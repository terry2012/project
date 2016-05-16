; ModuleID = 'klee_div_zero_check.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-f128:128:128-n8:16:32"
target triple = "i386-pc-linux-gnu"

@.str = private unnamed_addr constant [22 x i8] c"klee_div_zero_check.c\00", align 1
@.str1 = private unnamed_addr constant [15 x i8] c"divide by zero\00", align 1
@.str2 = private unnamed_addr constant [8 x i8] c"div.err\00", align 1

define void @klee_div_zero_check(i64 %z) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i64 %z}, i64 0, metadata !6), !dbg !7
  %0 = icmp eq i64 %z, 0, !dbg !8
  br i1 %0, label %bb, label %return, !dbg !8

bb:                                               ; preds = %entry
  tail call void @klee_report_error(i8* getelementptr inbounds ([22 x i8]* @.str, i32 0, i32 0), i32 14, i8* getelementptr inbounds ([15 x i8]* @.str1, i32 0, i32 0), i8* getelementptr inbounds ([8 x i8]* @.str2, i32 0, i32 0)) noreturn nounwind, !dbg !10
  unreachable, !dbg !10

return:                                           ; preds = %entry
  ret void, !dbg !11
}

declare void @klee_report_error(i8*, i32, i8*, i8*) noreturn

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}
!llvm.dbg.lv.klee_div_zero_check = !{!6}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"klee_div_zero_check", metadata !"klee_div_zero_check", metadata !"klee_div_zero_check", metadata !1, i32 12, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i64)* @klee_div_zero_check} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"klee_div_zero_check.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/Intrinsic/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"klee_div_zero_check.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{null, metadata !5}
!5 = metadata !{i32 589860, metadata !1, metadata !"long long int", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 590081, metadata !0, metadata !"z", metadata !1, i32 12, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!7 = metadata !{i32 12, i32 0, metadata !0, null}
!8 = metadata !{i32 13, i32 0, metadata !9, null}
!9 = metadata !{i32 589835, metadata !0, i32 12, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!10 = metadata !{i32 14, i32 0, metadata !9, null}
!11 = metadata !{i32 15, i32 0, metadata !9, null}
