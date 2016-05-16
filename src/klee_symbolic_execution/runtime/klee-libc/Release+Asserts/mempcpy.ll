; ModuleID = 'mempcpy.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-f128:128:128-n8:16:32"
target triple = "i386-pc-linux-gnu"

define i8* @mempcpy(i8* %destaddr, i8* nocapture %srcaddr, i32 %len) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %destaddr}, i64 0, metadata !9), !dbg !19
  tail call void @llvm.dbg.value(metadata !{i8* %srcaddr}, i64 0, metadata !10), !dbg !19
  tail call void @llvm.dbg.value(metadata !{i32 %len}, i64 0, metadata !11), !dbg !19
  tail call void @llvm.dbg.value(metadata !{i8* %destaddr}, i64 0, metadata !12), !dbg !20
  tail call void @llvm.dbg.value(metadata !{i8* %srcaddr}, i64 0, metadata !16), !dbg !21
  tail call void @llvm.dbg.value(metadata !22, i64 0, metadata !11), !dbg !23
  %0 = icmp eq i32 %len, 0, !dbg !23
  br i1 %0, label %bb2, label %bb, !dbg !23

bb:                                               ; preds = %entry, %bb
  %indvar = phi i32 [ %indvar.next, %bb ], [ 0, %entry ]
  %src.06 = getelementptr i8* %srcaddr, i32 %indvar
  %dest.05 = getelementptr i8* %destaddr, i32 %indvar
  %1 = load i8* %src.06, align 1, !dbg !24
  store i8 %1, i8* %dest.05, align 1, !dbg !24
  %indvar.next = add i32 %indvar, 1
  %exitcond = icmp eq i32 %indvar.next, %len
  br i1 %exitcond, label %bb1.bb2_crit_edge, label %bb, !dbg !23

bb1.bb2_crit_edge:                                ; preds = %bb
  %scevgep = getelementptr i8* %destaddr, i32 %len
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !12), !dbg !24
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !16), !dbg !24
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !11), !dbg !23
  br label %bb2

bb2:                                              ; preds = %bb1.bb2_crit_edge, %entry
  %dest.0.lcssa = phi i8* [ %scevgep, %bb1.bb2_crit_edge ], [ %destaddr, %entry ]
  ret i8* %dest.0.lcssa, !dbg !25
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}
!llvm.dbg.lv.mempcpy = !{!9, !10, !11, !12, !16}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"mempcpy", metadata !"mempcpy", metadata !"mempcpy", metadata !1, i32 12, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i8*, i32)* @mempcpy} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"mempcpy.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"mempcpy.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !5, metadata !5, metadata !6}
!5 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!6 = metadata !{i32 589846, metadata !7, metadata !"size_t", metadata !7, i32 326, i64 0, i64 0, i64 0, i32 0, metadata !8} ; [ DW_TAG_typedef ]
!7 = metadata !{i32 589865, metadata !"stddef.h", metadata !"/home/gfj/work/llvm-gcc-4.2-2.9-i686-linux/bin/../lib/gcc/i686-pc-linux-gnu/4.2.1/include", metadata !2} ; [ DW_TAG_file_type ]
!8 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!9 = metadata !{i32 590081, metadata !0, metadata !"destaddr", metadata !1, i32 12, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!10 = metadata !{i32 590081, metadata !0, metadata !"srcaddr", metadata !1, i32 12, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!11 = metadata !{i32 590081, metadata !0, metadata !"len", metadata !1, i32 12, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!12 = metadata !{i32 590080, metadata !13, metadata !"dest", metadata !1, i32 13, metadata !14, i32 0} ; [ DW_TAG_auto_variable ]
!13 = metadata !{i32 589835, metadata !0, i32 12, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!14 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !15} ; [ DW_TAG_pointer_type ]
!15 = metadata !{i32 589860, metadata !1, metadata !"char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!16 = metadata !{i32 590080, metadata !13, metadata !"src", metadata !1, i32 14, metadata !17, i32 0} ; [ DW_TAG_auto_variable ]
!17 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !18} ; [ DW_TAG_pointer_type ]
!18 = metadata !{i32 589862, metadata !1, metadata !"", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !15} ; [ DW_TAG_const_type ]
!19 = metadata !{i32 12, i32 0, metadata !0, null}
!20 = metadata !{i32 13, i32 0, metadata !13, null}
!21 = metadata !{i32 14, i32 0, metadata !13, null}
!22 = metadata !{null}
!23 = metadata !{i32 16, i32 0, metadata !13, null}
!24 = metadata !{i32 17, i32 0, metadata !13, null}
!25 = metadata !{i32 18, i32 0, metadata !13, null}
