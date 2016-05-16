#include "programCFG.h"
#include <vector> 

using namespace std;


//用于存储路径集合的数据结构
class ReverseSinglePath{//一条路径
public:	
	vector<CFGNode*> path;
	int length;
	CFGNode* head(){
		return path.front();
	}
	CFGNode* end(){
		return path.back();
	}
	void PathAddNode(CFGNode* node){
		path.push_back(node);
	}
	bool DecideCompletePath(CFGNode* beg,CFGNode* end){
		return 	end==path.back() && beg==path.front();
	}
	int PathFragmentLength(CFGNode* beg,CFGNode* end){
		unsigned int j=0;
		bool recognitionTag=false;
		for(unsigned int i=0;i<path.size();i++){
			if(path.at(i)==beg) 
				recognitionTag=true;
			if(recognitionTag==true)
				j++;
			if(path.at(i)==end)
				return j;
		}
		return 0;
	}
	int ContainPathFragment(ReverseSinglePath* rpath){
		int FragmentLength=PathFragmentLength(rpath->head(),rpath->end());
		if(FragmentLength==0) return 0;
		else if(length<FragmentLength) return 1;
		else if(length>FragmentLength) return -1;
		else if(length==FragmentLength) return -2;
			
	}
	void PrintPath(){
		for(unsigned int i=0;i<path.size();i++)
			errs()<<path.at(i)<<"->";
		errs()<<length<<"\n";
	}
};


void SearchReversePaths(BasicBlock* entry,BasicBlock* exit,BasicBlock* 	mainEntry,Module &m,int path_number);
int SuccNumber(CFGNode* node);
CFGNode* ConvertBBToNode(BasicBlock* block);
CFGNode* index_Succ(int index,CFGNode* node);
