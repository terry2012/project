; ModuleID = 'memset.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-f128:128:128-n8:16:32"
target triple = "i386-pc-linux-gnu"

define i8* @memset(i8* %dst, i32 %s, i32 %count) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %dst}, i64 0, metadata !10), !dbg !17
  tail call void @llvm.dbg.value(metadata !{i32 %s}, i64 0, metadata !11), !dbg !17
  tail call void @llvm.dbg.value(metadata !{i32 %count}, i64 0, metadata !12), !dbg !17
  tail call void @llvm.dbg.value(metadata !{i8* %dst}, i64 0, metadata !13), !dbg !18
  tail call void @llvm.dbg.value(metadata !19, i64 0, metadata !12), !dbg !20
  %0 = icmp eq i32 %count, 0, !dbg !20
  br i1 %0, label %bb2, label %bb.lr.ph, !dbg !20

bb.lr.ph:                                         ; preds = %entry
  %1 = trunc i32 %s to i8, !dbg !21
  call void @llvm.memset.p0i8.i32(i8* %dst, i8 %1, i32 %count, i32 1, i1 false), !dbg !21
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !13), !dbg !21
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !12), !dbg !20
  br label %bb2

bb2:                                              ; preds = %bb.lr.ph, %entry
  ret i8* %dst, !dbg !22
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

declare void @llvm.memset.p0i8.i32(i8* nocapture, i8, i32, i32, i1) nounwind

!llvm.dbg.sp = !{!0}
!llvm.dbg.lv.memset = !{!10, !11, !12, !13}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"memset", metadata !"memset", metadata !"memset", metadata !1, i32 12, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i32, i32)* @memset} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"memset.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"memset.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !5, metadata !6, metadata !7}
!5 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!6 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!7 = metadata !{i32 589846, metadata !8, metadata !"size_t", metadata !8, i32 326, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_typedef ]
!8 = metadata !{i32 589865, metadata !"stddef.h", metadata !"/home/gfj/work/llvm-gcc-4.2-2.9-i686-linux/bin/../lib/gcc/i686-pc-linux-gnu/4.2.1/include", metadata !2} ; [ DW_TAG_file_type ]
!9 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!10 = metadata !{i32 590081, metadata !0, metadata !"dst", metadata !1, i32 12, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!11 = metadata !{i32 590081, metadata !0, metadata !"s", metadata !1, i32 12, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!12 = metadata !{i32 590081, metadata !0, metadata !"count", metadata !1, i32 12, metadata !7, i32 0} ; [ DW_TAG_arg_variable ]
!13 = metadata !{i32 590080, metadata !14, metadata !"a", metadata !1, i32 13, metadata !15, i32 0} ; [ DW_TAG_auto_variable ]
!14 = metadata !{i32 589835, metadata !0, i32 12, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!15 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !16} ; [ DW_TAG_pointer_type ]
!16 = metadata !{i32 589860, metadata !1, metadata !"char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!17 = metadata !{i32 12, i32 0, metadata !0, null}
!18 = metadata !{i32 13, i32 0, metadata !14, null}
!19 = metadata !{null}
!20 = metadata !{i32 14, i32 0, metadata !14, null}
!21 = metadata !{i32 15, i32 0, metadata !14, null}
!22 = metadata !{i32 16, i32 0, metadata !14, null}
