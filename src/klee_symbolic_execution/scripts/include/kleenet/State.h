//===-- State.h -------------------------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#pragma once

#include "net/BasicState.h"
#include <string>

#include "PersistentStateData.h"

namespace klee {
  class ExecutionState;
  class Array;
}

namespace kleenet {
  class KleeNet;
  class Executor;
  class State;

  class ConfigurationData;
  struct ConfigurationDataBase { // used to figure out how to handle transmissions
    virtual ~ConfigurationDataBase() {}
    virtual ConfigurationData& self() = 0;
    virtual ConfigurationDataBase* fork(State*) const {
      return 0;
    }
    static ConfigurationDataBase* attemptFork(ConfigurationDataBase* from, State* state) {
      if (from)
        return from->fork(state);
      return 0;
    }
  };

  class State : public net::BasicState {
    friend class RegisterChildDependant;
    friend class KleeNet;
    private:
      Executor* executor;
    public:
      PersistentStateData persistent;
      ConfigurationDataBase* configurationData;
      State()
        : net::BasicState(), executor(0), persistent(), configurationData(0) {}
      State(State const& from)
        : net::BasicState(from)
        , executor(from.executor)
        , persistent(from.persistent)
        , configurationData(ConfigurationDataBase::attemptFork(from.configurationData,this)) {}
      ~State() {
        if (configurationData)
          delete configurationData;
      }
      virtual State* branch() = 0;
      State* forceFork();
      klee::Array const* makeNewSymbol(std::string, size_t);
      bool transferConstraints(State&);
      Executor* getExecutor() const;
      klee::ExecutionState const* executionState() const;
      klee::ExecutionState* executionState();
  };
}

