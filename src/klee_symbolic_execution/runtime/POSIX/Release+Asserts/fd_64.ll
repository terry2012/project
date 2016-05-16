; ModuleID = 'fd_64.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-f128:128:128-n8:16:32"
target triple = "i386-pc-linux-gnu"

%struct.__fsid_t = type { [2 x i32] }
%struct.dirent = type { i64, i64, i16, i8, [256 x i8] }
%struct.stat = type { i64, i16, i32, i32, i32, i32, i32, i64, i16, i64, i32, i64, %struct.timespec, %struct.timespec, %struct.timespec, i64 }
%struct.stat64 = type { i64, i32, i32, i32, i32, i32, i32, i64, i32, i64, i32, i64, %struct.timespec, %struct.timespec, %struct.timespec, i64 }
%struct.statfs = type { i32, i32, i64, i64, i64, i64, i64, %struct.__fsid_t, i32, i32, i32, [4 x i32] }
%struct.timespec = type { i32, i32 }

@__getdents64 = alias i32 (i32, %struct.dirent*, i32)* @getdents64

define i32 @"\01open64"(i8* %pathname, i32 %flags, ...) nounwind {
entry:
  %ap = alloca i8*, align 4
  call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !146), !dbg !156
  call void @llvm.dbg.value(metadata !{i32 %flags}, i64 0, metadata !147), !dbg !156
  call void @llvm.dbg.value(metadata !157, i64 0, metadata !148), !dbg !158
  %0 = and i32 %flags, 64, !dbg !159
  %1 = icmp eq i32 %0, 0, !dbg !159
  br i1 %1, label %bb3, label %bb, !dbg !159

bb:                                               ; preds = %entry
  call void @llvm.dbg.declare(metadata !{i8** %ap}, metadata !151), !dbg !160
  %ap1 = bitcast i8** %ap to i8*, !dbg !161
  call void @llvm.va_start(i8* %ap1), !dbg !161
  %2 = load i8** %ap, align 4, !dbg !162
  %3 = getelementptr inbounds i8* %2, i32 4, !dbg !162
  store i8* %3, i8** %ap, align 4, !dbg !162
  %4 = bitcast i8* %2 to i32*, !dbg !162
  %5 = load i32* %4, align 4, !dbg !162
  call void @llvm.dbg.value(metadata !{i32 %5}, i64 0, metadata !148), !dbg !162
  call void @llvm.va_end(i8* %ap1), !dbg !163
  br label %bb3, !dbg !163

bb3:                                              ; preds = %entry, %bb
  %mode.0 = phi i32 [ %5, %bb ], [ 0, %entry ]
  %6 = call i32 @__fd_open(i8* %pathname, i32 %flags, i32 %mode.0) nounwind, !dbg !164
  ret i32 %6, !dbg !164
}

define i32 @getdents64(i32 %fd, %struct.dirent* %dirp, i32 %count) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !121), !dbg !165
  tail call void @llvm.dbg.value(metadata !{%struct.dirent* %dirp}, i64 0, metadata !122), !dbg !165
  tail call void @llvm.dbg.value(metadata !{i32 %count}, i64 0, metadata !123), !dbg !165
  %0 = tail call i32 @__fd_getdents(i32 %fd, %struct.dirent* %dirp, i32 %count) nounwind, !dbg !166
  ret i32 %0, !dbg !166
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare i32 @__fd_getdents(i32, %struct.dirent*, i32)

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

define weak i32 @"\01statfs64"(i8* %path, %struct.statfs* %buf) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !124), !dbg !168
  tail call void @llvm.dbg.value(metadata !{%struct.statfs* %buf}, i64 0, metadata !125), !dbg !168
  %0 = tail call i32 @__fd_statfs(i8* %path, %struct.statfs* %buf) nounwind, !dbg !169
  ret i32 %0, !dbg !169
}

declare i32 @__fd_statfs(i8*, %struct.statfs*)

define i32 @ftruncate64(i32 %fd, i64 %length) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !126), !dbg !171
  tail call void @llvm.dbg.value(metadata !{i64 %length}, i64 0, metadata !127), !dbg !171
  %0 = tail call i32 @__fd_ftruncate(i32 %fd, i64 %length) nounwind, !dbg !172
  ret i32 %0, !dbg !172
}

declare i32 @__fd_ftruncate(i32, i64)

define i32 @"\01fstat64"(i32 %fd, %struct.stat* %buf) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !128), !dbg !174
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !129), !dbg !174
  %0 = bitcast %struct.stat* %buf to %struct.stat64*, !dbg !175
  %1 = tail call i32 @__fd_fstat(i32 %fd, %struct.stat64* %0) nounwind, !dbg !175
  ret i32 %1, !dbg !175
}

