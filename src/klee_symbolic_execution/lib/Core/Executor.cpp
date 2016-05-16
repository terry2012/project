//===-- Executor.cpp ------------------------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//----bty------user-defined-header-files--------------
#include "GuideExecutionInfo.h"
//--------------------------
//lyc modification
#include <set>
//lyc modification

#include "Common.h"

#include "Executor.h"
 
#include "Context.h"
#include "CoreStats.h"
#include "ExternalDispatcher.h"
#include "ImpliedValue.h"
#include "Memory.h"
#include "MemoryManager.h"
#include "PTree.h"
#include "Searcher.h"
#include "SeedInfo.h"
#include "SpecialFunctionHandler.h"
#include "StatsTracker.h"
#include "TimingSolver.h"
#include "UserSearcher.h"
#include "../Solver/SolverStats.h"

#include "klee/ExecutionState.h"
#include "klee/Expr.h"
#include "klee/Interpreter.h"
#include "klee/TimerStatIncrementer.h"
#include "klee/CommandLine.h"
#include "klee/Common.h"
#include "klee/util/Assignment.h"
#include "klee/util/ExprPPrinter.h"
#include "klee/util/ExprSMTLIBLetPrinter.h"
#include "klee/util/ExprUtil.h"
#include "klee/util/ExprVisitor.h"
#include "klee/util/GetElementPtrTypeIterator.h"
#include "klee/Config/Version.h"
#include "klee/Internal/ADT/KTest.h"
#include "klee/Internal/ADT/RNG.h"
#include "klee/Internal/Module/Cell.h"
#include "klee/Internal/Module/InstructionInfoTable.h"
#include "klee/Internal/Module/KInstruction.h"
#include "klee/Internal/Module/KModule.h"
#include "klee/Internal/Support/FloatEvaluation.h"
#include "klee/Internal/System/Time.h"

#include "llvm/Attributes.h"
#include "llvm/BasicBlock.h"
#include "llvm/Constants.h"
#include "llvm/Function.h"
#include "llvm/Instructions.h"
#include "llvm/IntrinsicInst.h"
#if LLVM_VERSION_CODE >= LLVM_VERSION(2, 7)
#include "llvm/LLVMContext.h"
#endif
#include "llvm/Module.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/Support/CallSite.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"
#if LLVM_VERSION_CODE < LLVM_VERSION(2, 9)
#include "llvm/System/Process.h"
#else
#include "llvm/Support/Process.h"
#endif
#if LLVM_VERSION_CODE <= LLVM_VERSION(3, 1)
#include "llvm/Target/TargetData.h"
#else
#include "llvm/DataLayout.h"
#endif

#include <cassert>
#include <algorithm>
#include <iostream>
#include <iomanip>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>

#include <sys/mman.h>

#include <errno.h>
#include <cxxabi.h>

//gfj modification
static bool Haschecklist_fileNames = false;
//#include <stdarg.h>
//#include <stdio.h>
//#include "/home/gfj/guided-symbolic-execution/validate_buffer_overflow/klee/runtime/POSIX/fd.h"
//#include "/home/gfj/guided-symbolic-execution/validate_buffer_overflow/klee/runtime/POSIX/fd_init.c"
//gfj end
using namespace llvm;
using namespace klee;
//---bty--determine start guide searcher or not---
extern bool GuidedExecutionTag;
extern std::vector<GuideProfile> GuideSrcInfoByKlee;
//------------
//gfj modification
//extern exe_file_system_t __exe_fs;
//extern "C" exe_sym_env_t __exe_env;
//gfj end
/****************************
 * lyc modification
 * *************************/

//extern bool GuidedExecution;
static bool HasCheckListFile = false;
/****** lyc modification end */
namespace {
  cl::opt<bool>
  DumpStatesOnHalt("dump-states-on-halt",
                   cl::init(true),
		   cl::desc("Dump test cases for all active states on exit (default=on)"));
 
  cl::opt<bool>
  NoPreferCex("no-prefer-cex",
              cl::init(false));
 
  cl::opt<bool>
  UseAsmAddresses("use-asm-addresses",
                  cl::init(false));
 
  cl::opt<bool>
  RandomizeFork("randomize-fork",
                cl::init(false),
		cl::desc("Randomly swap the true and false states on a fork (default=off)"));
 
  cl::opt<bool>
  AllowExternalSymCalls("allow-external-sym-calls",
                        cl::init(false),
			cl::desc("Allow calls with symbolic arguments to external functions.  This concretizes the symbolic arguments.  (default=off)"));

  cl::opt<bool>
  DebugPrintInstructions("debug-print-instructions", 
                         cl::desc("Print instructions during execution."));

  cl::opt<bool>
  DebugCheckForImpliedValues("debug-check-for-implied-values");


  cl::opt<bool>
  SimplifySymIndices("simplify-sym-indices",
                     cl::init(false));

  cl::opt<unsigned>
  MaxSymArraySize("max-sym-array-size",
                  cl::init(0));

  cl::opt<bool>
  DebugValidateSolver("debug-validate-solver",
		      cl::init(false));

  cl::opt<bool>
  SuppressExternalWarnings("suppress-external-warnings");

  cl::opt<bool>
  AllExternalWarnings("all-external-warnings");

  cl::opt<bool>
  OnlyOutputStatesCoveringNew("only-output-states-covering-new",
                              cl::init(false),
			      cl::desc("Only output test cases covering new code."));

  cl::opt<bool>
  EmitAllErrors("emit-all-errors",
                cl::init(false),
                cl::desc("Generate tests cases for all errors "
                         "(default=off, i.e. one per (error,instruction) pair)"));
  
  cl::opt<bool>
  NoExternals("no-externals", 
           cl::desc("Do not allow external function calls (default=off)"));

  cl::opt<bool>
  AlwaysOutputSeeds("always-output-seeds",
		    cl::init(true));

  cl::opt<bool>
  OnlyReplaySeeds("only-replay-seeds", 
                  cl::desc("Discard states that do not have a seed."));
 
  cl::opt<bool>
  OnlySeed("only-seed", 
           cl::desc("Stop execution after seeding is done without doing regular search."));
 
  cl::opt<bool>
  AllowSeedExtension("allow-seed-extension", 
                     cl::desc("Allow extra (unbound) values to become symbolic during seeding."));
 
  cl::opt<bool>
  ZeroSeedExtension("zero-seed-extension");
 
  cl::opt<bool>
  AllowSeedTruncation("allow-seed-truncation", 
                      cl::desc("Allow smaller buffers than in seeds."));
 
  cl::opt<bool>
  NamedSeedMatching("named-seed-matching",
                    cl::desc("Use names to match symbolic objects to inputs."));

  cl::opt<double>
  MaxStaticForkPct("max-static-fork-pct", cl::init(1.));
  cl::opt<double>
  MaxStaticSolvePct("max-static-solve-pct", cl::init(1.));
  cl::opt<double>
  MaxStaticCPForkPct("max-static-cpfork-pct", cl::init(1.));
  cl::opt<double>
  MaxStaticCPSolvePct("max-static-cpsolve-pct", cl::init(1.));

  cl::opt<double>
  MaxInstructionTime("max-instruction-time",
                     cl::desc("Only allow a single instruction to take this much time (default=0s (off)). Enables --use-forked-stp"),
                     cl::init(0));
  
  cl::opt<double>
  SeedTime("seed-time",
           cl::desc("Amount of time to dedicate to seeds, before normal search (default=0 (off))"),
           cl::init(0));
  
  cl::opt<double>
  MaxSTPTime("max-stp-time",
             cl::desc("Maximum amount of time for a single query (default=0s (off)). Enables --use-forked-stp"),
             cl::init(0.0));
  
  cl::opt<unsigned int>
  StopAfterNInstructions("stop-after-n-instructions",
                         cl::desc("Stop execution after specified number of instructions (default=0 (off))"),
                         cl::init(0));
  
  cl::opt<unsigned>
  MaxForks("max-forks",
           cl::desc("Only fork this many times (default=-1 (off))"),
           cl::init(~0u));
  
  cl::opt<unsigned>
  MaxDepth("max-depth",
           cl::desc("Only allow this many symbolic branches (default=0 (off))"),
           cl::init(0));
  
  cl::opt<unsigned>
  MaxMemory("max-memory",
            cl::desc("Refuse to fork when above this amount of memory (in MB, default=2000)"),
            cl::init(2000));

  cl::opt<bool>
  MaxMemoryInhibit("max-memory-inhibit",
            cl::desc("Inhibit forking at memory cap (vs. random terminate) (default=on)"),
            cl::init(true));

  cl::opt<bool>
  UseForkedSTP("use-forked-stp",
	       cl::desc("Run STP in a forked process (default=off)"));

  cl::opt<bool>
  STPOptimizeDivides("stp-optimize-divides", 
                 cl::desc("Optimize constant divides into add/shift/multiplies before passing to STP (default=on)"),
                 cl::init(true));

}


namespace klee {
  RNG theRNG;
}

Solver *constructSolverChain(STPSolver *stpSolver,
                             std::string querySMT2LogPath,
                             std::string baseSolverQuerySMT2LogPath,
                             std::string queryPCLogPath,
                             std::string baseSolverQueryPCLogPath) {
  Solver *solver = stpSolver;

  if (optionIsSet(queryLoggingOptions,SOLVER_PC))
  {
    solver = createPCLoggingSolver(solver, 
                                   baseSolverQueryPCLogPath,
		                   MinQueryTimeToLog);
    klee_message("Logging queries that reach solver in .pc format to %s",baseSolverQueryPCLogPath.c_str());
  }

  if (optionIsSet(queryLoggingOptions,SOLVER_SMTLIB))
  {
    solver = createSMTLIBLoggingSolver(solver,baseSolverQuerySMT2LogPath,
                                       MinQueryTimeToLog);
    klee_message("Logging queries that reach solver in .smt2 format to %s",baseSolverQuerySMT2LogPath.c_str());
  }

  if (UseFastCexSolver)
    solver = createFastCexSolver(solver);

  if (UseCexCache)
    solver = createCexCachingSolver(solver);

  if (UseCache)
    solver = createCachingSolver(solver);

  if (UseIndependentSolver)
    solver = createIndependentSolver(solver);

  if (DebugValidateSolver)
    solver = createValidatingSolver(solver, stpSolver);

  if (optionIsSet(queryLoggingOptions,ALL_PC))
  {
    solver = createPCLoggingSolver(solver, 
                                   queryPCLogPath,
                                   MinQueryTimeToLog);
    klee_message("Logging all queries in .pc format to %s",queryPCLogPath.c_str());
  }
  
  if (optionIsSet(queryLoggingOptions,ALL_SMTLIB))
  {
    solver = createSMTLIBLoggingSolver(solver,querySMT2LogPath,
                                       MinQueryTimeToLog);
    klee_message("Logging all queries in .smt2 format to %s",querySMT2LogPath.c_str());
  }

  return solver;
}

Executor::Executor(const InterpreterOptions &opts,
                   InterpreterHandler *ih) 
  : Interpreter(opts),
    kmodule(0),
    interpreterHandler(ih),
    searcher(0),
    externalDispatcher(new ExternalDispatcher()),
    statsTracker(0),
    pathWriter(0),
    symPathWriter(0),
    specialFunctionHandler(0),
    processTree(0),
    replayOut(0),
    replayPath(0),    
    usingSeeds(0),
    atMemoryLimit(false),
    inhibitForking(false),
    haltExecution(false),
    ivcEnabled(false),
    stpTimeout(MaxSTPTime != 0 && MaxInstructionTime != 0
      ? std::min(MaxSTPTime,MaxInstructionTime)
      : std::max(MaxSTPTime,MaxInstructionTime)) {
  if (stpTimeout) UseForkedSTP = true;
  STPSolver *stpSolver = new STPSolver(UseForkedSTP, STPOptimizeDivides);
  Solver *solver = 
    constructSolverChain(stpSolver,
                         interpreterHandler->getOutputFilename(ALL_QUERIES_SMT2_FILE_NAME),
                         interpreterHandler->getOutputFilename(SOLVER_QUERIES_SMT2_FILE_NAME),
                         interpreterHandler->getOutputFilename(ALL_QUERIES_PC_FILE_NAME),
                         interpreterHandler->getOutputFilename(SOLVER_QUERIES_PC_FILE_NAME));
  
  this->solver = new TimingSolver(solver, stpSolver);

  memory = new MemoryManager();

  // lyc modification
  loadCheckFiles();
  if(GuidedExecutionTag)loadCheckList();
}


const Module *Executor::setModule(llvm::Module *module, 
                                  const ModuleOptions &opts) {
  assert(!kmodule && module && "can only register one module"); // XXX gross
  
  kmodule = new KModule(module);

  // Initialize the context.
#if LLVM_VERSION_CODE <= LLVM_VERSION(3, 1)
  TargetData *TD = kmodule->targetData;
#else
  DataLayout *TD = kmodule->targetData;
#endif
  Context::initialize(TD->isLittleEndian(),
                      (Expr::Width) TD->getPointerSizeInBits());

  specialFunctionHandler = new SpecialFunctionHandler(*this);

  specialFunctionHandler->prepare();
  kmodule->prepare(opts, interpreterHandler);
  specialFunctionHandler->bind();

  if (StatsTracker::useStatistics()) {
    statsTracker = 
      new StatsTracker(*this,
                       interpreterHandler->getOutputFilename("assembly.ll"),
                       userSearcherRequiresMD2U());
  }
  
  return module;
}

Executor::~Executor() {
  delete memory;
  delete externalDispatcher;
  if (processTree)
    delete processTree;
  if (specialFunctionHandler)
    delete specialFunctionHandler;
  if (statsTracker)
    delete statsTracker;
  delete solver;
  delete kmodule;
}

/***/

void Executor::initializeGlobalObject(ExecutionState &state, ObjectState *os,
                                      const Constant *c, 
                                      unsigned offset) {
#if LLVM_VERSION_CODE <= LLVM_VERSION(3, 1)
  TargetData *targetData = kmodule->targetData;
#else
  DataLayout *targetData = kmodule->targetData;
#endif
  if (const ConstantVector *cp = dyn_cast<ConstantVector>(c)) {
    unsigned elementSize =
      targetData->getTypeStoreSize(cp->getType()->getElementType());
    for (unsigned i=0, e=cp->getNumOperands(); i != e; ++i)
      initializeGlobalObject(state, os, cp->getOperand(i), 
			     offset + i*elementSize);
  } else if (isa<ConstantAggregateZero>(c)) {
    unsigned i, size = targetData->getTypeStoreSize(c->getType());
    for (i=0; i<size; i++)
      os->write8(offset+i, (uint8_t) 0);
  } else if (const ConstantArray *ca = dyn_cast<ConstantArray>(c)) {
    unsigned elementSize =
      targetData->getTypeStoreSize(ca->getType()->getElementType());
    for (unsigned i=0, e=ca->getNumOperands(); i != e; ++i)
      initializeGlobalObject(state, os, ca->getOperand(i), 
			     offset + i*elementSize);
  } else if (const ConstantStruct *cs = dyn_cast<ConstantStruct>(c)) {
    const StructLayout *sl =
      targetData->getStructLayout(cast<StructType>(cs->getType()));
    for (unsigned i=0, e=cs->getNumOperands(); i != e; ++i)
      initializeGlobalObject(state, os, cs->getOperand(i), 
			     offset + sl->getElementOffset(i));
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 1)
  } else if (const ConstantDataSequential *cds =
               dyn_cast<ConstantDataSequential>(c)) {
    unsigned elementSize =
      targetData->getTypeStoreSize(cds->getElementType());
    for (unsigned i=0, e=cds->getNumElements(); i != e; ++i)
      initializeGlobalObject(state, os, cds->getElementAsConstant(i),
                             offset + i*elementSize);
#endif
  } else {
    unsigned StoreBits = targetData->getTypeStoreSizeInBits(c->getType());
    ref<ConstantExpr> C = evalConstant(c);

    // Extend the constant if necessary;
    assert(StoreBits >= C->getWidth() && "Invalid store size!");
    if (StoreBits > C->getWidth())
      C = C->ZExt(StoreBits);

    os->write(offset, C);
  }
}

MemoryObject * Executor::addExternalObject(ExecutionState &state, 
                                           void *addr, unsigned size, 
                                           bool isReadOnly) {
  MemoryObject *mo = memory->allocateFixed((uint64_t) (unsigned long) addr, 
                                           size, 0);
  ObjectState *os = bindObjectInState(state, mo, false);
  for(unsigned i = 0; i < size; i++)
    os->write8(i, ((uint8_t*)addr)[i]);
  if(isReadOnly)
    os->setReadOnly(true);  
  return mo;
}


extern void *__dso_handle __attribute__ ((__weak__));

void Executor::initializeGlobals(ExecutionState &state) {
  Module *m = kmodule->module;

  if (m->getModuleInlineAsm() != "")
    klee_warning("executable has module level assembly (ignoring)");

  assert(m->lib_begin() == m->lib_end() &&
         "XXX do not support dependent libraries");

  // represent function globals using the address of the actual llvm function
  // object. given that we use malloc to allocate memory in states this also
  // ensures that we won't conflict. we don't need to allocate a memory object
  // since reading/writing via a function pointer is unsupported anyway.
  for (Module::iterator i = m->begin(), ie = m->end(); i != ie; ++i) {
    Function *f = i;
    ref<ConstantExpr> addr(0);

    // If the symbol has external weak linkage then it is implicitly
    // not defined in this module; if it isn't resolvable then it
    // should be null.
    if (f->hasExternalWeakLinkage() && 
        !externalDispatcher->resolveSymbol(f->getName())) {
      addr = Expr::createPointer(0);
    } else {
      addr = Expr::createPointer((unsigned long) (void*) f);
      legalFunctions.insert((uint64_t) (unsigned long) (void*) f);
    }
    
    globalAddresses.insert(std::make_pair(f, addr));
  }

  // Disabled, we don't want to promote use of live externals.
#ifdef HAVE_CTYPE_EXTERNALS
#ifndef WINDOWS
#ifndef DARWIN
  /* From /usr/include/errno.h: it [errno] is a per-thread variable. */
  int *errno_addr = __errno_location();
  addExternalObject(state, (void *)errno_addr, sizeof *errno_addr, false);

  /* from /usr/include/ctype.h:
       These point into arrays of 384, so they can be indexed by any `unsigned
       char' value [0,255]; by EOF (-1); or by any `signed char' value
       [-128,-1).  ISO C requires that the ctype functions work for `unsigned */
  const uint16_t **addr = __ctype_b_loc();
  addExternalObject(state, (void *)(*addr-128), 
                    384 * sizeof **addr, true);
  addExternalObject(state, addr, sizeof(*addr), true);
    
  const int32_t **lower_addr = __ctype_tolower_loc();
  addExternalObject(state, (void *)(*lower_addr-128), 
                    384 * sizeof **lower_addr, true);
  addExternalObject(state, lower_addr, sizeof(*lower_addr), true);
  
  const int32_t **upper_addr = __ctype_toupper_loc();
  addExternalObject(state, (void *)(*upper_addr-128), 
                    384 * sizeof **upper_addr, true);
  addExternalObject(state, upper_addr, sizeof(*upper_addr), true);
#endif
#endif
#endif

  // allocate and initialize globals, done in two passes since we may
  // need address of a global in order to initialize some other one.

  // allocate memory objects for all globals
  for (Module::const_global_iterator i = m->global_begin(),
         e = m->global_end();
       i != e; ++i) {
    if (i->isDeclaration()) {
      // FIXME: We have no general way of handling unknown external
      // symbols. If we really cared about making external stuff work
      // better we could support user definition, or use the EXE style
      // hack where we check the object file information.

      LLVM_TYPE_Q Type *ty = i->getType()->getElementType();
      uint64_t size = kmodule->targetData->getTypeStoreSize(ty);

      // XXX - DWD - hardcode some things until we decide how to fix.
#ifndef WINDOWS
      if (i->getName() == "_ZTVN10__cxxabiv117__class_type_infoE") {
        size = 0x2C;
      } else if (i->getName() == "_ZTVN10__cxxabiv120__si_class_type_infoE") {
        size = 0x2C;
      } else if (i->getName() == "_ZTVN10__cxxabiv121__vmi_class_type_infoE") {
        size = 0x2C;
      }
#endif

      if (size == 0) {
        llvm::errs() << "Unable to find size for global variable: " 
                     << i->getName() 
                     << " (use will result in out of bounds access)\n";
      }

      MemoryObject *mo = memory->allocate(size, false, true, i);
      ObjectState *os = bindObjectInState(state, mo, false);
      globalObjects.insert(std::make_pair(i, mo));
      globalAddresses.insert(std::make_pair(i, mo->getBaseExpr()));

      // Program already running = object already initialized.  Read
      // concrete value and write it to our copy.
      if (size) {
        void *addr;
        if (i->getName() == "__dso_handle") {
          addr = &__dso_handle; // wtf ?
        } else {
          addr = externalDispatcher->resolveSymbol(i->getName());
        }
        if (!addr)
          klee_error("unable to load symbol(%s) while initializing globals.", 
                     i->getName().data());

        for (unsigned offset=0; offset<mo->size; offset++)
          os->write8(offset, ((unsigned char*)addr)[offset]);
      }
    } else {
      LLVM_TYPE_Q Type *ty = i->getType()->getElementType();
      uint64_t size = kmodule->targetData->getTypeStoreSize(ty);
      MemoryObject *mo = 0;

      if (UseAsmAddresses && i->getName()[0]=='\01') {
        char *end;
        uint64_t address = ::strtoll(i->getName().str().c_str()+1, &end, 0);

        if (end && *end == '\0') {
          klee_message("NOTE: allocated global at asm specified address: %#08llx"
                       " (%llu bytes)",
                       (long long) address, (unsigned long long) size);
          mo = memory->allocateFixed(address, size, &*i);
          mo->isUserSpecified = true; // XXX hack;
        }
      }

      if (!mo)
        mo = memory->allocate(size, false, true, &*i);
      assert(mo && "out of memory");
      ObjectState *os = bindObjectInState(state, mo, false);
      globalObjects.insert(std::make_pair(i, mo));
      globalAddresses.insert(std::make_pair(i, mo->getBaseExpr()));

      if (!i->hasInitializer())
          os->initializeToRandom();
    }
  }
  
  // link aliases to their definitions (if bound)
  for (Module::alias_iterator i = m->alias_begin(), ie = m->alias_end(); 
       i != ie; ++i) {
    // Map the alias to its aliasee's address. This works because we have
    // addresses for everything, even undefined functions. 
    globalAddresses.insert(std::make_pair(i, evalConstant(i->getAliasee())));
  }

  // once all objects are allocated, do the actual initialization
  for (Module::const_global_iterator i = m->global_begin(),
         e = m->global_end();
       i != e; ++i) {
    if (i->hasInitializer()) {
      MemoryObject *mo = globalObjects.find(i)->second;
      const ObjectState *os = state.addressSpace.findObject(mo);
      assert(os);
      ObjectState *wos = state.addressSpace.getWriteable(mo, os);
      
      initializeGlobalObject(state, wos, i->getInitializer(), 0);
      // if(i->isConstant()) os->setReadOnly(true);
    }
  }
}

void Executor::branch(ExecutionState &state, 
                      const std::vector< ref<Expr> > &conditions,
                      std::vector<ExecutionState*> &result) {
  TimerStatIncrementer timer(stats::forkTime);
  unsigned N = conditions.size();
  assert(N);

  stats::forks += N-1;

  // XXX do proper balance or keep random?
  result.push_back(&state);
  for (unsigned i=1; i<N; ++i) {
    ExecutionState *es = result[theRNG.getInt32() % i];
    ExecutionState *ns = es->branch();
    addedStates.insert(ns);
    result.push_back(ns);
    es->ptreeNode->data = 0;
    std::pair<PTree::Node*,PTree::Node*> res = 
      processTree->split(es->ptreeNode, ns, es);
    ns->ptreeNode = res.first;
    es->ptreeNode = res.second;
  }

  // If necessary redistribute seeds to match conditions, killing
  // states if necessary due to OnlyReplaySeeds (inefficient but
  // simple).
  
  std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it = 
    seedMap.find(&state);
  if (it != seedMap.end()) {
    std::vector<SeedInfo> seeds = it->second;
    seedMap.erase(it);

    // Assume each seed only satisfies one condition (necessarily true
    // when conditions are mutually exclusive and their conjunction is
    // a tautology).
    for (std::vector<SeedInfo>::iterator siit = seeds.begin(), 
           siie = seeds.end(); siit != siie; ++siit) {
      unsigned i;
      for (i=0; i<N; ++i) {
        ref<ConstantExpr> res;
        bool success = 
          solver->getValue(state, siit->assignment.evaluate(conditions[i]), 
                           res);
        assert(success && "FIXME: Unhandled solver failure");
        (void) success;
        if (res->isTrue())
          break;
      }
      
      // If we didn't find a satisfying condition randomly pick one
      // (the seed will be patched).
      if (i==N)
        i = theRNG.getInt32() % N;

      seedMap[result[i]].push_back(*siit);
    }

    if (OnlyReplaySeeds) {
      for (unsigned i=0; i<N; ++i) {
        if (!seedMap.count(result[i])) {
          terminateState(*result[i]);
          result[i] = NULL;
        }
      } 
    }
  }

  for (unsigned i=0; i<N; ++i)
    if (result[i])
      addConstraint(*result[i], conditions[i]);
}

