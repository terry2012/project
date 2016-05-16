#pragma once

namespace net {
  namespace util {
    template <typename T>
    struct DynamicFunctor {
      virtual void operator()(T) const = 0;
      virtual ~DynamicFunctor() {}
    };
    template <typename T>
    struct StaticFunctor {
    };

    template <typename T, typename F>
    struct CallOperator {
      CallOperator(F& f, T t) {
        f(t);
      }
    };
    template <typename T, typename F>
    struct IterateOperator {
      IterateOperator(F& f, T t) {
        *f++ = t;
      }
    };

    template <typename T = void, typename F = void, template <typename _T> class FunctorKind = StaticFunctor, template <typename _T, typename _F> class Operator = CallOperator>
    struct Functor : FunctorKind<T> {
      mutable F f;
      Functor(F f) : f(f) {}
      Functor() : f() {}
      void operator()(T arg) const {
        Operator<T,F>(f,arg);
      }
    };
    template <>
    struct Functor<void,void> {
      template <typename U>
      void operator()(U) {}
    };
    template <typename T, template <typename _T> class FunctorKind = StaticFunctor, template <typename _T, typename _F> class Operator = CallOperator>
    struct FunctorBuilder {
      template <typename F>
      static Functor<T,F,FunctorKind,Operator> build(F f) {
        return Functor<T,F,FunctorKind,Operator>(f);
      }
      private:
        FunctorBuilder(); // I'm shy, don't construct me
    };
  }
}