declare i32 @__fd_fstat(i32, %struct.stat64*)

define i32 @"\01__fxstat64"(i32 %vers, i32 %fd, %struct.stat* %buf) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %vers}, i64 0, metadata !130), !dbg !177
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !131), !dbg !177
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !132), !dbg !177
  %0 = bitcast %struct.stat* %buf to %struct.stat64*, !dbg !178
  %1 = tail call i32 @__fd_fstat(i32 %fd, %struct.stat64* %0) nounwind, !dbg !178
  ret i32 %1, !dbg !178
}

define i32 @"\01lstat64"(i8* %path, %struct.stat* %buf) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !133), !dbg !180
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !134), !dbg !180
  %0 = bitcast %struct.stat* %buf to %struct.stat64*, !dbg !181
  %1 = tail call i32 @__fd_lstat(i8* %path, %struct.stat64* %0) nounwind, !dbg !181
  ret i32 %1, !dbg !181
}

declare i32 @__fd_lstat(i8*, %struct.stat64*)

define i32 @"\01__lxstat64"(i32 %vers, i8* %path, %struct.stat* %buf) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %vers}, i64 0, metadata !135), !dbg !183
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !136), !dbg !183
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !137), !dbg !183
  %0 = bitcast %struct.stat* %buf to %struct.stat64*, !dbg !184
  %1 = tail call i32 @__fd_lstat(i8* %path, %struct.stat64* %0) nounwind, !dbg !184
  ret i32 %1, !dbg !184
}

define i32 @"\01stat64"(i8* %path, %struct.stat* %buf) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !138), !dbg !186
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !139), !dbg !186
  %0 = bitcast %struct.stat* %buf to %struct.stat64*, !dbg !187
  %1 = tail call i32 @__fd_stat(i8* %path, %struct.stat64* %0) nounwind, !dbg !187
  ret i32 %1, !dbg !187
}

declare i32 @__fd_stat(i8*, %struct.stat64*)

define i32 @"\01__xstat64"(i32 %vers, i8* %path, %struct.stat* %buf) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %vers}, i64 0, metadata !140), !dbg !189
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !141), !dbg !189
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !142), !dbg !189
  %0 = bitcast %struct.stat* %buf to %struct.stat64*, !dbg !190
  %1 = tail call i32 @__fd_stat(i8* %path, %struct.stat64* %0) nounwind, !dbg !190
  ret i32 %1, !dbg !190
}

define i64 @"\01lseek64"(i32 %fd, i64 %offset, i32 %whence) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !143), !dbg !192
  tail call void @llvm.dbg.value(metadata !{i64 %offset}, i64 0, metadata !144), !dbg !192
  tail call void @llvm.dbg.value(metadata !{i32 %whence}, i64 0, metadata !145), !dbg !192
  %0 = tail call i64 @__fd_lseek(i32 %fd, i64 %offset, i32 %whence) nounwind, !dbg !193
  ret i64 %0, !dbg !193
}

declare i64 @__fd_lseek(i32, i64, i32)

declare void @llvm.va_start(i8*) nounwind

declare void @llvm.va_end(i8*) nounwind

declare i32 @__fd_open(i8*, i32, i32)

