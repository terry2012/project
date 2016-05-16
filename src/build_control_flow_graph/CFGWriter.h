#include "programCFG.h"

#include "llvm/Support/GraphWriter.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/DOTGraphTraits.h"
#include <vector>
#include <cassert>
using namespace llvm;

template <typename Ty>
class InterPCFGTraits:public DefaultDOTGraphTraits{	
 
public:
	InterPCFGTraits(bool simple = false):DefaultDOTGraphTraits(simple){}
  
 

  static std::string getGraphName(const ProgramCFG *p) {
    return "Inter Procedure CFG ";
  }

  static std::string getSimpleNodeLabel(const CFGNode *node,
                                  const ProgramCFG *Graph) {
  		return node->name;
/*
    std::string Str;
    raw_string_ostream OS(Str);

    WriteAsOperand(OS, Node, false);
    return OS.str();*/
  }

  static std::string getCompleteNodeLabel(const CFGNode *node, 
                                          const ProgramCFG *Graph) {
  	return node->name;
  	/*	BasicBlock *Node = node->bb;
    std::string Str;
    raw_string_ostream OS(Str);

    if (Node->getName().empty()) {
      WriteAsOperand(OS, Node, false);
      OS << ":";
    }

    OS << *Node;
    std::string OutStr = OS.str();
    if (OutStr[0] == '\n') OutStr.erase(OutStr.begin());

    // Process string output to make it nicer...
    for (unsigned i = 0; i != OutStr.length(); ++i)
      if (OutStr[i] == '\n') {                            // Left justify
        OutStr[i] = '\\';
        OutStr.insert(OutStr.begin()+i+1, 'l');
      } else if (OutStr[i] == ';') {                      // Delete comments!
        unsigned Idx = OutStr.find('\n', i+1);            // Find end of line
        OutStr.erase(OutStr.begin()+i, OutStr.begin()+Idx);
        --i;
      }

    return OutStr;*/
  }

  std::string getNodeLabel(const CFGNode *Node,
                           const ProgramCFG *Graph) {
   // if (isSimple())
      return getSimpleNodeLabel(Node, Graph);
   // else
    //  return getCompleteNodeLabel(Node, Graph);
  }
/*
  static std::string getEdgeSourceLabel(const BasicBlock *Node,
                                        succ_const_iterator I) {
    // Label source of conditional branches with "T" or "F"
    if (const BranchInst *BI = dyn_cast<BranchInst>(Node->getTerminator()))
      if (BI->isConditional())
        return (I == succ_begin(Node)) ? "T" : "F";
    
    // Label source of switch edges with the associated value.
    if (const SwitchInst *SI = dyn_cast<SwitchInst>(Node->getTerminator())) {
      unsigned SuccNo = I.getSuccessorIndex();

      if (SuccNo == 0) return "def";
      
      std::string Str;
      raw_string_ostream OS(Str);
      OS << SI->getCaseValue(SuccNo)->getValue();
      return OS.str();
    }    
    return "";
  }*/
};

class CFGWriter{
private:
	ProgramCFG *G; 
	raw_ostream &O;
	InterPCFGTraits<ProgramCFG> DTraits;
 typedef std::map<BasicBlock*, CFGNode>::iterator node_iterator;
   
public:
	CFGWriter(ProgramCFG *CFG,raw_ostream& out,bool isSimple = false):
	G(CFG),O(out),DTraits(isSimple){}

bool writeGraph(){

		Function &F = *G->getRoot()->bb->getParent();
		std::string Filename = "G." + F.getName().str() + ".dotxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
		errs() << "Writing '" << Filename << "'...";
		
		std::string ErrorInfo;
		raw_fd_ostream File(Filename.c_str(), ErrorInfo); 
		if (ErrorInfo.empty())
			writeGraph(Filename);
		else
			errs() << "  error opening file for writing!";
		errs() << "\n";
		return false;
	}

	void writeGraph(const std::string &Title = ""){
	 writeHeader(Title);

	 // Emit all of the nodes in the graph...
	 writeNodes();

	 // Output the end of the graph
	 writeFooter();
	}

// Writes the edge labels of the node to O and returns true if there are any
  // edge labels not equal to the empty string "".
  bool getEdgeSourceLabels(raw_ostream &O, CFGNode *Node) {
   /* //child_iterator EI = GTraits::child_begin(Node);
    //child_iterator EE = GTraits::child_end(Node);
    bool hasEdgeSourceLabels = false;

    for (unsigned i = 0; EI != EE && i != 64; ++EI, ++i) {
      std::string label = DTraits.getEdgeSourceLabel(Node, EI);

      if (label.empty())
        continue;

      hasEdgeSourceLabels = true;

      if (i)
        O << "|";

      O << "<s" << i << ">" << DOT::EscapeString(label);
    }

    if (EI != EE && hasEdgeSourceLabels)
      O << "|<s64>truncated...";

    return hasEdgeSourceLabels;*/
  }

	void writeHeader(const std::string &Title) { 

    if (!Title.empty())
      O << "digraph \"" << DOT::EscapeString(Title) << "\" {\n";
    else  
      O << "digraph unnamed {\n";
 
    if (!Title.empty())
      O << "\tlabel=\"" << DOT::EscapeString(Title) << "\";\n";
  
    O << "\n";
  }

