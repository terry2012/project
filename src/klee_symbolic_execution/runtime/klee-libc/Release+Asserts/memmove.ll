; ModuleID = 'memmove.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-f128:128:128-n8:16:32"
target triple = "i386-pc-linux-gnu"

define i8* @memmove(i8* %dst, i8* %src, i32 %count) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %dst}, i64 0, metadata !9), !dbg !19
  tail call void @llvm.dbg.value(metadata !{i8* %src}, i64 0, metadata !10), !dbg !19
  tail call void @llvm.dbg.value(metadata !{i32 %count}, i64 0, metadata !11), !dbg !19
  tail call void @llvm.dbg.value(metadata !{i8* %dst}, i64 0, metadata !12), !dbg !20
  tail call void @llvm.dbg.value(metadata !{i8* %src}, i64 0, metadata !16), !dbg !21
  %0 = icmp eq i8* %src, %dst, !dbg !22
  br i1 %0, label %bb8, label %bb1, !dbg !22

bb1:                                              ; preds = %entry
  %1 = icmp ugt i8* %src, %dst, !dbg !23
  %2 = icmp eq i32 %count, 0, !dbg !24
  br i1 %1, label %bb3.preheader, label %bb4, !dbg !23

bb3.preheader:                                    ; preds = %bb1
  tail call void @llvm.dbg.value(metadata !25, i64 0, metadata !11), !dbg !24
  br i1 %2, label %bb8, label %bb2, !dbg !24

bb2:                                              ; preds = %bb3.preheader, %bb2
  %indvar19 = phi i32 [ %indvar.next20, %bb2 ], [ 0, %bb3.preheader ]
  %b.016 = getelementptr i8* %src, i32 %indvar19
  %a.015 = getelementptr i8* %dst, i32 %indvar19
  %3 = load i8* %b.016, align 1, !dbg !24
  store i8 %3, i8* %a.015, align 1, !dbg !24
  %indvar.next20 = add i32 %indvar19, 1
  %exitcond21 = icmp eq i32 %indvar.next20, %count
  br i1 %exitcond21, label %bb8, label %bb2, !dbg !24

bb4:                                              ; preds = %bb1
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !12), !dbg !26
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !16), !dbg !27
  tail call void @llvm.dbg.value(metadata !25, i64 0, metadata !11), !dbg !28
  br i1 %2, label %bb8, label %bb5.lr.ph, !dbg !28

bb5.lr.ph:                                        ; preds = %bb4
  %tmp17 = add i32 %count, -1
  br label %bb5

bb5:                                              ; preds = %bb5.lr.ph, %bb5
  %indvar = phi i32 [ 0, %bb5.lr.ph ], [ %indvar.next, %bb5 ]
  %tmp18 = sub i32 %tmp17, %indvar
  %b.112 = getelementptr i8* %src, i32 %tmp18
  %a.111 = getelementptr i8* %dst, i32 %tmp18
  %4 = load i8* %b.112, align 1, !dbg !28
  store i8 %4, i8* %a.111, align 1, !dbg !28
  %indvar.next = add i32 %indvar, 1
  %exitcond = icmp eq i32 %indvar.next, %count
  br i1 %exitcond, label %bb8, label %bb5, !dbg !28

bb8:                                              ; preds = %bb3.preheader, %bb2, %bb4, %bb5, %entry
  ret i8* %dst, !dbg !29
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}
!llvm.dbg.lv.memmove = !{!9, !10, !11, !12, !16}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"memmove", metadata !"memmove", metadata !"memmove", metadata !1, i32 12, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i8*, i32)* @memmove} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"memmove.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"memmove.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !5, metadata !5, metadata !6}
!5 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!6 = metadata !{i32 589846, metadata !7, metadata !"size_t", metadata !7, i32 326, i64 0, i64 0, i64 0, i32 0, metadata !8} ; [ DW_TAG_typedef ]
!7 = metadata !{i32 589865, metadata !"stddef.h", metadata !"/home/gfj/work/llvm-gcc-4.2-2.9-i686-linux/bin/../lib/gcc/i686-pc-linux-gnu/4.2.1/include", metadata !2} ; [ DW_TAG_file_type ]
!8 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!9 = metadata !{i32 590081, metadata !0, metadata !"dst", metadata !1, i32 12, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!10 = metadata !{i32 590081, metadata !0, metadata !"src", metadata !1, i32 12, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!11 = metadata !{i32 590081, metadata !0, metadata !"count", metadata !1, i32 12, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!12 = metadata !{i32 590080, metadata !13, metadata !"a", metadata !1, i32 13, metadata !14, i32 0} ; [ DW_TAG_auto_variable ]
!13 = metadata !{i32 589835, metadata !0, i32 12, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!14 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !15} ; [ DW_TAG_pointer_type ]
!15 = metadata !{i32 589860, metadata !1, metadata !"char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!16 = metadata !{i32 590080, metadata !13, metadata !"b", metadata !1, i32 14, metadata !17, i32 0} ; [ DW_TAG_auto_variable ]
!17 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !18} ; [ DW_TAG_pointer_type ]
!18 = metadata !{i32 589862, metadata !1, metadata !"", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !15} ; [ DW_TAG_const_type ]
!19 = metadata !{i32 12, i32 0, metadata !0, null}
!20 = metadata !{i32 13, i32 0, metadata !13, null}
!21 = metadata !{i32 14, i32 0, metadata !13, null}
!22 = metadata !{i32 16, i32 0, metadata !13, null}
!23 = metadata !{i32 19, i32 0, metadata !13, null}
!24 = metadata !{i32 20, i32 0, metadata !13, null}
!25 = metadata !{null}
!26 = metadata !{i32 22, i32 0, metadata !13, null}
!27 = metadata !{i32 23, i32 0, metadata !13, null}
!28 = metadata !{i32 24, i32 0, metadata !13, null}
!29 = metadata !{i32 17, i32 0, metadata !13, null}
