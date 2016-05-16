#pragma once

#include "net/Node.h"

#include <map>
#include <list>

namespace net {
  class BasicState;

  class TimeEvent {
    private:
      typedef std::map<Node, std::list<BasicState*> > Table;
      Table scheduledNodes;

    public:
      TimeEvent();
      ~TimeEvent();

      BasicState* peakState();
      void popState();
      void pushBack(BasicState*);
      void removeState(BasicState*);
      bool empty() const;
      bool isNodeScheduled(Node node);
  };
}