  void writeFooter() {
    // Finish off the graph
    O << "}\n";
  }

  void writeNodes() {
    // Loop over the graph, printing it out...
    for (node_iterator I = G->nodes->begin(), E = G->nodes->end() ;
         I != E; ++I) 
        writeNode(I->second);
  }

  void writeNode(CFGNode& Node) {
    writeNode(&Node);
  }

  void writeNode(CFGNode *const *Node) {
    writeNode(*Node);
  }

  void writeNode(CFGNode *Node) { 

    O << "\tNode" << static_cast<const void*>(Node) << " [shape=record,"; 
    O << "label=\"{";

    if (!DTraits.renderGraphFromBottomUp()) {
      O << DOT::EscapeString(DTraits.getNodeLabel(Node, G));

      // If we should include the address of the node in the label, do so now.
      if (DTraits.hasNodeAddressLabel(Node, G))
        O << "|" << (void*)Node;
    }

    std::string edgeSourceLabels;
    raw_string_ostream EdgeSourceLabels(edgeSourceLabels);
    bool hasEdgeSourceLabels = getEdgeSourceLabels(EdgeSourceLabels, Node);

    if (hasEdgeSourceLabels) {
      if (!DTraits.renderGraphFromBottomUp()) O << "|";

      O << "{" << EdgeSourceLabels.str() << "}";

      if (DTraits.renderGraphFromBottomUp()) O << "|";
    }

    if (DTraits.renderGraphFromBottomUp()) {
      O << DOT::EscapeString(DTraits.getNodeLabel(Node, G));

      // If we should include the address of the node in the label, do so now.
      if (DTraits.hasNodeAddressLabel(Node, G))
        O << "|" << (void*)Node;
    }

    if (DTraits.hasEdgeDestLabels()) {
      O << "|{";

      unsigned i = 0, e = DTraits.numEdgeDestLabels(Node);
      for (; i != e && i != 64; ++i) {
        if (i) O << "|";
        O << "<d" << i << ">"
          << DOT::EscapeString(DTraits.getEdgeDestLabel(Node, i));
      }

      if (i != e)
        O << "|<d64>truncated...";
      O << "}";
    }

    O << "}\"];\n";   // Finish printing the "node" line

    // Output all of the edges now
    Succ* EI = Node->getFirstSucc();
 
    for (unsigned i = 0; EI != NULL && i != 64; EI = EI->nextSucc, ++i)
        writeEdge(Node, i, EI);
    for (; EI != NULL; EI = EI->nextSucc)
        writeEdge(Node, 64, EI); 
  }

  void writeEdge(CFGNode *Node, unsigned edgeidx, Succ* EI) {
    if (CFGNode *TargetNode = EI->v) {
      int DestPort = -1;
      if (DTraits.edgeTargetsEdgeSource(Node, EI)) {
        Succ* TargetIt = DTraits.getEdgeTarget(Node, EI);

        // Figure out which edge this targets...
      /*  unsigned Offset =
          (unsigned)std::distance(GTraits::child_begin(TargetNode), TargetIt);
        DestPort = static_cast<int>(Offset);*/
      }

      if (DTraits.getEdgeSourceLabel(Node, EI).empty())
        edgeidx = -1;

      emitEdge(static_cast<const void*>(Node), edgeidx,
               static_cast<const void*>(TargetNode), DestPort,
               DTraits.getEdgeAttributes(Node, EI, G));
    }
  }

  /// emitSimpleNode - Outputs a simple (non-record) node
  void emitSimpleNode(const void *ID, const std::string &Attr,
                      const std::string &Label, unsigned NumEdgeSources = 0,
                      const std::vector<std::string> *EdgeSourceLabels = 0) {
    O << "\tNode" << ID << "[ ";
    if (!Attr.empty())
      O << Attr << ",";
    O << " label =\"";
    if (NumEdgeSources) O << "{";
    O << DOT::EscapeString(Label);
    if (NumEdgeSources) {
      O << "|{";

      for (unsigned i = 0; i != NumEdgeSources; ++i) {
        if (i) O << "|";
        O << "<s" << i << ">";
        if (EdgeSourceLabels) O << DOT::EscapeString((*EdgeSourceLabels)[i]);
      }
      O << "}}";
    }
    O << "\"];\n";
  }

  /// emitEdge - Output an edge from a simple node into the graph...
  void emitEdge(const void *SrcNodeID, int SrcNodePort,
                const void *DestNodeID, int DestNodePort,
                const std::string &Attrs) {
    if (SrcNodePort  > 64) return;             // Eminating from truncated part?
    if (DestNodePort > 64) DestNodePort = 64;  // Targetting the truncated part?

    O << "\tNode" << SrcNodeID;
    if (SrcNodePort >= 0)
      O << ":s" << SrcNodePort;
    O << " -> Node" << DestNodeID;
    if (DestNodePort >= 0 && DTraits.hasEdgeDestLabels())
      O << ":d" << DestNodePort;

    if (!Attrs.empty())
      O << "[" << Attrs << "]";
    O << ";\n";
  }
  bool getEdgeSourceLabels(raw_string_ostream& o,CFGNode* node){
  	return false;
  }
};

 