//===-- Searcher.h ----------------------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#pragma once

#include "klee_headers/Searcher.h"
#include "net/Time.h"

#include <set>
#include <memory>

namespace net {
  class Searcher;
}

namespace kleenet {
  class KleeNet;
  class State;

  class Searcher : public klee::Searcher {
    private:
      std::auto_ptr<net::Searcher> ns;
    public:
      Searcher(KleeNet&, std::auto_ptr<net::Searcher> ns);
      ~Searcher();
      net::Searcher* netSearcher() const;
      net::Time getStateTime(State*) const;
      net::Time getStateTime(State&) const;
    public: // interface to klee::Searcher
      klee::ExecutionState& selectState();
      void update(klee::ExecutionState*, std::set<klee::ExecutionState*> const&, std::set<klee::ExecutionState*> const&);
      bool empty();
  };

}

