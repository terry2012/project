; ModuleID = '__cxa_atexit.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-f128:128:128-n8:16:32"
target triple = "i386-pc-linux-gnu"

%0 = type { i32, void ()* }
%struct.anon = type { void (i8*)*, i8*, i8* }

@AtExit = internal unnamed_addr global [128 x %struct.anon] zeroinitializer, align 32
@NumAtExit = internal unnamed_addr global i32 0
@.str = private unnamed_addr constant [34 x i8] c"FIXME: __cxa_atexit being ignored\00", align 4
@.str1 = private unnamed_addr constant [15 x i8] c"__cxa_atexit.c\00", align 1
@.str2 = private unnamed_addr constant [32 x i8] c"__cxa_atexit: no room in array!\00", align 4
@.str3 = private unnamed_addr constant [5 x i8] c"exec\00", align 1
@llvm.global_dtors = appending unnamed_addr global [1 x %0] [%0 { i32 65535, void ()* @RunAtExit }]

define i32 @__cxa_atexit(void (i8*)* %fn, i8* %arg, i8* nocapture %dso_handle) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{void (i8*)* %fn}, i64 0, metadata !26), !dbg !29
  tail call void @llvm.dbg.value(metadata !{i8* %arg}, i64 0, metadata !27), !dbg !30
  tail call void @llvm.dbg.value(metadata !{i8* %dso_handle}, i64 0, metadata !28), !dbg !31
  tail call void @klee_warning_once(i8* getelementptr inbounds ([34 x i8]* @.str, i32 0, i32 0)) nounwind, !dbg !32
  %0 = load i32* @NumAtExit, align 4, !dbg !34
  %1 = icmp eq i32 %0, 128, !dbg !34
  br i1 %1, label %bb, label %bb1, !dbg !34

bb:                                               ; preds = %entry
  tail call void @klee_report_error(i8* getelementptr inbounds ([15 x i8]* @.str1, i32 0, i32 0), i32 39, i8* getelementptr inbounds ([32 x i8]* @.str2, i32 0, i32 0), i8* getelementptr inbounds ([5 x i8]* @.str3, i32 0, i32 0)) noreturn nounwind, !dbg !35
  unreachable, !dbg !35

bb1:                                              ; preds = %entry
  %2 = getelementptr inbounds [128 x %struct.anon]* @AtExit, i32 0, i32 %0, i32 0, !dbg !36
  store void (i8*)* %fn, void (i8*)** %2, align 4, !dbg !36
  %3 = getelementptr inbounds [128 x %struct.anon]* @AtExit, i32 0, i32 %0, i32 1, !dbg !37
  store i8* %arg, i8** %3, align 4, !dbg !37
  %4 = add i32 %0, 1, !dbg !38
  store i32 %4, i32* @NumAtExit, align 4, !dbg !38
  ret i32 0, !dbg !39
}

define internal void @RunAtExit() nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !40, i64 0, metadata !13), !dbg !41
  %0 = load i32* @NumAtExit, align 4, !dbg !41
  %1 = icmp eq i32 %0, 0, !dbg !41
  br i1 %1, label %return, label %bb, !dbg !41

bb:                                               ; preds = %entry, %bb
  %i.03 = phi i32 [ %tmp, %bb ], [ 0, %entry ]
  %scevgep4 = getelementptr [128 x %struct.anon]* @AtExit, i32 0, i32 %i.03, i32 0
  %scevgep5 = getelementptr [128 x %struct.anon]* @AtExit, i32 0, i32 %i.03, i32 1
  %tmp = add i32 %i.03, 1
  %2 = load void (i8*)** %scevgep4, align 4, !dbg !42
  %3 = load i8** %scevgep5, align 4, !dbg !42
  tail call void %2(i8* %3) nounwind, !dbg !42
  %4 = load i32* @NumAtExit, align 4, !dbg !41
  %5 = icmp ult i32 %tmp, %4, !dbg !41
  br i1 %5, label %bb, label %return, !dbg !41

return:                                           ; preds = %bb, %entry
  ret void, !dbg !43
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

declare void @klee_warning_once(i8*)

declare void @klee_report_error(i8*, i32, i8*, i8*) noreturn

