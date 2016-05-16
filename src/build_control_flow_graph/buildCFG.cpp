#define DEBUG_TYPE "buildCFG"
#include "llvm/Support/raw_ostream.h" 
#include "llvm/Support/CommandLine.h" 
#include "programCFG.h"
#include "targetPosition.h"
#include "convinent.h"
#include "ReverseSearchPath.h"
#include <vector>

using namespace llvm;
using namespace std;
//command line argument int n
//cl::opt<int >
//subpathLength("n",  
//  cl::desc("Subpath length"), cl::value_desc("length"));
cl::opt<string>
targetListFileName("targetList",
	cl::desc("target list file name"),cl::value_desc("fileName"));
namespace {
  // buildCFG - The first implementation, without getAnalysisUsage.
	struct buildCFG : public FunctionPass {
		static char ID; // Pass identification, replacement for typeid
		buildCFG() : FunctionPass(ID) {}
		bool doInitialization(Module &M);
		virtual bool runOnFunction(Function &F) ;
		virtual void getAnalysisUsage(AnalysisUsage &AU) const {
	     		AU.setPreservesCFG();
	    	}
	  };
}

bool buildCFG::doInitialization(Module &M){ 

	errs()<<"build programCFG-------------------------------------------------------------------\n";
	new ProgramCFG(M);
	std::vector<pair<BasicBlock*,BasicBlock*> > *target_point=NULL;
	if(!targetListFileName.empty())
		target_point=getTargetPoint(targetListFileName,M);
	errs()<<target_point->size()<<"\n";
	if(target_point->size()!=0){
		errs()<<"the path number is  "<<target_point->size()<<"\n";
		for(unsigned int i=0;i<target_point->size();i++){
			Function *main = M.getFunction("main");
			SearchReversePaths(target_point->at(i).first,target_point->at(i).second,&main->getEntryBlock(),M,i);
		}
	}
	else errs()<<"No valid path in checklist!!"<<"\n";
 	return false;
  
}

bool buildCFG::runOnFunction(Function &F) {   
	return false;
}
char buildCFG::ID = 0;
static RegisterPass<buildCFG> X("buildCFG", "build program CFG");
