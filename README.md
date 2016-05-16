

BovInspector can be used in the following steps:  

1. Extract the results of Fortify. Use ./fvdlParser audit.fvdl file to get static buffer overflow warnings. We save these warnings in the file checklist_bufferoverflow.   

2. Install llvm2.9.Compile the testcase to LLVM bitcode.  

3. Use opt –load buildCFG.so –buildCFG –targetList=checklist_bufferoverflow <XX.bc>/dev/null to generate GuideSrc.txt. GuideSrc.txt is consist of warning paths.   

4. Rebuild klee in dirctory src/klee symbolic execution,and the new executable file klee in the directory Release+Asserts/bin will be used in step 5. 

    install llvm2.9, stp and klee-uclibc according to http://klee.github.io/build-llvm29/  (namely steps before number 5) 
    
	./configure --with-llvm=/home/$(whoami)/work/llvm-2.9 --with-stp=/home/$(whoami)/work/stp_install --with-uclibc=/home/$(whoami)/work/klee-uclibc --enable-posix-runtime   

	make -j $(grep -c processor /proc/cpuinfo) ENABLE_OPTIMIZED=1

5. Use our extended klee to inspect buffer overflows with command line option --guided-execution and additional input file GuideSrc.txt.    

6. Use python repair.py to repair the vulnerabilities that have been validated. Specially, when we need to repair sprintf buffer overflow, we need copy these two files MY_vsnprintf.h and MY_vsnprintf.c to the directory where the repaired source file is. This is because we need to compute the format length to compare with the size of destination buffer.

7. You can use the files under /project/test_cases/UsefulComands for reference.