Executor::StatePair 
Executor::fork(ExecutionState &current, ref<Expr> condition, bool isInternal) {
  Solver::Validity res;
  std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it = 
    seedMap.find(&current);
  bool isSeeding = it != seedMap.end();

  if (!isSeeding && !isa<ConstantExpr>(condition) && 
      (MaxStaticForkPct!=1. || MaxStaticSolvePct != 1. ||
       MaxStaticCPForkPct!=1. || MaxStaticCPSolvePct != 1.) &&
      statsTracker->elapsed() > 60.) {
    StatisticManager &sm = *theStatisticManager;
    CallPathNode *cpn = current.stack.back().callPathNode;
    if ((MaxStaticForkPct<1. &&
         sm.getIndexedValue(stats::forks, sm.getIndex()) > 
         stats::forks*MaxStaticForkPct) ||
        (MaxStaticCPForkPct<1. &&
         cpn && (cpn->statistics.getValue(stats::forks) > 
                 stats::forks*MaxStaticCPForkPct)) ||
        (MaxStaticSolvePct<1 &&
         sm.getIndexedValue(stats::solverTime, sm.getIndex()) > 
         stats::solverTime*MaxStaticSolvePct) ||
        (MaxStaticCPForkPct<1. &&
         cpn && (cpn->statistics.getValue(stats::solverTime) > 
                 stats::solverTime*MaxStaticCPSolvePct))) {
      ref<ConstantExpr> value; 
      bool success = solver->getValue(current, condition, value);
      assert(success && "FIXME: Unhandled solver failure");
      (void) success;
      addConstraint(current, EqExpr::create(value, condition));
      condition = value;
    }
  }

  double timeout = stpTimeout;
  if (isSeeding)
    timeout *= it->second.size();
  solver->setTimeout(timeout);
  bool success = solver->evaluate(current, condition, res);
  solver->setTimeout(0);
  if (!success) {
    current.pc = current.prevPC;
    terminateStateEarly(current, "Query timed out (fork).");
    return StatePair(0, 0);
  }

  if (!isSeeding) {
    if (replayPath && !isInternal) {
      assert(replayPosition<replayPath->size() &&
             "ran out of branches in replay path mode");
      bool branch = (*replayPath)[replayPosition++];
      
      if (res==Solver::True) {
        assert(branch && "hit invalid branch in replay path mode");
      } else if (res==Solver::False) {
        assert(!branch && "hit invalid branch in replay path mode");
      } else {
        // add constraints
        if(branch) {
          res = Solver::True;
          addConstraint(current, condition);
        } else  {
          res = Solver::False;
          addConstraint(current, Expr::createIsZero(condition));
        }
      }
    } else if (res==Solver::Unknown) {
      assert(!replayOut && "in replay mode, only one branch can be true.");
      
      if ((MaxMemoryInhibit && atMemoryLimit) || 
          current.forkDisabled ||
          inhibitForking || 
          (MaxForks!=~0u && stats::forks >= MaxForks)) {

	if (MaxMemoryInhibit && atMemoryLimit)
	  klee_warning_once(0, "skipping fork (memory cap exceeded)");
	else if (current.forkDisabled)
	  klee_warning_once(0, "skipping fork (fork disabled on current path)");
	else if (inhibitForking)
	  klee_warning_once(0, "skipping fork (fork disabled globally)");
	else 
	  klee_warning_once(0, "skipping fork (max-forks reached)");

        TimerStatIncrementer timer(stats::forkTime);
        if (theRNG.getBool()) {
          addConstraint(current, condition);
          res = Solver::True;        
        } else {
          addConstraint(current, Expr::createIsZero(condition));
          res = Solver::False;
        }
      }
    }
  }

  // Fix branch in only-replay-seed mode, if we don't have both true
  // and false seeds.
  if (isSeeding && 
      (current.forkDisabled || OnlyReplaySeeds) && 
      res == Solver::Unknown) {
    bool trueSeed=false, falseSeed=false;
    // Is seed extension still ok here?
    for (std::vector<SeedInfo>::iterator siit = it->second.begin(), 
           siie = it->second.end(); siit != siie; ++siit) {
      ref<ConstantExpr> res;
      bool success = 
        solver->getValue(current, siit->assignment.evaluate(condition), res);
      assert(success && "FIXME: Unhandled solver failure");
      (void) success;
      if (res->isTrue()) {
        trueSeed = true;
      } else {
        falseSeed = true;
      }
      if (trueSeed && falseSeed)
        break;
    }
    if (!(trueSeed && falseSeed)) {
      assert(trueSeed || falseSeed);
      
      res = trueSeed ? Solver::True : Solver::False;
      addConstraint(current, trueSeed ? condition : Expr::createIsZero(condition));
    }
  }


  // XXX - even if the constraint is provable one way or the other we
  // can probably benefit by adding this constraint and allowing it to
  // reduce the other constraints. For example, if we do a binary
  // search on a particular value, and then see a comparison against
  // the value it has been fixed at, we should take this as a nice
  // hint to just use the single constraint instead of all the binary
  // search ones. If that makes sense.
  if (res==Solver::True) {
    if (!isInternal) {
      if (pathWriter) {
        current.pathOS << "1";
      }
    }

    return StatePair(&current, 0);
  } else if (res==Solver::False) {
    if (!isInternal) {
      if (pathWriter) {
        current.pathOS << "0";
      }
    }

    return StatePair(0, &current);
  } else {
    TimerStatIncrementer timer(stats::forkTime);
    ExecutionState *falseState, *trueState = &current;

    ++stats::forks;

    falseState = trueState->branch();
    addedStates.insert(falseState);

    if (RandomizeFork && theRNG.getBool())
      std::swap(trueState, falseState);

    if (it != seedMap.end()) {
      std::vector<SeedInfo> seeds = it->second;
      it->second.clear();
      std::vector<SeedInfo> &trueSeeds = seedMap[trueState];
      std::vector<SeedInfo> &falseSeeds = seedMap[falseState];
      for (std::vector<SeedInfo>::iterator siit = seeds.begin(), 
             siie = seeds.end(); siit != siie; ++siit) {
        ref<ConstantExpr> res;
        bool success = 
          solver->getValue(current, siit->assignment.evaluate(condition), res);
        assert(success && "FIXME: Unhandled solver failure");
        (void) success;
        if (res->isTrue()) {
          trueSeeds.push_back(*siit);
        } else {
          falseSeeds.push_back(*siit);
        }
      }
      
      bool swapInfo = false;
      if (trueSeeds.empty()) {
        if (&current == trueState) swapInfo = true;
        seedMap.erase(trueState);
      }
      if (falseSeeds.empty()) {
        if (&current == falseState) swapInfo = true;
        seedMap.erase(falseState);
      }
      if (swapInfo) {
        std::swap(trueState->coveredNew, falseState->coveredNew);
        std::swap(trueState->coveredLines, falseState->coveredLines);
      }
    }

    current.ptreeNode->data = 0;
    std::pair<PTree::Node*, PTree::Node*> res =
      processTree->split(current.ptreeNode, falseState, trueState);
    falseState->ptreeNode = res.first;
    trueState->ptreeNode = res.second;

    if (!isInternal) {
      if (pathWriter) {
        falseState->pathOS = pathWriter->open(current.pathOS);
        trueState->pathOS << "1";
        falseState->pathOS << "0";
      }      
      if (symPathWriter) {
        falseState->symPathOS = symPathWriter->open(current.symPathOS);
        trueState->symPathOS << "1";
        falseState->symPathOS << "0";
      }
    }

    addConstraint(*trueState, condition);
    addConstraint(*falseState, Expr::createIsZero(condition));

    // Kinda gross, do we even really still want this option?
    if (MaxDepth && MaxDepth<=trueState->depth) {
      terminateStateEarly(*trueState, "max-depth exceeded.");
      terminateStateEarly(*falseState, "max-depth exceeded.");
      return StatePair(0, 0);
    }

    return StatePair(trueState, falseState);
  }
}

void Executor::addConstraint(ExecutionState &state, ref<Expr> condition) {
  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(condition)) {
    assert(CE->isTrue() && "attempt to add invalid constraint");
    return;
  }

  // Check to see if this constraint violates seeds.
  std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it = 
    seedMap.find(&state);
  if (it != seedMap.end()) {
    bool warn = false;
    for (std::vector<SeedInfo>::iterator siit = it->second.begin(), 
           siie = it->second.end(); siit != siie; ++siit) {
      bool res;
      bool success = 
        solver->mustBeFalse(state, siit->assignment.evaluate(condition), res);
      assert(success && "FIXME: Unhandled solver failure");
      (void) success;
      if (res) {
        siit->patchSeed(state, condition, solver);
        warn = true;
      }
    }
    if (warn)
      klee_warning("seeds patched for violating constraint"); 
  }

  state.addConstraint(condition);
  if (ivcEnabled)
    doImpliedValueConcretization(state, condition, 
                                 ConstantExpr::alloc(1, Expr::Bool));
}

ref<klee::ConstantExpr> Executor::evalConstant(const Constant *c) {
  if (const llvm::ConstantExpr *ce = dyn_cast<llvm::ConstantExpr>(c)) {
    return evalConstantExpr(ce);
  } else {
    if (const ConstantInt *ci = dyn_cast<ConstantInt>(c)) {
      return ConstantExpr::alloc(ci->getValue());
    } else if (const ConstantFP *cf = dyn_cast<ConstantFP>(c)) {      
      return ConstantExpr::alloc(cf->getValueAPF().bitcastToAPInt());
    } else if (const GlobalValue *gv = dyn_cast<GlobalValue>(c)) {
      return globalAddresses.find(gv)->second;
    } else if (isa<ConstantPointerNull>(c)) {
      return Expr::createPointer(0);
    } else if (isa<UndefValue>(c) || isa<ConstantAggregateZero>(c)) {
      return ConstantExpr::create(0, getWidthForLLVMType(c->getType()));
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 1)
    } else if (const ConstantDataSequential *cds =
                 dyn_cast<ConstantDataSequential>(c)) {
      std::vector<ref<Expr> > kids;
      for (unsigned i = 0, e = cds->getNumElements(); i != e; ++i) {
        ref<Expr> kid = evalConstant(cds->getElementAsConstant(i));
        kids.push_back(kid);
      }
      ref<Expr> res = ConcatExpr::createN(kids.size(), kids.data());
      return cast<ConstantExpr>(res);
#endif
    } else if (const ConstantStruct *cs = dyn_cast<ConstantStruct>(c)) {
      const StructLayout *sl = kmodule->targetData->getStructLayout(cs->getType());
      llvm::SmallVector<ref<Expr>, 4> kids;
      for (unsigned i = cs->getNumOperands(); i != 0; --i) {
        unsigned op = i-1;
        ref<Expr> kid = evalConstant(cs->getOperand(op));

        uint64_t thisOffset = sl->getElementOffsetInBits(op),
                 nextOffset = (op == cs->getNumOperands() - 1)
                              ? sl->getSizeInBits()
                              : sl->getElementOffsetInBits(op+1);
        if (nextOffset-thisOffset > kid->getWidth()) {
          uint64_t paddingWidth = nextOffset-thisOffset-kid->getWidth();
          kids.push_back(ConstantExpr::create(0, paddingWidth));
        }

        kids.push_back(kid);
      }
      ref<Expr> res = ConcatExpr::createN(kids.size(), kids.data());
      return cast<ConstantExpr>(res);
    } else {
      // Constant{Array,Vector}
      assert(0 && "invalid argument to evalConstant()");
    }
  }
}

const Cell& Executor::eval(KInstruction *ki, unsigned index, 
                           ExecutionState &state) const {
  assert(index < ki->inst->getNumOperands());
  int vnumber = ki->operands[index];

  assert(vnumber != -1 &&
         "Invalid operand to eval(), not a value or constant!");

  // Determine if this is a constant or not.
  if (vnumber < 0) {
    unsigned index = -vnumber - 2;
    return kmodule->constantTable[index];
  } else {
    unsigned index = vnumber;
    StackFrame &sf = state.stack.back();
    return sf.locals[index];
  }
}

void Executor::bindLocal(KInstruction *target, ExecutionState &state, 
                         ref<Expr> value) {
  getDestCell(state, target).value = value;
}

void Executor::bindArgument(KFunction *kf, unsigned index, 
                            ExecutionState &state, ref<Expr> value) {
  getArgumentCell(state, kf, index).value = value;
}

ref<Expr> Executor::toUnique(const ExecutionState &state, 
                             ref<Expr> &e) {
  ref<Expr> result = e;

  if (!isa<ConstantExpr>(e)) {
    ref<ConstantExpr> value;
    bool isTrue = false;

    solver->setTimeout(stpTimeout);      
    if (solver->getValue(state, e, value) &&
        solver->mustBeTrue(state, EqExpr::create(e, value), isTrue) &&
        isTrue)
      result = value;
    solver->setTimeout(0);
  }
  
  return result;
}


/* Concretize the given expression, and return a possible constant value. 
   'reason' is just a documentation string stating the reason for concretization. */
ref<klee::ConstantExpr> 
Executor::toConstant(ExecutionState &state, 
                     ref<Expr> e,
                     const char *reason) {
  e = state.constraints.simplifyExpr(e);
  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(e))
    return CE;

  ref<ConstantExpr> value;
  bool success = solver->getValue(state, e, value);
  assert(success && "FIXME: Unhandled solver failure");
  (void) success;
    
  std::ostringstream os;
  os << "silently concretizing (reason: " << reason << ") expression " << e 
     << " to value " << value 
     << " (" << (*(state.pc)).info->file << ":" << (*(state.pc)).info->line << ")";
      
  if (AllExternalWarnings)
    klee_warning(reason, os.str().c_str());
  else
    klee_warning_once(reason, "%s", os.str().c_str());

  addConstraint(state, EqExpr::create(e, value));
    
  return value;
}

void Executor::executeGetValue(ExecutionState &state,
                               ref<Expr> e,
                               KInstruction *target) {
  e = state.constraints.simplifyExpr(e);
  std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it = 
    seedMap.find(&state);
  if (it==seedMap.end() || isa<ConstantExpr>(e)) {
    ref<ConstantExpr> value;
    bool success = solver->getValue(state, e, value);
    assert(success && "FIXME: Unhandled solver failure");
    (void) success;
    bindLocal(target, state, value);
  } else {
    std::set< ref<Expr> > values;
    for (std::vector<SeedInfo>::iterator siit = it->second.begin(), 
           siie = it->second.end(); siit != siie; ++siit) {
      ref<ConstantExpr> value;
      bool success = 
        solver->getValue(state, siit->assignment.evaluate(e), value);
      assert(success && "FIXME: Unhandled solver failure");
      (void) success;
      values.insert(value);
    }
    
    std::vector< ref<Expr> > conditions;
    for (std::set< ref<Expr> >::iterator vit = values.begin(), 
           vie = values.end(); vit != vie; ++vit)
      conditions.push_back(EqExpr::create(e, *vit));

    std::vector<ExecutionState*> branches;
    branch(state, conditions, branches);
    
    std::vector<ExecutionState*>::iterator bit = branches.begin();
    for (std::set< ref<Expr> >::iterator vit = values.begin(), 
           vie = values.end(); vit != vie; ++vit) {
      ExecutionState *es = *bit;
      if (es)
        bindLocal(target, *es, *vit);
      ++bit;
    }
  }
}

void Executor::stepInstruction(ExecutionState &state) {
  if (DebugPrintInstructions) {
    printFileLine(state, state.pc);
    std::cerr << std::setw(10) << stats::instructions << " ";
    llvm::errs() << *(state.pc->inst);
  }

  if (statsTracker)
    statsTracker->stepInstruction(state);

  ++stats::instructions;
  state.prevPC = state.pc;
  ++state.pc;

  if (stats::instructions==StopAfterNInstructions)
    haltExecution = true;
}

void Executor::executeCall(ExecutionState &state, 
                           KInstruction *ki,
                           Function *f,
                           std::vector< ref<Expr> > &arguments) {
  Instruction *i = ki->inst;
  if (f && f->isDeclaration()) {
    switch(f->getIntrinsicID()) {
    case Intrinsic::not_intrinsic:
      // state may be destroyed by this call, cannot touch
      callExternalFunction(state, ki, f, arguments);
      break;
        
      // va_arg is handled by caller and intrinsic lowering, see comment for
      // ExecutionState::varargs
    case Intrinsic::vastart:  {
      StackFrame &sf = state.stack.back();
      assert(sf.varargs && 
             "vastart called in function with no vararg object");

      // FIXME: This is really specific to the architecture, not the pointer
      // size. This happens to work fir x86-32 and x86-64, however.
      Expr::Width WordSize = Context::get().getPointerWidth();
      if (WordSize == Expr::Int32) {
        executeMemoryOperation(state, true, arguments[0], 
                               sf.varargs->getBaseExpr(), 0);
      } else {
        assert(WordSize == Expr::Int64 && "Unknown word size!");

        // X86-64 has quite complicated calling convention. However,
        // instead of implementing it, we can do a simple hack: just
        // make a function believe that all varargs are on stack.
        executeMemoryOperation(state, true, arguments[0],
                               ConstantExpr::create(48, 32), 0); // gp_offset
        executeMemoryOperation(state, true,
                               AddExpr::create(arguments[0], 
                                               ConstantExpr::create(4, 64)),
                               ConstantExpr::create(304, 32), 0); // fp_offset
        executeMemoryOperation(state, true,
                               AddExpr::create(arguments[0], 
                                               ConstantExpr::create(8, 64)),
                               sf.varargs->getBaseExpr(), 0); // overflow_arg_area
        executeMemoryOperation(state, true,
                               AddExpr::create(arguments[0], 
                                               ConstantExpr::create(16, 64)),
                               ConstantExpr::create(0, 64), 0); // reg_save_area
      }
      break;
    }
    case Intrinsic::vaend:
      // va_end is a noop for the interpreter.
      //
      // FIXME: We should validate that the target didn't do something bad
      // with vaeend, however (like call it twice).
      break;
        
    case Intrinsic::vacopy:
      // va_copy should have been lowered.
      //
      // FIXME: It would be nice to check for errors in the usage of this as
      // well.
    default:
      klee_error("unknown intrinsic: %s", f->getName().data());
    }

    if (InvokeInst *ii = dyn_cast<InvokeInst>(i))
      transferToBasicBlock(ii->getNormalDest(), i->getParent(), state);
  } else {
    // FIXME: I'm not really happy about this reliance on prevPC but it is ok, I
    // guess. This just done to avoid having to pass KInstIterator everywhere
    // instead of the actual instruction, since we can't make a KInstIterator
    // from just an instruction (unlike LLVM).
    KFunction *kf = kmodule->functionMap[f];
    state.pushFrame(state.prevPC, kf);
    state.pc = kf->instructions;
        
    if (statsTracker)
      statsTracker->framePushed(state, &state.stack[state.stack.size()-2]);
 
     // TODO: support "byval" parameter attribute
     // TODO: support zeroext, signext, sret attributes
        
    unsigned callingArgs = arguments.size();
    unsigned funcArgs = f->arg_size();
    if (!f->isVarArg()) {
      if (callingArgs > funcArgs) {
        klee_warning_once(f, "calling %s with extra arguments.", 
                          f->getName().data());
      } else if (callingArgs < funcArgs) {
        terminateStateOnError(state, "calling function with too few arguments", 
                              "user.err");
        return;
      }
    } else {
      if (callingArgs < funcArgs) {
        terminateStateOnError(state, "calling function with too few arguments", 
                              "user.err");
        return;
      }
            
      StackFrame &sf = state.stack.back();
      unsigned size = 0;
      for (unsigned i = funcArgs; i < callingArgs; i++) {
        // FIXME: This is really specific to the architecture, not the pointer
        // size. This happens to work fir x86-32 and x86-64, however.
        Expr::Width WordSize = Context::get().getPointerWidth();
        if (WordSize == Expr::Int32) {
          size += Expr::getMinBytesForWidth(arguments[i]->getWidth());
        } else {
          size += llvm::RoundUpToAlignment(arguments[i]->getWidth(), 
                                           WordSize) / 8;
        }
      }

      MemoryObject *mo = sf.varargs = memory->allocate(size, true, false, 
                                                       state.prevPC->inst);
      if (!mo) {
        terminateStateOnExecError(state, "out of memory (varargs)");
        return;
      }
      ObjectState *os = bindObjectInState(state, mo, true);
      unsigned offset = 0;
      for (unsigned i = funcArgs; i < callingArgs; i++) {
        // FIXME: This is really specific to the architecture, not the pointer
        // size. This happens to work fir x86-32 and x86-64, however.
        Expr::Width WordSize = Context::get().getPointerWidth();
        if (WordSize == Expr::Int32) {
          os->write(offset, arguments[i]);
          offset += Expr::getMinBytesForWidth(arguments[i]->getWidth());
        } else {
          assert(WordSize == Expr::Int64 && "Unknown word size!");
          os->write(offset, arguments[i]);
          offset += llvm::RoundUpToAlignment(arguments[i]->getWidth(), 
                                             WordSize) / 8;
        }
      }
    }

    unsigned numFormals = f->arg_size();
    for (unsigned i=0; i<numFormals; ++i) 
      bindArgument(kf, i, state, arguments[i]);
  }
}

void Executor::transferToBasicBlock(BasicBlock *dst, BasicBlock *src, 
                                    ExecutionState &state) {
  // Note that in general phi nodes can reuse phi values from the same
  // block but the incoming value is the eval() result *before* the
  // execution of any phi nodes. this is pathological and doesn't
  // really seem to occur, but just in case we run the PhiCleanerPass
  // which makes sure this cannot happen and so it is safe to just
  // eval things in order. The PhiCleanerPass also makes sure that all
  // incoming blocks have the same order for each PHINode so we only
  // have to compute the index once.
  //
  // With that done we simply set an index in the state so that PHI
  // instructions know which argument to eval, set the pc, and continue.
  
  // XXX this lookup has to go ?
  KFunction *kf = state.stack.back().kf;
  unsigned entry = kf->basicBlockEntry[dst];
  state.pc = &kf->instructions[entry];
  if (state.pc->inst->getOpcode() == Instruction::PHI) {
    PHINode *first = static_cast<PHINode*>(state.pc->inst);
    state.incomingBBIndex = first->getBasicBlockIndex(src);
  }
}

void Executor::printFileLine(ExecutionState &state, KInstruction *ki) {
  const InstructionInfo &ii = *ki->info;
  if (ii.file != "") 
    std::cerr << "     " << ii.file << ":" << ii.line << ":";
  else
    std::cerr << "     [no debug info]:";
}

/// Compute the true target of a function call, resolving LLVM and KLEE aliases
/// and bitcasts.
Function* Executor::getTargetFunction(Value *calledVal, ExecutionState &state) {
  SmallPtrSet<const GlobalValue*, 3> Visited;

  Constant *c = dyn_cast<Constant>(calledVal);
  if (!c)
    return 0;

  while (true) {
    if (GlobalValue *gv = dyn_cast<GlobalValue>(c)) {
      if (!Visited.insert(gv))
        return 0;

      std::string alias = state.getFnAlias(gv->getName());
      if (alias != "") {
        llvm::Module* currModule = kmodule->module;
        GlobalValue *old_gv = gv;
        gv = currModule->getNamedValue(alias);
        if (!gv) {
          llvm::errs() << "Function " << alias << "(), alias for " 
                       << old_gv->getName() << " not found!\n";
          assert(0 && "function alias not found");
        }
      }
     
      if (Function *f = dyn_cast<Function>(gv))
        return f;
      else if (GlobalAlias *ga = dyn_cast<GlobalAlias>(gv))
        c = ga->getAliasee();
      else
        return 0;
    } else if (llvm::ConstantExpr *ce = dyn_cast<llvm::ConstantExpr>(c)) {
      if (ce->getOpcode()==Instruction::BitCast)
        c = ce->getOperand(0);
      else
        return 0;
    } else
      return 0;
  }
}

static bool isDebugIntrinsic(const Function *f, KModule *KM) {
#if LLVM_VERSION_CODE < LLVM_VERSION(2, 7)
  // Fast path, getIntrinsicID is slow.
  if (f == KM->dbgStopPointFn)
    return true;

  switch (f->getIntrinsicID()) {
  case Intrinsic::dbg_stoppoint:
  case Intrinsic::dbg_region_start:
  case Intrinsic::dbg_region_end:
  case Intrinsic::dbg_func_start:
  case Intrinsic::dbg_declare:
    return true;

  default:
    return false;
  }
#else
  return false;
#endif
}

static inline const llvm::fltSemantics * fpWidthToSemantics(unsigned width) {
  switch(width) {
  case Expr::Int32:
    return &llvm::APFloat::IEEEsingle;
  case Expr::Int64:
    return &llvm::APFloat::IEEEdouble;
  case Expr::Fl80:
    return &llvm::APFloat::x87DoubleExtended;
  default:
    return 0;
  }
}

//---bty----record path
void RecordPath(KInstruction *ki){
        const InstructionInfo &ins = *ki->info;
	std::stringstream t_sstream;
	if(ins.line!=0) t_sstream<<ins.file<<'\t'<<ins.line<<std::endl;
	char* filename="pathrecord.txt";
	std::ofstream fileout(filename,std::ios::app);
	fileout<<t_sstream.str()<<std::endl;
}

