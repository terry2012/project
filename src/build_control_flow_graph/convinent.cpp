#include "convinent.h"
#include "llvm/Support/raw_ostream.h"
using namespace std;
using namespace llvm;

Constant* getGlobalString(string s, Module &M){
	Constant *str_init = ConstantArray::get(getGlobalContext(),s);
	GlobalVariable *GV = new GlobalVariable(str_init->getType(), //TYpe* Ty
							true,		   //isConstant
		          				GlobalValue::InternalLinkage, //LinkageTypes
		          				str_init,			//Constant* Initializer=0
		          				"");			//Twine &Name=""	
	M.getGlobalList().push_back(GV); 
	//get the pointer to the global string variable 
	const  IntegerType *Int32Ty =Type::getInt32Ty(getGlobalContext()); 
	Constant * nullValue = Constant::getNullValue(Int32Ty);
	Constant*  index[]= {nullValue,nullValue};
	return ConstantExpr::getGetElementPtr(GV,index,2u); //the pointer to global string
}

Constant* getLocation(Instruction* I,Module &M){
	if (MDNode *N = I->getMetadata("dbg")) { // this if is never executed
		DILocation Loc(N);
		unsigned Line = Loc.getLineNumber();
		string dir = Loc.getDirectory().str();
		string name = Loc.getFilename().str();
		stringstream location;
		location<<dir<<name<<": "<< Line;
		//errs() << location.str() << "\n";
		return getGlobalString(location.str(),M);
		//return ConstantInt::get(Type::getInt32Ty(I->getContext()), Line);
	}else{
		//stub
		return getGlobalString("can't find debug info: ",M);
	}
	return NULL;
}

string getSourceFileName(Function *f){
	for(Function::iterator bb = f->begin(); bb != f->end(); bb++)
	for(BasicBlock::iterator i = bb->begin(); i != bb->end(); i++){
		if (MDNode *N = i->getMetadata("dbg")) { // this if is never executed
			DILocation Loc(N);
			string dir = Loc.getDirectory().str();
			string name = Loc.getFilename().str();
			stringstream fileName;
			fileName<<dir<<name;
			errs() << fileName.str() << "\n";
			return fileName.str();
			//return ConstantInt::get(Type::getInt32Ty(I->getContext()), Line);
		}

	}
	return "";
}

int getLineNumber(Instruction* I){
	if (MDNode *N = I->getMetadata("dbg")) { // this if is never executed
		DILocation Loc(N);
		return  Loc.getLineNumber();   
	}else{
		//stub
		return 0;
	} 
}

string getFilename(Instruction* I){
	if (MDNode *N = I->getMetadata("dbg")) { // this if is never executed
		DILocation Loc(N);
		return  Loc.getFilename().str();   
	}else{
		//stub
		return "";
	} 
}