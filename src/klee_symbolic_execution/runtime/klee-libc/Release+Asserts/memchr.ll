; ModuleID = 'memchr.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-f128:128:128-n8:16:32"
target triple = "i386-pc-linux-gnu"

define i8* @memchr(i8* %s, i32 %c, i32 %n) nounwind readonly {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %s}, i64 0, metadata !10), !dbg !19
  tail call void @llvm.dbg.value(metadata !{i32 %c}, i64 0, metadata !11), !dbg !20
  tail call void @llvm.dbg.value(metadata !{i32 %n}, i64 0, metadata !12), !dbg !21
  %0 = icmp eq i32 %n, 0, !dbg !22
  br i1 %0, label %bb5, label %bb1.preheader, !dbg !22

bb1.preheader:                                    ; preds = %entry
  %tmp7 = add i32 %n, -1
  br label %bb1

bb1:                                              ; preds = %bb1.preheader, %bb3
  %indvar = phi i32 [ 0, %bb1.preheader ], [ %indvar.next, %bb3 ]
  %p.0 = getelementptr i8* %s, i32 %indvar
  %1 = load i8* %p.0, align 1, !dbg !23
  %2 = zext i8 %1 to i32, !dbg !23
  %3 = icmp eq i32 %2, %c, !dbg !23
  br i1 %3, label %bb5, label %bb3, !dbg !23

bb3:                                              ; preds = %bb1
  %4 = icmp eq i32 %tmp7, %indvar, !dbg !24
  %indvar.next = add i32 %indvar, 1
  br i1 %4, label %bb5, label %bb1, !dbg !24

bb5:                                              ; preds = %bb3, %bb1, %entry
  %.0 = phi i8* [ null, %entry ], [ null, %bb3 ], [ %p.0, %bb1 ]
  ret i8* %.0, !dbg !25
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}
!llvm.dbg.lv.memchr = !{!10, !11, !12, !13}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"memchr", metadata !"memchr", metadata !"memchr", metadata !1, i32 44, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i32, i32)* @memchr} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"memchr.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"memchr.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !5, metadata !6, metadata !7}
!5 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!6 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!7 = metadata !{i32 589846, metadata !8, metadata !"size_t", metadata !8, i32 29, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_typedef ]
!8 = metadata !{i32 589865, metadata !"xlocale.h", metadata !"/usr/include", metadata !2} ; [ DW_TAG_file_type ]
!9 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!10 = metadata !{i32 590081, metadata !0, metadata !"s", metadata !1, i32 41, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!11 = metadata !{i32 590081, metadata !0, metadata !"c", metadata !1, i32 42, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!12 = metadata !{i32 590081, metadata !0, metadata !"n", metadata !1, i32 43, metadata !7, i32 0} ; [ DW_TAG_arg_variable ]
!13 = metadata !{i32 590080, metadata !14, metadata !"p", metadata !1, i32 46, metadata !16, i32 0} ; [ DW_TAG_auto_variable ]
!14 = metadata !{i32 589835, metadata !15, i32 44, i32 0, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!15 = metadata !{i32 589835, metadata !0, i32 44, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!16 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !17} ; [ DW_TAG_pointer_type ]
!17 = metadata !{i32 589862, metadata !1, metadata !"", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !18} ; [ DW_TAG_const_type ]
!18 = metadata !{i32 589860, metadata !1, metadata !"unsigned char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 8} ; [ DW_TAG_base_type ]
!19 = metadata !{i32 41, i32 0, metadata !0, null}
!20 = metadata !{i32 42, i32 0, metadata !0, null}
!21 = metadata !{i32 43, i32 0, metadata !0, null}
!22 = metadata !{i32 45, i32 0, metadata !15, null}
!23 = metadata !{i32 49, i32 0, metadata !14, null}
!24 = metadata !{i32 51, i32 0, metadata !14, null}
!25 = metadata !{i32 50, i32 0, metadata !14, null}
