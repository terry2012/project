#include "programCFG.h"
#include "mylib/printSTL.h"
#include <stack>
#include "CFGWriter.h"

using namespace llvm;
 std::map<BasicBlock*, CFGNode>* ProgramCFG::nodes = NULL;
	ProgramCFG::ProgramCFG(Module &m):M(m){
		root = NULL;
		buildProgramCFG(m);
		std::string errorInfo="";
		raw_fd_ostream File("ProgramCFG.dot",errorInfo);
		CFGWriter cfgWriter(this,File,true);
	 cfgWriter.writeGraph("ProgramCFG");
	 errs() << "*************Please check the file ProgramCFG.dot**********\n";
	}

enum color{WHITE,BLACK,GRAY};
std::map<BasicBlock*, color> *colors;

std::map<Function*, std::vector<BasicBlock*> > *retBlocks;
std::set<Function*> *targetFunctionList; //only use in search
unsigned id = 0;
unsigned n = 1;

void ProgramCFG:: initTargetFunctionList(Module& m){
	//string targetFileName =  getSourceFileName(m.getFunction("main"));//get the file contains the function main()
	
/*	//only contains the functions in the main file
	for(Module::iterator f = m.begin(); f!= m.end(); f++){
		if(f->isDeclaration()) continue;
		if(targetFileName == getSourceFileName(f)) 
			targetFunctionList->insert(f);
	}*/

	//contains All function
	for(Module:: iterator f= m.begin(); f != m.end(); f++){
		if(f->isDeclaration()) continue;
		targetFunctionList->insert(f);
	}	
 
	//print set
 	for(std::set<Function*>::iterator iter  = targetFunctionList->begin(); iter   != targetFunctionList->end(); iter ++){
		errs()<<"Target FUnction LIst:"<< (*iter)->getName()<<"\n";
	} 
}



void ProgramCFG::findAllRetBlocks(Module &m){
	for(Module::iterator f = m.begin(); f!= m.end(); f++){
		if(f->getName() == "main") continue;
		if(targetFunctionList->find(f) == targetFunctionList->end()) continue;//didn't find in target func list 
		for(Function::iterator bb = f->begin(); bb != f->end(); bb++){
			TerminatorInst *terminator = bb->getTerminator();
			if(isa<ReturnInst>(terminator) ){
				//errs() <<"ret basicblock :in "<<f->getName()<<"\t"<<*terminator << "\n";
				((*retBlocks)[f]).push_back(bb);
			}/*else if(isa<UnreachableInst>(terminator)) {
				//errs()<<"hehe: "<<f->getName() <<"\t"<<*bb<<"\n";//bb contains exit ,abort or xalloc_die
			}*/
		}
	}

	//errs() << (*retBlocks) << "\n";

}

//build program cfg in the main source file !
void  ProgramCFG::buildProgramCFG(Module &m){
	Function *main = M.getFunction("main");  
	colors = new std::map<BasicBlock*, color>;
	nodes = new std::map<BasicBlock*, CFGNode>;
	retBlocks = new std::map<Function*, std::vector<BasicBlock*> > ;
	targetFunctionList = new std::set<Function*> ; //only use in search
	//init main node and color
	
	initTargetFunctionList(m);
	findAllRetBlocks(m);

	//prepare to create CFG
	for(Module::iterator f = m.begin(); f != m.end(); f++){ 
		if(targetFunctionList->find(f) == targetFunctionList->end()) continue; //only concerns the function in the main's file.

		for(Function::iterator bb = f->begin(); bb != f->end(); bb++){
			colors->insert(make_pair(bb,WHITE));
			nodes->insert(make_pair(bb, CFGNode(bb)));
		}
	}
	createSucc(&main->getEntryBlock());
	root = &((*nodes)[&main->getEntryBlock()]);

	//test the cfg using bfs
	for(Module::iterator f = m.begin(); f != m.end(); f++)
	for(Function::iterator bb = f->begin(); bb != f->end(); bb++){
		(*colors)[bb] = WHITE; 
	}
	/*test*/
	//bfs(root);
	delete colors; 
	delete retBlocks;
	delete targetFunctionList;
}

