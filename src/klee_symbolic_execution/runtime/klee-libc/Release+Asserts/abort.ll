; ModuleID = 'abort.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-f128:128:128-n8:16:32"
target triple = "i386-pc-linux-gnu"

define void @abort() noreturn nounwind {
entry:
  tail call void @klee_abort() noreturn nounwind, !dbg !5
  unreachable, !dbg !5
}

declare void @klee_abort() noreturn

!llvm.dbg.sp = !{!0}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"abort", metadata !"abort", metadata !"abort", metadata !1, i32 14, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void ()* @abort} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"abort.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"abort.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{null}
!5 = metadata !{i32 15, i32 0, metadata !6, null}
!6 = metadata !{i32 589835, metadata !0, i32 14, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
