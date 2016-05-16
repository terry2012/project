#ifndef CONVINENT_H
#define CONVINENT_H
#include "llvm/Constants.h"
#include <sstream>
#include "llvm/Constant.h"
#include "llvm/Pass.h" 
#include "llvm/Module.h" 
#include "llvm/Instructions.h"
#include "llvm/Instruction.h"
#include "llvm/LLVMContext.h" 
#include "llvm/Analysis/DebugInfo.h"
#include <string>
using namespace std;
using namespace llvm;

Constant* getGlobalString(string s, Module &M);

Constant* getLocation(Instruction* I,Module &M);

string getSourceFileName(Function *f);

int getLineNumber(Instruction* I);

string getFilename(Instruction* I);
#endif