int dfscount = 0;

void ProgramCFG::createSucc(BasicBlock *v){
	(*colors)[v] = GRAY;

	std::vector<CFGNode*> currentNodes ;

	//currentNodes is a node list in which nodes are waiting for find succ.
	currentNodes.push_back(&((*nodes)[v]));//first currentNodes is v
	
	///errs()<<dfscount++<<" dfs: "<<(*nodes)[v].name<<"\n";

	for(BasicBlock::iterator inst = v->begin(); inst != v->end(); inst ++){
		//errs() << *inst<<"\n";
		if(CallInst* call = dyn_cast<CallInst>(inst)){
 			
 			if(isa<UnreachableInst>(++inst)){//exit ,abort ,xalloc_die, program exit.
				///errs()<< *(--inst)<<"\n"; 
				goto finish;
			}
			--inst; 
			Function *f = call->getCalledFunction();

			//If there is a call asm instruction, the return value of getCalledFunction will be null.
			//So we just ignore it.
			if(!f) continue;

			if(f->isDeclaration()) { 
				continue;
			} 
			//only concerns the function in the targetFunctionList
		//	if(targetFunctionList->find(f) == targetFunctionList->end()) continue; 

		 //	errs() << "find a call : "<< f->getName() << "\n "; 

			BasicBlock *entry = &f->getEntryBlock(); 
			CFGNode *entryNode =  &((*nodes)[entry]);//f's EntryBlock 
			while(!currentNodes.empty()){
				//link succ and prev to each other
				currentNodes.back()->addSucc(entryNode);
				entryNode->addPrev(currentNodes.back());
				currentNodes.pop_back();
			}

			if((*colors)[entry] == WHITE){//dfs
				createSucc(entry);
			}

			for(std::vector<BasicBlock*>::iterator ret= (*retBlocks)[f].begin();
				ret != (*retBlocks)[f].end(); 
				ret++){
				currentNodes.push_back(&((*nodes)[*ret]));
			}
		}
	}

	while(!currentNodes.empty()){
		CFGNode* current = currentNodes.back();
		currentNodes.pop_back();
		for(succ_iterator succ = succ_begin(v),end = succ_end(v);
			succ != end;
			succ++){
			CFGNode *succNode = &((*nodes)[*succ]);
			current->addSucc(succNode);
			succNode->addPrev(current);
			if((*colors)[*succ] == WHITE){
				createSucc(*succ);
			}
		}
	}
finish:

	//errs()<<"dfs back\n";
	(*colors)[v] = BLACK;
}
 

 //test programCFG,CHECK THE program cfg 
void ProgramCFG::bfs(CFGNode *r){
	if (r == NULL) return; 
	deque<CFGNode*> q;
	(*colors)[r->bb] = GRAY;
	q.push_front(r);
	///errs() <<"WHITE:"<<WHITE<<"BLACK:"<<BLACK<<"GRAY:"<<GRAY<<"\n";
	while(!q.empty()){
		r = q.back();
		q.pop_back();
		///errs() << r->name<<"\n  succ: {";
		Succ *child = r->getFirstSucc();
		while(child){
			///errs()<< child->v->name<<"("<<(*colors)[child->v->bb]<<"), ";
			if((*colors)[child->v->bb] == WHITE){//not visit
				//errs() << "add: "<<child->v->name;
				(*colors)[child->v->bb] = GRAY;
				q.push_front(child->v);
			}
			child = child->nextSucc;
		}
		(*colors)[r->bb] = BLACK;
		///errs() << "}\n  prev: { ";
		Prev *prev = r->getFirstPrev();
		while(prev){
			///errs() << prev -> v->name << "(" << (*colors)[prev->v->bb] << "), ";
			prev = prev->nextPrev;
		}
		///errs() << "}\n";

	}
}
