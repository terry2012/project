; ModuleID = 'atoi.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-f128:128:128-n8:16:32"
target triple = "i386-pc-linux-gnu"

define i32 @atoi(i8* %str) nounwind readonly {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %str}, i64 0, metadata !9), !dbg !10
  %0 = tail call i32 @strtol(i8* noalias nocapture %str, i8** noalias null, i32 10) nounwind, !dbg !11
  ret i32 %0, !dbg !11
}

declare i32 @strtol(i8* noalias, i8** noalias nocapture, i32) nounwind

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}
!llvm.dbg.lv.atoi = !{!9}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"atoi", metadata !"atoi", metadata !"atoi", metadata !1, i32 35, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*)* @atoi} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"atoi.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"atoi.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !6}
!5 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !7} ; [ DW_TAG_pointer_type ]
!7 = metadata !{i32 589862, metadata !1, metadata !"", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !8} ; [ DW_TAG_const_type ]
!8 = metadata !{i32 589860, metadata !1, metadata !"char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!9 = metadata !{i32 590081, metadata !0, metadata !"str", metadata !1, i32 35, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!10 = metadata !{i32 35, i32 0, metadata !0, null}
!11 = metadata !{i32 36, i32 0, metadata !12, null}
!12 = metadata !{i32 589835, metadata !0, i32 35, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