void Executor::executeInstruction(ExecutionState &state, KInstruction *ki) {
  Instruction *i = ki->inst;
  //----bty----record path
  if(GuidedExecutionTag == true)
	RecordPath(ki);
  //----
  switch (i->getOpcode()) {
    // Control flow
  case Instruction::Ret: {
    ReturnInst *ri = cast<ReturnInst>(i);
    KInstIterator kcaller = state.stack.back().caller;
    Instruction *caller = kcaller ? kcaller->inst : 0;
    bool isVoidReturn = (ri->getNumOperands() == 0);
    ref<Expr> result = ConstantExpr::alloc(0, Expr::Bool);
    
    if (!isVoidReturn) {
      result = eval(ki, 0, state).value;
    }
    
    if (state.stack.size() <= 1) {
      assert(!caller && "caller set on initial stack frame");
      terminateStateOnExit(state);
    } else {
      state.popFrame();

      if (statsTracker)
        statsTracker->framePopped(state);

      if (InvokeInst *ii = dyn_cast<InvokeInst>(caller)) {
        transferToBasicBlock(ii->getNormalDest(), caller->getParent(), state);
      } else {
        state.pc = kcaller;
        ++state.pc;
      }

      if (!isVoidReturn) {
        LLVM_TYPE_Q Type *t = caller->getType();
        if (t != Type::getVoidTy(getGlobalContext())) {
          // may need to do coercion due to bitcasts
          Expr::Width from = result->getWidth();
          Expr::Width to = getWidthForLLVMType(t);
            
          if (from != to) {
            CallSite cs = (isa<InvokeInst>(caller) ? CallSite(cast<InvokeInst>(caller)) : 
                           CallSite(cast<CallInst>(caller)));

            // XXX need to check other param attrs ?
            if (cs.paramHasAttr(0, llvm::Attribute::SExt)) {
              result = SExtExpr::create(result, to);
            } else {
              result = ZExtExpr::create(result, to);
            }
          }

          bindLocal(kcaller, state, result);
        }
      } else {
        // We check that the return value has no users instead of
        // checking the type, since C defaults to returning int for
        // undeclared functions.
        if (!caller->use_empty()) {
          terminateStateOnExecError(state, "return void when caller expected a result");
        }
      }
    }      
    break;
  }
#if LLVM_VERSION_CODE < LLVM_VERSION(3, 1)
  case Instruction::Unwind: {
    for (;;) {
      KInstruction *kcaller = state.stack.back().caller;
      state.popFrame();

      if (statsTracker)
        statsTracker->framePopped(state);

      if (state.stack.empty()) {
        terminateStateOnExecError(state, "unwind from initial stack frame");
        break;
      } else {
        Instruction *caller = kcaller->inst;
        if (InvokeInst *ii = dyn_cast<InvokeInst>(caller)) {
          transferToBasicBlock(ii->getUnwindDest(), caller->getParent(), state);
          break;
        }
      }
    }
    break;
  }
#endif
  case Instruction::Br: {
    BranchInst *bi = cast<BranchInst>(i);
    if (bi->isUnconditional()) {
      transferToBasicBlock(bi->getSuccessor(0), bi->getParent(), state);
    } else {
      // FIXME: Find a way that we don't have this hidden dependency.
      assert(bi->getCondition() == bi->getOperand(0) &&
             "Wrong operand index!");
      ref<Expr> cond = eval(ki, 0, state).value;
      Executor::StatePair branches = fork(state, cond, false);

      // NOTE: There is a hidden dependency here, markBranchVisited
      // requires that we still be in the context of the branch
      // instruction (it reuses its statistic id). Should be cleaned
      // up with convenient instruction specific data.
      if (statsTracker && state.stack.back().kf->trackCoverage)
        statsTracker->markBranchVisited(branches.first, branches.second);

      if (branches.first)
        transferToBasicBlock(bi->getSuccessor(0), bi->getParent(), *branches.first);
      if (branches.second)
        transferToBasicBlock(bi->getSuccessor(1), bi->getParent(), *branches.second);
//-----bty-----guided execution
      if(GuidedExecutionTag == true){
      	if(branches.first!= NULL && branches.second!= NULL){
        	KInstruction *ktrue = (*(branches.first)).pc;
        	const InstructionInfo &itrue = *ktrue->info;
		KInstruction *kfalse = (*(branches.second)).pc;
        	const InstructionInfo &ifalse = *kfalse->info;
//		std::cout<<"Debug: currentstate:"<< &state <<
//          " truestate:"<< branches.first << itrue.file<<"  "<<itrue.line<<"  "<<" falsestate:"<< branches.second <<ifalse.file<<"  "<<ifalse.line <<std::endl;
      }
      //std::cout<<"Debug: currentstate:"<< &state <<
         // " truestate:"<< branches.first << " falsestate:"<< branches.second << std::endl;
      
		searcher->GuideStateExecution(removedStates,branches.first,branches.second);
	}
    }
    break;
  }
  case Instruction::Switch: {
    SwitchInst *si = cast<SwitchInst>(i);
    ref<Expr> cond = eval(ki, 0, state).value;
    BasicBlock *bb = si->getParent();

    cond = toUnique(state, cond);
    if (ConstantExpr *CE = dyn_cast<ConstantExpr>(cond)) {
      // Somewhat gross to create these all the time, but fine till we
      // switch to an internal rep.
      LLVM_TYPE_Q llvm::IntegerType *Ty = 
        cast<IntegerType>(si->getCondition()->getType());
      ConstantInt *ci = ConstantInt::get(Ty, CE->getZExtValue());
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 1)
      unsigned index = si->findCaseValue(ci).getSuccessorIndex();
#else
      unsigned index = si->findCaseValue(ci);
#endif
      transferToBasicBlock(si->getSuccessor(index), si->getParent(), state);
    } else {
      std::map<BasicBlock*, ref<Expr> > targets;
      ref<Expr> isDefault = ConstantExpr::alloc(1, Expr::Bool);
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 1)      
      for (SwitchInst::CaseIt i = si->case_begin(), e = si->case_end();
           i != e; ++i) {
        ref<Expr> value = evalConstant(i.getCaseValue());
#else
      for (unsigned i=1, cases = si->getNumCases(); i<cases; ++i) {
        ref<Expr> value = evalConstant(si->getCaseValue(i));
#endif
        ref<Expr> match = EqExpr::create(cond, value);
        isDefault = AndExpr::create(isDefault, Expr::createIsZero(match));
        bool result;
        bool success = solver->mayBeTrue(state, match, result);
        assert(success && "FIXME: Unhandled solver failure");
        (void) success;
        if (result) {
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 1)
          BasicBlock *caseSuccessor = i.getCaseSuccessor();
#else
          BasicBlock *caseSuccessor = si->getSuccessor(i);
#endif
          std::map<BasicBlock*, ref<Expr> >::iterator it =
            targets.insert(std::make_pair(caseSuccessor,
                           ConstantExpr::alloc(0, Expr::Bool))).first;

          it->second = OrExpr::create(match, it->second);
        }
      }
      bool res;
      bool success = solver->mayBeTrue(state, isDefault, res);
      assert(success && "FIXME: Unhandled solver failure");
      (void) success;
      if (res)
        targets.insert(std::make_pair(si->getDefaultDest(), isDefault));
      
      std::vector< ref<Expr> > conditions;
      for (std::map<BasicBlock*, ref<Expr> >::iterator it = 
             targets.begin(), ie = targets.end();
           it != ie; ++it)
        conditions.push_back(it->second);
      
      std::vector<ExecutionState*> branches;
      branch(state, conditions, branches);
        
      std::vector<ExecutionState*>::iterator bit = branches.begin();
      for (std::map<BasicBlock*, ref<Expr> >::iterator it = 
             targets.begin(), ie = targets.end();
           it != ie; ++it) {
        ExecutionState *es = *bit;
        if (es)
          transferToBasicBlock(it->first, bb, *es);
        ++bit;
      }
    }
    break;
 }
  case Instruction::Unreachable:
    // Note that this is not necessarily an internal bug, llvm will
    // generate unreachable instructions in cases where it knows the
    // program will crash. So it is effectively a SEGV or internal
    // error.
    terminateStateOnExecError(state, "reached \"unreachable\" instruction");
    break;

  case Instruction::Invoke:
  case Instruction::Call: {
    CallSite cs(i);

    unsigned numArgs = cs.arg_size();
    Value *fp = cs.getCalledValue();
    Function *f = getTargetFunction(fp, state);

    // Skip debug intrinsics, we can't evaluate their metadata arguments.
    if (f && isDebugIntrinsic(f, kmodule))
      break;

    if (isa<InlineAsm>(fp)) {
      terminateStateOnExecError(state, "inline assembly is unsupported");
      break;
    }
    // evaluate arguments
    std::vector< ref<Expr> > arguments;
    arguments.reserve(numArgs);

    for (unsigned j=0; j<numArgs; ++j)
      arguments.push_back(eval(ki, j+1, state).value);

    if (f) {
      const FunctionType *fType = 
        dyn_cast<FunctionType>(cast<PointerType>(f->getType())->getElementType());
      const FunctionType *fpType =
        dyn_cast<FunctionType>(cast<PointerType>(fp->getType())->getElementType());

      // special case the call with a bitcast case
      if (fType != fpType) {
        assert(fType && fpType && "unable to get function type");

        // XXX check result coercion

        // XXX this really needs thought and validation
        unsigned i=0;
        for (std::vector< ref<Expr> >::iterator
               ai = arguments.begin(), ie = arguments.end();
             ai != ie; ++ai) {
          Expr::Width to, from = (*ai)->getWidth();
            
          if (i<fType->getNumParams()) {
            to = getWidthForLLVMType(fType->getParamType(i));

            if (from != to) {
              // XXX need to check other param attrs ?
              if (cs.paramHasAttr(i+1, llvm::Attribute::SExt)) {
                arguments[i] = SExtExpr::create(arguments[i], to);
              } else {
                arguments[i] = ZExtExpr::create(arguments[i], to);
              }
            }
          }
            
          i++;
        }
      }

      executeCall(state, ki, f, arguments);
    } else {
      ref<Expr> v = eval(ki, 0, state).value;

      ExecutionState *free = &state;
      bool hasInvalid = false, first = true;

      /* XXX This is wasteful, no need to do a full evaluate since we
         have already got a value. But in the end the caches should
         handle it for us, albeit with some overhead. */
      do {
        ref<ConstantExpr> value;
        bool success = solver->getValue(*free, v, value);
        assert(success && "FIXME: Unhandled solver failure");
        (void) success;
        StatePair res = fork(*free, EqExpr::create(v, value), true);
        if (res.first) {
          uint64_t addr = value->getZExtValue();
          if (legalFunctions.count(addr)) {
            f = (Function*) addr;

            // Don't give warning on unique resolution
            if (res.second || !first)
              klee_warning_once((void*) (unsigned long) addr, 
                                "resolved symbolic function pointer to: %s",
                                f->getName().data());

            executeCall(*res.first, ki, f, arguments);
          } else {
            if (!hasInvalid) {
              terminateStateOnExecError(state, "invalid function pointer");
              hasInvalid = true;
            }
          }
        }

        first = false;
        free = res.second;
      } while (free);
    }
    break;
  }
  case Instruction::PHI: {
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 0)
    ref<Expr> result = eval(ki, state.incomingBBIndex, state).value;
#else
    ref<Expr> result = eval(ki, state.incomingBBIndex * 2, state).value;
#endif
    bindLocal(ki, state, result);
    break;
  }

    // Special instructions
  case Instruction::Select: {
    SelectInst *SI = cast<SelectInst>(ki->inst);
    assert(SI->getCondition() == SI->getOperand(0) &&
           "Wrong operand index!");
    ref<Expr> cond = eval(ki, 0, state).value;
    ref<Expr> tExpr = eval(ki, 1, state).value;
    ref<Expr> fExpr = eval(ki, 2, state).value;
    ref<Expr> result = SelectExpr::create(cond, tExpr, fExpr);
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::VAArg:
    terminateStateOnExecError(state, "unexpected VAArg instruction");
    break;

    // Arithmetic / logical

  case Instruction::Add: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    bindLocal(ki, state, AddExpr::create(left, right));
    break;
  }

  case Instruction::Sub: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    bindLocal(ki, state, SubExpr::create(left, right));
    break;
  }
 
  case Instruction::Mul: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    bindLocal(ki, state, MulExpr::create(left, right));
    break;
  }

  case Instruction::UDiv: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = UDivExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::SDiv: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = SDivExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::URem: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = URemExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }
 
  case Instruction::SRem: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = SRemExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::And: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = AndExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::Or: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = OrExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::Xor: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = XorExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::Shl: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = ShlExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::LShr: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = LShrExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::AShr: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = AShrExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

    // Compare

  case Instruction::ICmp: {
    CmpInst *ci = cast<CmpInst>(i);
    ICmpInst *ii = cast<ICmpInst>(ci);
 
    switch(ii->getPredicate()) {
    case ICmpInst::ICMP_EQ: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = EqExpr::create(left, right);
      bindLocal(ki, state, result);
      break;
    }

    case ICmpInst::ICMP_NE: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = NeExpr::create(left, right);
      bindLocal(ki, state, result);
      break;
    }

    case ICmpInst::ICMP_UGT: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = UgtExpr::create(left, right);
      bindLocal(ki, state,result);
      break;
    }

    case ICmpInst::ICMP_UGE: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = UgeExpr::create(left, right);
      bindLocal(ki, state, result);
      break;
    }

    case ICmpInst::ICMP_ULT: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = UltExpr::create(left, right);
      bindLocal(ki, state, result);
      break;
    }

    case ICmpInst::ICMP_ULE: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = UleExpr::create(left, right);
      bindLocal(ki, state, result);
      break;
    }

    case ICmpInst::ICMP_SGT: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = SgtExpr::create(left, right);
      bindLocal(ki, state, result);
      break;
    }

    case ICmpInst::ICMP_SGE: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = SgeExpr::create(left, right);
      bindLocal(ki, state, result);
      break;
    }

    case ICmpInst::ICMP_SLT: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = SltExpr::create(left, right);
      bindLocal(ki, state, result);
      break;
    }

    case ICmpInst::ICMP_SLE: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = SleExpr::create(left, right);
      bindLocal(ki, state, result);
      break;
    }

    default:
      terminateStateOnExecError(state, "invalid ICmp predicate");
    }
    break;
  }
 
    // Memory instructions...
#if LLVM_VERSION_CODE < LLVM_VERSION(2, 7)
  case Instruction::Malloc:
  case Instruction::Alloca: {
    AllocationInst *ai = cast<AllocationInst>(i);
#else
  case Instruction::Alloca: {
    AllocaInst *ai = cast<AllocaInst>(i);
#endif
    unsigned elementSize = 
      kmodule->targetData->getTypeStoreSize(ai->getAllocatedType());
    ref<Expr> size = Expr::createPointer(elementSize);
    if (ai->isArrayAllocation()) {
      ref<Expr> count = eval(ki, 0, state).value;
      count = Expr::createZExtToPointerWidth(count);
      size = MulExpr::create(size, count);
    }
    bool isLocal = i->getOpcode()==Instruction::Alloca;
    executeAlloc(state, size, isLocal, ki);
    break;
  }
#if LLVM_VERSION_CODE < LLVM_VERSION(2, 7)
  case Instruction::Free: {
    executeFree(state, eval(ki, 0, state).value);
    break;
  }
#endif

  case Instruction::Load: {
    ref<Expr> base = eval(ki, 0, state).value;
    executeMemoryOperation(state, false, base, 0, ki);
    break;
  }
  case Instruction::Store: {
    ref<Expr> base = eval(ki, 1, state).value;
    ref<Expr> value = eval(ki, 0, state).value;
    executeMemoryOperation(state, true, base, value, 0);
    break;
  }

  case Instruction::GetElementPtr: {
    KGEPInstruction *kgepi = static_cast<KGEPInstruction*>(ki);
    ref<Expr> base = eval(ki, 0, state).value;

    for (std::vector< std::pair<unsigned, uint64_t> >::iterator 
           it = kgepi->indices.begin(), ie = kgepi->indices.end(); 
         it != ie; ++it) {
      uint64_t elementSize = it->second;
      ref<Expr> index = eval(ki, it->first, state).value;
      base = AddExpr::create(base,
                             MulExpr::create(Expr::createSExtToPointerWidth(index),
                                             Expr::createPointer(elementSize)));
    }
    if (kgepi->offset)
      base = AddExpr::create(base,
                             Expr::createPointer(kgepi->offset));
    bindLocal(ki, state, base);
    break;
  }

    // Conversion
  case Instruction::Trunc: {
    CastInst *ci = cast<CastInst>(i);
    ref<Expr> result = ExtractExpr::create(eval(ki, 0, state).value,
                                           0,
                                           getWidthForLLVMType(ci->getType()));
    bindLocal(ki, state, result);
    break;
  }
  case Instruction::ZExt: {
    CastInst *ci = cast<CastInst>(i);
    ref<Expr> result = ZExtExpr::create(eval(ki, 0, state).value,
                                        getWidthForLLVMType(ci->getType()));
    bindLocal(ki, state, result);
    break;
  }
  case Instruction::SExt: {
    CastInst *ci = cast<CastInst>(i);
    ref<Expr> result = SExtExpr::create(eval(ki, 0, state).value,
                                        getWidthForLLVMType(ci->getType()));
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::IntToPtr: {
    CastInst *ci = cast<CastInst>(i);
    Expr::Width pType = getWidthForLLVMType(ci->getType());
    ref<Expr> arg = eval(ki, 0, state).value;
    bindLocal(ki, state, ZExtExpr::create(arg, pType));
    break;
  } 
  case Instruction::PtrToInt: {
    CastInst *ci = cast<CastInst>(i);
    Expr::Width iType = getWidthForLLVMType(ci->getType());
    ref<Expr> arg = eval(ki, 0, state).value;
    bindLocal(ki, state, ZExtExpr::create(arg, iType));
    break;
  }

  case Instruction::BitCast: {
    ref<Expr> result = eval(ki, 0, state).value;
    bindLocal(ki, state, result);
    break;
  }

    // Floating point instructions

  case Instruction::FAdd: {
    ref<ConstantExpr> left = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, eval(ki, 1, state).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecError(state, "Unsupported FAdd operation");

    llvm::APFloat Res(left->getAPValue());
    Res.add(APFloat(right->getAPValue()), APFloat::rmNearestTiesToEven);
    bindLocal(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()));
    break;
  }

  case Instruction::FSub: {
    ref<ConstantExpr> left = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, eval(ki, 1, state).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecError(state, "Unsupported FSub operation");

    llvm::APFloat Res(left->getAPValue());
    Res.subtract(APFloat(right->getAPValue()), APFloat::rmNearestTiesToEven);
    bindLocal(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()));
    break;
  }
 
  case Instruction::FMul: {
    ref<ConstantExpr> left = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, eval(ki, 1, state).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecError(state, "Unsupported FMul operation");

    llvm::APFloat Res(left->getAPValue());
    Res.multiply(APFloat(right->getAPValue()), APFloat::rmNearestTiesToEven);
    bindLocal(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()));
    break;
  }

  case Instruction::FDiv: {
    ref<ConstantExpr> left = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, eval(ki, 1, state).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecError(state, "Unsupported FDiv operation");

    llvm::APFloat Res(left->getAPValue());
    Res.divide(APFloat(right->getAPValue()), APFloat::rmNearestTiesToEven);
    bindLocal(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()));
    break;
  }

  case Instruction::FRem: {
    ref<ConstantExpr> left = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, eval(ki, 1, state).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecError(state, "Unsupported FRem operation");

    llvm::APFloat Res(left->getAPValue());
    Res.mod(APFloat(right->getAPValue()), APFloat::rmNearestTiesToEven);
    bindLocal(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()));
    break;
  }

  case Instruction::FPTrunc: {
    FPTruncInst *fi = cast<FPTruncInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                       "floating point");
    if (!fpWidthToSemantics(arg->getWidth()) || resultType > arg->getWidth())
      return terminateStateOnExecError(state, "Unsupported FPTrunc operation");

    llvm::APFloat Res(arg->getAPValue());
    bool losesInfo = false;
    Res.convert(*fpWidthToSemantics(resultType),
                llvm::APFloat::rmNearestTiesToEven,
                &losesInfo);
    bindLocal(ki, state, ConstantExpr::alloc(Res));
    break;
  }

  case Instruction::FPExt: {
    FPExtInst *fi = cast<FPExtInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    if (!fpWidthToSemantics(arg->getWidth()) || arg->getWidth() > resultType)
      return terminateStateOnExecError(state, "Unsupported FPExt operation");

    llvm::APFloat Res(arg->getAPValue());
    bool losesInfo = false;
    Res.convert(*fpWidthToSemantics(resultType),
                llvm::APFloat::rmNearestTiesToEven,
                &losesInfo);
    bindLocal(ki, state, ConstantExpr::alloc(Res));
    break;
  }

  case Instruction::FPToUI: {
    FPToUIInst *fi = cast<FPToUIInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                       "floating point");
    if (!fpWidthToSemantics(arg->getWidth()) || resultType > 64)
      return terminateStateOnExecError(state, "Unsupported FPToUI operation");

    llvm::APFloat Arg(arg->getAPValue());
    uint64_t value = 0;
    bool isExact = true;
    Arg.convertToInteger(&value, resultType, false,
                         llvm::APFloat::rmTowardZero, &isExact);
    bindLocal(ki, state, ConstantExpr::alloc(value, resultType));
    break;
  }

  case Instruction::FPToSI: {
    FPToSIInst *fi = cast<FPToSIInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                       "floating point");
    if (!fpWidthToSemantics(arg->getWidth()) || resultType > 64)
      return terminateStateOnExecError(state, "Unsupported FPToSI operation");

    llvm::APFloat Arg(arg->getAPValue());
    uint64_t value = 0;
    bool isExact = true;
    Arg.convertToInteger(&value, resultType, true,
                         llvm::APFloat::rmTowardZero, &isExact);
    bindLocal(ki, state, ConstantExpr::alloc(value, resultType));
    break;
  }

  case Instruction::UIToFP: {
    UIToFPInst *fi = cast<UIToFPInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                       "floating point");
    const llvm::fltSemantics *semantics = fpWidthToSemantics(resultType);
    if (!semantics)
      return terminateStateOnExecError(state, "Unsupported UIToFP operation");
    llvm::APFloat f(*semantics, 0);
    f.convertFromAPInt(arg->getAPValue(), false,
                       llvm::APFloat::rmNearestTiesToEven);

    bindLocal(ki, state, ConstantExpr::alloc(f));
    break;
  }

  case Instruction::SIToFP: {
    SIToFPInst *fi = cast<SIToFPInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                       "floating point");
    const llvm::fltSemantics *semantics = fpWidthToSemantics(resultType);
    if (!semantics)
      return terminateStateOnExecError(state, "Unsupported SIToFP operation");
    llvm::APFloat f(*semantics, 0);
    f.convertFromAPInt(arg->getAPValue(), true,
                       llvm::APFloat::rmNearestTiesToEven);

    bindLocal(ki, state, ConstantExpr::alloc(f));
    break;
  }

  case Instruction::FCmp: {
    FCmpInst *fi = cast<FCmpInst>(i);
    ref<ConstantExpr> left = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, eval(ki, 1, state).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecError(state, "Unsupported FCmp operation");

    APFloat LHS(left->getAPValue());
    APFloat RHS(right->getAPValue());
    APFloat::cmpResult CmpRes = LHS.compare(RHS);

    bool Result = false;
    switch( fi->getPredicate() ) {
      // Predicates which only care about whether or not the operands are NaNs.
    case FCmpInst::FCMP_ORD:
      Result = CmpRes != APFloat::cmpUnordered;
      break;

    case FCmpInst::FCMP_UNO:
      Result = CmpRes == APFloat::cmpUnordered;
      break;

      // Ordered comparisons return false if either operand is NaN.  Unordered
      // comparisons return true if either operand is NaN.
    case FCmpInst::FCMP_UEQ:
      if (CmpRes == APFloat::cmpUnordered) {
        Result = true;
        break;
      }
    case FCmpInst::FCMP_OEQ:
      Result = CmpRes == APFloat::cmpEqual;
      break;

    case FCmpInst::FCMP_UGT:
      if (CmpRes == APFloat::cmpUnordered) {
        Result = true;
        break;
      }
    case FCmpInst::FCMP_OGT:
      Result = CmpRes == APFloat::cmpGreaterThan;
      break;

    case FCmpInst::FCMP_UGE:
      if (CmpRes == APFloat::cmpUnordered) {
        Result = true;
        break;
      }
    case FCmpInst::FCMP_OGE:
      Result = CmpRes == APFloat::cmpGreaterThan || CmpRes == APFloat::cmpEqual;
      break;

    case FCmpInst::FCMP_ULT:
      if (CmpRes == APFloat::cmpUnordered) {
        Result = true;
        break;
      }
    case FCmpInst::FCMP_OLT:
      Result = CmpRes == APFloat::cmpLessThan;
      break;

    case FCmpInst::FCMP_ULE:
      if (CmpRes == APFloat::cmpUnordered) {
        Result = true;
        break;
      }
    case FCmpInst::FCMP_OLE:
      Result = CmpRes == APFloat::cmpLessThan || CmpRes == APFloat::cmpEqual;
      break;

    case FCmpInst::FCMP_UNE:
      Result = CmpRes == APFloat::cmpUnordered || CmpRes != APFloat::cmpEqual;
      break;
    case FCmpInst::FCMP_ONE:
      Result = CmpRes != APFloat::cmpUnordered && CmpRes != APFloat::cmpEqual;
      break;

    default:
      assert(0 && "Invalid FCMP predicate!");
    case FCmpInst::FCMP_FALSE:
      Result = false;
      break;
    case FCmpInst::FCMP_TRUE:
      Result = true;
      break;
    }

    bindLocal(ki, state, ConstantExpr::alloc(Result, Expr::Bool));
    break;
  }
  case Instruction::InsertValue: {
    KGEPInstruction *kgepi = static_cast<KGEPInstruction*>(ki);

    ref<Expr> agg = eval(ki, 0, state).value;
    ref<Expr> val = eval(ki, 1, state).value;

    ref<Expr> l = NULL, r = NULL;
    unsigned lOffset = kgepi->offset*8, rOffset = kgepi->offset*8 + val->getWidth();

    if (lOffset > 0)
      l = ExtractExpr::create(agg, 0, lOffset);
    if (rOffset < agg->getWidth())
      r = ExtractExpr::create(agg, rOffset, agg->getWidth() - rOffset);

    ref<Expr> result;
    if (!l.isNull() && !r.isNull())
      result = ConcatExpr::create(r, ConcatExpr::create(val, l));
    else if (!l.isNull())
      result = ConcatExpr::create(val, l);
    else if (!r.isNull())
      result = ConcatExpr::create(r, val);
    else
      result = val;

    bindLocal(ki, state, result);
    break;
  }
  case Instruction::ExtractValue: {
    KGEPInstruction *kgepi = static_cast<KGEPInstruction*>(ki);

    ref<Expr> agg = eval(ki, 0, state).value;

    ref<Expr> result = ExtractExpr::create(agg, kgepi->offset*8, getWidthForLLVMType(i->getType()));

    bindLocal(ki, state, result);
    break;
  }
 
    // Other instructions...
    // Unhandled
  case Instruction::ExtractElement:
  case Instruction::InsertElement:
  case Instruction::ShuffleVector:
    terminateStateOnError(state, "XXX vector instructions unhandled",
                          "xxx.err");
    break;
 
  default:
    terminateStateOnExecError(state, "illegal instruction");
    break;
  }
}

void Executor::updateStates(ExecutionState *current) {
  if (searcher) {
    searcher->update(current, addedStates, removedStates);
  }
  
  states.insert(addedStates.begin(), addedStates.end());
  addedStates.clear();
  
  for (std::set<ExecutionState*>::iterator
         it = removedStates.begin(), ie = removedStates.end();
       it != ie; ++it) {
    ExecutionState *es = *it;
    std::set<ExecutionState*>::iterator it2 = states.find(es);
    assert(it2!=states.end());
    states.erase(it2);
    std::map<ExecutionState*, std::vector<SeedInfo> >::iterator it3 = 
      seedMap.find(es);
    if (it3 != seedMap.end())
      seedMap.erase(it3);
    processTree->remove(es->ptreeNode);
    delete es;
  }
  removedStates.clear();
}

template <typename TypeIt>
void Executor::computeOffsets(KGEPInstruction *kgepi, TypeIt ib, TypeIt ie) {
  ref<ConstantExpr> constantOffset =
    ConstantExpr::alloc(0, Context::get().getPointerWidth());
  uint64_t index = 1;
  for (TypeIt ii = ib; ii != ie; ++ii) {
    if (LLVM_TYPE_Q StructType *st = dyn_cast<StructType>(*ii)) {
      const StructLayout *sl = kmodule->targetData->getStructLayout(st);
      const ConstantInt *ci = cast<ConstantInt>(ii.getOperand());
      uint64_t addend = sl->getElementOffset((unsigned) ci->getZExtValue());
      constantOffset = constantOffset->Add(ConstantExpr::alloc(addend,
                                                               Context::get().getPointerWidth()));
    } else {
      const SequentialType *set = cast<SequentialType>(*ii);
      uint64_t elementSize = 
        kmodule->targetData->getTypeStoreSize(set->getElementType());
      Value *operand = ii.getOperand();
      if (Constant *c = dyn_cast<Constant>(operand)) {
        ref<ConstantExpr> index = 
          evalConstant(c)->SExt(Context::get().getPointerWidth());
        ref<ConstantExpr> addend = 
          index->Mul(ConstantExpr::alloc(elementSize,
                                         Context::get().getPointerWidth()));
        constantOffset = constantOffset->Add(addend);
      } else {
        kgepi->indices.push_back(std::make_pair(index, elementSize));
      }
    }
    index++;
  }
  kgepi->offset = constantOffset->getZExtValue();
}

