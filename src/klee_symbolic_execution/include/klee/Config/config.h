/* include/klee/Config/config.h.  Generated from config.h.in by configure.  */
/* include/klee/Config/config.h.in.  Generated from autoconf/configure.tmp.ac by autoheader.  */

#ifndef KLEE_CONFIG_CONFIG_H
#define KLEE_CONFIG_CONFIG_H

/* Does the platform use __ctype_b_loc, etc. */
#define HAVE_CTYPE_EXTERNALS 1

/* Define to 1 if you have the <inttypes.h> header file. */
#define HAVE_INTTYPES_H 1

/* Define to 1 if you have the `stp' library (-lstp). */
#define HAVE_LIBSTP 1

/* Define to 1 if you have the <memory.h> header file. */
#define HAVE_MEMORY_H 1

/* Define to 1 if you have the <selinux/selinux.h> header file. */
/* #undef HAVE_SELINUX_SELINUX_H */

/* Define to 1 if you have the <stdint.h> header file. */
#define HAVE_STDINT_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#define HAVE_STDLIB_H 1

/* Define to 1 if you have the <strings.h> header file. */
#define HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#define HAVE_STRING_H 1

/* Define to 1 if you have the <sys/acl.h> header file. */
/* #undef HAVE_SYS_ACL_H */

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* Define to 1 if you have the <unistd.h> header file. */
#define HAVE_UNISTD_H 1

/* Path to KLEE's uClibc */
#define KLEE_UCLIBC "/home/gfj/work/klee-uclibc"

/* LLVM version is release (instead of development) */
#define LLVM_IS_RELEASE 1

/* LLVM major version number */
#define LLVM_VERSION_MAJOR 2

/* LLVM minor version number */
#define LLVM_VERSION_MINOR 9

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT "daniel@minormatter.com"

/* Define to the full name of this package. */
#define PACKAGE_NAME "KLEE"

/* Define to the full name and version of this package. */
#define PACKAGE_STRING "KLEE 0.01"

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME "-klee-"

/* Define to the home page for this package. */
#define PACKAGE_URL ""

/* Define to the version of this package. */
#define PACKAGE_VERSION "0.01"

/* Configuration for runtime libraries */
#define RUNTIME_CONFIGURATION "Release+Asserts"

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

#endif
