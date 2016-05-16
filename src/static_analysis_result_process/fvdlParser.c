/**
 * Add buffer overflow checklist in the output
 * the name of the output file is 'checklist_bufferoverflow'
 * Author: Yongchao Li
 */




#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <regex.h>
#include <string.h>
#include <libxml/parser.h>
#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>

char * VulTy[] = {"bufferoverflow", "memoryleak"};
xmlNodeSetPtr NodeRefs = NULL;
int matchReg(char* str1,char* str2){
	regex_t regex;
	int reti;
	char msgbuf[100];

	reti=regcomp(&regex, str2,0);
	if(reti){
		fprintf(stderr,"could not compile regex \n");
		exit(1);
	}
	reti=regexec(&regex,str1,0,NULL,0);
	if(!reti)
		return 1;
	else if(reti == REG_NOMATCH)
		return 0;
	else{
		regerror(reti,&regex,msgbuf,sizeof(msgbuf));
		fprintf(stderr,"Regex match failed: %s\n",msgbuf);
		exit(1);
	}
}

xmlDocPtr getFvdlDoc(char* docname){

	xmlDocPtr doc;
	xmlNodePtr cur;
	xmlKeepBlanksDefault(0);
	doc=xmlParseFile(docname);
	if(NULL==doc){
		fprintf(stderr,"Document not parsed successfully. \n");
		exit(1);
	}
	cur=xmlDocGetRootElement(doc);

	if(NULL==cur){
		fprintf(stderr,"empty document\n");
		xmlFreeDoc(doc);
		return NULL;
	}
	//printf("%d\n",xmlStrcmp(cur->name,(const xmlChar*)"FVDL"));	FVDL->0 same->0
	if(xmlStrcmp(cur->name,(const xmlChar*)"FVDL")){
		fprintf(stderr,"%s is not a FVDL file!\n",docname);
		xmlFreeDoc(doc);
		return NULL;
	}
	
	return doc;
}

