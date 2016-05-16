#pragma once

#include "net/EventSearcher.h"
#include "net/Observer.h"

#include "net/util/SharedPtr.h"

#include <map>
#include <memory>

namespace net {
  class StateCluster;
  class MappingInformation;
  class SearcherStrategy;

  struct ClusterInformationHandler;
  class PacketCacheBase;

  /* The ClusterSearcher is an abstract meta searcher that uses
   * simpler low-level searchers (polymorphically) within one cluster.
   * The cluster itself is chosen by a cluster-selection-strategy.
   */
  class ClusterSearcher : public EventSearcher, public Observer<MappingInformation> {
    public:
      typedef util::SharedPtr<Searcher> SearcherP;
      typedef std::map<StateCluster*,SearcherP> InternalSearchers;
    private:
      std::auto_ptr<ClusterInformationHandler> cih;
      InternalSearchers internalSearchers;
      void clear();
      SearcherP of(BasicState*) const;
    protected:
      util::SharedPtr<SearcherStrategy> strategy;
      void notify(Observable<MappingInformation>*);
      void notifyNew(Observable<MappingInformation>*, Observable<MappingInformation> const*);
      void notifyDie(Observable<MappingInformation> const*);
      virtual SearcherP newInternalSearcher() = 0;
    public:
      explicit ClusterSearcher(util::SharedPtr<SearcherStrategy> strategy);
      virtual ~ClusterSearcher();
      bool empty() const;
      void operator+=(BasicState*);
      void operator-=(BasicState*);
      BasicState* selectState();
      Time getStateTime(BasicState*) const;
      void scheduleStateAt(BasicState*, Time, EventKind);
      void yieldState(BasicState*);
      void barrier(BasicState*);
  };

  template <typename S> struct InternalSearcherAlloc {
    Searcher* operator()(PacketCacheBase* pc) const {
      return new S(pc);
    }
  };
  template <typename S, typename SAllocator = InternalSearcherAlloc<S> > class GenericClusterSearcher : public ClusterSearcher {
    private:
      PacketCacheBase* pc;
      SAllocator salloc;
      SearcherP newInternalSearcher() {
        return SearcherP(salloc(pc));
      }
    public:
      GenericClusterSearcher(util::SharedPtr<SearcherStrategy> s, PacketCacheBase* pc, SAllocator salloc = SAllocator())
        : ClusterSearcher(s)
        , pc(pc)
        , salloc(salloc) {
      }
      ~GenericClusterSearcher() {
      }
      bool supportsPhonyPackets() const {
        return pc;
      }
  };
}

