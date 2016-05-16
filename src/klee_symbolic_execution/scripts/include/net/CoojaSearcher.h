#pragma once

#include "net/EventSearcher.h"

#include "net/TimeEvent.h"

#include <map>

namespace net {
  class PacketCacheBase;
  class CoojaInformationHandler; // pimpl

  class CoojaSearcher : public EventSearcher {
    private:
      PacketCacheBase* packetCache;
      CoojaInformationHandler& cih;
      typedef std::map<Time, TimeEvent> CalQueue;
      CalQueue calQueue;
      bool removeState(BasicState*);
    public:
      CoojaSearcher(PacketCacheBase*);
      ~CoojaSearcher();
      bool supportsPhonyPackets() const;
      BasicState* selectState();
      bool empty() const;
      void operator+=(BasicState*);
      void operator-=(BasicState*);
      void scheduleStateAt(BasicState*, Time, EventKind);
      void yieldState(BasicState*);
      Time getStateTime(BasicState*) const;
  };
}