void Executor::bindInstructionConstants(KInstruction *KI) {
  KGEPInstruction *kgepi = static_cast<KGEPInstruction*>(KI);

  if (GetElementPtrInst *gepi = dyn_cast<GetElementPtrInst>(KI->inst)) {
    computeOffsets(kgepi, gep_type_begin(gepi), gep_type_end(gepi));
  } else if (InsertValueInst *ivi = dyn_cast<InsertValueInst>(KI->inst)) {
    computeOffsets(kgepi, iv_type_begin(ivi), iv_type_end(ivi));
    assert(kgepi->indices.empty() && "InsertValue constant offset expected");
  } else if (ExtractValueInst *evi = dyn_cast<ExtractValueInst>(KI->inst)) {
    computeOffsets(kgepi, ev_type_begin(evi), ev_type_end(evi));
    assert(kgepi->indices.empty() && "ExtractValue constant offset expected");
  }
}

void Executor::bindModuleConstants() {
  for (std::vector<KFunction*>::iterator it = kmodule->functions.begin(), 
         ie = kmodule->functions.end(); it != ie; ++it) {
    KFunction *kf = *it;
    for (unsigned i=0; i<kf->numInstructions; ++i)
      bindInstructionConstants(kf->instructions[i]);
  }

  kmodule->constantTable = new Cell[kmodule->constants.size()];
  for (unsigned i=0; i<kmodule->constants.size(); ++i) {
    Cell &c = kmodule->constantTable[i];
    c.value = evalConstant(kmodule->constants[i]);
  }
}

void Executor::run(ExecutionState &initialState) {
  bindModuleConstants();

  // Delay init till now so that ticks don't accrue during
  // optimization and such.
  initTimers();

  states.insert(&initialState);

  if (usingSeeds) {
    std::vector<SeedInfo> &v = seedMap[&initialState];
    
    for (std::vector<KTest*>::const_iterator it = usingSeeds->begin(), 
           ie = usingSeeds->end(); it != ie; ++it)
      v.push_back(SeedInfo(*it));

    int lastNumSeeds = usingSeeds->size()+10;
    double lastTime, startTime = lastTime = util::getWallTime();
    ExecutionState *lastState = 0;
    while (!seedMap.empty()) {
      if (haltExecution) goto dump;

      std::map<ExecutionState*, std::vector<SeedInfo> >::iterator it = 
        seedMap.upper_bound(lastState);
      if (it == seedMap.end())
        it = seedMap.begin();
      lastState = it->first;
      unsigned numSeeds = it->second.size();
      ExecutionState &state = *lastState;
      KInstruction *ki = state.pc;
      stepInstruction(state);

      executeInstruction(state, ki);
      processTimers(&state, MaxInstructionTime * numSeeds);
      updateStates(&state);

      if ((stats::instructions % 1000) == 0) {
        int numSeeds = 0, numStates = 0;
        for (std::map<ExecutionState*, std::vector<SeedInfo> >::iterator
               it = seedMap.begin(), ie = seedMap.end();
             it != ie; ++it) {
          numSeeds += it->second.size();
          numStates++;
        }
        double time = util::getWallTime();
        if (SeedTime>0. && time > startTime + SeedTime) {
          klee_warning("seed time expired, %d seeds remain over %d states",
                       numSeeds, numStates);
          break;
        } else if (numSeeds<=lastNumSeeds-10 ||
                   time >= lastTime+10) {
          lastTime = time;
          lastNumSeeds = numSeeds;          
          klee_message("%d seeds remaining over: %d states", 
                       numSeeds, numStates);
        }
      }
    }

    klee_message("seeding done (%d states remain)", (int) states.size());

    // XXX total hack, just because I like non uniform better but want
    // seed results to be equally weighted.
    for (std::set<ExecutionState*>::iterator
           it = states.begin(), ie = states.end();
         it != ie; ++it) {
      (*it)->weight = 1.;
    }

    if (OnlySeed)
      goto dump;
  }

  searcher = constructUserSearcher(*this);

  searcher->update(0, states, std::set<ExecutionState*>());

  while (!states.empty() && !haltExecution) {
    ExecutionState &state = searcher->selectState();
    KInstruction *ki = state.pc;
    stepInstruction(state);

    // lyc modification
    // I would insert a functin here, which checks current instrcution, 
    // to make sure whether it is a vulnerability statement.
    // I will try my best to insert only one line of instrcution to 
    // every place I am going to change in order to make my modification
    // to KLEE be as simple as possible

    BFO_Check(memory, state, ki);
    //printf("BFO_Check was executed!\n");

    //printf("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n");

    executeInstruction(state, ki);
    processTimers(&state, MaxInstructionTime);

    if (MaxMemory) {
      if ((stats::instructions & 0xFFFF) == 0) {
        // We need to avoid calling GetMallocUsage() often because it
        // is O(elts on freelist). This is really bad since we start
        // to pummel the freelist once we hit the memory cap.
        unsigned mbs = sys::Process::GetTotalMemoryUsage() >> 20;
        
        if (mbs > MaxMemory) {
          if (mbs > MaxMemory + 100) {
            // just guess at how many to kill
            unsigned numStates = states.size();
            unsigned toKill = std::max(1U, numStates - numStates*MaxMemory/mbs);

            if (MaxMemoryInhibit)
              klee_warning("killing %d states (over memory cap)",
                           toKill);

            std::vector<ExecutionState*> arr(states.begin(), states.end());
            for (unsigned i=0,N=arr.size(); N && i<toKill; ++i,--N) {
              unsigned idx = rand() % N;

              // Make two pulls to try and not hit a state that
              // covered new code.
              if (arr[idx]->coveredNew)
                idx = rand() % N;

              std::swap(arr[idx], arr[N-1]);
              terminateStateEarly(*arr[N-1], "Memory limit exceeded.");
            }
          }
          atMemoryLimit = true;
        } else {
          atMemoryLimit = false;
        }
      }
    }

    updateStates(&state);
  }

  delete searcher;
  searcher = 0;
  
 dump:
  if (DumpStatesOnHalt && !states.empty()) {
    std::cerr << "KLEE: halting execution, dumping remaining states\n";
    for (std::set<ExecutionState*>::iterator
           it = states.begin(), ie = states.end();
         it != ie; ++it) {
      ExecutionState &state = **it;
      stepInstruction(state); // keep stats rolling
      terminateStateEarly(state, "Execution halting.");
    }
    updateStates(0);
  }
}

std::string Executor::getAddressInfo(ExecutionState &state, 
                                     ref<Expr> address) const{
  std::ostringstream info;
  info << "\taddress: " << address << "\n";
  uint64_t example;
  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(address)) {
    example = CE->getZExtValue();
  } else {
    ref<ConstantExpr> value;
    bool success = solver->getValue(state, address, value);
    assert(success && "FIXME: Unhandled solver failure");
    (void) success;
    example = value->getZExtValue();
    info << "\texample: " << example << "\n";
    std::pair< ref<Expr>, ref<Expr> > res = solver->getRange(state, address);
    info << "\trange: [" << res.first << ", " << res.second <<"]\n";
  }
  
  MemoryObject hack((unsigned) example);    
  MemoryMap::iterator lower = state.addressSpace.objects.upper_bound(&hack);
  info << "\tnext: ";
  if (lower==state.addressSpace.objects.end()) {
    info << "none\n";
  } else {
    const MemoryObject *mo = lower->first;
    std::string alloc_info;
    mo->getAllocInfo(alloc_info);
    info << "object at " << mo->address
         << " of size " << mo->size << "\n"
         << "\t\t" << alloc_info << "\n";
  }
  if (lower!=state.addressSpace.objects.begin()) {
    --lower;
    info << "\tprev: ";
    if (lower==state.addressSpace.objects.end()) {
      info << "none\n";
    } else {
      const MemoryObject *mo = lower->first;
      std::string alloc_info;
      mo->getAllocInfo(alloc_info);
      info << "object at " << mo->address 
           << " of size " << mo->size << "\n"
           << "\t\t" << alloc_info << "\n";
    }
  }

  return info.str();
}

void Executor::terminateState(ExecutionState &state) {
  if (replayOut && replayPosition!=replayOut->numObjects) {
    klee_warning_once(replayOut, 
                      "replay did not consume all objects in test input.");
  }

  interpreterHandler->incPathsExplored();

  std::set<ExecutionState*>::iterator it = addedStates.find(&state);
  if (it==addedStates.end()) {
    state.pc = state.prevPC;

    removedStates.insert(&state);
  } else {
    // never reached searcher, just delete immediately
    std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it3 = 
      seedMap.find(&state);
    if (it3 != seedMap.end())
      seedMap.erase(it3);
    addedStates.erase(it);
    processTree->remove(state.ptreeNode);
    delete &state;
  }
}

void Executor::terminateStateEarly(ExecutionState &state, 
                                   const Twine &message) {
  if (!OnlyOutputStatesCoveringNew || state.coveredNew ||
      (AlwaysOutputSeeds && seedMap.count(&state)))
    interpreterHandler->processTestCase(state, (message + "\n").str().c_str(),
                                        "early");
  terminateState(state);
}

void Executor::terminateStateOnExit(ExecutionState &state) {
  if (!OnlyOutputStatesCoveringNew || state.coveredNew || 
      (AlwaysOutputSeeds && seedMap.count(&state)))
    interpreterHandler->processTestCase(state, 0, 0);
  terminateState(state);
}

void Executor::terminateStateOnError(ExecutionState &state,
                                     const llvm::Twine &messaget,
                                     const char *suffix,
                                     const llvm::Twine &info) {
  std::string message = messaget.str();
  static std::set< std::pair<Instruction*, std::string> > emittedErrors;
  const InstructionInfo &ii = *state.prevPC->info;
  
  if (EmitAllErrors ||
      emittedErrors.insert(std::make_pair(state.prevPC->inst, message)).second) {
    if (ii.file != "") {
      klee_message("ERROR: %s:%d: %s", ii.file.c_str(), ii.line, message.c_str());
    } else {
      klee_message("ERROR: %s", message.c_str());
    }
    if (!EmitAllErrors)
      klee_message("NOTE: now ignoring this error at this location");
    
    std::ostringstream msg;
    msg << "Error: " << message << "\n";
    if (ii.file != "") {
      msg << "File: " << ii.file << "\n";
      msg << "Line: " << ii.line << "\n";
    }
    msg << "Stack: \n";
    state.dumpStack(msg);

    std::string info_str = info.str();
    if (info_str != "")
      msg << "Info: \n" << info_str;
    interpreterHandler->processTestCase(state, msg.str().c_str(), suffix);
  }
    
  terminateState(state);
}

// XXX shoot me
static const char *okExternalsList[] = { "printf", 
                                         "fprintf", 
                                         "puts",
                                         "getpid" };
static std::set<std::string> okExternals(okExternalsList,
                                         okExternalsList + 
                                         (sizeof(okExternalsList)/sizeof(okExternalsList[0])));

void Executor::callExternalFunction(ExecutionState &state,
                                    KInstruction *target,
                                    Function *function,
                                    std::vector< ref<Expr> > &arguments) {
  // check if specialFunctionHandler wants it
  if (specialFunctionHandler->handle(state, function, target, arguments))
    return;
  
  if (NoExternals && !okExternals.count(function->getName())) {
    std::cerr << "KLEE:ERROR: Calling not-OK external function : " 
              << function->getName().str() << "\n";
    terminateStateOnError(state, "externals disallowed", "user.err");
    return;
  }

  // normal external function handling path
  // allocate 128 bits for each argument (+return value) to support fp80's;
  // we could iterate through all the arguments first and determine the exact
  // size we need, but this is faster, and the memory usage isn't significant.
  uint64_t *args = (uint64_t*) alloca(2*sizeof(*args) * (arguments.size() + 1));
  memset(args, 0, 2 * sizeof(*args) * (arguments.size() + 1));
  unsigned wordIndex = 2;
  for (std::vector<ref<Expr> >::iterator ai = arguments.begin(), 
       ae = arguments.end(); ai!=ae; ++ai) {
    if (AllowExternalSymCalls) { // don't bother checking uniqueness
      ref<ConstantExpr> ce;
      bool success = solver->getValue(state, *ai, ce);
      assert(success && "FIXME: Unhandled solver failure");
      (void) success;
      ce->toMemory(&args[wordIndex]);
      wordIndex += (ce->getWidth()+63)/64;
    } else {
      ref<Expr> arg = toUnique(state, *ai);
      if (ConstantExpr *ce = dyn_cast<ConstantExpr>(arg)) {
        // XXX kick toMemory functions from here
        ce->toMemory(&args[wordIndex]);
        wordIndex += (ce->getWidth()+63)/64;
      } else {
        terminateStateOnExecError(state, 
                                  "external call with symbolic argument: " + 
                                  function->getName());
        return;
      }
    }
  }

  state.addressSpace.copyOutConcretes();

  if (!SuppressExternalWarnings) {
    std::ostringstream os;
    os << "calling external: " << function->getName().str() << "(";
    for (unsigned i=0; i<arguments.size(); i++) {
      os << arguments[i];
      if (i != arguments.size()-1)
	os << ", ";
    }
    os << ")";
    
    if (AllExternalWarnings)
      klee_warning("%s", os.str().c_str());
    else
      klee_warning_once(function, "%s", os.str().c_str());
  }
  
  bool success = externalDispatcher->executeCall(function, target->inst, args);
  if (!success) {
    terminateStateOnError(state, "failed external call: " + function->getName(),
                          "external.err");
    return;
  }

  if (!state.addressSpace.copyInConcretes()) {
    terminateStateOnError(state, "external modified read-only object",
                          "external.err");
    return;
  }

  LLVM_TYPE_Q Type *resultType = target->inst->getType();
  if (resultType != Type::getVoidTy(getGlobalContext())) {
    ref<Expr> e = ConstantExpr::fromMemory((void*) args, 
                                           getWidthForLLVMType(resultType));
    bindLocal(target, state, e);
  }
}

/***/

ref<Expr> Executor::replaceReadWithSymbolic(ExecutionState &state, 
                                            ref<Expr> e) {
  unsigned n = interpreterOpts.MakeConcreteSymbolic;
  if (!n || replayOut || replayPath)
    return e;

  // right now, we don't replace symbolics (is there any reason too?)
  if (!isa<ConstantExpr>(e))
    return e;

  if (n != 1 && random() %  n)
    return e;

  // create a new fresh location, assert it is equal to concrete value in e
  // and return it.
  
  static unsigned id;
  const Array *array = new Array("rrws_arr" + llvm::utostr(++id), 
                                 Expr::getMinBytesForWidth(e->getWidth()));
  ref<Expr> res = Expr::createTempRead(array, e->getWidth());
  ref<Expr> eq = NotOptimizedExpr::create(EqExpr::create(e, res));
  std::cerr << "Making symbolic: " << eq << "\n";
  state.addConstraint(eq);
  return res;
}

ObjectState *Executor::bindObjectInState(ExecutionState &state, 
                                         const MemoryObject *mo,
                                         bool isLocal,
                                         const Array *array) {
  ObjectState *os = array ? new ObjectState(mo, array) : new ObjectState(mo);
  state.addressSpace.bindObject(mo, os);

  // Its possible that multiple bindings of the same mo in the state
  // will put multiple copies on this list, but it doesn't really
  // matter because all we use this list for is to unbind the object
  // on function return.
  if (isLocal)
    state.stack.back().allocas.push_back(mo);

  return os;
}

void Executor::executeAlloc(ExecutionState &state,
                            ref<Expr> size,
                            bool isLocal,
                            KInstruction *target,
                            bool zeroMemory,
                            const ObjectState *reallocFrom) {
  size = toUnique(state, size);
  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(size)) {
    MemoryObject *mo = memory->allocate(CE->getZExtValue(), isLocal, false, 
                                        state.prevPC->inst);
    if (!mo) {
      bindLocal(target, state, 
                ConstantExpr::alloc(0, Context::get().getPointerWidth()));
    } else {
      ObjectState *os = bindObjectInState(state, mo, isLocal);
      if (zeroMemory) {
        os->initializeToZero();
      } else {
        os->initializeToRandom();
      }
      bindLocal(target, state, mo->getBaseExpr());
      
      if (reallocFrom) {
        unsigned count = std::min(reallocFrom->size, os->size);
        for (unsigned i=0; i<count; i++)
          os->write(i, reallocFrom->read8(i));
        state.addressSpace.unbindObject(reallocFrom->getObject());
      }
    }
  } else {
    // XXX For now we just pick a size. Ideally we would support
    // symbolic sizes fully but even if we don't it would be better to
    // "smartly" pick a value, for example we could fork and pick the
    // min and max values and perhaps some intermediate (reasonable
    // value).
    // 
    // It would also be nice to recognize the case when size has
    // exactly two values and just fork (but we need to get rid of
    // return argument first). This shows up in pcre when llvm
    // collapses the size expression with a select.

    ref<ConstantExpr> example;
    bool success = solver->getValue(state, size, example);
    assert(success && "FIXME: Unhandled solver failure");
    (void) success;
    
    // Try and start with a small example.
    Expr::Width W = example->getWidth();
    while (example->Ugt(ConstantExpr::alloc(128, W))->isTrue()) {
      ref<ConstantExpr> tmp = example->LShr(ConstantExpr::alloc(1, W));
      bool res;
      bool success = solver->mayBeTrue(state, EqExpr::create(tmp, size), res);
      assert(success && "FIXME: Unhandled solver failure");      
      (void) success;
      if (!res)
        break;
      example = tmp;
    }

    StatePair fixedSize = fork(state, EqExpr::create(example, size), true);
    
    if (fixedSize.second) { 
      // Check for exactly two values
      ref<ConstantExpr> tmp;
      bool success = solver->getValue(*fixedSize.second, size, tmp);
      assert(success && "FIXME: Unhandled solver failure");      
      (void) success;
      bool res;
      success = solver->mustBeTrue(*fixedSize.second, 
                                   EqExpr::create(tmp, size),
                                   res);
      assert(success && "FIXME: Unhandled solver failure");      
      (void) success;
      if (res) {
        executeAlloc(*fixedSize.second, tmp, isLocal,
                     target, zeroMemory, reallocFrom);
      } else {
        // See if a *really* big value is possible. If so assume
        // malloc will fail for it, so lets fork and return 0.
        StatePair hugeSize = 
          fork(*fixedSize.second, 
               UltExpr::create(ConstantExpr::alloc(1<<31, W), size), 
               true);
        if (hugeSize.first) {
          klee_message("NOTE: found huge malloc, returning 0");
          bindLocal(target, *hugeSize.first, 
                    ConstantExpr::alloc(0, Context::get().getPointerWidth()));
        }
        
        if (hugeSize.second) {
          std::ostringstream info;
          ExprPPrinter::printOne(info, "  size expr", size);
          info << "  concretization : " << example << "\n";
          info << "  unbound example: " << tmp << "\n";
          terminateStateOnError(*hugeSize.second, 
                                "concretized symbolic size", 
                                "model.err", 
                                info.str());
        }
      }
    }

    if (fixedSize.first) // can be zero when fork fails
      executeAlloc(*fixedSize.first, example, isLocal, 
                   target, zeroMemory, reallocFrom);
  }
}

void Executor::executeFree(ExecutionState &state,
                           ref<Expr> address,
                           KInstruction *target) {
  StatePair zeroPointer = fork(state, Expr::createIsZero(address), true);
  if (zeroPointer.first) {
    if (target)
      bindLocal(target, *zeroPointer.first, Expr::createPointer(0));
  }
  if (zeroPointer.second) { // address != 0
    ExactResolutionList rl;
    resolveExact(*zeroPointer.second, address, rl, "free");
    
    for (Executor::ExactResolutionList::iterator it = rl.begin(), 
           ie = rl.end(); it != ie; ++it) {
      const MemoryObject *mo = it->first.first;
      if (mo->isLocal) {
        terminateStateOnError(*it->second, 
                              "free of alloca", 
                              "free.err",
                              getAddressInfo(*it->second, address));
      } else if (mo->isGlobal) {
        terminateStateOnError(*it->second, 
                              "free of global", 
                              "free.err",
                              getAddressInfo(*it->second, address));
      } else {
        it->second->addressSpace.unbindObject(mo);
        if (target)
          bindLocal(target, *it->second, Expr::createPointer(0));
      }
    }
  }
}

void Executor::resolveExact(ExecutionState &state,
                            ref<Expr> p,
                            ExactResolutionList &results, 
                            const std::string &name) {
  // XXX we may want to be capping this?
  ResolutionList rl;
  state.addressSpace.resolve(state, solver, p, rl);
  
  ExecutionState *unbound = &state;
  for (ResolutionList::iterator it = rl.begin(), ie = rl.end(); 
       it != ie; ++it) {
    ref<Expr> inBounds = EqExpr::create(p, it->first->getBaseExpr());
    
    StatePair branches = fork(*unbound, inBounds, true);
    
    if (branches.first)
      results.push_back(std::make_pair(*it, branches.first));

    unbound = branches.second;
    if (!unbound) // Fork failure
      break;
  }

  if (unbound) {
    terminateStateOnError(*unbound,
                          "memory error: invalid pointer: " + name,
                          "ptr.err",
                          getAddressInfo(*unbound, p));
  }
}

void Executor::executeMemoryOperation(ExecutionState &state,
                                      bool isWrite,
                                      ref<Expr> address,
                                      ref<Expr> value /* undef if read */,
                                      KInstruction *target /* undef if write */) {
  Expr::Width type = (isWrite ? value->getWidth() : 
                     getWidthForLLVMType(target->inst->getType()));
  unsigned bytes = Expr::getMinBytesForWidth(type);

  if (SimplifySymIndices) {
    if (!isa<ConstantExpr>(address))
      address = state.constraints.simplifyExpr(address);
    if (isWrite && !isa<ConstantExpr>(value))
      value = state.constraints.simplifyExpr(value);
  }

  // fast path: single in-bounds resolution
  ObjectPair op;
  bool success;
  solver->setTimeout(stpTimeout);
  if (!state.addressSpace.resolveOne(state, solver, address, op, success)) {
    address = toConstant(state, address, "resolveOne failure");
    success = state.addressSpace.resolveOne(cast<ConstantExpr>(address), op);
  }
  solver->setTimeout(0);

  if (success) {
    const MemoryObject *mo = op.first;

    if (MaxSymArraySize && mo->size>=MaxSymArraySize) {
      address = toConstant(state, address, "max-sym-array-size");
    }
    
    ref<Expr> offset = mo->getOffsetExpr(address);

    bool inBounds;
    solver->setTimeout(stpTimeout);
    bool success = solver->mustBeTrue(state, 
                                      mo->getBoundsCheckOffset(offset, bytes),
                                      inBounds);
    solver->setTimeout(0);
    if (!success) {
      state.pc = state.prevPC;
      terminateStateEarly(state, "Query timed out (bounds check).");
      return;
    }

    if (inBounds) {
      const ObjectState *os = op.second;
      if (isWrite) {
        if (os->readOnly) {
          terminateStateOnError(state,
                                "memory error: object read only",
                                "readonly.err");
        } else {
          ObjectState *wos = state.addressSpace.getWriteable(mo, os);
          wos->write(offset, value);
        }          
      } else {
        ref<Expr> result = os->read(offset, type);
        
        if (interpreterOpts.MakeConcreteSymbolic)
          result = replaceReadWithSymbolic(state, result);
        
        bindLocal(target, state, result);
      }

      return;
    }
  } 

  // we are on an error path (no resolution, multiple resolution, one
  // resolution with out of bounds)
  
  ResolutionList rl;  
  solver->setTimeout(stpTimeout);
  bool incomplete = state.addressSpace.resolve(state, solver, address, rl,
                                               0, stpTimeout);
  solver->setTimeout(0);
  
  // XXX there is some query wasteage here. who cares?
  ExecutionState *unbound = &state;
  
  for (ResolutionList::iterator i = rl.begin(), ie = rl.end(); i != ie; ++i) {
    const MemoryObject *mo = i->first;
    const ObjectState *os = i->second;
    ref<Expr> inBounds = mo->getBoundsCheckPointer(address, bytes);
    
    StatePair branches = fork(*unbound, inBounds, true);
    ExecutionState *bound = branches.first;

    // bound can be 0 on failure or overlapped 
    if (bound) {
      if (isWrite) {
        if (os->readOnly) {
          terminateStateOnError(*bound,
                                "memory error: object read only",
                                "readonly.err");
        } else {
          ObjectState *wos = bound->addressSpace.getWriteable(mo, os);
          wos->write(mo->getOffsetExpr(address), value);
        }
      } else {
        ref<Expr> result = os->read(mo->getOffsetExpr(address), type);
        bindLocal(target, *bound, result);
      }
    }

    unbound = branches.second;
    if (!unbound)
      break;
  }
  
  // XXX should we distinguish out of bounds and overlapped cases?
  if (unbound) {
    if (incomplete) {
      terminateStateEarly(*unbound, "Query timed out (resolve).");
    } else {
      terminateStateOnError(*unbound,
                            "memory error: out of bound pointer",
                            "ptr.err",
                            getAddressInfo(*unbound, address));
    }
  }
}

void Executor::executeMakeSymbolic(ExecutionState &state, 
                                   const MemoryObject *mo,
                                   const std::string &name) {
  // Create a new object state for the memory object (instead of a copy).
  if (!replayOut) {
    // Find a unique name for this array.  First try the original name,
    // or if that fails try adding a unique identifier.
    unsigned id = 0;
    std::string uniqueName = name;
    while (!state.arrayNames.insert(uniqueName).second) {
      uniqueName = name + "_" + llvm::utostr(++id);
    }
    const Array *array = new Array(uniqueName, mo->size);
    bindObjectInState(state, mo, false, array);
    state.addSymbolic(mo, array);
    
    std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it = 
      seedMap.find(&state);
    if (it!=seedMap.end()) { // In seed mode we need to add this as a
                             // binding.
      for (std::vector<SeedInfo>::iterator siit = it->second.begin(), 
             siie = it->second.end(); siit != siie; ++siit) {
        SeedInfo &si = *siit;
        KTestObject *obj = si.getNextInput(mo, NamedSeedMatching);

        if (!obj) {
          if (ZeroSeedExtension) {
            std::vector<unsigned char> &values = si.assignment.bindings[array];
            values = std::vector<unsigned char>(mo->size, '\0');
          } else if (!AllowSeedExtension) {
            terminateStateOnError(state, 
                                  "ran out of inputs during seeding",
                                  "user.err");
            break;
          }
        } else {
          if (obj->numBytes != mo->size &&
              ((!(AllowSeedExtension || ZeroSeedExtension)
                && obj->numBytes < mo->size) ||
               (!AllowSeedTruncation && obj->numBytes > mo->size))) {
	    std::stringstream msg;
	    msg << "replace size mismatch: "
		<< mo->name << "[" << mo->size << "]"
		<< " vs " << obj->name << "[" << obj->numBytes << "]"
		<< " in test\n";

            terminateStateOnError(state,
                                  msg.str(),
                                  "user.err");
            break;
          } else {
            std::vector<unsigned char> &values = si.assignment.bindings[array];
            values.insert(values.begin(), obj->bytes, 
                          obj->bytes + std::min(obj->numBytes, mo->size));
            if (ZeroSeedExtension) {
              for (unsigned i=obj->numBytes; i<mo->size; ++i)
                values.push_back('\0');
            }
          }
        }
      }
    }
  } else {
    ObjectState *os = bindObjectInState(state, mo, false);
    if (replayPosition >= replayOut->numObjects) {
      terminateStateOnError(state, "replay count mismatch", "user.err");
    } else {
      KTestObject *obj = &replayOut->objects[replayPosition++];
      if (obj->numBytes != mo->size) {
        terminateStateOnError(state, "replay size mismatch", "user.err");
      } else {
        for (unsigned i=0; i<mo->size; i++)
          os->write8(i, obj->bytes[i]);
      }
    }
  }
}