xmlXPathObjectPtr getnodeset(xmlDocPtr doc, xmlChar *xpath){
	int status;
	xmlXPathContextPtr context;
	xmlXPathObjectPtr result;

	context = xmlXPathNewContext(doc);
	status = xmlXPathRegisterNs(context,(const xmlChar*)"fvdl",
			(const xmlChar*)"xmlns://www.fortifysoftware.com/schema/fvdl");
	if(status!=0){
		fprintf(stderr,"XML Namespace register fail\n");
		xmlXPathFreeContext(context);
		exit(1);	
	}
	result = xmlXPathEvalExpression(xpath,context);
	if(xmlXPathNodeSetIsEmpty(result->nodesetval)){
		//fprintf(stderr,"No result\n");
		xmlXPathFreeContext(context);
		return NULL;
	}
	xmlXPathFreeContext(context);
	return result;

}
int isAssignOrReturn(xmlChar* actionType){
	if(!xmlStrcmp(actionType,(const xmlChar*)"Assign"))
		return 1;
	else if(!xmlStrcmp(actionType,(const xmlChar*)"Return"))
		return 1;
	else 
		return 0;
}
void getTraceInfo(xmlDocPtr doc,xmlNodePtr cur, FILE* fp){
	int i,j;
	xmlChar* nodeXpath=(unsigned char*)"//fvdl:Primary/fvdl:Entry/fvdl:Node";
	xmlNodeSetPtr nodeset;

	xmlXPathObjectPtr result;
	xmlNodePtr nodeChild;
	xmlNodePtr reasonChildNode;
	xmlChar* refxpath=NULL;
	xmlNodeSetPtr refNodeset=NULL;
	xmlXPathObjectPtr refResult=NULL;

	xmlChar *file,*line,*actionType,*actionString;
	//xmlChar *lineEnd
	xmlChar *markWord=NULL;
	xmlChar *traceRefId;
	
	result=getnodeset((xmlDocPtr)cur,nodeXpath);
	if(result){
		nodeset = result ->nodesetval;
		for(i=0;i<nodeset->nodeNr;i++){
			nodeChild=nodeset->nodeTab[i]->xmlChildrenNode;
			while(nodeChild!=NULL){
				if(!xmlStrcmp(nodeChild->name,(const xmlChar*)"SourceLocation")){
					file=xmlGetProp(nodeChild,(const xmlChar*)"path");
					line=xmlGetProp(nodeChild,(const xmlChar*)"line");
					//lineEnd=xmlGetProp(nodeChild,(const xmlChar*)"lineEnd");
					//assert(!xmlStrcmp(line,lineEnd));
					fprintf(fp,"%s\t%s\t",file,line);
					
					xmlFree(file);
					xmlFree(line);
					//xmlFree(lineEnd);
				}else if(!xmlStrcmp(nodeChild->name,(const xmlChar*)"Action")){
					actionType=xmlGetProp(nodeChild,(const xmlChar*)"type");
					actionString=xmlNodeListGetString(doc,nodeChild->xmlChildrenNode,1);
					if(!xmlStrcmp(actionType,(const xmlChar*)"BranchNotTaken")){
                        if(matchReg((char*)actionString,(char*)"^Branch not taken: (create_html_directory(.*) != 0)$")){
                            markWord=(unsigned char*)"BT";      //!func() -> cil reverse branch , and we have to reverse
                        }else
                            markWord=(unsigned char*)"BF";		//branch false
                    }
					else if(!xmlStrcmp(actionType,(const xmlChar*)"BranchTaken")){
                        if(matchReg((char*)actionString,(char*)"Branch taken: (create_heml_directory(.*) == 0)$")){
                            markWord=(unsigned char*)"BF";
                        }else
                            markWord=(unsigned char*)"BT";		//branch true
                    }
					else if(isAssignOrReturn(actionType)
						&& (matchReg((char*)actionString,(char*)"^.* malloc.*$") || matchReg((char*)actionString,(char*)"^malloc.*$")))
						markWord=(unsigned char*)"MA";
					else if(isAssignOrReturn(actionType)
						&& (matchReg((char*)actionString,(char*)"^.* calloc.*$") || matchReg((char*)actionString,(char*)"^calloc.*$")))
						markWord=(unsigned char*)"CA";
					else if(isAssignOrReturn(actionType)
						&& (matchReg((char*)actionString,(char*)"^.* realloc.*$") || matchReg((char*)actionString,(char*)"^realloc.*$")))
						markWord=(unsigned char*)"RA";
					else if(isAssignOrReturn(actionType)
						&& (matchReg((char*)actionString,(char*)"^.* xmalloc.*$") || matchReg((char*)actionString,(char*)"^xmalloc.*$")))
						markWord=(unsigned char*)"MA";
					else if(isAssignOrReturn(actionType)
						&& (matchReg((char*)actionString,(char*)"^.* xstrdup.*$") || matchReg((char*)actionString,(char*)"^xstrdup.*$")))
						markWord=(unsigned char*)"XSD";
					else if(isAssignOrReturn(actionType)
						&& (matchReg((char*)actionString,(char*)"^.* xcalloc.*$") || matchReg((char*)actionString,(char*)"^xcalloc.*$")))
						markWord=(unsigned char*)"CA";
					else if(isAssignOrReturn(actionType)
						&& (matchReg((char*)actionString,(char*)"^.* xrealloc.*$") || matchReg((char*)actionString,(char*)"^xrealloc.*$")))
						markWord=(unsigned char*)"RA";
					else if((!xmlStrcmp(actionType,(const xmlChar*)"EndScope")) 
								&& matchReg((char*)actionString,(char*)"^.*Memory leaked$"))
						markWord=(unsigned char*)"LK";		//leak point
					else
						markWord=(unsigned char*)"PP";		//normal path point

					fprintf(fp,"%s\n",markWord);
					xmlFree(actionType);
					xmlFree(actionString);
				}else if(!xmlStrcmp(nodeChild->name,(const xmlChar*)"Reason")){
					reasonChildNode = nodeChild->xmlChildrenNode;
					if(!xmlStrcmp(reasonChildNode->name,(const xmlChar*)"TraceRef")){
						traceRefId=xmlGetProp(reasonChildNode,(const xmlChar*)"id");	
						//printf("%s\n",traceRefId);
						refxpath=(unsigned char*)"//fvdl:UnifiedTracePool/fvdl:Trace";
						refResult=getnodeset(doc,refxpath);
						if(refResult){
							refNodeset = refResult ->nodesetval;
							for(j=0;j< refNodeset->nodeNr; j++){
								if(!xmlStrcmp(traceRefId,xmlGetProp(refNodeset->nodeTab[j],(const xmlChar*)"id"))){
									//fprintf(fp,"BEGIN_TraceRef\tRefId:%s\n",traceRefId);
									getTraceInfo(doc,refNodeset->nodeTab[j],fp);
									//fprintf(fp,"END_TraceRef");
								}
							}
							xmlXPathFreeObject(refResult);
						}
					}
				}
				nodeChild=nodeChild->next;
			}
			//fprintf(fp,"\n");
		}
		xmlXPathFreeObject(result);
	}
}
xmlNodePtr getNodeFromRefID(xmlNodeSetPtr nodes, xmlChar * nodeID){
        xmlNodePtr retNode = NULL;
	int ID = atoi((char *)nodeID);
	retNode = nodes->nodeTab[ID];
	return retNode;
}

// return the last index of c in str
// the index starts from 0
int fvlastIndexof(char * str, unsigned char c) {
	int i = 0, last = 0;
	if(!str)return -1;
	for(; str[i] != 0; i++) {
		if(str[i] == c)last = i;
	}
	return last;
}

// returns substring of str start from index start
char * fvsubstr(char * str, int start) {
	char * hander = str;
	if(!str || start >= strlen(str))
		return NULL;
	while(start) {
		hander++;
		start--;
	}
	strcpy(str, hander);
	return str;
}
// Judge whether there is c in the str in case
int fvcontains(char * str, char c) {
	int i = 0;
	if(str == NULL)return 0;
	for(; str[i] != 0; i++)
		if(str[i] == c)return 1;
	return 0;
}


