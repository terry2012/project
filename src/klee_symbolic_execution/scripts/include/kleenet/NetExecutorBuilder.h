//===-- Interpreter.h - Abstract Execution Engine Interface -----*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//===----------------------------------------------------------------------===//

#pragma once

#include "klee/Interpreter.h"

namespace kleenet {
  class InterpreterHandler;

  struct NetExecutorBuilder {
    private:
      NetExecutorBuilder(); // prevent anybody from instantiating, let alone deriving from us
    public:
      static klee::Interpreter* create(klee::Interpreter::InterpreterOptions const&, InterpreterHandler*);
  };
}

