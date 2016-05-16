#pragma once

#include "net/Iterator.h"
#include "net/Time.h"

namespace net {
  class BasicState;
  class EventSearcher;

  class Searcher {
    public:
      virtual ~Searcher();
      virtual bool supportsPhonyPackets() const = 0;
      virtual BasicState* selectState() = 0;
      virtual bool empty() const = 0;
      /*final*/ void add(ConstIteratable<BasicState*> const&, ConstIteratable<BasicState*> const&);
      /*final*/ void remove(ConstIteratable<BasicState*> const&, ConstIteratable<BasicState*> const&);
      virtual Time getStateTime(BasicState*) const = 0;
      virtual EventSearcher* toEventSearcher(); // custom conversion
      virtual void barrier(BasicState*);
    private:
      virtual void operator+=(BasicState*) = 0;
      virtual void operator-=(BasicState*) = 0;
  };
}

