#pragma once

#include "net/Searcher.h"

#include "Time.h"

/* A time sorted searcher is a searcher that has some knowledge of time and
 * will execute its states always in a time consistent manner.
 * This is more of a design hint than something that we can enforce, but
 * if you implement a TimeSortedSearcher, you are responsible for
 *   1) call updateLowerBound whenever you select a state
 *   2) never select a state that has a time < lowerBound
 * For instance, every event-search is a time-sorted searcher.
 */

namespace net {
  class BasicState;

  class TimeSortedSearcher : public Searcher {
    private:
      Time lastLowerBound;
    protected:
      TimeSortedSearcher();
      void updateLowerBound(Time);
    public:
      Time lowerBound() const; //final
  };
}

