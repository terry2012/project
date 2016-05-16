; ModuleID = 'fd_init.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-f128:128:128-n8:16:32"
target triple = "i386-pc-linux-gnu"

%struct.exe_disk_file_t = type { i32, i8*, %struct.stat64* }
%struct.exe_file_system_t = type { i32, %struct.exe_disk_file_t*, %struct.exe_disk_file_t*, i32, %struct.exe_disk_file_t*, i32, i32*, i32*, i32*, i32*, i32*, i32*, i32* }
%struct.exe_file_t = type { i32, i32, i64, %struct.exe_disk_file_t* }
%struct.exe_sym_env_t = type { [32 x %struct.exe_file_t], i32, i32, i32 }
%struct.stat64 = type { i64, i32, i32, i32, i32, i32, i32, i64, i32, i64, i32, i64, %struct.timespec, %struct.timespec, %struct.timespec, i64 }
%struct.timespec = type { i32, i32 }

@__exe_env = unnamed_addr global %struct.exe_sym_env_t { [32 x %struct.exe_file_t] [%struct.exe_file_t { i32 0, i32 5, i64 0, %struct.exe_disk_file_t* null }, %struct.exe_file_t { i32 1, i32 9, i64 0, %struct.exe_disk_file_t* null }, %struct.exe_file_t { i32 2, i32 9, i64 0, %struct.exe_disk_file_t* null }, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer, %struct.exe_file_t zeroinitializer], i32 18, i32 0, i32 0 }, align 32
@.str = private unnamed_addr constant [6 x i8] c"-stat\00", align 1
@.str1 = private unnamed_addr constant [5 x i8] c"size\00", align 1
@.str2 = private unnamed_addr constant [10 x i8] c"fd_init.c\00", align 1
@__PRETTY_FUNCTION__.4081 = internal unnamed_addr constant [19 x i8] c"__create_new_dfile\00"
@.str4 = private unnamed_addr constant [2 x i8] c".\00", align 1
@__exe_fs = common unnamed_addr global %struct.exe_file_system_t zeroinitializer, align 32
@.str5 = private unnamed_addr constant [6 x i8] c"stdin\00", align 1
@.str6 = private unnamed_addr constant [10 x i8] c"read_fail\00", align 1
@.str7 = private unnamed_addr constant [11 x i8] c"write_fail\00", align 1
@.str8 = private unnamed_addr constant [11 x i8] c"close_fail\00", align 1
@.str9 = private unnamed_addr constant [15 x i8] c"ftruncate_fail\00", align 1
@.str10 = private unnamed_addr constant [12 x i8] c"getcwd_fail\00", align 1
@.str11 = private unnamed_addr constant [7 x i8] c"stdout\00", align 1
@.str12 = private unnamed_addr constant [14 x i8] c"model_version\00", align 1

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @klee_make_symbolic(i8*, i32, i8*)

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

declare i32 @__xstat64(i32, i8*, %struct.stat64*) nounwind

define internal fastcc void @__create_new_dfile(%struct.exe_disk_file_t* nocapture %dfile, i32 %size, i8* %name, %struct.stat64* nocapture %defaults) nounwind {
entry:
  %sname = alloca [64 x i8], align 1
  call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %dfile}, i64 0, metadata !75), !dbg !138
  call void @llvm.dbg.value(metadata !{i32 %size}, i64 0, metadata !76), !dbg !138
  call void @llvm.dbg.value(metadata !{i8* %name}, i64 0, metadata !77), !dbg !139
  call void @llvm.dbg.value(metadata !{%struct.stat64* %defaults}, i64 0, metadata !78), !dbg !139
  call void @llvm.dbg.declare(metadata !{[64 x i8]* %sname}, metadata !82), !dbg !140
  %0 = call noalias i8* @malloc(i32 96) nounwind, !dbg !141
  %1 = bitcast i8* %0 to %struct.stat64*, !dbg !141
  call void @llvm.dbg.value(metadata !{%struct.stat64* %1}, i64 0, metadata !79), !dbg !141
  call void @llvm.dbg.value(metadata !{i8* %name}, i64 0, metadata !81), !dbg !142
  %2 = load i8* %name, align 1, !dbg !142
  %3 = icmp eq i8 %2, 0, !dbg !142
  %4 = getelementptr inbounds [64 x i8]* %sname, i32 0, i32 0, !dbg !143
  br i1 %3, label %bb2, label %bb, !dbg !142

bb:                                               ; preds = %entry, %bb
  %indvar = phi i32 [ %tmp, %bb ], [ 0, %entry ]
  %5 = phi i8* [ %9, %bb ], [ %4, %entry ]
  %6 = phi i8 [ %7, %bb ], [ %2, %entry ]
  %tmp = add i32 %indvar, 1
  %scevgep = getelementptr i8* %name, i32 %tmp
  store i8 %6, i8* %5, align 1, !dbg !144
  %7 = load i8* %scevgep, align 1, !dbg !142
  %8 = icmp eq i8 %7, 0, !dbg !142
  %9 = getelementptr inbounds [64 x i8]* %sname, i32 0, i32 %tmp, !dbg !143
  br i1 %8, label %bb2, label %bb, !dbg !142

bb2:                                              ; preds = %bb, %entry
  %.lcssa = phi i8* [ %4, %entry ], [ %9, %bb ]
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %.lcssa, i8* getelementptr inbounds ([6 x i8]* @.str, i32 0, i32 0), i32 6, i32 1, i1 false), !dbg !143
  %10 = icmp eq i32 %size, 0, !dbg !145
  br i1 %10, label %bb3, label %bb4, !dbg !145

bb3:                                              ; preds = %bb2
  call void @__assert_fail(i8* getelementptr inbounds ([5 x i8]* @.str1, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8]* @.str2, i32 0, i32 0), i32 55, i8* getelementptr inbounds ([19 x i8]* @__PRETTY_FUNCTION__.4081, i32 0, i32 0)) noreturn nounwind, !dbg !145
  unreachable, !dbg !145

bb4:                                              ; preds = %bb2
  %11 = getelementptr inbounds %struct.exe_disk_file_t* %dfile, i32 0, i32 0, !dbg !146
  store i32 %size, i32* %11, align 4, !dbg !146
  %12 = call noalias i8* @malloc(i32 %size) nounwind, !dbg !147
  %13 = getelementptr inbounds %struct.exe_disk_file_t* %dfile, i32 0, i32 1, !dbg !147
  store i8* %12, i8** %13, align 4, !dbg !147
  call void @klee_make_symbolic(i8* %12, i32 %size, i8* %name) nounwind, !dbg !148
  call void @klee_make_symbolic(i8* %0, i32 96, i8* %4) nounwind, !dbg !149
  %14 = getelementptr inbounds i8* %0, i32 88
  %15 = bitcast i8* %14 to i64*, !dbg !150
  %16 = load i64* %15, align 4, !dbg !150
  %17 = trunc i64 %16 to i32, !dbg !150
  %18 = call i32 @klee_is_symbolic(i32 %17) nounwind, !dbg !150
  %19 = icmp eq i32 %18, 0, !dbg !150
  %20 = load i64* %15, align 4, !dbg !150
  br i1 %19, label %bb6, label %bb8, !dbg !150

