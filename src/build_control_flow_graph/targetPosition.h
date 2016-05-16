#ifndef TARGETPOSITION_H
#define TARGETPOSITION_H
#include "llvm/Module.h"
#include <string>
using namespace std;
using namespace llvm;

Instruction* getInstFromFilenameAndLineNum(string filename,int lineNum,Module& M);

/*
* The function can find all the memory leak points reported by Fortify.
* The return value is a vector pointer,in which every element of vector 
* is a pair of BasicBlock pointers.The 2 pointers point to the begin and end
* of a memory leak path respectively.
*
*@param: the fortify report file name.
*/
std::vector<pair<BasicBlock*,BasicBlock*> > *getTargetPoint(string targetListFile,Module& M );

#endif