!llvm.dbg.sp = !{!0, !27, !60, !65, !104, !107, !110, !113, !114, !115, !118}
!llvm.dbg.lv.getdents64 = !{!121, !122, !123}
!llvm.dbg.lv.statfs64 = !{!124, !125}
!llvm.dbg.lv.ftruncate64 = !{!126, !127}
!llvm.dbg.lv.fstat64 = !{!128, !129}
!llvm.dbg.lv.__fxstat64 = !{!130, !131, !132}
!llvm.dbg.lv.lstat64 = !{!133, !134}
!llvm.dbg.lv.__lxstat64 = !{!135, !136, !137}
!llvm.dbg.lv.stat64 = !{!138, !139}
!llvm.dbg.lv.__xstat64 = !{!140, !141, !142}
!llvm.dbg.lv.lseek64 = !{!143, !144, !145}
!llvm.dbg.lv.open64 = !{!146, !147, !148, !151}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"getdents64", metadata !"getdents64", metadata !"getdents64", metadata !1, i32 86, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, %struct.dirent*, i32)* @getdents64} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"fd_64.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/POSIX/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"fd_64.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/POSIX/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !6, metadata !7, metadata !6}
!5 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!7 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !8} ; [ DW_TAG_pointer_type ]
!8 = metadata !{i32 589843, metadata !1, metadata !"dirent", metadata !9, i32 24, i64 2208, i64 32, i64 0, i32 0, null, metadata !10, i32 0, null} ; [ DW_TAG_structure_type ]
!9 = metadata !{i32 589865, metadata !"dirent.h", metadata !"/usr/include/i386-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!10 = metadata !{metadata !11, metadata !15, metadata !18, metadata !20, metadata !22}
!11 = metadata !{i32 589837, metadata !8, metadata !"d_ino", metadata !9, i32 29, i64 64, i64 64, i64 0, i32 0, metadata !12} ; [ DW_TAG_member ]
!12 = metadata !{i32 589846, metadata !13, metadata !"__ino64_t", metadata !13, i32 139, i64 0, i64 0, i64 0, i32 0, metadata !14} ; [ DW_TAG_typedef ]
!13 = metadata !{i32 589865, metadata !"types.h", metadata !"/usr/include/i386-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!14 = metadata !{i32 589860, metadata !1, metadata !"long long unsigned int", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!15 = metadata !{i32 589837, metadata !8, metadata !"d_off", metadata !9, i32 30, i64 64, i64 64, i64 64, i32 0, metadata !16} ; [ DW_TAG_member ]
!16 = metadata !{i32 589846, metadata !13, metadata !"__off64_t", metadata !13, i32 143, i64 0, i64 0, i64 0, i32 0, metadata !17} ; [ DW_TAG_typedef ]
!17 = metadata !{i32 589860, metadata !1, metadata !"long long int", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!18 = metadata !{i32 589837, metadata !8, metadata !"d_reclen", metadata !9, i32 32, i64 16, i64 16, i64 128, i32 0, metadata !19} ; [ DW_TAG_member ]
!19 = metadata !{i32 589860, metadata !1, metadata !"short unsigned int", metadata !1, i32 0, i64 16, i64 16, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!20 = metadata !{i32 589837, metadata !8, metadata !"d_type", metadata !9, i32 33, i64 8, i64 8, i64 144, i32 0, metadata !21} ; [ DW_TAG_member ]
!21 = metadata !{i32 589860, metadata !1, metadata !"unsigned char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 8} ; [ DW_TAG_base_type ]
!22 = metadata !{i32 589837, metadata !8, metadata !"d_name", metadata !9, i32 34, i64 2048, i64 8, i64 152, i32 0, metadata !23} ; [ DW_TAG_member ]
!23 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 2048, i64 8, i64 0, i32 0, metadata !24, metadata !25, i32 0, null} ; [ DW_TAG_array_type ]
!24 = metadata !{i32 589860, metadata !1, metadata !"char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!25 = metadata !{metadata !26}
!26 = metadata !{i32 589857, i64 0, i64 255}      ; [ DW_TAG_subrange_type ]
!27 = metadata !{i32 589870, i32 0, metadata !1, metadata !"statfs", metadata !"statfs", metadata !"\01statfs64", metadata !1, i32 82, metadata !28, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, %struct.statfs*)* @"\01statfs64"} ; [ DW_TAG_subprogram ]
!28 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !29, i32 0, null} ; [ DW_TAG_subroutine_type ]
!29 = metadata !{metadata !5, metadata !30, metadata !32}
!30 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !31} ; [ DW_TAG_pointer_type ]
!31 = metadata !{i32 589862, metadata !1, metadata !"", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !24} ; [ DW_TAG_const_type ]
!32 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !33} ; [ DW_TAG_pointer_type ]
!33 = metadata !{i32 589843, metadata !1, metadata !"statfs", metadata !34, i32 26, i64 672, i64 32, i64 0, i32 0, null, metadata !35, i32 0, null} ; [ DW_TAG_structure_type ]
!34 = metadata !{i32 589865, metadata !"statfs.h", metadata !"/usr/include/i386-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!35 = metadata !{metadata !36, metadata !37, metadata !38, metadata !40, metadata !41, metadata !42, metadata !44, metadata !45, metadata !53, metadata !54, metadata !55, metadata !56}
!36 = metadata !{i32 589837, metadata !33, metadata !"f_type", metadata !34, i32 27, i64 32, i64 32, i64 0, i32 0, metadata !5} ; [ DW_TAG_member ]
!37 = metadata !{i32 589837, metadata !33, metadata !"f_bsize", metadata !34, i32 28, i64 32, i64 32, i64 32, i32 0, metadata !5} ; [ DW_TAG_member ]
!38 = metadata !{i32 589837, metadata !33, metadata !"f_blocks", metadata !34, i32 36, i64 64, i64 64, i64 64, i32 0, metadata !39} ; [ DW_TAG_member ]
!39 = metadata !{i32 589846, metadata !13, metadata !"__fsblkcnt64_t", metadata !13, i32 177, i64 0, i64 0, i64 0, i32 0, metadata !14} ; [ DW_TAG_typedef ]
!40 = metadata !{i32 589837, metadata !33, metadata !"f_bfree", metadata !34, i32 37, i64 64, i64 64, i64 128, i32 0, metadata !39} ; [ DW_TAG_member ]
!41 = metadata !{i32 589837, metadata !33, metadata !"f_bavail", metadata !34, i32 38, i64 64, i64 64, i64 192, i32 0, metadata !39} ; [ DW_TAG_member ]
!42 = metadata !{i32 589837, metadata !33, metadata !"f_files", metadata !34, i32 39, i64 64, i64 64, i64 256, i32 0, metadata !43} ; [ DW_TAG_member ]
!43 = metadata !{i32 589846, metadata !13, metadata !"__fsfilcnt64_t", metadata !13, i32 180, i64 0, i64 0, i64 0, i32 0, metadata !14} ; [ DW_TAG_typedef ]
!44 = metadata !{i32 589837, metadata !33, metadata !"f_ffree", metadata !34, i32 40, i64 64, i64 64, i64 320, i32 0, metadata !43} ; [ DW_TAG_member ]
!45 = metadata !{i32 589837, metadata !33, metadata !"f_fsid", metadata !34, i32 42, i64 64, i64 32, i64 384, i32 0, metadata !46} ; [ DW_TAG_member ]
!46 = metadata !{i32 589846, metadata !13, metadata !"__fsid_t", metadata !13, i32 145, i64 0, i64 0, i64 0, i32 0, metadata !47} ; [ DW_TAG_typedef ]
!47 = metadata !{i32 589843, metadata !1, metadata !"", metadata !13, i32 144, i64 64, i64 32, i64 0, i32 0, null, metadata !48, i32 0, null} ; [ DW_TAG_structure_type ]
!48 = metadata !{metadata !49}
!49 = metadata !{i32 589837, metadata !47, metadata !"__val", metadata !13, i32 144, i64 64, i64 32, i64 0, i32 0, metadata !50} ; [ DW_TAG_member ]
!50 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 32, i64 0, i32 0, metadata !5, metadata !51, i32 0, null} ; [ DW_TAG_array_type ]
!51 = metadata !{metadata !52}
!52 = metadata !{i32 589857, i64 0, i64 1}        ; [ DW_TAG_subrange_type ]
!53 = metadata !{i32 589837, metadata !33, metadata !"f_namelen", metadata !34, i32 43, i64 32, i64 32, i64 448, i32 0, metadata !5} ; [ DW_TAG_member ]
!54 = metadata !{i32 589837, metadata !33, metadata !"f_frsize", metadata !34, i32 44, i64 32, i64 32, i64 480, i32 0, metadata !5} ; [ DW_TAG_member ]
!55 = metadata !{i32 589837, metadata !33, metadata !"f_flags", metadata !34, i32 45, i64 32, i64 32, i64 512, i32 0, metadata !5} ; [ DW_TAG_member ]
!56 = metadata !{i32 589837, metadata !33, metadata !"f_spare", metadata !34, i32 46, i64 128, i64 32, i64 544, i32 0, metadata !57} ; [ DW_TAG_member ]
!57 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 128, i64 32, i64 0, i32 0, metadata !5, metadata !58, i32 0, null} ; [ DW_TAG_array_type ]
!58 = metadata !{metadata !59}
!59 = metadata !{i32 589857, i64 0, i64 3}        ; [ DW_TAG_subrange_type ]
!60 = metadata !{i32 589870, i32 0, metadata !1, metadata !"ftruncate64", metadata !"ftruncate64", metadata !"ftruncate64", metadata !1, i32 77, metadata !61, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i64)* @ftruncate64} ; [ DW_TAG_subprogram ]
!61 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !62, i32 0, null} ; [ DW_TAG_subroutine_type ]
!62 = metadata !{metadata !5, metadata !5, metadata !63}
!63 = metadata !{i32 589846, metadata !64, metadata !"off64_t", metadata !64, i32 99, i64 0, i64 0, i64 0, i32 0, metadata !17} ; [ DW_TAG_typedef ]
!64 = metadata !{i32 589865, metadata !"types.h", metadata !"/usr/include/i386-linux-gnu/sys", metadata !2} ; [ DW_TAG_file_type ]
!65 = metadata !{i32 589870, i32 0, metadata !1, metadata !"fstat", metadata !"fstat", metadata !"\01fstat64", metadata !1, i32 73, metadata !66, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, %struct.stat*)* @"\01fstat64"} ; [ DW_TAG_subprogram ]
!66 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !67, i32 0, null} ; [ DW_TAG_subroutine_type ]
!67 = metadata !{metadata !5, metadata !5, metadata !68}
!68 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !69} ; [ DW_TAG_pointer_type ]
!69 = metadata !{i32 589843, metadata !1, metadata !"stat", metadata !70, i32 40, i64 768, i64 32, i64 0, i32 0, null, metadata !71, i32 0, null} ; [ DW_TAG_structure_type ]
!70 = metadata !{i32 589865, metadata !"stat.h", metadata !"/usr/include/i386-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!71 = metadata !{metadata !72, metadata !74, metadata !75, metadata !78, metadata !80, metadata !82, metadata !84, metadata !86, metadata !87, metadata !88, metadata !89, metadata !92, metadata !94, metadata !101, metadata !102, metadata !103}
!72 = metadata !{i32 589837, metadata !69, metadata !"st_dev", metadata !70, i32 41, i64 64, i64 64, i64 0, i32 0, metadata !73} ; [ DW_TAG_member ]
!73 = metadata !{i32 589846, metadata !13, metadata !"__dev_t", metadata !13, i32 135, i64 0, i64 0, i64 0, i32 0, metadata !14} ; [ DW_TAG_typedef ]
!74 = metadata !{i32 589837, metadata !69, metadata !"__pad1", metadata !70, i32 42, i64 16, i64 16, i64 64, i32 0, metadata !19} ; [ DW_TAG_member ]
!75 = metadata !{i32 589837, metadata !69, metadata !"__st_ino", metadata !70, i32 46, i64 32, i64 32, i64 96, i32 0, metadata !76} ; [ DW_TAG_member ]
!76 = metadata !{i32 589846, metadata !13, metadata !"__ino_t", metadata !13, i32 138, i64 0, i64 0, i64 0, i32 0, metadata !77} ; [ DW_TAG_typedef ]
!77 = metadata !{i32 589860, metadata !1, metadata !"long unsigned int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!78 = metadata !{i32 589837, metadata !69, metadata !"st_mode", metadata !70, i32 48, i64 32, i64 32, i64 128, i32 0, metadata !79} ; [ DW_TAG_member ]
!79 = metadata !{i32 589846, metadata !13, metadata !"__mode_t", metadata !13, i32 140, i64 0, i64 0, i64 0, i32 0, metadata !6} ; [ DW_TAG_typedef ]
!80 = metadata !{i32 589837, metadata !69, metadata !"st_nlink", metadata !70, i32 49, i64 32, i64 32, i64 160, i32 0, metadata !81} ; [ DW_TAG_member ]
!81 = metadata !{i32 589846, metadata !13, metadata !"__nlink_t", metadata !13, i32 141, i64 0, i64 0, i64 0, i32 0, metadata !6} ; [ DW_TAG_typedef ]
!82 = metadata !{i32 589837, metadata !69, metadata !"st_uid", metadata !70, i32 50, i64 32, i64 32, i64 192, i32 0, metadata !83} ; [ DW_TAG_member ]
!83 = metadata !{i32 589846, metadata !13, metadata !"__uid_t", metadata !13, i32 136, i64 0, i64 0, i64 0, i32 0, metadata !6} ; [ DW_TAG_typedef ]
!84 = metadata !{i32 589837, metadata !69, metadata !"st_gid", metadata !70, i32 51, i64 32, i64 32, i64 224, i32 0, metadata !85} ; [ DW_TAG_member ]
!85 = metadata !{i32 589846, metadata !13, metadata !"__gid_t", metadata !13, i32 137, i64 0, i64 0, i64 0, i32 0, metadata !6} ; [ DW_TAG_typedef ]
!86 = metadata !{i32 589837, metadata !69, metadata !"st_rdev", metadata !70, i32 52, i64 64, i64 64, i64 256, i32 0, metadata !73} ; [ DW_TAG_member ]
!87 = metadata !{i32 589837, metadata !69, metadata !"__pad2", metadata !70, i32 53, i64 16, i64 16, i64 320, i32 0, metadata !19} ; [ DW_TAG_member ]
!88 = metadata !{i32 589837, metadata !69, metadata !"st_size", metadata !70, i32 57, i64 64, i64 64, i64 352, i32 0, metadata !16} ; [ DW_TAG_member ]
!89 = metadata !{i32 589837, metadata !69, metadata !"st_blksize", metadata !70, i32 59, i64 32, i64 32, i64 416, i32 0, metadata !90} ; [ DW_TAG_member ]
!90 = metadata !{i32 589846, metadata !13, metadata !"__blksize_t", metadata !13, i32 169, i64 0, i64 0, i64 0, i32 0, metadata !91} ; [ DW_TAG_typedef ]
!91 = metadata !{i32 589860, metadata !1, metadata !"long int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!92 = metadata !{i32 589837, metadata !69, metadata !"st_blocks", metadata !70, i32 64, i64 64, i64 64, i64 448, i32 0, metadata !93} ; [ DW_TAG_member ]
!93 = metadata !{i32 589846, metadata !13, metadata !"__blkcnt64_t", metadata !13, i32 173, i64 0, i64 0, i64 0, i32 0, metadata !17} ; [ DW_TAG_typedef ]
!94 = metadata !{i32 589837, metadata !69, metadata !"st_atim", metadata !70, i32 73, i64 64, i64 32, i64 512, i32 0, metadata !95} ; [ DW_TAG_member ]
!95 = metadata !{i32 589843, metadata !1, metadata !"timespec", metadata !96, i32 121, i64 64, i64 32, i64 0, i32 0, null, metadata !97, i32 0, null} ; [ DW_TAG_structure_type ]
!96 = metadata !{i32 589865, metadata !"time.h", metadata !"/usr/include", metadata !2} ; [ DW_TAG_file_type ]
!97 = metadata !{metadata !98, metadata !100}
!98 = metadata !{i32 589837, metadata !95, metadata !"tv_sec", metadata !96, i32 122, i64 32, i64 32, i64 0, i32 0, metadata !99} ; [ DW_TAG_member ]
!99 = metadata !{i32 589846, metadata !13, metadata !"__time_t", metadata !13, i32 150, i64 0, i64 0, i64 0, i32 0, metadata !91} ; [ DW_TAG_typedef ]
!100 = metadata !{i32 589837, metadata !95, metadata !"tv_nsec", metadata !96, i32 123, i64 32, i64 32, i64 32, i32 0, metadata !91} ; [ DW_TAG_member ]
!101 = metadata !{i32 589837, metadata !69, metadata !"st_mtim", metadata !70, i32 74, i64 64, i64 32, i64 576, i32 0, metadata !95} ; [ DW_TAG_member ]
!102 = metadata !{i32 589837, metadata !69, metadata !"st_ctim", metadata !70, i32 75, i64 64, i64 32, i64 640, i32 0, metadata !95} ; [ DW_TAG_member ]
!103 = metadata !{i32 589837, metadata !69, metadata !"st_ino", metadata !70, i32 91, i64 64, i64 64, i64 704, i32 0, metadata !12} ; [ DW_TAG_member ]
!104 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fxstat", metadata !"__fxstat", metadata !"\01__fxstat64", metadata !1, i32 69, metadata !105, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i32, %struct.stat*)* @"\01__fxstat64"} ; [ DW_TAG_subprogram ]
!105 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !106, i32 0, null} ; [ DW_TAG_subroutine_type ]
!106 = metadata !{metadata !5, metadata !5, metadata !5, metadata !68}
!107 = metadata !{i32 589870, i32 0, metadata !1, metadata !"lstat", metadata !"lstat", metadata !"\01lstat64", metadata !1, i32 65, metadata !108, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, %struct.stat*)* @"\01lstat64"} ; [ DW_TAG_subprogram ]
!108 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !109, i32 0, null} ; [ DW_TAG_subroutine_type ]
!109 = metadata !{metadata !5, metadata !30, metadata !68}
!110 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__lxstat", metadata !"__lxstat", metadata !"\01__lxstat64", metadata !1, i32 61, metadata !111, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i8*, %struct.stat*)* @"\01__lxstat64"} ; [ DW_TAG_subprogram ]
!111 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !112, i32 0, null} ; [ DW_TAG_subroutine_type ]
!112 = metadata !{metadata !5, metadata !5, metadata !30, metadata !68}
!113 = metadata !{i32 589870, i32 0, metadata !1, metadata !"stat", metadata !"stat", metadata !"\01stat64", metadata !1, i32 57, metadata !108, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, %struct.stat*)* @"\01stat64"} ; [ DW_TAG_subprogram ]
!114 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__xstat", metadata !"__xstat", metadata !"\01__xstat64", metadata !1, i32 53, metadata !111, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i8*, %struct.stat*)* @"\01__xstat64"} ; [ DW_TAG_subprogram ]
!115 = metadata !{i32 589870, i32 0, metadata !1, metadata !"lseek", metadata !"lseek", metadata !"\01lseek64", metadata !1, i32 49, metadata !116, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i64 (i32, i64, i32)* @"\01lseek64"} ; [ DW_TAG_subprogram ]
!116 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !117, i32 0, null} ; [ DW_TAG_subroutine_type ]
!117 = metadata !{metadata !63, metadata !5, metadata !63, metadata !5}
!118 = metadata !{i32 589870, i32 0, metadata !1, metadata !"open", metadata !"open", metadata !"\01open64", metadata !1, i32 35, metadata !119, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, i32, ...)* @"\01open64"} ; [ DW_TAG_subprogram ]
!119 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !120, i32 0, null} ; [ DW_TAG_subroutine_type ]
!120 = metadata !{metadata !5, metadata !30, metadata !5}
!121 = metadata !{i32 590081, metadata !0, metadata !"fd", metadata !1, i32 86, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!122 = metadata !{i32 590081, metadata !0, metadata !"dirp", metadata !1, i32 86, metadata !7, i32 0} ; [ DW_TAG_arg_variable ]
!123 = metadata !{i32 590081, metadata !0, metadata !"count", metadata !1, i32 86, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!124 = metadata !{i32 590081, metadata !27, metadata !"path", metadata !1, i32 82, metadata !30, i32 0} ; [ DW_TAG_arg_variable ]
!125 = metadata !{i32 590081, metadata !27, metadata !"buf", metadata !1, i32 82, metadata !32, i32 0} ; [ DW_TAG_arg_variable ]
!126 = metadata !{i32 590081, metadata !60, metadata !"fd", metadata !1, i32 77, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!127 = metadata !{i32 590081, metadata !60, metadata !"length", metadata !1, i32 77, metadata !63, i32 0} ; [ DW_TAG_arg_variable ]
!128 = metadata !{i32 590081, metadata !65, metadata !"fd", metadata !1, i32 73, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!129 = metadata !{i32 590081, metadata !65, metadata !"buf", metadata !1, i32 73, metadata !68, i32 0} ; [ DW_TAG_arg_variable ]
!130 = metadata !{i32 590081, metadata !104, metadata !"vers", metadata !1, i32 69, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!131 = metadata !{i32 590081, metadata !104, metadata !"fd", metadata !1, i32 69, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!132 = metadata !{i32 590081, metadata !104, metadata !"buf", metadata !1, i32 69, metadata !68, i32 0} ; [ DW_TAG_arg_variable ]
!133 = metadata !{i32 590081, metadata !107, metadata !"path", metadata !1, i32 65, metadata !30, i32 0} ; [ DW_TAG_arg_variable ]
!134 = metadata !{i32 590081, metadata !107, metadata !"buf", metadata !1, i32 65, metadata !68, i32 0} ; [ DW_TAG_arg_variable ]
!135 = metadata !{i32 590081, metadata !110, metadata !"vers", metadata !1, i32 61, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!136 = metadata !{i32 590081, metadata !110, metadata !"path", metadata !1, i32 61, metadata !30, i32 0} ; [ DW_TAG_arg_variable ]
!137 = metadata !{i32 590081, metadata !110, metadata !"buf", metadata !1, i32 61, metadata !68, i32 0} ; [ DW_TAG_arg_variable ]
!138 = metadata !{i32 590081, metadata !113, metadata !"path", metadata !1, i32 57, metadata !30, i32 0} ; [ DW_TAG_arg_variable ]
!139 = metadata !{i32 590081, metadata !113, metadata !"buf", metadata !1, i32 57, metadata !68, i32 0} ; [ DW_TAG_arg_variable ]
!140 = metadata !{i32 590081, metadata !114, metadata !"vers", metadata !1, i32 53, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!141 = metadata !{i32 590081, metadata !114, metadata !"path", metadata !1, i32 53, metadata !30, i32 0} ; [ DW_TAG_arg_variable ]
!142 = metadata !{i32 590081, metadata !114, metadata !"buf", metadata !1, i32 53, metadata !68, i32 0} ; [ DW_TAG_arg_variable ]
!143 = metadata !{i32 590081, metadata !115, metadata !"fd", metadata !1, i32 49, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!144 = metadata !{i32 590081, metadata !115, metadata !"offset", metadata !1, i32 49, metadata !63, i32 0} ; [ DW_TAG_arg_variable ]
!145 = metadata !{i32 590081, metadata !115, metadata !"whence", metadata !1, i32 49, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!146 = metadata !{i32 590081, metadata !118, metadata !"pathname", metadata !1, i32 35, metadata !30, i32 0} ; [ DW_TAG_arg_variable ]
!147 = metadata !{i32 590081, metadata !118, metadata !"flags", metadata !1, i32 35, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!148 = metadata !{i32 590080, metadata !149, metadata !"mode", metadata !1, i32 36, metadata !150, i32 0} ; [ DW_TAG_auto_variable ]
!149 = metadata !{i32 589835, metadata !118, i32 35, i32 0, metadata !1, i32 10} ; [ DW_TAG_lexical_block ]
!150 = metadata !{i32 589846, metadata !64, metadata !"mode_t", metadata !64, i32 76, i64 0, i64 0, i64 0, i32 0, metadata !6} ; [ DW_TAG_typedef ]
!151 = metadata !{i32 590080, metadata !152, metadata !"ap", metadata !1, i32 40, metadata !153, i32 0} ; [ DW_TAG_auto_variable ]
!152 = metadata !{i32 589835, metadata !149, i32 41, i32 0, metadata !1, i32 11} ; [ DW_TAG_lexical_block ]
!153 = metadata !{i32 589846, metadata !154, metadata !"va_list", metadata !154, i32 113, i64 0, i64 0, i64 0, i32 0, metadata !155} ; [ DW_TAG_typedef ]
!154 = metadata !{i32 589865, metadata !"stdio.h", metadata !"/usr/include", metadata !2} ; [ DW_TAG_file_type ]
!155 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !24} ; [ DW_TAG_pointer_type ]
!156 = metadata !{i32 35, i32 0, metadata !118, null}
!157 = metadata !{i32 0}
!158 = metadata !{i32 36, i32 0, metadata !149, null}
!159 = metadata !{i32 38, i32 0, metadata !149, null}
!160 = metadata !{i32 40, i32 0, metadata !152, null}
!161 = metadata !{i32 41, i32 0, metadata !152, null}
!162 = metadata !{i32 42, i32 0, metadata !152, null}
!163 = metadata !{i32 43, i32 0, metadata !152, null}
!164 = metadata !{i32 46, i32 0, metadata !149, null}
!165 = metadata !{i32 86, i32 0, metadata !0, null}
!166 = metadata !{i32 87, i32 0, metadata !167, null}
!167 = metadata !{i32 589835, metadata !0, i32 86, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!168 = metadata !{i32 82, i32 0, metadata !27, null}
!169 = metadata !{i32 83, i32 0, metadata !170, null}
!170 = metadata !{i32 589835, metadata !27, i32 82, i32 0, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!171 = metadata !{i32 77, i32 0, metadata !60, null}
!172 = metadata !{i32 78, i32 0, metadata !173, null}
!173 = metadata !{i32 589835, metadata !60, i32 77, i32 0, metadata !1, i32 2} ; [ DW_TAG_lexical_block ]
!174 = metadata !{i32 73, i32 0, metadata !65, null}
!175 = metadata !{i32 74, i32 0, metadata !176, null}
!176 = metadata !{i32 589835, metadata !65, i32 73, i32 0, metadata !1, i32 3} ; [ DW_TAG_lexical_block ]
!177 = metadata !{i32 69, i32 0, metadata !104, null}
!178 = metadata !{i32 70, i32 0, metadata !179, null}
!179 = metadata !{i32 589835, metadata !104, i32 69, i32 0, metadata !1, i32 4} ; [ DW_TAG_lexical_block ]
!180 = metadata !{i32 65, i32 0, metadata !107, null}
!181 = metadata !{i32 66, i32 0, metadata !182, null}
!182 = metadata !{i32 589835, metadata !107, i32 65, i32 0, metadata !1, i32 5} ; [ DW_TAG_lexical_block ]
!183 = metadata !{i32 61, i32 0, metadata !110, null}
!184 = metadata !{i32 62, i32 0, metadata !185, null}
!185 = metadata !{i32 589835, metadata !110, i32 61, i32 0, metadata !1, i32 6} ; [ DW_TAG_lexical_block ]
!186 = metadata !{i32 57, i32 0, metadata !113, null}
!187 = metadata !{i32 58, i32 0, metadata !188, null}
!188 = metadata !{i32 589835, metadata !113, i32 57, i32 0, metadata !1, i32 7} ; [ DW_TAG_lexical_block ]
!189 = metadata !{i32 53, i32 0, metadata !114, null}
!190 = metadata !{i32 54, i32 0, metadata !191, null}
!191 = metadata !{i32 589835, metadata !114, i32 53, i32 0, metadata !1, i32 8} ; [ DW_TAG_lexical_block ]
!192 = metadata !{i32 49, i32 0, metadata !115, null}
!193 = metadata !{i32 50, i32 0, metadata !194, null}
!194 = metadata !{i32 589835, metadata !115, i32 49, i32 0, metadata !1, i32 9} ; [ DW_TAG_lexical_block ]
