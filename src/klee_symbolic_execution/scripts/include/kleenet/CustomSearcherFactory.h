#pragma once

#include <stddef.h>

#include <memory>
#include <assert.h>

#include "kleenet/Searcher.h"

namespace klee {
  class Struct;
}

namespace net {
  class PacketCacheBase;
  class Searcher;
}

namespace kleenet {
  class KleeNet;
  class Searcher;
  struct FactoryContainer;

  class CustomSearcherFactory {
    public:
      enum Precedence {
        CSFP_OVERRIDE_LEGACY, // take precedence before the default KLEE Searcher Factory
        CSFP_AMEND_LEGACY // is only invoked if the default KLEE Searcher Factory is clueless
      };
    private:
      static FactoryContainer& fetchContainer();
    protected:
      static void registerFactory(Precedence precedence, CustomSearcherFactory* factory);
      static void unregisterFactory(CustomSearcherFactory* factory);
      // return NULL if you don't know which Searcher to create
      virtual Searcher* createSearcher(KleeNet&, net::PacketCacheBase*) = 0;
    public:
      static Searcher* attemptConstruction(Precedence, KleeNet&, net::PacketCacheBase*);
  };

  template <typename S, bool autoNew> struct AutoNewSearcher {
    static S* tryNew(net::PacketCacheBase* pcb) {
      assert(autoNew);
      return new S(pcb);
    }
  };
  template <typename S> struct AutoNewSearcher<S,false> {
    static S* tryNew(net::PacketCacheBase* pcb) {
      assert(0);
      return NULL;
    }
  };

  // Condition is typically set to cl::opt<bool> but we don't want to set this as default.
  // It must be castable to bool.
  template <typename S, typename Condition, bool autoNew = true> class CustomSearcherAutoFactory : public CustomSearcherFactory {
    private:
      Condition& condition;
    protected:
      virtual net::Searcher* newSearcher(net::PacketCacheBase* pcb) {
        return AutoNewSearcher<S,autoNew>::tryNew(pcb);
      }
      Searcher* createSearcher(KleeNet& kn, net::PacketCacheBase* pcb) {
        if (condition) {
          net::Searcher* const ns = newSearcher(pcb);
          if (ns) {
            return new Searcher(kn,std::auto_ptr<net::Searcher>(ns));
          }
        }
        return NULL;
      }
    public:
      typedef CustomSearcherAutoFactory CSAF;
      CustomSearcherAutoFactory(Condition& condition, Precedence precedence)
        : condition(condition) {
        registerFactory(precedence,this);
      }
      ~CustomSearcherAutoFactory() {
        unregisterFactory(this);
      }
  };
}

