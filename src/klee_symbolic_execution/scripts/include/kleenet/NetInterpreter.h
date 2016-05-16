//===-- Interpreter.h - Abstract Execution Engine Interface -----*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//===----------------------------------------------------------------------===//

#pragma once

#include "klee/Interpreter.h"
#include <set>

namespace kleenet {
  class InterpreterHandler : public klee::InterpreterHandler {
    public:
      virtual void incDScenariosExplored() = 0;
      virtual void incClustersExplored() = 0;
      virtual void updateKnownRedundantMappings(size_t) = 0;
      virtual void logClusterChange(std::set<unsigned> const&) = 0;
  };
  // NOTE: inheriting from klee::Interpreter is dangerous. Don't do it!
  // rationale: kleenet::Executor isA klee::Executor isA klee::Interpreter
  // if you create kleenet::Interpreter isA klee::Interpreter, it will not be a base class of kleenet::Executor!
}