bb6:                                              ; preds = %bb4
  %21 = and i64 %20, 2147483647, !dbg !150
  %22 = icmp eq i64 %21, 0, !dbg !150
  br i1 %22, label %bb7, label %bb8, !dbg !150

bb7:                                              ; preds = %bb6
  %23 = getelementptr inbounds %struct.stat64* %defaults, i32 0, i32 15, !dbg !151
  %24 = load i64* %23, align 4, !dbg !151
  store i64 %24, i64* %15, align 4, !dbg !151
  br label %bb8, !dbg !151

bb8:                                              ; preds = %bb4, %bb7, %bb6
  %25 = phi i64 [ %24, %bb7 ], [ %20, %bb6 ], [ %20, %bb4 ]
  %26 = and i64 %25, 2147483647, !dbg !152
  %27 = icmp ne i64 %26, 0, !dbg !152
  %28 = zext i1 %27 to i32, !dbg !152
  call void @klee_assume(i32 %28) nounwind, !dbg !152
  %29 = getelementptr inbounds i8* %0, i32 52
  %30 = bitcast i8* %29 to i32*, !dbg !153
  %31 = load i32* %30, align 4, !dbg !153
  %32 = icmp ult i32 %31, 65536, !dbg !153
  %33 = zext i1 %32 to i32, !dbg !153
  call void @klee_assume(i32 %33) nounwind, !dbg !153
  %34 = getelementptr inbounds i8* %0, i32 16
  %35 = bitcast i8* %34 to i32*, !dbg !154
  %36 = load i32* %35, align 4, !dbg !154
  %37 = and i32 %36, -61952, !dbg !154
  %38 = icmp eq i32 %37, 0, !dbg !154
  %39 = zext i1 %38 to i32, !dbg !154
  call void @klee_prefer_cex(i8* %0, i32 %39) nounwind, !dbg !154
  %40 = bitcast i8* %0 to i64*, !dbg !155
  %41 = load i64* %40, align 4, !dbg !155
  %42 = getelementptr inbounds %struct.stat64* %defaults, i32 0, i32 0, !dbg !155
  %43 = load i64* %42, align 4, !dbg !155
  %44 = icmp eq i64 %41, %43, !dbg !155
  %45 = zext i1 %44 to i32, !dbg !155
  call void @klee_prefer_cex(i8* %0, i32 %45) nounwind, !dbg !155
  %46 = getelementptr inbounds i8* %0, i32 32
  %47 = bitcast i8* %46 to i64*, !dbg !156
  %48 = load i64* %47, align 4, !dbg !156
  %49 = getelementptr inbounds %struct.stat64* %defaults, i32 0, i32 7, !dbg !156
  %50 = load i64* %49, align 4, !dbg !156
  %51 = icmp eq i64 %48, %50, !dbg !156
  %52 = zext i1 %51 to i32, !dbg !156
  call void @klee_prefer_cex(i8* %0, i32 %52) nounwind, !dbg !156
  %53 = load i32* %35, align 4, !dbg !157
  %54 = and i32 %53, 448, !dbg !157
  %55 = icmp eq i32 %54, 384, !dbg !157
  %56 = zext i1 %55 to i32, !dbg !157
  call void @klee_prefer_cex(i8* %0, i32 %56) nounwind, !dbg !157
  %57 = load i32* %35, align 4, !dbg !158
  %58 = and i32 %57, 56, !dbg !158
  %59 = icmp eq i32 %58, 16, !dbg !158
  %60 = zext i1 %59 to i32, !dbg !158
  call void @klee_prefer_cex(i8* %0, i32 %60) nounwind, !dbg !158
  %61 = load i32* %35, align 4, !dbg !159
  %62 = and i32 %61, 7, !dbg !159
  %63 = icmp eq i32 %62, 2, !dbg !159
  %64 = zext i1 %63 to i32, !dbg !159
  call void @klee_prefer_cex(i8* %0, i32 %64) nounwind, !dbg !159
  %65 = load i32* %35, align 4, !dbg !160
  %66 = and i32 %65, 61440, !dbg !160
  %67 = icmp eq i32 %66, 32768, !dbg !160
  %68 = zext i1 %67 to i32, !dbg !160
  call void @klee_prefer_cex(i8* %0, i32 %68) nounwind, !dbg !160
  %69 = getelementptr inbounds i8* %0, i32 20
  %70 = bitcast i8* %69 to i32*, !dbg !161
  %71 = load i32* %70, align 4, !dbg !161
  %72 = icmp eq i32 %71, 1, !dbg !161
  %73 = zext i1 %72 to i32, !dbg !161
  call void @klee_prefer_cex(i8* %0, i32 %73) nounwind, !dbg !161
  %74 = getelementptr inbounds i8* %0, i32 24
  %75 = bitcast i8* %74 to i32*, !dbg !162
  %76 = load i32* %75, align 4, !dbg !162
  %77 = getelementptr inbounds %struct.stat64* %defaults, i32 0, i32 5, !dbg !162
  %78 = load i32* %77, align 4, !dbg !162
  %79 = icmp eq i32 %76, %78, !dbg !162
  %80 = zext i1 %79 to i32, !dbg !162
  call void @klee_prefer_cex(i8* %0, i32 %80) nounwind, !dbg !162
  %81 = getelementptr inbounds i8* %0, i32 28
  %82 = bitcast i8* %81 to i32*, !dbg !163
  %83 = load i32* %82, align 4, !dbg !163
  %84 = getelementptr inbounds %struct.stat64* %defaults, i32 0, i32 6, !dbg !163
  %85 = load i32* %84, align 4, !dbg !163
  %86 = icmp eq i32 %83, %85, !dbg !163
  %87 = zext i1 %86 to i32, !dbg !163
  call void @klee_prefer_cex(i8* %0, i32 %87) nounwind, !dbg !163
  %88 = load i32* %30, align 4, !dbg !164
  %89 = icmp eq i32 %88, 4096, !dbg !164
  %90 = zext i1 %89 to i32, !dbg !164
  call void @klee_prefer_cex(i8* %0, i32 %90) nounwind, !dbg !164
  %91 = getelementptr inbounds i8* %0, i32 64
  %92 = bitcast i8* %91 to i32*, !dbg !165
  %93 = load i32* %92, align 4, !dbg !165
  %94 = getelementptr inbounds %struct.stat64* %defaults, i32 0, i32 12, i32 0, !dbg !165
  %95 = load i32* %94, align 4, !dbg !165
  %96 = icmp eq i32 %93, %95, !dbg !165
  %97 = zext i1 %96 to i32, !dbg !165
  call void @klee_prefer_cex(i8* %0, i32 %97) nounwind, !dbg !165
  %98 = getelementptr inbounds i8* %0, i32 72
  %99 = bitcast i8* %98 to i32*, !dbg !166
  %100 = load i32* %99, align 4, !dbg !166
  %101 = getelementptr inbounds %struct.stat64* %defaults, i32 0, i32 13, i32 0, !dbg !166
  %102 = load i32* %101, align 4, !dbg !166
  %103 = icmp eq i32 %100, %102, !dbg !166
  %104 = zext i1 %103 to i32, !dbg !166
  call void @klee_prefer_cex(i8* %0, i32 %104) nounwind, !dbg !166
  %105 = getelementptr inbounds i8* %0, i32 80
  %106 = bitcast i8* %105 to i32*, !dbg !167
  %107 = load i32* %106, align 4, !dbg !167
  %108 = getelementptr inbounds %struct.stat64* %defaults, i32 0, i32 14, i32 0, !dbg !167
  %109 = load i32* %108, align 4, !dbg !167
  %110 = icmp eq i32 %107, %109, !dbg !167
  %111 = zext i1 %110 to i32, !dbg !167
  call void @klee_prefer_cex(i8* %0, i32 %111) nounwind, !dbg !167
  %112 = load i32* %11, align 4, !dbg !168
  %113 = zext i32 %112 to i64, !dbg !168
  %114 = getelementptr inbounds i8* %0, i32 44
  %115 = bitcast i8* %114 to i64*, !dbg !168
  store i64 %113, i64* %115, align 4, !dbg !168
  %116 = getelementptr inbounds i8* %0, i32 56
  %117 = bitcast i8* %116 to i64*, !dbg !169
  store i64 8, i64* %117, align 4, !dbg !169
  %118 = getelementptr inbounds %struct.exe_disk_file_t* %dfile, i32 0, i32 2, !dbg !170
  store %struct.stat64* %1, %struct.stat64** %118, align 4, !dbg !170
  ret void, !dbg !171
}