/***/

void Executor::runFunctionAsMain(Function *f,
				 int argc,
				 char **argv,
				 char **envp) {
  std::vector<ref<Expr> > arguments;

  // force deterministic initialization of memory objects
  srand(1);
  srandom(1);
  
  MemoryObject *argvMO = 0;

  // In order to make uclibc happy and be closer to what the system is
  // doing we lay out the environments at the end of the argv array
  // (both are terminated by a null). There is also a final terminating
  // null that uclibc seems to expect, possibly the ELF header?

  int envc;
  for (envc=0; envp[envc]; ++envc) ;

  unsigned NumPtrBytes = Context::get().getPointerWidth() / 8;
  KFunction *kf = kmodule->functionMap[f];
  assert(kf);
  Function::arg_iterator ai = f->arg_begin(), ae = f->arg_end();
  if (ai!=ae) {
    arguments.push_back(ConstantExpr::alloc(argc, Expr::Int32));

    if (++ai!=ae) {
      argvMO = memory->allocate((argc+1+envc+1+1) * NumPtrBytes, false, true,
                                f->begin()->begin());
      
      arguments.push_back(argvMO->getBaseExpr());

      if (++ai!=ae) {
        uint64_t envp_start = argvMO->address + (argc+1)*NumPtrBytes;
        arguments.push_back(Expr::createPointer(envp_start));

        if (++ai!=ae)
          klee_error("invalid main function (expect 0-3 arguments)");
      }
    }
  }

  ExecutionState *state = new ExecutionState(kmodule->functionMap[f]);
  
  if (pathWriter) 
    state->pathOS = pathWriter->open();
  if (symPathWriter) 
    state->symPathOS = symPathWriter->open();


  if (statsTracker)
    statsTracker->framePushed(*state, 0);

  assert(arguments.size() == f->arg_size() && "wrong number of arguments");
  for (unsigned i = 0, e = f->arg_size(); i != e; ++i)
    bindArgument(kf, i, *state, arguments[i]);

  if (argvMO) {
    ObjectState *argvOS = bindObjectInState(*state, argvMO, false);

    for (int i=0; i<argc+1+envc+1+1; i++) {
      MemoryObject *arg;
      
      if (i==argc || i>=argc+1+envc) {
        arg = 0;
      } else {
        char *s = i<argc ? argv[i] : envp[i-(argc+1)];
        int j, len = strlen(s);
        
        arg = memory->allocate(len+1, false, true, state->pc->inst);
        ObjectState *os = bindObjectInState(*state, arg, false);
        for (j=0; j<len+1; j++)
          os->write8(j, s[j]);
      }

      if (arg) {
        argvOS->write(i * NumPtrBytes, arg->getBaseExpr());
      } else {
        argvOS->write(i * NumPtrBytes, Expr::createPointer(0));
      }
    }
  }
  
  initializeGlobals(*state);

  processTree = new PTree(state);
  state->ptreeNode = processTree->root;
  run(*state);
  delete processTree;
  processTree = 0;

  // hack to clear memory objects
  delete memory;
  memory = new MemoryManager();
  
  globalObjects.clear();
  globalAddresses.clear();

  if (statsTracker)
    statsTracker->done();
}

unsigned Executor::getPathStreamID(const ExecutionState &state) {
  assert(pathWriter);
  return state.pathOS.getID();
}

unsigned Executor::getSymbolicPathStreamID(const ExecutionState &state) {
  assert(symPathWriter);
  return state.symPathOS.getID();
}

void Executor::getConstraintLog(const ExecutionState &state,
                                std::string &res,
                                Interpreter::LogType logFormat) {

  std::ostringstream info;

  switch(logFormat)
  {
  case STP:
  {
	  Query query(state.constraints, ConstantExpr::alloc(0, Expr::Bool));
	  char *log = solver->stpSolver->getConstraintLog(query);
	  res = std::string(log);
	  free(log);
  }
	  break;

  case KQUERY:
  {
	  std::ostringstream info;
	  ExprPPrinter::printConstraints(info, state.constraints);
	  res = info.str();
  }
	  break;

  case SMTLIB2:
  {
	  std::ostringstream info;
	  ExprSMTLIBPrinter* printer = createSMTLIBPrinter();
	  printer->setOutput(info);
	  Query query(state.constraints, ConstantExpr::alloc(0, Expr::Bool));
	  printer->setQuery(query);
	  printer->generateOutput();
	  res = info.str();
	  delete printer;
  }
	  break;

  default:
	  klee_warning("Executor::getConstraintLog() : Log format not supported!");
  }

}

bool Executor::getSymbolicSolution(const ExecutionState &state,
                                   std::vector< 
                                   std::pair<std::string,
                                   std::vector<unsigned char> > >
                                   &res) {
  solver->setTimeout(stpTimeout);

  ExecutionState tmp(state);
  if (!NoPreferCex) {
    for (unsigned i = 0; i != state.symbolics.size(); ++i) {
      const MemoryObject *mo = state.symbolics[i].first;
      std::vector< ref<Expr> >::const_iterator pi = 
        mo->cexPreferences.begin(), pie = mo->cexPreferences.end();
      for (; pi != pie; ++pi) {
        bool mustBeTrue;
        bool success = solver->mustBeTrue(tmp, Expr::createIsZero(*pi), 
                                          mustBeTrue);
        if (!success) break;
        if (!mustBeTrue) tmp.addConstraint(*pi);
      }
      if (pi!=pie) break;
    }
  }

  std::vector< std::vector<unsigned char> > values;
  std::vector<const Array*> objects;
  for (unsigned i = 0; i != state.symbolics.size(); ++i)
    objects.push_back(state.symbolics[i].second);
  bool success = solver->getInitialValues(tmp, objects, values);
  solver->setTimeout(0);
  if (!success) {
    klee_warning("unable to compute initial values (invalid constraints?)!");
    ExprPPrinter::printQuery(std::cerr,
                             state.constraints, 
                             ConstantExpr::alloc(0, Expr::Bool));
    return false;
  }
  
  for (unsigned i = 0; i != state.symbolics.size(); ++i)
    res.push_back(std::make_pair(state.symbolics[i].first->name, values[i]));
  return true;
}

void Executor::getCoveredLines(const ExecutionState &state,
                               std::map<const std::string*, std::set<unsigned> > &res) {
  res = state.coveredLines;
}

void Executor::doImpliedValueConcretization(ExecutionState &state,
                                            ref<Expr> e,
                                            ref<ConstantExpr> value) {
  abort(); // FIXME: Broken until we sort out how to do the write back.

  if (DebugCheckForImpliedValues)
    ImpliedValue::checkForImpliedValues(solver->solver, e, value);

  ImpliedValueList results;
  ImpliedValue::getImpliedValues(e, value, results);
  for (ImpliedValueList::iterator it = results.begin(), ie = results.end();
       it != ie; ++it) {
    ReadExpr *re = it->first.get();
    
    if (ConstantExpr *CE = dyn_cast<ConstantExpr>(re->index)) {
      // FIXME: This is the sole remaining usage of the Array object
      // variable. Kill me.
      const MemoryObject *mo = 0; //re->updates.root->object;
      const ObjectState *os = state.addressSpace.findObject(mo);

      if (!os) {
        // object has been free'd, no need to concretize (although as
        // in other cases we would like to concretize the outstanding
        // reads, but we have no facility for that yet)
      } else {
        assert(!os->readOnly && 
               "not possible? read only object with static read?");
        ObjectState *wos = state.addressSpace.getWriteable(mo, os);
        wos->write(CE, it->second);
      }
    }
  }
}

Expr::Width Executor::getWidthForLLVMType(LLVM_TYPE_Q llvm::Type *type) const {
  return kmodule->targetData->getTypeSizeInBits(type);
}

///

Interpreter *Interpreter::create(const InterpreterOptions &opts,
                                 InterpreterHandler *ih) {
  return new Executor(opts, ih);
}

