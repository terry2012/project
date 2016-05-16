===========================================================

  This document includes development notations.
  Author: Fengjuan Gao


==========================================================
Modified files: 
instrument.py
MY_vsnprintf.h
MY_vsnprintf.c

7/6/2015

1.We have added new file instrument.py to repair a c/c++ source file's buffer overflow vulnerabilities.
Util now we can repair following bfo APIs:
strcpy,strncpy,strcat,strncat,sprintf,snprintf,memcpy,memmove,

BUFFER OVERFLOW CONDITIONS:
Strcpy---------Len(src)>=size(dest)
Strncpy、memcpy、memmove、memset Snprintf、vsnprintf	-------n>size(dest)
Strcat---------	len(src) + len(dest) >= size(dest)
strncat	-----min{len(src),n} + len(dest) >= size(dest)
Sprintf、vsprintf------len(format string）>= size(str)
char * fgets ( char * str, int num, FILE * stream )-------num > size(str)
size_t fread ( void * ptr, size_t size, size_t count, FILE * stream );-------	size*count > size(ptr)
ssize_t read(int fd, void *buf, size_t count);--------	count > size(buf)
Array bound-------------index*elementSize >= size(buf)

2.Specially:
when we need to repair sprintf bfo,we need copy these two files MY_vsnprintf.h and MY_vsnprintf.c to the dir where the repaired source file is.
Because we need to compute the format length to compare with the size of destination buffer.So,we need these two files.

3.Today,I tested strcpy,after repair,FORTIFY report Dangerous function instead of buffer overflow.

7/7/2015

1.Today,I tested sprintf,after repair,FORTIFY still report buffer overflow,but our symbolic execution bfo detection tool does not report bfo.
The shell commands used are as following:
(Attention:we need to compile MY_vsnprintf.c and link them together! )
fortify:
sourceanalyzer -b static1 gcc src.c MY_vsnprintf.c
llvm&klee:
llvm-gcc --emit-llvm -g -I /home/gfj/guided-symbolic-execution/validate_buffer_overflow/klee/include src.c -c -o src.o
llvm-gcc --emit-llvm -g MY_vsnprintf.c -c -o MY_vsnprintf.o
llvm-ld MY_vsnprintf.o src.o -o test
klee --max-time 2 --libc=uclibc --posix-runtime --guided-execution test.bc

7/8/2015

1.Today,I tested strcat,after repair,Fortify report nothing.
2.Today,I tested strncat,after repair,Fortify report nothing.
3.Today,I tested strncpy,it turned out that Fortify always cannot report the bfo vulnebility in strncpy.
4.Today,I tested memcpy,after repair,Fortify report nothing.
Attention:When compiling,we need -fno-builtin.
llvm-gcc --emit-llvm -g -fno-builtin -I /home/gfj/guided-symbolic-execution/validate_buffer_overflow/klee/include src.c -c -o test.bc 

7/9/2015

1.Array bound repair added,but I'm not sure it's enough.Now I only considered the pattern:buf[i]=x,buf can be char or int array.
After repair Fortify report nothing.
2.elementSize=sizeof(buf[0])
3.Other possible pattern:
a) char buf[2]="ing"(it's uncommon)
b) int x[2]={1,2,3}(it's uncommon)
c) *(buf+i)=x

7/10/2015

1.fgets,fread,read repair added.
2.Now our instrument.py can deal with command-line parameters.
3.strncpy:We use src_code.insert(lineNum-1,tab+'if('+n+' > sizeof('+dest+'))...
n may be an integer or a variable,We only dealed with variable,but when n is an integer(eg. 3),/*what we get from python is string,we need to turn it into integer.*/

7/15/2015

1.Deal with Command parameters:
default(add bound checking):
python instrument.py
python instrument.py --mode/-m default
API-REPLACEMENT:
python instrument.py --mode/-m API-REP

2.r = read(int fd, void *buf, size_t count);
We use split('read') to split arguments.So as other APIs.

3.API-REP:
strcpy----strncpy
strcat----snprintf
sprintf---snprintf