declare noalias i8* @malloc(i32) nounwind

declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture, i32, i32, i1) nounwind

declare void @__assert_fail(i8*, i8*, i32, i8*) noreturn nounwind

declare i32 @klee_is_symbolic(i32)

declare void @klee_assume(i32)

declare void @klee_prefer_cex(i8*, i32)

define void @klee_init_fds(i32 %n_files, i32 %file_length, i32 %sym_stdout_flag, i32 %save_all_writes_flag, i32 %max_failures) nounwind {
entry:
  %x.i = alloca i32, align 4
  %name = alloca [7 x i8], align 1
  %s = alloca %struct.stat64, align 8
  call void @llvm.dbg.value(metadata !{i32 %n_files}, i64 0, metadata !86), !dbg !172
  call void @llvm.dbg.value(metadata !{i32 %file_length}, i64 0, metadata !87), !dbg !172
  call void @llvm.dbg.value(metadata !{i32 %sym_stdout_flag}, i64 0, metadata !88), !dbg !173
  call void @llvm.dbg.value(metadata !{i32 %save_all_writes_flag}, i64 0, metadata !89), !dbg !173
  call void @llvm.dbg.value(metadata !{i32 %max_failures}, i64 0, metadata !90), !dbg !174
  call void @llvm.dbg.declare(metadata !{[7 x i8]* %name}, metadata !93), !dbg !175
  call void @llvm.dbg.declare(metadata !{%struct.stat64* %s}, metadata !97), !dbg !176
  %0 = getelementptr inbounds [7 x i8]* %name, i32 0, i32 0, !dbg !175
  store i8 63, i8* %0, align 1, !dbg !175
  %1 = getelementptr inbounds [7 x i8]* %name, i32 0, i32 1, !dbg !175
  store i8 45, i8* %1, align 1, !dbg !175
  %2 = getelementptr inbounds [7 x i8]* %name, i32 0, i32 2, !dbg !175
  store i8 100, i8* %2, align 1, !dbg !175
  %3 = getelementptr inbounds [7 x i8]* %name, i32 0, i32 3, !dbg !175
  store i8 97, i8* %3, align 1, !dbg !175
  %4 = getelementptr inbounds [7 x i8]* %name, i32 0, i32 4, !dbg !175
  store i8 116, i8* %4, align 1, !dbg !175
  %5 = getelementptr inbounds [7 x i8]* %name, i32 0, i32 5, !dbg !175
  store i8 97, i8* %5, align 1, !dbg !175
  %6 = getelementptr inbounds [7 x i8]* %name, i32 0, i32 6, !dbg !175
  store i8 0, i8* %6, align 1, !dbg !175
  call void @llvm.dbg.value(metadata !177, i64 0, metadata !73) nounwind, !dbg !178
  call void @llvm.dbg.value(metadata !{%struct.stat64* %s}, i64 0, metadata !74) nounwind, !dbg !178
  %7 = call i32 @__xstat64(i32 3, i8* getelementptr inbounds ([2 x i8]* @.str4, i32 0, i32 0), %struct.stat64* %s) nounwind, !dbg !180
  store i32 %n_files, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 0), align 32, !dbg !182
  %8 = mul i32 %n_files, 12, !dbg !183
  %9 = call noalias i8* @malloc(i32 %8) nounwind, !dbg !183
  %10 = bitcast i8* %9 to %struct.exe_disk_file_t*, !dbg !183
  store %struct.exe_disk_file_t* %10, %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 4), align 16, !dbg !183
  call void @llvm.dbg.value(metadata !184, i64 0, metadata !91), !dbg !185
  %11 = icmp eq i32 %n_files, 0, !dbg !185
  br i1 %11, label %bb3, label %bb, !dbg !185

bb:                                               ; preds = %entry, %bb.bb_crit_edge
  %12 = phi %struct.exe_disk_file_t* [ %.pre, %bb.bb_crit_edge ], [ %10, %entry ]
  %k.012 = phi i32 [ %13, %bb.bb_crit_edge ], [ 0, %entry ]
  %tmp = add i32 %k.012, 65
  %tmp13 = trunc i32 %tmp to i8
  store i8 %tmp13, i8* %0, align 1, !dbg !186
  %scevgep = getelementptr %struct.exe_disk_file_t* %12, i32 %k.012
  call fastcc void @__create_new_dfile(%struct.exe_disk_file_t* %scevgep, i32 %file_length, i8* %0, %struct.stat64* %s) nounwind, !dbg !187
  %13 = add i32 %k.012, 1, !dbg !185
  %exitcond = icmp eq i32 %13, %n_files
  br i1 %exitcond, label %bb3, label %bb.bb_crit_edge, !dbg !185

bb.bb_crit_edge:                                  ; preds = %bb
  %.pre = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 4), align 16
  br label %bb

bb3:                                              ; preds = %bb, %entry
  %14 = icmp eq i32 %file_length, 0, !dbg !188
  br i1 %14, label %bb5, label %bb4, !dbg !188

