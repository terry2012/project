; ModuleID = 'strncmp.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-f128:128:128-n8:16:32"
target triple = "i386-pc-linux-gnu"

define i32 @strncmp(i8* nocapture %s1, i8* nocapture %s2, i32 %n) nounwind readonly {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %s1}, i64 0, metadata !12), !dbg !15
  tail call void @llvm.dbg.value(metadata !{i8* %s2}, i64 0, metadata !13), !dbg !15
  tail call void @llvm.dbg.value(metadata !{i32 %n}, i64 0, metadata !14), !dbg !15
  %0 = icmp eq i32 %n, 0, !dbg !16
  br i1 %0, label %bb7, label %bb1.preheader, !dbg !16

bb1.preheader:                                    ; preds = %entry
  %tmp15 = add i32 %n, -1
  br label %bb1

bb1:                                              ; preds = %bb1.preheader, %bb5
  %indvar = phi i32 [ 0, %bb1.preheader ], [ %indvar.next, %bb5 ]
  %s2_addr.0 = getelementptr i8* %s2, i32 %indvar
  %s1_addr.0 = getelementptr i8* %s1, i32 %indvar
  %1 = load i8* %s1_addr.0, align 1, !dbg !18
  %2 = load i8* %s2_addr.0, align 1, !dbg !18
  %3 = icmp eq i8 %1, %2, !dbg !18
  br i1 %3, label %bb3, label %bb2, !dbg !18

bb2:                                              ; preds = %bb1
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !13), !dbg !18
  %4 = zext i8 %1 to i32, !dbg !19
  %5 = zext i8 %2 to i32, !dbg !19
  %6 = sub nsw i32 %4, %5, !dbg !19
  br label %bb7, !dbg !19

bb3:                                              ; preds = %bb1
  %7 = icmp eq i8 %1, 0, !dbg !20
  br i1 %7, label %bb7, label %bb5, !dbg !20

bb5:                                              ; preds = %bb3
  %8 = icmp eq i32 %tmp15, %indvar, !dbg !21
  %indvar.next = add i32 %indvar, 1
  br i1 %8, label %bb7, label %bb1, !dbg !21

bb7:                                              ; preds = %bb3, %bb5, %entry, %bb2
  %.0 = phi i32 [ %6, %bb2 ], [ 0, %entry ], [ 0, %bb5 ], [ 0, %bb3 ]
  ret i32 %.0, !dbg !22
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}
!llvm.dbg.lv.strncmp = !{!12, !13, !14}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"strncmp", metadata !"strncmp", metadata !"strncmp", metadata !1, i32 37, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, i8*, i32)* @strncmp} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"strncmp.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"strncmp.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !6, metadata !6, metadata !9}
!5 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !7} ; [ DW_TAG_pointer_type ]
!7 = metadata !{i32 589862, metadata !1, metadata !"", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !8} ; [ DW_TAG_const_type ]
!8 = metadata !{i32 589860, metadata !1, metadata !"char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!9 = metadata !{i32 589846, metadata !10, metadata !"size_t", metadata !10, i32 326, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!10 = metadata !{i32 589865, metadata !"stddef.h", metadata !"/home/gfj/work/llvm-gcc-4.2-2.9-i686-linux/bin/../lib/gcc/i686-pc-linux-gnu/4.2.1/include", metadata !2} ; [ DW_TAG_file_type ]
!11 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!12 = metadata !{i32 590081, metadata !0, metadata !"s1", metadata !1, i32 36, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!13 = metadata !{i32 590081, metadata !0, metadata !"s2", metadata !1, i32 36, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!14 = metadata !{i32 590081, metadata !0, metadata !"n", metadata !1, i32 36, metadata !9, i32 0} ; [ DW_TAG_arg_variable ]
!15 = metadata !{i32 36, i32 0, metadata !0, null}
!16 = metadata !{i32 39, i32 0, metadata !17, null}
!17 = metadata !{i32 589835, metadata !0, i32 37, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!18 = metadata !{i32 42, i32 0, metadata !17, null}
!19 = metadata !{i32 43, i32 0, metadata !17, null}
!20 = metadata !{i32 45, i32 0, metadata !17, null}
!21 = metadata !{i32 47, i32 0, metadata !17, null}
!22 = metadata !{i32 40, i32 0, metadata !17, null}
