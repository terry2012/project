#ifndef PROGRAMCFG_H
#define PROGRAMCFG_H
#include "llvm/BasicBlock.h"
#include "llvm/Support/CFG.h"
#include "llvm/Analysis/CallGraph.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Module.h" 
#include <vector> 
#include "convinent.h"


using namespace llvm;
using namespace std;
struct CFGNode;

//a succ link list
struct Succ{
	CFGNode *v;
	Succ *nextSucc;
	Succ(CFGNode* newNode):v(newNode),nextSucc(NULL){}
};

//a prev link list
struct Prev{
	CFGNode *v;
	Prev *nextPrev;
	Prev(CFGNode* newNode):v(newNode),nextPrev(NULL){}
};

struct CFGNode{
	BasicBlock *bb; 
	Succ* firstSucc; 
	Prev* firstPrev;
	string name;

	CFGNode(){
		CFGNode(NULL);
	}

	CFGNode (BasicBlock *b  ):bb(b),firstSucc(NULL),firstPrev(NULL) {  
		if(b){
			name = b->getParent()->getName().str()+"." + b->getName().str();
		}else {
			name  = "";
		}
		//errs()<<"CFGNode constructor: "<< name <<"\n";
	}

	void addSucc(CFGNode *succ){
		assert(succ && succ->bb);
		Succ *newSucc = new Succ(succ);
		if(firstSucc == NULL){
			firstSucc = newSucc; 
		}else{
			newSucc->nextSucc = firstSucc;
			firstSucc = newSucc;
		}
	}


	void addPrev(CFGNode *prev){
		assert(prev && prev->bb);
		Prev *newPrev = new Prev(prev);
		if(firstPrev == NULL){
			firstPrev = newPrev; 
		}else{
			newPrev->nextPrev = firstPrev;
			firstPrev = newPrev;
		}
	}

	Succ *getFirstSucc(){
		return firstSucc;
	}

	Prev *getFirstPrev(){
		return firstPrev;
	}

	bool operator == (const CFGNode &node){ 
		return  (bb == node.bb) ;
	}

	template<class Stream>
	friend Stream& operator << (Stream &outputStream,const CFGNode *node){
		if(node){
			outputStream << node->name<</*"," << node->id <<","<< node->lowlink <<*/""; 
		}
		return outputStream;
	}
};



class ProgramCFG{
private:
	void initTargetFunctionList(Module &m);
	void findAllRetBlocks(Module &m);
	void buildProgramCFG(Module &m);
	void createSucc(BasicBlock *v);
	void bfs(CFGNode *v);
	CFGNode* root;
	Module &M;
public:
	ProgramCFG(Module &m);
	static std::map<BasicBlock*, CFGNode> *nodes;
	CFGNode *getRoot(){
		return root;
	} 
};


#endif