bb4:                                              ; preds = %bb3
  %15 = call noalias i8* @malloc(i32 12) nounwind, !dbg !189
  %16 = bitcast i8* %15 to %struct.exe_disk_file_t*, !dbg !189
  store %struct.exe_disk_file_t* %16, %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 1), align 4, !dbg !189
  call fastcc void @__create_new_dfile(%struct.exe_disk_file_t* %16, i32 %file_length, i8* getelementptr inbounds ([6 x i8]* @.str5, i32 0, i32 0), %struct.stat64* %s) nounwind, !dbg !190
  %17 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 1), align 4, !dbg !191
  store %struct.exe_disk_file_t* %17, %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 0, i32 3), align 16, !dbg !191
  br label %bb6, !dbg !191

bb5:                                              ; preds = %bb3
  store %struct.exe_disk_file_t* null, %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 1), align 4, !dbg !192
  br label %bb6, !dbg !192

bb6:                                              ; preds = %bb5, %bb4
  store i32 %max_failures, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 5), align 4, !dbg !193
  %18 = icmp eq i32 %max_failures, 0, !dbg !194
  br i1 %18, label %bb8, label %bb7, !dbg !194

bb7:                                              ; preds = %bb6
  %19 = call noalias i8* @malloc(i32 4) nounwind, !dbg !195
  %20 = bitcast i8* %19 to i32*, !dbg !195
  store i32* %20, i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 6), align 8, !dbg !195
  %21 = call noalias i8* @malloc(i32 4) nounwind, !dbg !196
  %22 = bitcast i8* %21 to i32*, !dbg !196
  store i32* %22, i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 7), align 4, !dbg !196
  %23 = call noalias i8* @malloc(i32 4) nounwind, !dbg !197
  %24 = bitcast i8* %23 to i32*, !dbg !197
  store i32* %24, i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 8), align 32, !dbg !197
  %25 = call noalias i8* @malloc(i32 4) nounwind, !dbg !198
  %26 = bitcast i8* %25 to i32*, !dbg !198
  store i32* %26, i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 9), align 4, !dbg !198
  %27 = call noalias i8* @malloc(i32 4) nounwind, !dbg !199
  %28 = bitcast i8* %27 to i32*, !dbg !199
  store i32* %28, i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 10), align 8, !dbg !199
  call void @klee_make_symbolic(i8* %19, i32 4, i8* getelementptr inbounds ([10 x i8]* @.str6, i32 0, i32 0)) nounwind, !dbg !200
  %29 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 7), align 4, !dbg !201
  %30 = bitcast i32* %29 to i8*, !dbg !201
  call void @klee_make_symbolic(i8* %30, i32 4, i8* getelementptr inbounds ([11 x i8]* @.str7, i32 0, i32 0)) nounwind, !dbg !201
  %31 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 8), align 32, !dbg !202
  %32 = bitcast i32* %31 to i8*, !dbg !202
  call void @klee_make_symbolic(i8* %32, i32 4, i8* getelementptr inbounds ([11 x i8]* @.str8, i32 0, i32 0)) nounwind, !dbg !202
  %33 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 9), align 4, !dbg !203
  %34 = bitcast i32* %33 to i8*, !dbg !203
  call void @klee_make_symbolic(i8* %34, i32 4, i8* getelementptr inbounds ([15 x i8]* @.str9, i32 0, i32 0)) nounwind, !dbg !203
  %35 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 10), align 8, !dbg !204
  %36 = bitcast i32* %35 to i8*, !dbg !204
  call void @klee_make_symbolic(i8* %36, i32 4, i8* getelementptr inbounds ([12 x i8]* @.str10, i32 0, i32 0)) nounwind, !dbg !204
  br label %bb8, !dbg !204

bb8:                                              ; preds = %bb6, %bb7
  %37 = icmp eq i32 %sym_stdout_flag, 0, !dbg !205
  br i1 %37, label %bb10, label %bb9, !dbg !205

bb9:                                              ; preds = %bb8
  %38 = call noalias i8* @malloc(i32 12) nounwind, !dbg !206
  %39 = bitcast i8* %38 to %struct.exe_disk_file_t*, !dbg !206
  store %struct.exe_disk_file_t* %39, %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 2), align 8, !dbg !206
  call fastcc void @__create_new_dfile(%struct.exe_disk_file_t* %39, i32 1024, i8* getelementptr inbounds ([7 x i8]* @.str11, i32 0, i32 0), %struct.stat64* %s) nounwind, !dbg !207
  %40 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 2), align 8, !dbg !208
  store %struct.exe_disk_file_t* %40, %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 1, i32 3), align 4, !dbg !208
  store i32 0, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 3), align 4, !dbg !209
  br label %bb11, !dbg !209

bb10:                                             ; preds = %bb8
  store %struct.exe_disk_file_t* null, %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 2), align 8, !dbg !210
  br label %bb11, !dbg !210

bb11:                                             ; preds = %bb10, %bb9
  store i32 %save_all_writes_flag, i32* getelementptr inbounds (%struct.exe_sym_env_t* @__exe_env, i32 0, i32 3), align 8, !dbg !211
  call void @llvm.dbg.value(metadata !212, i64 0, metadata !70) nounwind, !dbg !213
  call void @llvm.dbg.declare(metadata !{i32* %x.i}, metadata !71) nounwind, !dbg !215
  %x1.i = bitcast i32* %x.i to i8*, !dbg !216
  call void @klee_make_symbolic(i8* %x1.i, i32 4, i8* getelementptr inbounds ([14 x i8]* @.str12, i32 0, i32 0)) nounwind, !dbg !216
  %41 = load i32* %x.i, align 4, !dbg !217
  store i32 %41, i32* getelementptr inbounds (%struct.exe_sym_env_t* @__exe_env, i32 0, i32 2), align 4, !dbg !214
  %42 = icmp eq i32 %41, 1, !dbg !218
  %43 = zext i1 %42 to i32, !dbg !218
  call void @klee_assume(i32 %43) nounwind, !dbg !218
  ret void, !dbg !219
}