!llvm.dbg.sp = !{!0, !5}
!llvm.dbg.lv.RunAtExit = !{!13}
!llvm.dbg.gv = !{!16, !25}
!llvm.dbg.lv.__cxa_atexit = !{!26, !27, !28}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"RunAtExit", metadata !"RunAtExit", metadata !"", metadata !1, i32 22, metadata !3, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, void ()* @RunAtExit} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"__cxa_atexit.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"__cxa_atexit.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/klee-libc/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{null}
!5 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__cxa_atexit", metadata !"__cxa_atexit", metadata !"__cxa_atexit", metadata !1, i32 31, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (void (i8*)*, i8*, i8*)* @__cxa_atexit} ; [ DW_TAG_subprogram ]
!6 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null} ; [ DW_TAG_subroutine_type ]
!7 = metadata !{metadata !8, metadata !9, metadata !12, metadata !12}
!8 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!9 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !10} ; [ DW_TAG_pointer_type ]
!10 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !11, i32 0, null} ; [ DW_TAG_subroutine_type ]
!11 = metadata !{null, metadata !12}
!12 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!13 = metadata !{i32 590080, metadata !14, metadata !"i", metadata !1, i32 23, metadata !15, i32 0} ; [ DW_TAG_auto_variable ]
!14 = metadata !{i32 589835, metadata !0, i32 22, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!15 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!16 = metadata !{i32 589876, i32 0, metadata !1, metadata !"AtExit", metadata !"AtExit", metadata !"", metadata !1, i32 18, metadata !17, i1 true, i1 true, [128 x %struct.anon]* @AtExit} ; [ DW_TAG_variable ]
!17 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 12288, i64 32, i64 0, i32 0, metadata !18, metadata !23, i32 0, null} ; [ DW_TAG_array_type ]
!18 = metadata !{i32 589843, metadata !1, metadata !"", metadata !1, i32 14, i64 96, i64 32, i64 0, i32 0, null, metadata !19, i32 0, null} ; [ DW_TAG_structure_type ]
!19 = metadata !{metadata !20, metadata !21, metadata !22}
!20 = metadata !{i32 589837, metadata !18, metadata !"fn", metadata !1, i32 15, i64 32, i64 32, i64 0, i32 0, metadata !9} ; [ DW_TAG_member ]
!21 = metadata !{i32 589837, metadata !18, metadata !"arg", metadata !1, i32 16, i64 32, i64 32, i64 32, i32 0, metadata !12} ; [ DW_TAG_member ]
!22 = metadata !{i32 589837, metadata !18, metadata !"dso_handle", metadata !1, i32 17, i64 32, i64 32, i64 64, i32 0, metadata !12} ; [ DW_TAG_member ]
!23 = metadata !{metadata !24}
!24 = metadata !{i32 589857, i64 0, i64 127}      ; [ DW_TAG_subrange_type ]
!25 = metadata !{i32 589876, i32 0, metadata !1, metadata !"NumAtExit", metadata !"NumAtExit", metadata !"", metadata !1, i32 19, metadata !15, i1 true, i1 true, i32* @NumAtExit} ; [ DW_TAG_variable ]
!26 = metadata !{i32 590081, metadata !5, metadata !"fn", metadata !1, i32 29, metadata !9, i32 0} ; [ DW_TAG_arg_variable ]
!27 = metadata !{i32 590081, metadata !5, metadata !"arg", metadata !1, i32 30, metadata !12, i32 0} ; [ DW_TAG_arg_variable ]
!28 = metadata !{i32 590081, metadata !5, metadata !"dso_handle", metadata !1, i32 31, metadata !12, i32 0} ; [ DW_TAG_arg_variable ]
!29 = metadata !{i32 29, i32 0, metadata !5, null}
!30 = metadata !{i32 30, i32 0, metadata !5, null}
!31 = metadata !{i32 31, i32 0, metadata !5, null}
!32 = metadata !{i32 32, i32 0, metadata !33, null}
!33 = metadata !{i32 589835, metadata !5, i32 31, i32 0, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!34 = metadata !{i32 37, i32 0, metadata !33, null}
!35 = metadata !{i32 38, i32 0, metadata !33, null}
!36 = metadata !{i32 43, i32 0, metadata !33, null}
!37 = metadata !{i32 44, i32 0, metadata !33, null}
!38 = metadata !{i32 45, i32 0, metadata !33, null}
!39 = metadata !{i32 47, i32 0, metadata !33, null}
!40 = metadata !{i32 0}
!41 = metadata !{i32 25, i32 0, metadata !14, null}
!42 = metadata !{i32 26, i32 0, metadata !14, null}
!43 = metadata !{i32 27, i32 0, metadata !14, null}
