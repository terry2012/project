#include "MY_vsnprintf.h"

int MY_vsnprintf(char * format,...){
	va_list args;
	va_start(args,format);
	return vsnprintf(NULL,0,format,args);
}