!llvm.dbg.sp = !{!0, !9, !56, !67}
!llvm.dbg.lv.__sym_uint32 = !{!70, !71}
!llvm.dbg.lv.stat64 = !{!73, !74}
!llvm.dbg.lv.__create_new_dfile = !{!75, !76, !77, !78, !79, !81, !82}
!llvm.dbg.lv.klee_init_fds = !{!86, !87, !88, !89, !90, !91, !93, !97}
!llvm.dbg.gv = !{!98, !120}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__sym_uint32", metadata !"__sym_uint32", metadata !"", metadata !1, i32 97, metadata !3, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"fd_init.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/POSIX/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"fd_init.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/POSIX/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !6}
!5 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !7} ; [ DW_TAG_pointer_type ]
!7 = metadata !{i32 589862, metadata !1, metadata !"", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !8} ; [ DW_TAG_const_type ]
!8 = metadata !{i32 589860, metadata !1, metadata !"char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!9 = metadata !{i32 589870, i32 0, metadata !1, metadata !"stat64", metadata !"stat64", metadata !"stat64", metadata !10, i32 505, metadata !11, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!10 = metadata !{i32 589865, metadata !"stat.h", metadata !"/usr/include/i386-linux-gnu/sys", metadata !2} ; [ DW_TAG_file_type ]
!11 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !12, i32 0, null} ; [ DW_TAG_subroutine_type ]
!12 = metadata !{metadata !13, metadata !6, metadata !14}
!13 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!14 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !15} ; [ DW_TAG_pointer_type ]
!15 = metadata !{i32 589843, metadata !1, metadata !"stat64", metadata !16, i32 23, i64 768, i64 32, i64 0, i32 0, null, metadata !17, i32 0, null} ; [ DW_TAG_structure_type ]
!16 = metadata !{i32 589865, metadata !"fd.h", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/POSIX/", metadata !2} ; [ DW_TAG_file_type ]
!17 = metadata !{metadata !18, metadata !23, metadata !24, metadata !27, metadata !29, metadata !31, metadata !33, metadata !35, metadata !36, metadata !37, metadata !40, metadata !43, metadata !45, metadata !52, metadata !53, metadata !54}
!18 = metadata !{i32 589837, metadata !15, metadata !"st_dev", metadata !19, i32 98, i64 64, i64 64, i64 0, i32 0, metadata !20} ; [ DW_TAG_member ]
!19 = metadata !{i32 589865, metadata !"stat.h", metadata !"/usr/include/i386-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!20 = metadata !{i32 589846, metadata !21, metadata !"__dev_t", metadata !21, i32 135, i64 0, i64 0, i64 0, i32 0, metadata !22} ; [ DW_TAG_typedef ]
!21 = metadata !{i32 589865, metadata !"types.h", metadata !"/usr/include/i386-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!22 = metadata !{i32 589860, metadata !1, metadata !"long long unsigned int", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!23 = metadata !{i32 589837, metadata !15, metadata !"__pad1", metadata !19, i32 99, i64 32, i64 32, i64 64, i32 0, metadata !5} ; [ DW_TAG_member ]
!24 = metadata !{i32 589837, metadata !15, metadata !"__st_ino", metadata !19, i32 101, i64 32, i64 32, i64 96, i32 0, metadata !25} ; [ DW_TAG_member ]
!25 = metadata !{i32 589846, metadata !21, metadata !"__ino_t", metadata !21, i32 138, i64 0, i64 0, i64 0, i32 0, metadata !26} ; [ DW_TAG_typedef ]
!26 = metadata !{i32 589860, metadata !1, metadata !"long unsigned int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!27 = metadata !{i32 589837, metadata !15, metadata !"st_mode", metadata !19, i32 102, i64 32, i64 32, i64 128, i32 0, metadata !28} ; [ DW_TAG_member ]
!28 = metadata !{i32 589846, metadata !21, metadata !"__mode_t", metadata !21, i32 140, i64 0, i64 0, i64 0, i32 0, metadata !5} ; [ DW_TAG_typedef ]
!29 = metadata !{i32 589837, metadata !15, metadata !"st_nlink", metadata !19, i32 103, i64 32, i64 32, i64 160, i32 0, metadata !30} ; [ DW_TAG_member ]
!30 = metadata !{i32 589846, metadata !21, metadata !"__nlink_t", metadata !21, i32 141, i64 0, i64 0, i64 0, i32 0, metadata !5} ; [ DW_TAG_typedef ]
!31 = metadata !{i32 589837, metadata !15, metadata !"st_uid", metadata !19, i32 104, i64 32, i64 32, i64 192, i32 0, metadata !32} ; [ DW_TAG_member ]
!32 = metadata !{i32 589846, metadata !21, metadata !"__uid_t", metadata !21, i32 136, i64 0, i64 0, i64 0, i32 0, metadata !5} ; [ DW_TAG_typedef ]
!33 = metadata !{i32 589837, metadata !15, metadata !"st_gid", metadata !19, i32 105, i64 32, i64 32, i64 224, i32 0, metadata !34} ; [ DW_TAG_member ]
!34 = metadata !{i32 589846, metadata !21, metadata !"__gid_t", metadata !21, i32 137, i64 0, i64 0, i64 0, i32 0, metadata !5} ; [ DW_TAG_typedef ]
!35 = metadata !{i32 589837, metadata !15, metadata !"st_rdev", metadata !19, i32 106, i64 64, i64 64, i64 256, i32 0, metadata !20} ; [ DW_TAG_member ]
!36 = metadata !{i32 589837, metadata !15, metadata !"__pad2", metadata !19, i32 107, i64 32, i64 32, i64 320, i32 0, metadata !5} ; [ DW_TAG_member ]
!37 = metadata !{i32 589837, metadata !15, metadata !"st_size", metadata !19, i32 108, i64 64, i64 64, i64 352, i32 0, metadata !38} ; [ DW_TAG_member ]
!38 = metadata !{i32 589846, metadata !21, metadata !"__off64_t", metadata !21, i32 143, i64 0, i64 0, i64 0, i32 0, metadata !39} ; [ DW_TAG_typedef ]
!39 = metadata !{i32 589860, metadata !1, metadata !"long long int", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!40 = metadata !{i32 589837, metadata !15, metadata !"st_blksize", metadata !19, i32 109, i64 32, i64 32, i64 416, i32 0, metadata !41} ; [ DW_TAG_member ]
!41 = metadata !{i32 589846, metadata !21, metadata !"__blksize_t", metadata !21, i32 169, i64 0, i64 0, i64 0, i32 0, metadata !42} ; [ DW_TAG_typedef ]
!42 = metadata !{i32 589860, metadata !1, metadata !"long int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!43 = metadata !{i32 589837, metadata !15, metadata !"st_blocks", metadata !19, i32 111, i64 64, i64 64, i64 448, i32 0, metadata !44} ; [ DW_TAG_member ]
!44 = metadata !{i32 589846, metadata !21, metadata !"__blkcnt64_t", metadata !21, i32 173, i64 0, i64 0, i64 0, i32 0, metadata !39} ; [ DW_TAG_typedef ]
!45 = metadata !{i32 589837, metadata !15, metadata !"st_atim", metadata !19, i32 119, i64 64, i64 32, i64 512, i32 0, metadata !46} ; [ DW_TAG_member ]
!46 = metadata !{i32 589843, metadata !1, metadata !"timespec", metadata !47, i32 121, i64 64, i64 32, i64 0, i32 0, null, metadata !48, i32 0, null} ; [ DW_TAG_structure_type ]
!47 = metadata !{i32 589865, metadata !"time.h", metadata !"/usr/include", metadata !2} ; [ DW_TAG_file_type ]
!48 = metadata !{metadata !49, metadata !51}
!49 = metadata !{i32 589837, metadata !46, metadata !"tv_sec", metadata !47, i32 122, i64 32, i64 32, i64 0, i32 0, metadata !50} ; [ DW_TAG_member ]
!50 = metadata !{i32 589846, metadata !21, metadata !"__time_t", metadata !21, i32 150, i64 0, i64 0, i64 0, i32 0, metadata !42} ; [ DW_TAG_typedef ]
!51 = metadata !{i32 589837, metadata !46, metadata !"tv_nsec", metadata !47, i32 123, i64 32, i64 32, i64 32, i32 0, metadata !42} ; [ DW_TAG_member ]
!52 = metadata !{i32 589837, metadata !15, metadata !"st_mtim", metadata !19, i32 120, i64 64, i64 32, i64 576, i32 0, metadata !46} ; [ DW_TAG_member ]
!53 = metadata !{i32 589837, metadata !15, metadata !"st_ctim", metadata !19, i32 121, i64 64, i64 32, i64 640, i32 0, metadata !46} ; [ DW_TAG_member ]
!54 = metadata !{i32 589837, metadata !15, metadata !"st_ino", metadata !19, i32 130, i64 64, i64 64, i64 704, i32 0, metadata !55} ; [ DW_TAG_member ]
!55 = metadata !{i32 589846, metadata !21, metadata !"__ino64_t", metadata !21, i32 139, i64 0, i64 0, i64 0, i32 0, metadata !22} ; [ DW_TAG_typedef ]
!56 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__create_new_dfile", metadata !"__create_new_dfile", metadata !"", metadata !1, i32 47, metadata !57, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (%struct.exe_disk_file_t*, i32, i8*, %struct.stat64*)* @__create_new_dfile} ; [ DW_TAG_subprogram ]
!57 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !58, i32 0, null} ; [ DW_TAG_subroutine_type ]
!58 = metadata !{null, metadata !59, metadata !5, metadata !6, metadata !14}
!59 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !60} ; [ DW_TAG_pointer_type ]
!60 = metadata !{i32 589846, metadata !16, metadata !"exe_disk_file_t", metadata !16, i32 26, i64 0, i64 0, i64 0, i32 0, metadata !61} ; [ DW_TAG_typedef ]
!61 = metadata !{i32 589843, metadata !1, metadata !"", metadata !16, i32 20, i64 96, i64 32, i64 0, i32 0, null, metadata !62, i32 0, null} ; [ DW_TAG_structure_type ]
!62 = metadata !{metadata !63, metadata !64, metadata !66}
!63 = metadata !{i32 589837, metadata !61, metadata !"size", metadata !16, i32 21, i64 32, i64 32, i64 0, i32 0, metadata !5} ; [ DW_TAG_member ]
!64 = metadata !{i32 589837, metadata !61, metadata !"contents", metadata !16, i32 22, i64 32, i64 32, i64 32, i32 0, metadata !65} ; [ DW_TAG_member ]
!65 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !8} ; [ DW_TAG_pointer_type ]
!66 = metadata !{i32 589837, metadata !61, metadata !"stat", metadata !16, i32 23, i64 32, i64 32, i64 64, i32 0, metadata !14} ; [ DW_TAG_member ]
!67 = metadata !{i32 589870, i32 0, metadata !1, metadata !"klee_init_fds", metadata !"klee_init_fds", metadata !"klee_init_fds", metadata !1, i32 112, metadata !68, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i32, i32, i32, i32, i32)* @klee_init_fds} ; [ DW_TAG_subprogram ]
!68 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !69, i32 0, null} ; [ DW_TAG_subroutine_type ]
!69 = metadata !{null, metadata !5, metadata !5, metadata !13, metadata !13, metadata !5}
!70 = metadata !{i32 590081, metadata !0, metadata !"name", metadata !1, i32 97, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!71 = metadata !{i32 590080, metadata !72, metadata !"x", metadata !1, i32 98, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!72 = metadata !{i32 589835, metadata !0, i32 97, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!73 = metadata !{i32 590081, metadata !9, metadata !"__path", metadata !10, i32 504, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!74 = metadata !{i32 590081, metadata !9, metadata !"__statbuf", metadata !10, i32 504, metadata !14, i32 0} ; [ DW_TAG_arg_variable ]
!75 = metadata !{i32 590081, metadata !56, metadata !"dfile", metadata !1, i32 46, metadata !59, i32 0} ; [ DW_TAG_arg_variable ]
!76 = metadata !{i32 590081, metadata !56, metadata !"size", metadata !1, i32 46, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!77 = metadata !{i32 590081, metadata !56, metadata !"name", metadata !1, i32 47, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!78 = metadata !{i32 590081, metadata !56, metadata !"defaults", metadata !1, i32 47, metadata !14, i32 0} ; [ DW_TAG_arg_variable ]
!79 = metadata !{i32 590080, metadata !80, metadata !"s", metadata !1, i32 48, metadata !14, i32 0} ; [ DW_TAG_auto_variable ]
!80 = metadata !{i32 589835, metadata !56, i32 47, i32 0, metadata !1, i32 2} ; [ DW_TAG_lexical_block ]
!81 = metadata !{i32 590080, metadata !80, metadata !"sp", metadata !1, i32 49, metadata !6, i32 0} ; [ DW_TAG_auto_variable ]
!82 = metadata !{i32 590080, metadata !80, metadata !"sname", metadata !1, i32 50, metadata !83, i32 0} ; [ DW_TAG_auto_variable ]
!83 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 512, i64 8, i64 0, i32 0, metadata !8, metadata !84, i32 0, null} ; [ DW_TAG_array_type ]
!84 = metadata !{metadata !85}
!85 = metadata !{i32 589857, i64 0, i64 63}       ; [ DW_TAG_subrange_type ]
!86 = metadata !{i32 590081, metadata !67, metadata !"n_files", metadata !1, i32 110, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!87 = metadata !{i32 590081, metadata !67, metadata !"file_length", metadata !1, i32 110, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!88 = metadata !{i32 590081, metadata !67, metadata !"sym_stdout_flag", metadata !1, i32 111, metadata !13, i32 0} ; [ DW_TAG_arg_variable ]
!89 = metadata !{i32 590081, metadata !67, metadata !"save_all_writes_flag", metadata !1, i32 111, metadata !13, i32 0} ; [ DW_TAG_arg_variable ]
!90 = metadata !{i32 590081, metadata !67, metadata !"max_failures", metadata !1, i32 112, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!91 = metadata !{i32 590080, metadata !92, metadata !"k", metadata !1, i32 113, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!92 = metadata !{i32 589835, metadata !67, i32 112, i32 0, metadata !1, i32 3} ; [ DW_TAG_lexical_block ]
!93 = metadata !{i32 590080, metadata !92, metadata !"name", metadata !1, i32 114, metadata !94, i32 0} ; [ DW_TAG_auto_variable ]
!94 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 56, i64 8, i64 0, i32 0, metadata !8, metadata !95, i32 0, null} ; [ DW_TAG_array_type ]
!95 = metadata !{metadata !96}
!96 = metadata !{i32 589857, i64 0, i64 6}        ; [ DW_TAG_subrange_type ]
!97 = metadata !{i32 590080, metadata !92, metadata !"s", metadata !1, i32 115, metadata !15, i32 0} ; [ DW_TAG_auto_variable ]
!98 = metadata !{i32 589876, i32 0, metadata !1, metadata !"__exe_env", metadata !"__exe_env", metadata !"", metadata !1, i32 37, metadata !99, i1 false, i1 true, %struct.exe_sym_env_t* @__exe_env} ; [ DW_TAG_variable ]
!99 = metadata !{i32 589846, metadata !100, metadata !"exe_sym_env_t", metadata !100, i32 49, i64 0, i64 0, i64 0, i32 0, metadata !101} ; [ DW_TAG_typedef ]
!100 = metadata !{i32 589865, metadata !"stdint.h", metadata !"/usr/include", metadata !2} ; [ DW_TAG_file_type ]
!101 = metadata !{i32 589843, metadata !1, metadata !"", metadata !16, i32 61, i64 5216, i64 32, i64 0, i32 0, null, metadata !102, i32 0, null} ; [ DW_TAG_structure_type ]
!102 = metadata !{metadata !103, metadata !116, metadata !118, metadata !119}
!103 = metadata !{i32 589837, metadata !101, metadata !"fds", metadata !16, i32 62, i64 5120, i64 32, i64 0, i32 0, metadata !104} ; [ DW_TAG_member ]
!104 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 5120, i64 32, i64 0, i32 0, metadata !105, metadata !114, i32 0, null} ; [ DW_TAG_array_type ]
!105 = metadata !{i32 589846, metadata !16, metadata !"exe_file_t", metadata !16, i32 42, i64 0, i64 0, i64 0, i32 0, metadata !106} ; [ DW_TAG_typedef ]
!106 = metadata !{i32 589843, metadata !1, metadata !"", metadata !16, i32 33, i64 160, i64 32, i64 0, i32 0, null, metadata !107, i32 0, null} ; [ DW_TAG_structure_type ]
!107 = metadata !{metadata !108, metadata !109, metadata !110, metadata !113}
!108 = metadata !{i32 589837, metadata !106, metadata !"fd", metadata !16, i32 34, i64 32, i64 32, i64 0, i32 0, metadata !13} ; [ DW_TAG_member ]
!109 = metadata !{i32 589837, metadata !106, metadata !"flags", metadata !16, i32 35, i64 32, i64 32, i64 32, i32 0, metadata !5} ; [ DW_TAG_member ]
!110 = metadata !{i32 589837, metadata !106, metadata !"off", metadata !16, i32 38, i64 64, i64 64, i64 64, i32 0, metadata !111} ; [ DW_TAG_member ]
!111 = metadata !{i32 589846, metadata !112, metadata !"off64_t", metadata !112, i32 99, i64 0, i64 0, i64 0, i32 0, metadata !39} ; [ DW_TAG_typedef ]
!112 = metadata !{i32 589865, metadata !"types.h", metadata !"/usr/include/i386-linux-gnu/sys", metadata !2} ; [ DW_TAG_file_type ]
!113 = metadata !{i32 589837, metadata !106, metadata !"dfile", metadata !16, i32 39, i64 32, i64 32, i64 128, i32 0, metadata !59} ; [ DW_TAG_member ]
!114 = metadata !{metadata !115}
!115 = metadata !{i32 589857, i64 0, i64 31}      ; [ DW_TAG_subrange_type ]
!116 = metadata !{i32 589837, metadata !101, metadata !"umask", metadata !16, i32 63, i64 32, i64 32, i64 5120, i32 0, metadata !117} ; [ DW_TAG_member ]
!117 = metadata !{i32 589846, metadata !112, metadata !"mode_t", metadata !112, i32 76, i64 0, i64 0, i64 0, i32 0, metadata !5} ; [ DW_TAG_typedef ]
!118 = metadata !{i32 589837, metadata !101, metadata !"version", metadata !16, i32 64, i64 32, i64 32, i64 5152, i32 0, metadata !5} ; [ DW_TAG_member ]
!119 = metadata !{i32 589837, metadata !101, metadata !"save_all_writes", metadata !16, i32 68, i64 32, i64 32, i64 5184, i32 0, metadata !13} ; [ DW_TAG_member ]
!120 = metadata !{i32 589876, i32 0, metadata !1, metadata !"__exe_fs", metadata !"__exe_fs", metadata !"", metadata !1, i32 24, metadata !121, i1 false, i1 true, %struct.exe_file_system_t* @__exe_fs} ; [ DW_TAG_variable ]
!121 = metadata !{i32 589846, metadata !16, metadata !"exe_file_system_t", metadata !16, i32 61, i64 0, i64 0, i64 0, i32 0, metadata !122} ; [ DW_TAG_typedef ]
!122 = metadata !{i32 589843, metadata !1, metadata !"", metadata !16, i32 42, i64 416, i64 32, i64 0, i32 0, null, metadata !123, i32 0, null} ; [ DW_TAG_structure_type ]
!123 = metadata !{metadata !124, metadata !125, metadata !126, metadata !127, metadata !128, metadata !129, metadata !130, metadata !132, metadata !133, metadata !134, metadata !135, metadata !136, metadata !137}
!124 = metadata !{i32 589837, metadata !122, metadata !"n_sym_files", metadata !16, i32 43, i64 32, i64 32, i64 0, i32 0, metadata !5} ; [ DW_TAG_member ]
!125 = metadata !{i32 589837, metadata !122, metadata !"sym_stdin", metadata !16, i32 44, i64 32, i64 32, i64 32, i32 0, metadata !59} ; [ DW_TAG_member ]
!126 = metadata !{i32 589837, metadata !122, metadata !"sym_stdout", metadata !16, i32 44, i64 32, i64 32, i64 64, i32 0, metadata !59} ; [ DW_TAG_member ]
!127 = metadata !{i32 589837, metadata !122, metadata !"stdout_writes", metadata !16, i32 45, i64 32, i64 32, i64 96, i32 0, metadata !5} ; [ DW_TAG_member ]
!128 = metadata !{i32 589837, metadata !122, metadata !"sym_files", metadata !16, i32 46, i64 32, i64 32, i64 128, i32 0, metadata !59} ; [ DW_TAG_member ]
!129 = metadata !{i32 589837, metadata !122, metadata !"max_failures", metadata !16, i32 49, i64 32, i64 32, i64 160, i32 0, metadata !5} ; [ DW_TAG_member ]
!130 = metadata !{i32 589837, metadata !122, metadata !"read_fail", metadata !16, i32 52, i64 32, i64 32, i64 192, i32 0, metadata !131} ; [ DW_TAG_member ]
!131 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !13} ; [ DW_TAG_pointer_type ]
!132 = metadata !{i32 589837, metadata !122, metadata !"write_fail", metadata !16, i32 52, i64 32, i64 32, i64 224, i32 0, metadata !131} ; [ DW_TAG_member ]
!133 = metadata !{i32 589837, metadata !122, metadata !"close_fail", metadata !16, i32 52, i64 32, i64 32, i64 256, i32 0, metadata !131} ; [ DW_TAG_member ]
!134 = metadata !{i32 589837, metadata !122, metadata !"ftruncate_fail", metadata !16, i32 52, i64 32, i64 32, i64 288, i32 0, metadata !131} ; [ DW_TAG_member ]
!135 = metadata !{i32 589837, metadata !122, metadata !"getcwd_fail", metadata !16, i32 52, i64 32, i64 32, i64 320, i32 0, metadata !131} ; [ DW_TAG_member ]
!136 = metadata !{i32 589837, metadata !122, metadata !"chmod_fail", metadata !16, i32 53, i64 32, i64 32, i64 352, i32 0, metadata !131} ; [ DW_TAG_member ]
!137 = metadata !{i32 589837, metadata !122, metadata !"fchmod_fail", metadata !16, i32 53, i64 32, i64 32, i64 384, i32 0, metadata !131} ; [ DW_TAG_member ]
!138 = metadata !{i32 46, i32 0, metadata !56, null}
!139 = metadata !{i32 47, i32 0, metadata !56, null}
!140 = metadata !{i32 50, i32 0, metadata !80, null}
!141 = metadata !{i32 48, i32 0, metadata !80, null}
!142 = metadata !{i32 51, i32 0, metadata !80, null}
!143 = metadata !{i32 53, i32 0, metadata !80, null}
!144 = metadata !{i32 52, i32 0, metadata !80, null}
!145 = metadata !{i32 55, i32 0, metadata !80, null}
!146 = metadata !{i32 57, i32 0, metadata !80, null}
!147 = metadata !{i32 58, i32 0, metadata !80, null}
!148 = metadata !{i32 59, i32 0, metadata !80, null}
!149 = metadata !{i32 61, i32 0, metadata !80, null}
!150 = metadata !{i32 64, i32 0, metadata !80, null}
!151 = metadata !{i32 66, i32 0, metadata !80, null}
!152 = metadata !{i32 71, i32 0, metadata !80, null}
!153 = metadata !{i32 75, i32 0, metadata !80, null}
!154 = metadata !{i32 77, i32 0, metadata !80, null}
!155 = metadata !{i32 78, i32 0, metadata !80, null}
!156 = metadata !{i32 79, i32 0, metadata !80, null}
!157 = metadata !{i32 80, i32 0, metadata !80, null}
!158 = metadata !{i32 81, i32 0, metadata !80, null}
!159 = metadata !{i32 82, i32 0, metadata !80, null}
!160 = metadata !{i32 83, i32 0, metadata !80, null}
!161 = metadata !{i32 84, i32 0, metadata !80, null}
!162 = metadata !{i32 85, i32 0, metadata !80, null}
!163 = metadata !{i32 86, i32 0, metadata !80, null}
!164 = metadata !{i32 87, i32 0, metadata !80, null}
!165 = metadata !{i32 88, i32 0, metadata !80, null}
!166 = metadata !{i32 89, i32 0, metadata !80, null}
!167 = metadata !{i32 90, i32 0, metadata !80, null}
!168 = metadata !{i32 92, i32 0, metadata !80, null}
!169 = metadata !{i32 93, i32 0, metadata !80, null}
!170 = metadata !{i32 94, i32 0, metadata !80, null}
!171 = metadata !{i32 95, i32 0, metadata !80, null}
!172 = metadata !{i32 110, i32 0, metadata !67, null}
!173 = metadata !{i32 111, i32 0, metadata !67, null}
!174 = metadata !{i32 112, i32 0, metadata !67, null}
!175 = metadata !{i32 114, i32 0, metadata !92, null}
!176 = metadata !{i32 115, i32 0, metadata !92, null}
!177 = metadata !{i8* getelementptr inbounds ([2 x i8]* @.str4, i32 0, i32 0)}
!178 = metadata !{i32 504, i32 0, metadata !9, metadata !179}
!179 = metadata !{i32 117, i32 0, metadata !92, null}
!180 = metadata !{i32 506, i32 0, metadata !181, metadata !179}
!181 = metadata !{i32 589835, metadata !9, i32 505, i32 0, metadata !10, i32 1} ; [ DW_TAG_lexical_block ]
!182 = metadata !{i32 119, i32 0, metadata !92, null}
!183 = metadata !{i32 120, i32 0, metadata !92, null}
!184 = metadata !{i32 0}
!185 = metadata !{i32 121, i32 0, metadata !92, null}
!186 = metadata !{i32 122, i32 0, metadata !92, null}
!187 = metadata !{i32 123, i32 0, metadata !92, null}
!188 = metadata !{i32 127, i32 0, metadata !92, null}
!189 = metadata !{i32 128, i32 0, metadata !92, null}
!190 = metadata !{i32 129, i32 0, metadata !92, null}
!191 = metadata !{i32 130, i32 0, metadata !92, null}
!192 = metadata !{i32 132, i32 0, metadata !92, null}
!193 = metadata !{i32 134, i32 0, metadata !92, null}
!194 = metadata !{i32 135, i32 0, metadata !92, null}
!195 = metadata !{i32 136, i32 0, metadata !92, null}
!196 = metadata !{i32 137, i32 0, metadata !92, null}
!197 = metadata !{i32 138, i32 0, metadata !92, null}
!198 = metadata !{i32 139, i32 0, metadata !92, null}
!199 = metadata !{i32 140, i32 0, metadata !92, null}
!200 = metadata !{i32 142, i32 0, metadata !92, null}
!201 = metadata !{i32 143, i32 0, metadata !92, null}
!202 = metadata !{i32 144, i32 0, metadata !92, null}
!203 = metadata !{i32 145, i32 0, metadata !92, null}
!204 = metadata !{i32 146, i32 0, metadata !92, null}
!205 = metadata !{i32 150, i32 0, metadata !92, null}
!206 = metadata !{i32 151, i32 0, metadata !92, null}
!207 = metadata !{i32 152, i32 0, metadata !92, null}
!208 = metadata !{i32 153, i32 0, metadata !92, null}
!209 = metadata !{i32 154, i32 0, metadata !92, null}
!210 = metadata !{i32 156, i32 0, metadata !92, null}
!211 = metadata !{i32 158, i32 0, metadata !92, null}
!212 = metadata !{i8* getelementptr inbounds ([14 x i8]* @.str12, i32 0, i32 0)}
!213 = metadata !{i32 97, i32 0, metadata !0, metadata !214}
!214 = metadata !{i32 159, i32 0, metadata !92, null}
!215 = metadata !{i32 98, i32 0, metadata !72, metadata !214}
!216 = metadata !{i32 99, i32 0, metadata !72, metadata !214}
!217 = metadata !{i32 100, i32 0, metadata !72, metadata !214}
!218 = metadata !{i32 160, i32 0, metadata !92, null}
!219 = metadata !{i32 161, i32 0, metadata !92, null}
