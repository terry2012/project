; ModuleID = 'atexit.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-f128:128:128-n8:16:32"
target triple = "i386-pc-linux-gnu"

define i32 @atexit(void ()* %fn) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{void ()* %fn}, i64 0, metadata !9), !dbg !10
  %0 = bitcast void ()* %fn to void (i8*)*, !dbg !11
  %1 = tail call i32 @__cxa_atexit(void (i8*)* %0, i8* null, i8* null) nounwind, !dbg !11
  ret i32 %1, !dbg !11
}

declare i32 @__cxa_atexit(void (i8*)*, i8*, i8*)

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}
!llvm.dbg.lv.atexit = !{!9}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"atexit", metadata !"atexit", metadata !"atexit", metadata !1, i32 14, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (void ()*)* @atexit} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"atexit.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"atexit.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !6}
!5 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !7} ; [ DW_TAG_pointer_type ]
!7 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !8, i32 0, null} ; [ DW_TAG_subroutine_type ]
!8 = metadata !{null}
!9 = metadata !{i32 590081, metadata !0, metadata !"fn", metadata !1, i32 14, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!10 = metadata !{i32 14, i32 0, metadata !0, null}
!11 = metadata !{i32 15, i32 0, metadata !12, null}
!12 = metadata !{i32 589835, metadata !0, i32 14, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
