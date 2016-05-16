//===-- PersistentStateData.h -----------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#pragma once

#include "net/Node.h"

namespace kleenet {

  // This should be kept POD.
  // It's a member of State that tracks extra information that is
  //   needed outside.
  struct PersistentStateData {
    net::Node node;
  };

}
