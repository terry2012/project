; ModuleID = 'strcat.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-f128:128:128-n8:16:32"
target triple = "i386-pc-linux-gnu"

define i8* @strcat(i8* %s, i8* nocapture %append) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %s}, i64 0, metadata !9), !dbg !13
  tail call void @llvm.dbg.value(metadata !{i8* %append}, i64 0, metadata !10), !dbg !13
  tail call void @llvm.dbg.value(metadata !{i8* %s}, i64 0, metadata !11), !dbg !14
  %0 = load i8* %s, align 1, !dbg !15
  %1 = icmp eq i8 %0, 0, !dbg !15
  br i1 %1, label %bb2.preheader, label %bb, !dbg !15

bb:                                               ; preds = %entry, %bb
  %indvar6 = phi i32 [ %tmp, %bb ], [ 0, %entry ]
  %tmp = add i32 %indvar6, 1
  %scevgep = getelementptr i8* %s, i32 %tmp
  %2 = load i8* %scevgep, align 1, !dbg !15
  %3 = icmp eq i8 %2, 0, !dbg !15
  br i1 %3, label %bb2.preheader, label %bb, !dbg !15

bb2.preheader:                                    ; preds = %bb, %entry
  %s_addr.0.lcssa = phi i8* [ %s, %entry ], [ %scevgep, %bb ]
  br label %bb2

bb2:                                              ; preds = %bb2.preheader, %bb2
  %indvar = phi i32 [ 0, %bb2.preheader ], [ %indvar.next, %bb2 ]
  %append_addr.0 = getelementptr i8* %append, i32 %indvar
  %s_addr.1 = getelementptr i8* %s_addr.0.lcssa, i32 %indvar
  %4 = load i8* %append_addr.0, align 1, !dbg !16
  store i8 %4, i8* %s_addr.1, align 1, !dbg !16
  %5 = icmp eq i8 %4, 0, !dbg !16
  %indvar.next = add i32 %indvar, 1
  br i1 %5, label %bb3, label %bb2, !dbg !16

bb3:                                              ; preds = %bb2
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !9), !dbg !16
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !10), !dbg !16
  ret i8* %s, !dbg !17
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}
!llvm.dbg.lv.strcat = !{!9, !10, !11}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"strcat", metadata !"strcat", metadata !"strcat", metadata !1, i32 39, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i8*)* @strcat} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"strcat.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"strcat.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !5, metadata !7}
!5 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !6} ; [ DW_TAG_pointer_type ]
!6 = metadata !{i32 589860, metadata !1, metadata !"char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!7 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !8} ; [ DW_TAG_pointer_type ]
!8 = metadata !{i32 589862, metadata !1, metadata !"", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !6} ; [ DW_TAG_const_type ]
!9 = metadata !{i32 590081, metadata !0, metadata !"s", metadata !1, i32 39, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!10 = metadata !{i32 590081, metadata !0, metadata !"append", metadata !1, i32 39, metadata !7, i32 0} ; [ DW_TAG_arg_variable ]
!11 = metadata !{i32 590080, metadata !12, metadata !"save", metadata !1, i32 40, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!12 = metadata !{i32 589835, metadata !0, i32 39, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!13 = metadata !{i32 39, i32 0, metadata !0, null}
!14 = metadata !{i32 40, i32 0, metadata !12, null}
!15 = metadata !{i32 42, i32 0, metadata !12, null}
!16 = metadata !{i32 44, i32 0, metadata !12, null}
!17 = metadata !{i32 46, i32 0, metadata !12, null}
