#pragma once

namespace net {
  class StateCluster;

  class SearcherStrategy {
    public:
      virtual ~SearcherStrategy() {}
      virtual StateCluster* selectCluster() = 0;
      virtual SearcherStrategy& operator+=(StateCluster*) = 0;
      virtual SearcherStrategy& operator-=(StateCluster*) = 0;
  };

}

