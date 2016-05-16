#pragma once

#include "net/Observer.h"
#include "net/BasicState.h"

#include <set>

namespace net {
  class ClusterCounter_impl;
  class ClusterCounter : public Observable<ClusterCounter> {
    friend class ClusterCounter_impl;
    private:
      ClusterCounter_impl* const pimpl;
      ClusterCounter(ClusterCounter const&); // not implemented
      ClusterCounter& operator=(ClusterCounter const&); // not implemented
    public:
      explicit ClusterCounter(BasicState* root);
      ~ClusterCounter();
      std::set<unsigned> const& clusters;
  };
}
