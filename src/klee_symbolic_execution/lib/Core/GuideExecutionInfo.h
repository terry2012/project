//----bty----define GuideProfile---
#pragma once 
#include <fstream>
#include <vector>
#include <iostream>
#include <sstream>
#include <stdlib.h>


	class GuideProfile{
     	public:
      		std::string file_name;
       		unsigned int Executionline;
        	GuideProfile():Executionline(0){}
      		static std::vector<GuideProfile> fileread(const char* filename);
      		std::string toString();
   	};

std::string filepathCanonical(std::string path);

