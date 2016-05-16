; ModuleID = 'tolower.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-f128:128:128-n8:16:32"
target triple = "i386-pc-linux-gnu"

define i32 @tolower(i32 %ch) nounwind readnone {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %ch}, i64 0, metadata !6), !dbg !7
  %0 = add nsw i32 %ch, -65, !dbg !8
  %1 = add nsw i32 %ch, 32, !dbg !10
  %2 = icmp ult i32 %0, 26, !dbg !8
  %.ch = select i1 %2, i32 %1, i32 %ch
  ret i32 %.ch, !dbg !11
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}
!llvm.dbg.lv.tolower = !{!6}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"tolower", metadata !"tolower", metadata !"tolower", metadata !1, i32 10, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32)* @tolower} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"tolower.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"tolower.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !5}
!5 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 590081, metadata !0, metadata !"ch", metadata !1, i32 10, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!7 = metadata !{i32 10, i32 0, metadata !0, null}
!8 = metadata !{i32 11, i32 0, metadata !9, null}
!9 = metadata !{i32 589835, metadata !0, i32 10, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!10 = metadata !{i32 12, i32 0, metadata !9, null}
!11 = metadata !{i32 13, i32 0, metadata !9, null}
