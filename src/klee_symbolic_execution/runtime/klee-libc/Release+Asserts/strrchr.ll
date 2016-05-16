; ModuleID = 'strrchr.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-f128:128:128-n8:16:32"
target triple = "i386-pc-linux-gnu"

define i8* @strrchr(i8* %t, i32 %c) nounwind readonly {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %t}, i64 0, metadata !10), !dbg !15
  tail call void @llvm.dbg.value(metadata !{i32 %c}, i64 0, metadata !11), !dbg !15
  tail call void @llvm.dbg.value(metadata !16, i64 0, metadata !14), !dbg !17
  %0 = trunc i32 %c to i8, !dbg !18
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !12), !dbg !18
  %1 = load i8* %t, align 1, !dbg !19
  %2 = icmp eq i8 %1, %0, !dbg !19
  tail call void @llvm.dbg.value(metadata !{i8* %t}, i64 0, metadata !14), !dbg !19
  %l.16 = select i1 %2, i8* %t, i8* null
  %3 = icmp eq i8 %1, 0, !dbg !19
  br i1 %3, label %bb3, label %bb4, !dbg !19

bb3:                                              ; preds = %bb4, %entry
  %l.1.lcssa = phi i8* [ %l.16, %entry ], [ %l.1, %bb4 ]
  ret i8* %l.1.lcssa, !dbg !19

bb4:                                              ; preds = %entry, %bb4
  %indvar = phi i32 [ %tmp, %bb4 ], [ 0, %entry ]
  %l.18 = phi i8* [ %l.1, %bb4 ], [ %l.16, %entry ]
  %tmp = add i32 %indvar, 1
  %scevgep = getelementptr i8* %t, i32 %tmp
  %4 = load i8* %scevgep, align 1, !dbg !19
  %5 = icmp eq i8 %4, %0, !dbg !19
  %l.1 = select i1 %5, i8* %scevgep, i8* %l.18
  %6 = icmp eq i8 %4, 0, !dbg !19
  br i1 %6, label %bb3, label %bb4, !dbg !19
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}
!llvm.dbg.lv.strrchr = !{!10, !11, !12, !14}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"strrchr", metadata !"strrchr", metadata !"strrchr", metadata !1, i32 12, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i32)* @strrchr} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"strrchr.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"strrchr.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !7, metadata !9}
!5 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !6} ; [ DW_TAG_pointer_type ]
!6 = metadata !{i32 589860, metadata !1, metadata !"char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!7 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !8} ; [ DW_TAG_pointer_type ]
!8 = metadata !{i32 589862, metadata !1, metadata !"", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !6} ; [ DW_TAG_const_type ]
!9 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!10 = metadata !{i32 590081, metadata !0, metadata !"t", metadata !1, i32 12, metadata !7, i32 0} ; [ DW_TAG_arg_variable ]
!11 = metadata !{i32 590081, metadata !0, metadata !"c", metadata !1, i32 12, metadata !9, i32 0} ; [ DW_TAG_arg_variable ]
!12 = metadata !{i32 590080, metadata !13, metadata !"ch", metadata !1, i32 13, metadata !6, i32 0} ; [ DW_TAG_auto_variable ]
!13 = metadata !{i32 589835, metadata !0, i32 12, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!14 = metadata !{i32 590080, metadata !13, metadata !"l", metadata !1, i32 14, metadata !7, i32 0} ; [ DW_TAG_auto_variable ]
!15 = metadata !{i32 12, i32 0, metadata !0, null}
!16 = metadata !{i8* null}
!17 = metadata !{i32 14, i32 0, metadata !13, null}
!18 = metadata !{i32 16, i32 0, metadata !13, null}
!19 = metadata !{i32 18, i32 0, metadata !13, null}
