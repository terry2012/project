#pragma once

#include "net/util/SharedPtr.h"
#include "net/util/Type.h"

namespace net {
  namespace util {
    template <typename T> class Monad;

    template <typename T> struct MonadInterface {
      friend class Monad<T>;
      protected:
        typedef typename Type<T>::Ref Ref;
        typedef typename Type<T>::ConstRef ConstRef;
        virtual ConstRef monad_read() const = 0;
        virtual void monad_write(ConstRef cr) = 0;
    };

    template <typename T> class Monad : public MonadInterface<T> {
      private:
        typedef SharedPtr<MonadInterface<T> > P;
        typedef typename MonadInterface<T>::ConstRef ConstRef;
        P code;
        ConstRef monad_read() const {
          return code->monad_read();
        }
        void monad_write(ConstRef cr) {
          code->monad_write(cr);
        }
      public:
        Monad(P mi) : code(mi) {}
        operator ConstRef() {
          return monad_read();
        }
        //operator typename Type<T>::Rigid() {
        //  return monad_read();
        //}
        Monad& operator=(ConstRef cr) {
          monad_write(cr);
          return *this;
        }
        bool operator==(ConstRef cr) const {
          return code->monad_read() == cr;
        }
        bool operator!=(ConstRef cr) const {
          return code->monad_read() != cr;
        }
    };

    template <typename T, typename Read, typename Write> class MonadWrapper : public MonadInterface<T> {
      private:
        typedef typename MonadInterface<T>::ConstRef ConstRef;
        Read read;
        Write write;
        MonadWrapper(Read read = Read(), Write write = Write()) : read(read), write(write) {}
        ConstRef monad_read() const {
          return read();
        }
        void monad_write(ConstRef cr) {
          write(cr);
        }
      public:
        static Monad<T> make(Write write = Write(), Read read = Read()) {
          return Monad<T>(SharedPtr<MonadInterface<T> >(new MonadWrapper<T,Write,Read>(write,read)));
        }
    };

    template <typename T, typename Read, typename Write> Monad<T> makeMonadWrapper(Read read = Read(), Write write = Write()) {
      return MonadWrapper<T,Read,Write>::make(read,write);
    }
  }
}
