//===-- MemoryManager.h -----------------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef KLEE_MEMORYMANAGER_H
#define KLEE_MEMORYMANAGER_H

#include <set>
#include <stdint.h>
#include <Memory.h>

namespace llvm {
  class Value;
}

namespace klee {
  class MemoryObject;

  class MemoryManager {
  private:
    typedef std::set<MemoryObject*> objects_ty;
    objects_ty objects;

  public:
    MemoryManager() {}
    ~MemoryManager();

    MemoryObject *allocate(uint64_t size, bool isLocal, bool isGlobal,
                           const llvm::Value *allocSite);
    MemoryObject *allocateFixed(uint64_t address, uint64_t size,
                                const llvm::Value *allocSite);
    void deallocate(const MemoryObject *mo);
    void markFreed(MemoryObject *mo);

    // lyc modification
    // findBufferByAddr added, to obtain a BufferObject
    BufferObject * findBufferByAddr(uint64_t addr);

    // lyc modification
    // findMemoryObjectByAddr, returns the reference to the MemoryObject specified by the address(
    // the address may within the MemoryBlock)
    MemoryObject * findMemoryObjectByAddr(uint64_t addr);
    //gfj modification
    MemoryObject * findMemoryObjectByName(std::string name);
  };

} // End klee namespace

#endif