// lyc modification
void Executor :: BFO_Check(MemoryManager * manager, ExecutionState & state, KInstruction *ki){
//      errs()<<"BFO_Checker: entering\n";
	Instruction * ins = ki->inst;
	CallInst * callInst = NULL;
	GetElementPtrInst * getElePtrInst = NULL;
	std::string funcName;

	// Get the line number info of ins
//	errs()<<"BFO_Check: obtaining line numbers\n";
	MDNode * md = ins->getMetadata("dbg");
//	if(!md)printf("Failed to obtain debug infomation\n");
	DILocation dl(md);
//	errs()<<"BFO_Check: finishing obtaining line numbers\n";
	std::string file = dl.getFilename().str();
	unsigned line = dl.getLineNumber();
	char line_str[5];       // I am not sure whether 5 is enough to hold
	sprintf((char *)line_str, "%u", line);
	//errs()<<file<<"\n";
	if(Haschecklist_fileNames && !isCheckFile(file)){
		//errs()<<file<<" not check file\n";
		return;
	}
	/*
	using namespace std;
	char *fileChar;
	int len = file.length();
	fileChar = (char *)malloc((len+1)*sizeof(char));
	file.copy(fileChar,len,0);
	fstream _file;
	_file.open(fileChar,ios::in);
	if(!_file){
		errs()<<file<<" not exit\n";
		return;
	}
	* */
//
	file = file + "_";
	file = file + (const char *)line_str;
	bool hasBFO = false;
	bool isCheckFunc = false;
	bool isArrayBound = false;
//	printf("source file and line number: %s\n", file.c_str());
	// now file is in format like "Core/Executor.c_12"
	// checks whether it is in the checklist
	
	if(GuidedExecutionTag && HasCheckListFile && !isCheckPoint(file))  {
		//errs()<<"BFO_Check:Instruction info :"<<file<<"\n";
		//errs()<<"not checkpoint\n";
		return;
	}
	// Validation type 1: API invocation	
	ExecutionState temp = *(state.branch());
	printf("Hit checkpoint: %s\n", file.c_str());
	if(callInst = dyn_cast<CallInst>(ins)){
		//errs()<<"callInst "<<callInst;
		Function * func = callInst->getCalledFunction();
		//errs()<<"func "<<func
		if(func){
			//func->dump();
			//printf("Function called: %s\n", func->getName());
			funcName = func->getName().str();
			errs()<<"Function called: "<<funcName<<"\n";			
		}
		else {
			// TODO when func is null,we need to strip off any unneeded pointer casts from the specified value, get the original uncasted value.
			Value * val = callInst->getCalledValue();
			//val->dump();
			//i32 @read(i32, i8 *, i32)
			//val->dump() is :
			//i32 (...)* bitcast (i32 (i32, i8*, i32)* @read to i32 (...)*)
			//llvm::Type * ty = val->getType();
			//ty->dump();
			//ty->dump()is:i32 (...)*
			Value * v = val->stripPointerCasts();
			//v->dump();
			//v->dump() is:
			//define i32 @read(i32 %fd, i8* %buf, i32 %count) nounwind
			//const llvm::Type * ty = v->getType();
			//ty->dump();
			//ty->dump()is:i32 (i32, i8*, i32)*
			if(v->hasName()){			
				funcName = v->getNameStr();
				errs()<<"Function called : "<<funcName<<"\n";
			}
		}
		if(funcName == "strcpy" || funcName == "strcat") {
			isCheckFunc = true;
			// print the sizes of the arguments
			//errs()<<"Function called : "<<funcName<<"\n";
			ref<ConstantExpr> op1 = toConstant(state, eval(ki, 1, state).value, "uint64");
			ref<ConstantExpr> op2 = toConstant(state, eval(ki, 2, state).value, "uint64");
			//errs()<<op1->getZExtValue()<<"\n";
			//errs()<<op2->getZExtValue()<<"\n";
			
			//llvm::PointerType *intop1 = dyn_cast<PointerType>(op1), *intop2 = dyn_cast<PointerType>(op2);
			
			//assert(intop1 && intop2);
			
			uint64_t addr_arg1 = op1->getZExtValue();
			uint64_t addr_arg2 = op2->getZExtValue();
			// First decide whether at least one of the two arguments is symbolic value
			MemoryObject * mo_arg1 = manager->findMemoryObjectByAddr(addr_arg1);
			MemoryObject * mo_arg2 = manager->findMemoryObjectByAddr(addr_arg2);
			int iss_src = -1, iss_des = -1;
			if(-1 == state.isSymbolic(mo_arg1) && -1 == state.isSymbolic(mo_arg2)) {
				// neither of the two arguments is symbolic value
				// what do we do? do runtime check and give test case?
				// I don`t think it necessary cause klee is alread
				// able to generate test case for the detected buffer oveflow
				// TODO how??
			}
			if((iss_des = state.isSymbolic(mo_arg1)) != -1) {
	//				errs()<<"Symbolic value:"<<mo_arg1->name<<"\n";
			}
			if((iss_src = state.isSymbolic(mo_arg2)) != -1) {
	//				errs()<<"Symbolic value:"<<mo_arg2->name<<"\n";;
			}
			// Now get the buffer
			BufferObject * des_buf = manager->findBufferByAddr(addr_arg1);
			BufferObject * src_buf = manager->findBufferByAddr(addr_arg2);
			int start_des_index = addr_arg1 - mo_arg1->address, start_src_index = addr_arg2 - mo_arg2->address;
			uint64_t size_des_buf = des_buf->getSize();	// Size of the memory object found by address(the address may be with the memory)
			uint64_t size_src_buf = src_buf->getSize();
			int actual_size_des = size_des_buf, actual_size_src = size_src_buf;
			errs()<<"actual_size_des:"<<actual_size_des<<"\n";
	//		printf("Debug: strcpy: size_des: %u, size_src: %u\n", (unsigned)size_des_buf, (unsigned)size_src_buf);
	//			if(des_buf) {
	//				printf("Destination buffer starting address: %llu\n", des_buf->getStartAddr());
	//				printf("Size: %u\n", size_des_buf);
	//			}
	//			if(src_buf) {
	//				printf("Source buffer starting address: %llu\n", src_buf->getStartAddr());
	//				printf("Size: %u\n", size_src_buf);
	//			}

			// Now we have the information of the buffer, check whether they overflow!!!
			// TODO implement the check algorithm here
			// API 1: strcpy
			if(funcName == "strcpy") {
				// implement the check!!
				// in fact, if the source buffer is not symbolic, 
				// whether buffer overflows is assured
				//const Array * array_src_buf = state.symbolics[iss_src].second;
				//UpdateList ul(array_src_buf, 0);
				// Use ObjectState to manipulate MemoryObject
				const ObjectState * os = state.addressSpace.findObject(src_buf->mo);
				int actual_size_des = size_des_buf /*- start_des_index*/, actual_size_src = size_src_buf /*- start_src_index*/;
				int upper = actual_size_src < actual_size_des? actual_size_src: actual_size_des;
	//				printf("Debug: upper: act_src_size: %d, act_des_size: %d\n", actual_size_src, actual_size_des);
				errs()<<"size_src:"<<actual_size_src<<"\tsize_des:"<<actual_size_des<<"\tupper:"<<upper<<"\n";
				errs()<<"start_src_index: "<<start_src_index<<", start_des_index: "<<start_des_index<<"\n";
				if(iss_src == -1) {
					// if the source buffer is not symbolic
					// omit checking
					//	errs()<<"BO_klee: The source buffer is not symbolic value, omit checking\n";
					//	return;
					int lenSrc=0;
					for(int i = start_src_index; i < start_src_index+actual_size_src; i++) {
						// construct and add the constraints to the path constraint
		//					ref<Expr> read_buf = ReadExpr::create(ul, ConstantExpr::create(i, 32));      // This is previous implementation, but now deemed incorrect
						ref<Expr> read_buf = os->read8(i);
						errs()<<"read_buf:";
						read_buf->dump();
						ref<Expr> bo_constraint = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
						errs()<<"Added new constraint:";
						bo_constraint->dump();
						bo_constraint = temp.constraints.simplifyExpr(bo_constraint);
						if((bo_constraint->getKind() == Expr::Constant)) {
							ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
							if(!constExpr->isTrue()) {
								//errs()<<"expr added failed\n";
								break;
							}
							else{
								lenSrc++;
							}
						}
					}
					errs()<<"lenSrc is :"<<lenSrc<<"\n";
					if(lenSrc >= actual_size_des){
						errs()<<"src is not symbolic,and its length > actual_size_des.\n";
						errs()<<file<<": The overflow may happen here!\n";
						hasBFO = true;
					}
					else{
						errs()<<file<<": The overflow would not happen here!\n";
					}
				}
				else{
				 
					// although the source buffer is no bigger than
					// the destination buffer. However, if source buffer
					// does not end up with '\0', a buffer overflow may also
					// happen.
					// CAUTIONS: fill the buffer starting from addr_arg2. Why? Cause
					// there may be arithmatic operations on the buffer thus in fact, 
					// the actual copied content may not start from the start address of
					// the buffer. For instance: strcpy(a, b + 2); in this case, it is
					// copying the content starting from the third cell in b.
		//				ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
					errs()<<"temp:";
					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
					//errs()<<"state:";
				//	ExprPPrinter::printQuery(std::cerr, state.constraints, ConstantExpr::alloc(0, Expr::Bool));
					bool hasSolution = true, updated = false;
					for(int i = start_src_index; i < upper + start_src_index; i++) {
						// construct and add the constraints to the path constraint
		//					ref<Expr> read_buf = ReadExpr::create(ul, ConstantExpr::create(i, 32));      // This is previous implementation, but now deemed incorrect
						ref<Expr> read_buf = os->read8(i);
						errs()<<"read_buf:";
						read_buf->dump();
						ref<Expr> bo_constraint = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
						errs()<<"Added new constraint:";
						bo_constraint->dump();
						bo_constraint = temp.constraints.simplifyExpr(bo_constraint);
						if((bo_constraint->getKind() == Expr::Constant)) {
							ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
							if(!constExpr->isTrue()) {
								errs()<<"expr added failed\n";
								errs()<<file<<": The overflow would not happen here!\n";
								hasSolution = false;
								updated = false;
								break;
							}
						}
						// Test code: rewriteConstraints()
		//					Constraints::ExprReplaceVisitor visitor(bo_constraint, ConstantExpr::alloc(1, Expr::Bool));
		//					temp.constraints.rewriteConstraints(visitor);
						// Test code: rewriteConstraints()
						else {
							errs()<<"expr added succeed\n";
							temp.addConstraint(bo_constraint);
							updated = true;
						}
					}
					errs()<<"temp:";
					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
				//	errs()<<"state:";
				//	ExprPPrinter::printQuery(std::cerr, state.constraints, ConstantExpr::alloc(0, Expr::Bool));
					// Now the buffer overflow constraints has been added
					std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
		//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
					if(updated) hasSolution = this->getSymbolicSolution(temp, res);
					if(!hasSolution)
						errs()<<file<<": The overflow would not happen here!\n";
					else{
						errs()<<file<<": The overflow may happen here!\n";
						hasBFO = true;
						// Test: try to generate a test caes that will invoke the buffer overflow
						errs()<<"Generating my test cases\n";
						interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(),
							"bfowarning");
						errs()<<"Generating finished\n";
					}
					/*if(updated){
						hasSolution = this->getSymbolicSolution(temp, res);
						if(!hasSolution){
							errs()<<"hasSolution is false, now we negate the overflow constraints and add it to current constraints\n";
							ExecutionState temp2 = *(state.branch());
							errs()<<"temp2:";
							ExprPPrinter::printQuery(std::cerr, temp2.constraints, ConstantExpr::alloc(0, Expr::Bool));
									//updated2 = false;
							bool mark = false;
							for(int i = start_src_index; i < upper + start_src_index; i++) {
								bool hasSolution2 = true;
								ref<Expr> read_buf = os->read8(i);
								errs()<<"read_buf:";
								read_buf->dump();
								ref<Expr> bo_constraint = EqExpr::create(ConstantExpr::create(0, 8), read_buf);
								errs()<<"Added new constraint:";
								bo_constraint->dump();
								bo_constraint = temp2.constraints.simplifyExpr(bo_constraint);
								if((bo_constraint->getKind() == Expr::Constant)) {
									ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
									if(!constExpr->isTrue()) {
										errs()<<"expr added failed\n";
										hasSolution2 = false;
									}
								}
								else {
									errs()<<"expr added succeed\n";
									temp2.addConstraint(bo_constraint);
									hasSolution2 = this->getSymbolicSolution(temp2, res);
								}
								if(hasSolution2){
									errs()<<file<<": The overflow would not happen here!\n";
									mark=true;
									break;
								}
							}
							if(!mark){
								errs()<<file<<": The constranits are too complex,we couldn't jumping to conclusions here!\n";
							}
						}
						else {
							errs()<<file<<": The overflow may happen here!\n";
							// Test: try to generate a test caes that will invoke the buffer overflow
							errs()<<"Generating my test cases\n";
							interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(),
								"bfowarning");
							hasBFO = true;
							errs()<<"Generating finished\n";
						}
					}
					else{
						if(hasSolution){
							errs()<<file<<": The overflow may happen here!\n";
							// Test: try to generate a test caes that will invoke the buffer overflow
							errs()<<"Generating my test cases\n";
							interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(),
								"bfowarning");
							hasBFO = true;
							errs()<<"Generating finished\n";
						}
					}*/

				}
			}
			// API 2: strcat
			/*
			else if(funcName == "strcat") {
				// TODO implement the check!!
				//gfj modification
				//char *strcat(char *dest,char *src)
				//when len(dest)+len(src)>=size(dest),bfo
				const ObjectState * os_des = state.addressSpace.findObject(des_buf->mo);
				const ObjectState * os_src = state.addressSpace.findObject(src_buf->mo);
				int lenDest=0;
				for(int i=start_des_index;i<start_des_index+actual_size_des;i++){
					ref<Expr> read_buf = os_des->read8(i);
					errs()<<"dest read_buf:";
					read_buf->dump();
					ref<Expr> desiEq0 = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
					errs()<<"Added new constraint:";
					desiEq0->dump();
					ExecutionState temp2(state);
					bool hasSolution = false;
					bool updated = false;
					desiEq0 = temp2.constraints.simplifyExpr(desiEq0);
					if((desiEq0->getKind() == Expr::Constant)) {
						ref<ConstantExpr> constExpr = cast<ConstantExpr>(desiEq0);
						if(!constExpr->isTrue()) {
							errs()<<"expr added failed,desti == 0\n";
							hasSolution = false;
							updated = false;
						}
						else{
							errs()<<"it comes here!,desti != 0\n";
							hasSolution = true;
							updated = false;
						}
					}
					else {
						errs()<<"expr added succeed\n";
						temp2.addConstraint(desiEq0);
						updated = true;					
					}
					errs()<<"temp2:";
					ExprPPrinter::printQuery(std::cerr, temp2.constraints, ConstantExpr::alloc(0, Expr::Bool));
					// Now the buffer overflow constraints has been added
					std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
					if(updated)hasSolution = this->getSymbolicSolution(temp2, res);
					if(hasSolution){
						//dest[i]!=0
						lenDest++;
					}else{
						//dest[i]==0
						break;
					}
				}
				errs()<<"len(dest) is :"<<lenDest<<"\n";
				if(lenDest >= actual_size_des){
					errs()<<"lenDest may >= actual_size_des.\n";
					errs()<<file<<": The overflow may happen here!\n";
					hasBFO = true;
					// Test: try to generate a test caes that will invoke the buffer overflow
					errs()<<"Generating my test cases\n";
					interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(), 
						"bfowarning");
					errs()<<"Generating finished\n";
				}
				else{
					actual_size_des = actual_size_des - lenDest;
					int lenSrc=0;
					for(int i=start_src_index;i<start_src_index+actual_size_src;i++){
						ref<Expr> read_buf = os_src->read8(i);
						errs()<<"src read_buf:";
						read_buf->dump();
						ref<Expr> srciEq0 = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
						errs()<<"Added new constraint:";
						srciEq0->dump();
						ExecutionState temp2(state);
						bool hasSolution = false;
						bool updated = false;
						srciEq0 = temp2.constraints.simplifyExpr(srciEq0);
						if((srciEq0->getKind() == Expr::Constant)) {
							ref<ConstantExpr> constExpr = cast<ConstantExpr>(srciEq0);
							if(!constExpr->isTrue()) {
								errs()<<"expr added failed\n";
								hasSolution = false;
								updated = false;
							}
							else{
								errs()<<"it comes here!\n";
								hasSolution = true;
								updated = false;
							}
						}
						else {
							errs()<<"expr added succeed\n";
							temp2.addConstraint(srciEq0);
							updated = true;					
						}
						errs()<<"temp2:";
						ExprPPrinter::printQuery(std::cerr, temp2.constraints, ConstantExpr::alloc(0, Expr::Bool));
						// Now the buffer overflow constraints has been added
						std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
						if(updated)hasSolution = this->getSymbolicSolution(temp2, res);
						if(hasSolution){
							//src[i]!=0
							lenSrc++;
						}else{
							//src[i]==0
							break;
						}
					}
					errs()<<"len(src) is :"<<lenSrc<<"\n";
					if(lenSrc == actual_size_src){
						errs()<<"there isn't a \\0 in src.\n";
						errs()<<file<<": The overflow may happen here!\n";
						hasBFO = true;
						// Test: try to generate a test caes that will invoke the buffer overflow
						errs()<<"Generating my test cases\n";
						interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(), 
							"bfowarning");
						errs()<<"Generating finished\n";
					}else{
						if(lenSrc >= actual_size_des){
							errs()<<"lenSrc+lenDes may >= actual_size_des.\n";
							errs()<<file<<": The overflow may happen here!\n";
							hasBFO = true;
							// Test: try to generate a test caes that will invoke the buffer overflow
							errs()<<"Generating my test cases\n";
							interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(), 
								"bfowarning");
							errs()<<"Generating finished\n";
						}else{
							errs()<<"lenSrc+lenDes < actual_size_des.\n";
							errs()<<file<<": The overflow would not happen here!\n";
							hasBFO = false;
						}
					}
				}
			}
			*/
			else if(funcName == "strcat") {
				// TODO implement the check!!
				//gfj modification
				// Use ObjectState to manipulate MemoryObject
				const ObjectState * os_src = state.addressSpace.findObject(src_buf->mo);
				const ObjectState * os_des = state.addressSpace.findObject(des_buf->mo);
				int actual_size_des = size_des_buf , actual_size_src = size_src_buf;
				errs()<<"actual_size_des:"<<actual_size_des<<"\n";
				ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));

				if(iss_des == -1) {
					// if the destination buffer is not symbolic
					int cnt = 0;
					for(int j = start_des_index;j < start_des_index + actual_size_des; j++){
						ref<Expr> read_buf = os_des->read8(j);
						errs()<<"j:"<<j;
						errs()<<"read_buf:";
						read_buf->dump();
						if(read_buf.operator ==(ConstantExpr::create(0, 8))) {
							errs()<<"equal 0,break\n";
							break;
						}
						else cnt++;
					}
					if(cnt == actual_size_des){
						errs()<<"There is not a \\0 in the destination buffer!\n";
						errs()<<": The overflow may happen here!\n";
						hasBFO = true;
						//return;
					}
					else{
						actual_size_des = actual_size_des - cnt;
						int upper = actual_size_des < actual_size_src ? actual_size_des : actual_size_src;
						bool hasSolution = true, updated = false;
						for(int i = start_src_index; i < upper + start_src_index; i++) {
							ref<Expr> read_buf = os_src->read8(i);
							errs()<<"read_buf:";
							read_buf->dump();
							ref<Expr> bo_constraint = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
							errs()<<"Added new constraint:";
							bo_constraint->dump();
							bo_constraint = temp.constraints.simplifyExpr(bo_constraint);
							if((bo_constraint->getKind() == Expr::Constant)) {
								ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
								if(!constExpr->isTrue()) {
									errs()<<"expr added failed\n";
									hasSolution = false;
									updated = false;
									break;
								}
							}
							else {
								errs()<<"expr added succeed\n";
								temp.addConstraint(bo_constraint);
								updated = true;
							}
						}
						ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));

						// Now the buffer overflow constraints has been added
						std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
		//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
						if(updated)hasSolution = this->getSymbolicSolution(temp, res);
						if(!hasSolution)
							errs()<<file<<": The overflow would not happen here!\n";
						else{
							errs()<<file<<": The overflow may happen here!\n";
							hasBFO = true;
							// Test: try to generate a test caes that will invoke the buffer overflow
							errs()<<"Generating my test cases\n";
							interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(), 
								"bfowarning");
							errs()<<"Generating finished\n";
						}
					}
				}
				else if(iss_src == -1) {
					// if the source buffer is not symbolic
					//
					int cnt = 0;
					for(int j = start_src_index;j < start_src_index + actual_size_src; j++){
						ref<Expr> read_buf = os_src->read8(j);
						//errs()<<"j:"<<j;
						//errs()<<"read_buf:";
						//read_buf->dump();
						if(read_buf.operator ==(ConstantExpr::create(0, 8))) {
							errs()<<"equal 0,break\n";
							break;
						}
						else cnt++;
					}
					if(cnt == actual_size_src){
						errs()<<"There is not a 0 in the source buffer!\n";
						errs()<<": The overflow may happen here!\n";
						hasBFO = true;
						//return;
					}
					else{
						int upper = actual_size_des - cnt;
						errs()<<"upper:"<<upper<<"\n";
						bool hasSolution = true, updated = false;
						for(int i = start_des_index; i < start_des_index + upper; i++) {
							errs()<<"i:"<<i;
							ref<Expr> read_buf = os_des->read8(i);
							errs()<<"read_buf:";
							read_buf->dump();
							ref<Expr> bo_constraint = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
							errs()<<"Added new constraint:";
							bo_constraint->dump();
							bo_constraint = temp.constraints.simplifyExpr(bo_constraint);
							if((bo_constraint->getKind() == Expr::Constant)) {
								ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
								if(!constExpr->isTrue()) {
									errs()<<"expr added failed\n";
									hasSolution = false;
									updated = false;
									break;
								}
							}
							else {
								errs()<<"expr added succeed\n";
								temp.addConstraint(bo_constraint);
								updated = true;
							}
						}
						ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));

						// Now the buffer overflow constraints has been added
						std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
		//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
						if(updated)hasSolution = this->getSymbolicSolution(temp, res);
						if(!hasSolution)
							errs()<<file<<": The overflow would not happen here!\n";
						else{
							errs()<<file<<": The overflow may happen here!\n";
							hasBFO = true;
							// Test: try to generate a test caes that will invoke the buffer overflow
							errs()<<"Generating my test cases\n";
							interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(), 
								"bfowarning");
							errs()<<"Generating finished\n";		
						}
					}
				}

				//both of the src & des are symbolic
				else{
					bool hasSolution = true, updated = false;
					for(int k = start_des_index; k < start_des_index + actual_size_des; k++) {
						ExecutionState temp2(state);
						//ExprPPrinter::printQuery(std::cerr, temp2.constraints, ConstantExpr::alloc(0, Expr::Bool));
						int upper = actual_size_src < (k + 1 - start_des_index) ? actual_size_src : (k + 1 - start_des_index);
						errs()<<"k:"<<k;
						int j;
						for(j = start_src_index;j < start_src_index + upper;j++){
							ref<Expr> read_buf = os_src->read8(j);
							errs()<<"j:"<<j;
							errs()<<"read_buf:";
							read_buf->dump();
							ref<Expr> bo_constraint = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
							errs()<<"Added new constraint:";
							bo_constraint->dump();
							bo_constraint = temp2.constraints.simplifyExpr(bo_constraint);
							if((bo_constraint->getKind() == Expr::Constant)) {
								ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
								if(!constExpr->isTrue()) {
									errs()<<"expr added failed,exit cycle\n";
									hasSolution = false;
									updated = false;
									j++;
									break;
								}
								else{
									errs()<<"it comes here!\n";

								}
							}else {
								errs()<<"expr added succeed\n";
								temp2.addConstraint(bo_constraint);
								updated = true;
							}
						}
						//when j== actual_size_src,means there is not a \0 in source buffer
						//errs()<<"j:"<<j;
						//if(hasSolution == true && j != actual_size_src && actual_size_des-k-1 > start_des_index){
						if(hasSolution == true && j != actual_size_src && start_des_index+actual_size_des-(k-start_des_index)-1 > start_des_index){
							for(int i = start_des_index; i < start_des_index+actual_size_des-(k-start_des_index)-1; i++){
								errs()<<"i:"<<i;
								ref<Expr> read_buf = os_des->read8(i);
								errs()<<"read_buf:";
								read_buf->dump();
								ref<Expr> bo_constraint = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
								errs()<<"Added new constraint:";
								bo_constraint->dump();
								bo_constraint = temp2.constraints.simplifyExpr(bo_constraint);
								if((bo_constraint->getKind() == Expr::Constant)) {
									ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
									if(!constExpr->isTrue()) {
										errs()<<"expr added failed,exit cycle\n";
										hasSolution = false;
										updated = false;
										break;
									}
									else{
										errs()<<"it comes here!\n";

									}
								}
								else {
									errs()<<"expr added succeed\n";
									temp2.addConstraint(bo_constraint);
									updated = true;

								}
							}
						}
					//	errs()<<"temp:";
						//ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
						errs()<<"temp2:";
						ExprPPrinter::printQuery(std::cerr, temp2.constraints, ConstantExpr::alloc(0, Expr::Bool));

						// Now the buffer overflow constraints has been added
						std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
		//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
						if(updated)hasSolution = this->getSymbolicSolution(temp2, res);
						if(!hasSolution)
							errs()<<file<<": The overflow would not happen here!\n";
						else{
							errs()<<file<<": The overflow may happen here!\n";
							hasBFO = true;
							// Test: try to generate a test caes that will invoke the buffer overflow
							errs()<<"Generating my test cases\n";
							interpreterHandler->processTestCase(temp2, (file + "Buffer overflow error is found here").c_str(), 
								"bfowarning");
							errs()<<"Generating finished\n";
						}
						if(j == actual_size_src) break;
						errs()<<"not break\n";
					}
				}

			}
		}
		else if(funcName == "memset"){
			isCheckFunc = true;
			//memset(void *s, int ch, size_t n);
			//when n > size(s),bfo
			ref<ConstantExpr> op1 = toConstant(state, eval(ki, 1, state).value, "uint64");
			ref<Expr> op3 = eval(ki, 3, state).value;
			errs()<<"the third operation:\n";
			op3->dump();
			uint64_t addr_arg1 = op1->getZExtValue();
			MemoryObject * mo_arg1 = manager->findMemoryObjectByAddr(addr_arg1);
			// Now get the buffer
			BufferObject * des_buf = manager->findBufferByAddr(addr_arg1);
		//	int start_des_index = addr_arg1 - mo_arg1->address;
			uint64_t size_des_buf = des_buf->getSize();	// Size of the memory object found by address(the address may be with the memory)
			// Use ObjectState to manipulate MemoryObject
		//	const ObjectState * os_des = state.addressSpace.findObject(des_buf->mo);
			int actual_size_des = size_des_buf/* - start_des_index*/;
			errs()<<"actual_size_des:"<<actual_size_des<<"\n";
			//int upper = actual_size_src < actual_size_des? actual_size_src: actual_size_des;
			ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
			if(op3->getKind() == Expr::Constant){
				ref<ConstantExpr> constop3 = cast<ConstantExpr>(op3);
				errs()<<"op3 is constant\n";
				uint64_t addr_op3 = constop3->getZExtValue();
				errs()<<"addr_op3:"<<addr_op3;
				if(addr_op3 > actual_size_des){
					errs()<<file<<": The overflow may happen here!\n";
					hasBFO = true;
					
				}
				else{
					errs()<<file<<": The overflow would not happen here!\n";
				}
			}
			else{
				ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
				bool hasSolution = true;
				ref<Expr> bo_constraint = SgtExpr::create(op3,ConstantExpr::create(actual_size_des, 32));
				errs()<<"Added new constraint:";
				bo_constraint->dump();
				bo_constraint = temp.constraints.simplifyExpr(bo_constraint);
				if((bo_constraint->getKind() == Expr::Constant)) {
					ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
					if(!constExpr->isTrue()) {
						errs()<<"expr added failed\n";
						errs()<<file<<": The overflow would not happen here!\n";
						//return;
					}else{
						errs()<<file<<": The overflow may happen here!\n";
						hasBFO = true;
						//return;
					}
				}
				else {
					errs()<<"expr added succeed\n";
					temp.addConstraint(bo_constraint);
					errs()<<"temp:";
					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));

					// Now the buffer overflow constraints has been added
					std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
	//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
					hasSolution = this->getSymbolicSolution(temp, res);
					if(!hasSolution)
						errs()<<file<<": The overflow would not happen here!\n";
					else{
						errs()<<file<<": The overflow may happen here!\n";
						hasBFO = true;
						// Test: try to generate a test caes that will invoke the buffer overflow
						errs()<<"Generating my test cases\n";
						interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(), 
							"bfowarning");
						errs()<<"Generating finished\n";
					}
				}
			}
		}
		// API 3: .. memory access APIs
		else if(funcName == "memcpy" || funcName == "strncpy" || funcName == "strncat" || funcName == "memmove") {
			// TODO implement me
			//gfj modification
			isCheckFunc = true;
			ref<ConstantExpr> op1 = toConstant(state, eval(ki, 1, state).value, "uint64");
			ref<ConstantExpr> op2 = toConstant(state, eval(ki, 2, state).value, "uint64");
			//ref<ConstantExpr> op3 = toConstant(state, eval(ki, 3, state).value, "uint64");
			ref<Expr> op3 = eval(ki, 3, state).value;
			errs()<<"the third operation:\n";
			op3->dump();

			uint64_t addr_arg1 = op1->getZExtValue();
			uint64_t addr_arg2 = op2->getZExtValue();

			// First decide whether at least one of the two arguments is symbolic value
			MemoryObject * mo_arg1 = manager->findMemoryObjectByAddr(addr_arg1);
			MemoryObject * mo_arg2 = manager->findMemoryObjectByAddr(addr_arg2);
			int iss_src = -1, iss_des = -1;
			//if(-1 == state.isSymbolic(mo_arg1) && -1 == state.isSymbolic(mo_arg2) && op3->getKind() == Expr::Constant) {
				// neither of the two arguments is symbolic value
				// what do we do? do runtime check and give test case?
				// I don`t think it necessary cause klee is alread
				// able to generate test case for the detected buffer oveflow
				// TODO how??
				//return;
			//}

			//if((iss_des = state.isSymbolic(mo_arg1)) != -1) {
	//				errs()<<"Symbolic value:"<<mo_arg1->name<<"\n";
			//}
			//if((iss_src = state.isSymbolic(mo_arg2)) != -1) {
	//				errs()<<"Symbolic value:"<<mo_arg2->name<<"\n";;
			//}
			// Now get the buffer
			BufferObject * des_buf = manager->findBufferByAddr(addr_arg1);
			BufferObject * src_buf = manager->findBufferByAddr(addr_arg2);
			int start_des_index = addr_arg1 - mo_arg1->address, start_src_index = addr_arg2 - mo_arg2->address;
			uint64_t size_des_buf = des_buf->getSize();	// Size of the memory object found by address(the address may be with the memory)
			uint64_t size_src_buf = src_buf->getSize();
			// Use ObjectState to manipulate MemoryObject
			const ObjectState * os_src = state.addressSpace.findObject(src_buf->mo);
			const ObjectState * os_des = state.addressSpace.findObject(des_buf->mo);
			int actual_size_des = size_des_buf/* - start_des_index*/, actual_size_src = size_src_buf/* - start_src_index*/;
			errs()<<"actual_size_des:"<<actual_size_des<<"\n";
			//int upper = actual_size_src < actual_size_des? actual_size_src: actual_size_des;
			ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));

			if(funcName == "memcpy" || funcName == "memmove"){
				// TODO when function called is memcpy
				//void *memcpy(void*dest, const void *src, size_t n);
				//void *memmove(void *dest, const void *src, unsigned int count);
				//bfo when n > size(dest)
				if(op3->getKind() == Expr::Constant){
					ref<ConstantExpr> constop3 = cast<ConstantExpr>(op3);
					//errs()<<"op3 is constant\n";
					uint64_t addr_op3 = constop3->getZExtValue();
					//errs()<<"addr_op3:"<<addr_op3;
					if(addr_op3 > actual_size_des){
						errs()<<"op3 > size(dest)\n";
						errs()<<file<<": The overflow may happen here!\n";
						hasBFO = true;
					}
					else{
						errs()<<file<<": The overflow would not happen here!\n";
					}
				}
				else{
					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
					bool hasSolution = true;
					ref<Expr> bo_constraint = UltExpr::create(ConstantExpr::create(actual_size_des, 32),op3);
					errs()<<"Added new constraint:";
					bo_constraint->dump();
					bo_constraint = temp.constraints.simplifyExpr(bo_constraint);
					if((bo_constraint->getKind() == Expr::Constant)) {
						ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
						if(!constExpr->isTrue()) {
							errs()<<"expr added failed\n";
							errs()<<file<<": The overflow would not happen here!\n";
						}else{
							errs()<<file<<": The overflow may happen here!\n";
							hasBFO = true;
						}
					}
					else {
						errs()<<"expr added succeed\n";
						temp.addConstraint(bo_constraint);
						errs()<<"temp:";
						ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));

						// Now the buffer overflow constraints has been added
						std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
		//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
						hasSolution = this->getSymbolicSolution(temp, res);
						if(!hasSolution){
							errs()<<file<<": The overflow would not happen here!\n";
							//hasBFO = false;
						}
						else{
							errs()<<file<<": The overflow may happen here!\n";
							hasBFO = true;
							// Test: try to generate a test caes that will invoke the buffer overflow
							errs()<<"Generating my test cases\n";
							interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(), 
								"bfowarning");
							errs()<<"Generating finished\n";
						}
					}
				}
			

			}

			else if(funcName == "strncpy"){
				// TODO when function called is strncpy
				//char *strncpy(char *dest, const char *src, size_t n);
				//bfo when n > size(dest)
				//if(iss_src == -1 && op3->getKind() == Expr::Constant){
					//if the source buffer is not symbolic
					//omit checking
					//return;
				//}
				if(op3->getKind() == Expr::Constant){
					ref<ConstantExpr> constop3 = cast<ConstantExpr>(op3);
					errs()<<"op3 is constant\n";
					uint64_t val_op3 = constop3->getZExtValue();
					errs()<<"val_op3:"<<val_op3;
					//op3>des
					//bufferoverflow
					if(val_op3 > actual_size_des){
						errs()<<"n > actual_size_des.\n";
						errs()<<file<<": The overflow may happen here!\n";
						hasBFO = true;
						//return;
					}else{
						errs()<<file<<": The overflow would not happen here!\n";
						//hasBFO = false;
					}		
				}
				else{
					//deal with symbolic n
					ref<Expr> op3CmpDes = SgtExpr::create(op3,ConstantExpr::create(actual_size_des,32));
					//op3>des
					//bufferoverflow
					//ExecutionState temp1(state);
					bool hasSolution = false;
					errs()<<"Added new constraint:";
					op3CmpDes->dump();
					op3CmpDes = temp.constraints.simplifyExpr(op3CmpDes);

					if((op3CmpDes->getKind() == Expr::Constant)) {
						ref<ConstantExpr> constExpr = cast<ConstantExpr>(op3CmpDes);
						if(!constExpr->isTrue()) {
							//errs()<<"it comes here,op3<=des\n";
							hasSolution = false;
						}else{
							//errs()<<"it comes here,true\n";
						}
					}
					else {
						temp.addConstraint(op3CmpDes);
						errs()<<"temp:";
						ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
						// Now the buffer overflow constraints has been added
						std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
						hasSolution = this->getSymbolicSolution(temp, res);
					}
					if(!hasSolution){
							errs()<<file<<": The overflow would not happen here!\n";
					}
					else{
						//errs()<<"op3>des\n";
						errs()<<file<<": The overflow may happen here!\n";
						hasBFO = true;
						// Test: try to generate a test caes that will invoke the buffer overflow
						errs()<<"Generating my test cases\n";
						interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(), 
							"bfowarning");
						errs()<<"Generating finished\n";
					}
				}

			}
			else if(funcName == "strncat"){
				// TODO when function called is strncat
				if(op3->getKind() == Expr::Constant){
					ref<ConstantExpr> constop3 = cast<ConstantExpr>(op3);
					errs()<<"op3 is constant\n";
					uint64_t addr_op3 = constop3->getZExtValue();
					errs()<<"addr_op3:"<<addr_op3;
					int minOp3Src = addr_op3 < actual_size_src ? addr_op3 : actual_size_src;
					bool hasSolution = true, updated = false;
					for(int k = start_des_index; k < start_des_index+actual_size_des; k++) {
						ExecutionState temp2(state);
						//ExprPPrinter::printQuery(std::cerr, temp2.constraints, ConstantExpr::alloc(0, Expr::Bool));
						int upper = minOp3Src < (k + 1 - start_des_index) ? minOp3Src : (k + 1 - start_des_index);
						errs()<<"k:"<<k;
						int j;
						for(j = start_src_index;j < start_src_index+upper;j++){
							ref<Expr> read_buf = os_src->read8(j);
							errs()<<"j:"<<j;
							errs()<<"read_buf:";
							read_buf->dump();
							ref<Expr> bo_constraint = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
							errs()<<"Added new constraint:";
							bo_constraint->dump();
							bo_constraint = temp2.constraints.simplifyExpr(bo_constraint);
							if((bo_constraint->getKind() == Expr::Constant)) {
								ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
								if(!constExpr->isTrue()) {
									errs()<<"expr added failed,exit cycle\n";
									hasSolution = false;
									updated = false;
									j++;
									break;
								}
								else{
									errs()<<"it comes here!\n";

								}
							}else {
								errs()<<"expr added succeed\n";
								temp2.addConstraint(bo_constraint);
								updated = true;
							}
						}
						//errs()<<"j:"<<j;
						if(hasSolution == true && j != minOp3Src && start_des_index+actual_size_des-(k-start_des_index)-1 > start_des_index){
							for(int i = start_des_index; i < start_des_index+actual_size_des-(k-start_des_index)-1; i++){
								errs()<<"i:"<<i;
								ref<Expr> read_buf = os_des->read8(i);
								errs()<<"read_buf:";
								read_buf->dump();
								ref<Expr> bo_constraint = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
								errs()<<"Added new constraint:";
								bo_constraint->dump();
								bo_constraint = temp2.constraints.simplifyExpr(bo_constraint);
								if((bo_constraint->getKind() == Expr::Constant)) {
									ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
									if(!constExpr->isTrue()) {
										errs()<<"expr added failed,exit cycle\n";
										hasSolution = false;
										updated = false;
										break;
									}
									else{
										errs()<<"it comes here!\n";

									}
								}
								else {
									errs()<<"expr added succeed\n";
									temp2.addConstraint(bo_constraint);
									updated = true;

								}
							}
						}
					//	errs()<<"temp:";
						//ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
						errs()<<"temp2:";
						ExprPPrinter::printQuery(std::cerr, temp2.constraints, ConstantExpr::alloc(0, Expr::Bool));

						// Now the buffer overflow constraints has been added
						std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
		//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
						if(updated)hasSolution = this->getSymbolicSolution(temp2, res);
						if(!hasSolution)
							errs()<<file<<": The overflow would not happen here!\n";
						else{
							errs()<<file<<": The overflow may happen here!\n";
							hasBFO = true;
							// Test: try to generate a test caes that will invoke the buffer overflow
							errs()<<"Generating my test cases\n";
							interpreterHandler->processTestCase(temp2, (file + "Buffer overflow error is found here").c_str(), 
								"bfowarning");
							errs()<<"Generating finished\n";
						}
						if(j == actual_size_src) break;
						errs()<<"not break\n";
					}
				}

				//op3 is symbolic
				else{
					bool op3SgtSrc = true;
					//bool hasSolution = true,updated = false;
					ExecutionState temp22(state);
					errs()<<"temp22:";
					ExprPPrinter::printQuery(std::cerr, temp22.constraints, ConstantExpr::alloc(0, Expr::Bool));
					ref<Expr> op3CmpSrc = SgtExpr::create(op3,ConstantExpr::create(actual_size_src,32));
					errs()<<"Added new constraint:";
					op3CmpSrc->dump();
					op3CmpSrc = temp22.constraints.simplifyExpr(op3CmpSrc);
					if((op3CmpSrc->getKind() == Expr::Constant)) {
						ref<ConstantExpr> constExpr1 = cast<ConstantExpr>(op3CmpSrc);
						if(!constExpr1->isTrue()) {
							errs()<<"op3<=Src\n";
							op3SgtSrc = false;
						}else{
							errs()<<"it comes here,op3>Src,has solution\n";
						}
					}
					else {
						temp22.addConstraint(op3CmpSrc);
						errs()<<"temp22:";
						ExprPPrinter::printQuery(std::cerr, temp22.constraints, ConstantExpr::alloc(0, Expr::Bool));

						// Now the buffer overflow constraints has been added
						std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
						op3SgtSrc = this->getSymbolicSolution(temp22, res);

					}
					//op3>src
					//same as strcat
					if(op3SgtSrc){
						bool hasSolution = true, updated = false;
						for(int k = start_des_index; k < start_des_index+actual_size_des; k++) {
							ExecutionState temp2(state);
							//ExprPPrinter::printQuery(std::cerr, temp2.constraints, ConstantExpr::alloc(0, Expr::Bool));
							int upper = actual_size_src < (k + 1 - start_des_index) ? actual_size_src : (k + 1 - start_des_index);
							errs()<<"k:"<<k;
							int j;
							for(j = start_src_index;j < start_src_index+upper;j++){
								ref<Expr> read_buf = os_src->read8(j);
								errs()<<"j:"<<j;
								errs()<<"read_buf:";
								read_buf->dump();
								ref<Expr> bo_constraint = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
								errs()<<"Added new constraint:";
								bo_constraint->dump();
								bo_constraint = temp2.constraints.simplifyExpr(bo_constraint);
								if((bo_constraint->getKind() == Expr::Constant)) {
									ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
									if(!constExpr->isTrue()) {
										errs()<<"expr added failed,exit cycle\n";
										hasSolution = false;
										updated = false;
										j++;
										break;
									}
									else{
										errs()<<"it comes here!\n";

									}
								}else {
									errs()<<"expr added succeed\n";
									temp2.addConstraint(bo_constraint);
									updated = true;
								}
							}
							//errs()<<"j:"<<j;
							if(hasSolution == true && j != actual_size_src && start_des_index+actual_size_des-(k-start_des_index)-1 > start_des_index){
								for(int i = start_des_index; i < start_des_index+actual_size_des-(k-start_des_index)-1; i++){
									errs()<<"i:"<<i;
									ref<Expr> read_buf = os_des->read8(i);
									errs()<<"read_buf:";
									read_buf->dump();
									ref<Expr> bo_constraint = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
									errs()<<"Added new constraint:";
									bo_constraint->dump();
									bo_constraint = temp2.constraints.simplifyExpr(bo_constraint);
									if((bo_constraint->getKind() == Expr::Constant)) {
										ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
										if(!constExpr->isTrue()) {
											errs()<<"expr added failed,exit cycle\n";
											hasSolution = false;
											updated = false;
											break;
										}
										else{
											errs()<<"it comes here!\n";

										}
									}
									else {
										errs()<<"expr added succeed\n";
										temp2.addConstraint(bo_constraint);
										updated = true;

									}
								}
							}
						//	errs()<<"temp:";
							//ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
							errs()<<"temp2:";
							ExprPPrinter::printQuery(std::cerr, temp2.constraints, ConstantExpr::alloc(0, Expr::Bool));

							// Now the buffer overflow constraints has been added
							std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
			//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
							if(updated)hasSolution = this->getSymbolicSolution(temp2, res);
							if(!hasSolution)
								errs()<<file<<": The overflow would not happen here!\n";
							else{
								errs()<<file<<": The overflow may happen here!\n";
								hasBFO = true;
								// Test: try to generate a test caes that will invoke the buffer overflow
								errs()<<"Generating my test cases\n";
								interpreterHandler->processTestCase(temp2, (file + "Buffer overflow error is found here").c_str(), 
									"bfowarning");
								errs()<<"Generating finished\n";
							}
							if(j == actual_size_src) break;
							errs()<<"not break\n";
						}
					}
					//op3<=src,
					//we check op3 instead of srclength
					else{
						bool hasSolution = true, updated = false;
						for(int k = start_des_index; k < start_des_index+actual_size_des; k++) {
							ExecutionState temp2(state);
							//ExprPPrinter::printQuery(std::cerr, temp2.constraints, ConstantExpr::alloc(0, Expr::Bool));
							//int upper = actual_size_src < (k + 1) ? actual_size_src : (k + 1);
							errs()<<"k:"<<k;
							int j = start_src_index;
							errs()<<"start_src_index:"<<start_src_index<<"\n";
							while(1){
								ref<Expr> read_buf = os_src->read8(j);
								errs()<<"j:"<<j;
								errs()<<"read_buf:";
								read_buf->dump();
								ref<Expr> bo_constraint = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
								errs()<<"Added new constraint:";
								bo_constraint->dump();
								bo_constraint = temp2.constraints.simplifyExpr(bo_constraint);
								if((bo_constraint->getKind() == Expr::Constant)) {
									ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
									if(!constExpr->isTrue()) {
										errs()<<"expr added failed,exit cycle\n";
										hasSolution = false;
										updated = false;
										j++;
										break;
									}
									else{
										errs()<<"it comes here!\n";

									}
								}else {
									errs()<<"expr added succeed\n";
									temp2.addConstraint(bo_constraint);
									updated = true;
								}
								j++;
								if(j>k) break;
								ExecutionState temp4(state);
								errs()<<"temp4:";
								ExprPPrinter::printQuery(std::cerr, temp4.constraints, ConstantExpr::alloc(0, Expr::Bool));
								bool op3Slej = true;
								ref<Expr> op3Cmpj = SleExpr::create(op3,ConstantExpr::create(j-start_src_index,32));
								errs()<<"Added new constraint:";
								op3Cmpj->dump();
								op3Cmpj = temp4.constraints.simplifyExpr(op3Cmpj);
								if((op3Cmpj->getKind() == Expr::Constant)) {
									ref<ConstantExpr> constExpr = cast<ConstantExpr>(op3Cmpj);
									if(!constExpr->isTrue()) {
										errs()<<"op3>i\n";
										op3Slej = false;
									}else{
										errs()<<"it comes here,op3<="<<j-start_src_index<<"break\n";
										break;
									}
								}

							}
							//when j== actual_size_src,means ther is not a \0 in source buffer
							//errs()<<"j:"<<j;
		/*					ExecutionState temp3(state);
							bool op3eqj = true;
							ref<Expr> op3Eqj = EqExpr::create(op3,ConstantExpr::create(j,32));
							errs()<<"Added new constraint:";
							op3Cmpj->dump();
							op3Cmpj = temp4.constraints.simplifyExpr(op3Cmpj);
							if((op3Cmpj->getKind() == Expr::Constant)) {
								ref<ConstantExpr> constExpr = cast<ConstantExpr>(op3Cmpj);
								if(!constExpr->isTrue()) {
									errs()<<"op3>i\n";
									op3Slej = false;
								}else{
									errs()<<"it comes here,op3<="<<j<<"break\n";
									break;
								}
							}*/
							if(hasSolution == true && start_des_index+actual_size_des-(k-start_des_index)-1 > start_des_index){
								for(int i = start_des_index; i < start_des_index+actual_size_des-(k-start_des_index)-1; i++){
									errs()<<"i:"<<i;
									ref<Expr> read_buf = os_des->read8(i);
									errs()<<"read_buf:";
									read_buf->dump();
									ref<Expr> bo_constraint = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
									errs()<<"Added new constraint:";
									bo_constraint->dump();
									bo_constraint = temp2.constraints.simplifyExpr(bo_constraint);
									if((bo_constraint->getKind() == Expr::Constant)) {
										ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
										if(!constExpr->isTrue()) {
											errs()<<"expr added failed,exit cycle\n";
											hasSolution = false;
											updated = false;
											break;
										}
										else{
											errs()<<"it comes here!\n";

										}
									}
									else {
										errs()<<"expr added succeed\n";
										temp2.addConstraint(bo_constraint);
										updated = true;

									}
								}
							}
						//	errs()<<"temp:";
							//ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
							errs()<<"temp2:";
							ExprPPrinter::printQuery(std::cerr, temp2.constraints, ConstantExpr::alloc(0, Expr::Bool));

							// Now the buffer overflow constraints has been added
							std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
			//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
							if(updated)hasSolution = this->getSymbolicSolution(temp2, res);
							if(!hasSolution)
								errs()<<file<<": The overflow would not happen here!\n";
							else{
								errs()<<file<<": The overflow may happen here!\n";
								hasBFO = true;
								// Test: try to generate a test caes that will invoke the buffer overflow
								errs()<<"Generating my test cases\n";
								interpreterHandler->processTestCase(temp2, (file + "Buffer overflow error is found here").c_str(), 
									"bfowarning");
								errs()<<"Generating finished\n";
							}
							ExecutionState temp3(state);
							bool op3eqj = true,updated = false;
							ref<Expr> op3Eqj = SgtExpr::create(op3,ConstantExpr::create(j-start_src_index,32));
							errs()<<"Added new constraint:";
							op3Eqj->dump();
							op3Eqj = temp3.constraints.simplifyExpr(op3Eqj);
							if((op3Eqj->getKind() == Expr::Constant)) {
								ref<ConstantExpr> constExpr = cast<ConstantExpr>(op3Eqj);
								if(!constExpr->isTrue()) {
									errs()<<"op3=="<<j-start_src_index<<"break\n";
									op3eqj = false;
								}else{
									errs()<<"it comes here,op3!="<<j-start_src_index<<"\n";
									//break;
								}
							}else{
								temp3.addConstraint(op3Eqj);
								updated = true;
							}
							errs()<<"temp3:";
							ExprPPrinter::printQuery(std::cerr, temp3.constraints, ConstantExpr::alloc(0, Expr::Bool));

							// Now the buffer overflow constraints has been added
							std::vector<std::pair<std::string, std::vector<unsigned char> > > res1;
			//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
							if(updated) op3eqj = this->getSymbolicSolution(temp3, res1);
							if(!op3eqj) break;

							errs()<<"not break\n";
						}
					}
				}


			}
			/*
			else if(funcName == "strncat"){
				// TODO when function called is strncat
				//char *strncat(char *dest,char *src,int n)
				//when min{n,len(src)}+len(dest) >= size(dest),bfo
				int lenDest=0;
				for(int i=start_des_index;i<start_des_index+actual_size_des;i++){
					ref<Expr> read_buf = os_des->read8(i);
					errs()<<"dest read_buf:";
					read_buf->dump();
					ref<Expr> desiEq0 = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
					errs()<<"Added new constraint:";
					desiEq0->dump();
					ExecutionState temp2(state);
					bool hasSolution = false;
					bool updated = false;
					desiEq0 = temp2.constraints.simplifyExpr(desiEq0);
					if((desiEq0->getKind() == Expr::Constant)) {
						ref<ConstantExpr> constExpr = cast<ConstantExpr>(desiEq0);
						if(!constExpr->isTrue()) {
							errs()<<"expr added failed,desti == 0\n";
							hasSolution = false;
							updated = false;
						}
						else{
							errs()<<"it comes here!,desti != 0\n";
							hasSolution = true;
							updated = false;
						}
					}
					else {
						errs()<<"expr added succeed\n";
						temp2.addConstraint(desiEq0);
						updated = true;					
					}
					errs()<<"temp2:";
					ExprPPrinter::printQuery(std::cerr, temp2.constraints, ConstantExpr::alloc(0, Expr::Bool));
					// Now the buffer overflow constraints has been added
					std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
					if(updated)hasSolution = this->getSymbolicSolution(temp2, res);
					if(hasSolution){
						//dest[i]!=0
						lenDest++;
					}else{
						//dest[i]==0
						break;
					}
				}
				errs()<<"len(dest) is :"<<lenDest<<"\n";
				if(lenDest >= actual_size_des){
					errs()<<"lenDest may >= actual_size_des.\n";
					errs()<<file<<": The overflow may happen here!\n";
					hasBFO = true;
					// Test: try to generate a test caes that will invoke the buffer overflow
					errs()<<"Generating my test cases\n";
					interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(), 
						"bfowarning");
					errs()<<"Generating finished\n";
				}
				else{
					actual_size_des = actual_size_des - lenDest;
					int lenSrc=0;
					for(int i=start_src_index;i<start_src_index+actual_size_src;i++){
						ref<Expr> read_buf = os_src->read8(i);
						errs()<<"src read_buf:";
						read_buf->dump();
						ref<Expr> srciEq0 = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
						errs()<<"Added new constraint:";
						srciEq0->dump();
						ExecutionState temp2(state);
						bool hasSolution = false;
						bool updated = false;
						srciEq0 = temp2.constraints.simplifyExpr(srciEq0);
						if((srciEq0->getKind() == Expr::Constant)) {
							ref<ConstantExpr> constExpr = cast<ConstantExpr>(srciEq0);
							if(!constExpr->isTrue()) {
								errs()<<"expr added failed\n";
								hasSolution = false;
								updated = false;
							}
							else{
								errs()<<"it comes here!\n";
								hasSolution = true;
								updated = false;
							}
						}
						else {
							errs()<<"expr added succeed\n";
							temp2.addConstraint(srciEq0);
							updated = true;					
						}
						errs()<<"temp2:";
						ExprPPrinter::printQuery(std::cerr, temp2.constraints, ConstantExpr::alloc(0, Expr::Bool));
						// Now the buffer overflow constraints has been added
						std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
						if(updated)hasSolution = this->getSymbolicSolution(temp2, res);
						if(hasSolution){
							//src[i]!=0
							lenSrc++;
						}else{
							//src[i]==0
							break;
						}
					}
					errs()<<"len(src) is :"<<lenSrc<<"\n";
					if(lenSrc >= actual_size_des){
						errs()<<"lenSrc+lenDes may >= actual_size_des.\n";
						errs()<<file<<": The overflow may happen here!\n";
						hasBFO = true;
						// Test: try to generate a test caes that will invoke the buffer overflow
						errs()<<"Generating my test cases\n";
						interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(), 
							"bfowarning");
						errs()<<"Generating finished\n";
					}else{
						ref<Expr> op3CmpDes = UgeExpr::create(op3,ConstantExpr::create(actual_size_des,32));
						ExecutionState temp3(state);
						bool hasSolution = false;
						bool updated = false;
						op3CmpDes = temp3.constraints.simplifyExpr(op3CmpDes);
						if((op3CmpDes->getKind() == Expr::Constant)) {
							ref<ConstantExpr> constExpr = cast<ConstantExpr>(op3CmpDes);
							if(!constExpr->isTrue()) {
								errs()<<"expr added failed\n";
								hasSolution = false;
								updated = false;
							}
							else{
								errs()<<"it comes here!\n";
								hasSolution = true;
								updated = false;
							}
						}
						else {
							errs()<<"expr added succeed\n";
							temp3.addConstraint(op3CmpDes);
							updated = true;	
						}
						errs()<<"temp3:";
						ExprPPrinter::printQuery(std::cerr, temp3.constraints, ConstantExpr::alloc(0, Expr::Bool));
						// Now the buffer overflow constraints has been added
						std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
						if(updated)hasSolution = this->getSymbolicSolution(temp3, res);
						if(hasSolution){
							//n >= actual_size_des
							errs()<<"n+lenDes may >= actual_size_des.\n";
							errs()<<file<<": The overflow may happen here!\n";
							hasBFO = true;
							// Test: try to generate a test caes that will invoke the buffer overflow
							errs()<<"Generating my test cases\n";
							interpreterHandler->processTestCase(temp3, (file + "Buffer overflow error is found here").c_str(), 
								"bfowarning");
							errs()<<"Generating finished\n";
						}else{
							//n < actual_size_des
							errs()<<file<<": The overflow would not happen here!\n";
							hasBFO = false;
						}
					}
				}
			}
			*/
		}

		else if(funcName == "gets"){
			//char *gets(char *str);
			//when get stdin character is a \n(10),will stop gets(not include \n),and will add \0 at end of str
			//the number before \n >= size(str),bfo
			isCheckFunc = true;
			ref<ConstantExpr> op = toConstant(state, eval(ki, 1, state).value, "uint64");
			uint64_t addr_arg = op->getZExtValue();
			MemoryObject * mo_arg = manager->findMemoryObjectByAddr(addr_arg);
			// Now get the buffer
			BufferObject * des_buf = manager->findBufferByAddr(addr_arg);
			int start_des_index = addr_arg - mo_arg->address;
			uint64_t size_des_buf = des_buf->getSize();	// Size of the memory object found by address(the address may be with the memory)
			printf("Debug: read: size_des: %u\n", (unsigned)size_des_buf);
			// Use ObjectState to manipulate MemoryObject
			const ObjectState * os_des = state.addressSpace.findObject(des_buf->mo);
			int actual_size_des = size_des_buf;
					//, actual_size_src = size_src_buf - start_src_index;
			errs()<<"actual_size_des:"<<actual_size_des<<"\n";
			ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
			//A-data,stdin,A-data-stat,stdin-stat
			MemoryObject *moStdin = manager->findMemoryObjectByName("stdin");
			if(!moStdin) {errs()<<"Stdin memoryobject is null\n";return;}
		//	errs()<<"moStdin getbase:";
		//	moStdin->getBaseExpr()->dump();
			const ObjectState * os = state.addressSpace.findObject(moStdin);
			if(!os) {errs()<<"Stdin objectstate is null\n";return;}
			errs()<<"stdin length: "<<os->size<<"\n";
			bool hasSolution = true, updated = false;
			if(os->size < actual_size_des){
				//file size < dest size
				errs()<<file<<": The overflow would not happen here!\n";
			}
			else{
				for(int i = 0; i < actual_size_des; i++) {
					ref<Expr> read_buf = os->read8(i);
					errs()<<"read_buf:";
					read_buf->dump();
					ref<Expr> bo_constraint = Expr::createIsZero(EqExpr::create(ConstantExpr::create(10, 8), read_buf));
					//10 is ascii of \n
					errs()<<"Added new constraint:";
					bo_constraint->dump();
					bo_constraint = temp.constraints.simplifyExpr(bo_constraint);
					errs()<<"Added new constraint:";
					bo_constraint->dump();
					bo_constraint = temp.constraints.simplifyExpr(bo_constraint);
					if((bo_constraint->getKind() == Expr::Constant)) {
						ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
						if(!constExpr->isTrue()) {
							errs()<<"expr added failed\n";
							hasSolution = false;
							updated = false;
							break;
						}
					}
					else {
						errs()<<"expr added succeed\n";
						temp.addConstraint(bo_constraint);
						updated = true;
					}
				}
				errs()<<"temp:";
				ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));

				// Now the buffer overflow constraints has been added
				std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
		//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
				if(updated)hasSolution = this->getSymbolicSolution(temp, res);
				if(!hasSolution)
					errs()<<file<<": The overflow would not happen here!\n";
				else{
					errs()<<file<<": The overflow may happen here!\n";
					hasBFO = true;
					// Test: try to generate a test caes that will invoke the buffer overflow
					errs()<<"Generating my test cases\n";
					interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(),
						"bfowarning");
					errs()<<"Generating finished\n";
				}
			}

		}
		else if(funcName == "fgets" || funcName == "fgets_unlocked"){
			// TODO when function called is fgets
			//char * fgets ( char * str, int num, FILE * stream );
			//bfo when Min{num,len(include \n)+1}(include \0) > size(str)
			isCheckFunc = true;
			ref<ConstantExpr> op1 = toConstant(state, eval(ki, 1, state).value, "uint64");
			ref<Expr> op2 = eval(ki, 2, state).value;
			ref<ConstantExpr> op3 = toConstant(state, eval(ki, 3, state).value, "uint64");
			errs()<<"the second operation int num:\n";
			op2->dump();
			errs()<<"the third operation:\n";
			op3->dump();
			uint64_t addr_arg1 = op1->getZExtValue();
			uint64_t addr_arg3 = op3->getZExtValue();
			MemoryObject * mo_arg1 = manager->findMemoryObjectByAddr(addr_arg1);
			// Now get the buffer
			BufferObject * des_buf = manager->findBufferByAddr(addr_arg1);
			int start_des_index = addr_arg1 - mo_arg1->address;
			uint64_t size_des_buf = des_buf->getSize();	// Size of the memory object found by address(the address may be with the memory)
			printf("Debug: read: size_des: %u\n", (unsigned)size_des_buf);
			// Use ObjectState to manipulate MemoryObject
			const ObjectState * os_des = state.addressSpace.findObject(des_buf->mo);
			int actual_size_des = size_des_buf;
			errs()<<"actual_size_des:"<<actual_size_des<<"\n";
			ref<Expr> bo_constraint = SgtExpr::create(op2,ConstantExpr::create(actual_size_des, 32));
			errs()<<"Added new constraint:";
			bo_constraint->dump();
			bo_constraint = temp.constraints.simplifyExpr(bo_constraint);
			bool hasSolution = true, updated = false;
			if((bo_constraint->getKind() == Expr::Constant)) {
				ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
				if(!constExpr->isTrue()) {
					errs()<<"expr added failed\n";
					hasSolution = false;
					updated = false;
				}
			}
			else {
				errs()<<"expr added succeed\n";
				temp.addConstraint(bo_constraint);
				updated = true;
			}
			errs()<<"temp:";
			ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));

			// Now the buffer overflow constraints has been added
			std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
	//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
			if(updated)hasSolution = this->getSymbolicSolution(temp, res);
			if(!hasSolution)
				errs()<<file<<": The overflow would not happen here!\n";
			else{
				errs()<<file<<": The overflow may happen here!\n";
				hasBFO = true;
				// Test: try to generate a test caes that will invoke the buffer overflow
				errs()<<"Generating my test cases\n";
				interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(),
					"bfowarning");
				errs()<<"Generating finished\n";
			}
		}
		else if(funcName == "read"){
			// TODO when function called is read
			//read(fd,buf,BUFSIZE)
			//ref<Expr> op1 = eval(ki, 1, state).value;
			isCheckFunc = true;
			ref<ConstantExpr> op1 = toConstant(state, eval(ki, 1, state).value, "uint64");
			ref<ConstantExpr> op2 = toConstant(state, eval(ki, 2, state).value, "uint64");
			ref<Expr> op3 = eval(ki, 3, state).value;
			errs()<<"the first operation:\n";
			op1->dump();
			uint64_t fd = op1->getZExtValue();
			//exe_file_t *f;
			//f = get_file_env(fd);
			//errs()<<"fd : "<<fd<<"\n";
			//extern "C" exe_sym_env_t __exe_env;
			//extern "C" exe_file_system_t __exe_fs;
			/*
			exe_file_t *f;
			//f = __get_file(fd);
			f = &__exe_env.fds[fd];		
			if(f!=NULL) errs()<<"find fd\n";
			else errs()<<"NOT find fd\n";
			if (!f->dfile) {
				// concrete file /
				
			}else{	
				// symbolic file /
				errs()<<"contents : "<<f->dfile->contents<<"\n";
			}
			*/
			errs()<<"the third operation:\n";
			op3->dump();
			//ref<ConstantExpr> constop3 = cast<ConstantExpr>(op3);
			//uint64_t val_op3 = constop3->getZExtValue();
			// std::vector< std::pair<const MemoryObject*, const Array*> > symbolics;
			//state.symbolics[].first
			uint64_t addr_arg2 = op2->getZExtValue();
			MemoryObject * mo_arg2 = manager->findMemoryObjectByAddr(addr_arg2);
			// Now get the buffer
			BufferObject * des_buf = manager->findBufferByAddr(addr_arg2);
			int start_des_index = addr_arg2 - mo_arg2->address;
			uint64_t size_des_buf = des_buf->getSize();	// Size of the memory object found by address(the address may be with the memory)
			printf("Debug: read: size_des: %u\n", (unsigned)size_des_buf);
			// Use ObjectState to manipulate MemoryObject
			const ObjectState * os_des = state.addressSpace.findObject(des_buf->mo);
			int actual_size_des = size_des_buf;
					//, actual_size_src = size_src_buf - start_src_index;
			errs()<<"actual_size_des:"<<actual_size_des<<"\n";
			ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
			//A-data,stdin,A-data-stat,stdin-stat
		//	MemoryObject *moStdin = manager->findMemoryObjectByName("A-data");
		//	if(!moStdin) {errs()<<"A-data memoryobject is null\n";return;}
		//	const ObjectState * os = state.addressSpace.findObject(moStdin);
		//	if(!os) {errs()<<"A-data ObjectState is null\n";return;}
		//	errs()<<"A-data length: "<<os->size<<"\n";
			bool hasSolution = true, updated = false;
			ref<Expr> op3GtDes = UgtExpr::create(op3,ConstantExpr::create(actual_size_des, 32));
			errs()<<"Added new constraint:";
			op3GtDes->dump();
			op3GtDes = temp.constraints.simplifyExpr(op3GtDes);
			if((op3GtDes->getKind() == Expr::Constant)) {
				ref<ConstantExpr> constExpr = cast<ConstantExpr>(op3GtDes);
				if(!constExpr->isTrue()) {
					errs()<<"expr added failed\n";
					hasSolution = false;
					updated = false;
				}
			}
			else {
				errs()<<"expr added succeed\n";
				temp.addConstraint(op3GtDes);
				updated = true;
			}
			errs()<<"temp:";
			ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));

			// Now the buffer overflow constraints has been added
			std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
	//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
			if(updated)hasSolution = this->getSymbolicSolution(temp, res);
			if(!hasSolution)
				errs()<<file<<": The overflow would not happen here!\n";
			else{
				errs()<<file<<": The overflow may happen here!\n";
				hasBFO = true;
				// Test: try to generate a test caes that will invoke the buffer overflow
				errs()<<"Generating my test cases\n";
				interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(),
					"bfowarning");
				errs()<<"Generating finished\n";
			}
			/*
			//int upper = actual_size_des < val_op3 ? actual_size_des : val_op3;
			for(int i = start_des_index; i < start_des_index+actual_size_des; i++) {
				ref<Expr> read_buf = os->read8(i);
				errs()<<"read_buf:";
				read_buf->dump();
				ref<Expr> bo_constraint = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
				errs()<<"Added new constraint:";
				bo_constraint->dump();
				bo_constraint = temp.constraints.simplifyExpr(bo_constraint);
				if((bo_constraint->getKind() == Expr::Constant)) {
					ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
					if(!constExpr->isTrue()) {
						errs()<<"expr added failed\n";
						hasSolution = false;
						updated = false;
						break;
					}
				}
				else {
					errs()<<"expr added succeed\n";
					temp.addConstraint(bo_constraint);
					updated = true;
				}
			}
			errs()<<"temp:";
			ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));

			// Now the buffer overflow constraints has been added
			std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
	//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
			if(updated)hasSolution = this->getSymbolicSolution(temp, res);
			if(!hasSolution)
				errs()<<file<<": The overflow would not happen here!\n";
			else{
				errs()<<file<<": The overflow may happen here!\n";
				// Test: try to generate a test caes that will invoke the buffer overflow
				errs()<<"Generating my test cases\n";
				interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(), 
					"bfowarning");
				errs()<<"Generating finished\n";
			}
			*/
		}
		
		else if(funcName == "fread_unlocked" || funcName == "fread"){
			// TODO when function called is fread
			//size_t fread ( void *buffer, size_t size, size_t count, FILE *stream) ;
			//size_t fread_unlocked (void *buf, size_t size,size_t nr,FILE *stream);
			//when size*count > size(buf),bfo
			isCheckFunc = true;
			ref<ConstantExpr> op1 = toConstant(state, eval(ki, 1, state).value, "uint64");
			ref<Expr> op2 = eval(ki, 2, state).value;
			ref<Expr> op3 = eval(ki, 3, state).value;
			ref<ConstantExpr> op4 = toConstant(state, eval(ki, 4, state).value, "uint64");
			//errs()<<"the first operation:\n";
			//op1->dump();
			errs()<<"the second operation size_t size:\n";
			op2->dump();
			errs()<<"the third operation size_t count:\n";
			op3->dump();
			errs()<<"the fourth operation:\n";
			op4->dump();
			/*
			ref<ConstantExpr> constop2 = cast<ConstantExpr>(op2);
			uint64_t val_op2 = constop2->getZExtValue();
			ref<ConstantExpr> constop3 = cast<ConstantExpr>(op3);
			uint64_t val_op3 = constop3->getZExtValue();
			* */
			// std::vector< std::pair<const MemoryObject*, const Array*> > symbolics;
			//state.symbolics[].first
			uint64_t addr_arg1 = op1->getZExtValue();
			uint64_t addr_arg4 = op4->getZExtValue();
			MemoryObject * mo_arg1 = manager->findMemoryObjectByAddr(addr_arg1);
			// Now get the buffer
			BufferObject * des_buf = manager->findBufferByAddr(addr_arg1);
			int start_des_index = addr_arg1 - mo_arg1->address;
			uint64_t size_des_buf = des_buf->getSize();	// Size of the memory object found by address(the address may be with the memory)
			printf("Debug: read: size_des: %u\n", (unsigned)size_des_buf);
			// Use ObjectState to manipulate MemoryObject
			const ObjectState * os_des = state.addressSpace.findObject(des_buf->mo);
			int actual_size_des = size_des_buf;
			errs()<<"actual_size_des:"<<actual_size_des<<"\n";
			ref<Expr> bo_constraint = SgtExpr::create(MulExpr::create(op2,op3),ConstantExpr::create(actual_size_des, 32));
			errs()<<"Added new constraint:";
			bo_constraint->dump();
			bo_constraint = temp.constraints.simplifyExpr(bo_constraint);
			bool hasSolution = true, updated = false;
			if((bo_constraint->getKind() == Expr::Constant)) {
				ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
				if(!constExpr->isTrue()) {
					errs()<<"expr added failed\n";
					hasSolution = false;
					updated = false;
				}
			}
			else {
				errs()<<"expr added succeed\n";
				temp.addConstraint(bo_constraint);
				updated = true;
			}
			errs()<<"temp:";
			ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));

			// Now the buffer overflow constraints has been added
			std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
	//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
			if(updated)hasSolution = this->getSymbolicSolution(temp, res);
			if(!hasSolution)
				errs()<<file<<": The overflow would not happen here!\n";
			else{
				errs()<<file<<": The overflow may happen here!\n";
				hasBFO = true;
				// Test: try to generate a test caes that will invoke the buffer overflow
				errs()<<"Generating my test cases\n";
				interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(),
					"bfowarning");
				errs()<<"Generating finished\n";
			}
		//	MemoryObject * mo_op4 = manager->findMemoryObjectByAddr(addr_arg4);
		//	if(!mo_op4) {errs()<<"mo_op4 memoryobject is null\n";return;}
		//	errs()<<"moop4id:"<<mo_op4->address<<"\n";
		//	const ObjectState * os_op4 = state.addressSpace.findObject(mo_op4);
		//	if(!os_op4) {errs()<<"os_op4 ObjectState is null\n";return;}
			//A-data,stdin,A-data-stat,stdin-stat
			/*
			MemoryObject *moStdin = manager->findMemoryObjectByName("A-data");
			if(!moStdin) {errs()<<"Stdin memoryobject is null\n";return;}
			errs()<<"moStdin:"<<moStdin->address<<"\n";
			const ObjectState * os = state.addressSpace.findObject(moStdin);
			if(!os) {errs()<<"Stdin ObjectState is null\n";return;}
		//	MemoryObject *moarg0 = manager->findMemoryObjectByName("arg0");
		//	if(!moarg0){errs()<<"cannot find arg0 memory object\n"; return;}
		//	const ObjectState * osarg0 = state.addressSpace.findObject(moarg0);
		//	if(!osarg0){errs()<<"cannot find arg0 objectstate\n"; return;}
		//	errs()<<"osarg0:\n";
		//	osarg0->read8(0)->dump();
			ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
			bool hasSolution = true, updated = false;
			int upper = actual_size_des < val_op2*val_op3 ? actual_size_des : val_op2*val_op3;
			errs()<<"upper:"<<upper<<"\n";
			for(int i = start_des_index; i < start_des_index+upper; i++) {
				ref<Expr> read_buf = os->read8(i);
				errs()<<"read_buf:";
				read_buf->dump();
				ref<Expr> bo_constraint = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
				errs()<<"Added new constraint:";
				bo_constraint->dump();
				bo_constraint = temp.constraints.simplifyExpr(bo_constraint);
				if((bo_constraint->getKind() == Expr::Constant)) {
					ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
					if(!constExpr->isTrue()) {
						errs()<<"expr added failed\n";
						hasSolution = false;
						updated = false;
						break;
					}
				}
				else {
					errs()<<"expr added succeed\n";
					temp.addConstraint(bo_constraint);
					updated = true;
				}
			}
			errs()<<"temp:";
			ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));

			// Now the buffer overflow constraints has been added
			std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
	//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
			if(updated)hasSolution = this->getSymbolicSolution(temp, res);
			if(!hasSolution)
				errs()<<file<<": The overflow would not happen here!\n";
			else{
				errs()<<file<<": The overflow may happen here!\n";
				// Test: try to generate a test caes that will invoke the buffer overflow
				errs()<<"Generating my test cases\n";
				interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(),
					"bfowarning");
				errs()<<"Generating finished\n";
			}
			* */
		}
		else if(funcName == "sprintf" || funcName == "vsprintf"){
			// TODO when function called is sprintf
			//int sprintf( char *buffer, const char *format, [ argument] \E2\80  )
			//int vsprintf(char *buf,char * format,va_list arg);
			//bfo when char length(not include \0) >= size(buffer)
			isCheckFunc = true;
			ref<ConstantExpr> op1 = toConstant(state, eval(ki, 1, state).value, "uint64");
			uint64_t addr_arg1 = op1->getZExtValue();
			MemoryObject * mo_arg1 = manager->findMemoryObjectByAddr(addr_arg1);
			// Now get the buffer
			BufferObject * des_buf = manager->findBufferByAddr(addr_arg1);
			int start_des_index = addr_arg1 - mo_arg1->address;
			uint64_t size_des_buf = des_buf->getSize();	// Size of the memory object found by address(the address may be with the memory)
			int actual_size_des = size_des_buf;
			errs()<<"actual_size_des:"<<actual_size_des<<"\n";
			MemoryObject *moFormatLen = manager->findMemoryObjectByName(funcName+"_FormatLen");
			if(!moFormatLen){errs()<<"cannot find FormatLen memory object\n"; return;}
			const ObjectState * osFormatLen = state.addressSpace.findObject(moFormatLen);
			if(!osFormatLen){errs()<<"cannot find FormatLen objectstate\n"; return;}
			errs()<<"FormatLen:\n";
			//osFormatLen->read8(0)->dump();
			ref<Expr> FormatLen = osFormatLen->read(0,32);
			FormatLen->dump();
			//ref<Expr> bo_constraint = UgeExpr::create(FormatLen, ConstantExpr::create(actual_size_des, 32));
			ref<Expr> bo_constraint = UleExpr::create(ConstantExpr::create(actual_size_des, 32),FormatLen);
			errs()<<"Added new constraint:";
			bo_constraint->dump();
			bo_constraint = temp.constraints.simplifyExpr(bo_constraint);
			bool hasSolution = true, updated = false;
			if((bo_constraint->getKind() == Expr::Constant)) {
				ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
				if(!constExpr->isTrue()) {
					errs()<<"expr added failed\n";
					hasSolution = false;
					updated = false;
				}
			}
			else {
				errs()<<"expr added succeed\n";
				temp.addConstraint(bo_constraint);
				updated = true;
			}
			errs()<<"temp:";
			ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));

			// Now the buffer overflow constraints has been added
			std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
	//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
			if(updated)hasSolution = this->getSymbolicSolution(temp, res);
			if(!hasSolution)
				errs()<<file<<": The overflow would not happen here!\n";
			else{
				hasBFO = true;
				errs()<<file<<": The overflow may happen here!\n";
				// Test: try to generate a test caes that will invoke the buffer overflow
				errs()<<"Generating my test cases\n";
				interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(),
					"bfowarning");
				errs()<<"Generating finished\n";
			}
		}
		else if(funcName == "snprintf" || funcName == "vsnprintf"){
			// TODO when function called is sprintf
			//int snprintf ( char * s, size_t n, const char * format, ... );
			//bfo when n>size(s)
			isCheckFunc = true;
			ref<ConstantExpr> op1 = toConstant(state, eval(ki, 1, state).value, "uint64");
			uint64_t addr_arg1 = op1->getZExtValue();
			MemoryObject * mo_arg1 = manager->findMemoryObjectByAddr(addr_arg1);
			// Now get the buffer
			BufferObject * des_buf = manager->findBufferByAddr(addr_arg1);
			int start_des_index = addr_arg1 - mo_arg1->address;
			uint64_t size_des_buf = des_buf->getSize();	// Size of the memory object found by address(the address may be with the memory)
			int actual_size_des = size_des_buf;
			errs()<<"actual_size_des:"<<actual_size_des<<"\n";
			ref<Expr> op2 = eval(ki, 2, state).value;
			errs()<<"the second operation n:\n";
			op2->dump();
			//ref<Expr> bo_constraint = UgtExpr::create(op2, ConstantExpr::create(actual_size_des, 32));
			ref<Expr> bo_constraint = UltExpr::create(ConstantExpr::create(actual_size_des, 32),op2);
			errs()<<"Added new constraint:";
			bo_constraint->dump();
			bo_constraint = temp.constraints.simplifyExpr(bo_constraint);
			bool hasSolution = true, updated = false;
			if((bo_constraint->getKind() == Expr::Constant)) {
				ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
				if(!constExpr->isTrue()) {
					errs()<<"expr added failed\n";
					hasSolution = false;
					updated = false;
				}else{
					//hasSolution = true;
					//updated = false;
				}
			}
			else {
				errs()<<"expr added succeed\n";
				temp.addConstraint(bo_constraint);
				updated = true;
			}
			errs()<<"temp:";
			ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));

			// Now the buffer overflow constraints has been added
			std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
	//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
			if(updated)hasSolution = this->getSymbolicSolution(temp, res);
			if(!hasSolution)
				errs()<<file<<": The overflow would not happen here!\n";
			else{
				hasBFO = true;
				errs()<<file<<": The overflow may happen here!\n";
				// Test: try to generate a test caes that will invoke the buffer overflow
				errs()<<"Generating my test cases\n";
				interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(),
					"bfowarning");
				errs()<<"Generating finished\n";
			}
		}

		else if(funcName == "sscanf" || funcName == "__isoc99_sscanf0" || funcName == "fscanf" || funcName == "__isoc99_fscanf"){
			// TODO when function called is sscanf
			//int sscanf(char *buffer, const char *format, [ argument] \E2\80  )
			//now we only deal with %s,we think that %d will not bfo
			isCheckFunc = true;
			int opNum=2;
			//opNum means the opcode number before dest variabel,include buf/stream and format,but scanf doesn't have a buf or stream
			bool srcSym=false;
			ref<ConstantExpr> op1 = toConstant(state, eval(ki, 1, state).value, "uint64");
			uint64_t addr_arg1 = op1->getZExtValue();
			MemoryObject * mo_arg1 = manager->findMemoryObjectByAddr(addr_arg1);
			// Now get the buffer
			BufferObject * src_buf = manager->findBufferByAddr(addr_arg1);
			int start_src_index = addr_arg1 - mo_arg1->address;
			uint64_t size_src_buf = src_buf->getSize();	// Size of the memory object found by address(the address may be with the memory)
			int actual_size_src = size_src_buf;
			errs()<<"actual_size_src:"<<actual_size_src<<"\n";
			const ObjectState * os_src = state.addressSpace.findObject(src_buf->mo);
			if(-1==state.isSymbolic(mo_arg1)){
				errs()<<"src buf is not symbolic\n";
				srcSym=false;
			}
			else{
				errs()<<"src buf is symbolic\n";
				srcSym=true;
			}
			//now get format
			ref<ConstantExpr> op2 = toConstant(state, eval(ki, opNum, state).value, "uint64");
			errs()<<"the second operation:\n";
			op2->dump();
			uint64_t addr_arg2 = op2->getZExtValue();
			MemoryObject * mo_arg2 = manager->findMemoryObjectByAddr(addr_arg2);
			// Now get the buffer
			BufferObject * buf2 = manager->findBufferByAddr(addr_arg2);
			int start_buf2_index = addr_arg2 - mo_arg2->address;
			uint64_t size_buf2 = buf2->getSize();	// Size of the memory object found by address(the address may be with the memory)
			int actual_size_buf2 = size_buf2;
		//	errs()<<"actual_size_buf2:"<<actual_size_buf2<<"\n";
			// Use ObjectState to manipulate MemoryObject
			const ObjectState * os2 = state.addressSpace.findObject(buf2->mo);

			int cntPercent=0;
			//cnt % number
			int cntN=0;
			//cnt %n number
			bool flag=false;
			//flag is set true when the char is %
			//bool ignor=false;
			//if %*s,it'll be ignored
			int saveN[50];
			//index of %n in format
			//I'm not sure 50 is enough
			int checkIndex[50];
			//index of %s... in format
			//I'm not sure 50 is enough
			for(int i = start_buf2_index; i < start_buf2_index+actual_size_buf2; i++) {
				ref<Expr> read_buf = os2->read8(i);
				ref<ConstantExpr> constExpr = cast<ConstantExpr>(read_buf);
				errs()<<"read_buf:";
				read_buf->dump();
				if(!flag){
					//last cycle char is not %
					ref<ConstantExpr> const1 = ConstantExpr::create(37, 8);
					//37 is ASCII of %
					//errs()<<"%: ";
					//const1->dump();
					ref<ConstantExpr> cmp = constExpr->Eq(const1);
					if(cmp->isTrue()){
						errs()<<"read_buf is %\n";
						cntPercent++;
						flag = true;
					}
				}else{
					//last cycle char is %,we want to know if the next char is n or *
					flag = false;
					ref<ConstantExpr> const21 = ConstantExpr::create(110, 8);
					//100 is ASCII of n
					ref<ConstantExpr> const22 = ConstantExpr::create(42, 8);
					//115 is ASCII of *
					ref<ConstantExpr> cmp21 = constExpr->Eq(const21);
					ref<ConstantExpr> cmp22 = constExpr->Eq(const22);
					if(cmp21->isTrue()){
						//%n
						cntN++;
						saveN[cntN-1] = cntPercent-1;
					}
					else if(cmp22->isTrue()){
						//%*s or %*d...
						//saveDS[cnt-1]='s';
					}
					else{
						//continue;
					}
				}
			}
			printf("%% number is: %d\n",cntPercent);
			printf("%%n number is: %d\n",cntN);
			printf("saveN:\n");
			for(int i=0;i<cntN;i++){
				printf("%d ",saveN[i]);
			}
			printf("\n");
			int cntCheckNum = cntN/2;
			printf("checkIndex:\n");
			//int strLen[50];
			for(int i=0;i<cntCheckNum;i++){
				checkIndex[i] = saveN[2*i+1]-1;
				printf("%d, checkIndex: %d \n",i,checkIndex[i]);
				if(srcSym){
					//src buffer is symbolic, we should compare size(src) with size(dest)
					//now we need get %s... buffer
					ref<ConstantExpr> opDs0 = toConstant(state, eval(ki, checkIndex[i]+opNum+1, state).value, "uint64");
					uint64_t addr_opDs0 = opDs0->getZExtValue();
					MemoryObject * mo_opDs0 = manager->findMemoryObjectByAddr(addr_opDs0);
					// Now get the buffer
					BufferObject * opDs0_buf = manager->findBufferByAddr(addr_opDs0);
					int start_opDs0_index = addr_opDs0 - mo_opDs0->address;
					uint64_t size_opDs0_buff = opDs0_buf->getSize();	// Size of the memory object found by address(the address may be with the memory)
					int actual_size_opDs0 = size_opDs0_buff;
					errs()<<"actual_size_opDs0:"<<actual_size_opDs0<<"\n";
					if(actual_size_src <= actual_size_opDs0){
						//will not bfo
						errs()<<file<<": The overflow would not happen here!\n";
						continue;
					}
					else{
						bool hasSolution = true, updated = false;
						ExecutionState temp2(state);
						for(int i=start_src_index;i<start_src_index+actual_size_opDs0;i++){
							ref<Expr> read_buf = os_src->read8(i);
							errs()<<"read_buf:";
							read_buf->dump();
							ref<Expr> bo_constraint = Expr::createIsZero(EqExpr::create(ConstantExpr::create(0, 8), read_buf));
							errs()<<"Added new constraint:";
							bo_constraint->dump();
							bo_constraint = temp2.constraints.simplifyExpr(bo_constraint);
							if((bo_constraint->getKind() == Expr::Constant)) {
								ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
								if(!constExpr->isTrue()) {
									errs()<<"expr added failed,exit cycle\n";
									hasSolution = false;
									updated = false;
									break;
								}
							}
							else {
								errs()<<"expr added succeed\n";
								temp2.addConstraint(bo_constraint);
								updated = true;
							}
						}
						errs()<<"temp2:";
						ExprPPrinter::printQuery(std::cerr, temp2.constraints, ConstantExpr::alloc(0, Expr::Bool));

						// Now the buffer overflow constraints has been added
						std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
		//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
						if(updated)hasSolution = this->getSymbolicSolution(temp2, res);
						if(!hasSolution)
							errs()<<file<<": The overflow would not happen here!\n";
						else{
							errs()<<file<<": The overflow may happen here!\n";
							hasBFO = true;
							// Test: try to generate a test caes that will invoke the buffer overflow
							errs()<<"Generating my test cases\n";
							interpreterHandler->processTestCase(temp2, (file + "Buffer overflow error is found here").c_str(),
								"bfowarning");
							errs()<<"Generating finished\n";
							break;
						}
					}
				}
				else{
					//now we should get %n
					ref<ConstantExpr> opn0 = toConstant(state, eval(ki, saveN[2*i]+opNum+1, state).value, "uint64");
					printf("%d %%n: ",saveN[2*i]+2);
					opn0->dump();
					uint64_t addr_opn0 = opn0->getZExtValue();
					MemoryObject * mo_opn0 = manager->findMemoryObjectByAddr(addr_opn0);
					const ObjectState * os_opn0 = state.addressSpace.findObject(mo_opn0);
					ref<Expr> read_buf_opn0 = os_opn0->read(0,32);
					read_buf_opn0->dump();

					ref<ConstantExpr> opn1 = toConstant(state, eval(ki, saveN[2*i+1]+opNum+1, state).value, "uint64");
					printf("%d %%n: ",saveN[2*i+1]+2);
					opn1->dump();
					uint64_t addr_opn1 = opn1->getZExtValue();
					MemoryObject * mo_opn1 = manager->findMemoryObjectByAddr(addr_opn1);
					const ObjectState * os_opn1 = state.addressSpace.findObject(mo_opn1);
					ref<Expr> read_buf_opn1 = os_opn1->read(0,32);
					read_buf_opn1->dump();

					ref<Expr> strLen = SubExpr::create(read_buf_opn1,read_buf_opn0);
					if(i>0){
						strLen = SubExpr::create(strLen,ConstantExpr::create(1,32));
					}
					errs()<<"strLen:\n";
					strLen->dump();
					//now we should get the checkIndex[i]+2 opcode
					ref<ConstantExpr> opi = toConstant(state, eval(ki, checkIndex[i]+opNum+1, state).value, "uint64");
					//printf("the %d operation:\n",checkIndex[i]+2);
					//op3->dump();
					uint64_t addr_argi = opi->getZExtValue();
					MemoryObject * mo_argi = manager->findMemoryObjectByAddr(addr_argi);
					// Now get the buffer
					BufferObject * bufi = manager->findBufferByAddr(addr_argi);
					int start_bufi_index = addr_argi - mo_argi->address;
					uint64_t size_bufi = bufi->getSize();	// Size of the memory object found by address(the address may be with the memory)
					int actual_size_bufi = size_bufi;
					errs()<<"actual_size_bufi:"<<actual_size_bufi<<"\n";
					bool hasSolution = true,updated=false;
					ref<Expr> bo_constraint = UgtExpr::create(strLen,ConstantExpr::create(actual_size_bufi, 32));
					errs()<<"Added new constraint:";
					bo_constraint->dump();
					bo_constraint = temp.constraints.simplifyExpr(bo_constraint);
					if((bo_constraint->getKind() == Expr::Constant)) {
						ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
						if(!constExpr->isTrue()) {
							errs()<<"expr added failed\n";
							updated=false;
							hasSolution=false;
						}else{
							updated=false;
							hasSolution=true;
						}
					}
					else {
						errs()<<"expr added succeed\n";
						temp.addConstraint(bo_constraint);
					}
					errs()<<"temp:";
					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));

					// Now the buffer overflow constraints has been added
					std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
	//					ExprPPrinter::printQuery(std::cerr, temp.constraints, ConstantExpr::alloc(0, Expr::Bool));
					if(updated) hasSolution = this->getSymbolicSolution(temp, res);
					if(!hasSolution)
						errs()<<file<<": The overflow would not happen here!\n";
					else{
						errs()<<file<<": The overflow may happen here!\n";
						hasBFO = true;
						// Test: try to generate a test caes that will invoke the buffer overflow
						errs()<<"Generating my test cases\n";
						interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(),
							"bfowarning");
						errs()<<"Generating finished\n";
					}
				}

			}
			//printf("\n");

		}
		else {
		// TODO we don`t recognize the function called, give notification?
			isCheckFunc = false;
		}
		
	}		
	// Validation type 2: directly buffer access
	else if(ins->getOpcode() == Instruction::GetElementPtr) {
		// TODO implement me
		printf("access instruction\n");
		isArrayBound = true;
		KGEPInstruction *kgepi = static_cast<KGEPInstruction*>(ki);
		ref<Expr> base = eval(ki, 0, state).value;
		base->dump();
		for (std::vector< std::pair<unsigned, uint64_t> >::iterator 
           		it = kgepi->indices.begin(), ie = kgepi->indices.end(); 
         	it != ie; ++it) {
			ref<ConstantExpr> baseAddrExpr = toConstant(state, base, "uint64");
			uint64_t baseAddr = baseAddrExpr->getZExtValue();
			BufferObject * bo = manager->findBufferByAddr(baseAddr);
			uint64_t upperBound = baseAddr + bo->getSize() - 1;
      			uint64_t elementSize = it->second;
			printf("Base address: 0x%x, upper bounder: 0x%x, element size: %u\n", (unsigned)baseAddr,
			(unsigned)upperBound, (unsigned)elementSize);
      		ref<Expr> index = eval(ki, it->first, state).value;
      		errs()<<"index: ";
      		index->dump();
		//	ref<ConstantExpr> indexExpr = toConstant(state, index, "uint64");
		//	printf("Index: %d\n", indexExpr->getZExtValue());
			/*base = AddExpr::create(base,
                             MulExpr::create(Expr::createSExtToPointerWidth(index),
                                             Expr::createPointer(elementSize)));*/
			ExecutionState temp(state);
			// compose constraint that will lead to buffer overflow
			ref<Expr> bo_constraint = SltExpr::create(Expr::createPointer(upperBound), AddExpr::create(base, 
						MulExpr::create(Expr::createSExtToPointerWidth(index), 
                                             	Expr::createPointer(elementSize))));
			printf("Debug: bo_constraint: \n");
			bo_constraint->dump();
			bo_constraint = temp.constraints.simplifyExpr(bo_constraint);
			bool hasSolution = true, updated = true;
			if((bo_constraint->getKind() == Expr::Constant)) {
				ref<ConstantExpr> constExpr = cast<ConstantExpr>(bo_constraint);
				if(!constExpr->isTrue()) {
					errs()<<"expr added failed\n";
					hasSolution = false;
					updated = false;
				}
			}
			else {
				errs()<<"expr added succeed\n";
				temp.addConstraint(bo_constraint);
				updated = true;
			}
			std::vector<std::pair<std::string, std::vector<unsigned char> > > res;
			if(updated)hasSolution = this->getSymbolicSolution(temp, res);
			if(!hasSolution)
				errs()<<file<<": The overflow would not happen here!\n";
			else {
				errs()<<file<<": The overflow may happen here!\n";
				hasBFO = true;
    			// now the buffer overflow happens, should we do something otherthan simply warns?
    			// Test: try to generate a test caes that will invoke the buffer overflow
				errs()<<"Generating my test cases\n";
				interpreterHandler->processTestCase(temp, (file + "Buffer overflow error is found here").c_str(), 
					"bfowarning");
				errs()<<"Generating finished\n";
			}
		}
	}
	else{
		return;
	}
	errs()<<"hasBFO: "<<hasBFO<<", isCheckFunc: "<<isCheckFunc<<", isArray: "<<isArrayBound<<"\n";
	errs()<<"funcName: "<<funcName<<"\n";
	if(hasBFO == true && (isCheckFunc == true || isArrayBound == true)){
		using namespace std;
		ifstream ifs("report_BFO.txt",ios::in);
		string buf;
		string appStr;
		if(isCheckFunc == true ){
			appStr = file + ' ' + funcName;
		}
		else if(isArrayBound == true){
			appStr = file + " Array bound";
		}
		// + " Buffer overflow error is found here!";
		if(!ifs){
			//cout<<"report_BFO.txt not exit"<<endl;
			ofstream ofs("report_BFO.txt",ios::out);
			if(!ofs) return;
			ofs<<appStr<<endl;
			ofs.close();
			return;
		}
		bool hasappStr=false;
		while(getline(ifs,buf))
		{
			 if(appStr == buf){		 
				 hasappStr=true;
				 break;	 
			 } 
		} 
		ifs.close();
		if(hasappStr){return;}
		fstream f("report_BFO.txt",ios::app | ios::out);
		f<<appStr<<endl;
		f.close();
		return;
	}
	
	if(hasBFO == false && (isCheckFunc == true || isArrayBound == true)){
		using namespace std;
		ifstream ifs("report_NOTBFO.txt",ios::in);
		string buf;
		string appStr;
		errs()<<"funcName: "<<funcName<<"\n";
		if(isCheckFunc == true){
			appStr = file + ' ' + funcName;
		}
		else if(isArrayBound == true){
			appStr = file + " Array bound";
		}
		// + " Buffer overflow error is found here!";
		if(!ifs){
			//cout<<"report_BFO.txt not exit"<<endl;
			ofstream ofs("report_NOTBFO.txt",ios::out);
			if(!ofs) return;
			ofs<<appStr<<endl;
			ofs.close();
			return;
		}
		bool hasappStr=false;
		while(getline(ifs,buf))
		{
			 if(appStr == buf){		 
				 hasappStr=true;
				 break;	 
			 } 
		} 
		ifs.close();
		if(hasappStr){return;}
		fstream f("report_NOTBFO.txt",ios::app | ios::out);
		f<<appStr<<endl;
		f.close();
		return;
	}
	
}
// lyc modification
// definitions for CheckList class
// return 0 indicating failure, otherwise 1
int Executor :: loadCheckList(){
	std::ifstream in("checklist_bufferoverflow");
	if(!in.is_open()){
		errs()<<"Fail to open checklist_bufferoverflow, does it exist?\n";
		HasCheckListFile = false;
		return 0;
	}
	HasCheckListFile = true;
	char lastline[100], curline[100];           // I am not sure if 100 is enough to hold the chars in case of very long file name
	do{
		in.getline(curline, 100);
		if(!strcmp(curline, "END_PATH")){
			std::string checkpoint((const char *)lastline);
			// replace '\t' with '_'
			for(int i = 0; i < checkpoint.length(); i++)
				if(checkpoint[i] == '\t'){
					checkpoint[i] = '_';
					int j = i + 1;
					for(; checkpoint[j] != '\t'; ++j);
					for(; checkpoint[j] != 0 && j < 100; ++j)checkpoint[j] = 0;
					break;
				}
			errs()<<"loadCheckList: read one line:"<<checkpoint<<"\n";
			insertCheckPoint(checkpoint);
		}
		else
			strcpy(lastline, curline);
	}while(!in.eof());
	in.close();
	//errs()<<"loadCheckList: finishing\n";
	return 1;
}

