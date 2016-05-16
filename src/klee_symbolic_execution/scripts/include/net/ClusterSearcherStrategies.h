#pragma once

#include "net/ClusterSearcherStrategy.h"

#include "net/util/SharedPtr.h"

#include <set>
#include <map>
#include <vector>
#include <list>

namespace net {
  class StateCluster;

  // strategy that always selects the last cluster, until it dies
  // default!
  struct NullStrategy : public SearcherStrategy {
    private:
      std::list<StateCluster*> clusters;
    public:
      StateCluster* selectCluster();
      NullStrategy& operator+=(StateCluster* c);
      NullStrategy& operator-=(StateCluster* c);
  };

  // strategy that selects clusters in a fifo manner
  struct FifoStrategy : public SearcherStrategy {
    private:
      std::set<StateCluster*> clusters;
      std::set<StateCluster*>::iterator current;
    public:
      FifoStrategy();
      FifoStrategy(FifoStrategy const& from);
      StateCluster* selectCluster();
      FifoStrategy& operator+=(StateCluster* c);
      FifoStrategy& operator-=(StateCluster* c);
  };

  // strategy that always selects the next cluster randomly
  // Note: no fairness guarantee is given at all.
  struct RandomStrategy : public SearcherStrategy {
    private:
      std::vector<StateCluster*> clusterLookUp;
      std::map<StateCluster*,unsigned> clusters;
    protected:
      virtual unsigned prng(unsigned size) const = 0;
    public:
      StateCluster* selectCluster();
      RandomStrategy& operator+=(StateCluster* c);
      RandomStrategy& operator-=(StateCluster* c);
  };

  // strategy that "mangles" several strategies, executing each a fixed number of times
  // and then choosing the next strategy in a fifo manner.
  class MangleStrategy : public SearcherStrategy {
    private:
      typedef std::vector<std::pair<util::SharedPtr<SearcherStrategy>,unsigned> > Components;
      Components const components;
      Components::const_iterator current;
      unsigned remaining;
    public:
      explicit MangleStrategy(Components const& components);
      MangleStrategy(MangleStrategy const& from);
      StateCluster* selectCluster();
      MangleStrategy& operator+=(StateCluster* c);
      MangleStrategy& operator-=(StateCluster* c);
  };

  // strategy that keeps buffers the selected cluster for a number of times
  // this is DIFFERENT from using the mangle strategy with one sub-strategy!
  class RepeatStrategy : public SearcherStrategy {
    private:
      util::SharedPtr<SearcherStrategy> const s;
      unsigned const repeat;
      StateCluster* current;
      unsigned streak;
    public:
      explicit RepeatStrategy(util::SharedPtr<SearcherStrategy> s, unsigned repeat);
      RepeatStrategy(RepeatStrategy const& from);
      StateCluster* selectCluster();
      RepeatStrategy& operator+=(StateCluster* c);
      RepeatStrategy& operator-=(StateCluster* c);
  };
}


