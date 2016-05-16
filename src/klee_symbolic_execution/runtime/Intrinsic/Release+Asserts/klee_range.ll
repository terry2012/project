; ModuleID = 'klee_range.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-f128:128:128-n8:16:32"
target triple = "i386-pc-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"klee_range.c\00", align 1
@.str1 = private unnamed_addr constant [14 x i8] c"invalid range\00", align 1
@.str2 = private unnamed_addr constant [5 x i8] c"user\00", align 1

define i32 @klee_range(i32 %start, i32 %end, i8* %name) nounwind {
entry:
  %x = alloca i32, align 4
  call void @llvm.dbg.value(metadata !{i32 %start}, i64 0, metadata !9), !dbg !14
  call void @llvm.dbg.value(metadata !{i32 %end}, i64 0, metadata !10), !dbg !14
  call void @llvm.dbg.value(metadata !{i8* %name}, i64 0, metadata !11), !dbg !14
  call void @llvm.dbg.declare(metadata !{i32* %x}, metadata !12), !dbg !15
  %0 = icmp slt i32 %start, %end, !dbg !16
  br i1 %0, label %bb1, label %bb, !dbg !16

bb:                                               ; preds = %entry
  call void @klee_report_error(i8* getelementptr inbounds ([13 x i8]* @.str, i32 0, i32 0), i32 17, i8* getelementptr inbounds ([14 x i8]* @.str1, i32 0, i32 0), i8* getelementptr inbounds ([5 x i8]* @.str2, i32 0, i32 0)) noreturn nounwind, !dbg !17
  unreachable, !dbg !17

bb1:                                              ; preds = %entry
  %1 = add nsw i32 %start, 1, !dbg !18
  %2 = icmp eq i32 %1, %end, !dbg !18
  br i1 %2, label %bb8, label %bb3, !dbg !18

bb3:                                              ; preds = %bb1
  %x4 = bitcast i32* %x to i8*, !dbg !19
  call void @klee_make_symbolic(i8* %x4, i32 4, i8* %name) nounwind, !dbg !19
  %3 = icmp eq i32 %start, 0, !dbg !20
  %4 = load i32* %x, align 4, !dbg !21
  br i1 %3, label %bb5, label %bb6, !dbg !20

bb5:                                              ; preds = %bb3
  %5 = icmp ult i32 %4, %end, !dbg !21
  %6 = zext i1 %5 to i32, !dbg !21
  call void @klee_assume(i32 %6) nounwind, !dbg !21
  br label %bb7, !dbg !21

bb6:                                              ; preds = %bb3
  %7 = icmp sge i32 %4, %start, !dbg !22
  %8 = zext i1 %7 to i32, !dbg !22
  call void @klee_assume(i32 %8) nounwind, !dbg !22
  %9 = load i32* %x, align 4, !dbg !23
  %10 = icmp slt i32 %9, %end, !dbg !23
  %11 = zext i1 %10 to i32, !dbg !23
  call void @klee_assume(i32 %11) nounwind, !dbg !23
  br label %bb7, !dbg !23

bb7:                                              ; preds = %bb6, %bb5
  %12 = load i32* %x, align 4, !dbg !24
  br label %bb8, !dbg !24

bb8:                                              ; preds = %bb1, %bb7
  %.0 = phi i32 [ %12, %bb7 ], [ %start, %bb1 ]
  ret i32 %.0, !dbg !25
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @klee_report_error(i8*, i32, i8*, i8*) noreturn

declare void @klee_make_symbolic(i8*, i32, i8*)

declare void @klee_assume(i32)

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}
!llvm.dbg.lv.klee_range = !{!9, !10, !11, !12}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"klee_range", metadata !"klee_range", metadata !"klee_range", metadata !1, i32 13, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i32, i8*)* @klee_range} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"klee_range.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/Intrinsic/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"klee_range.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !5, metadata !5, metadata !6}
!5 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !7} ; [ DW_TAG_pointer_type ]
!7 = metadata !{i32 589862, metadata !1, metadata !"", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !8} ; [ DW_TAG_const_type ]
!8 = metadata !{i32 589860, metadata !1, metadata !"char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!9 = metadata !{i32 590081, metadata !0, metadata !"start", metadata !1, i32 13, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!10 = metadata !{i32 590081, metadata !0, metadata !"end", metadata !1, i32 13, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!11 = metadata !{i32 590081, metadata !0, metadata !"name", metadata !1, i32 13, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!12 = metadata !{i32 590080, metadata !13, metadata !"x", metadata !1, i32 14, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!13 = metadata !{i32 589835, metadata !0, i32 13, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!14 = metadata !{i32 13, i32 0, metadata !0, null}
!15 = metadata !{i32 14, i32 0, metadata !13, null}
!16 = metadata !{i32 16, i32 0, metadata !13, null}
!17 = metadata !{i32 17, i32 0, metadata !13, null}
!18 = metadata !{i32 19, i32 0, metadata !13, null}
!19 = metadata !{i32 22, i32 0, metadata !13, null}
!20 = metadata !{i32 25, i32 0, metadata !13, null}
!21 = metadata !{i32 26, i32 0, metadata !13, null}
!22 = metadata !{i32 28, i32 0, metadata !13, null}
!23 = metadata !{i32 29, i32 0, metadata !13, null}
!24 = metadata !{i32 32, i32 0, metadata !13, null}
!25 = metadata !{i32 20, i32 0, metadata !13, null}
