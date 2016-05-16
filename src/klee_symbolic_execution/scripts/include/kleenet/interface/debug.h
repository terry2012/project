//===-- debug.h -------------------------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

// This file does not live in include/kleenet because it is the user includable
// special function header.

#pragma once

#ifdef __cplusplus
extern "C" {
#endif

  /// debug constraints dumping
  void kleenet_dump_constraints(void);

#ifdef __cplusplus
}
#endif
