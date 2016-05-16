
//---bty----realize functions which read file and save gudied info
#include "GuideExecutionInfo.h"

std::vector<GuideProfile> GuideProfile::fileread(const char* filename){
	std::vector<GuideProfile> guideinfo;
  	std::ifstream fin(filename);
 	std::string sstring;
 	fin >> sstring;
 	if (sstring.length() == 0)
          std::cout<<"Warning: GuideProfile is empty or not exist! "<<std::endl;
        else{
    		while (fin >> sstring) {
      			GuideProfile tempInfo;
      			tempInfo.file_name=sstring;
      			fin>>sstring;
      			tempInfo.Executionline=atoi(sstring.c_str());
      			guideinfo.push_back(tempInfo); 
    		}   
  	}
  	fin.close();
  	return guideinfo; 
}

std::string GuideProfile::toString(){
 	std::stringstream t_sstream;
  	t_sstream<<file_name<<"   "<<Executionline;
  	return t_sstream.str();
}

std::string filepathCanonical(std::string path){
	std::vector<std::string> path_vector;
  	std::stringstream streampath(path);
  	std::string sub_str;
  	std::string canonical_path;
	while(getline(streampath,sub_str,'/'))
		path_vector.push_back(sub_str);
	return path_vector.back();
}