void Executor :: insertCheckPoint(std::string checkPoint) {
	CheckPoints.insert(checkPoint);
}

bool Executor :: isCheckPoint(std :: string lineOfCode) {
	//return (CheckPoints.find(lineOfCode) != CheckPoints.end());
	std::set<std::string> :: iterator it = CheckPoints.begin(), it_e = CheckPoints.end();
	for(int i = 0; i < 4; ++i)lineOfCode += '\0'; // this is tricky, because we add  BOF, that is 4 characters longer
	int compare_res = -1;
	for (; it != it_e; ++it){
		compare_res = (*it).compare(lineOfCode);
//		printf("Debug:");
//		printf("checklis string: %s, lineOfCode string: %s, compare_res: %d\n", (*it).c_str(), lineOfCode.c_str(), compare_res);
		if(compare_res == 0)break;
	}
	return compare_res == 0;
}
//gfj added
int Executor :: loadCheckFiles(){
	using namespace std;
	//std::ifstream in("checklist_fileNames");
	ifstream ifs("checklist_fileNames",ios::in);
	if(!ifs){
		errs()<<"Fail to open checklist_fileNames, does it exist?\n";
		Haschecklist_fileNames = false;
		return 0;
	}
	Haschecklist_fileNames = true;
	string line;
	while(getline(ifs,line)){
		//errs()<<"checklist_fileNames: read one line:"<<line<<"\n";
		if(line!="")
			CheckFiles.insert(line);
	}
	ifs.close();
	//errs()<<"loadCheckList: finishing\n";
	return 1;
}

bool Executor::isCheckFile(std::string fileName){
	std::set<std::string> :: iterator it = CheckFiles.begin(), it_e = CheckFiles.end();
	int compare_res = -1;
	for (; it != it_e; ++it){
		compare_res = (*it).compare(fileName);
//		printf("Debug:");
		//printf("checklist string: %s, fileName string: %s, compare_res: %d\n", (*it).c_str(), fileName.c_str(), compare_res);
		if(compare_res == 0)break;
	}
	return compare_res == 0;
}
/*
int Executor :: _vscprintf(const char * format, va_list pargs){
	int retval;
	va_list argcopy;
	va_copy(argcopy,pargs);
	retval = vsnprintf(NULL, 0, format, argcopy);
	va_end(argcopy);
	return retval;
}
int Executor :: calculateFormatLen(char * format,...){
	va_list args;
	int len=1024;
	//I'm not sure 1024 is enough
	char * buf;
	va_start(args,format);
	len = _vscprintf(format,args)+1;
	printf("len is: %d\n",len);
	return len;
}
* */
//gfj end
