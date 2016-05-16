#include "targetPosition.h"
#include "convinent.h"
#include "ReverseSearchPath.h"
#include "llvm/Support/raw_ostream.h"
#include <fstream>
#include <map>

std::map<pair<CFGNode*,CFGNode*>,std::vector<CFGNode*> >* FortifyPath;
void InsertOverflowUsePoint(std::vector<CFGNode*>* OverflowUsePoint,CFGNode* cfgnode){
	unsigned int i=0;
	for(;i<OverflowUsePoint->size();i++)
		if(OverflowUsePoint->at(i)==cfgnode)
			break;
	if(i==OverflowUsePoint->size()) {OverflowUsePoint->push_back(cfgnode);/*errs() << "Success insert "  << "\n";*/};
}


Instruction* getInstFromFilenameAndLineNum(string filename,int lineNum,Module& M){
	for(Module::iterator f = M.begin(), E = M.end(); f != E; ++f) { 
		if(f->isDeclaration()) continue;  
		//errs()<<"function name: " << F.getName() <<"\n";
		for(Function::iterator BB = f->begin(); BB != f->end(); BB++)
		for(BasicBlock::iterator I = BB->begin(), E = BB->end(); I != E;I++){ 
		        //errs()<<getFilename(I)<<"\n";
		        //errs()<<getLineNumber(I)<<"\n";
			//errs()<<filename<<"\n";
		        //errs()<<lineNum<<"\n";
			if(filename == getFilename(I) && lineNum == getLineNumber(I) ){
			 return I;
			}
		}
	}
		return NULL;
}


/*
* The function can find all the memory leak points reported by Fortify.
* The return value is a vector pointer,in which every element of vector 
* is a pair of BasicBlock pointers.The 2 pointers point to the begin and end
* of a memory leak path respectively.
*
*@param: the fortify report file name.
*/
std::vector<pair<BasicBlock*,BasicBlock*> > *getTargetPoint(string targetListFile,Module& M ){
	ifstream fin(targetListFile.c_str());
	if(!fin){
		errs() << "Failed to open file " <<targetListFile << "\n";
		return NULL;
	}

	errs() << "------------------In getTargetPoint print leak point------------\n";
	std::vector<pair<BasicBlock*,BasicBlock*> > *targetPoint = 
		new	std::vector<pair<BasicBlock*,BasicBlock*> >(); 
	BasicBlock* begin = NULL,*end = NULL; 
	int count = -1;
	string fileName = "";
	int lineNum = 0;
	string tag = "";

	std::vector<CFGNode*>* OverflowUsePoint;
	FortifyPath=new std::map<pair<CFGNode*,CFGNode*>,std::vector<CFGNode*> >();
	//read memory allocation point and memory leak point of every Fortify reported path.
	while(fin >> count){
		//errs() <<"No "<< count << " path\n";
		OverflowUsePoint=new std::vector<CFGNode*>();
		while(1){
			fin>> fileName;
			if(fileName == "END_PATH") {
				if(begin != NULL && end != NULL)
					FortifyPath->insert(map<pair<CFGNode*,CFGNode*>,std::vector<CFGNode*> >::value_type(make_pair(ConvertBBToNode(begin),ConvertBBToNode(end)),(*OverflowUsePoint)));
				break;
			}
			fin >> lineNum;
			fin >> tag;
			if(tag == "DEF")
			{
				
				//Find the memory allocation basic block.
				Instruction *I = getInstFromFilenameAndLineNum(fileName,lineNum,M);
				if(I){
					begin = I->getParent();
				}else
					begin = NULL;

			}else if (tag == "BOF"){
				//Find the memory leak basic block.
				Instruction* I = getInstFromFilenameAndLineNum(fileName,lineNum,M);
				if(I){
					end = I->getParent();
				}else
					end = NULL;

				if(begin && end){
					targetPoint->push_back(make_pair(begin,end));
					
					
				}else{
					errs() << "In getTargetPoint(): begin = "<< begin << "end = " << end << "\n";
				}

			}/*else if( (tag=="BF") || (tag=="BT")){
				// Find memroy leak used basic block 
				Instruction *I = getInstFromFilenameAndLineNum(fileName,lineNum,M);
				BasicBlock* ParentBlock=I->getParent();
				int ChildrenNumber=SuccNumber(ConvertBBToNode(ParentBlock));
				if(ChildrenNumber > 2)
					errs() << "Warning: When handle BF && BT,the parent have more than two children"<< "\n";			
				else if(ChildrenNumber == 1 ){
					
					InsertLeakUsePoint(LeakUsePoint,ConvertBBToNode(ParentBlock)->firstSucc->v);
				}else{
					BasicBlock::iterator ir=index_Succ(0,ConvertBBToNode(ParentBlock))->bb->begin();
					BasicBlock::iterator it=index_Succ(1,ConvertBBToNode(ParentBlock))->bb->begin();
					if( tag == "BF" ){
						if(getLineNumber(ir)>getLineNumber(it))
							InsertLeakUsePoint(LeakUsePoint,index_Succ(0,ConvertBBToNode(ParentBlock)));	
						else
							InsertLeakUsePoint(LeakUsePoint,index_Succ(1,ConvertBBToNode(ParentBlock)));						
						
					}else if( tag == "BT" ){
						if(getLineNumber(ir)>getLineNumber(it))
							InsertLeakUsePoint(LeakUsePoint,index_Succ(1,ConvertBBToNode(ParentBlock)));	
						else
							InsertLeakUsePoint(LeakUsePoint,index_Succ(0,ConvertBBToNode(ParentBlock)));		
					}						
				}				
				
			}*/
			else if(tag == "N/A"){
				// Find memroy overflow used basic block
				Instruction* I = getInstFromFilenameAndLineNum(fileName,lineNum,M);
				BasicBlock* MemoryOverflowBlock=NULL;
				if(I)
					MemoryOverflowBlock=I->getParent();
				InsertOverflowUsePoint(OverflowUsePoint,ConvertBBToNode(MemoryOverflowBlock));
			}
		}
	}

	//Print the result
	for(std::vector<pair<BasicBlock*,BasicBlock*> >::iterator iter = targetPoint->begin();
		iter != targetPoint->end(); iter++){
		///errs()<< "Mem alloc block: in function "<<iter->first->getParent()->getName()<< *(iter->first)
			///<< "Mem Leak block: in function "<<iter->second->getParent()->getName() << *(iter->second)<<"\n" ;
	}
	errs() << "------------------End of getTargetPoint -------------------------\n";
	return targetPoint;
}


