; ModuleID = 'strcmp.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-f128:128:128-n8:16:32"
target triple = "i386-pc-linux-gnu"

define i32 @strcmp(i8* nocapture %a, i8* nocapture %b) nounwind readonly {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %a}, i64 0, metadata !9), !dbg !11
  tail call void @llvm.dbg.value(metadata !{i8* %b}, i64 0, metadata !10), !dbg !11
  br label %bb1, !dbg !12

bb:                                               ; preds = %bb1
  %indvar.next = add i32 %indvar, 1
  br label %bb1, !dbg !14

bb1:                                              ; preds = %bb, %entry
  %indvar = phi i32 [ %indvar.next, %bb ], [ 0, %entry ]
  %b_addr.0 = getelementptr i8* %b, i32 %indvar
  %a_addr.0 = getelementptr i8* %a, i32 %indvar
  %0 = load i8* %a_addr.0, align 1, !dbg !12
  %1 = icmp ne i8 %0, 0, !dbg !12
  %.pre = load i8* %b_addr.0, align 1
  %2 = icmp eq i8 %0, %.pre, !dbg !12
  %or.cond = and i1 %1, %2
  br i1 %or.cond, label %bb, label %bb3, !dbg !12

bb3:                                              ; preds = %bb1
  %3 = sext i8 %0 to i32, !dbg !15
  %4 = sext i8 %.pre to i32, !dbg !15
  %5 = sub nsw i32 %3, %4, !dbg !15
  ret i32 %5, !dbg !15
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}
!llvm.dbg.lv.strcmp = !{!9, !10}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"strcmp", metadata !"strcmp", metadata !"strcmp", metadata !1, i32 10, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, i8*)* @strcmp} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"strcmp.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"strcmp.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !6, metadata !6}
!5 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !7} ; [ DW_TAG_pointer_type ]
!7 = metadata !{i32 589862, metadata !1, metadata !"", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !8} ; [ DW_TAG_const_type ]
!8 = metadata !{i32 589860, metadata !1, metadata !"char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!9 = metadata !{i32 590081, metadata !0, metadata !"a", metadata !1, i32 10, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!10 = metadata !{i32 590081, metadata !0, metadata !"b", metadata !1, i32 10, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!11 = metadata !{i32 10, i32 0, metadata !0, null}
!12 = metadata !{i32 11, i32 0, metadata !13, null}
!13 = metadata !{i32 589835, metadata !0, i32 10, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!14 = metadata !{i32 12, i32 0, metadata !13, null}
!15 = metadata !{i32 13, i32 0, metadata !13, null}
