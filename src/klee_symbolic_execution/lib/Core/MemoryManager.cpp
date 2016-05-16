//===-- MemoryManager.cpp -------------------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "Common.h"

#include "CoreStats.h"
#include "Memory.h"
#include "MemoryManager.h"

#include "klee/ExecutionState.h"
#include "klee/Expr.h"
#include "klee/Solver.h"

#include "llvm/Support/CommandLine.h"


using namespace klee;

/***/

MemoryManager::~MemoryManager() { 
  while (!objects.empty()) {
    MemoryObject *mo = *objects.begin();
    if (!mo->isFixed)
      free((void *)mo->address);
    objects.erase(mo);
    delete mo;
  }
}

MemoryObject *MemoryManager::allocate(uint64_t size, bool isLocal, 
                                      bool isGlobal,
                                      const llvm::Value *allocSite) {
  if (size>10*1024*1024)
    klee_warning_once(0, "Large alloc: %u bytes.  KLEE may run out of memory.", (unsigned) size);
  
  uint64_t address = (uint64_t) (unsigned long) malloc((unsigned) size);
  if (!address)
    return 0;
  
  ++stats::allocations;
  MemoryObject *res = new MemoryObject(address, size, isLocal, isGlobal, false,
                                       allocSite, this);
  objects.insert(res);
  return res;
}

MemoryObject *MemoryManager::allocateFixed(uint64_t address, uint64_t size,
                                           const llvm::Value *allocSite) {
#ifndef NDEBUG
  for (objects_ty::iterator it = objects.begin(), ie = objects.end();
       it != ie; ++it) {
    MemoryObject *mo = *it;
    if (address+size > mo->address && address < mo->address+mo->size)
      klee_error("Trying to allocate an overlapping object");
  }
#endif

  ++stats::allocations;
  MemoryObject *res = new MemoryObject(address, size, false, true, true,
                                       allocSite, this);
  objects.insert(res);
  return res;
}

void MemoryManager::deallocate(const MemoryObject *mo) {
  assert(0);
}

void MemoryManager::markFreed(MemoryObject *mo) {
  if (objects.find(mo) != objects.end())
  {
    if (!mo->isFixed)
      free((void *)mo->address);
    objects.erase(mo);
  }
}


// lyc modification
BufferObject * MemoryManager:: findBufferByAddr(uint64_t addr){
	BufferObject * bf = NULL;
	for(std::set<MemoryObject*> :: iterator it = objects.begin(); it != objects.end(); it++){
		uint64_t addr_start = (*it)->address;
		ref<ConstantExpr> sizeExpr = (*it)->getSizeExpr();
		uint64_t size = sizeExpr->getZExtValue();
		uint64_t addr_end = addr_start + size - 1;
		if(addr <= addr_end && addr >= addr_start) {
			bf = new BufferObject(*it);
			bf->setStartAddr(addr);
			bf->setSize(addr_end - addr + 1);
//			printf("Debug: findBufferByAddr: start address: %u, end address: %u, size: %u\n", (unsigned)addr, 
//			(unsigned)addr_end, (unsigned)size);
			return bf;
		}
	}
	return NULL;
}

// lyc modification
MemoryObject * MemoryManager:: findMemoryObjectByAddr(uint64_t addr) {
	for(std::set<MemoryObject*> :: iterator it = this->objects.begin(), end = this->objects.end(); 
		it != end; it++) {
		if(addr >= (*it)->address && addr < (*it)->address + (*it)->size)
			return (*it);
	}
	return NULL;
}
//gfj modification
MemoryObject * MemoryManager:: findMemoryObjectByName(std::string name) {
	for(std::set<MemoryObject*> :: iterator it = this->objects.begin(), end = this->objects.end();
		it != end; it++) {
		if((*it)->name == name)
			  return (*it);
	}
	return NULL;
}

