#pragma once

#include "net/TimeSortedSearcher.h"

namespace net {
  class LockStepInformationHandler; // pimpl
  class PacketCacheBase;

  class LockStepSearcher : public TimeSortedSearcher {
    private:
      PacketCacheBase* packetCache;
      Time const stepIncrement;
      LockStepInformationHandler& lsih;
    public:
      LockStepSearcher(PacketCacheBase*, Time stepIncrement = 1);
      ~LockStepSearcher();
      bool supportsPhonyPackets() const;
      BasicState* selectState();
      bool empty() const;
      void operator+=(BasicState*);
      void operator-=(BasicState*);
      Time getStateTime(BasicState*) const;
      void barrier(BasicState*);
  };
}