// Iteratively output check list on every single vulnerablity
// Do not simply use <Trace> nodes, cause it loses the informatin
// of <Context>
// vulTy specifies the type of vulnerability, such as, "bufferoverflow", "memoryleak"
// see gloable variable VulType
void getTraceInfoForBufferOverflow(xmlDocPtr doc, xmlNodePtr vulNode, FILE * fp){
	int i = 0;     // noderef is 1 means that we should find Node from NodeRef
	xmlChar * xpath = (unsigned char *)"//fvdl:Primary/fvdl:Entry";
	xmlNodePtr child = NULL, cur_entry = NULL, sourcelocation = NULL;
	xmlNodeSetPtr Entry = getnodeset((xmlDocPtr)vulNode, xpath)->nodesetval;
	xmlNodePtr cur_node = NULL;
	xmlChar * file = NULL, * line = NULL;
	xmlChar * tags[3] = {"DEF", "N/A", "BOF"};
	for(; i < Entry->nodeNr; i++){
		cur_entry = Entry->nodeTab[i];
		child = cur_entry->children;
		if(!xmlStrcmp(child->name, (const xmlChar*)"NodeRef")){
			if(!NodeRefs){
				// We haven`t got NodeRef, now get it
				NodeRefs = getnodeset(doc, (unsigned char *)"//fvdl:UnifiedNodePool/fvdl:Node")->nodesetval;
			}
			cur_node = getNodeFromRefID(NodeRefs, xmlGetProp(child, (xmlChar *)"id"));
		}
		else
			cur_node = child;
		// Get file and line number !
		sourcelocation = cur_node->children;
		file = xmlGetProp(sourcelocation, (xmlChar *)"path");
		int absolutepath = fvcontains((char *)file, '/');
		// If it is an absolute path, we should simplify it.
		// Make it look like this: src.c rather than /home/xxx/xxx/src/src.c
		if(absolutepath == 1)file = (xmlChar *)fvsubstr((char *)file, fvlastIndexof((char *)file, '/') + 1);
		line = xmlGetProp(sourcelocation, (xmlChar *)"line");	
		if(i == 0)
			fprintf(fp, "%s\t%s\t%s\n", file, line, tags[0]);
		else if(i == Entry->nodeNr - 1)
			fprintf(fp, "%s\t%s\t%s\n", file, line, tags[2]);
		else
			fprintf(fp, "%s\t%s\t%s\n", file, line, tags[1]);
		
	}
}


int main(int argc, char** argv){
	int i;
	char* fvdlDocName;
	xmlDocPtr doc;

	FILE *fp=NULL, *fp_buf = NULL;
	xmlChar *xpath=(unsigned char*)"//fvdl:Vulnerability[./fvdl:ClassInfo/fvdl:Type='Memory Leak']"
					"/fvdl:AnalysisInfo/fvdl:Unified/fvdl:Trace";
	xmlChar *xpath_buf = (unsigned char *)"//fvdl:Vulnerability[./fvdl:ClassInfo/fvdl:Type='Buffer Overflow']"
					     "/fvdl:AnalysisInfo/fvdl:Unified/fvdl:Trace"; // Inlcudes Context info required to obtain the caller function
	xmlNodeSetPtr nodeset;
	xmlXPathObjectPtr result, result_buf = NULL;

	if(argc <=1){
		printf("Usage: %s docname\n",argv[0]);
		return (0);
	}

	fvdlDocName=argv[1];
	doc=getFvdlDoc(fvdlDocName);

	if(NULL!=doc){
		result=getnodeset(doc, xpath);
		result_buf = getnodeset(doc, xpath_buf);
	}
	else
		return (0);
		
	if(result){
		fp=fopen("checklists","w");
		nodeset = result->nodesetval;
		for(i=0;i< nodeset->nodeNr; i++){
			fprintf(stderr,"%d\n",i);
			fprintf(fp,"%d\n",i);
			getTraceInfo(doc,nodeset->nodeTab[i],fp);
			fprintf(fp,"END_PATH\n");
		}
		xmlXPathFreeObject(result);
	}else{
		printf("no result for xpath: %s\n", xpath);
	}
	if(result_buf){
		fp_buf = fopen("checklist_bufferoverflow", "w");
		if(!fp_buf){
			printf("Failed to open file %s\n", "checklist_bufferoverflow");
			return 0;
		}
		nodeset = result_buf->nodesetval;
		for(i = 0; i < nodeset->nodeNr; i++){
			fprintf(stderr, "%d\n", i);
			fprintf(fp_buf, "%d\n", i);
			getTraceInfoForBufferOverflow(doc, nodeset->nodeTab[i], fp_buf);
			fprintf(fp_buf, "END_PATH\n");
		}
		xmlXPathFreeObject(result_buf);
	}
	else
		printf("no result for xpath: %s\n",xpath_buf);

	if(fp)
		fclose(fp);
	if(fp_buf)
		fclose(fp_buf);
	xmlFreeDoc(doc);
	xmlCleanupParser();
	return(1);

}
