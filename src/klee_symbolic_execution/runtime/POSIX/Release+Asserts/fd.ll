; ModuleID = 'fd.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-f128:128:128-n8:16:32"
target triple = "i386-pc-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i32, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i32, i32, [40 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.__fsid_t = type { [2 x i32] }
%struct.dirent64 = type { i64, i64, i16, i8, [256 x i8] }
%struct.exe_disk_file_t = type { i32, i8*, %struct.stat64* }
%struct.exe_file_system_t = type { i32, %struct.exe_disk_file_t*, %struct.exe_disk_file_t*, i32, %struct.exe_disk_file_t*, i32, i32*, i32*, i32*, i32*, i32*, i32*, i32* }
%struct.exe_file_t = type { i32, i32, i64, %struct.exe_disk_file_t* }
%struct.exe_sym_env_t = type { [32 x %struct.exe_file_t], i32, i32, i32 }
%struct.fd_set = type { [32 x i32] }
%struct.stat64 = type { i64, i32, i32, i32, i32, i32, i32, i64, i32, i64, i32, i64, %struct.timespec, %struct.timespec, %struct.timespec, i64 }
%struct.statfs = type { i32, i32, i32, i32, i32, i32, i32, %struct.__fsid_t, i32, i32, i32, [4 x i32] }
%struct.timespec = type { i32, i32 }

@__exe_fs = external unnamed_addr global %struct.exe_file_system_t
@__exe_env = external unnamed_addr global %struct.exe_sym_env_t
@.str = private unnamed_addr constant [18 x i8] c"ignoring (ENOENT)\00", align 1
@.str1 = private unnamed_addr constant [17 x i8] c"ignoring (EPERM)\00", align 1
@.str2 = private unnamed_addr constant [32 x i8] c"symbolic file, ignoring (EPERM)\00", align 4
@.str3 = private unnamed_addr constant [32 x i8] c"symbolic file, ignoring (EBADF)\00", align 4
@n_calls.4789 = internal unnamed_addr global i32 0
@.str4 = private unnamed_addr constant [30 x i8] c"symbolic file, ignoring (EIO)\00", align 1
@.str5 = private unnamed_addr constant [33 x i8] c"symbolic file, ignoring (ENOENT)\00", align 4
@n_calls.5307 = internal unnamed_addr global i32 0
@n_calls.4421 = internal unnamed_addr global i32 0
@.str6 = private unnamed_addr constant [33 x i8] c"symbolic file, ignoring (EINVAL)\00", align 4
@.str7 = private unnamed_addr constant [41 x i8] c"(TCGETS) symbolic file, incomplete model\00", align 4
@.str8 = private unnamed_addr constant [42 x i8] c"(TCSETS) symbolic file, silently ignoring\00", align 4
@.str9 = private unnamed_addr constant [43 x i8] c"(TCSETSW) symbolic file, silently ignoring\00", align 4
@.str10 = private unnamed_addr constant [43 x i8] c"(TCSETSF) symbolic file, silently ignoring\00", align 4
@.str11 = private unnamed_addr constant [45 x i8] c"(TIOCGWINSZ) symbolic file, incomplete model\00", align 4
@.str12 = private unnamed_addr constant [46 x i8] c"(TIOCSWINSZ) symbolic file, ignoring (EINVAL)\00", align 4
@.str13 = private unnamed_addr constant [43 x i8] c"(FIONREAD) symbolic file, incomplete model\00", align 4
@.str14 = private unnamed_addr constant [44 x i8] c"(MTIOCGET) symbolic file, ignoring (EINVAL)\00", align 4
@.str15 = private unnamed_addr constant [18 x i8] c"s != (off64_t) -1\00", align 1
@.str16 = private unnamed_addr constant [5 x i8] c"fd.c\00", align 1
@__PRETTY_FUNCTION__.4826 = internal unnamed_addr constant [14 x i8] c"__fd_getdents\00"
@.str17 = private unnamed_addr constant [18 x i8] c"new_off == f->off\00", align 1
@__PRETTY_FUNCTION__.4570 = internal unnamed_addr constant [11 x i8] c"__fd_lseek\00"
@n_calls.4441 = internal unnamed_addr global i32 0
@.str18 = private unnamed_addr constant [12 x i8] c"f->off >= 0\00", align 1
@__PRETTY_FUNCTION__.4444 = internal unnamed_addr constant [5 x i8] c"read\00"
@n_calls.4696 = internal unnamed_addr global i32 0
@n_calls.4673 = internal unnamed_addr global i32 0
@n_calls.4500 = internal unnamed_addr global i32 0
@.str19 = private unnamed_addr constant [7 x i8] c"r >= 0\00", align 1
@__PRETTY_FUNCTION__.4503 = internal unnamed_addr constant [6 x i8] c"write\00"
@.str20 = private unnamed_addr constant [2 x i8] c"0\00", align 1
@stderr = external unnamed_addr global %struct._IO_FILE*
@.str21 = private unnamed_addr constant [33 x i8] c"WARNING: write() ignores bytes.\0A\00", align 4
@.str22 = private unnamed_addr constant [47 x i8] c"Undefined call to open(): O_EXCL w/o O_RDONLY\0A\00", align 4

define i32 @access(i8* %pathname, i32 %mode) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !345), !dbg !545
  tail call void @llvm.dbg.value(metadata !{i32 %mode}, i64 0, metadata !346), !dbg !545
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !230), !dbg !546
  %0 = load i8* %pathname, align 1, !dbg !548
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !231), !dbg !548
  %1 = icmp eq i8 %0, 0, !dbg !549
  br i1 %1, label %bb1, label %bb.i, !dbg !549

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %pathname, i32 1, !dbg !549
  %3 = load i8* %2, align 1, !dbg !549
  %4 = icmp eq i8 %3, 0, !dbg !549
  br i1 %4, label %bb8.preheader.i, label %bb1, !dbg !549

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 0), align 4, !dbg !550
  %6 = sext i8 %0 to i32, !dbg !551
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %17, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !551
  %8 = add nsw i32 %7, 65, !dbg !551
  %9 = icmp eq i32 %6, %8, !dbg !551
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !551

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 4), align 4, !dbg !552
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !234), !dbg !552
  %11 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, i32 2, !dbg !554
  %12 = load %struct.stat64** %11, align 4, !dbg !554
  %13 = getelementptr inbounds %struct.stat64* %12, i32 0, i32 15, !dbg !554
  %14 = load i64* %13, align 4, !dbg !554
  %15 = icmp eq i64 %14, 0, !dbg !554
  br i1 %15, label %bb1, label %__get_sym_file.exit, !dbg !554

bb7.i:                                            ; preds = %bb3.i
  %16 = add i32 %17, 1, !dbg !550
  br label %bb8.i, !dbg !550

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %17 = phi i32 [ %16, %bb7.i ], [ 0, %bb8.preheader.i ]
  %18 = icmp ugt i32 %5, %17, !dbg !550
  br i1 %18, label %bb3.i, label %bb1, !dbg !550

__get_sym_file.exit:                              ; preds = %bb4.i
  %19 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, !dbg !552
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %19}, i64 0, metadata !347), !dbg !547
  %20 = icmp eq %struct.exe_disk_file_t* %19, null, !dbg !555
  br i1 %20, label %bb1, label %bb4, !dbg !555

bb1:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !312) nounwind, !dbg !556
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !302) nounwind, !dbg !558
  %21 = ptrtoint i8* %pathname to i32, !dbg !560
  %22 = tail call i32 @klee_get_valuel(i32 %21) nounwind, !dbg !560
  %23 = inttoptr i32 %22 to i8*, !dbg !560
  tail call void @llvm.dbg.value(metadata !{i8* %23}, i64 0, metadata !303) nounwind, !dbg !560
  %24 = icmp eq i8* %23, %pathname, !dbg !561
  %25 = zext i1 %24 to i32, !dbg !561
  tail call void @klee_assume(i32 %25) nounwind, !dbg !561
  tail call void @llvm.dbg.value(metadata !{i8* %23}, i64 0, metadata !313) nounwind, !dbg !559
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !315) nounwind, !dbg !563
  br label %bb.i6, !dbg !563

bb.i6:                                            ; preds = %bb6.i8, %bb1
  %sc.0.i = phi i8* [ %23, %bb1 ], [ %sc.1.i, %bb6.i8 ]
  %26 = phi i32 [ 0, %bb1 ], [ %38, %bb6.i8 ]
  %tmp.i = add i32 %26, -1
  %27 = load i8* %sc.0.i, align 1, !dbg !564
  %28 = and i32 %tmp.i, %26, !dbg !565
  %29 = icmp eq i32 %28, 0, !dbg !565
  br i1 %29, label %bb1.i, label %bb5.i, !dbg !565

bb1.i:                                            ; preds = %bb.i6
  switch i8 %27, label %bb6.i8 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i7
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %27}, i64 0, metadata !316) nounwind, !dbg !564
  store i8 0, i8* %sc.0.i, align 1, !dbg !566
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !313) nounwind, !dbg !566
  br label %__concretize_string.exit, !dbg !566

bb4.i7:                                           ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !567
  %30 = getelementptr inbounds i8* %sc.0.i, i32 1, !dbg !567
  br label %bb6.i8, !dbg !567

bb5.i:                                            ; preds = %bb.i6
  %31 = sext i8 %27 to i32, !dbg !568
  %32 = tail call i32 @klee_get_valuel(i32 %31) nounwind, !dbg !568
  %33 = trunc i32 %32 to i8, !dbg !568
  %34 = icmp eq i8 %33, %27, !dbg !569
  %35 = zext i1 %34 to i32, !dbg !569
  tail call void @klee_assume(i32 %35) nounwind, !dbg !569
  store i8 %33, i8* %sc.0.i, align 1, !dbg !570
  %36 = getelementptr inbounds i8* %sc.0.i, i32 1, !dbg !570
  %37 = icmp eq i8 %33, 0, !dbg !571
  br i1 %37, label %__concretize_string.exit, label %bb6.i8, !dbg !571

bb6.i8:                                           ; preds = %bb5.i, %bb4.i7, %bb1.i
  %sc.1.i = phi i8* [ %30, %bb4.i7 ], [ %36, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %38 = add i32 %26, 1, !dbg !563
  br label %bb.i6, !dbg !563

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %39 = tail call i32 (i32, ...)* @syscall(i32 33, i8* %pathname, i32 %mode) nounwind, !dbg !557
  tail call void @llvm.dbg.value(metadata !{i32 %39}, i64 0, metadata !349), !dbg !557
  %40 = icmp eq i32 %39, -1, !dbg !572
  br i1 %40, label %bb2, label %bb4, !dbg !572

bb2:                                              ; preds = %__concretize_string.exit
  %41 = tail call i32* @__errno_location() nounwind readnone, !dbg !573
  %42 = tail call i32 @klee_get_errno() nounwind, !dbg !573
  store i32 %42, i32* %41, align 4, !dbg !573
  br label %bb4, !dbg !573

bb4:                                              ; preds = %__concretize_string.exit, %bb2, %__get_sym_file.exit
  %.0 = phi i32 [ 0, %__get_sym_file.exit ], [ -1, %bb2 ], [ %39, %__concretize_string.exit ]
  ret i32 %.0, !dbg !574
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

define i32 @umask(i32 %mask) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %mask}, i64 0, metadata !240), !dbg !575
  %0 = load i32* getelementptr inbounds (%struct.exe_sym_env_t* @__exe_env, i32 0, i32 1), align 4, !dbg !576
  tail call void @llvm.dbg.value(metadata !{i32 %0}, i64 0, metadata !241), !dbg !576
  %1 = and i32 %mask, 511, !dbg !577
  store i32 %1, i32* getelementptr inbounds (%struct.exe_sym_env_t* @__exe_env, i32 0, i32 1), align 4, !dbg !577
  ret i32 %0, !dbg !578
}

define i32 @chroot(i8* nocapture %path) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !249), !dbg !579
  %0 = load i8* %path, align 1, !dbg !580
  switch i8 %0, label %bb4 [
    i8 0, label %bb
    i8 47, label %bb2
  ]

bb:                                               ; preds = %entry
  %1 = tail call i32* @__errno_location() nounwind readnone, !dbg !582
  store i32 2, i32* %1, align 4, !dbg !582
  br label %bb5, !dbg !583

bb2:                                              ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i32 1, !dbg !584
  %3 = load i8* %2, align 1, !dbg !584
  %4 = icmp eq i8 %3, 0, !dbg !584
  br i1 %4, label %bb5, label %bb4, !dbg !584

bb4:                                              ; preds = %entry, %bb2
  tail call void @klee_warning(i8* getelementptr inbounds ([18 x i8]* @.str, i32 0, i32 0)) nounwind, !dbg !585
  %5 = tail call i32* @__errno_location() nounwind readnone, !dbg !586
  store i32 2, i32* %5, align 4, !dbg !586
  br label %bb5, !dbg !587

bb5:                                              ; preds = %bb2, %bb4, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb4 ], [ 0, %bb2 ]
  ret i32 %.0, !dbg !583
}

declare i32* @__errno_location() nounwind readnone

declare void @klee_warning(i8*)

define i32 @unlink(i8* nocapture %pathname) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !250), !dbg !588
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !230), !dbg !589
  %0 = load i8* %pathname, align 1, !dbg !591
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !231), !dbg !591
  %1 = icmp eq i8 %0, 0, !dbg !592
  br i1 %1, label %bb5, label %bb.i, !dbg !592

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %pathname, i32 1, !dbg !592
  %3 = load i8* %2, align 1, !dbg !592
  %4 = icmp eq i8 %3, 0, !dbg !592
  br i1 %4, label %bb8.preheader.i, label %bb5, !dbg !592

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 0), align 4, !dbg !593
  %6 = sext i8 %0 to i32, !dbg !594
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %17, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !594
  %8 = add nsw i32 %7, 65, !dbg !594
  %9 = icmp eq i32 %6, %8, !dbg !594
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !594

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 4), align 4, !dbg !595
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !234), !dbg !595
  %11 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, i32 2, !dbg !596
  %12 = load %struct.stat64** %11, align 4, !dbg !596
  %13 = getelementptr inbounds %struct.stat64* %12, i32 0, i32 15, !dbg !596
  %14 = load i64* %13, align 4, !dbg !596
  %15 = icmp eq i64 %14, 0, !dbg !596
  br i1 %15, label %bb5, label %__get_sym_file.exit, !dbg !596

bb7.i:                                            ; preds = %bb3.i
  %16 = add i32 %17, 1, !dbg !593
  br label %bb8.i, !dbg !593

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %17 = phi i32 [ %16, %bb7.i ], [ 0, %bb8.preheader.i ]
  %18 = icmp ugt i32 %5, %17, !dbg !593
  br i1 %18, label %bb3.i, label %bb5, !dbg !593

__get_sym_file.exit:                              ; preds = %bb4.i
  %19 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, !dbg !595
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %19}, i64 0, metadata !251), !dbg !590
  %20 = icmp eq %struct.exe_disk_file_t* %19, null, !dbg !597
  br i1 %20, label %bb5, label %bb, !dbg !597

bb:                                               ; preds = %__get_sym_file.exit
  %21 = getelementptr inbounds %struct.stat64* %12, i32 0, i32 3, !dbg !598
  %22 = load i32* %21, align 4, !dbg !598
  %23 = and i32 %22, 61440, !dbg !598
  %24 = icmp eq i32 %23, 32768, !dbg !598
  br i1 %24, label %bb1, label %bb2, !dbg !598

bb1:                                              ; preds = %bb
  store i64 0, i64* %13, align 4, !dbg !599
  br label %bb6, !dbg !600

bb2:                                              ; preds = %bb
  %25 = icmp eq i32 %23, 16384, !dbg !601
  %26 = tail call i32* @__errno_location() nounwind readnone, !dbg !602
  br i1 %25, label %bb3, label %bb4, !dbg !601

bb3:                                              ; preds = %bb2
  store i32 21, i32* %26, align 4, !dbg !602
  br label %bb6, !dbg !603

bb4:                                              ; preds = %bb2
  store i32 1, i32* %26, align 4, !dbg !604
  br label %bb6, !dbg !605

bb5:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @klee_warning(i8* getelementptr inbounds ([17 x i8]* @.str1, i32 0, i32 0)) nounwind, !dbg !606
  %27 = tail call i32* @__errno_location() nounwind readnone, !dbg !607
  store i32 1, i32* %27, align 4, !dbg !607
  br label %bb6, !dbg !608

bb6:                                              ; preds = %bb5, %bb4, %bb3, %bb1
  %.0 = phi i32 [ 0, %bb1 ], [ -1, %bb3 ], [ -1, %bb4 ], [ -1, %bb5 ]
  ret i32 %.0, !dbg !600
}

define i32 @rmdir(i8* nocapture %pathname) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !253), !dbg !609
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !230), !dbg !610
  %0 = load i8* %pathname, align 1, !dbg !612
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !231), !dbg !612
  %1 = icmp eq i8 %0, 0, !dbg !613
  br i1 %1, label %bb3, label %bb.i, !dbg !613

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %pathname, i32 1, !dbg !613
  %3 = load i8* %2, align 1, !dbg !613
  %4 = icmp eq i8 %3, 0, !dbg !613
  br i1 %4, label %bb8.preheader.i, label %bb3, !dbg !613

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 0), align 4, !dbg !614
  %6 = sext i8 %0 to i32, !dbg !615
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %17, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !615
  %8 = add nsw i32 %7, 65, !dbg !615
  %9 = icmp eq i32 %6, %8, !dbg !615
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !615

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 4), align 4, !dbg !616
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !234), !dbg !616
  %11 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, i32 2, !dbg !617
  %12 = load %struct.stat64** %11, align 4, !dbg !617
  %13 = getelementptr inbounds %struct.stat64* %12, i32 0, i32 15, !dbg !617
  %14 = load i64* %13, align 4, !dbg !617
  %15 = icmp eq i64 %14, 0, !dbg !617
  br i1 %15, label %bb3, label %__get_sym_file.exit, !dbg !617

bb7.i:                                            ; preds = %bb3.i
  %16 = add i32 %17, 1, !dbg !614
  br label %bb8.i, !dbg !614

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %17 = phi i32 [ %16, %bb7.i ], [ 0, %bb8.preheader.i ]
  %18 = icmp ugt i32 %5, %17, !dbg !614
  br i1 %18, label %bb3.i, label %bb3, !dbg !614

__get_sym_file.exit:                              ; preds = %bb4.i
  %19 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, !dbg !616
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %19}, i64 0, metadata !254), !dbg !611
  %20 = icmp eq %struct.exe_disk_file_t* %19, null, !dbg !618
  br i1 %20, label %bb3, label %bb, !dbg !618

bb:                                               ; preds = %__get_sym_file.exit
  %21 = getelementptr inbounds %struct.stat64* %12, i32 0, i32 3, !dbg !619
  %22 = load i32* %21, align 4, !dbg !619
  %23 = and i32 %22, 61440, !dbg !619
  %24 = icmp eq i32 %23, 16384, !dbg !619
  br i1 %24, label %bb1, label %bb2, !dbg !619

bb1:                                              ; preds = %bb
  store i64 0, i64* %13, align 4, !dbg !620
  br label %bb4, !dbg !621

bb2:                                              ; preds = %bb
  %25 = tail call i32* @__errno_location() nounwind readnone, !dbg !622
  store i32 20, i32* %25, align 4, !dbg !622
  br label %bb4, !dbg !623

bb3:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @klee_warning(i8* getelementptr inbounds ([17 x i8]* @.str1, i32 0, i32 0)) nounwind, !dbg !624
  %26 = tail call i32* @__errno_location() nounwind readnone, !dbg !625
  store i32 1, i32* %26, align 4, !dbg !625
  br label %bb4, !dbg !626

bb4:                                              ; preds = %bb3, %bb2, %bb1
  %.0 = phi i32 [ 0, %bb1 ], [ -1, %bb2 ], [ -1, %bb3 ]
  ret i32 %.0, !dbg !621
}

define i32 @readlink(i8* %path, i8* %buf, i32 %bufsize) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !259), !dbg !627
  tail call void @llvm.dbg.value(metadata !{i8* %buf}, i64 0, metadata !260), !dbg !627
  tail call void @llvm.dbg.value(metadata !{i32 %bufsize}, i64 0, metadata !261), !dbg !627
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !230), !dbg !628
  %0 = load i8* %path, align 1, !dbg !630
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !231), !dbg !630
  %1 = icmp eq i8 %0, 0, !dbg !631
  br i1 %1, label %bb12, label %bb.i, !dbg !631

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i32 1, !dbg !631
  %3 = load i8* %2, align 1, !dbg !631
  %4 = icmp eq i8 %3, 0, !dbg !631
  br i1 %4, label %bb8.preheader.i, label %bb12, !dbg !631

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 0), align 4, !dbg !632
  %6 = sext i8 %0 to i32, !dbg !633
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %17, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !633
  %8 = add nsw i32 %7, 65, !dbg !633
  %9 = icmp eq i32 %6, %8, !dbg !633
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !633

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 4), align 4, !dbg !634
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !234), !dbg !634
  %11 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, i32 2, !dbg !635
  %12 = load %struct.stat64** %11, align 4, !dbg !635
  %13 = getelementptr inbounds %struct.stat64* %12, i32 0, i32 15, !dbg !635
  %14 = load i64* %13, align 4, !dbg !635
  %15 = icmp eq i64 %14, 0, !dbg !635
  br i1 %15, label %bb12, label %__get_sym_file.exit, !dbg !635

bb7.i:                                            ; preds = %bb3.i
  %16 = add i32 %17, 1, !dbg !632
  br label %bb8.i, !dbg !632

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %17 = phi i32 [ %16, %bb7.i ], [ 0, %bb8.preheader.i ]
  %18 = icmp ugt i32 %5, %17, !dbg !632
  br i1 %18, label %bb3.i, label %bb12, !dbg !632

__get_sym_file.exit:                              ; preds = %bb4.i
  %19 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, !dbg !634
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %19}, i64 0, metadata !262), !dbg !629
  %20 = icmp eq %struct.exe_disk_file_t* %19, null, !dbg !636
  br i1 %20, label %bb12, label %bb, !dbg !636

bb:                                               ; preds = %__get_sym_file.exit
  %21 = getelementptr inbounds %struct.stat64* %12, i32 0, i32 3, !dbg !637
  %22 = load i32* %21, align 4, !dbg !637
  %23 = and i32 %22, 61440, !dbg !637
  %24 = icmp eq i32 %23, 40960, !dbg !637
  br i1 %24, label %bb1, label %bb11, !dbg !637

bb1:                                              ; preds = %bb
  store i8 %0, i8* %buf, align 1, !dbg !638
  %25 = icmp ugt i32 %bufsize, 1, !dbg !639
  br i1 %25, label %bb3, label %bb9, !dbg !639

bb3:                                              ; preds = %bb1
  %26 = getelementptr inbounds i8* %buf, i32 1, !dbg !639
  store i8 46, i8* %26, align 1, !dbg !639
  %27 = icmp ugt i32 %bufsize, 2, !dbg !640
  br i1 %27, label %bb5, label %bb9, !dbg !640

bb5:                                              ; preds = %bb3
  %28 = getelementptr inbounds i8* %buf, i32 2, !dbg !640
  store i8 108, i8* %28, align 1, !dbg !640
  %29 = icmp ugt i32 %bufsize, 3, !dbg !641
  br i1 %29, label %bb7, label %bb9, !dbg !641

bb7:                                              ; preds = %bb5
  %30 = getelementptr inbounds i8* %buf, i32 3, !dbg !641
  store i8 110, i8* %30, align 1, !dbg !641
  %31 = icmp ugt i32 %bufsize, 4, !dbg !642
  br i1 %31, label %bb8, label %bb9, !dbg !642

bb8:                                              ; preds = %bb7
  %32 = getelementptr inbounds i8* %buf, i32 4, !dbg !642
  store i8 107, i8* %32, align 1, !dbg !642
  br label %bb9, !dbg !642

bb9:                                              ; preds = %bb3, %bb1, %bb5, %bb8, %bb7
  %33 = icmp ugt i32 %bufsize, 5, !dbg !643
  %min = select i1 %33, i32 5, i32 %bufsize, !dbg !643
  br label %bb15, !dbg !643

bb11:                                             ; preds = %bb
  %34 = tail call i32* @__errno_location() nounwind readnone, !dbg !644
  store i32 22, i32* %34, align 4, !dbg !644
  br label %bb15, !dbg !645

bb12:                                             ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  %35 = tail call i32 (i32, ...)* @syscall(i32 85, i8* %path, i8* %buf, i32 %bufsize) nounwind, !dbg !646
  tail call void @llvm.dbg.value(metadata !{i32 %35}, i64 0, metadata !264), !dbg !646
  %36 = icmp eq i32 %35, -1, !dbg !647
  br i1 %36, label %bb13, label %bb15, !dbg !647

bb13:                                             ; preds = %bb12
  %37 = tail call i32* @__errno_location() nounwind readnone, !dbg !648
  %38 = tail call i32 @klee_get_errno() nounwind, !dbg !648
  store i32 %38, i32* %37, align 4, !dbg !648
  br label %bb15, !dbg !648

bb15:                                             ; preds = %bb12, %bb13, %bb11, %bb9
  %.0 = phi i32 [ %min, %bb9 ], [ -1, %bb11 ], [ -1, %bb13 ], [ %35, %bb12 ]
  ret i32 %.0, !dbg !643
}

declare i32 @syscall(i32, ...) nounwind

declare i32 @klee_get_errno()

define i32 @fsync(i32 %fd) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !266), !dbg !649
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !236), !dbg !650
  %0 = icmp ult i32 %fd, 32, !dbg !652
  br i1 %0, label %bb.i, label %bb, !dbg !652

bb.i:                                             ; preds = %entry
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !237), !dbg !653
  %1 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 1, !dbg !654
  %2 = load i32* %1, align 4, !dbg !654
  %3 = and i32 %2, 1
  %toBool.i = icmp eq i32 %3, 0, !dbg !654
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !654

__get_file.exit:                                  ; preds = %bb.i
  %4 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, !dbg !653
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %4}, i64 0, metadata !267), !dbg !651
  %5 = icmp eq %struct.exe_file_t* %4, null, !dbg !655
  br i1 %5, label %bb, label %bb1, !dbg !655

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %6 = tail call i32* @__errno_location() nounwind readnone, !dbg !656
  store i32 9, i32* %6, align 4, !dbg !656
  br label %bb6, !dbg !657

bb1:                                              ; preds = %__get_file.exit
  %7 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 3, !dbg !658
  %8 = load %struct.exe_disk_file_t** %7, align 4, !dbg !658
  %9 = icmp eq %struct.exe_disk_file_t* %8, null, !dbg !658
  br i1 %9, label %bb3, label %bb6, !dbg !658

bb3:                                              ; preds = %bb1
  %10 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 0, !dbg !659
  %11 = load i32* %10, align 4, !dbg !659
  %12 = tail call i32 (i32, ...)* @syscall(i32 118, i32 %11) nounwind, !dbg !659
  tail call void @llvm.dbg.value(metadata !{i32 %12}, i64 0, metadata !269), !dbg !659
  %13 = icmp eq i32 %12, -1, !dbg !660
  br i1 %13, label %bb4, label %bb6, !dbg !660

bb4:                                              ; preds = %bb3
  %14 = tail call i32* @__errno_location() nounwind readnone, !dbg !661
  %15 = tail call i32 @klee_get_errno() nounwind, !dbg !661
  store i32 %15, i32* %14, align 4, !dbg !661
  br label %bb6, !dbg !661

bb6:                                              ; preds = %bb3, %bb4, %bb1, %bb
  %.0 = phi i32 [ -1, %bb ], [ 0, %bb1 ], [ -1, %bb4 ], [ %12, %bb3 ]
  ret i32 %.0, !dbg !657
}

define i32 @fstatfs(i32 %fd, %struct.statfs* %buf) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !271), !dbg !662
  tail call void @llvm.dbg.value(metadata !{%struct.statfs* %buf}, i64 0, metadata !272), !dbg !662
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !236), !dbg !663
  %0 = icmp ult i32 %fd, 32, !dbg !665
  br i1 %0, label %bb.i, label %bb, !dbg !665

bb.i:                                             ; preds = %entry
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !237), !dbg !666
  %1 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 1, !dbg !667
  %2 = load i32* %1, align 4, !dbg !667
  %3 = and i32 %2, 1
  %toBool.i = icmp eq i32 %3, 0, !dbg !667
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !667

__get_file.exit:                                  ; preds = %bb.i
  %4 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, !dbg !666
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %4}, i64 0, metadata !273), !dbg !664
  %5 = icmp eq %struct.exe_file_t* %4, null, !dbg !668
  br i1 %5, label %bb, label %bb1, !dbg !668

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %6 = tail call i32* @__errno_location() nounwind readnone, !dbg !669
  store i32 9, i32* %6, align 4, !dbg !669
  br label %bb6, !dbg !670

bb1:                                              ; preds = %__get_file.exit
  %7 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 3, !dbg !671
  %8 = load %struct.exe_disk_file_t** %7, align 4, !dbg !671
  %9 = icmp eq %struct.exe_disk_file_t* %8, null, !dbg !671
  br i1 %9, label %bb3, label %bb2, !dbg !671

bb2:                                              ; preds = %bb1
  tail call void @klee_warning(i8* getelementptr inbounds ([32 x i8]* @.str3, i32 0, i32 0)) nounwind, !dbg !672
  %10 = tail call i32* @__errno_location() nounwind readnone, !dbg !673
  store i32 9, i32* %10, align 4, !dbg !673
  br label %bb6, !dbg !674

bb3:                                              ; preds = %bb1
  %11 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 0, !dbg !675
  %12 = load i32* %11, align 4, !dbg !675
  %13 = tail call i32 (i32, ...)* @syscall(i32 100, i32 %12, %struct.statfs* %buf) nounwind, !dbg !675
  tail call void @llvm.dbg.value(metadata !{i32 %13}, i64 0, metadata !275), !dbg !675
  %14 = icmp eq i32 %13, -1, !dbg !676
  br i1 %14, label %bb4, label %bb6, !dbg !676

bb4:                                              ; preds = %bb3
  %15 = tail call i32* @__errno_location() nounwind readnone, !dbg !677
  %16 = tail call i32 @klee_get_errno() nounwind, !dbg !677
  store i32 %16, i32* %15, align 4, !dbg !677
  br label %bb6, !dbg !677

bb6:                                              ; preds = %bb3, %bb4, %bb2, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb2 ], [ -1, %bb4 ], [ %13, %bb3 ]
  ret i32 %.0, !dbg !670
}

define i32 @__fd_ftruncate(i32 %fd, i64 %length) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !277), !dbg !678
  tail call void @llvm.dbg.value(metadata !{i64 %length}, i64 0, metadata !278), !dbg !678
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !236), !dbg !679
  %0 = icmp ult i32 %fd, 32, !dbg !681
  br i1 %0, label %bb.i, label %__get_file.exit.thread, !dbg !681

bb.i:                                             ; preds = %entry
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !237), !dbg !682
  %1 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 1, !dbg !683
  %2 = load i32* %1, align 4, !dbg !683
  %3 = and i32 %2, 1
  %toBool.i = icmp eq i32 %3, 0, !dbg !683
  br i1 %toBool.i, label %__get_file.exit.thread, label %__get_file.exit, !dbg !683

__get_file.exit.thread:                           ; preds = %bb.i, %entry
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %6}, i64 0, metadata !279), !dbg !680
  %4 = load i32* @n_calls.4789, align 4, !dbg !684
  %5 = add nsw i32 %4, 1, !dbg !684
  store i32 %5, i32* @n_calls.4789, align 4, !dbg !684
  br label %bb

__get_file.exit:                                  ; preds = %bb.i
  %6 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, !dbg !682
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %6}, i64 0, metadata !279), !dbg !680
  %7 = load i32* @n_calls.4789, align 4, !dbg !684
  %8 = add nsw i32 %7, 1, !dbg !684
  store i32 %8, i32* @n_calls.4789, align 4, !dbg !684
  %9 = icmp eq %struct.exe_file_t* %6, null, !dbg !685
  br i1 %9, label %bb, label %bb1, !dbg !685

bb:                                               ; preds = %__get_file.exit.thread, %__get_file.exit
  %10 = tail call i32* @__errno_location() nounwind readnone, !dbg !686
  store i32 9, i32* %10, align 4, !dbg !686
  br label %bb9, !dbg !687

bb1:                                              ; preds = %__get_file.exit
  %11 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 5), align 4, !dbg !688
  %12 = icmp eq i32 %11, 0, !dbg !688
  br i1 %12, label %bb4, label %bb2, !dbg !688

bb2:                                              ; preds = %bb1
  %13 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 9), align 4, !dbg !688
  %14 = load i32* %13, align 4, !dbg !688
  %15 = icmp eq i32 %14, %8, !dbg !688
  br i1 %15, label %bb3, label %bb4, !dbg !688

bb3:                                              ; preds = %bb2
  %16 = add i32 %11, -1, !dbg !689
  store i32 %16, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 5), align 4, !dbg !689
  %17 = tail call i32* @__errno_location() nounwind readnone, !dbg !690
  store i32 5, i32* %17, align 4, !dbg !690
  br label %bb9, !dbg !691

bb4:                                              ; preds = %bb1, %bb2
  %18 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 3, !dbg !692
  %19 = load %struct.exe_disk_file_t** %18, align 4, !dbg !692
  %20 = icmp eq %struct.exe_disk_file_t* %19, null, !dbg !692
  br i1 %20, label %bb6, label %bb5, !dbg !692

bb5:                                              ; preds = %bb4
  tail call void @klee_warning(i8* getelementptr inbounds ([30 x i8]* @.str4, i32 0, i32 0)) nounwind, !dbg !693
  %21 = tail call i32* @__errno_location() nounwind readnone, !dbg !694
  store i32 5, i32* %21, align 4, !dbg !694
  br label %bb9, !dbg !695

bb6:                                              ; preds = %bb4
  %22 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 0, !dbg !696
  %23 = load i32* %22, align 4, !dbg !696
  %24 = tail call i32 (i32, ...)* @syscall(i32 194, i32 %23, i64 %length) nounwind, !dbg !696
  tail call void @llvm.dbg.value(metadata !{i32 %24}, i64 0, metadata !281), !dbg !696
  %25 = icmp eq i32 %24, -1, !dbg !697
  br i1 %25, label %bb7, label %bb9, !dbg !697

bb7:                                              ; preds = %bb6
  %26 = tail call i32* @__errno_location() nounwind readnone, !dbg !698
  %27 = tail call i32 @klee_get_errno() nounwind, !dbg !698
  store i32 %27, i32* %26, align 4, !dbg !698
  br label %bb9, !dbg !698

bb9:                                              ; preds = %bb6, %bb7, %bb5, %bb3, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb3 ], [ -1, %bb5 ], [ -1, %bb7 ], [ %24, %bb6 ]
  ret i32 %.0, !dbg !687
}

define i32 @fchown(i32 %fd, i32 %owner, i32 %group) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !290), !dbg !699
  tail call void @llvm.dbg.value(metadata !{i32 %owner}, i64 0, metadata !291), !dbg !699
  tail call void @llvm.dbg.value(metadata !{i32 %group}, i64 0, metadata !292), !dbg !699
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !236), !dbg !700
  %0 = icmp ult i32 %fd, 32, !dbg !702
  br i1 %0, label %bb.i, label %bb, !dbg !702

bb.i:                                             ; preds = %entry
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !237), !dbg !703
  %1 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 1, !dbg !704
  %2 = load i32* %1, align 4, !dbg !704
  %3 = and i32 %2, 1
  %toBool.i = icmp eq i32 %3, 0, !dbg !704
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !704

__get_file.exit:                                  ; preds = %bb.i
  %4 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, !dbg !703
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %4}, i64 0, metadata !293), !dbg !701
  %5 = icmp eq %struct.exe_file_t* %4, null, !dbg !705
  br i1 %5, label %bb, label %bb1, !dbg !705

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %6 = tail call i32* @__errno_location() nounwind readnone, !dbg !706
  store i32 9, i32* %6, align 4, !dbg !706
  br label %bb6, !dbg !707

bb1:                                              ; preds = %__get_file.exit
  %7 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 3, !dbg !708
  %8 = load %struct.exe_disk_file_t** %7, align 4, !dbg !708
  %9 = icmp eq %struct.exe_disk_file_t* %8, null, !dbg !708
  br i1 %9, label %bb3, label %bb2, !dbg !708

bb2:                                              ; preds = %bb1
  tail call void @llvm.dbg.value(metadata !709, i64 0, metadata !256) nounwind, !dbg !710
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !257) nounwind, !dbg !710
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !258) nounwind, !dbg !710
  tail call void @klee_warning(i8* getelementptr inbounds ([32 x i8]* @.str2, i32 0, i32 0)) nounwind, !dbg !712
  %10 = tail call i32* @__errno_location() nounwind readnone, !dbg !714
  store i32 1, i32* %10, align 4, !dbg !714
  br label %bb6, !dbg !711

bb3:                                              ; preds = %bb1
  %11 = tail call i32 (i32, ...)* @syscall(i32 95, i32 %fd, i32 %owner, i32 %group) nounwind, !dbg !715
  tail call void @llvm.dbg.value(metadata !{i32 %11}, i64 0, metadata !295), !dbg !715
  %12 = icmp eq i32 %11, -1, !dbg !716
  br i1 %12, label %bb4, label %bb6, !dbg !716

bb4:                                              ; preds = %bb3
  %13 = tail call i32* @__errno_location() nounwind readnone, !dbg !717
  %14 = tail call i32 @klee_get_errno() nounwind, !dbg !717
  store i32 %14, i32* %13, align 4, !dbg !717
  br label %bb6, !dbg !717

bb6:                                              ; preds = %bb3, %bb4, %bb2, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb2 ], [ -1, %bb4 ], [ %11, %bb3 ]
  ret i32 %.0, !dbg !707
}

define i32 @fchdir(i32 %fd) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !297), !dbg !718
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !236), !dbg !719
  %0 = icmp ult i32 %fd, 32, !dbg !721
  br i1 %0, label %bb.i, label %bb, !dbg !721

bb.i:                                             ; preds = %entry
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !237), !dbg !722
  %1 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 1, !dbg !723
  %2 = load i32* %1, align 4, !dbg !723
  %3 = and i32 %2, 1
  %toBool.i = icmp eq i32 %3, 0, !dbg !723
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !723

__get_file.exit:                                  ; preds = %bb.i
  %4 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, !dbg !722
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %4}, i64 0, metadata !298), !dbg !720
  %5 = icmp eq %struct.exe_file_t* %4, null, !dbg !724
  br i1 %5, label %bb, label %bb1, !dbg !724

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %6 = tail call i32* @__errno_location() nounwind readnone, !dbg !725
  store i32 9, i32* %6, align 4, !dbg !725
  br label %bb6, !dbg !726

bb1:                                              ; preds = %__get_file.exit
  %7 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 3, !dbg !727
  %8 = load %struct.exe_disk_file_t** %7, align 4, !dbg !727
  %9 = icmp eq %struct.exe_disk_file_t* %8, null, !dbg !727
  br i1 %9, label %bb3, label %bb2, !dbg !727

bb2:                                              ; preds = %bb1
  tail call void @klee_warning(i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0)) nounwind, !dbg !728
  %10 = tail call i32* @__errno_location() nounwind readnone, !dbg !729
  store i32 2, i32* %10, align 4, !dbg !729
  br label %bb6, !dbg !730

bb3:                                              ; preds = %bb1
  %11 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 0, !dbg !731
  %12 = load i32* %11, align 4, !dbg !731
  %13 = tail call i32 (i32, ...)* @syscall(i32 133, i32 %12) nounwind, !dbg !731
  tail call void @llvm.dbg.value(metadata !{i32 %13}, i64 0, metadata !300), !dbg !731
  %14 = icmp eq i32 %13, -1, !dbg !732
  br i1 %14, label %bb4, label %bb6, !dbg !732

bb4:                                              ; preds = %bb3
  %15 = tail call i32* @__errno_location() nounwind readnone, !dbg !733
  %16 = tail call i32 @klee_get_errno() nounwind, !dbg !733
  store i32 %16, i32* %15, align 4, !dbg !733
  br label %bb6, !dbg !733

bb6:                                              ; preds = %bb3, %bb4, %bb2, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb2 ], [ -1, %bb4 ], [ %13, %bb3 ]
  ret i32 %.0, !dbg !726
}

declare i32 @klee_get_valuel(i32)

declare void @klee_assume(i32)

define i8* @getcwd(i8* %buf, i32 %size) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %buf}, i64 0, metadata !308), !dbg !734
  tail call void @llvm.dbg.value(metadata !{i32 %size}, i64 0, metadata !309), !dbg !734
  %0 = load i32* @n_calls.5307, align 4, !dbg !735
  %1 = add nsw i32 %0, 1, !dbg !735
  store i32 %1, i32* @n_calls.5307, align 4, !dbg !735
  %2 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 5), align 4, !dbg !736
  %3 = icmp eq i32 %2, 0, !dbg !736
  br i1 %3, label %bb2, label %bb, !dbg !736

bb:                                               ; preds = %entry
  %4 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 10), align 4, !dbg !736
  %5 = load i32* %4, align 4, !dbg !736
  %6 = icmp eq i32 %5, %1, !dbg !736
  br i1 %6, label %bb1, label %bb2, !dbg !736

bb1:                                              ; preds = %bb
  %7 = add i32 %2, -1, !dbg !737
  store i32 %7, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 5), align 4, !dbg !737
  %8 = tail call i32* @__errno_location() nounwind readnone, !dbg !738
  store i32 34, i32* %8, align 4, !dbg !738
  br label %bb9, !dbg !739

bb2:                                              ; preds = %entry, %bb
  %9 = icmp eq i8* %buf, null, !dbg !740
  br i1 %9, label %bb3, label %bb6, !dbg !740

bb3:                                              ; preds = %bb2
  %10 = icmp eq i32 %size, 0, !dbg !741
  tail call void @llvm.dbg.value(metadata !742, i64 0, metadata !309), !dbg !743
  %size_addr.0 = select i1 %10, i32 1024, i32 %size
  %11 = tail call noalias i8* @malloc(i32 %size_addr.0) nounwind, !dbg !744
  tail call void @llvm.dbg.value(metadata !{i8* %11}, i64 0, metadata !308), !dbg !744
  br label %bb6, !dbg !744

bb6:                                              ; preds = %bb3, %bb2
  %size_addr.1 = phi i32 [ %size_addr.0, %bb3 ], [ %size, %bb2 ]
  %buf_addr.0 = phi i8* [ %11, %bb3 ], [ %buf, %bb2 ]
  tail call void @llvm.dbg.value(metadata !{i8* %buf_addr.0}, i64 0, metadata !302) nounwind, !dbg !745
  %12 = ptrtoint i8* %buf_addr.0 to i32, !dbg !747
  %13 = tail call i32 @klee_get_valuel(i32 %12) nounwind, !dbg !747
  %14 = inttoptr i32 %13 to i8*, !dbg !747
  tail call void @llvm.dbg.value(metadata !{i8* %14}, i64 0, metadata !303) nounwind, !dbg !747
  %15 = icmp eq i8* %14, %buf_addr.0, !dbg !748
  %16 = zext i1 %15 to i32, !dbg !748
  tail call void @klee_assume(i32 %16) nounwind, !dbg !748
  tail call void @llvm.dbg.value(metadata !{i8* %14}, i64 0, metadata !308), !dbg !746
  tail call void @llvm.dbg.value(metadata !{i32 %size_addr.1}, i64 0, metadata !305) nounwind, !dbg !749
  %17 = tail call i32 @klee_get_valuel(i32 %size_addr.1) nounwind, !dbg !751
  tail call void @llvm.dbg.value(metadata !{i32 %17}, i64 0, metadata !306) nounwind, !dbg !751
  %18 = icmp eq i32 %17, %size_addr.1, !dbg !752
  %19 = zext i1 %18 to i32, !dbg !752
  tail call void @klee_assume(i32 %19) nounwind, !dbg !752
  tail call void @llvm.dbg.value(metadata !{i32 %17}, i64 0, metadata !309), !dbg !750
  tail call void @klee_check_memory_access(i8* %14, i32 %17) nounwind, !dbg !753
  %20 = tail call i32 (i32, ...)* @syscall(i32 183, i8* %14, i32 %17) nounwind, !dbg !754
  tail call void @llvm.dbg.value(metadata !{i32 %20}, i64 0, metadata !310), !dbg !754
  %21 = icmp eq i32 %20, -1, !dbg !755
  br i1 %21, label %bb7, label %bb9, !dbg !755

bb7:                                              ; preds = %bb6
  %22 = tail call i32* @__errno_location() nounwind readnone, !dbg !756
  %23 = tail call i32 @klee_get_errno() nounwind, !dbg !756
  store i32 %23, i32* %22, align 4, !dbg !756
  br label %bb9, !dbg !757

bb9:                                              ; preds = %bb6, %bb7, %bb1
  %.0 = phi i8* [ null, %bb1 ], [ null, %bb7 ], [ %14, %bb6 ]
  ret i8* %.0, !dbg !739
}

declare noalias i8* @malloc(i32) nounwind

declare void @klee_check_memory_access(i8*, i32)

define i32 @__fd_statfs(i8* %path, %struct.statfs* %buf) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !320), !dbg !758
  tail call void @llvm.dbg.value(metadata !{%struct.statfs* %buf}, i64 0, metadata !321), !dbg !758
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !230), !dbg !759
  %0 = load i8* %path, align 1, !dbg !761
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !231), !dbg !761
  %1 = icmp eq i8 %0, 0, !dbg !762
  br i1 %1, label %bb1, label %bb.i, !dbg !762

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i32 1, !dbg !762
  %3 = load i8* %2, align 1, !dbg !762
  %4 = icmp eq i8 %3, 0, !dbg !762
  br i1 %4, label %bb8.preheader.i, label %bb1, !dbg !762

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 0), align 4, !dbg !763
  %6 = sext i8 %0 to i32, !dbg !764
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %17, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !764
  %8 = add nsw i32 %7, 65, !dbg !764
  %9 = icmp eq i32 %6, %8, !dbg !764
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !764

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 4), align 4, !dbg !765
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !234), !dbg !765
  %11 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, i32 2, !dbg !766
  %12 = load %struct.stat64** %11, align 4, !dbg !766
  %13 = getelementptr inbounds %struct.stat64* %12, i32 0, i32 15, !dbg !766
  %14 = load i64* %13, align 4, !dbg !766
  %15 = icmp eq i64 %14, 0, !dbg !766
  br i1 %15, label %bb1, label %__get_sym_file.exit, !dbg !766

bb7.i:                                            ; preds = %bb3.i
  %16 = add i32 %17, 1, !dbg !763
  br label %bb8.i, !dbg !763

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %17 = phi i32 [ %16, %bb7.i ], [ 0, %bb8.preheader.i ]
  %18 = icmp ugt i32 %5, %17, !dbg !763
  br i1 %18, label %bb3.i, label %bb1, !dbg !763

__get_sym_file.exit:                              ; preds = %bb4.i
  %19 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, !dbg !765
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %19}, i64 0, metadata !322), !dbg !760
  %20 = icmp eq %struct.exe_disk_file_t* %19, null, !dbg !767
  br i1 %20, label %bb1, label %bb, !dbg !767

bb:                                               ; preds = %__get_sym_file.exit
  tail call void @klee_warning(i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0)) nounwind, !dbg !768
  %21 = tail call i32* @__errno_location() nounwind readnone, !dbg !769
  store i32 2, i32* %21, align 4, !dbg !769
  br label %bb4, !dbg !770

bb1:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !312) nounwind, !dbg !771
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !302) nounwind, !dbg !773
  %22 = ptrtoint i8* %path to i32, !dbg !775
  %23 = tail call i32 @klee_get_valuel(i32 %22) nounwind, !dbg !775
  %24 = inttoptr i32 %23 to i8*, !dbg !775
  tail call void @llvm.dbg.value(metadata !{i8* %24}, i64 0, metadata !303) nounwind, !dbg !775
  %25 = icmp eq i8* %24, %path, !dbg !776
  %26 = zext i1 %25 to i32, !dbg !776
  tail call void @klee_assume(i32 %26) nounwind, !dbg !776
  tail call void @llvm.dbg.value(metadata !{i8* %24}, i64 0, metadata !313) nounwind, !dbg !774
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !315) nounwind, !dbg !777
  br label %bb.i6, !dbg !777

bb.i6:                                            ; preds = %bb6.i8, %bb1
  %sc.0.i = phi i8* [ %24, %bb1 ], [ %sc.1.i, %bb6.i8 ]
  %27 = phi i32 [ 0, %bb1 ], [ %39, %bb6.i8 ]
  %tmp.i = add i32 %27, -1
  %28 = load i8* %sc.0.i, align 1, !dbg !778
  %29 = and i32 %tmp.i, %27, !dbg !779
  %30 = icmp eq i32 %29, 0, !dbg !779
  br i1 %30, label %bb1.i, label %bb5.i, !dbg !779

bb1.i:                                            ; preds = %bb.i6
  switch i8 %28, label %bb6.i8 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i7
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %28}, i64 0, metadata !316) nounwind, !dbg !778
  store i8 0, i8* %sc.0.i, align 1, !dbg !780
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !313) nounwind, !dbg !780
  br label %__concretize_string.exit, !dbg !780

bb4.i7:                                           ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !781
  %31 = getelementptr inbounds i8* %sc.0.i, i32 1, !dbg !781
  br label %bb6.i8, !dbg !781

bb5.i:                                            ; preds = %bb.i6
  %32 = sext i8 %28 to i32, !dbg !782
  %33 = tail call i32 @klee_get_valuel(i32 %32) nounwind, !dbg !782
  %34 = trunc i32 %33 to i8, !dbg !782
  %35 = icmp eq i8 %34, %28, !dbg !783
  %36 = zext i1 %35 to i32, !dbg !783
  tail call void @klee_assume(i32 %36) nounwind, !dbg !783
  store i8 %34, i8* %sc.0.i, align 1, !dbg !784
  %37 = getelementptr inbounds i8* %sc.0.i, i32 1, !dbg !784
  %38 = icmp eq i8 %34, 0, !dbg !785
  br i1 %38, label %__concretize_string.exit, label %bb6.i8, !dbg !785

bb6.i8:                                           ; preds = %bb5.i, %bb4.i7, %bb1.i
  %sc.1.i = phi i8* [ %31, %bb4.i7 ], [ %37, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %39 = add i32 %27, 1, !dbg !777
  br label %bb.i6, !dbg !777

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %40 = tail call i32 (i32, ...)* @syscall(i32 99, i8* %path, %struct.statfs* %buf) nounwind, !dbg !772
  tail call void @llvm.dbg.value(metadata !{i32 %40}, i64 0, metadata !324), !dbg !772
  %41 = icmp eq i32 %40, -1, !dbg !786
  br i1 %41, label %bb2, label %bb4, !dbg !786

bb2:                                              ; preds = %__concretize_string.exit
  %42 = tail call i32* @__errno_location() nounwind readnone, !dbg !787
  %43 = tail call i32 @klee_get_errno() nounwind, !dbg !787
  store i32 %43, i32* %42, align 4, !dbg !787
  br label %bb4, !dbg !787

bb4:                                              ; preds = %__concretize_string.exit, %bb2, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb2 ], [ %40, %__concretize_string.exit ]
  ret i32 %.0, !dbg !770
}

define i32 @lchown(i8* %path, i32 %owner, i32 %group) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !326), !dbg !788
  tail call void @llvm.dbg.value(metadata !{i32 %owner}, i64 0, metadata !327), !dbg !788
  tail call void @llvm.dbg.value(metadata !{i32 %group}, i64 0, metadata !328), !dbg !788
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !230), !dbg !789
  %0 = load i8* %path, align 1, !dbg !791
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !231), !dbg !791
  %1 = icmp eq i8 %0, 0, !dbg !792
  br i1 %1, label %bb1, label %bb.i, !dbg !792

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i32 1, !dbg !792
  %3 = load i8* %2, align 1, !dbg !792
  %4 = icmp eq i8 %3, 0, !dbg !792
  br i1 %4, label %bb8.preheader.i, label %bb1, !dbg !792

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 0), align 4, !dbg !793
  %6 = sext i8 %0 to i32, !dbg !794
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %17, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !794
  %8 = add nsw i32 %7, 65, !dbg !794
  %9 = icmp eq i32 %6, %8, !dbg !794
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !794

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 4), align 4, !dbg !795
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !234), !dbg !795
  %11 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, i32 2, !dbg !796
  %12 = load %struct.stat64** %11, align 4, !dbg !796
  %13 = getelementptr inbounds %struct.stat64* %12, i32 0, i32 15, !dbg !796
  %14 = load i64* %13, align 4, !dbg !796
  %15 = icmp eq i64 %14, 0, !dbg !796
  br i1 %15, label %bb1, label %__get_sym_file.exit, !dbg !796

bb7.i:                                            ; preds = %bb3.i
  %16 = add i32 %17, 1, !dbg !793
  br label %bb8.i, !dbg !793

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %17 = phi i32 [ %16, %bb7.i ], [ 0, %bb8.preheader.i ]
  %18 = icmp ugt i32 %5, %17, !dbg !793
  br i1 %18, label %bb3.i, label %bb1, !dbg !793

__get_sym_file.exit:                              ; preds = %bb4.i
  %19 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, !dbg !795
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %19}, i64 0, metadata !329), !dbg !790
  %20 = icmp eq %struct.exe_disk_file_t* %19, null, !dbg !797
  br i1 %20, label %bb1, label %bb, !dbg !797

bb:                                               ; preds = %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !709, i64 0, metadata !256) nounwind, !dbg !798
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !257) nounwind, !dbg !798
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !258) nounwind, !dbg !798
  tail call void @klee_warning(i8* getelementptr inbounds ([32 x i8]* @.str2, i32 0, i32 0)) nounwind, !dbg !800
  %21 = tail call i32* @__errno_location() nounwind readnone, !dbg !801
  store i32 1, i32* %21, align 4, !dbg !801
  br label %bb4, !dbg !799

bb1:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !312) nounwind, !dbg !802
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !302) nounwind, !dbg !804
  %22 = ptrtoint i8* %path to i32, !dbg !806
  %23 = tail call i32 @klee_get_valuel(i32 %22) nounwind, !dbg !806
  %24 = inttoptr i32 %23 to i8*, !dbg !806
  tail call void @llvm.dbg.value(metadata !{i8* %24}, i64 0, metadata !303) nounwind, !dbg !806
  %25 = icmp eq i8* %24, %path, !dbg !807
  %26 = zext i1 %25 to i32, !dbg !807
  tail call void @klee_assume(i32 %26) nounwind, !dbg !807
  tail call void @llvm.dbg.value(metadata !{i8* %24}, i64 0, metadata !313) nounwind, !dbg !805
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !315) nounwind, !dbg !808
  br label %bb.i6, !dbg !808

bb.i6:                                            ; preds = %bb6.i8, %bb1
  %sc.0.i = phi i8* [ %24, %bb1 ], [ %sc.1.i, %bb6.i8 ]
  %27 = phi i32 [ 0, %bb1 ], [ %39, %bb6.i8 ]
  %tmp.i = add i32 %27, -1
  %28 = load i8* %sc.0.i, align 1, !dbg !809
  %29 = and i32 %tmp.i, %27, !dbg !810
  %30 = icmp eq i32 %29, 0, !dbg !810
  br i1 %30, label %bb1.i, label %bb5.i, !dbg !810

bb1.i:                                            ; preds = %bb.i6
  switch i8 %28, label %bb6.i8 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i7
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %28}, i64 0, metadata !316) nounwind, !dbg !809
  store i8 0, i8* %sc.0.i, align 1, !dbg !811
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !313) nounwind, !dbg !811
  br label %__concretize_string.exit, !dbg !811

bb4.i7:                                           ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !812
  %31 = getelementptr inbounds i8* %sc.0.i, i32 1, !dbg !812
  br label %bb6.i8, !dbg !812

bb5.i:                                            ; preds = %bb.i6
  %32 = sext i8 %28 to i32, !dbg !813
  %33 = tail call i32 @klee_get_valuel(i32 %32) nounwind, !dbg !813
  %34 = trunc i32 %33 to i8, !dbg !813
  %35 = icmp eq i8 %34, %28, !dbg !814
  %36 = zext i1 %35 to i32, !dbg !814
  tail call void @klee_assume(i32 %36) nounwind, !dbg !814
  store i8 %34, i8* %sc.0.i, align 1, !dbg !815
  %37 = getelementptr inbounds i8* %sc.0.i, i32 1, !dbg !815
  %38 = icmp eq i8 %34, 0, !dbg !816
  br i1 %38, label %__concretize_string.exit, label %bb6.i8, !dbg !816

bb6.i8:                                           ; preds = %bb5.i, %bb4.i7, %bb1.i
  %sc.1.i = phi i8* [ %31, %bb4.i7 ], [ %37, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %39 = add i32 %27, 1, !dbg !808
  br label %bb.i6, !dbg !808

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %40 = tail call i32 (i32, ...)* @syscall(i32 182, i8* %path, i32 %owner, i32 %group) nounwind, !dbg !803
  tail call void @llvm.dbg.value(metadata !{i32 %40}, i64 0, metadata !331), !dbg !803
  %41 = icmp eq i32 %40, -1, !dbg !817
  br i1 %41, label %bb2, label %bb4, !dbg !817

bb2:                                              ; preds = %__concretize_string.exit
  %42 = tail call i32* @__errno_location() nounwind readnone, !dbg !818
  %43 = tail call i32 @klee_get_errno() nounwind, !dbg !818
  store i32 %43, i32* %42, align 4, !dbg !818
  br label %bb4, !dbg !818

bb4:                                              ; preds = %__concretize_string.exit, %bb2, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb2 ], [ %40, %__concretize_string.exit ]
  ret i32 %.0, !dbg !799
}

define i32 @chown(i8* %path, i32 %owner, i32 %group) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !333), !dbg !819
  tail call void @llvm.dbg.value(metadata !{i32 %owner}, i64 0, metadata !334), !dbg !819
  tail call void @llvm.dbg.value(metadata !{i32 %group}, i64 0, metadata !335), !dbg !819
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !230), !dbg !820
  %0 = load i8* %path, align 1, !dbg !822
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !231), !dbg !822
  %1 = icmp eq i8 %0, 0, !dbg !823
  br i1 %1, label %bb1, label %bb.i, !dbg !823

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i32 1, !dbg !823
  %3 = load i8* %2, align 1, !dbg !823
  %4 = icmp eq i8 %3, 0, !dbg !823
  br i1 %4, label %bb8.preheader.i, label %bb1, !dbg !823

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 0), align 4, !dbg !824
  %6 = sext i8 %0 to i32, !dbg !825
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %17, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !825
  %8 = add nsw i32 %7, 65, !dbg !825
  %9 = icmp eq i32 %6, %8, !dbg !825
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !825

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 4), align 4, !dbg !826
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !234), !dbg !826
  %11 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, i32 2, !dbg !827
  %12 = load %struct.stat64** %11, align 4, !dbg !827
  %13 = getelementptr inbounds %struct.stat64* %12, i32 0, i32 15, !dbg !827
  %14 = load i64* %13, align 4, !dbg !827
  %15 = icmp eq i64 %14, 0, !dbg !827
  br i1 %15, label %bb1, label %__get_sym_file.exit, !dbg !827

bb7.i:                                            ; preds = %bb3.i
  %16 = add i32 %17, 1, !dbg !824
  br label %bb8.i, !dbg !824

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %17 = phi i32 [ %16, %bb7.i ], [ 0, %bb8.preheader.i ]
  %18 = icmp ugt i32 %5, %17, !dbg !824
  br i1 %18, label %bb3.i, label %bb1, !dbg !824

__get_sym_file.exit:                              ; preds = %bb4.i
  %19 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, !dbg !826
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %19}, i64 0, metadata !336), !dbg !821
  %20 = icmp eq %struct.exe_disk_file_t* %19, null, !dbg !828
  br i1 %20, label %bb1, label %bb, !dbg !828

bb:                                               ; preds = %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !709, i64 0, metadata !256) nounwind, !dbg !829
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !257) nounwind, !dbg !829
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !258) nounwind, !dbg !829
  tail call void @klee_warning(i8* getelementptr inbounds ([32 x i8]* @.str2, i32 0, i32 0)) nounwind, !dbg !831
  %21 = tail call i32* @__errno_location() nounwind readnone, !dbg !832
  store i32 1, i32* %21, align 4, !dbg !832
  br label %bb4, !dbg !830

bb1:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !312) nounwind, !dbg !833
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !302) nounwind, !dbg !835
  %22 = ptrtoint i8* %path to i32, !dbg !837
  %23 = tail call i32 @klee_get_valuel(i32 %22) nounwind, !dbg !837
  %24 = inttoptr i32 %23 to i8*, !dbg !837
  tail call void @llvm.dbg.value(metadata !{i8* %24}, i64 0, metadata !303) nounwind, !dbg !837
  %25 = icmp eq i8* %24, %path, !dbg !838
  %26 = zext i1 %25 to i32, !dbg !838
  tail call void @klee_assume(i32 %26) nounwind, !dbg !838
  tail call void @llvm.dbg.value(metadata !{i8* %24}, i64 0, metadata !313) nounwind, !dbg !836
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !315) nounwind, !dbg !839
  br label %bb.i6, !dbg !839

bb.i6:                                            ; preds = %bb6.i8, %bb1
  %sc.0.i = phi i8* [ %24, %bb1 ], [ %sc.1.i, %bb6.i8 ]
  %27 = phi i32 [ 0, %bb1 ], [ %39, %bb6.i8 ]
  %tmp.i = add i32 %27, -1
  %28 = load i8* %sc.0.i, align 1, !dbg !840
  %29 = and i32 %tmp.i, %27, !dbg !841
  %30 = icmp eq i32 %29, 0, !dbg !841
  br i1 %30, label %bb1.i, label %bb5.i, !dbg !841

bb1.i:                                            ; preds = %bb.i6
  switch i8 %28, label %bb6.i8 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i7
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %28}, i64 0, metadata !316) nounwind, !dbg !840
  store i8 0, i8* %sc.0.i, align 1, !dbg !842
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !313) nounwind, !dbg !842
  br label %__concretize_string.exit, !dbg !842

bb4.i7:                                           ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !843
  %31 = getelementptr inbounds i8* %sc.0.i, i32 1, !dbg !843
  br label %bb6.i8, !dbg !843

bb5.i:                                            ; preds = %bb.i6
  %32 = sext i8 %28 to i32, !dbg !844
  %33 = tail call i32 @klee_get_valuel(i32 %32) nounwind, !dbg !844
  %34 = trunc i32 %33 to i8, !dbg !844
  %35 = icmp eq i8 %34, %28, !dbg !845
  %36 = zext i1 %35 to i32, !dbg !845
  tail call void @klee_assume(i32 %36) nounwind, !dbg !845
  store i8 %34, i8* %sc.0.i, align 1, !dbg !846
  %37 = getelementptr inbounds i8* %sc.0.i, i32 1, !dbg !846
  %38 = icmp eq i8 %34, 0, !dbg !847
  br i1 %38, label %__concretize_string.exit, label %bb6.i8, !dbg !847

bb6.i8:                                           ; preds = %bb5.i, %bb4.i7, %bb1.i
  %sc.1.i = phi i8* [ %31, %bb4.i7 ], [ %37, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %39 = add i32 %27, 1, !dbg !839
  br label %bb.i6, !dbg !839

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %40 = tail call i32 (i32, ...)* @syscall(i32 182, i8* %path, i32 %owner, i32 %group) nounwind, !dbg !834
  tail call void @llvm.dbg.value(metadata !{i32 %40}, i64 0, metadata !338), !dbg !834
  %41 = icmp eq i32 %40, -1, !dbg !848
  br i1 %41, label %bb2, label %bb4, !dbg !848

bb2:                                              ; preds = %__concretize_string.exit
  %42 = tail call i32* @__errno_location() nounwind readnone, !dbg !849
  %43 = tail call i32 @klee_get_errno() nounwind, !dbg !849
  store i32 %43, i32* %42, align 4, !dbg !849
  br label %bb4, !dbg !849

bb4:                                              ; preds = %__concretize_string.exit, %bb2, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb2 ], [ %40, %__concretize_string.exit ]
  ret i32 %.0, !dbg !830
}

define i32 @chdir(i8* %path) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !340), !dbg !850
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !230), !dbg !851
  %0 = load i8* %path, align 1, !dbg !853
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !231), !dbg !853
  %1 = icmp eq i8 %0, 0, !dbg !854
  br i1 %1, label %bb1, label %bb.i, !dbg !854

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i32 1, !dbg !854
  %3 = load i8* %2, align 1, !dbg !854
  %4 = icmp eq i8 %3, 0, !dbg !854
  br i1 %4, label %bb8.preheader.i, label %bb1, !dbg !854

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 0), align 4, !dbg !855
  %6 = sext i8 %0 to i32, !dbg !856
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %17, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !856
  %8 = add nsw i32 %7, 65, !dbg !856
  %9 = icmp eq i32 %6, %8, !dbg !856
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !856

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 4), align 4, !dbg !857
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !234), !dbg !857
  %11 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, i32 2, !dbg !858
  %12 = load %struct.stat64** %11, align 4, !dbg !858
  %13 = getelementptr inbounds %struct.stat64* %12, i32 0, i32 15, !dbg !858
  %14 = load i64* %13, align 4, !dbg !858
  %15 = icmp eq i64 %14, 0, !dbg !858
  br i1 %15, label %bb1, label %__get_sym_file.exit, !dbg !858

bb7.i:                                            ; preds = %bb3.i
  %16 = add i32 %17, 1, !dbg !855
  br label %bb8.i, !dbg !855

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %17 = phi i32 [ %16, %bb7.i ], [ 0, %bb8.preheader.i ]
  %18 = icmp ugt i32 %5, %17, !dbg !855
  br i1 %18, label %bb3.i, label %bb1, !dbg !855

__get_sym_file.exit:                              ; preds = %bb4.i
  %19 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, !dbg !857
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %19}, i64 0, metadata !341), !dbg !852
  %20 = icmp eq %struct.exe_disk_file_t* %19, null, !dbg !859
  br i1 %20, label %bb1, label %bb, !dbg !859

bb:                                               ; preds = %__get_sym_file.exit
  tail call void @klee_warning(i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0)) nounwind, !dbg !860
  %21 = tail call i32* @__errno_location() nounwind readnone, !dbg !861
  store i32 2, i32* %21, align 4, !dbg !861
  br label %bb4, !dbg !862

bb1:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !312) nounwind, !dbg !863
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !302) nounwind, !dbg !865
  %22 = ptrtoint i8* %path to i32, !dbg !867
  %23 = tail call i32 @klee_get_valuel(i32 %22) nounwind, !dbg !867
  %24 = inttoptr i32 %23 to i8*, !dbg !867
  tail call void @llvm.dbg.value(metadata !{i8* %24}, i64 0, metadata !303) nounwind, !dbg !867
  %25 = icmp eq i8* %24, %path, !dbg !868
  %26 = zext i1 %25 to i32, !dbg !868
  tail call void @klee_assume(i32 %26) nounwind, !dbg !868
  tail call void @llvm.dbg.value(metadata !{i8* %24}, i64 0, metadata !313) nounwind, !dbg !866
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !315) nounwind, !dbg !869
  br label %bb.i6, !dbg !869

bb.i6:                                            ; preds = %bb6.i8, %bb1
  %sc.0.i = phi i8* [ %24, %bb1 ], [ %sc.1.i, %bb6.i8 ]
  %27 = phi i32 [ 0, %bb1 ], [ %39, %bb6.i8 ]
  %tmp.i = add i32 %27, -1
  %28 = load i8* %sc.0.i, align 1, !dbg !870
  %29 = and i32 %tmp.i, %27, !dbg !871
  %30 = icmp eq i32 %29, 0, !dbg !871
  br i1 %30, label %bb1.i, label %bb5.i, !dbg !871

bb1.i:                                            ; preds = %bb.i6
  switch i8 %28, label %bb6.i8 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i7
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %28}, i64 0, metadata !316) nounwind, !dbg !870
  store i8 0, i8* %sc.0.i, align 1, !dbg !872
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !313) nounwind, !dbg !872
  br label %__concretize_string.exit, !dbg !872

bb4.i7:                                           ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !873
  %31 = getelementptr inbounds i8* %sc.0.i, i32 1, !dbg !873
  br label %bb6.i8, !dbg !873

bb5.i:                                            ; preds = %bb.i6
  %32 = sext i8 %28 to i32, !dbg !874
  %33 = tail call i32 @klee_get_valuel(i32 %32) nounwind, !dbg !874
  %34 = trunc i32 %33 to i8, !dbg !874
  %35 = icmp eq i8 %34, %28, !dbg !875
  %36 = zext i1 %35 to i32, !dbg !875
  tail call void @klee_assume(i32 %36) nounwind, !dbg !875
  store i8 %34, i8* %sc.0.i, align 1, !dbg !876
  %37 = getelementptr inbounds i8* %sc.0.i, i32 1, !dbg !876
  %38 = icmp eq i8 %34, 0, !dbg !877
  br i1 %38, label %__concretize_string.exit, label %bb6.i8, !dbg !877

bb6.i8:                                           ; preds = %bb5.i, %bb4.i7, %bb1.i
  %sc.1.i = phi i8* [ %31, %bb4.i7 ], [ %37, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %39 = add i32 %27, 1, !dbg !869
  br label %bb.i6, !dbg !869

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %40 = tail call i32 (i32, ...)* @syscall(i32 12, i8* %path) nounwind, !dbg !864
  tail call void @llvm.dbg.value(metadata !{i32 %40}, i64 0, metadata !343), !dbg !864
  %41 = icmp eq i32 %40, -1, !dbg !878
  br i1 %41, label %bb2, label %bb4, !dbg !878

bb2:                                              ; preds = %__concretize_string.exit
  %42 = tail call i32* @__errno_location() nounwind readnone, !dbg !879
  %43 = tail call i32 @klee_get_errno() nounwind, !dbg !879
  store i32 %43, i32* %42, align 4, !dbg !879
  br label %bb4, !dbg !879

bb4:                                              ; preds = %__concretize_string.exit, %bb2, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb2 ], [ %40, %__concretize_string.exit ]
  ret i32 %.0, !dbg !862
}

define i32 @select(i32 %nfds, %struct.fd_set* %read, %struct.fd_set* %write, %struct.fd_set* %except, %struct.timespec* nocapture %timeout) nounwind {
entry:
  %in_read = alloca %struct.fd_set, align 8
  %in_write = alloca %struct.fd_set, align 8
  %in_except = alloca %struct.fd_set, align 8
  %os_read = alloca %struct.fd_set, align 8
  %os_write = alloca %struct.fd_set, align 8
  %os_except = alloca %struct.fd_set, align 8
  %tv = alloca %struct.timespec, align 8
  call void @llvm.dbg.value(metadata !{i32 %nfds}, i64 0, metadata !351), !dbg !880
  call void @llvm.dbg.value(metadata !{%struct.fd_set* %read}, i64 0, metadata !352), !dbg !880
  call void @llvm.dbg.value(metadata !{%struct.fd_set* %write}, i64 0, metadata !353), !dbg !880
  call void @llvm.dbg.value(metadata !{%struct.fd_set* %except}, i64 0, metadata !354), !dbg !881
  call void @llvm.dbg.value(metadata !{%struct.timespec* %timeout}, i64 0, metadata !355), !dbg !881
  call void @llvm.dbg.declare(metadata !{%struct.fd_set* %in_read}, metadata !356), !dbg !882
  call void @llvm.dbg.declare(metadata !{%struct.fd_set* %in_write}, metadata !358), !dbg !882
  call void @llvm.dbg.declare(metadata !{%struct.fd_set* %in_except}, metadata !359), !dbg !882
  call void @llvm.dbg.declare(metadata !{%struct.fd_set* %os_read}, metadata !360), !dbg !882
  call void @llvm.dbg.declare(metadata !{%struct.fd_set* %os_write}, metadata !361), !dbg !882
  call void @llvm.dbg.declare(metadata !{%struct.fd_set* %os_except}, metadata !362), !dbg !882
  call void @llvm.dbg.value(metadata !562, i64 0, metadata !364), !dbg !883
  call void @llvm.dbg.value(metadata !562, i64 0, metadata !365), !dbg !883
  %0 = icmp eq %struct.fd_set* %read, null, !dbg !884
  %in_read3 = bitcast %struct.fd_set* %in_read to i8*, !dbg !885
  br i1 %0, label %bb2, label %bb, !dbg !884

bb:                                               ; preds = %entry
  %1 = bitcast %struct.fd_set* %read to i8*, !dbg !886
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %in_read3, i8* %1, i32 128, i32 4, i1 false), !dbg !886
  call void @llvm.memset.p0i8.i32(i8* %1, i8 0, i32 128, i32 4, i1 false), !dbg !887
  br label %bb4, !dbg !887

bb2:                                              ; preds = %entry
  call void @llvm.memset.p0i8.i32(i8* %in_read3, i8 0, i32 128, i32 8, i1 false), !dbg !885
  br label %bb4, !dbg !885

bb4:                                              ; preds = %bb2, %bb
  %2 = icmp eq %struct.fd_set* %write, null, !dbg !888
  %in_write8 = bitcast %struct.fd_set* %in_write to i8*, !dbg !889
  br i1 %2, label %bb7, label %bb5, !dbg !888

bb5:                                              ; preds = %bb4
  %3 = bitcast %struct.fd_set* %write to i8*, !dbg !890
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %in_write8, i8* %3, i32 128, i32 4, i1 false), !dbg !890
  call void @llvm.memset.p0i8.i32(i8* %3, i8 0, i32 128, i32 4, i1 false), !dbg !891
  br label %bb9, !dbg !891

bb7:                                              ; preds = %bb4
  call void @llvm.memset.p0i8.i32(i8* %in_write8, i8 0, i32 128, i32 8, i1 false), !dbg !889
  br label %bb9, !dbg !889

bb9:                                              ; preds = %bb7, %bb5
  %4 = icmp eq %struct.fd_set* %except, null, !dbg !892
  %in_except13 = bitcast %struct.fd_set* %in_except to i8*, !dbg !893
  br i1 %4, label %bb12, label %bb10, !dbg !892

bb10:                                             ; preds = %bb9
  %5 = bitcast %struct.fd_set* %except to i8*, !dbg !894
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %in_except13, i8* %5, i32 128, i32 4, i1 false), !dbg !894
  call void @llvm.memset.p0i8.i32(i8* %5, i8 0, i32 128, i32 4, i1 false), !dbg !895
  br label %bb14, !dbg !895

bb12:                                             ; preds = %bb9
  call void @llvm.memset.p0i8.i32(i8* %in_except13, i8 0, i32 128, i32 8, i1 false), !dbg !893
  br label %bb14, !dbg !893

bb14:                                             ; preds = %bb12, %bb10
  %os_read15 = bitcast %struct.fd_set* %os_read to i8*, !dbg !896
  call void @llvm.memset.p0i8.i32(i8* %os_read15, i8 0, i32 128, i32 8, i1 false), !dbg !896
  %os_write16 = bitcast %struct.fd_set* %os_write to i8*, !dbg !897
  call void @llvm.memset.p0i8.i32(i8* %os_write16, i8 0, i32 128, i32 8, i1 false), !dbg !897
  %os_except17 = bitcast %struct.fd_set* %os_except to i8*, !dbg !898
  call void @llvm.memset.p0i8.i32(i8* %os_except17, i8 0, i32 128, i32 8, i1 false), !dbg !898
  call void @llvm.dbg.value(metadata !562, i64 0, metadata !363), !dbg !899
  br label %bb40, !dbg !899

bb18:                                             ; preds = %bb40
  %6 = sdiv i32 %78, 32, !dbg !900
  %7 = getelementptr inbounds %struct.fd_set* %in_read, i32 0, i32 0, i32 %6, !dbg !900
  %8 = load i32* %7, align 4, !dbg !900
  %9 = and i32 %78, 31
  %10 = shl i32 1, %9, !dbg !900
  %11 = and i32 %8, %10, !dbg !900
  %12 = icmp eq i32 %11, 0, !dbg !900
  br i1 %12, label %bb19, label %bb21, !dbg !900

bb19:                                             ; preds = %bb18
  %13 = getelementptr inbounds %struct.fd_set* %in_write, i32 0, i32 0, i32 %6, !dbg !900
  %14 = load i32* %13, align 4, !dbg !900
  %15 = and i32 %14, %10, !dbg !900
  %16 = icmp eq i32 %15, 0, !dbg !900
  br i1 %16, label %bb20, label %bb21, !dbg !900

bb20:                                             ; preds = %bb19
  %17 = getelementptr inbounds %struct.fd_set* %in_except, i32 0, i32 0, i32 %6, !dbg !900
  %18 = load i32* %17, align 4, !dbg !900
  %19 = and i32 %18, %10, !dbg !900
  %20 = icmp eq i32 %19, 0, !dbg !900
  br i1 %20, label %bb39, label %bb21, !dbg !900

bb21:                                             ; preds = %bb20, %bb19, %bb18
  %21 = icmp ult i32 %78, 32, !dbg !901
  br i1 %21, label %bb.i, label %bb22, !dbg !901

bb.i:                                             ; preds = %bb21
  %22 = load i32* %scevgep79, align 4, !dbg !903
  %23 = and i32 %22, 1
  %toBool.i = icmp eq i32 %23, 0, !dbg !903
  %24 = icmp eq %struct.exe_file_t* %scevgep76, null, !dbg !904
  %or.cond = or i1 %toBool.i, %24
  br i1 %or.cond, label %bb22, label %bb23, !dbg !903

bb22:                                             ; preds = %bb21, %bb.i
  tail call void @llvm.dbg.value(metadata !{i32 %78}, i64 0, metadata !236), !dbg !905
  %25 = call i32* @__errno_location() nounwind readnone, !dbg !906
  store i32 9, i32* %25, align 4, !dbg !906
  br label %bb61, !dbg !907

bb23:                                             ; preds = %bb.i
  %26 = load %struct.exe_disk_file_t** %scevgep78, align 4, !dbg !908
  %27 = icmp eq %struct.exe_disk_file_t* %26, null, !dbg !908
  %28 = icmp ne i32 %11, 0, !dbg !909
  br i1 %27, label %bb31, label %bb24, !dbg !908

bb24:                                             ; preds = %bb23
  br i1 %28, label %bb25, label %bb26, !dbg !909

bb25:                                             ; preds = %bb24
  %29 = getelementptr inbounds %struct.fd_set* %read, i32 0, i32 0, i32 %6, !dbg !909
  %30 = load i32* %29, align 4, !dbg !909
  %31 = or i32 %30, %10, !dbg !909
  store i32 %31, i32* %29, align 4, !dbg !909
  br label %bb26, !dbg !909

bb26:                                             ; preds = %bb24, %bb25
  %32 = getelementptr inbounds %struct.fd_set* %in_write, i32 0, i32 0, i32 %6, !dbg !910
  %33 = load i32* %32, align 4, !dbg !910
  %34 = and i32 %33, %10, !dbg !910
  %35 = icmp eq i32 %34, 0, !dbg !910
  br i1 %35, label %bb28, label %bb27, !dbg !910

bb27:                                             ; preds = %bb26
  %36 = getelementptr inbounds %struct.fd_set* %write, i32 0, i32 0, i32 %6, !dbg !910
  %37 = load i32* %36, align 4, !dbg !910
  %38 = or i32 %37, %10, !dbg !910
  store i32 %38, i32* %36, align 4, !dbg !910
  br label %bb28, !dbg !910

bb28:                                             ; preds = %bb26, %bb27
  %39 = getelementptr inbounds %struct.fd_set* %in_except, i32 0, i32 0, i32 %6, !dbg !911
  %40 = load i32* %39, align 4, !dbg !911
  %41 = and i32 %40, %10, !dbg !911
  %42 = icmp eq i32 %41, 0, !dbg !911
  br i1 %42, label %bb30, label %bb29, !dbg !911

bb29:                                             ; preds = %bb28
  %43 = getelementptr inbounds %struct.fd_set* %except, i32 0, i32 0, i32 %6, !dbg !911
  %44 = load i32* %43, align 4, !dbg !911
  %45 = or i32 %44, %10, !dbg !911
  store i32 %45, i32* %43, align 4, !dbg !911
  br label %bb30, !dbg !911

bb30:                                             ; preds = %bb28, %bb29
  %46 = add nsw i32 %count.1, 1, !dbg !912
  br label %bb39, !dbg !912

bb31:                                             ; preds = %bb23
  br i1 %28, label %bb32, label %bb33, !dbg !913

bb32:                                             ; preds = %bb31
  %47 = load i32* %scevgep7677, align 4, !dbg !913
  %48 = sdiv i32 %47, 32, !dbg !913
  %49 = getelementptr inbounds %struct.fd_set* %os_read, i32 0, i32 0, i32 %48, !dbg !913
  %50 = load i32* %49, align 4, !dbg !913
  %51 = and i32 %47, 31
  %52 = shl i32 1, %51, !dbg !913
  %53 = or i32 %50, %52, !dbg !913
  store i32 %53, i32* %49, align 4, !dbg !913
  br label %bb33, !dbg !913

bb33:                                             ; preds = %bb31, %bb32
  %54 = getelementptr inbounds %struct.fd_set* %in_write, i32 0, i32 0, i32 %6, !dbg !914
  %55 = load i32* %54, align 4, !dbg !914
  %56 = and i32 %55, %10, !dbg !914
  %57 = icmp eq i32 %56, 0, !dbg !914
  br i1 %57, label %bb35, label %bb34, !dbg !914

bb34:                                             ; preds = %bb33
  %58 = load i32* %scevgep7677, align 4, !dbg !914
  %59 = sdiv i32 %58, 32, !dbg !914
  %60 = getelementptr inbounds %struct.fd_set* %os_write, i32 0, i32 0, i32 %59, !dbg !914
  %61 = load i32* %60, align 4, !dbg !914
  %62 = and i32 %58, 31
  %63 = shl i32 1, %62, !dbg !914
  %64 = or i32 %61, %63, !dbg !914
  store i32 %64, i32* %60, align 4, !dbg !914
  br label %bb35, !dbg !914

bb35:                                             ; preds = %bb33, %bb34
  %65 = getelementptr inbounds %struct.fd_set* %in_except, i32 0, i32 0, i32 %6, !dbg !915
  %66 = load i32* %65, align 4, !dbg !915
  %67 = and i32 %66, %10, !dbg !915
  %68 = icmp eq i32 %67, 0, !dbg !915
  %.pre = load i32* %scevgep7677, align 4
  br i1 %68, label %bb37, label %bb36, !dbg !915

bb36:                                             ; preds = %bb35
  %69 = sdiv i32 %.pre, 32, !dbg !915
  %70 = getelementptr inbounds %struct.fd_set* %os_except, i32 0, i32 0, i32 %69, !dbg !915
  %71 = load i32* %70, align 4, !dbg !915
  %72 = and i32 %.pre, 31
  %73 = shl i32 1, %72, !dbg !915
  %74 = or i32 %71, %73, !dbg !915
  store i32 %74, i32* %70, align 4, !dbg !915
  br label %bb37, !dbg !915

bb37:                                             ; preds = %bb35, %bb36
  %75 = add nsw i32 %.pre, 1, !dbg !916
  %76 = icmp slt i32 %.pre, %os_nfds.1, !dbg !916
  %os_nfds.1. = select i1 %76, i32 %os_nfds.1, i32 %75
  br label %bb39

bb39:                                             ; preds = %bb37, %bb20, %bb30
  %count.0 = phi i32 [ %46, %bb30 ], [ %count.1, %bb20 ], [ %count.1, %bb37 ]
  %os_nfds.0 = phi i32 [ %os_nfds.1, %bb30 ], [ %os_nfds.1, %bb20 ], [ %os_nfds.1., %bb37 ]
  %77 = add nsw i32 %78, 1, !dbg !899
  br label %bb40, !dbg !899

bb40:                                             ; preds = %bb39, %bb14
  %78 = phi i32 [ 0, %bb14 ], [ %77, %bb39 ]
  %count.1 = phi i32 [ 0, %bb14 ], [ %count.0, %bb39 ]
  %os_nfds.1 = phi i32 [ 0, %bb14 ], [ %os_nfds.0, %bb39 ]
  %scevgep76 = getelementptr %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %78
  %scevgep7677 = getelementptr %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %78, i32 0
  %scevgep78 = getelementptr %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %78, i32 3
  %scevgep79 = getelementptr %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %78, i32 1
  %79 = icmp slt i32 %78, %nfds, !dbg !899
  br i1 %79, label %bb18, label %bb41, !dbg !899

bb41:                                             ; preds = %bb40
  %80 = icmp sgt i32 %os_nfds.1, 0, !dbg !917
  br i1 %80, label %bb42, label %bb61, !dbg !917

bb42:                                             ; preds = %bb41
  call void @llvm.dbg.declare(metadata !{%struct.timespec* %tv}, metadata !368), !dbg !918
  %81 = getelementptr inbounds %struct.timespec* %tv, i32 0, i32 0, !dbg !918
  store i32 0, i32* %81, align 8, !dbg !918
  %82 = getelementptr inbounds %struct.timespec* %tv, i32 0, i32 1, !dbg !918
  store i32 0, i32* %82, align 4, !dbg !918
  %83 = call i32 (i32, ...)* @syscall(i32 82, i32 %os_nfds.1, %struct.fd_set* %os_read, %struct.fd_set* %os_write, %struct.fd_set* %os_except, %struct.timespec* %tv) nounwind, !dbg !919
  call void @llvm.dbg.value(metadata !{i32 %83}, i64 0, metadata !370), !dbg !919
  %84 = icmp eq i32 %83, -1, !dbg !920
  br i1 %84, label %bb43, label %bb45, !dbg !920

bb43:                                             ; preds = %bb42
  %85 = icmp eq i32 %count.1, 0, !dbg !921
  br i1 %85, label %bb44, label %bb61, !dbg !921

bb44:                                             ; preds = %bb43
  %86 = call i32* @__errno_location() nounwind readnone, !dbg !922
  %87 = call i32 @klee_get_errno() nounwind, !dbg !922
  store i32 %87, i32* %86, align 4, !dbg !922
  br label %bb61, !dbg !923

bb45:                                             ; preds = %bb42
  %88 = add nsw i32 %83, %count.1, !dbg !924
  call void @llvm.dbg.value(metadata !{i32 %88}, i64 0, metadata !364), !dbg !924
  call void @llvm.dbg.value(metadata !562, i64 0, metadata !363), !dbg !925
  %89 = icmp sgt i32 %nfds, 0, !dbg !925
  br i1 %89, label %bb46, label %bb61, !dbg !925

bb46:                                             ; preds = %bb45, %bb58
  %90 = phi i32 [ %139, %bb58 ], [ 0, %bb45 ]
  %scevgep71 = getelementptr %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %90
  %scevgep7173 = getelementptr %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %90, i32 0
  %scevgep72 = getelementptr %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %90, i32 3
  %91 = icmp ult i32 %90, 32, !dbg !926
  br i1 %91, label %bb.i64, label %bb58, !dbg !926

bb.i64:                                           ; preds = %bb46
  %scevgep = getelementptr %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %90, i32 1
  %92 = load i32* %scevgep, align 4, !dbg !928
  %93 = and i32 %92, 1
  %toBool.i63 = icmp eq i32 %93, 0, !dbg !928
  %94 = icmp eq %struct.exe_file_t* %scevgep71, null, !dbg !929
  %or.cond80 = or i1 %toBool.i63, %94
  br i1 %or.cond80, label %bb58, label %bb48, !dbg !928

bb48:                                             ; preds = %bb.i64
  %95 = load %struct.exe_disk_file_t** %scevgep72, align 4, !dbg !929
  %96 = icmp eq %struct.exe_disk_file_t* %95, null, !dbg !929
  br i1 %96, label %bb49, label %bb58, !dbg !929

bb49:                                             ; preds = %bb48
  br i1 %0, label %bb52, label %bb50, !dbg !930

bb50:                                             ; preds = %bb49
  %97 = load i32* %scevgep7173, align 4, !dbg !930
  %98 = sdiv i32 %97, 32, !dbg !930
  %99 = getelementptr inbounds %struct.fd_set* %os_read, i32 0, i32 0, i32 %98, !dbg !930
  %100 = load i32* %99, align 4, !dbg !930
  %101 = and i32 %97, 31
  %102 = shl i32 1, %101, !dbg !930
  %103 = and i32 %100, %102, !dbg !930
  %104 = icmp eq i32 %103, 0, !dbg !930
  br i1 %104, label %bb52, label %bb51, !dbg !930

bb51:                                             ; preds = %bb50
  %105 = sdiv i32 %90, 32, !dbg !930
  %106 = getelementptr inbounds %struct.fd_set* %read, i32 0, i32 0, i32 %105, !dbg !930
  %107 = load i32* %106, align 4, !dbg !930
  %108 = and i32 %90, 31
  %109 = shl i32 1, %108, !dbg !930
  %110 = or i32 %107, %109, !dbg !930
  store i32 %110, i32* %106, align 4, !dbg !930
  br label %bb52, !dbg !930

bb52:                                             ; preds = %bb50, %bb49, %bb51
  br i1 %2, label %bb55, label %bb53, !dbg !931

bb53:                                             ; preds = %bb52
  %111 = load i32* %scevgep7173, align 4, !dbg !931
  %112 = sdiv i32 %111, 32, !dbg !931
  %113 = getelementptr inbounds %struct.fd_set* %os_write, i32 0, i32 0, i32 %112, !dbg !931
  %114 = load i32* %113, align 4, !dbg !931
  %115 = and i32 %111, 31
  %116 = shl i32 1, %115, !dbg !931
  %117 = and i32 %114, %116, !dbg !931
  %118 = icmp eq i32 %117, 0, !dbg !931
  br i1 %118, label %bb55, label %bb54, !dbg !931

bb54:                                             ; preds = %bb53
  %119 = sdiv i32 %90, 32, !dbg !931
  %120 = getelementptr inbounds %struct.fd_set* %write, i32 0, i32 0, i32 %119, !dbg !931
  %121 = load i32* %120, align 4, !dbg !931
  %122 = and i32 %90, 31
  %123 = shl i32 1, %122, !dbg !931
  %124 = or i32 %121, %123, !dbg !931
  store i32 %124, i32* %120, align 4, !dbg !931
  br label %bb55, !dbg !931

bb55:                                             ; preds = %bb53, %bb52, %bb54
  br i1 %4, label %bb58, label %bb56, !dbg !932

bb56:                                             ; preds = %bb55
  %125 = load i32* %scevgep7173, align 4, !dbg !932
  %126 = sdiv i32 %125, 32, !dbg !932
  %127 = getelementptr inbounds %struct.fd_set* %os_except, i32 0, i32 0, i32 %126, !dbg !932
  %128 = load i32* %127, align 4, !dbg !932
  %129 = and i32 %125, 31
  %130 = shl i32 1, %129, !dbg !932
  %131 = and i32 %128, %130, !dbg !932
  %132 = icmp eq i32 %131, 0, !dbg !932
  br i1 %132, label %bb58, label %bb57, !dbg !932

bb57:                                             ; preds = %bb56
  %133 = sdiv i32 %90, 32, !dbg !932
  %134 = getelementptr inbounds %struct.fd_set* %except, i32 0, i32 0, i32 %133, !dbg !932
  %135 = load i32* %134, align 4, !dbg !932
  %136 = and i32 %90, 31
  %137 = shl i32 1, %136, !dbg !932
  %138 = or i32 %135, %137, !dbg !932
  store i32 %138, i32* %134, align 4, !dbg !932
  br label %bb58, !dbg !932

bb58:                                             ; preds = %bb46, %bb.i64, %bb56, %bb55, %bb57, %bb48
  %139 = add nsw i32 %90, 1, !dbg !925
  %exitcond = icmp eq i32 %139, %nfds
  br i1 %exitcond, label %bb61, label %bb46, !dbg !925

bb61:                                             ; preds = %bb45, %bb58, %bb41, %bb43, %bb44, %bb22
  %.0 = phi i32 [ -1, %bb22 ], [ -1, %bb44 ], [ %count.1, %bb43 ], [ %count.1, %bb41 ], [ %88, %bb58 ], [ %88, %bb45 ]
  ret i32 %.0, !dbg !907
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture, i32, i32, i1) nounwind

declare void @llvm.memset.p0i8.i32(i8* nocapture, i8, i32, i32, i1) nounwind

define i32 @close(i32 %fd) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !373), !dbg !933
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !376), !dbg !934
  %0 = load i32* @n_calls.4421, align 4, !dbg !935
  %1 = add nsw i32 %0, 1, !dbg !935
  store i32 %1, i32* @n_calls.4421, align 4, !dbg !935
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !236), !dbg !936
  %2 = icmp ult i32 %fd, 32, !dbg !938
  br i1 %2, label %bb.i, label %bb, !dbg !938

bb.i:                                             ; preds = %entry
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !237), !dbg !939
  %3 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 1, !dbg !940
  %4 = load i32* %3, align 4, !dbg !940
  %5 = and i32 %4, 1
  %toBool.i = icmp eq i32 %5, 0, !dbg !940
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !940

__get_file.exit:                                  ; preds = %bb.i
  %6 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, !dbg !939
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %6}, i64 0, metadata !374), !dbg !937
  %7 = icmp eq %struct.exe_file_t* %6, null, !dbg !941
  br i1 %7, label %bb, label %bb1, !dbg !941

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %8 = tail call i32* @__errno_location() nounwind readnone, !dbg !942
  store i32 9, i32* %8, align 4, !dbg !942
  br label %bb5, !dbg !943

bb1:                                              ; preds = %__get_file.exit
  %9 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 5), align 4, !dbg !944
  %10 = icmp eq i32 %9, 0, !dbg !944
  br i1 %10, label %bb4, label %bb2, !dbg !944

bb2:                                              ; preds = %bb1
  %11 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 8), align 4, !dbg !944
  %12 = load i32* %11, align 4, !dbg !944
  %13 = icmp eq i32 %12, %1, !dbg !944
  br i1 %13, label %bb3, label %bb4, !dbg !944

bb3:                                              ; preds = %bb2
  %14 = add i32 %9, -1, !dbg !945
  store i32 %14, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 5), align 4, !dbg !945
  %15 = tail call i32* @__errno_location() nounwind readnone, !dbg !946
  store i32 5, i32* %15, align 4, !dbg !946
  br label %bb5, !dbg !947

bb4:                                              ; preds = %bb1, %bb2
  %16 = bitcast %struct.exe_file_t* %6 to i8*, !dbg !948
  tail call void @llvm.memset.p0i8.i32(i8* %16, i8 0, i32 20, i32 4, i1 false), !dbg !948
  br label %bb5, !dbg !949

bb5:                                              ; preds = %bb4, %bb3, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb3 ], [ 0, %bb4 ]
  ret i32 %.0, !dbg !943
}

define i32 @dup2(i32 %oldfd, i32 %newfd) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %oldfd}, i64 0, metadata !377), !dbg !950
  tail call void @llvm.dbg.value(metadata !{i32 %newfd}, i64 0, metadata !378), !dbg !950
  tail call void @llvm.dbg.value(metadata !{i32 %oldfd}, i64 0, metadata !236), !dbg !951
  %0 = icmp ult i32 %oldfd, 32, !dbg !953
  br i1 %0, label %bb.i, label %bb, !dbg !953

bb.i:                                             ; preds = %entry
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !237), !dbg !954
  %1 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %oldfd, i32 1, !dbg !955
  %2 = load i32* %1, align 4, !dbg !955
  %3 = and i32 %2, 1
  %toBool.i = icmp eq i32 %3, 0, !dbg !955
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !955

__get_file.exit:                                  ; preds = %bb.i
  %4 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %oldfd, !dbg !954
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %4}, i64 0, metadata !379), !dbg !952
  %5 = icmp eq %struct.exe_file_t* %4, null, !dbg !956
  %6 = icmp ugt i32 %newfd, 31, !dbg !956
  %7 = or i1 %5, %6, !dbg !956
  br i1 %7, label %bb, label %bb3, !dbg !956

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %8 = tail call i32* @__errno_location() nounwind readnone, !dbg !957
  store i32 9, i32* %8, align 4, !dbg !957
  br label %bb7, !dbg !958

bb3:                                              ; preds = %__get_file.exit
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !381), !dbg !959
  %9 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %newfd, i32 1, !dbg !960
  %10 = load i32* %9, align 4, !dbg !960
  %11 = and i32 %10, 1
  %toBool4 = icmp eq i32 %11, 0, !dbg !960
  br i1 %toBool4, label %bb6, label %bb5, !dbg !960

bb5:                                              ; preds = %bb3
  tail call void @llvm.dbg.value(metadata !{i32 %newfd}, i64 0, metadata !373) nounwind, !dbg !961
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !376) nounwind, !dbg !962
  %12 = load i32* @n_calls.4421, align 4, !dbg !963
  %13 = add nsw i32 %12, 1, !dbg !963
  store i32 %13, i32* @n_calls.4421, align 4, !dbg !963
  tail call void @llvm.dbg.value(metadata !{i32 %newfd}, i64 0, metadata !236) nounwind, !dbg !964
  %14 = icmp ult i32 %newfd, 32, !dbg !966
  br i1 %14, label %__get_file.exit.i, label %bb.i9, !dbg !966

__get_file.exit.i:                                ; preds = %bb5
  %15 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %newfd, !dbg !967
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %15}, i64 0, metadata !374) nounwind, !dbg !965
  %16 = icmp eq %struct.exe_file_t* %15, null, !dbg !968
  br i1 %16, label %bb.i9, label %bb1.i10, !dbg !968

bb.i9:                                            ; preds = %__get_file.exit.i, %bb5
  %17 = tail call i32* @__errno_location() nounwind readnone, !dbg !969
  store i32 9, i32* %17, align 4, !dbg !969
  br label %bb6, !dbg !970

bb1.i10:                                          ; preds = %__get_file.exit.i
  %18 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 5), align 4, !dbg !971
  %19 = icmp eq i32 %18, 0, !dbg !971
  br i1 %19, label %bb4.i, label %bb2.i, !dbg !971

bb2.i:                                            ; preds = %bb1.i10
  %20 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 8), align 4, !dbg !971
  %21 = load i32* %20, align 4, !dbg !971
  %22 = icmp eq i32 %21, %13, !dbg !971
  br i1 %22, label %bb3.i, label %bb4.i, !dbg !971

bb3.i:                                            ; preds = %bb2.i
  %23 = add i32 %18, -1, !dbg !972
  store i32 %23, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 5), align 4, !dbg !972
  %24 = tail call i32* @__errno_location() nounwind readnone, !dbg !973
  store i32 5, i32* %24, align 4, !dbg !973
  br label %bb6, !dbg !974

bb4.i:                                            ; preds = %bb2.i, %bb1.i10
  %25 = bitcast %struct.exe_file_t* %15 to i8*, !dbg !975
  tail call void @llvm.memset.p0i8.i32(i8* %25, i8 0, i32 20, i32 4, i1 false) nounwind, !dbg !975
  br label %bb6, !dbg !976

bb6:                                              ; preds = %bb4.i, %bb3.i, %bb.i9, %bb3
  %26 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %newfd, i32 0, !dbg !977
  %27 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %oldfd, i32 0, !dbg !977
  %28 = load i32* %27, align 4, !dbg !977
  store i32 %28, i32* %26, align 4, !dbg !977
  %29 = load i32* %1, align 4, !dbg !977
  %30 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %newfd, i32 2, !dbg !977
  %31 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %oldfd, i32 2, !dbg !977
  %32 = load i64* %31, align 4, !dbg !977
  store i64 %32, i64* %30, align 4, !dbg !977
  %33 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %newfd, i32 3, !dbg !977
  %34 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %oldfd, i32 3, !dbg !977
  %35 = load %struct.exe_disk_file_t** %34, align 4, !dbg !977
  store %struct.exe_disk_file_t* %35, %struct.exe_disk_file_t** %33, align 4, !dbg !977
  %36 = and i32 %29, -3, !dbg !978
  store i32 %36, i32* %9, align 4, !dbg !978
  br label %bb7, !dbg !979

bb7:                                              ; preds = %bb6, %bb
  %.0 = phi i32 [ -1, %bb ], [ %newfd, %bb6 ]
  ret i32 %.0, !dbg !958
}

define i32 @dup(i32 %oldfd) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %oldfd}, i64 0, metadata !383), !dbg !980
  tail call void @llvm.dbg.value(metadata !{i32 %oldfd}, i64 0, metadata !236), !dbg !981
  %0 = icmp ult i32 %oldfd, 32, !dbg !983
  br i1 %0, label %bb.i, label %bb, !dbg !983

bb.i:                                             ; preds = %entry
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !237), !dbg !984
  %1 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %oldfd, i32 1, !dbg !985
  %2 = load i32* %1, align 4, !dbg !985
  %3 = and i32 %2, 1
  %toBool.i = icmp eq i32 %3, 0, !dbg !985
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !985

__get_file.exit:                                  ; preds = %bb.i
  %4 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %oldfd, !dbg !984
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %4}, i64 0, metadata !384), !dbg !982
  %5 = icmp eq %struct.exe_file_t* %4, null, !dbg !986
  br i1 %5, label %bb, label %bb4, !dbg !986

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %6 = tail call i32* @__errno_location() nounwind readnone, !dbg !987
  store i32 9, i32* %6, align 4, !dbg !987
  br label %bb8, !dbg !988

bb2:                                              ; preds = %bb4
  %scevgep = getelementptr %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %11, i32 1
  %7 = load i32* %scevgep, align 4, !dbg !989
  %8 = and i32 %7, 1, !dbg !989
  %9 = icmp eq i32 %8, 0, !dbg !989
  br i1 %9, label %bb7, label %bb3, !dbg !989

bb3:                                              ; preds = %bb2
  %10 = add nsw i32 %11, 1, !dbg !990
  br label %bb4, !dbg !990

bb4:                                              ; preds = %__get_file.exit, %bb3
  %11 = phi i32 [ %10, %bb3 ], [ 0, %__get_file.exit ]
  %12 = icmp slt i32 %11, 32, !dbg !990
  br i1 %12, label %bb2, label %bb5, !dbg !990

bb5:                                              ; preds = %bb4
  %13 = icmp eq i32 %11, 32, !dbg !991
  br i1 %13, label %bb6, label %bb7, !dbg !991

bb6:                                              ; preds = %bb5
  %14 = tail call i32* @__errno_location() nounwind readnone, !dbg !992
  store i32 24, i32* %14, align 4, !dbg !992
  br label %bb8, !dbg !993

bb7:                                              ; preds = %bb2, %bb5
  %15 = tail call i32 @dup2(i32 %oldfd, i32 %11) nounwind, !dbg !994
  br label %bb8, !dbg !994

bb8:                                              ; preds = %bb7, %bb6, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb6 ], [ %15, %bb7 ]
  ret i32 %.0, !dbg !988
}

define i32 @fcntl(i32 %fd, i32 %cmd, ...) nounwind {
entry:
  %ap = alloca i8*, align 4
  call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !388), !dbg !995
  call void @llvm.dbg.value(metadata !{i32 %cmd}, i64 0, metadata !389), !dbg !995
  call void @llvm.dbg.declare(metadata !{i8** %ap}, metadata !392), !dbg !996
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !236), !dbg !997
  %0 = icmp ult i32 %fd, 32, !dbg !999
  br i1 %0, label %bb.i, label %bb, !dbg !999

bb.i:                                             ; preds = %entry
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !237), !dbg !1000
  %1 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 1, !dbg !1001
  %2 = load i32* %1, align 4, !dbg !1001
  %3 = and i32 %2, 1
  %toBool.i = icmp eq i32 %3, 0, !dbg !1001
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !1001

__get_file.exit:                                  ; preds = %bb.i
  %4 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, !dbg !1000
  call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %4}, i64 0, metadata !390), !dbg !998
  %5 = icmp eq %struct.exe_file_t* %4, null, !dbg !1002
  br i1 %5, label %bb, label %bb1, !dbg !1002

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %6 = call i32* @__errno_location() nounwind readnone, !dbg !1003
  store i32 9, i32* %6, align 4, !dbg !1003
  br label %bb30, !dbg !1004

bb1:                                              ; preds = %__get_file.exit
  switch i32 %cmd, label %bb8 [
    i32 3, label %bb16
    i32 1, label %bb16
    i32 11, label %bb16
    i32 9, label %bb16
  ]

bb8:                                              ; preds = %bb1
  %cmd.off = add i32 %cmd, -1025
  %7 = icmp ult i32 %cmd.off, 2
  br i1 %7, label %bb16, label %bb13, !dbg !1005

bb13:                                             ; preds = %bb8
  %ap14 = bitcast i8** %ap to i8*, !dbg !1006
  call void @llvm.va_start(i8* %ap14), !dbg !1006
  %8 = load i8** %ap, align 4, !dbg !1007
  %9 = getelementptr inbounds i8* %8, i32 4, !dbg !1007
  store i8* %9, i8** %ap, align 4, !dbg !1007
  %10 = bitcast i8* %8 to i32*, !dbg !1007
  %11 = load i32* %10, align 4, !dbg !1007
  call void @llvm.dbg.value(metadata !{i32 %11}, i64 0, metadata !395), !dbg !1007
  call void @llvm.va_end(i8* %ap14), !dbg !1008
  br label %bb16, !dbg !1008

bb16:                                             ; preds = %bb1, %bb1, %bb1, %bb1, %bb8, %bb13
  %arg.0 = phi i32 [ %11, %bb13 ], [ 0, %bb1 ], [ 0, %bb1 ], [ 0, %bb8 ], [ 0, %bb1 ], [ 0, %bb1 ]
  %12 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 3, !dbg !1009
  %13 = load %struct.exe_disk_file_t** %12, align 4, !dbg !1009
  %14 = icmp eq %struct.exe_disk_file_t* %13, null, !dbg !1009
  br i1 %14, label %bb27, label %bb17, !dbg !1009

bb17:                                             ; preds = %bb16
  switch i32 %cmd, label %bb26 [
    i32 1, label %bb18
    i32 2, label %bb21
    i32 3, label %bb30
  ], !dbg !1010

bb18:                                             ; preds = %bb17
  call void @llvm.dbg.value(metadata !562, i64 0, metadata !396), !dbg !1011
  %15 = load i32* %1, align 4, !dbg !1012
  call void @llvm.dbg.value(metadata !1013, i64 0, metadata !396), !dbg !1014
  %16 = lshr i32 %15, 1
  %.lobit = and i32 %16, 1
  br label %bb30

bb21:                                             ; preds = %bb17
  %17 = load i32* %1, align 4, !dbg !1015
  %18 = and i32 %17, -3, !dbg !1015
  store i32 %18, i32* %1, align 4, !dbg !1015
  %19 = and i32 %arg.0, 1
  %toBool22 = icmp eq i32 %19, 0, !dbg !1016
  br i1 %toBool22, label %bb30, label %bb23, !dbg !1016

bb23:                                             ; preds = %bb21
  %20 = or i32 %17, 2, !dbg !1017
  store i32 %20, i32* %1, align 4, !dbg !1017
  br label %bb30, !dbg !1017

bb26:                                             ; preds = %bb17
  call void @klee_warning(i8* getelementptr inbounds ([33 x i8]* @.str6, i32 0, i32 0)) nounwind, !dbg !1018
  %21 = call i32* @__errno_location() nounwind readnone, !dbg !1019
  store i32 22, i32* %21, align 4, !dbg !1019
  br label %bb30, !dbg !1020

bb27:                                             ; preds = %bb16
  %22 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 0, !dbg !1021
  %23 = load i32* %22, align 4, !dbg !1021
  %24 = call i32 (i32, ...)* @syscall(i32 55, i32 %23, i32 %cmd, i32 %arg.0) nounwind, !dbg !1021
  call void @llvm.dbg.value(metadata !{i32 %24}, i64 0, metadata !398), !dbg !1021
  %25 = icmp eq i32 %24, -1, !dbg !1022
  br i1 %25, label %bb28, label %bb30, !dbg !1022

bb28:                                             ; preds = %bb27
  %26 = call i32* @__errno_location() nounwind readnone, !dbg !1023
  %27 = call i32 @klee_get_errno() nounwind, !dbg !1023
  store i32 %27, i32* %26, align 4, !dbg !1023
  br label %bb30, !dbg !1023

bb30:                                             ; preds = %bb27, %bb28, %bb17, %bb23, %bb21, %bb18, %bb26, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb26 ], [ %.lobit, %bb18 ], [ 0, %bb21 ], [ 0, %bb23 ], [ 0, %bb17 ], [ -1, %bb28 ], [ %24, %bb27 ]
  ret i32 %.0, !dbg !1004
}

declare void @llvm.va_start(i8*) nounwind

declare void @llvm.va_end(i8*) nounwind

define i32 @ioctl(i32 %fd, i32 %request, ...) nounwind {
entry:
  %ap = alloca i8*, align 4
  call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !400), !dbg !1024
  call void @llvm.dbg.value(metadata !{i32 %request}, i64 0, metadata !401), !dbg !1024
  call void @llvm.dbg.declare(metadata !{i8** %ap}, metadata !404), !dbg !1025
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !236), !dbg !1026
  %0 = icmp ult i32 %fd, 32, !dbg !1028
  br i1 %0, label %bb.i, label %bb, !dbg !1028

bb.i:                                             ; preds = %entry
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !237), !dbg !1029
  %1 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 1, !dbg !1030
  %2 = load i32* %1, align 4, !dbg !1030
  %3 = and i32 %2, 1
  %toBool.i = icmp eq i32 %3, 0, !dbg !1030
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !1030

__get_file.exit:                                  ; preds = %bb.i
  %4 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, !dbg !1029
  call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %4}, i64 0, metadata !402), !dbg !1027
  %5 = icmp eq %struct.exe_file_t* %4, null, !dbg !1031
  br i1 %5, label %bb, label %bb1, !dbg !1031

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %6 = call i32* @__errno_location() nounwind readnone, !dbg !1032
  store i32 9, i32* %6, align 4, !dbg !1032
  br label %bb34, !dbg !1033

bb1:                                              ; preds = %__get_file.exit
  %ap2 = bitcast i8** %ap to i8*, !dbg !1034
  call void @llvm.va_start(i8* %ap2), !dbg !1034
  %7 = load i8** %ap, align 4, !dbg !1035
  %8 = getelementptr inbounds i8* %7, i32 4, !dbg !1035
  store i8* %8, i8** %ap, align 4, !dbg !1035
  %9 = bitcast i8* %7 to i8**, !dbg !1035
  %10 = load i8** %9, align 4, !dbg !1035
  call void @llvm.dbg.value(metadata !{i8* %10}, i64 0, metadata !405), !dbg !1035
  call void @llvm.va_end(i8* %ap2), !dbg !1036
  %11 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 3, !dbg !1037
  %12 = load %struct.exe_disk_file_t** %11, align 4, !dbg !1037
  %13 = icmp eq %struct.exe_disk_file_t* %12, null, !dbg !1037
  br i1 %13, label %bb31, label %bb4, !dbg !1037

bb4:                                              ; preds = %bb1
  %14 = getelementptr inbounds %struct.exe_disk_file_t* %12, i32 0, i32 2, !dbg !1038
  %15 = load %struct.stat64** %14, align 4, !dbg !1038
  call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !406), !dbg !1038
  switch i32 %request, label %bb30 [
    i32 21505, label %bb5
    i32 21506, label %bb8
    i32 21507, label %bb11
    i32 21508, label %bb14
    i32 21523, label %bb17
    i32 21524, label %bb20
    i32 21531, label %bb23
    i32 -2145620734, label %bb29
  ], !dbg !1039

bb5:                                              ; preds = %bb4
  call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !430), !dbg !1040
  call void @klee_warning_once(i8* getelementptr inbounds ([41 x i8]* @.str7, i32 0, i32 0)) nounwind, !dbg !1041
  %16 = getelementptr inbounds %struct.stat64* %15, i32 0, i32 3
  %17 = load i32* %16, align 4, !dbg !1042
  %18 = and i32 %17, 61440, !dbg !1042
  %19 = icmp eq i32 %18, 8192, !dbg !1042
  br i1 %19, label %bb6, label %bb7, !dbg !1042

bb6:                                              ; preds = %bb5
  %20 = bitcast i8* %10 to i32*, !dbg !1043
  store i32 27906, i32* %20, align 4, !dbg !1043
  %21 = getelementptr inbounds i8* %10, i32 4
  %22 = bitcast i8* %21 to i32*, !dbg !1044
  store i32 5, i32* %22, align 4, !dbg !1044
  %23 = getelementptr inbounds i8* %10, i32 8
  %24 = bitcast i8* %23 to i32*, !dbg !1045
  store i32 1215, i32* %24, align 4, !dbg !1045
  %25 = getelementptr inbounds i8* %10, i32 12
  %26 = bitcast i8* %25 to i32*, !dbg !1046
  store i32 35287, i32* %26, align 4, !dbg !1046
  %27 = getelementptr inbounds i8* %10, i32 16
  store i8 0, i8* %27, align 4, !dbg !1047
  %28 = getelementptr inbounds i8* %10, i32 17
  store i8 3, i8* %28, align 1, !dbg !1048
  %29 = getelementptr inbounds i8* %10, i32 18, !dbg !1049
  store i8 28, i8* %29, align 1, !dbg !1049
  %30 = getelementptr inbounds i8* %10, i32 19, !dbg !1050
  store i8 127, i8* %30, align 1, !dbg !1050
  %31 = getelementptr inbounds i8* %10, i32 20, !dbg !1051
  store i8 21, i8* %31, align 1, !dbg !1051
  %32 = getelementptr inbounds i8* %10, i32 21, !dbg !1052
  store i8 4, i8* %32, align 1, !dbg !1052
  %33 = getelementptr inbounds i8* %10, i32 22, !dbg !1053
  store i8 0, i8* %33, align 1, !dbg !1053
  %34 = getelementptr inbounds i8* %10, i32 23, !dbg !1054
  store i8 1, i8* %34, align 1, !dbg !1054
  %35 = getelementptr inbounds i8* %10, i32 24, !dbg !1055
  store i8 -1, i8* %35, align 1, !dbg !1055
  %36 = getelementptr inbounds i8* %10, i32 25, !dbg !1056
  store i8 17, i8* %36, align 1, !dbg !1056
  %37 = getelementptr inbounds i8* %10, i32 26, !dbg !1057
  store i8 19, i8* %37, align 1, !dbg !1057
  %38 = getelementptr inbounds i8* %10, i32 27, !dbg !1058
  store i8 26, i8* %38, align 1, !dbg !1058
  %39 = getelementptr inbounds i8* %10, i32 28, !dbg !1059
  store i8 -1, i8* %39, align 1, !dbg !1059
  %40 = getelementptr inbounds i8* %10, i32 29, !dbg !1060
  store i8 18, i8* %40, align 1, !dbg !1060
  %41 = getelementptr inbounds i8* %10, i32 30, !dbg !1061
  store i8 15, i8* %41, align 1, !dbg !1061
  %42 = getelementptr inbounds i8* %10, i32 31, !dbg !1062
  store i8 23, i8* %42, align 1, !dbg !1062
  %43 = getelementptr inbounds i8* %10, i32 32, !dbg !1063
  store i8 22, i8* %43, align 1, !dbg !1063
  %44 = getelementptr inbounds i8* %10, i32 33, !dbg !1064
  store i8 -1, i8* %44, align 1, !dbg !1064
  %45 = getelementptr inbounds i8* %10, i32 34, !dbg !1065
  store i8 0, i8* %45, align 1, !dbg !1065
  %46 = getelementptr inbounds i8* %10, i32 35, !dbg !1066
  store i8 0, i8* %46, align 1, !dbg !1066
  br label %bb34, !dbg !1067

bb7:                                              ; preds = %bb5
  %47 = call i32* @__errno_location() nounwind readnone, !dbg !1068
  store i32 25, i32* %47, align 4, !dbg !1068
  br label %bb34, !dbg !1069

bb8:                                              ; preds = %bb4
  call void @klee_warning_once(i8* getelementptr inbounds ([42 x i8]* @.str8, i32 0, i32 0)) nounwind, !dbg !1070
  %48 = getelementptr inbounds %struct.stat64* %15, i32 0, i32 3
  %49 = load i32* %48, align 4, !dbg !1071
  %50 = and i32 %49, 61440, !dbg !1071
  %51 = icmp eq i32 %50, 8192, !dbg !1071
  br i1 %51, label %bb34, label %bb10, !dbg !1071

bb10:                                             ; preds = %bb8
  %52 = call i32* @__errno_location() nounwind readnone, !dbg !1072
  store i32 25, i32* %52, align 4, !dbg !1072
  br label %bb34, !dbg !1073

bb11:                                             ; preds = %bb4
  call void @klee_warning_once(i8* getelementptr inbounds ([43 x i8]* @.str9, i32 0, i32 0)) nounwind, !dbg !1074
  %53 = icmp eq i32 %fd, 0, !dbg !1075
  br i1 %53, label %bb34, label %bb13, !dbg !1075

bb13:                                             ; preds = %bb11
  %54 = call i32* @__errno_location() nounwind readnone, !dbg !1076
  store i32 25, i32* %54, align 4, !dbg !1076
  br label %bb34, !dbg !1077

bb14:                                             ; preds = %bb4
  call void @klee_warning_once(i8* getelementptr inbounds ([43 x i8]* @.str10, i32 0, i32 0)) nounwind, !dbg !1078
  %55 = getelementptr inbounds %struct.stat64* %15, i32 0, i32 3
  %56 = load i32* %55, align 4, !dbg !1079
  %57 = and i32 %56, 61440, !dbg !1079
  %58 = icmp eq i32 %57, 8192, !dbg !1079
  br i1 %58, label %bb34, label %bb16, !dbg !1079

bb16:                                             ; preds = %bb14
  %59 = call i32* @__errno_location() nounwind readnone, !dbg !1080
  store i32 25, i32* %59, align 4, !dbg !1080
  br label %bb34, !dbg !1081

bb17:                                             ; preds = %bb4
  call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !448), !dbg !1082
  %60 = bitcast i8* %10 to i16*, !dbg !1083
  store i16 24, i16* %60, align 2, !dbg !1083
  %61 = getelementptr inbounds i8* %10, i32 2
  %62 = bitcast i8* %61 to i16*, !dbg !1084
  store i16 80, i16* %62, align 2, !dbg !1084
  call void @klee_warning_once(i8* getelementptr inbounds ([45 x i8]* @.str11, i32 0, i32 0)) nounwind, !dbg !1085
  %63 = getelementptr inbounds %struct.stat64* %15, i32 0, i32 3
  %64 = load i32* %63, align 4, !dbg !1086
  %65 = and i32 %64, 61440, !dbg !1086
  %66 = icmp eq i32 %65, 8192, !dbg !1086
  br i1 %66, label %bb34, label %bb19, !dbg !1086

bb19:                                             ; preds = %bb17
  %67 = call i32* @__errno_location() nounwind readnone, !dbg !1087
  store i32 25, i32* %67, align 4, !dbg !1087
  br label %bb34, !dbg !1088

bb20:                                             ; preds = %bb4
  call void @klee_warning_once(i8* getelementptr inbounds ([46 x i8]* @.str12, i32 0, i32 0)) nounwind, !dbg !1089
  %68 = getelementptr inbounds %struct.stat64* %15, i32 0, i32 3
  %69 = load i32* %68, align 4, !dbg !1090
  %70 = and i32 %69, 61440, !dbg !1090
  %71 = icmp eq i32 %70, 8192, !dbg !1090
  %72 = call i32* @__errno_location() nounwind readnone, !dbg !1091
  br i1 %71, label %bb21, label %bb22, !dbg !1090

bb21:                                             ; preds = %bb20
  store i32 22, i32* %72, align 4, !dbg !1091
  br label %bb34, !dbg !1092

bb22:                                             ; preds = %bb20
  store i32 25, i32* %72, align 4, !dbg !1093
  br label %bb34, !dbg !1094

bb23:                                             ; preds = %bb4
  %73 = bitcast i8* %10 to i32*, !dbg !1095
  call void @llvm.dbg.value(metadata !{i32* %73}, i64 0, metadata !458), !dbg !1095
  call void @klee_warning_once(i8* getelementptr inbounds ([43 x i8]* @.str13, i32 0, i32 0)) nounwind, !dbg !1096
  %74 = getelementptr inbounds %struct.stat64* %15, i32 0, i32 3
  %75 = load i32* %74, align 4, !dbg !1097
  %76 = and i32 %75, 61440, !dbg !1097
  %77 = icmp eq i32 %76, 8192, !dbg !1097
  br i1 %77, label %bb24, label %bb28, !dbg !1097

bb24:                                             ; preds = %bb23
  %78 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 2, !dbg !1098
  %79 = load i64* %78, align 4, !dbg !1098
  %80 = load %struct.exe_disk_file_t** %11, align 4, !dbg !1098
  %81 = getelementptr inbounds %struct.exe_disk_file_t* %80, i32 0, i32 0, !dbg !1098
  %82 = load i32* %81, align 4, !dbg !1098
  %83 = zext i32 %82 to i64, !dbg !1098
  %84 = icmp slt i64 %79, %83, !dbg !1098
  br i1 %84, label %bb25, label %bb27, !dbg !1098

bb25:                                             ; preds = %bb24
  %85 = trunc i64 %79 to i32, !dbg !1099
  %86 = sub i32 %82, %85, !dbg !1099
  br label %bb27, !dbg !1099

bb27:                                             ; preds = %bb24, %bb25
  %storemerge = phi i32 [ %86, %bb25 ], [ 0, %bb24 ]
  store i32 %storemerge, i32* %73, align 4
  br label %bb34, !dbg !1100

bb28:                                             ; preds = %bb23
  %87 = call i32* @__errno_location() nounwind readnone, !dbg !1101
  store i32 25, i32* %87, align 4, !dbg !1101
  br label %bb34, !dbg !1102

bb29:                                             ; preds = %bb4
  call void @klee_warning(i8* getelementptr inbounds ([44 x i8]* @.str14, i32 0, i32 0)) nounwind, !dbg !1103
  %88 = call i32* @__errno_location() nounwind readnone, !dbg !1104
  store i32 22, i32* %88, align 4, !dbg !1104
  br label %bb34, !dbg !1105

bb30:                                             ; preds = %bb4
  call void @klee_warning(i8* getelementptr inbounds ([33 x i8]* @.str6, i32 0, i32 0)) nounwind, !dbg !1106
  %89 = call i32* @__errno_location() nounwind readnone, !dbg !1107
  store i32 22, i32* %89, align 4, !dbg !1107
  br label %bb34, !dbg !1108

bb31:                                             ; preds = %bb1
  %90 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 0, !dbg !1109
  %91 = load i32* %90, align 4, !dbg !1109
  %92 = call i32 (i32, ...)* @syscall(i32 54, i32 %91, i32 %request, i8* %10) nounwind, !dbg !1109
  call void @llvm.dbg.value(metadata !{i32 %92}, i64 0, metadata !461), !dbg !1109
  %93 = icmp eq i32 %92, -1, !dbg !1110
  br i1 %93, label %bb32, label %bb34, !dbg !1110

bb32:                                             ; preds = %bb31
  %94 = call i32* @__errno_location() nounwind readnone, !dbg !1111
  %95 = call i32 @klee_get_errno() nounwind, !dbg !1111
  store i32 %95, i32* %94, align 4, !dbg !1111
  br label %bb34, !dbg !1111

bb34:                                             ; preds = %bb31, %bb32, %bb17, %bb14, %bb11, %bb8, %bb30, %bb29, %bb28, %bb27, %bb22, %bb21, %bb19, %bb16, %bb13, %bb10, %bb7, %bb6, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb30 ], [ -1, %bb29 ], [ 0, %bb27 ], [ -1, %bb28 ], [ -1, %bb21 ], [ -1, %bb22 ], [ -1, %bb19 ], [ -1, %bb16 ], [ -1, %bb13 ], [ -1, %bb10 ], [ 0, %bb6 ], [ -1, %bb7 ], [ 0, %bb8 ], [ 0, %bb11 ], [ 0, %bb14 ], [ 0, %bb17 ], [ -1, %bb32 ], [ %92, %bb31 ]
  ret i32 %.0, !dbg !1033
}

declare void @klee_warning_once(i8*)

define i32 @__fd_getdents(i32 %fd, %struct.dirent64* %dirp, i32 %count) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !463), !dbg !1112
  tail call void @llvm.dbg.value(metadata !{%struct.dirent64* %dirp}, i64 0, metadata !464), !dbg !1112
  tail call void @llvm.dbg.value(metadata !{i32 %count}, i64 0, metadata !465), !dbg !1112
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !236), !dbg !1113
  %0 = icmp ult i32 %fd, 32, !dbg !1115
  br i1 %0, label %bb.i, label %bb, !dbg !1115

bb.i:                                             ; preds = %entry
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !237), !dbg !1116
  %1 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 1, !dbg !1117
  %2 = load i32* %1, align 4, !dbg !1117
  %3 = and i32 %2, 1
  %toBool.i = icmp eq i32 %3, 0, !dbg !1117
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !1117

__get_file.exit:                                  ; preds = %bb.i
  %4 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, !dbg !1116
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %4}, i64 0, metadata !466), !dbg !1114
  %5 = icmp eq %struct.exe_file_t* %4, null, !dbg !1118
  br i1 %5, label %bb, label %bb1, !dbg !1118

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %6 = tail call i32* @__errno_location() nounwind readnone, !dbg !1119
  store i32 9, i32* %6, align 4, !dbg !1119
  br label %bb18, !dbg !1120

bb1:                                              ; preds = %__get_file.exit
  %7 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 3, !dbg !1121
  %8 = load %struct.exe_disk_file_t** %7, align 4, !dbg !1121
  %9 = icmp eq %struct.exe_disk_file_t* %8, null, !dbg !1121
  br i1 %9, label %bb3, label %bb2, !dbg !1121

bb2:                                              ; preds = %bb1
  tail call void @klee_warning(i8* getelementptr inbounds ([33 x i8]* @.str6, i32 0, i32 0)) nounwind, !dbg !1122
  %10 = tail call i32* @__errno_location() nounwind readnone, !dbg !1123
  store i32 22, i32* %10, align 4, !dbg !1123
  br label %bb18, !dbg !1124

bb3:                                              ; preds = %bb1
  %11 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 2, !dbg !1125
  %12 = load i64* %11, align 4, !dbg !1125
  %13 = trunc i64 %12 to i32, !dbg !1125
  %14 = icmp ult i32 %13, 4096, !dbg !1125
  br i1 %14, label %bb4, label %bb10, !dbg !1125

bb4:                                              ; preds = %bb3
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !471), !dbg !1126
  %15 = sdiv i64 %12, 276, !dbg !1127
  %16 = trunc i64 %15 to i32, !dbg !1127
  tail call void @llvm.dbg.value(metadata !{i32 %16}, i64 0, metadata !468), !dbg !1127
  %17 = mul i32 %16, 276, !dbg !1128
  %18 = zext i32 %17 to i64, !dbg !1128
  %19 = icmp ne i64 %18, %12, !dbg !1128
  %20 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 0), align 4, !dbg !1128
  %21 = icmp ult i32 %20, %16, !dbg !1128
  %or.cond = or i1 %19, %21
  br i1 %or.cond, label %bb6, label %bb8.preheader, !dbg !1128

bb8.preheader:                                    ; preds = %bb4
  %22 = icmp ugt i32 %20, %16, !dbg !1129
  br i1 %22, label %bb7.lr.ph, label %bb9, !dbg !1129

bb7.lr.ph:                                        ; preds = %bb8.preheader
  %tmp38 = add i32 %16, 65
  %tmp48 = add i32 %17, 276
  %tmp50 = add i32 %16, 1
  br label %bb7

bb6:                                              ; preds = %bb4
  %23 = tail call i32* @__errno_location() nounwind readnone, !dbg !1130
  store i32 22, i32* %23, align 4, !dbg !1130
  br label %bb18, !dbg !1131

bb7:                                              ; preds = %bb7.lr.ph, %bb7
  %indvar = phi i32 [ 0, %bb7.lr.ph ], [ %indvar.next, %bb7 ]
  %bytes.025 = phi i32 [ 0, %bb7.lr.ph ], [ %34, %bb7 ]
  %scevgep29 = getelementptr inbounds %struct.dirent64* %dirp, i32 %indvar, i32 0
  %scevgep30 = getelementptr %struct.dirent64* %dirp, i32 %indvar, i32 2
  %scevgep31 = getelementptr %struct.dirent64* %dirp, i32 %indvar, i32 3
  %scevgep32 = getelementptr %struct.dirent64* %dirp, i32 %indvar, i32 1
  %scevgep35 = getelementptr %struct.dirent64* %dirp, i32 %indvar, i32 4, i32 0
  %scevgep36 = getelementptr %struct.dirent64* %dirp, i32 %indvar, i32 4, i32 1
  %tmp40 = add i32 %tmp38, %indvar
  %tmp41 = trunc i32 %tmp40 to i8
  %tmp43 = add i32 %16, %indvar
  %tmp46 = mul i32 %indvar, 276
  %tmp49 = add i32 %tmp48, %tmp46
  %tmp51 = add i32 %tmp50, %indvar
  %24 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 4), align 4, !dbg !1132
  %scevgep45 = getelementptr %struct.exe_disk_file_t* %24, i32 %tmp43, i32 2
  %25 = load %struct.stat64** %scevgep45, align 4, !dbg !1133
  %26 = getelementptr inbounds %struct.stat64* %25, i32 0, i32 15, !dbg !1133
  %27 = load i64* %26, align 4, !dbg !1133
  store i64 %27, i64* %scevgep29, align 4, !dbg !1133
  store i16 276, i16* %scevgep30, align 4, !dbg !1134
  %28 = load %struct.stat64** %scevgep45, align 4, !dbg !1135
  %29 = getelementptr inbounds %struct.stat64* %28, i32 0, i32 3, !dbg !1135
  %30 = load i32* %29, align 4, !dbg !1135
  %31 = lshr i32 %30, 12
  %.tr = trunc i32 %31 to i8
  %32 = and i8 %.tr, 15, !dbg !1135
  store i8 %32, i8* %scevgep31, align 2, !dbg !1135
  store i8 %tmp41, i8* %scevgep35, align 1, !dbg !1136
  store i8 0, i8* %scevgep36, align 1, !dbg !1137
  %33 = zext i32 %tmp49 to i64, !dbg !1138
  store i64 %33, i64* %scevgep32, align 4, !dbg !1138
  %34 = add i32 %bytes.025, 276, !dbg !1139
  %35 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 0), align 4, !dbg !1129
  %36 = icmp ugt i32 %35, %tmp51, !dbg !1129
  %indvar.next = add i32 %indvar, 1
  br i1 %36, label %bb7, label %bb8.bb9_crit_edge, !dbg !1129

bb8.bb9_crit_edge:                                ; preds = %bb7
  %scevgep34 = getelementptr %struct.dirent64* %dirp, i32 %indvar.next
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !472), !dbg !1132
  tail call void @llvm.dbg.value(metadata !{i32 %34}, i64 0, metadata !471), !dbg !1139
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !464), !dbg !1140
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !468), !dbg !1129
  br label %bb9

bb9:                                              ; preds = %bb8.bb9_crit_edge, %bb8.preheader
  %dirp_addr.0.lcssa = phi %struct.dirent64* [ %scevgep34, %bb8.bb9_crit_edge ], [ %dirp, %bb8.preheader ]
  %bytes.0.lcssa = phi i32 [ %34, %bb8.bb9_crit_edge ], [ 0, %bb8.preheader ]
  %37 = icmp ugt i32 %count, 4096, !dbg !1141
  %min = select i1 %37, i32 4096, i32 %count, !dbg !1141
  tail call void @llvm.dbg.value(metadata !{i32 %min}, i64 0, metadata !470), !dbg !1141
  %38 = getelementptr inbounds %struct.dirent64* %dirp_addr.0.lcssa, i32 0, i32 0, !dbg !1142
  store i64 0, i64* %38, align 4, !dbg !1142
  %39 = trunc i32 %min to i16, !dbg !1143
  %40 = trunc i32 %bytes.0.lcssa to i16, !dbg !1143
  %41 = sub i16 %39, %40, !dbg !1143
  %42 = getelementptr inbounds %struct.dirent64* %dirp_addr.0.lcssa, i32 0, i32 2, !dbg !1143
  store i16 %41, i16* %42, align 4, !dbg !1143
  %43 = getelementptr inbounds %struct.dirent64* %dirp_addr.0.lcssa, i32 0, i32 3, !dbg !1144
  store i8 0, i8* %43, align 2, !dbg !1144
  %44 = getelementptr inbounds %struct.dirent64* %dirp_addr.0.lcssa, i32 0, i32 4, i32 0, !dbg !1145
  store i8 0, i8* %44, align 1, !dbg !1145
  %45 = getelementptr inbounds %struct.dirent64* %dirp_addr.0.lcssa, i32 0, i32 1, !dbg !1146
  store i64 4096, i64* %45, align 4, !dbg !1146
  %46 = zext i16 %41 to i32, !dbg !1147
  %47 = add i32 %46, %bytes.0.lcssa, !dbg !1147
  tail call void @llvm.dbg.value(metadata !{i32 %47}, i64 0, metadata !471), !dbg !1147
  %48 = zext i32 %min to i64, !dbg !1148
  store i64 %48, i64* %11, align 4, !dbg !1148
  br label %bb18, !dbg !1149

bb10:                                             ; preds = %bb3
  %49 = add i32 %13, -4096, !dbg !1150
  tail call void @llvm.dbg.value(metadata !{i32 %49}, i64 0, metadata !474), !dbg !1150
  %50 = bitcast %struct.dirent64* %dirp to i8*, !dbg !1151
  tail call void @llvm.memset.p0i8.i32(i8* %50, i8 0, i32 %count, i32 4, i1 false), !dbg !1151
  %51 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 0, !dbg !1152
  %52 = load i32* %51, align 4, !dbg !1152
  %53 = tail call i32 (i32, ...)* @syscall(i32 19, i32 %52, i32 %49, i32 0) nounwind, !dbg !1152
  tail call void @llvm.dbg.value(metadata !{i32 %53}, i64 0, metadata !477), !dbg !1152
  %54 = icmp eq i32 %53, -1, !dbg !1153
  br i1 %54, label %bb11, label %bb12, !dbg !1153

bb11:                                             ; preds = %bb10
  tail call void @__assert_fail(i8* getelementptr inbounds ([18 x i8]* @.str15, i32 0, i32 0), i8* getelementptr inbounds ([5 x i8]* @.str16, i32 0, i32 0), i32 735, i8* getelementptr inbounds ([14 x i8]* @__PRETTY_FUNCTION__.4826, i32 0, i32 0)) noreturn nounwind, !dbg !1153
  unreachable, !dbg !1153

bb12:                                             ; preds = %bb10
  %55 = load i32* %51, align 4, !dbg !1154
  %56 = tail call i32 (i32, ...)* @syscall(i32 220, i32 %55, %struct.dirent64* %dirp, i32 %count) nounwind, !dbg !1154
  tail call void @llvm.dbg.value(metadata !{i32 %56}, i64 0, metadata !476), !dbg !1154
  %57 = icmp eq i32 %56, -1, !dbg !1155
  br i1 %57, label %bb13, label %bb14, !dbg !1155

bb13:                                             ; preds = %bb12
  %58 = tail call i32* @__errno_location() nounwind readnone, !dbg !1156
  %59 = tail call i32 @klee_get_errno() nounwind, !dbg !1156
  store i32 %59, i32* %58, align 4, !dbg !1156
  br label %bb18, !dbg !1156

bb14:                                             ; preds = %bb12
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !478), !dbg !1157
  %60 = load i32* %51, align 4, !dbg !1158
  %61 = tail call i32 (i32, ...)* @syscall(i32 19, i32 %60, i32 0, i32 1) nounwind, !dbg !1158
  %62 = add nsw i32 %61, 4096, !dbg !1158
  %63 = sext i32 %62 to i64, !dbg !1158
  store i64 %63, i64* %11, align 4, !dbg !1158
  %64 = icmp sgt i32 %56, 0, !dbg !1159
  br i1 %64, label %bb15, label %bb18, !dbg !1159

bb15:                                             ; preds = %bb14, %bb15
  %pos.023 = phi i32 [ %73, %bb15 ], [ 0, %bb14 ]
  %.sum = add i32 %pos.023, 8
  %65 = getelementptr inbounds i8* %50, i32 %.sum
  %66 = bitcast i8* %65 to i64*, !dbg !1160
  %67 = load i64* %66, align 4, !dbg !1160
  %68 = add nsw i64 %67, 4096, !dbg !1160
  store i64 %68, i64* %66, align 4, !dbg !1160
  %.sum21 = add i32 %pos.023, 16
  %69 = getelementptr inbounds i8* %50, i32 %.sum21
  %70 = bitcast i8* %69 to i16*, !dbg !1161
  %71 = load i16* %70, align 4, !dbg !1161
  %72 = zext i16 %71 to i32, !dbg !1161
  %73 = add nsw i32 %72, %pos.023, !dbg !1161
  %74 = icmp slt i32 %73, %56, !dbg !1159
  br i1 %74, label %bb15, label %bb18, !dbg !1159

bb18:                                             ; preds = %bb14, %bb15, %bb13, %bb9, %bb6, %bb2, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb2 ], [ -1, %bb6 ], [ %47, %bb9 ], [ -1, %bb13 ], [ %56, %bb15 ], [ %56, %bb14 ]
  ret i32 %.0, !dbg !1120
}

declare void @__assert_fail(i8*, i8*, i32, i8*) noreturn nounwind

define i64 @__fd_lseek(i32 %fd, i64 %offset, i32 %whence) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !482), !dbg !1162
  tail call void @llvm.dbg.value(metadata !{i64 %offset}, i64 0, metadata !483), !dbg !1162
  tail call void @llvm.dbg.value(metadata !{i32 %whence}, i64 0, metadata !484), !dbg !1162
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !236), !dbg !1163
  %0 = icmp ult i32 %fd, 32, !dbg !1165
  br i1 %0, label %bb.i, label %bb, !dbg !1165

bb.i:                                             ; preds = %entry
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !237), !dbg !1166
  %1 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 1, !dbg !1167
  %2 = load i32* %1, align 4, !dbg !1167
  %3 = and i32 %2, 1
  %toBool.i = icmp eq i32 %3, 0, !dbg !1167
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !1167

__get_file.exit:                                  ; preds = %bb.i
  %4 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, !dbg !1166
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %4}, i64 0, metadata !487), !dbg !1164
  %5 = icmp eq %struct.exe_file_t* %4, null, !dbg !1168
  br i1 %5, label %bb, label %bb1, !dbg !1168

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %6 = tail call i32* @__errno_location() nounwind readnone, !dbg !1169
  store i32 9, i32* %6, align 4, !dbg !1169
  br label %bb19, !dbg !1170

bb1:                                              ; preds = %__get_file.exit
  %7 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 3, !dbg !1171
  %8 = load %struct.exe_disk_file_t** %7, align 4, !dbg !1171
  %9 = icmp eq %struct.exe_disk_file_t* %8, null, !dbg !1171
  br i1 %9, label %bb2, label %bb11, !dbg !1171

bb2:                                              ; preds = %bb1
  %10 = icmp eq i32 %whence, 0, !dbg !1172
  br i1 %10, label %bb3, label %bb4, !dbg !1172

bb3:                                              ; preds = %bb2
  %11 = trunc i64 %offset to i32, !dbg !1173
  %12 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 0, !dbg !1173
  %13 = load i32* %12, align 4, !dbg !1173
  %14 = tail call i32 (i32, ...)* @syscall(i32 19, i32 %13, i32 %11, i32 0) nounwind, !dbg !1173
  %15 = sext i32 %14 to i64, !dbg !1173
  tail call void @llvm.dbg.value(metadata !{i64 %15}, i64 0, metadata !485), !dbg !1173
  br label %bb8, !dbg !1173

bb4:                                              ; preds = %bb2
  %16 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 2, !dbg !1174
  %17 = load i64* %16, align 4, !dbg !1174
  %18 = trunc i64 %17 to i32, !dbg !1174
  %19 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 0, !dbg !1174
  %20 = load i32* %19, align 4, !dbg !1174
  %21 = tail call i32 (i32, ...)* @syscall(i32 19, i32 %20, i32 %18, i32 0) nounwind, !dbg !1174
  %22 = sext i32 %21 to i64, !dbg !1174
  tail call void @llvm.dbg.value(metadata !{i64 %22}, i64 0, metadata !485), !dbg !1174
  %23 = icmp eq i32 %21, -1, !dbg !1175
  br i1 %23, label %bb8, label %bb5, !dbg !1175

bb5:                                              ; preds = %bb4
  %24 = load i64* %16, align 4, !dbg !1176
  %25 = icmp eq i64 %24, %22, !dbg !1176
  br i1 %25, label %bb7, label %bb6, !dbg !1176

bb6:                                              ; preds = %bb5
  tail call void @__assert_fail(i8* getelementptr inbounds ([18 x i8]* @.str17, i32 0, i32 0), i8* getelementptr inbounds ([5 x i8]* @.str16, i32 0, i32 0), i32 397, i8* getelementptr inbounds ([11 x i8]* @__PRETTY_FUNCTION__.4570, i32 0, i32 0)) noreturn nounwind, !dbg !1176
  unreachable, !dbg !1176

bb7:                                              ; preds = %bb5
  %26 = trunc i64 %offset to i32, !dbg !1177
  %27 = load i32* %19, align 4, !dbg !1177
  %28 = tail call i32 (i32, ...)* @syscall(i32 19, i32 %27, i32 %26, i32 %whence) nounwind, !dbg !1177
  %29 = sext i32 %28 to i64, !dbg !1177
  tail call void @llvm.dbg.value(metadata !{i64 %29}, i64 0, metadata !485), !dbg !1177
  br label %bb8, !dbg !1177

bb8:                                              ; preds = %bb4, %bb7, %bb3
  %new_off.0 = phi i64 [ %15, %bb3 ], [ %29, %bb7 ], [ %22, %bb4 ]
  %30 = icmp eq i64 %new_off.0, -1, !dbg !1178
  br i1 %30, label %bb9, label %bb10, !dbg !1178

bb9:                                              ; preds = %bb8
  %31 = tail call i32* @__errno_location() nounwind readnone, !dbg !1179
  %32 = tail call i32 @klee_get_errno() nounwind, !dbg !1179
  store i32 %32, i32* %31, align 4, !dbg !1179
  br label %bb19, !dbg !1180

bb10:                                             ; preds = %bb8
  %33 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 2, !dbg !1181
  store i64 %new_off.0, i64* %33, align 4, !dbg !1181
  br label %bb19, !dbg !1182

bb11:                                             ; preds = %bb1
  switch i32 %whence, label %bb15 [
    i32 0, label %bb16
    i32 1, label %bb13
    i32 2, label %bb14
  ], !dbg !1183

bb13:                                             ; preds = %bb11
  %34 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 2, !dbg !1184
  %35 = load i64* %34, align 4, !dbg !1184
  %36 = add nsw i64 %35, %offset, !dbg !1184
  tail call void @llvm.dbg.value(metadata !{i64 %36}, i64 0, metadata !485), !dbg !1184
  br label %bb16, !dbg !1184

bb14:                                             ; preds = %bb11
  %37 = getelementptr inbounds %struct.exe_disk_file_t* %8, i32 0, i32 0, !dbg !1185
  %38 = load i32* %37, align 4, !dbg !1185
  %39 = zext i32 %38 to i64, !dbg !1185
  %40 = add nsw i64 %39, %offset, !dbg !1185
  tail call void @llvm.dbg.value(metadata !{i64 %40}, i64 0, metadata !485), !dbg !1185
  br label %bb16, !dbg !1185

bb15:                                             ; preds = %bb11
  %41 = tail call i32* @__errno_location() nounwind readnone, !dbg !1186
  store i32 22, i32* %41, align 4, !dbg !1186
  br label %bb19, !dbg !1187

bb16:                                             ; preds = %bb11, %bb14, %bb13
  %new_off.1 = phi i64 [ %40, %bb14 ], [ %36, %bb13 ], [ %offset, %bb11 ]
  %42 = icmp slt i64 %new_off.1, 0, !dbg !1188
  br i1 %42, label %bb17, label %bb18, !dbg !1188

bb17:                                             ; preds = %bb16
  %43 = tail call i32* @__errno_location() nounwind readnone, !dbg !1189
  store i32 22, i32* %43, align 4, !dbg !1189
  br label %bb19, !dbg !1190

bb18:                                             ; preds = %bb16
  %44 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 2, !dbg !1191
  store i64 %new_off.1, i64* %44, align 4, !dbg !1191
  br label %bb19, !dbg !1192

bb19:                                             ; preds = %bb18, %bb17, %bb15, %bb10, %bb9, %bb
  %.0 = phi i64 [ -1, %bb ], [ -1, %bb9 ], [ %new_off.0, %bb10 ], [ -1, %bb15 ], [ -1, %bb17 ], [ %new_off.1, %bb18 ]
  ret i64 %.0, !dbg !1170
}

define i32 @__fd_fstat(i32 %fd, %struct.stat64* %buf) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !488), !dbg !1193
  tail call void @llvm.dbg.value(metadata !{%struct.stat64* %buf}, i64 0, metadata !489), !dbg !1193
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !236), !dbg !1194
  %0 = icmp ult i32 %fd, 32, !dbg !1196
  br i1 %0, label %bb.i, label %bb, !dbg !1196

bb.i:                                             ; preds = %entry
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !237), !dbg !1197
  %1 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 1, !dbg !1198
  %2 = load i32* %1, align 4, !dbg !1198
  %3 = and i32 %2, 1
  %toBool.i = icmp eq i32 %3, 0, !dbg !1198
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !1198

__get_file.exit:                                  ; preds = %bb.i
  %4 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, !dbg !1197
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %4}, i64 0, metadata !490), !dbg !1195
  %5 = icmp eq %struct.exe_file_t* %4, null, !dbg !1199
  br i1 %5, label %bb, label %bb1, !dbg !1199

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %6 = tail call i32* @__errno_location() nounwind readnone, !dbg !1200
  store i32 9, i32* %6, align 4, !dbg !1200
  br label %bb6, !dbg !1201

bb1:                                              ; preds = %__get_file.exit
  %7 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 3, !dbg !1202
  %8 = load %struct.exe_disk_file_t** %7, align 4, !dbg !1202
  %9 = icmp eq %struct.exe_disk_file_t* %8, null, !dbg !1202
  br i1 %9, label %bb2, label %bb5, !dbg !1202

bb2:                                              ; preds = %bb1
  %10 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 0, !dbg !1203
  %11 = load i32* %10, align 4, !dbg !1203
  %12 = tail call i32 (i32, ...)* @syscall(i32 197, i32 %11, %struct.stat64* %buf) nounwind, !dbg !1203
  tail call void @llvm.dbg.value(metadata !{i32 %12}, i64 0, metadata !492), !dbg !1203
  %13 = icmp eq i32 %12, -1, !dbg !1204
  br i1 %13, label %bb3, label %bb6, !dbg !1204

bb3:                                              ; preds = %bb2
  %14 = tail call i32* @__errno_location() nounwind readnone, !dbg !1205
  %15 = tail call i32 @klee_get_errno() nounwind, !dbg !1205
  store i32 %15, i32* %14, align 4, !dbg !1205
  br label %bb6, !dbg !1205

bb5:                                              ; preds = %bb1
  %16 = getelementptr inbounds %struct.exe_disk_file_t* %8, i32 0, i32 2, !dbg !1206
  %17 = load %struct.stat64** %16, align 4, !dbg !1206
  %18 = bitcast %struct.stat64* %buf to i8*, !dbg !1206
  %19 = bitcast %struct.stat64* %17 to i8*, !dbg !1206
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %18, i8* %19, i32 96, i32 4, i1 false), !dbg !1206
  br label %bb6, !dbg !1207

bb6:                                              ; preds = %bb2, %bb3, %bb5, %bb
  %.0 = phi i32 [ -1, %bb ], [ 0, %bb5 ], [ -1, %bb3 ], [ %12, %bb2 ]
  ret i32 %.0, !dbg !1201
}

define i32 @__fd_lstat(i8* %path, %struct.stat64* %buf) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !494), !dbg !1208
  tail call void @llvm.dbg.value(metadata !{%struct.stat64* %buf}, i64 0, metadata !495), !dbg !1208
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !230), !dbg !1209
  %0 = load i8* %path, align 1, !dbg !1211
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !231), !dbg !1211
  %1 = icmp eq i8 %0, 0, !dbg !1212
  br i1 %1, label %bb1, label %bb.i, !dbg !1212

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i32 1, !dbg !1212
  %3 = load i8* %2, align 1, !dbg !1212
  %4 = icmp eq i8 %3, 0, !dbg !1212
  br i1 %4, label %bb8.preheader.i, label %bb1, !dbg !1212

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 0), align 4, !dbg !1213
  %6 = sext i8 %0 to i32, !dbg !1214
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %17, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !1214
  %8 = add nsw i32 %7, 65, !dbg !1214
  %9 = icmp eq i32 %6, %8, !dbg !1214
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !1214

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 4), align 4, !dbg !1215
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !234), !dbg !1215
  %11 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, i32 2, !dbg !1216
  %12 = load %struct.stat64** %11, align 4, !dbg !1216
  %13 = getelementptr inbounds %struct.stat64* %12, i32 0, i32 15, !dbg !1216
  %14 = load i64* %13, align 4, !dbg !1216
  %15 = icmp eq i64 %14, 0, !dbg !1216
  br i1 %15, label %bb1, label %__get_sym_file.exit, !dbg !1216

bb7.i:                                            ; preds = %bb3.i
  %16 = add i32 %17, 1, !dbg !1213
  br label %bb8.i, !dbg !1213

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %17 = phi i32 [ %16, %bb7.i ], [ 0, %bb8.preheader.i ]
  %18 = icmp ugt i32 %5, %17, !dbg !1213
  br i1 %18, label %bb3.i, label %bb1, !dbg !1213

__get_sym_file.exit:                              ; preds = %bb4.i
  %19 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, !dbg !1215
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %19}, i64 0, metadata !496), !dbg !1210
  %20 = icmp eq %struct.exe_disk_file_t* %19, null, !dbg !1217
  br i1 %20, label %bb1, label %bb, !dbg !1217

bb:                                               ; preds = %__get_sym_file.exit
  %21 = bitcast %struct.stat64* %buf to i8*, !dbg !1218
  %22 = bitcast %struct.stat64* %12 to i8*, !dbg !1218
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %21, i8* %22, i32 96, i32 4, i1 false), !dbg !1218
  br label %bb4, !dbg !1219

bb1:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !312) nounwind, !dbg !1220
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !302) nounwind, !dbg !1222
  %23 = ptrtoint i8* %path to i32, !dbg !1224
  %24 = tail call i32 @klee_get_valuel(i32 %23) nounwind, !dbg !1224
  %25 = inttoptr i32 %24 to i8*, !dbg !1224
  tail call void @llvm.dbg.value(metadata !{i8* %25}, i64 0, metadata !303) nounwind, !dbg !1224
  %26 = icmp eq i8* %25, %path, !dbg !1225
  %27 = zext i1 %26 to i32, !dbg !1225
  tail call void @klee_assume(i32 %27) nounwind, !dbg !1225
  tail call void @llvm.dbg.value(metadata !{i8* %25}, i64 0, metadata !313) nounwind, !dbg !1223
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !315) nounwind, !dbg !1226
  br label %bb.i6, !dbg !1226

bb.i6:                                            ; preds = %bb6.i8, %bb1
  %sc.0.i = phi i8* [ %25, %bb1 ], [ %sc.1.i, %bb6.i8 ]
  %28 = phi i32 [ 0, %bb1 ], [ %40, %bb6.i8 ]
  %tmp.i = add i32 %28, -1
  %29 = load i8* %sc.0.i, align 1, !dbg !1227
  %30 = and i32 %tmp.i, %28, !dbg !1228
  %31 = icmp eq i32 %30, 0, !dbg !1228
  br i1 %31, label %bb1.i, label %bb5.i, !dbg !1228

bb1.i:                                            ; preds = %bb.i6
  switch i8 %29, label %bb6.i8 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i7
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %29}, i64 0, metadata !316) nounwind, !dbg !1227
  store i8 0, i8* %sc.0.i, align 1, !dbg !1229
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !313) nounwind, !dbg !1229
  br label %__concretize_string.exit, !dbg !1229

bb4.i7:                                           ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !1230
  %32 = getelementptr inbounds i8* %sc.0.i, i32 1, !dbg !1230
  br label %bb6.i8, !dbg !1230

bb5.i:                                            ; preds = %bb.i6
  %33 = sext i8 %29 to i32, !dbg !1231
  %34 = tail call i32 @klee_get_valuel(i32 %33) nounwind, !dbg !1231
  %35 = trunc i32 %34 to i8, !dbg !1231
  %36 = icmp eq i8 %35, %29, !dbg !1232
  %37 = zext i1 %36 to i32, !dbg !1232
  tail call void @klee_assume(i32 %37) nounwind, !dbg !1232
  store i8 %35, i8* %sc.0.i, align 1, !dbg !1233
  %38 = getelementptr inbounds i8* %sc.0.i, i32 1, !dbg !1233
  %39 = icmp eq i8 %35, 0, !dbg !1234
  br i1 %39, label %__concretize_string.exit, label %bb6.i8, !dbg !1234

bb6.i8:                                           ; preds = %bb5.i, %bb4.i7, %bb1.i
  %sc.1.i = phi i8* [ %32, %bb4.i7 ], [ %38, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %40 = add i32 %28, 1, !dbg !1226
  br label %bb.i6, !dbg !1226

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %41 = tail call i32 (i32, ...)* @syscall(i32 196, i8* %path, %struct.stat64* %buf) nounwind, !dbg !1221
  tail call void @llvm.dbg.value(metadata !{i32 %41}, i64 0, metadata !498), !dbg !1221
  %42 = icmp eq i32 %41, -1, !dbg !1235
  br i1 %42, label %bb2, label %bb4, !dbg !1235

bb2:                                              ; preds = %__concretize_string.exit
  %43 = tail call i32* @__errno_location() nounwind readnone, !dbg !1236
  %44 = tail call i32 @klee_get_errno() nounwind, !dbg !1236
  store i32 %44, i32* %43, align 4, !dbg !1236
  br label %bb4, !dbg !1236

bb4:                                              ; preds = %__concretize_string.exit, %bb2, %bb
  %.0 = phi i32 [ 0, %bb ], [ -1, %bb2 ], [ %41, %__concretize_string.exit ]
  ret i32 %.0, !dbg !1219
}

define i32 @__fd_stat(i8* %path, %struct.stat64* %buf) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !500), !dbg !1237
  tail call void @llvm.dbg.value(metadata !{%struct.stat64* %buf}, i64 0, metadata !501), !dbg !1237
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !230), !dbg !1238
  %0 = load i8* %path, align 1, !dbg !1240
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !231), !dbg !1240
  %1 = icmp eq i8 %0, 0, !dbg !1241
  br i1 %1, label %bb1, label %bb.i, !dbg !1241

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i32 1, !dbg !1241
  %3 = load i8* %2, align 1, !dbg !1241
  %4 = icmp eq i8 %3, 0, !dbg !1241
  br i1 %4, label %bb8.preheader.i, label %bb1, !dbg !1241

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 0), align 4, !dbg !1242
  %6 = sext i8 %0 to i32, !dbg !1243
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %17, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !1243
  %8 = add nsw i32 %7, 65, !dbg !1243
  %9 = icmp eq i32 %6, %8, !dbg !1243
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !1243

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 4), align 4, !dbg !1244
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !234), !dbg !1244
  %11 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, i32 2, !dbg !1245
  %12 = load %struct.stat64** %11, align 4, !dbg !1245
  %13 = getelementptr inbounds %struct.stat64* %12, i32 0, i32 15, !dbg !1245
  %14 = load i64* %13, align 4, !dbg !1245
  %15 = icmp eq i64 %14, 0, !dbg !1245
  br i1 %15, label %bb1, label %__get_sym_file.exit, !dbg !1245

bb7.i:                                            ; preds = %bb3.i
  %16 = add i32 %17, 1, !dbg !1242
  br label %bb8.i, !dbg !1242

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %17 = phi i32 [ %16, %bb7.i ], [ 0, %bb8.preheader.i ]
  %18 = icmp ugt i32 %5, %17, !dbg !1242
  br i1 %18, label %bb3.i, label %bb1, !dbg !1242

__get_sym_file.exit:                              ; preds = %bb4.i
  %19 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %17, !dbg !1244
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %19}, i64 0, metadata !502), !dbg !1239
  %20 = icmp eq %struct.exe_disk_file_t* %19, null, !dbg !1246
  br i1 %20, label %bb1, label %bb, !dbg !1246

bb:                                               ; preds = %__get_sym_file.exit
  %21 = bitcast %struct.stat64* %buf to i8*, !dbg !1247
  %22 = bitcast %struct.stat64* %12 to i8*, !dbg !1247
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %21, i8* %22, i32 96, i32 4, i1 false), !dbg !1247
  br label %bb4, !dbg !1248

bb1:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !312) nounwind, !dbg !1249
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !302) nounwind, !dbg !1251
  %23 = ptrtoint i8* %path to i32, !dbg !1253
  %24 = tail call i32 @klee_get_valuel(i32 %23) nounwind, !dbg !1253
  %25 = inttoptr i32 %24 to i8*, !dbg !1253
  tail call void @llvm.dbg.value(metadata !{i8* %25}, i64 0, metadata !303) nounwind, !dbg !1253
  %26 = icmp eq i8* %25, %path, !dbg !1254
  %27 = zext i1 %26 to i32, !dbg !1254
  tail call void @klee_assume(i32 %27) nounwind, !dbg !1254
  tail call void @llvm.dbg.value(metadata !{i8* %25}, i64 0, metadata !313) nounwind, !dbg !1252
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !315) nounwind, !dbg !1255
  br label %bb.i6, !dbg !1255

bb.i6:                                            ; preds = %bb6.i8, %bb1
  %sc.0.i = phi i8* [ %25, %bb1 ], [ %sc.1.i, %bb6.i8 ]
  %28 = phi i32 [ 0, %bb1 ], [ %40, %bb6.i8 ]
  %tmp.i = add i32 %28, -1
  %29 = load i8* %sc.0.i, align 1, !dbg !1256
  %30 = and i32 %tmp.i, %28, !dbg !1257
  %31 = icmp eq i32 %30, 0, !dbg !1257
  br i1 %31, label %bb1.i, label %bb5.i, !dbg !1257

bb1.i:                                            ; preds = %bb.i6
  switch i8 %29, label %bb6.i8 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i7
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %29}, i64 0, metadata !316) nounwind, !dbg !1256
  store i8 0, i8* %sc.0.i, align 1, !dbg !1258
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !313) nounwind, !dbg !1258
  br label %__concretize_string.exit, !dbg !1258

bb4.i7:                                           ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !1259
  %32 = getelementptr inbounds i8* %sc.0.i, i32 1, !dbg !1259
  br label %bb6.i8, !dbg !1259

bb5.i:                                            ; preds = %bb.i6
  %33 = sext i8 %29 to i32, !dbg !1260
  %34 = tail call i32 @klee_get_valuel(i32 %33) nounwind, !dbg !1260
  %35 = trunc i32 %34 to i8, !dbg !1260
  %36 = icmp eq i8 %35, %29, !dbg !1261
  %37 = zext i1 %36 to i32, !dbg !1261
  tail call void @klee_assume(i32 %37) nounwind, !dbg !1261
  store i8 %35, i8* %sc.0.i, align 1, !dbg !1262
  %38 = getelementptr inbounds i8* %sc.0.i, i32 1, !dbg !1262
  %39 = icmp eq i8 %35, 0, !dbg !1263
  br i1 %39, label %__concretize_string.exit, label %bb6.i8, !dbg !1263

bb6.i8:                                           ; preds = %bb5.i, %bb4.i7, %bb1.i
  %sc.1.i = phi i8* [ %32, %bb4.i7 ], [ %38, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %40 = add i32 %28, 1, !dbg !1255
  br label %bb.i6, !dbg !1255

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %41 = tail call i32 (i32, ...)* @syscall(i32 195, i8* %path, %struct.stat64* %buf) nounwind, !dbg !1250
  tail call void @llvm.dbg.value(metadata !{i32 %41}, i64 0, metadata !504), !dbg !1250
  %42 = icmp eq i32 %41, -1, !dbg !1264
  br i1 %42, label %bb2, label %bb4, !dbg !1264

bb2:                                              ; preds = %__concretize_string.exit
  %43 = tail call i32* @__errno_location() nounwind readnone, !dbg !1265
  %44 = tail call i32 @klee_get_errno() nounwind, !dbg !1265
  store i32 %44, i32* %43, align 4, !dbg !1265
  br label %bb4, !dbg !1265

bb4:                                              ; preds = %__concretize_string.exit, %bb2, %bb
  %.0 = phi i32 [ 0, %bb ], [ -1, %bb2 ], [ %41, %__concretize_string.exit ]
  ret i32 %.0, !dbg !1248
}

define i32 @read(i32 %fd, i8* %buf, i32 %count) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !506), !dbg !1266
  tail call void @llvm.dbg.value(metadata !{i8* %buf}, i64 0, metadata !507), !dbg !1266
  tail call void @llvm.dbg.value(metadata !{i32 %count}, i64 0, metadata !508), !dbg !1266
  %0 = load i32* @n_calls.4441, align 4, !dbg !1267
  %1 = add nsw i32 %0, 1, !dbg !1267
  store i32 %1, i32* @n_calls.4441, align 4, !dbg !1267
  %2 = icmp eq i32 %count, 0, !dbg !1268
  br i1 %2, label %bb24, label %bb1, !dbg !1268

bb1:                                              ; preds = %entry
  %3 = icmp eq i8* %buf, null, !dbg !1269
  br i1 %3, label %bb2, label %bb3, !dbg !1269

bb2:                                              ; preds = %bb1
  %4 = tail call i32* @__errno_location() nounwind readnone, !dbg !1270
  store i32 14, i32* %4, align 4, !dbg !1270
  br label %bb24, !dbg !1271

bb3:                                              ; preds = %bb1
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !236), !dbg !1272
  %5 = icmp ult i32 %fd, 32, !dbg !1274
  br i1 %5, label %bb.i, label %bb4, !dbg !1274

bb.i:                                             ; preds = %bb3
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !237), !dbg !1275
  %6 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 1, !dbg !1276
  %7 = load i32* %6, align 4, !dbg !1276
  %8 = and i32 %7, 1
  %toBool.i = icmp eq i32 %8, 0, !dbg !1276
  br i1 %toBool.i, label %bb4, label %__get_file.exit, !dbg !1276

__get_file.exit:                                  ; preds = %bb.i
  %9 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, !dbg !1275
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %9}, i64 0, metadata !509), !dbg !1273
  %10 = icmp eq %struct.exe_file_t* %9, null, !dbg !1277
  br i1 %10, label %bb4, label %bb5, !dbg !1277

bb4:                                              ; preds = %bb3, %bb.i, %__get_file.exit
  %11 = tail call i32* @__errno_location() nounwind readnone, !dbg !1278
  store i32 9, i32* %11, align 4, !dbg !1278
  br label %bb24, !dbg !1279

bb5:                                              ; preds = %__get_file.exit
  %12 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 5), align 4, !dbg !1280
  %13 = icmp eq i32 %12, 0, !dbg !1280
  br i1 %13, label %bb8, label %bb6, !dbg !1280

bb6:                                              ; preds = %bb5
  %14 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 6), align 4, !dbg !1280
  %15 = load i32* %14, align 4, !dbg !1280
  %16 = icmp eq i32 %15, %1, !dbg !1280
  br i1 %16, label %bb7, label %bb8, !dbg !1280

bb7:                                              ; preds = %bb6
  %17 = add i32 %12, -1, !dbg !1281
  store i32 %17, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 5), align 4, !dbg !1281
  %18 = tail call i32* @__errno_location() nounwind readnone, !dbg !1282
  store i32 5, i32* %18, align 4, !dbg !1282
  br label %bb24, !dbg !1283

bb8:                                              ; preds = %bb5, %bb6
  %19 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 3, !dbg !1284
  %20 = load %struct.exe_disk_file_t** %19, align 4, !dbg !1284
  %21 = icmp eq %struct.exe_disk_file_t* %20, null, !dbg !1284
  br i1 %21, label %bb9, label %bb17, !dbg !1284

bb9:                                              ; preds = %bb8
  tail call void @llvm.dbg.value(metadata !{i8* %buf}, i64 0, metadata !302) nounwind, !dbg !1285
  %22 = ptrtoint i8* %buf to i32, !dbg !1287
  %23 = tail call i32 @klee_get_valuel(i32 %22) nounwind, !dbg !1287
  %24 = inttoptr i32 %23 to i8*, !dbg !1287
  tail call void @llvm.dbg.value(metadata !{i8* %24}, i64 0, metadata !303) nounwind, !dbg !1287
  %25 = icmp eq i8* %24, %buf, !dbg !1288
  %26 = zext i1 %25 to i32, !dbg !1288
  tail call void @klee_assume(i32 %26) nounwind, !dbg !1288
  tail call void @llvm.dbg.value(metadata !{i8* %24}, i64 0, metadata !507), !dbg !1286
  tail call void @llvm.dbg.value(metadata !{i32 %count}, i64 0, metadata !305) nounwind, !dbg !1289
  %27 = tail call i32 @klee_get_valuel(i32 %count) nounwind, !dbg !1291
  tail call void @llvm.dbg.value(metadata !{i32 %27}, i64 0, metadata !306) nounwind, !dbg !1291
  %28 = icmp eq i32 %27, %count, !dbg !1292
  %29 = zext i1 %28 to i32, !dbg !1292
  tail call void @klee_assume(i32 %29) nounwind, !dbg !1292
  tail call void @llvm.dbg.value(metadata !{i32 %27}, i64 0, metadata !508), !dbg !1290
  tail call void @klee_check_memory_access(i8* %24, i32 %27) nounwind, !dbg !1293
  %30 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 0, !dbg !1294
  %31 = load i32* %30, align 4, !dbg !1294
  %32 = icmp eq i32 %31, 0, !dbg !1294
  br i1 %32, label %bb10, label %bb11, !dbg !1294

bb10:                                             ; preds = %bb9
  %33 = tail call i32 (i32, ...)* @syscall(i32 3, i32 %31, i8* %24, i32 %27) nounwind, !dbg !1295
  tail call void @llvm.dbg.value(metadata !{i32 %33}, i64 0, metadata !511), !dbg !1295
  br label %bb12, !dbg !1295

bb11:                                             ; preds = %bb9
  %34 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 2, !dbg !1296
  %35 = load i64* %34, align 4, !dbg !1296
  %36 = tail call i32 (i32, ...)* @syscall(i32 180, i32 %31, i8* %24, i32 %27, i64 %35) nounwind, !dbg !1296
  tail call void @llvm.dbg.value(metadata !{i32 %36}, i64 0, metadata !511), !dbg !1296
  br label %bb12, !dbg !1296

bb12:                                             ; preds = %bb11, %bb10
  %r.0 = phi i32 [ %33, %bb10 ], [ %36, %bb11 ]
  %37 = icmp eq i32 %r.0, -1, !dbg !1297
  br i1 %37, label %bb13, label %bb14, !dbg !1297

bb13:                                             ; preds = %bb12
  %38 = tail call i32* @__errno_location() nounwind readnone, !dbg !1298
  %39 = tail call i32 @klee_get_errno() nounwind, !dbg !1298
  store i32 %39, i32* %38, align 4, !dbg !1298
  br label %bb24, !dbg !1299

bb14:                                             ; preds = %bb12
  %40 = load i32* %30, align 4, !dbg !1300
  %41 = icmp eq i32 %40, 0, !dbg !1300
  br i1 %41, label %bb24, label %bb15, !dbg !1300

bb15:                                             ; preds = %bb14
  %42 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 2, !dbg !1301
  %43 = load i64* %42, align 4, !dbg !1301
  %44 = sext i32 %r.0 to i64, !dbg !1301
  %45 = add nsw i64 %43, %44, !dbg !1301
  store i64 %45, i64* %42, align 4, !dbg !1301
  br label %bb24, !dbg !1301

bb17:                                             ; preds = %bb8
  %46 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 2, !dbg !1302
  %47 = load i64* %46, align 4, !dbg !1302
  %48 = icmp slt i64 %47, 0, !dbg !1302
  br i1 %48, label %bb18, label %bb19, !dbg !1302

bb18:                                             ; preds = %bb17
  tail call void @__assert_fail(i8* getelementptr inbounds ([12 x i8]* @.str18, i32 0, i32 0), i8* getelementptr inbounds ([5 x i8]* @.str16, i32 0, i32 0), i32 284, i8* getelementptr inbounds ([5 x i8]* @__PRETTY_FUNCTION__.4444, i32 0, i32 0)) noreturn nounwind, !dbg !1302
  unreachable, !dbg !1302

bb19:                                             ; preds = %bb17
  %49 = getelementptr inbounds %struct.exe_disk_file_t* %20, i32 0, i32 0, !dbg !1303
  %50 = load i32* %49, align 4, !dbg !1303
  %51 = zext i32 %50 to i64, !dbg !1303
  %52 = icmp slt i64 %51, %47, !dbg !1303
  br i1 %52, label %bb24, label %bb21, !dbg !1303

bb21:                                             ; preds = %bb19
  %53 = zext i32 %count to i64, !dbg !1304
  %54 = add nsw i64 %47, %53, !dbg !1304
  %55 = icmp sgt i64 %54, %51, !dbg !1304
  %56 = trunc i64 %47 to i32, !dbg !1305
  %57 = sub i32 %50, %56, !dbg !1305
  tail call void @llvm.dbg.value(metadata !{i32 %57}, i64 0, metadata !508), !dbg !1305
  %count_addr.0 = select i1 %55, i32 %57, i32 %count
  %58 = getelementptr inbounds %struct.exe_disk_file_t* %20, i32 0, i32 1, !dbg !1306
  %59 = load i8** %58, align 4, !dbg !1306
  %60 = getelementptr inbounds i8* %59, i32 %56, !dbg !1306
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %buf, i8* %60, i32 %count_addr.0, i32 1, i1 false), !dbg !1306
  %61 = load i64* %46, align 4, !dbg !1307
  %62 = zext i32 %count_addr.0 to i64, !dbg !1307
  %63 = add nsw i64 %61, %62, !dbg !1307
  store i64 %63, i64* %46, align 4, !dbg !1307
  br label %bb24, !dbg !1308

bb24:                                             ; preds = %bb19, %bb15, %bb14, %entry, %bb21, %bb13, %bb7, %bb4, %bb2
  %.0 = phi i32 [ -1, %bb2 ], [ -1, %bb4 ], [ -1, %bb7 ], [ -1, %bb13 ], [ %count_addr.0, %bb21 ], [ 0, %entry ], [ %r.0, %bb14 ], [ %r.0, %bb15 ], [ 0, %bb19 ]
  ret i32 %.0, !dbg !1309
}

declare i32 @geteuid() nounwind

declare i32 @getgid() nounwind

define i32 @fchmod(i32 %fd, i32 %mode) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !515), !dbg !1310
  tail call void @llvm.dbg.value(metadata !{i32 %mode}, i64 0, metadata !516), !dbg !1310
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !236), !dbg !1311
  %0 = icmp ult i32 %fd, 32, !dbg !1313
  br i1 %0, label %bb.i, label %bb, !dbg !1313

bb.i:                                             ; preds = %entry
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !237), !dbg !1314
  %1 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 1, !dbg !1315
  %2 = load i32* %1, align 4, !dbg !1315
  %3 = and i32 %2, 1
  %toBool.i = icmp eq i32 %3, 0, !dbg !1315
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !1315

__get_file.exit:                                  ; preds = %bb.i
  %4 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, !dbg !1314
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %4}, i64 0, metadata !517), !dbg !1312
  %5 = icmp eq %struct.exe_file_t* %4, null, !dbg !1316
  br i1 %5, label %bb, label %bb1, !dbg !1316

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %6 = tail call i32* @__errno_location() nounwind readnone, !dbg !1317
  store i32 9, i32* %6, align 4, !dbg !1317
  br label %bb9, !dbg !1318

bb1:                                              ; preds = %__get_file.exit
  %7 = load i32* @n_calls.4696, align 4, !dbg !1319
  %8 = add nsw i32 %7, 1, !dbg !1319
  store i32 %8, i32* @n_calls.4696, align 4, !dbg !1319
  %9 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 5), align 4, !dbg !1320
  %10 = icmp eq i32 %9, 0, !dbg !1320
  br i1 %10, label %bb4, label %bb2, !dbg !1320

bb2:                                              ; preds = %bb1
  %11 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 12), align 4, !dbg !1320
  %12 = load i32* %11, align 4, !dbg !1320
  %13 = icmp eq i32 %12, %8, !dbg !1320
  br i1 %13, label %bb3, label %bb4, !dbg !1320

bb3:                                              ; preds = %bb2
  %14 = add i32 %9, -1, !dbg !1321
  store i32 %14, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 5), align 4, !dbg !1321
  %15 = tail call i32* @__errno_location() nounwind readnone, !dbg !1322
  store i32 5, i32* %15, align 4, !dbg !1322
  br label %bb9, !dbg !1323

bb4:                                              ; preds = %bb1, %bb2
  %16 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 3, !dbg !1324
  %17 = load %struct.exe_disk_file_t** %16, align 4, !dbg !1324
  %18 = icmp eq %struct.exe_disk_file_t* %17, null, !dbg !1324
  br i1 %18, label %bb6, label %bb5, !dbg !1324

bb5:                                              ; preds = %bb4
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %17}, i64 0, metadata !513) nounwind, !dbg !1325
  tail call void @llvm.dbg.value(metadata !{i32 %mode}, i64 0, metadata !514) nounwind, !dbg !1325
  %19 = tail call i32 @geteuid() nounwind, !dbg !1327
  %20 = getelementptr inbounds %struct.exe_disk_file_t* %17, i32 0, i32 2, !dbg !1327
  %21 = load %struct.stat64** %20, align 4, !dbg !1327
  %22 = getelementptr inbounds %struct.stat64* %21, i32 0, i32 5, !dbg !1327
  %23 = load i32* %22, align 4, !dbg !1327
  %24 = icmp eq i32 %19, %23, !dbg !1327
  br i1 %24, label %bb.i11, label %bb3.i, !dbg !1327

bb.i11:                                           ; preds = %bb5
  %25 = tail call i32 @getgid() nounwind, !dbg !1329
  %26 = load %struct.stat64** %20, align 4, !dbg !1329
  %27 = getelementptr inbounds %struct.stat64* %26, i32 0, i32 6, !dbg !1329
  %28 = load i32* %27, align 4, !dbg !1329
  %29 = and i32 %mode, 3071, !dbg !1330
  %30 = icmp eq i32 %25, %28, !dbg !1329
  %mode..i = select i1 %30, i32 %mode, i32 %29
  %31 = getelementptr inbounds %struct.stat64* %26, i32 0, i32 3, !dbg !1331
  %32 = load i32* %31, align 4, !dbg !1331
  %33 = and i32 %32, -4096, !dbg !1331
  %34 = and i32 %mode..i, 4095, !dbg !1331
  %35 = or i32 %34, %33, !dbg !1331
  store i32 %35, i32* %31, align 4, !dbg !1331
  br label %bb9, !dbg !1332

bb3.i:                                            ; preds = %bb5
  %36 = tail call i32* @__errno_location() nounwind readnone, !dbg !1333
  store i32 1, i32* %36, align 4, !dbg !1333
  br label %bb9, !dbg !1334

bb6:                                              ; preds = %bb4
  %37 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 0, !dbg !1335
  %38 = load i32* %37, align 4, !dbg !1335
  %39 = tail call i32 (i32, ...)* @syscall(i32 94, i32 %38, i32 %mode) nounwind, !dbg !1335
  tail call void @llvm.dbg.value(metadata !{i32 %39}, i64 0, metadata !519), !dbg !1335
  %40 = icmp eq i32 %39, -1, !dbg !1336
  br i1 %40, label %bb7, label %bb9, !dbg !1336

bb7:                                              ; preds = %bb6
  %41 = tail call i32* @__errno_location() nounwind readnone, !dbg !1337
  %42 = tail call i32 @klee_get_errno() nounwind, !dbg !1337
  store i32 %42, i32* %41, align 4, !dbg !1337
  br label %bb9, !dbg !1337

bb9:                                              ; preds = %bb3.i, %bb.i11, %bb6, %bb7, %bb3, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb3 ], [ -1, %bb7 ], [ %39, %bb6 ], [ 0, %bb.i11 ], [ -1, %bb3.i ]
  ret i32 %.0, !dbg !1318
}

define i32 @chmod(i8* %path, i32 %mode) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !521), !dbg !1338
  tail call void @llvm.dbg.value(metadata !{i32 %mode}, i64 0, metadata !522), !dbg !1338
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !230), !dbg !1339
  %0 = load i8* %path, align 1, !dbg !1341
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !231), !dbg !1341
  %1 = icmp eq i8 %0, 0, !dbg !1342
  br i1 %1, label %__get_sym_file.exit, label %bb.i, !dbg !1342

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i32 1, !dbg !1342
  %3 = load i8* %2, align 1, !dbg !1342
  %4 = icmp eq i8 %3, 0, !dbg !1342
  br i1 %4, label %bb8.preheader.i, label %__get_sym_file.exit, !dbg !1342

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 0), align 4, !dbg !1343
  %6 = sext i8 %0 to i32, !dbg !1344
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %18, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !1344
  %8 = add nsw i32 %7, 65, !dbg !1344
  %9 = icmp eq i32 %6, %8, !dbg !1344
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !1344

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 4), align 4, !dbg !1345
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !234), !dbg !1345
  %11 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %18, i32 2, !dbg !1346
  %12 = load %struct.stat64** %11, align 4, !dbg !1346
  %13 = getelementptr inbounds %struct.stat64* %12, i32 0, i32 15, !dbg !1346
  %14 = load i64* %13, align 4, !dbg !1346
  %15 = icmp eq i64 %14, 0, !dbg !1346
  br i1 %15, label %__get_sym_file.exit, label %bb6.i, !dbg !1346

bb6.i:                                            ; preds = %bb4.i
  %16 = getelementptr inbounds %struct.exe_disk_file_t* %10, i32 %18, !dbg !1345
  br label %__get_sym_file.exit, !dbg !1347

bb7.i:                                            ; preds = %bb3.i
  %17 = add i32 %18, 1, !dbg !1343
  br label %bb8.i, !dbg !1343

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %18 = phi i32 [ %17, %bb7.i ], [ 0, %bb8.preheader.i ]
  %19 = icmp ugt i32 %5, %18, !dbg !1343
  br i1 %19, label %bb3.i, label %__get_sym_file.exit, !dbg !1343

__get_sym_file.exit:                              ; preds = %bb8.i, %entry, %bb.i, %bb4.i, %bb6.i
  %.0.i = phi %struct.exe_disk_file_t* [ %16, %bb6.i ], [ null, %bb.i ], [ null, %entry ], [ null, %bb4.i ], [ null, %bb8.i ]
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %.0.i}, i64 0, metadata !523), !dbg !1340
  %20 = load i32* @n_calls.4673, align 4, !dbg !1348
  %21 = add nsw i32 %20, 1, !dbg !1348
  store i32 %21, i32* @n_calls.4673, align 4, !dbg !1348
  %22 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 5), align 4, !dbg !1349
  %23 = icmp eq i32 %22, 0, !dbg !1349
  br i1 %23, label %bb2, label %bb, !dbg !1349

bb:                                               ; preds = %__get_sym_file.exit
  %24 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 11), align 4, !dbg !1349
  %25 = load i32* %24, align 4, !dbg !1349
  %26 = icmp eq i32 %25, %21, !dbg !1349
  br i1 %26, label %bb1, label %bb2, !dbg !1349

bb1:                                              ; preds = %bb
  %27 = add i32 %22, -1, !dbg !1350
  store i32 %27, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 5), align 4, !dbg !1350
  %28 = tail call i32* @__errno_location() nounwind readnone, !dbg !1351
  store i32 5, i32* %28, align 4, !dbg !1351
  br label %bb7, !dbg !1352

bb2:                                              ; preds = %__get_sym_file.exit, %bb
  %29 = icmp eq %struct.exe_disk_file_t* %.0.i, null, !dbg !1353
  br i1 %29, label %bb4, label %bb3, !dbg !1353

bb3:                                              ; preds = %bb2
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %.0.i}, i64 0, metadata !513) nounwind, !dbg !1354
  tail call void @llvm.dbg.value(metadata !{i32 %mode}, i64 0, metadata !514) nounwind, !dbg !1354
  %30 = tail call i32 @geteuid() nounwind, !dbg !1356
  %31 = getelementptr inbounds %struct.exe_disk_file_t* %.0.i, i32 0, i32 2, !dbg !1356
  %32 = load %struct.stat64** %31, align 4, !dbg !1356
  %33 = getelementptr inbounds %struct.stat64* %32, i32 0, i32 5, !dbg !1356
  %34 = load i32* %33, align 4, !dbg !1356
  %35 = icmp eq i32 %30, %34, !dbg !1356
  br i1 %35, label %bb.i13, label %bb3.i14, !dbg !1356

bb.i13:                                           ; preds = %bb3
  %36 = tail call i32 @getgid() nounwind, !dbg !1357
  %37 = load %struct.stat64** %31, align 4, !dbg !1357
  %38 = getelementptr inbounds %struct.stat64* %37, i32 0, i32 6, !dbg !1357
  %39 = load i32* %38, align 4, !dbg !1357
  %40 = and i32 %mode, 3071, !dbg !1358
  %41 = icmp eq i32 %36, %39, !dbg !1357
  %mode..i = select i1 %41, i32 %mode, i32 %40
  %42 = getelementptr inbounds %struct.stat64* %37, i32 0, i32 3, !dbg !1359
  %43 = load i32* %42, align 4, !dbg !1359
  %44 = and i32 %43, -4096, !dbg !1359
  %45 = and i32 %mode..i, 4095, !dbg !1359
  %46 = or i32 %45, %44, !dbg !1359
  store i32 %46, i32* %42, align 4, !dbg !1359
  br label %bb7, !dbg !1360

bb3.i14:                                          ; preds = %bb3
  %47 = tail call i32* @__errno_location() nounwind readnone, !dbg !1361
  store i32 1, i32* %47, align 4, !dbg !1361
  br label %bb7, !dbg !1362

bb4:                                              ; preds = %bb2
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !312) nounwind, !dbg !1363
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !302) nounwind, !dbg !1365
  %48 = ptrtoint i8* %path to i32, !dbg !1367
  %49 = tail call i32 @klee_get_valuel(i32 %48) nounwind, !dbg !1367
  %50 = inttoptr i32 %49 to i8*, !dbg !1367
  tail call void @llvm.dbg.value(metadata !{i8* %50}, i64 0, metadata !303) nounwind, !dbg !1367
  %51 = icmp eq i8* %50, %path, !dbg !1368
  %52 = zext i1 %51 to i32, !dbg !1368
  tail call void @klee_assume(i32 %52) nounwind, !dbg !1368
  tail call void @llvm.dbg.value(metadata !{i8* %50}, i64 0, metadata !313) nounwind, !dbg !1366
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !315) nounwind, !dbg !1369
  br label %bb.i9, !dbg !1369

bb.i9:                                            ; preds = %bb6.i11, %bb4
  %sc.0.i = phi i8* [ %50, %bb4 ], [ %sc.1.i, %bb6.i11 ]
  %53 = phi i32 [ 0, %bb4 ], [ %65, %bb6.i11 ]
  %tmp.i = add i32 %53, -1
  %54 = load i8* %sc.0.i, align 1, !dbg !1370
  %55 = and i32 %tmp.i, %53, !dbg !1371
  %56 = icmp eq i32 %55, 0, !dbg !1371
  br i1 %56, label %bb1.i, label %bb5.i, !dbg !1371

bb1.i:                                            ; preds = %bb.i9
  switch i8 %54, label %bb6.i11 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i10
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %54}, i64 0, metadata !316) nounwind, !dbg !1370
  store i8 0, i8* %sc.0.i, align 1, !dbg !1372
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !313) nounwind, !dbg !1372
  br label %__concretize_string.exit, !dbg !1372

bb4.i10:                                          ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !1373
  %57 = getelementptr inbounds i8* %sc.0.i, i32 1, !dbg !1373
  br label %bb6.i11, !dbg !1373

bb5.i:                                            ; preds = %bb.i9
  %58 = sext i8 %54 to i32, !dbg !1374
  %59 = tail call i32 @klee_get_valuel(i32 %58) nounwind, !dbg !1374
  %60 = trunc i32 %59 to i8, !dbg !1374
  %61 = icmp eq i8 %60, %54, !dbg !1375
  %62 = zext i1 %61 to i32, !dbg !1375
  tail call void @klee_assume(i32 %62) nounwind, !dbg !1375
  store i8 %60, i8* %sc.0.i, align 1, !dbg !1376
  %63 = getelementptr inbounds i8* %sc.0.i, i32 1, !dbg !1376
  %64 = icmp eq i8 %60, 0, !dbg !1377
  br i1 %64, label %__concretize_string.exit, label %bb6.i11, !dbg !1377

bb6.i11:                                          ; preds = %bb5.i, %bb4.i10, %bb1.i
  %sc.1.i = phi i8* [ %57, %bb4.i10 ], [ %63, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %65 = add i32 %53, 1, !dbg !1369
  br label %bb.i9, !dbg !1369

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %66 = tail call i32 (i32, ...)* @syscall(i32 15, i8* %path, i32 %mode) nounwind, !dbg !1364
  tail call void @llvm.dbg.value(metadata !{i32 %66}, i64 0, metadata !525), !dbg !1364
  %67 = icmp eq i32 %66, -1, !dbg !1378
  br i1 %67, label %bb5, label %bb7, !dbg !1378

bb5:                                              ; preds = %__concretize_string.exit
  %68 = tail call i32* @__errno_location() nounwind readnone, !dbg !1379
  %69 = tail call i32 @klee_get_errno() nounwind, !dbg !1379
  store i32 %69, i32* %68, align 4, !dbg !1379
  br label %bb7, !dbg !1379

bb7:                                              ; preds = %bb3.i14, %bb.i13, %__concretize_string.exit, %bb5, %bb1
  %.0 = phi i32 [ -1, %bb1 ], [ -1, %bb5 ], [ %66, %__concretize_string.exit ], [ 0, %bb.i13 ], [ -1, %bb3.i14 ]
  ret i32 %.0, !dbg !1352
}

define i32 @write(i32 %fd, i8* %buf, i32 %count) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !527), !dbg !1380
  tail call void @llvm.dbg.value(metadata !{i8* %buf}, i64 0, metadata !528), !dbg !1380
  tail call void @llvm.dbg.value(metadata !{i32 %count}, i64 0, metadata !529), !dbg !1380
  %0 = load i32* @n_calls.4500, align 4, !dbg !1381
  %1 = add nsw i32 %0, 1, !dbg !1381
  store i32 %1, i32* @n_calls.4500, align 4, !dbg !1381
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !236), !dbg !1382
  %2 = icmp ult i32 %fd, 32, !dbg !1384
  br i1 %2, label %bb.i, label %bb, !dbg !1384

bb.i:                                             ; preds = %entry
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !237), !dbg !1385
  %3 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 1, !dbg !1386
  %4 = load i32* %3, align 4, !dbg !1386
  %5 = and i32 %4, 1
  %toBool.i = icmp eq i32 %5, 0, !dbg !1386
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !1386

__get_file.exit:                                  ; preds = %bb.i
  %6 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, !dbg !1385
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %6}, i64 0, metadata !530), !dbg !1383
  %7 = icmp eq %struct.exe_file_t* %6, null, !dbg !1387
  br i1 %7, label %bb, label %bb1, !dbg !1387

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %8 = tail call i32* @__errno_location() nounwind readnone, !dbg !1388
  store i32 9, i32* %8, align 4, !dbg !1388
  br label %bb28, !dbg !1389

bb1:                                              ; preds = %__get_file.exit
  %9 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 5), align 4, !dbg !1390
  %10 = icmp eq i32 %9, 0, !dbg !1390
  br i1 %10, label %bb4, label %bb2, !dbg !1390

bb2:                                              ; preds = %bb1
  %11 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 7), align 4, !dbg !1390
  %12 = load i32* %11, align 4, !dbg !1390
  %13 = icmp eq i32 %12, %1, !dbg !1390
  br i1 %13, label %bb3, label %bb4, !dbg !1390

bb3:                                              ; preds = %bb2
  %14 = add i32 %9, -1, !dbg !1391
  store i32 %14, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 5), align 4, !dbg !1391
  %15 = tail call i32* @__errno_location() nounwind readnone, !dbg !1392
  store i32 5, i32* %15, align 4, !dbg !1392
  br label %bb28, !dbg !1393

bb4:                                              ; preds = %bb1, %bb2
  %16 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 3, !dbg !1394
  %17 = load %struct.exe_disk_file_t** %16, align 4, !dbg !1394
  %18 = icmp eq %struct.exe_disk_file_t* %17, null, !dbg !1394
  br i1 %18, label %bb5, label %bb15, !dbg !1394

bb5:                                              ; preds = %bb4
  tail call void @llvm.dbg.value(metadata !{i8* %buf}, i64 0, metadata !302) nounwind, !dbg !1395
  %19 = ptrtoint i8* %buf to i32, !dbg !1397
  %20 = tail call i32 @klee_get_valuel(i32 %19) nounwind, !dbg !1397
  %21 = inttoptr i32 %20 to i8*, !dbg !1397
  tail call void @llvm.dbg.value(metadata !{i8* %21}, i64 0, metadata !303) nounwind, !dbg !1397
  %22 = icmp eq i8* %21, %buf, !dbg !1398
  %23 = zext i1 %22 to i32, !dbg !1398
  tail call void @klee_assume(i32 %23) nounwind, !dbg !1398
  tail call void @llvm.dbg.value(metadata !{i8* %21}, i64 0, metadata !528), !dbg !1396
  tail call void @llvm.dbg.value(metadata !{i32 %count}, i64 0, metadata !305) nounwind, !dbg !1399
  %24 = tail call i32 @klee_get_valuel(i32 %count) nounwind, !dbg !1401
  tail call void @llvm.dbg.value(metadata !{i32 %24}, i64 0, metadata !306) nounwind, !dbg !1401
  %25 = icmp eq i32 %24, %count, !dbg !1402
  %26 = zext i1 %25 to i32, !dbg !1402
  tail call void @klee_assume(i32 %26) nounwind, !dbg !1402
  tail call void @llvm.dbg.value(metadata !{i32 %24}, i64 0, metadata !529), !dbg !1400
  tail call void @klee_check_memory_access(i8* %21, i32 %24) nounwind, !dbg !1403
  %27 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 0, !dbg !1404
  %28 = load i32* %27, align 4, !dbg !1404
  %29 = add i32 %28, -1, !dbg !1404
  %30 = icmp ult i32 %29, 2, !dbg !1404
  br i1 %30, label %bb6, label %bb7, !dbg !1404

bb6:                                              ; preds = %bb5
  %31 = tail call i32 (i32, ...)* @syscall(i32 4, i32 %28, i8* %21, i32 %24) nounwind, !dbg !1405
  tail call void @llvm.dbg.value(metadata !{i32 %31}, i64 0, metadata !532), !dbg !1405
  br label %bb8, !dbg !1405

bb7:                                              ; preds = %bb5
  %32 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 2, !dbg !1406
  %33 = load i64* %32, align 4, !dbg !1406
  %34 = tail call i32 (i32, ...)* @syscall(i32 181, i32 %28, i8* %21, i32 %24, i64 %33) nounwind, !dbg !1406
  tail call void @llvm.dbg.value(metadata !{i32 %34}, i64 0, metadata !532), !dbg !1406
  br label %bb8, !dbg !1406

bb8:                                              ; preds = %bb7, %bb6
  %r.0 = phi i32 [ %31, %bb6 ], [ %34, %bb7 ]
  %35 = icmp eq i32 %r.0, -1, !dbg !1407
  br i1 %35, label %bb9, label %bb10, !dbg !1407

bb9:                                              ; preds = %bb8
  %36 = tail call i32* @__errno_location() nounwind readnone, !dbg !1408
  %37 = tail call i32 @klee_get_errno() nounwind, !dbg !1408
  store i32 %37, i32* %36, align 4, !dbg !1408
  br label %bb28, !dbg !1409

bb10:                                             ; preds = %bb8
  %38 = icmp slt i32 %r.0, 0, !dbg !1410
  br i1 %38, label %bb11, label %bb12, !dbg !1410

bb11:                                             ; preds = %bb10
  tail call void @__assert_fail(i8* getelementptr inbounds ([7 x i8]* @.str19, i32 0, i32 0), i8* getelementptr inbounds ([5 x i8]* @.str16, i32 0, i32 0), i32 338, i8* getelementptr inbounds ([6 x i8]* @__PRETTY_FUNCTION__.4503, i32 0, i32 0)) noreturn nounwind, !dbg !1410
  unreachable, !dbg !1410

bb12:                                             ; preds = %bb10
  %39 = load i32* %27, align 4, !dbg !1411
  %40 = add i32 %39, -1, !dbg !1411
  %41 = icmp ugt i32 %40, 1, !dbg !1411
  br i1 %41, label %bb13, label %bb28, !dbg !1411

bb13:                                             ; preds = %bb12
  %42 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 2, !dbg !1412
  %43 = load i64* %42, align 4, !dbg !1412
  %44 = sext i32 %r.0 to i64, !dbg !1412
  %45 = add nsw i64 %43, %44, !dbg !1412
  store i64 %45, i64* %42, align 4, !dbg !1412
  br label %bb28, !dbg !1412

bb15:                                             ; preds = %bb4
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !534), !dbg !1413
  %46 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %fd, i32 2, !dbg !1414
  %47 = load i64* %46, align 4, !dbg !1414
  %48 = zext i32 %count to i64, !dbg !1414
  %49 = add nsw i64 %47, %48, !dbg !1414
  %50 = getelementptr inbounds %struct.exe_disk_file_t* %17, i32 0, i32 0, !dbg !1414
  %51 = load i32* %50, align 4, !dbg !1414
  %52 = zext i32 %51 to i64, !dbg !1414
  %53 = icmp sgt i64 %49, %52, !dbg !1414
  br i1 %53, label %bb17, label %bb21, !dbg !1414

bb17:                                             ; preds = %bb15
  %54 = load i32* getelementptr inbounds (%struct.exe_sym_env_t* @__exe_env, i32 0, i32 3), align 4, !dbg !1415
  %55 = icmp eq i32 %54, 0, !dbg !1415
  br i1 %55, label %bb19, label %bb18, !dbg !1415

bb18:                                             ; preds = %bb17
  tail call void @__assert_fail(i8* getelementptr inbounds ([2 x i8]* @.str20, i32 0, i32 0), i8* getelementptr inbounds ([5 x i8]* @.str16, i32 0, i32 0), i32 351, i8* getelementptr inbounds ([6 x i8]* @__PRETTY_FUNCTION__.4503, i32 0, i32 0)) noreturn nounwind, !dbg !1416
  unreachable, !dbg !1416

bb19:                                             ; preds = %bb17
  %56 = icmp slt i64 %47, %52, !dbg !1417
  br i1 %56, label %bb20, label %bb23, !dbg !1417

bb20:                                             ; preds = %bb19
  %57 = trunc i64 %47 to i32, !dbg !1418
  %58 = sub i32 %51, %57, !dbg !1418
  tail call void @llvm.dbg.value(metadata !{i32 %58}, i64 0, metadata !534), !dbg !1418
  br label %bb21, !dbg !1418

bb21:                                             ; preds = %bb15, %bb20
  %actual_count.0 = phi i32 [ %58, %bb20 ], [ %count, %bb15 ]
  %59 = icmp eq i32 %actual_count.0, 0, !dbg !1419
  br i1 %59, label %bb23, label %bb22, !dbg !1419

bb22:                                             ; preds = %bb21
  %60 = getelementptr inbounds %struct.exe_disk_file_t* %17, i32 0, i32 1, !dbg !1420
  %61 = load i8** %60, align 4, !dbg !1420
  %62 = trunc i64 %47 to i32, !dbg !1420
  %63 = getelementptr inbounds i8* %61, i32 %62, !dbg !1420
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %63, i8* %buf, i32 %actual_count.0, i32 1, i1 false), !dbg !1420
  br label %bb23, !dbg !1420

bb23:                                             ; preds = %bb19, %bb21, %bb22
  %actual_count.030 = phi i32 [ 0, %bb21 ], [ %actual_count.0, %bb22 ], [ 0, %bb19 ]
  %64 = icmp eq i32 %actual_count.030, %count, !dbg !1421
  br i1 %64, label %bb25, label %bb24, !dbg !1421

bb24:                                             ; preds = %bb23
  %65 = load %struct._IO_FILE** @stderr, align 4, !dbg !1422
  %66 = bitcast %struct._IO_FILE* %65 to i8*, !dbg !1422
  %67 = tail call i32 @fwrite(i8* getelementptr inbounds ([33 x i8]* @.str21, i32 0, i32 0), i32 1, i32 32, i8* %66) nounwind, !dbg !1422
  br label %bb25, !dbg !1422

bb25:                                             ; preds = %bb23, %bb24
  %68 = load %struct.exe_disk_file_t** %16, align 4, !dbg !1423
  %69 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 2), align 4, !dbg !1423
  %70 = icmp eq %struct.exe_disk_file_t* %68, %69, !dbg !1423
  br i1 %70, label %bb26, label %bb27, !dbg !1423

bb26:                                             ; preds = %bb25
  %71 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 3), align 4, !dbg !1424
  %72 = add i32 %71, %actual_count.030, !dbg !1424
  store i32 %72, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 3), align 4, !dbg !1424
  br label %bb27, !dbg !1424

bb27:                                             ; preds = %bb25, %bb26
  %73 = load i64* %46, align 4, !dbg !1425
  %74 = add nsw i64 %73, %48, !dbg !1425
  store i64 %74, i64* %46, align 4, !dbg !1425
  br label %bb28, !dbg !1426

bb28:                                             ; preds = %bb12, %bb13, %bb27, %bb9, %bb3, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb3 ], [ -1, %bb9 ], [ %count, %bb27 ], [ %r.0, %bb13 ], [ %r.0, %bb12 ]
  ret i32 %.0, !dbg !1389
}

declare i32 @fwrite(i8* nocapture, i32, i32, i8* nocapture) nounwind

define i32 @__fd_open(i8* %pathname, i32 %flags, i32 %mode) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !536), !dbg !1427
  tail call void @llvm.dbg.value(metadata !{i32 %flags}, i64 0, metadata !537), !dbg !1427
  tail call void @llvm.dbg.value(metadata !{i32 %mode}, i64 0, metadata !538), !dbg !1427
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !542), !dbg !1428
  br label %bb2, !dbg !1428

bb:                                               ; preds = %bb2
  %scevgep = getelementptr %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %4, i32 1
  %0 = load i32* %scevgep, align 4, !dbg !1429
  %1 = and i32 %0, 1, !dbg !1429
  %2 = icmp eq i32 %1, 0, !dbg !1429
  br i1 %2, label %bb5, label %bb1, !dbg !1429

bb1:                                              ; preds = %bb
  %3 = add nsw i32 %4, 1, !dbg !1428
  br label %bb2, !dbg !1428

bb2:                                              ; preds = %bb1, %entry
  %4 = phi i32 [ 0, %entry ], [ %3, %bb1 ]
  %5 = icmp slt i32 %4, 32, !dbg !1428
  br i1 %5, label %bb, label %bb3, !dbg !1428

bb3:                                              ; preds = %bb2
  %6 = icmp eq i32 %4, 32, !dbg !1430
  br i1 %6, label %bb4, label %bb5, !dbg !1430

bb4:                                              ; preds = %bb3
  %7 = tail call i32* @__errno_location() nounwind readnone, !dbg !1431
  store i32 24, i32* %7, align 4, !dbg !1431
  br label %bb25, !dbg !1432

bb5:                                              ; preds = %bb, %bb3
  %8 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %4, !dbg !1433
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %8}, i64 0, metadata !541), !dbg !1433
  %9 = bitcast %struct.exe_file_t* %8 to i8*, !dbg !1434
  tail call void @llvm.memset.p0i8.i32(i8* %9, i8 0, i32 20, i32 4, i1 false), !dbg !1434
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !230), !dbg !1435
  %10 = load i8* %pathname, align 1, !dbg !1437
  tail call void @llvm.dbg.value(metadata !{i8 %10}, i64 0, metadata !231), !dbg !1437
  %11 = icmp eq i8 %10, 0, !dbg !1438
  br i1 %11, label %bb16, label %bb.i, !dbg !1438

bb.i:                                             ; preds = %bb5
  %12 = getelementptr inbounds i8* %pathname, i32 1, !dbg !1438
  %13 = load i8* %12, align 1, !dbg !1438
  %14 = icmp eq i8 %13, 0, !dbg !1438
  br i1 %14, label %bb8.preheader.i, label %bb16, !dbg !1438

bb8.preheader.i:                                  ; preds = %bb.i
  %15 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 0), align 4, !dbg !1439
  %16 = sext i8 %10 to i32, !dbg !1440
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %27, 24
  %17 = ashr exact i32 %sext.i, 24, !dbg !1440
  %18 = add nsw i32 %17, 65, !dbg !1440
  %19 = icmp eq i32 %16, %18, !dbg !1440
  br i1 %19, label %bb4.i, label %bb7.i, !dbg !1440

bb4.i:                                            ; preds = %bb3.i
  %20 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i32 0, i32 4), align 4, !dbg !1441
  tail call void @llvm.dbg.value(metadata !553, i64 0, metadata !234), !dbg !1441
  %21 = getelementptr inbounds %struct.exe_disk_file_t* %20, i32 %27, i32 2, !dbg !1442
  %22 = load %struct.stat64** %21, align 4, !dbg !1442
  %23 = getelementptr inbounds %struct.stat64* %22, i32 0, i32 15, !dbg !1442
  %24 = load i64* %23, align 4, !dbg !1442
  %25 = icmp eq i64 %24, 0, !dbg !1442
  br i1 %25, label %bb16, label %__get_sym_file.exit, !dbg !1442

bb7.i:                                            ; preds = %bb3.i
  %26 = add i32 %27, 1, !dbg !1439
  br label %bb8.i, !dbg !1439

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %27 = phi i32 [ %26, %bb7.i ], [ 0, %bb8.preheader.i ]
  %28 = icmp ugt i32 %15, %27, !dbg !1439
  br i1 %28, label %bb3.i, label %bb16, !dbg !1439

__get_sym_file.exit:                              ; preds = %bb4.i
  %29 = getelementptr inbounds %struct.exe_disk_file_t* %20, i32 %27, !dbg !1441
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %29}, i64 0, metadata !539), !dbg !1436
  %30 = icmp eq %struct.exe_disk_file_t* %29, null, !dbg !1443
  br i1 %30, label %bb16, label %bb6, !dbg !1443

bb6:                                              ; preds = %__get_sym_file.exit
  %31 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %4, i32 3, !dbg !1444
  store %struct.exe_disk_file_t* %29, %struct.exe_disk_file_t** %31, align 4, !dbg !1444
  %32 = and i32 %flags, 192
  switch i32 %32, label %bb12 [
    i32 192, label %bb8
    i32 128, label %bb11
  ]

bb8:                                              ; preds = %bb6
  %33 = tail call i32* @__errno_location() nounwind readnone, !dbg !1445
  store i32 17, i32* %33, align 4, !dbg !1445
  br label %bb25, !dbg !1446

bb11:                                             ; preds = %bb6
  %34 = load %struct._IO_FILE** @stderr, align 4, !dbg !1447
  %35 = bitcast %struct._IO_FILE* %34 to i8*, !dbg !1447
  %36 = tail call i32 @fwrite(i8* getelementptr inbounds ([47 x i8]* @.str22, i32 0, i32 0), i32 1, i32 46, i8* %35) nounwind, !dbg !1447
  %37 = tail call i32* @__errno_location() nounwind readnone, !dbg !1448
  store i32 13, i32* %37, align 4, !dbg !1448
  br label %bb25, !dbg !1449

bb12:                                             ; preds = %bb6
  %38 = load %struct.stat64** %21, align 4, !dbg !1450
  tail call void @llvm.dbg.value(metadata !{i32 %flags}, i64 0, metadata !243), !dbg !1451
  tail call void @llvm.dbg.value(metadata !{%struct.stat64* %38}, i64 0, metadata !244), !dbg !1451
  %39 = getelementptr inbounds %struct.stat64* %38, i32 0, i32 3, !dbg !1452
  %40 = load i32* %39, align 4, !dbg !1452
  tail call void @llvm.dbg.value(metadata !{i32 %40}, i64 0, metadata !248), !dbg !1452
  %41 = and i32 %flags, 2, !dbg !1453
  %42 = icmp eq i32 %41, 0, !dbg !1453
  %43 = and i32 %flags, 3
  %44 = icmp eq i32 %43, 0
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !245), !dbg !1454
  br i1 %42, label %bb9.i, label %bb7.i34, !dbg !1455

bb7.i34:                                          ; preds = %bb12
  %45 = and i32 %40, 292, !dbg !1455
  %46 = icmp eq i32 %45, 0, !dbg !1455
  br i1 %46, label %bb9.i, label %bb13, !dbg !1455

bb9.i:                                            ; preds = %bb7.i34, %bb12
  br i1 %44, label %bb14, label %bb10.i, !dbg !1456

bb10.i:                                           ; preds = %bb9.i
  %47 = and i32 %40, 146, !dbg !1456
  %48 = icmp eq i32 %47, 0, !dbg !1456
  br i1 %48, label %bb13, label %bb14, !dbg !1456

bb13:                                             ; preds = %bb7.i34, %bb10.i
  %49 = tail call i32* @__errno_location() nounwind readnone, !dbg !1457
  store i32 13, i32* %49, align 4, !dbg !1457
  br label %bb25, !dbg !1458

bb14:                                             ; preds = %bb10.i, %bb9.i
  %50 = and i32 %40, -512, !dbg !1459
  %51 = load i32* getelementptr inbounds (%struct.exe_sym_env_t* @__exe_env, i32 0, i32 1), align 4, !dbg !1459
  %not = xor i32 %51, -1, !dbg !1459
  %52 = and i32 %not, %mode, !dbg !1459
  %53 = or i32 %52, %50, !dbg !1459
  store i32 %53, i32* %39, align 4, !dbg !1459
  br label %bb19, !dbg !1459

bb16:                                             ; preds = %bb8.i, %bb4.i, %bb5, %bb.i, %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !312) nounwind, !dbg !1460
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !302) nounwind, !dbg !1462
  %54 = ptrtoint i8* %pathname to i32, !dbg !1464
  %55 = tail call i32 @klee_get_valuel(i32 %54) nounwind, !dbg !1464
  %56 = inttoptr i32 %55 to i8*, !dbg !1464
  tail call void @llvm.dbg.value(metadata !{i8* %56}, i64 0, metadata !303) nounwind, !dbg !1464
  %57 = icmp eq i8* %56, %pathname, !dbg !1465
  %58 = zext i1 %57 to i32, !dbg !1465
  tail call void @klee_assume(i32 %58) nounwind, !dbg !1465
  tail call void @llvm.dbg.value(metadata !{i8* %56}, i64 0, metadata !313) nounwind, !dbg !1463
  tail call void @llvm.dbg.value(metadata !562, i64 0, metadata !315) nounwind, !dbg !1466
  br label %bb.i30, !dbg !1466

bb.i30:                                           ; preds = %bb6.i32, %bb16
  %sc.0.i = phi i8* [ %56, %bb16 ], [ %sc.1.i, %bb6.i32 ]
  %59 = phi i32 [ 0, %bb16 ], [ %71, %bb6.i32 ]
  %tmp.i = add i32 %59, -1
  %60 = load i8* %sc.0.i, align 1, !dbg !1467
  %61 = and i32 %tmp.i, %59, !dbg !1468
  %62 = icmp eq i32 %61, 0, !dbg !1468
  br i1 %62, label %bb1.i, label %bb5.i, !dbg !1468

bb1.i:                                            ; preds = %bb.i30
  switch i8 %60, label %bb6.i32 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i31
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %60}, i64 0, metadata !316) nounwind, !dbg !1467
  store i8 0, i8* %sc.0.i, align 1, !dbg !1469
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !313) nounwind, !dbg !1469
  br label %__concretize_string.exit, !dbg !1469

bb4.i31:                                          ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !1470
  %63 = getelementptr inbounds i8* %sc.0.i, i32 1, !dbg !1470
  br label %bb6.i32, !dbg !1470

bb5.i:                                            ; preds = %bb.i30
  %64 = sext i8 %60 to i32, !dbg !1471
  %65 = tail call i32 @klee_get_valuel(i32 %64) nounwind, !dbg !1471
  %66 = trunc i32 %65 to i8, !dbg !1471
  %67 = icmp eq i8 %66, %60, !dbg !1472
  %68 = zext i1 %67 to i32, !dbg !1472
  tail call void @klee_assume(i32 %68) nounwind, !dbg !1472
  store i8 %66, i8* %sc.0.i, align 1, !dbg !1473
  %69 = getelementptr inbounds i8* %sc.0.i, i32 1, !dbg !1473
  %70 = icmp eq i8 %66, 0, !dbg !1474
  br i1 %70, label %__concretize_string.exit, label %bb6.i32, !dbg !1474

bb6.i32:                                          ; preds = %bb5.i, %bb4.i31, %bb1.i
  %sc.1.i = phi i8* [ %63, %bb4.i31 ], [ %69, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %71 = add i32 %59, 1, !dbg !1466
  br label %bb.i30, !dbg !1466

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %72 = tail call i32 (i32, ...)* @syscall(i32 5, i8* %pathname, i32 %flags, i32 %mode) nounwind, !dbg !1461
  tail call void @llvm.dbg.value(metadata !{i32 %72}, i64 0, metadata !543), !dbg !1461
  %73 = icmp eq i32 %72, -1, !dbg !1475
  br i1 %73, label %bb17, label %bb18, !dbg !1475

bb17:                                             ; preds = %__concretize_string.exit
  %74 = tail call i32* @__errno_location() nounwind readnone, !dbg !1476
  %75 = tail call i32 @klee_get_errno() nounwind, !dbg !1476
  store i32 %75, i32* %74, align 4, !dbg !1476
  br label %bb25, !dbg !1477

bb18:                                             ; preds = %__concretize_string.exit
  %76 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %4, i32 0, !dbg !1478
  store i32 %72, i32* %76, align 4, !dbg !1478
  %.pre = and i32 %flags, 3, !dbg !1479
  br label %bb19, !dbg !1478

bb19:                                             ; preds = %bb18, %bb14
  %.pre-phi = phi i32 [ %.pre, %bb18 ], [ %43, %bb14 ]
  %77 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i32 0, i32 0, i32 %4, i32 1, !dbg !1480
  store i32 1, i32* %77, align 4, !dbg !1480
  switch i32 %.pre-phi, label %bb23 [
    i32 0, label %bb20
    i32 1, label %bb22
  ]

bb20:                                             ; preds = %bb19
  store i32 5, i32* %77, align 4, !dbg !1481
  br label %bb25, !dbg !1481

bb22:                                             ; preds = %bb19
  store i32 9, i32* %77, align 4, !dbg !1482
  br label %bb25, !dbg !1482

bb23:                                             ; preds = %bb19
  store i32 13, i32* %77, align 4, !dbg !1483
  br label %bb25, !dbg !1483

bb25:                                             ; preds = %bb20, %bb22, %bb23, %bb17, %bb13, %bb11, %bb8, %bb4
  %.0 = phi i32 [ -1, %bb4 ], [ -1, %bb8 ], [ -1, %bb11 ], [ -1, %bb13 ], [ -1, %bb17 ], [ %4, %bb23 ], [ %4, %bb22 ], [ %4, %bb20 ]
  ret i32 %.0, !dbg !1432
}

!llvm.dbg.sp = !{!0, !59, !73, !77, !80, !83, !84, !85, !90, !95, !98, !129, !132, !135, !136, !140, !143, !146, !149, !152, !155, !156, !157, !160, !180, !181, !184, !185, !186, !189, !206, !209, !210, !213, !214, !217, !220, !223, !226, !227}
!llvm.dbg.lv.__get_sym_file = !{!230, !231, !233, !234}
!llvm.dbg.lv.__get_file = !{!236, !237}
!llvm.dbg.lv.umask = !{!240, !241}
!llvm.dbg.lv.has_permission = !{!243, !244, !245, !247, !248}
!llvm.dbg.lv.chroot = !{!249}
!llvm.dbg.lv.unlink = !{!250, !251}
!llvm.dbg.lv.rmdir = !{!253, !254}
!llvm.dbg.lv.__df_chown = !{!256, !257, !258}
!llvm.dbg.lv.readlink = !{!259, !260, !261, !262, !264}
!llvm.dbg.lv.fsync = !{!266, !267, !269}
!llvm.dbg.lv.fstatfs = !{!271, !272, !273, !275}
!llvm.dbg.lv.__fd_ftruncate = !{!277, !278, !279, !281}
!llvm.dbg.gv = !{!283, !284, !285, !286, !287, !288, !289}
!llvm.dbg.lv.fchown = !{!290, !291, !292, !293, !295}
!llvm.dbg.lv.fchdir = !{!297, !298, !300}
!llvm.dbg.lv.__concretize_ptr = !{!302, !303}
!llvm.dbg.lv.__concretize_size = !{!305, !306}
!llvm.dbg.lv.getcwd = !{!308, !309, !310}
!llvm.dbg.lv.__concretize_string = !{!312, !313, !315, !316, !318}
!llvm.dbg.lv.__fd_statfs = !{!320, !321, !322, !324}
!llvm.dbg.lv.lchown = !{!326, !327, !328, !329, !331}
!llvm.dbg.lv.chown = !{!333, !334, !335, !336, !338}
!llvm.dbg.lv.chdir = !{!340, !341, !343}
!llvm.dbg.lv.access = !{!345, !346, !347, !349}
!llvm.dbg.lv.select = !{!351, !352, !353, !354, !355, !356, !358, !359, !360, !361, !362, !363, !364, !365, !366, !368, !370, !371}
!llvm.dbg.lv.close = !{!373, !374, !376}
!llvm.dbg.lv.dup2 = !{!377, !378, !379, !381}
!llvm.dbg.lv.dup = !{!383, !384, !386}
!llvm.dbg.lv.fcntl = !{!388, !389, !390, !392, !395, !396, !398}
!llvm.dbg.lv.ioctl = !{!400, !401, !402, !404, !405, !406, !430, !448, !458, !461}
!llvm.dbg.lv.__fd_getdents = !{!463, !464, !465, !466, !468, !470, !471, !472, !474, !476, !477, !478, !480}
!llvm.dbg.lv.__fd_lseek = !{!482, !483, !484, !485, !487}
!llvm.dbg.lv.__fd_fstat = !{!488, !489, !490, !492}
!llvm.dbg.lv.__fd_lstat = !{!494, !495, !496, !498}
!llvm.dbg.lv.__fd_stat = !{!500, !501, !502, !504}
!llvm.dbg.lv.read = !{!506, !507, !508, !509, !511}
!llvm.dbg.lv.__df_chmod = !{!513, !514}
!llvm.dbg.lv.fchmod = !{!515, !516, !517, !519}
!llvm.dbg.lv.chmod = !{!521, !522, !523, !525}
!llvm.dbg.lv.write = !{!527, !528, !529, !530, !532, !534}
!llvm.dbg.lv.__fd_open = !{!536, !537, !538, !539, !541, !542, !543}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__get_sym_file", metadata !"__get_sym_file", metadata !"", metadata !1, i32 39, metadata !3, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"fd.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/POSIX/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"fd.c", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/POSIX/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !57}
!5 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !6} ; [ DW_TAG_pointer_type ]
!6 = metadata !{i32 589846, metadata !7, metadata !"exe_disk_file_t", metadata !7, i32 26, i64 0, i64 0, i64 0, i32 0, metadata !8} ; [ DW_TAG_typedef ]
!7 = metadata !{i32 589865, metadata !"fd.h", metadata !"/home/gfj/project/src/klee_symbolic_execution/runtime/POSIX/", metadata !2} ; [ DW_TAG_file_type ]
!8 = metadata !{i32 589843, metadata !1, metadata !"", metadata !7, i32 20, i64 96, i64 32, i64 0, i32 0, null, metadata !9, i32 0, null} ; [ DW_TAG_structure_type ]
!9 = metadata !{metadata !10, metadata !12, metadata !15}
!10 = metadata !{i32 589837, metadata !8, metadata !"size", metadata !7, i32 21, i64 32, i64 32, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ]
!11 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!12 = metadata !{i32 589837, metadata !8, metadata !"contents", metadata !7, i32 22, i64 32, i64 32, i64 32, i32 0, metadata !13} ; [ DW_TAG_member ]
!13 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !14} ; [ DW_TAG_pointer_type ]
!14 = metadata !{i32 589860, metadata !1, metadata !"char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!15 = metadata !{i32 589837, metadata !8, metadata !"stat", metadata !7, i32 23, i64 32, i64 32, i64 64, i32 0, metadata !16} ; [ DW_TAG_member ]
!16 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !17} ; [ DW_TAG_pointer_type ]
!17 = metadata !{i32 589843, metadata !1, metadata !"stat64", metadata !7, i32 23, i64 768, i64 32, i64 0, i32 0, null, metadata !18, i32 0, null} ; [ DW_TAG_structure_type ]
!18 = metadata !{metadata !19, metadata !24, metadata !25, metadata !28, metadata !30, metadata !32, metadata !34, metadata !36, metadata !37, metadata !38, metadata !41, metadata !44, metadata !46, metadata !53, metadata !54, metadata !55}
!19 = metadata !{i32 589837, metadata !17, metadata !"st_dev", metadata !20, i32 98, i64 64, i64 64, i64 0, i32 0, metadata !21} ; [ DW_TAG_member ]
!20 = metadata !{i32 589865, metadata !"stat.h", metadata !"/usr/include/i386-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!21 = metadata !{i32 589846, metadata !22, metadata !"__dev_t", metadata !22, i32 135, i64 0, i64 0, i64 0, i32 0, metadata !23} ; [ DW_TAG_typedef ]
!22 = metadata !{i32 589865, metadata !"types.h", metadata !"/usr/include/i386-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!23 = metadata !{i32 589860, metadata !1, metadata !"long long unsigned int", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!24 = metadata !{i32 589837, metadata !17, metadata !"__pad1", metadata !20, i32 99, i64 32, i64 32, i64 64, i32 0, metadata !11} ; [ DW_TAG_member ]
!25 = metadata !{i32 589837, metadata !17, metadata !"__st_ino", metadata !20, i32 101, i64 32, i64 32, i64 96, i32 0, metadata !26} ; [ DW_TAG_member ]
!26 = metadata !{i32 589846, metadata !22, metadata !"__ino_t", metadata !22, i32 138, i64 0, i64 0, i64 0, i32 0, metadata !27} ; [ DW_TAG_typedef ]
!27 = metadata !{i32 589860, metadata !1, metadata !"long unsigned int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!28 = metadata !{i32 589837, metadata !17, metadata !"st_mode", metadata !20, i32 102, i64 32, i64 32, i64 128, i32 0, metadata !29} ; [ DW_TAG_member ]
!29 = metadata !{i32 589846, metadata !22, metadata !"__mode_t", metadata !22, i32 140, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!30 = metadata !{i32 589837, metadata !17, metadata !"st_nlink", metadata !20, i32 103, i64 32, i64 32, i64 160, i32 0, metadata !31} ; [ DW_TAG_member ]
!31 = metadata !{i32 589846, metadata !22, metadata !"__nlink_t", metadata !22, i32 141, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!32 = metadata !{i32 589837, metadata !17, metadata !"st_uid", metadata !20, i32 104, i64 32, i64 32, i64 192, i32 0, metadata !33} ; [ DW_TAG_member ]
!33 = metadata !{i32 589846, metadata !22, metadata !"__uid_t", metadata !22, i32 136, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!34 = metadata !{i32 589837, metadata !17, metadata !"st_gid", metadata !20, i32 105, i64 32, i64 32, i64 224, i32 0, metadata !35} ; [ DW_TAG_member ]
!35 = metadata !{i32 589846, metadata !22, metadata !"__gid_t", metadata !22, i32 137, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!36 = metadata !{i32 589837, metadata !17, metadata !"st_rdev", metadata !20, i32 106, i64 64, i64 64, i64 256, i32 0, metadata !21} ; [ DW_TAG_member ]
!37 = metadata !{i32 589837, metadata !17, metadata !"__pad2", metadata !20, i32 107, i64 32, i64 32, i64 320, i32 0, metadata !11} ; [ DW_TAG_member ]
!38 = metadata !{i32 589837, metadata !17, metadata !"st_size", metadata !20, i32 108, i64 64, i64 64, i64 352, i32 0, metadata !39} ; [ DW_TAG_member ]
!39 = metadata !{i32 589846, metadata !22, metadata !"__off64_t", metadata !22, i32 143, i64 0, i64 0, i64 0, i32 0, metadata !40} ; [ DW_TAG_typedef ]
!40 = metadata !{i32 589860, metadata !1, metadata !"long long int", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!41 = metadata !{i32 589837, metadata !17, metadata !"st_blksize", metadata !20, i32 109, i64 32, i64 32, i64 416, i32 0, metadata !42} ; [ DW_TAG_member ]
!42 = metadata !{i32 589846, metadata !22, metadata !"__blksize_t", metadata !22, i32 169, i64 0, i64 0, i64 0, i32 0, metadata !43} ; [ DW_TAG_typedef ]
!43 = metadata !{i32 589860, metadata !1, metadata !"long int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!44 = metadata !{i32 589837, metadata !17, metadata !"st_blocks", metadata !20, i32 111, i64 64, i64 64, i64 448, i32 0, metadata !45} ; [ DW_TAG_member ]
!45 = metadata !{i32 589846, metadata !22, metadata !"__blkcnt64_t", metadata !22, i32 173, i64 0, i64 0, i64 0, i32 0, metadata !40} ; [ DW_TAG_typedef ]
!46 = metadata !{i32 589837, metadata !17, metadata !"st_atim", metadata !20, i32 119, i64 64, i64 32, i64 512, i32 0, metadata !47} ; [ DW_TAG_member ]
!47 = metadata !{i32 589843, metadata !1, metadata !"timespec", metadata !48, i32 121, i64 64, i64 32, i64 0, i32 0, null, metadata !49, i32 0, null} ; [ DW_TAG_structure_type ]
!48 = metadata !{i32 589865, metadata !"time.h", metadata !"/usr/include", metadata !2} ; [ DW_TAG_file_type ]
!49 = metadata !{metadata !50, metadata !52}
!50 = metadata !{i32 589837, metadata !47, metadata !"tv_sec", metadata !48, i32 122, i64 32, i64 32, i64 0, i32 0, metadata !51} ; [ DW_TAG_member ]
!51 = metadata !{i32 589846, metadata !22, metadata !"__time_t", metadata !22, i32 150, i64 0, i64 0, i64 0, i32 0, metadata !43} ; [ DW_TAG_typedef ]
!52 = metadata !{i32 589837, metadata !47, metadata !"tv_nsec", metadata !48, i32 123, i64 32, i64 32, i64 32, i32 0, metadata !43} ; [ DW_TAG_member ]
!53 = metadata !{i32 589837, metadata !17, metadata !"st_mtim", metadata !20, i32 120, i64 64, i64 32, i64 576, i32 0, metadata !47} ; [ DW_TAG_member ]
!54 = metadata !{i32 589837, metadata !17, metadata !"st_ctim", metadata !20, i32 121, i64 64, i64 32, i64 640, i32 0, metadata !47} ; [ DW_TAG_member ]
!55 = metadata !{i32 589837, metadata !17, metadata !"st_ino", metadata !20, i32 130, i64 64, i64 64, i64 704, i32 0, metadata !56} ; [ DW_TAG_member ]
!56 = metadata !{i32 589846, metadata !22, metadata !"__ino64_t", metadata !22, i32 139, i64 0, i64 0, i64 0, i32 0, metadata !23} ; [ DW_TAG_typedef ]
!57 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !58} ; [ DW_TAG_pointer_type ]
!58 = metadata !{i32 589862, metadata !1, metadata !"", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !14} ; [ DW_TAG_const_type ]
!59 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__get_file", metadata !"__get_file", metadata !"", metadata !1, i32 63, metadata !60, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!60 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !61, i32 0, null} ; [ DW_TAG_subroutine_type ]
!61 = metadata !{metadata !62, metadata !67}
!62 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !63} ; [ DW_TAG_pointer_type ]
!63 = metadata !{i32 589846, metadata !7, metadata !"exe_file_t", metadata !7, i32 42, i64 0, i64 0, i64 0, i32 0, metadata !64} ; [ DW_TAG_typedef ]
!64 = metadata !{i32 589843, metadata !1, metadata !"", metadata !7, i32 33, i64 160, i64 32, i64 0, i32 0, null, metadata !65, i32 0, null} ; [ DW_TAG_structure_type ]
!65 = metadata !{metadata !66, metadata !68, metadata !69, metadata !72}
!66 = metadata !{i32 589837, metadata !64, metadata !"fd", metadata !7, i32 34, i64 32, i64 32, i64 0, i32 0, metadata !67} ; [ DW_TAG_member ]
!67 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!68 = metadata !{i32 589837, metadata !64, metadata !"flags", metadata !7, i32 35, i64 32, i64 32, i64 32, i32 0, metadata !11} ; [ DW_TAG_member ]
!69 = metadata !{i32 589837, metadata !64, metadata !"off", metadata !7, i32 38, i64 64, i64 64, i64 64, i32 0, metadata !70} ; [ DW_TAG_member ]
!70 = metadata !{i32 589846, metadata !71, metadata !"off64_t", metadata !71, i32 99, i64 0, i64 0, i64 0, i32 0, metadata !40} ; [ DW_TAG_typedef ]
!71 = metadata !{i32 589865, metadata !"types.h", metadata !"/usr/include/i386-linux-gnu/sys", metadata !2} ; [ DW_TAG_file_type ]
!72 = metadata !{i32 589837, metadata !64, metadata !"dfile", metadata !7, i32 39, i64 32, i64 32, i64 128, i32 0, metadata !5} ; [ DW_TAG_member ]
!73 = metadata !{i32 589870, i32 0, metadata !1, metadata !"umask", metadata !"umask", metadata !"umask", metadata !1, i32 88, metadata !74, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32)* @umask} ; [ DW_TAG_subprogram ]
!74 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !75, i32 0, null} ; [ DW_TAG_subroutine_type ]
!75 = metadata !{metadata !76, metadata !76}
!76 = metadata !{i32 589846, metadata !71, metadata !"mode_t", metadata !71, i32 76, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!77 = metadata !{i32 589870, i32 0, metadata !1, metadata !"has_permission", metadata !"has_permission", metadata !"", metadata !1, i32 97, metadata !78, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!78 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !79, i32 0, null} ; [ DW_TAG_subroutine_type ]
!79 = metadata !{metadata !67, metadata !67, metadata !16}
!80 = metadata !{i32 589870, i32 0, metadata !1, metadata !"chroot", metadata !"chroot", metadata !"chroot", metadata !1, i32 1294, metadata !81, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*)* @chroot} ; [ DW_TAG_subprogram ]
!81 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !82, i32 0, null} ; [ DW_TAG_subroutine_type ]
!82 = metadata !{metadata !67, metadata !57}
!83 = metadata !{i32 589870, i32 0, metadata !1, metadata !"unlink", metadata !"unlink", metadata !"unlink", metadata !1, i32 1078, metadata !81, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*)* @unlink} ; [ DW_TAG_subprogram ]
!84 = metadata !{i32 589870, i32 0, metadata !1, metadata !"rmdir", metadata !"rmdir", metadata !"rmdir", metadata !1, i32 1060, metadata !81, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*)* @rmdir} ; [ DW_TAG_subprogram ]
!85 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__df_chown", metadata !"__df_chown", metadata !"", metadata !1, i32 569, metadata !86, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!86 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !87, i32 0, null} ; [ DW_TAG_subroutine_type ]
!87 = metadata !{metadata !67, metadata !5, metadata !88, metadata !89}
!88 = metadata !{i32 589846, metadata !71, metadata !"uid_t", metadata !71, i32 87, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!89 = metadata !{i32 589846, metadata !71, metadata !"gid_t", metadata !71, i32 71, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!90 = metadata !{i32 589870, i32 0, metadata !1, metadata !"readlink", metadata !"readlink", metadata !"readlink", metadata !1, i32 1099, metadata !91, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, i8*, i32)* @readlink} ; [ DW_TAG_subprogram ]
!91 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !92, i32 0, null} ; [ DW_TAG_subroutine_type ]
!92 = metadata !{metadata !93, metadata !57, metadata !13, metadata !94}
!93 = metadata !{i32 589846, metadata !71, metadata !"ssize_t", metadata !71, i32 116, i64 0, i64 0, i64 0, i32 0, metadata !67} ; [ DW_TAG_typedef ]
!94 = metadata !{i32 589846, metadata !71, metadata !"size_t", metadata !71, i32 151, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!95 = metadata !{i32 589870, i32 0, metadata !1, metadata !"fsync", metadata !"fsync", metadata !"fsync", metadata !1, i32 1000, metadata !96, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32)* @fsync} ; [ DW_TAG_subprogram ]
!96 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !97, i32 0, null} ; [ DW_TAG_subroutine_type ]
!97 = metadata !{metadata !67, metadata !67}
!98 = metadata !{i32 589870, i32 0, metadata !1, metadata !"fstatfs", metadata !"fstatfs", metadata !"fstatfs", metadata !1, i32 980, metadata !99, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, %struct.statfs*)* @fstatfs} ; [ DW_TAG_subprogram ]
!99 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !100, i32 0, null} ; [ DW_TAG_subroutine_type ]
!100 = metadata !{metadata !67, metadata !67, metadata !101}
!101 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !102} ; [ DW_TAG_pointer_type ]
!102 = metadata !{i32 589843, metadata !1, metadata !"statfs", metadata !103, i32 26, i64 512, i64 32, i64 0, i32 0, null, metadata !104, i32 0, null} ; [ DW_TAG_structure_type ]
!103 = metadata !{i32 589865, metadata !"statfs.h", metadata !"/usr/include/i386-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!104 = metadata !{metadata !105, metadata !106, metadata !107, metadata !109, metadata !110, metadata !111, metadata !113, metadata !114, metadata !122, metadata !123, metadata !124, metadata !125}
!105 = metadata !{i32 589837, metadata !102, metadata !"f_type", metadata !103, i32 27, i64 32, i64 32, i64 0, i32 0, metadata !67} ; [ DW_TAG_member ]
!106 = metadata !{i32 589837, metadata !102, metadata !"f_bsize", metadata !103, i32 28, i64 32, i64 32, i64 32, i32 0, metadata !67} ; [ DW_TAG_member ]
!107 = metadata !{i32 589837, metadata !102, metadata !"f_blocks", metadata !103, i32 30, i64 32, i64 32, i64 64, i32 0, metadata !108} ; [ DW_TAG_member ]
!108 = metadata !{i32 589846, metadata !22, metadata !"__fsblkcnt_t", metadata !22, i32 174, i64 0, i64 0, i64 0, i32 0, metadata !27} ; [ DW_TAG_typedef ]
!109 = metadata !{i32 589837, metadata !102, metadata !"f_bfree", metadata !103, i32 31, i64 32, i64 32, i64 96, i32 0, metadata !108} ; [ DW_TAG_member ]
!110 = metadata !{i32 589837, metadata !102, metadata !"f_bavail", metadata !103, i32 32, i64 32, i64 32, i64 128, i32 0, metadata !108} ; [ DW_TAG_member ]
!111 = metadata !{i32 589837, metadata !102, metadata !"f_files", metadata !103, i32 33, i64 32, i64 32, i64 160, i32 0, metadata !112} ; [ DW_TAG_member ]
!112 = metadata !{i32 589846, metadata !22, metadata !"__fsfilcnt_t", metadata !22, i32 178, i64 0, i64 0, i64 0, i32 0, metadata !27} ; [ DW_TAG_typedef ]
!113 = metadata !{i32 589837, metadata !102, metadata !"f_ffree", metadata !103, i32 34, i64 32, i64 32, i64 192, i32 0, metadata !112} ; [ DW_TAG_member ]
!114 = metadata !{i32 589837, metadata !102, metadata !"f_fsid", metadata !103, i32 42, i64 64, i64 32, i64 224, i32 0, metadata !115} ; [ DW_TAG_member ]
!115 = metadata !{i32 589846, metadata !22, metadata !"__fsid_t", metadata !22, i32 145, i64 0, i64 0, i64 0, i32 0, metadata !116} ; [ DW_TAG_typedef ]
!116 = metadata !{i32 589843, metadata !1, metadata !"", metadata !22, i32 144, i64 64, i64 32, i64 0, i32 0, null, metadata !117, i32 0, null} ; [ DW_TAG_structure_type ]
!117 = metadata !{metadata !118}
!118 = metadata !{i32 589837, metadata !116, metadata !"__val", metadata !22, i32 144, i64 64, i64 32, i64 0, i32 0, metadata !119} ; [ DW_TAG_member ]
!119 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 32, i64 0, i32 0, metadata !67, metadata !120, i32 0, null} ; [ DW_TAG_array_type ]
!120 = metadata !{metadata !121}
!121 = metadata !{i32 589857, i64 0, i64 1}       ; [ DW_TAG_subrange_type ]
!122 = metadata !{i32 589837, metadata !102, metadata !"f_namelen", metadata !103, i32 43, i64 32, i64 32, i64 288, i32 0, metadata !67} ; [ DW_TAG_member ]
!123 = metadata !{i32 589837, metadata !102, metadata !"f_frsize", metadata !103, i32 44, i64 32, i64 32, i64 320, i32 0, metadata !67} ; [ DW_TAG_member ]
!124 = metadata !{i32 589837, metadata !102, metadata !"f_flags", metadata !103, i32 45, i64 32, i64 32, i64 352, i32 0, metadata !67} ; [ DW_TAG_member ]
!125 = metadata !{i32 589837, metadata !102, metadata !"f_spare", metadata !103, i32 46, i64 128, i64 32, i64 384, i32 0, metadata !126} ; [ DW_TAG_member ]
!126 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 128, i64 32, i64 0, i32 0, metadata !67, metadata !127, i32 0, null} ; [ DW_TAG_array_type ]
!127 = metadata !{metadata !128}
!128 = metadata !{i32 589857, i64 0, i64 3}       ; [ DW_TAG_subrange_type ]
!129 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fd_ftruncate", metadata !"__fd_ftruncate", metadata !"__fd_ftruncate", metadata !1, i32 643, metadata !130, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i64)* @__fd_ftruncate} ; [ DW_TAG_subprogram ]
!130 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !131, i32 0, null} ; [ DW_TAG_subroutine_type ]
!131 = metadata !{metadata !67, metadata !67, metadata !70}
!132 = metadata !{i32 589870, i32 0, metadata !1, metadata !"fchown", metadata !"fchown", metadata !"fchown", metadata !1, i32 588, metadata !133, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i32, i32)* @fchown} ; [ DW_TAG_subprogram ]
!133 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !134, i32 0, null} ; [ DW_TAG_subroutine_type ]
!134 = metadata !{metadata !67, metadata !67, metadata !88, metadata !89}
!135 = metadata !{i32 589870, i32 0, metadata !1, metadata !"fchdir", metadata !"fchdir", metadata !"fchdir", metadata !1, i32 486, metadata !96, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32)* @fchdir} ; [ DW_TAG_subprogram ]
!136 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__concretize_ptr", metadata !"__concretize_ptr", metadata !"", metadata !1, i32 1252, metadata !137, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!137 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !138, i32 0, null} ; [ DW_TAG_subroutine_type ]
!138 = metadata !{metadata !139, metadata !139}
!139 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!140 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__concretize_size", metadata !"__concretize_size", metadata !"", metadata !1, i32 1259, metadata !141, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!141 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !142, i32 0, null} ; [ DW_TAG_subroutine_type ]
!142 = metadata !{metadata !94, metadata !94}
!143 = metadata !{i32 589870, i32 0, metadata !1, metadata !"getcwd", metadata !"getcwd", metadata !"getcwd", metadata !1, i32 1217, metadata !144, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i32)* @getcwd} ; [ DW_TAG_subprogram ]
!144 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !145, i32 0, null} ; [ DW_TAG_subroutine_type ]
!145 = metadata !{metadata !13, metadata !13, metadata !94}
!146 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__concretize_string", metadata !"__concretize_string", metadata !"", metadata !1, i32 1265, metadata !147, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!147 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !148, i32 0, null} ; [ DW_TAG_subroutine_type ]
!148 = metadata !{metadata !57, metadata !57}
!149 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fd_statfs", metadata !"__fd_statfs", metadata !"__fd_statfs", metadata !1, i32 963, metadata !150, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, %struct.statfs*)* @__fd_statfs} ; [ DW_TAG_subprogram ]
!150 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !151, i32 0, null} ; [ DW_TAG_subroutine_type ]
!151 = metadata !{metadata !67, metadata !57, metadata !101}
!152 = metadata !{i32 589870, i32 0, metadata !1, metadata !"lchown", metadata !"lchown", metadata !"lchown", metadata !1, i32 606, metadata !153, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, i32, i32)* @lchown} ; [ DW_TAG_subprogram ]
!153 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !154, i32 0, null} ; [ DW_TAG_subroutine_type ]
!154 = metadata !{metadata !67, metadata !57, metadata !88, metadata !89}
!155 = metadata !{i32 589870, i32 0, metadata !1, metadata !"chown", metadata !"chown", metadata !"chown", metadata !1, i32 575, metadata !153, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, i32, i32)* @chown} ; [ DW_TAG_subprogram ]
!156 = metadata !{i32 589870, i32 0, metadata !1, metadata !"chdir", metadata !"chdir", metadata !"chdir", metadata !1, i32 468, metadata !81, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*)* @chdir} ; [ DW_TAG_subprogram ]
!157 = metadata !{i32 589870, i32 0, metadata !1, metadata !"access", metadata !"access", metadata !"access", metadata !1, i32 73, metadata !158, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, i32)* @access} ; [ DW_TAG_subprogram ]
!158 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !159, i32 0, null} ; [ DW_TAG_subroutine_type ]
!159 = metadata !{metadata !67, metadata !57, metadata !67}
!160 = metadata !{i32 589870, i32 0, metadata !1, metadata !"select", metadata !"select", metadata !"select", metadata !1, i32 1132, metadata !161, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, %struct.fd_set*, %struct.fd_set*, %struct.fd_set*, %struct.timespec*)* @select} ; [ DW_TAG_subprogram ]
!161 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !162, i32 0, null} ; [ DW_TAG_subroutine_type ]
!162 = metadata !{metadata !67, metadata !67, metadata !163, metadata !163, metadata !163, metadata !173}
!163 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !164} ; [ DW_TAG_pointer_type ]
!164 = metadata !{i32 589846, metadata !165, metadata !"fd_set", metadata !165, i32 83, i64 0, i64 0, i64 0, i32 0, metadata !166} ; [ DW_TAG_typedef ]
!165 = metadata !{i32 589865, metadata !"select.h", metadata !"/usr/include/i386-linux-gnu/sys", metadata !2} ; [ DW_TAG_file_type ]
!166 = metadata !{i32 589843, metadata !1, metadata !"", metadata !165, i32 66, i64 1024, i64 32, i64 0, i32 0, null, metadata !167, i32 0, null} ; [ DW_TAG_structure_type ]
!167 = metadata !{metadata !168}
!168 = metadata !{i32 589837, metadata !166, metadata !"fds_bits", metadata !165, i32 70, i64 1024, i64 32, i64 0, i32 0, metadata !169} ; [ DW_TAG_member ]
!169 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 1024, i64 32, i64 0, i32 0, metadata !170, metadata !171, i32 0, null} ; [ DW_TAG_array_type ]
!170 = metadata !{i32 589846, metadata !165, metadata !"__fd_mask", metadata !165, i32 66, i64 0, i64 0, i64 0, i32 0, metadata !43} ; [ DW_TAG_typedef ]
!171 = metadata !{metadata !172}
!172 = metadata !{i32 589857, i64 0, i64 31}      ; [ DW_TAG_subrange_type ]
!173 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !174} ; [ DW_TAG_pointer_type ]
!174 = metadata !{i32 589843, metadata !1, metadata !"timeval", metadata !175, i32 32, i64 64, i64 32, i64 0, i32 0, null, metadata !176, i32 0, null} ; [ DW_TAG_structure_type ]
!175 = metadata !{i32 589865, metadata !"time.h", metadata !"/usr/include/i386-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!176 = metadata !{metadata !177, metadata !178}
!177 = metadata !{i32 589837, metadata !174, metadata !"tv_sec", metadata !175, i32 33, i64 32, i64 32, i64 0, i32 0, metadata !51} ; [ DW_TAG_member ]
!178 = metadata !{i32 589837, metadata !174, metadata !"tv_usec", metadata !175, i32 34, i64 32, i64 32, i64 32, i32 0, metadata !179} ; [ DW_TAG_member ]
!179 = metadata !{i32 589846, metadata !22, metadata !"__suseconds_t", metadata !22, i32 153, i64 0, i64 0, i64 0, i32 0, metadata !43} ; [ DW_TAG_typedef ]
!180 = metadata !{i32 589870, i32 0, metadata !1, metadata !"close", metadata !"close", metadata !"close", metadata !1, i32 201, metadata !96, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32)* @close} ; [ DW_TAG_subprogram ]
!181 = metadata !{i32 589870, i32 0, metadata !1, metadata !"dup2", metadata !"dup2", metadata !"dup2", metadata !1, i32 1016, metadata !182, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i32)* @dup2} ; [ DW_TAG_subprogram ]
!182 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !183, i32 0, null} ; [ DW_TAG_subroutine_type ]
!183 = metadata !{metadata !67, metadata !67, metadata !67}
!184 = metadata !{i32 589870, i32 0, metadata !1, metadata !"dup", metadata !"dup", metadata !"dup", metadata !1, i32 1041, metadata !96, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32)* @dup} ; [ DW_TAG_subprogram ]
!185 = metadata !{i32 589870, i32 0, metadata !1, metadata !"fcntl", metadata !"fcntl", metadata !"fcntl", metadata !1, i32 908, metadata !182, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i32, ...)* @fcntl} ; [ DW_TAG_subprogram ]
!186 = metadata !{i32 589870, i32 0, metadata !1, metadata !"ioctl", metadata !"ioctl", metadata !"ioctl", metadata !1, i32 760, metadata !187, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i32, ...)* @ioctl} ; [ DW_TAG_subprogram ]
!187 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !188, i32 0, null} ; [ DW_TAG_subroutine_type ]
!188 = metadata !{metadata !67, metadata !67, metadata !27}
!189 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fd_getdents", metadata !"__fd_getdents", metadata !"__fd_getdents", metadata !1, i32 676, metadata !190, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, %struct.dirent64*, i32)* @__fd_getdents} ; [ DW_TAG_subprogram ]
!190 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !191, i32 0, null} ; [ DW_TAG_subroutine_type ]
!191 = metadata !{metadata !67, metadata !11, metadata !192, metadata !11}
!192 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !193} ; [ DW_TAG_pointer_type ]
!193 = metadata !{i32 589843, metadata !1, metadata !"dirent64", metadata !194, i32 39, i64 2208, i64 32, i64 0, i32 0, null, metadata !195, i32 0, null} ; [ DW_TAG_structure_type ]
!194 = metadata !{i32 589865, metadata !"dirent.h", metadata !"/usr/include/i386-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!195 = metadata !{metadata !196, metadata !197, metadata !198, metadata !200, metadata !202}
!196 = metadata !{i32 589837, metadata !193, metadata !"d_ino", metadata !194, i32 40, i64 64, i64 64, i64 0, i32 0, metadata !56} ; [ DW_TAG_member ]
!197 = metadata !{i32 589837, metadata !193, metadata !"d_off", metadata !194, i32 41, i64 64, i64 64, i64 64, i32 0, metadata !39} ; [ DW_TAG_member ]
!198 = metadata !{i32 589837, metadata !193, metadata !"d_reclen", metadata !194, i32 42, i64 16, i64 16, i64 128, i32 0, metadata !199} ; [ DW_TAG_member ]
!199 = metadata !{i32 589860, metadata !1, metadata !"short unsigned int", metadata !1, i32 0, i64 16, i64 16, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!200 = metadata !{i32 589837, metadata !193, metadata !"d_type", metadata !194, i32 43, i64 8, i64 8, i64 144, i32 0, metadata !201} ; [ DW_TAG_member ]
!201 = metadata !{i32 589860, metadata !1, metadata !"unsigned char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 8} ; [ DW_TAG_base_type ]
!202 = metadata !{i32 589837, metadata !193, metadata !"d_name", metadata !194, i32 44, i64 2048, i64 8, i64 152, i32 0, metadata !203} ; [ DW_TAG_member ]
!203 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 2048, i64 8, i64 0, i32 0, metadata !14, metadata !204, i32 0, null} ; [ DW_TAG_array_type ]
!204 = metadata !{metadata !205}
!205 = metadata !{i32 589857, i64 0, i64 255}     ; [ DW_TAG_subrange_type ]
!206 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fd_lseek", metadata !"__fd_lseek", metadata !"__fd_lseek", metadata !1, i32 373, metadata !207, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i64 (i32, i64, i32)* @__fd_lseek} ; [ DW_TAG_subprogram ]
!207 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !208, i32 0, null} ; [ DW_TAG_subroutine_type ]
!208 = metadata !{metadata !70, metadata !67, metadata !70, metadata !67}
!209 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fd_fstat", metadata !"__fd_fstat", metadata !"__fd_fstat", metadata !1, i32 620, metadata !78, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, %struct.stat64*)* @__fd_fstat} ; [ DW_TAG_subprogram ]
!210 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fd_lstat", metadata !"__fd_lstat", metadata !"__fd_lstat", metadata !1, i32 449, metadata !211, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, %struct.stat64*)* @__fd_lstat} ; [ DW_TAG_subprogram ]
!211 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !212, i32 0, null} ; [ DW_TAG_subroutine_type ]
!212 = metadata !{metadata !67, metadata !57, metadata !16}
!213 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fd_stat", metadata !"__fd_stat", metadata !"__fd_stat", metadata !1, i32 430, metadata !211, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, %struct.stat64*)* @__fd_stat} ; [ DW_TAG_subprogram ]
!214 = metadata !{i32 589870, i32 0, metadata !1, metadata !"read", metadata !"read", metadata !"read", metadata !1, i32 233, metadata !215, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i8*, i32)* @read} ; [ DW_TAG_subprogram ]
!215 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !216, i32 0, null} ; [ DW_TAG_subroutine_type ]
!216 = metadata !{metadata !93, metadata !67, metadata !139, metadata !94}
!217 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__df_chmod", metadata !"__df_chmod", metadata !"", metadata !1, i32 507, metadata !218, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!218 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !219, i32 0, null} ; [ DW_TAG_subroutine_type ]
!219 = metadata !{metadata !67, metadata !5, metadata !76}
!220 = metadata !{i32 589870, i32 0, metadata !1, metadata !"fchmod", metadata !"fchmod", metadata !"fchmod", metadata !1, i32 542, metadata !221, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i32)* @fchmod} ; [ DW_TAG_subprogram ]
!221 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !222, i32 0, null} ; [ DW_TAG_subroutine_type ]
!222 = metadata !{metadata !67, metadata !67, metadata !76}
!223 = metadata !{i32 589870, i32 0, metadata !1, metadata !"chmod", metadata !"chmod", metadata !"chmod", metadata !1, i32 520, metadata !224, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, i32)* @chmod} ; [ DW_TAG_subprogram ]
!224 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !225, i32 0, null} ; [ DW_TAG_subroutine_type ]
!225 = metadata !{metadata !67, metadata !57, metadata !76}
!226 = metadata !{i32 589870, i32 0, metadata !1, metadata !"write", metadata !"write", metadata !"write", metadata !1, i32 301, metadata !215, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i8*, i32)* @write} ; [ DW_TAG_subprogram ]
!227 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fd_open", metadata !"__fd_open", metadata !"__fd_open", metadata !1, i32 128, metadata !228, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, i32, i32)* @__fd_open} ; [ DW_TAG_subprogram ]
!228 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !229, i32 0, null} ; [ DW_TAG_subroutine_type ]
!229 = metadata !{metadata !67, metadata !57, metadata !67, metadata !76}
!230 = metadata !{i32 590081, metadata !0, metadata !"pathname", metadata !1, i32 39, metadata !57, i32 0} ; [ DW_TAG_arg_variable ]
!231 = metadata !{i32 590080, metadata !232, metadata !"c", metadata !1, i32 40, metadata !14, i32 0} ; [ DW_TAG_auto_variable ]
!232 = metadata !{i32 589835, metadata !0, i32 39, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!233 = metadata !{i32 590080, metadata !232, metadata !"i", metadata !1, i32 41, metadata !11, i32 0} ; [ DW_TAG_auto_variable ]
!234 = metadata !{i32 590080, metadata !235, metadata !"df", metadata !1, i32 48, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!235 = metadata !{i32 589835, metadata !232, i32 48, i32 0, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!236 = metadata !{i32 590081, metadata !59, metadata !"fd", metadata !1, i32 63, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!237 = metadata !{i32 590080, metadata !238, metadata !"f", metadata !1, i32 65, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!238 = metadata !{i32 589835, metadata !239, i32 63, i32 0, metadata !1, i32 3} ; [ DW_TAG_lexical_block ]
!239 = metadata !{i32 589835, metadata !59, i32 63, i32 0, metadata !1, i32 2} ; [ DW_TAG_lexical_block ]
!240 = metadata !{i32 590081, metadata !73, metadata !"mask", metadata !1, i32 88, metadata !76, i32 0} ; [ DW_TAG_arg_variable ]
!241 = metadata !{i32 590080, metadata !242, metadata !"r", metadata !1, i32 89, metadata !76, i32 0} ; [ DW_TAG_auto_variable ]
!242 = metadata !{i32 589835, metadata !73, i32 88, i32 0, metadata !1, i32 4} ; [ DW_TAG_lexical_block ]
!243 = metadata !{i32 590081, metadata !77, metadata !"flags", metadata !1, i32 97, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!244 = metadata !{i32 590081, metadata !77, metadata !"s", metadata !1, i32 97, metadata !16, i32 0} ; [ DW_TAG_arg_variable ]
!245 = metadata !{i32 590080, metadata !246, metadata !"write_access", metadata !1, i32 98, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!246 = metadata !{i32 589835, metadata !77, i32 97, i32 0, metadata !1, i32 5} ; [ DW_TAG_lexical_block ]
!247 = metadata !{i32 590080, metadata !246, metadata !"read_access", metadata !1, i32 98, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!248 = metadata !{i32 590080, metadata !246, metadata !"mode", metadata !1, i32 99, metadata !76, i32 0} ; [ DW_TAG_auto_variable ]
!249 = metadata !{i32 590081, metadata !80, metadata !"path", metadata !1, i32 1294, metadata !57, i32 0} ; [ DW_TAG_arg_variable ]
!250 = metadata !{i32 590081, metadata !83, metadata !"pathname", metadata !1, i32 1078, metadata !57, i32 0} ; [ DW_TAG_arg_variable ]
!251 = metadata !{i32 590080, metadata !252, metadata !"dfile", metadata !1, i32 1079, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!252 = metadata !{i32 589835, metadata !83, i32 1078, i32 0, metadata !1, i32 7} ; [ DW_TAG_lexical_block ]
!253 = metadata !{i32 590081, metadata !84, metadata !"pathname", metadata !1, i32 1060, metadata !57, i32 0} ; [ DW_TAG_arg_variable ]
!254 = metadata !{i32 590080, metadata !255, metadata !"dfile", metadata !1, i32 1061, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!255 = metadata !{i32 589835, metadata !84, i32 1060, i32 0, metadata !1, i32 8} ; [ DW_TAG_lexical_block ]
!256 = metadata !{i32 590081, metadata !85, metadata !"df", metadata !1, i32 569, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!257 = metadata !{i32 590081, metadata !85, metadata !"owner", metadata !1, i32 569, metadata !88, i32 0} ; [ DW_TAG_arg_variable ]
!258 = metadata !{i32 590081, metadata !85, metadata !"group", metadata !1, i32 569, metadata !89, i32 0} ; [ DW_TAG_arg_variable ]
!259 = metadata !{i32 590081, metadata !90, metadata !"path", metadata !1, i32 1099, metadata !57, i32 0} ; [ DW_TAG_arg_variable ]
!260 = metadata !{i32 590081, metadata !90, metadata !"buf", metadata !1, i32 1099, metadata !13, i32 0} ; [ DW_TAG_arg_variable ]
!261 = metadata !{i32 590081, metadata !90, metadata !"bufsize", metadata !1, i32 1099, metadata !94, i32 0} ; [ DW_TAG_arg_variable ]
!262 = metadata !{i32 590080, metadata !263, metadata !"dfile", metadata !1, i32 1100, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!263 = metadata !{i32 589835, metadata !90, i32 1099, i32 0, metadata !1, i32 10} ; [ DW_TAG_lexical_block ]
!264 = metadata !{i32 590080, metadata !265, metadata !"r", metadata !1, i32 1116, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!265 = metadata !{i32 589835, metadata !263, i32 1116, i32 0, metadata !1, i32 11} ; [ DW_TAG_lexical_block ]
!266 = metadata !{i32 590081, metadata !95, metadata !"fd", metadata !1, i32 1000, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!267 = metadata !{i32 590080, metadata !268, metadata !"f", metadata !1, i32 1001, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!268 = metadata !{i32 589835, metadata !95, i32 1000, i32 0, metadata !1, i32 12} ; [ DW_TAG_lexical_block ]
!269 = metadata !{i32 590080, metadata !270, metadata !"r", metadata !1, i32 1009, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!270 = metadata !{i32 589835, metadata !268, i32 1009, i32 0, metadata !1, i32 13} ; [ DW_TAG_lexical_block ]
!271 = metadata !{i32 590081, metadata !98, metadata !"fd", metadata !1, i32 980, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!272 = metadata !{i32 590081, metadata !98, metadata !"buf", metadata !1, i32 980, metadata !101, i32 0} ; [ DW_TAG_arg_variable ]
!273 = metadata !{i32 590080, metadata !274, metadata !"f", metadata !1, i32 981, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!274 = metadata !{i32 589835, metadata !98, i32 980, i32 0, metadata !1, i32 14} ; [ DW_TAG_lexical_block ]
!275 = metadata !{i32 590080, metadata !276, metadata !"r", metadata !1, i32 993, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!276 = metadata !{i32 589835, metadata !274, i32 993, i32 0, metadata !1, i32 15} ; [ DW_TAG_lexical_block ]
!277 = metadata !{i32 590081, metadata !129, metadata !"fd", metadata !1, i32 643, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!278 = metadata !{i32 590081, metadata !129, metadata !"length", metadata !1, i32 643, metadata !70, i32 0} ; [ DW_TAG_arg_variable ]
!279 = metadata !{i32 590080, metadata !280, metadata !"f", metadata !1, i32 645, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!280 = metadata !{i32 589835, metadata !129, i32 643, i32 0, metadata !1, i32 16} ; [ DW_TAG_lexical_block ]
!281 = metadata !{i32 590080, metadata !282, metadata !"r", metadata !1, i32 668, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!282 = metadata !{i32 589835, metadata !280, i32 668, i32 0, metadata !1, i32 17} ; [ DW_TAG_lexical_block ]
!283 = metadata !{i32 589876, i32 0, metadata !129, metadata !"n_calls", metadata !"n_calls", metadata !"", metadata !1, i32 644, metadata !67, i1 true, i1 true, i32* @n_calls.4789} ; [ DW_TAG_variable ]
!284 = metadata !{i32 589876, i32 0, metadata !143, metadata !"n_calls", metadata !"n_calls", metadata !"", metadata !1, i32 1218, metadata !67, i1 true, i1 true, i32* @n_calls.5307} ; [ DW_TAG_variable ]
!285 = metadata !{i32 589876, i32 0, metadata !180, metadata !"n_calls", metadata !"n_calls", metadata !"", metadata !1, i32 202, metadata !67, i1 true, i1 true, i32* @n_calls.4421} ; [ DW_TAG_variable ]
!286 = metadata !{i32 589876, i32 0, metadata !214, metadata !"n_calls", metadata !"n_calls", metadata !"", metadata !1, i32 234, metadata !67, i1 true, i1 true, i32* @n_calls.4441} ; [ DW_TAG_variable ]
!287 = metadata !{i32 589876, i32 0, metadata !220, metadata !"n_calls", metadata !"n_calls", metadata !"", metadata !1, i32 543, metadata !67, i1 true, i1 true, i32* @n_calls.4696} ; [ DW_TAG_variable ]
!288 = metadata !{i32 589876, i32 0, metadata !223, metadata !"n_calls", metadata !"n_calls", metadata !"", metadata !1, i32 521, metadata !67, i1 true, i1 true, i32* @n_calls.4673} ; [ DW_TAG_variable ]
!289 = metadata !{i32 589876, i32 0, metadata !226, metadata !"n_calls", metadata !"n_calls", metadata !"", metadata !1, i32 302, metadata !67, i1 true, i1 true, i32* @n_calls.4500} ; [ DW_TAG_variable ]
!290 = metadata !{i32 590081, metadata !132, metadata !"fd", metadata !1, i32 588, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!291 = metadata !{i32 590081, metadata !132, metadata !"owner", metadata !1, i32 588, metadata !88, i32 0} ; [ DW_TAG_arg_variable ]
!292 = metadata !{i32 590081, metadata !132, metadata !"group", metadata !1, i32 588, metadata !89, i32 0} ; [ DW_TAG_arg_variable ]
!293 = metadata !{i32 590080, metadata !294, metadata !"f", metadata !1, i32 589, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!294 = metadata !{i32 589835, metadata !132, i32 588, i32 0, metadata !1, i32 18} ; [ DW_TAG_lexical_block ]
!295 = metadata !{i32 590080, metadata !296, metadata !"r", metadata !1, i32 599, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!296 = metadata !{i32 589835, metadata !294, i32 599, i32 0, metadata !1, i32 19} ; [ DW_TAG_lexical_block ]
!297 = metadata !{i32 590081, metadata !135, metadata !"fd", metadata !1, i32 486, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!298 = metadata !{i32 590080, metadata !299, metadata !"f", metadata !1, i32 487, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!299 = metadata !{i32 589835, metadata !135, i32 486, i32 0, metadata !1, i32 20} ; [ DW_TAG_lexical_block ]
!300 = metadata !{i32 590080, metadata !301, metadata !"r", metadata !1, i32 499, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!301 = metadata !{i32 589835, metadata !299, i32 499, i32 0, metadata !1, i32 21} ; [ DW_TAG_lexical_block ]
!302 = metadata !{i32 590081, metadata !136, metadata !"p", metadata !1, i32 1252, metadata !139, i32 0} ; [ DW_TAG_arg_variable ]
!303 = metadata !{i32 590080, metadata !304, metadata !"pc", metadata !1, i32 1254, metadata !13, i32 0} ; [ DW_TAG_auto_variable ]
!304 = metadata !{i32 589835, metadata !136, i32 1252, i32 0, metadata !1, i32 22} ; [ DW_TAG_lexical_block ]
!305 = metadata !{i32 590081, metadata !140, metadata !"s", metadata !1, i32 1259, metadata !94, i32 0} ; [ DW_TAG_arg_variable ]
!306 = metadata !{i32 590080, metadata !307, metadata !"sc", metadata !1, i32 1260, metadata !94, i32 0} ; [ DW_TAG_auto_variable ]
!307 = metadata !{i32 589835, metadata !140, i32 1259, i32 0, metadata !1, i32 23} ; [ DW_TAG_lexical_block ]
!308 = metadata !{i32 590081, metadata !143, metadata !"buf", metadata !1, i32 1217, metadata !13, i32 0} ; [ DW_TAG_arg_variable ]
!309 = metadata !{i32 590081, metadata !143, metadata !"size", metadata !1, i32 1217, metadata !94, i32 0} ; [ DW_TAG_arg_variable ]
!310 = metadata !{i32 590080, metadata !311, metadata !"r", metadata !1, i32 1219, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!311 = metadata !{i32 589835, metadata !143, i32 1217, i32 0, metadata !1, i32 24} ; [ DW_TAG_lexical_block ]
!312 = metadata !{i32 590081, metadata !146, metadata !"s", metadata !1, i32 1265, metadata !57, i32 0} ; [ DW_TAG_arg_variable ]
!313 = metadata !{i32 590080, metadata !314, metadata !"sc", metadata !1, i32 1266, metadata !13, i32 0} ; [ DW_TAG_auto_variable ]
!314 = metadata !{i32 589835, metadata !146, i32 1265, i32 0, metadata !1, i32 25} ; [ DW_TAG_lexical_block ]
!315 = metadata !{i32 590080, metadata !314, metadata !"i", metadata !1, i32 1267, metadata !11, i32 0} ; [ DW_TAG_auto_variable ]
!316 = metadata !{i32 590080, metadata !317, metadata !"c", metadata !1, i32 1270, metadata !14, i32 0} ; [ DW_TAG_auto_variable ]
!317 = metadata !{i32 589835, metadata !314, i32 1270, i32 0, metadata !1, i32 26} ; [ DW_TAG_lexical_block ]
!318 = metadata !{i32 590080, metadata !319, metadata !"cc", metadata !1, i32 1279, metadata !14, i32 0} ; [ DW_TAG_auto_variable ]
!319 = metadata !{i32 589835, metadata !317, i32 1279, i32 0, metadata !1, i32 27} ; [ DW_TAG_lexical_block ]
!320 = metadata !{i32 590081, metadata !149, metadata !"path", metadata !1, i32 963, metadata !57, i32 0} ; [ DW_TAG_arg_variable ]
!321 = metadata !{i32 590081, metadata !149, metadata !"buf", metadata !1, i32 963, metadata !101, i32 0} ; [ DW_TAG_arg_variable ]
!322 = metadata !{i32 590080, metadata !323, metadata !"dfile", metadata !1, i32 964, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!323 = metadata !{i32 589835, metadata !149, i32 963, i32 0, metadata !1, i32 28} ; [ DW_TAG_lexical_block ]
!324 = metadata !{i32 590080, metadata !325, metadata !"r", metadata !1, i32 973, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!325 = metadata !{i32 589835, metadata !323, i32 973, i32 0, metadata !1, i32 29} ; [ DW_TAG_lexical_block ]
!326 = metadata !{i32 590081, metadata !152, metadata !"path", metadata !1, i32 606, metadata !57, i32 0} ; [ DW_TAG_arg_variable ]
!327 = metadata !{i32 590081, metadata !152, metadata !"owner", metadata !1, i32 606, metadata !88, i32 0} ; [ DW_TAG_arg_variable ]
!328 = metadata !{i32 590081, metadata !152, metadata !"group", metadata !1, i32 606, metadata !89, i32 0} ; [ DW_TAG_arg_variable ]
!329 = metadata !{i32 590080, metadata !330, metadata !"df", metadata !1, i32 608, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!330 = metadata !{i32 589835, metadata !152, i32 606, i32 0, metadata !1, i32 30} ; [ DW_TAG_lexical_block ]
!331 = metadata !{i32 590080, metadata !332, metadata !"r", metadata !1, i32 613, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!332 = metadata !{i32 589835, metadata !330, i32 613, i32 0, metadata !1, i32 31} ; [ DW_TAG_lexical_block ]
!333 = metadata !{i32 590081, metadata !155, metadata !"path", metadata !1, i32 575, metadata !57, i32 0} ; [ DW_TAG_arg_variable ]
!334 = metadata !{i32 590081, metadata !155, metadata !"owner", metadata !1, i32 575, metadata !88, i32 0} ; [ DW_TAG_arg_variable ]
!335 = metadata !{i32 590081, metadata !155, metadata !"group", metadata !1, i32 575, metadata !89, i32 0} ; [ DW_TAG_arg_variable ]
!336 = metadata !{i32 590080, metadata !337, metadata !"df", metadata !1, i32 576, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!337 = metadata !{i32 589835, metadata !155, i32 575, i32 0, metadata !1, i32 32} ; [ DW_TAG_lexical_block ]
!338 = metadata !{i32 590080, metadata !339, metadata !"r", metadata !1, i32 581, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!339 = metadata !{i32 589835, metadata !337, i32 581, i32 0, metadata !1, i32 33} ; [ DW_TAG_lexical_block ]
!340 = metadata !{i32 590081, metadata !156, metadata !"path", metadata !1, i32 468, metadata !57, i32 0} ; [ DW_TAG_arg_variable ]
!341 = metadata !{i32 590080, metadata !342, metadata !"dfile", metadata !1, i32 469, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!342 = metadata !{i32 589835, metadata !156, i32 468, i32 0, metadata !1, i32 34} ; [ DW_TAG_lexical_block ]
!343 = metadata !{i32 590080, metadata !344, metadata !"r", metadata !1, i32 479, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!344 = metadata !{i32 589835, metadata !342, i32 479, i32 0, metadata !1, i32 35} ; [ DW_TAG_lexical_block ]
!345 = metadata !{i32 590081, metadata !157, metadata !"pathname", metadata !1, i32 73, metadata !57, i32 0} ; [ DW_TAG_arg_variable ]
!346 = metadata !{i32 590081, metadata !157, metadata !"mode", metadata !1, i32 73, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!347 = metadata !{i32 590080, metadata !348, metadata !"dfile", metadata !1, i32 74, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!348 = metadata !{i32 589835, metadata !157, i32 73, i32 0, metadata !1, i32 36} ; [ DW_TAG_lexical_block ]
!349 = metadata !{i32 590080, metadata !350, metadata !"r", metadata !1, i32 81, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!350 = metadata !{i32 589835, metadata !348, i32 81, i32 0, metadata !1, i32 37} ; [ DW_TAG_lexical_block ]
!351 = metadata !{i32 590081, metadata !160, metadata !"nfds", metadata !1, i32 1131, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!352 = metadata !{i32 590081, metadata !160, metadata !"read", metadata !1, i32 1131, metadata !163, i32 0} ; [ DW_TAG_arg_variable ]
!353 = metadata !{i32 590081, metadata !160, metadata !"write", metadata !1, i32 1131, metadata !163, i32 0} ; [ DW_TAG_arg_variable ]
!354 = metadata !{i32 590081, metadata !160, metadata !"except", metadata !1, i32 1132, metadata !163, i32 0} ; [ DW_TAG_arg_variable ]
!355 = metadata !{i32 590081, metadata !160, metadata !"timeout", metadata !1, i32 1132, metadata !173, i32 0} ; [ DW_TAG_arg_variable ]
!356 = metadata !{i32 590080, metadata !357, metadata !"in_read", metadata !1, i32 1133, metadata !164, i32 0} ; [ DW_TAG_auto_variable ]
!357 = metadata !{i32 589835, metadata !160, i32 1132, i32 0, metadata !1, i32 38} ; [ DW_TAG_lexical_block ]
!358 = metadata !{i32 590080, metadata !357, metadata !"in_write", metadata !1, i32 1133, metadata !164, i32 0} ; [ DW_TAG_auto_variable ]
!359 = metadata !{i32 590080, metadata !357, metadata !"in_except", metadata !1, i32 1133, metadata !164, i32 0} ; [ DW_TAG_auto_variable ]
!360 = metadata !{i32 590080, metadata !357, metadata !"os_read", metadata !1, i32 1133, metadata !164, i32 0} ; [ DW_TAG_auto_variable ]
!361 = metadata !{i32 590080, metadata !357, metadata !"os_write", metadata !1, i32 1133, metadata !164, i32 0} ; [ DW_TAG_auto_variable ]
!362 = metadata !{i32 590080, metadata !357, metadata !"os_except", metadata !1, i32 1133, metadata !164, i32 0} ; [ DW_TAG_auto_variable ]
!363 = metadata !{i32 590080, metadata !357, metadata !"i", metadata !1, i32 1134, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!364 = metadata !{i32 590080, metadata !357, metadata !"count", metadata !1, i32 1134, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!365 = metadata !{i32 590080, metadata !357, metadata !"os_nfds", metadata !1, i32 1134, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!366 = metadata !{i32 590080, metadata !367, metadata !"f", metadata !1, i32 1164, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!367 = metadata !{i32 589835, metadata !357, i32 1164, i32 0, metadata !1, i32 39} ; [ DW_TAG_lexical_block ]
!368 = metadata !{i32 590080, metadata !369, metadata !"tv", metadata !1, i32 1186, metadata !174, i32 0} ; [ DW_TAG_auto_variable ]
!369 = metadata !{i32 589835, metadata !357, i32 1186, i32 0, metadata !1, i32 40} ; [ DW_TAG_lexical_block ]
!370 = metadata !{i32 590080, metadata !369, metadata !"r", metadata !1, i32 1187, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!371 = metadata !{i32 590080, metadata !372, metadata !"f", metadata !1, i32 1202, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!372 = metadata !{i32 589835, metadata !369, i32 1202, i32 0, metadata !1, i32 41} ; [ DW_TAG_lexical_block ]
!373 = metadata !{i32 590081, metadata !180, metadata !"fd", metadata !1, i32 201, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!374 = metadata !{i32 590080, metadata !375, metadata !"f", metadata !1, i32 203, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!375 = metadata !{i32 589835, metadata !180, i32 201, i32 0, metadata !1, i32 42} ; [ DW_TAG_lexical_block ]
!376 = metadata !{i32 590080, metadata !375, metadata !"r", metadata !1, i32 204, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!377 = metadata !{i32 590081, metadata !181, metadata !"oldfd", metadata !1, i32 1016, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!378 = metadata !{i32 590081, metadata !181, metadata !"newfd", metadata !1, i32 1016, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!379 = metadata !{i32 590080, metadata !380, metadata !"f", metadata !1, i32 1017, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!380 = metadata !{i32 589835, metadata !181, i32 1016, i32 0, metadata !1, i32 43} ; [ DW_TAG_lexical_block ]
!381 = metadata !{i32 590080, metadata !382, metadata !"f2", metadata !1, i32 1023, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!382 = metadata !{i32 589835, metadata !380, i32 1023, i32 0, metadata !1, i32 44} ; [ DW_TAG_lexical_block ]
!383 = metadata !{i32 590081, metadata !184, metadata !"oldfd", metadata !1, i32 1041, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!384 = metadata !{i32 590080, metadata !385, metadata !"f", metadata !1, i32 1042, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!385 = metadata !{i32 589835, metadata !184, i32 1041, i32 0, metadata !1, i32 45} ; [ DW_TAG_lexical_block ]
!386 = metadata !{i32 590080, metadata !387, metadata !"fd", metadata !1, i32 1047, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!387 = metadata !{i32 589835, metadata !385, i32 1048, i32 0, metadata !1, i32 46} ; [ DW_TAG_lexical_block ]
!388 = metadata !{i32 590081, metadata !185, metadata !"fd", metadata !1, i32 908, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!389 = metadata !{i32 590081, metadata !185, metadata !"cmd", metadata !1, i32 908, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!390 = metadata !{i32 590080, metadata !391, metadata !"f", metadata !1, i32 909, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!391 = metadata !{i32 589835, metadata !185, i32 908, i32 0, metadata !1, i32 47} ; [ DW_TAG_lexical_block ]
!392 = metadata !{i32 590080, metadata !391, metadata !"ap", metadata !1, i32 910, metadata !393, i32 0} ; [ DW_TAG_auto_variable ]
!393 = metadata !{i32 589846, metadata !394, metadata !"va_list", metadata !394, i32 111, i64 0, i64 0, i64 0, i32 0, metadata !13} ; [ DW_TAG_typedef ]
!394 = metadata !{i32 589865, metadata !"stdio.h", metadata !"/usr/include", metadata !2} ; [ DW_TAG_file_type ]
!395 = metadata !{i32 590080, metadata !391, metadata !"arg", metadata !1, i32 911, metadata !11, i32 0} ; [ DW_TAG_auto_variable ]
!396 = metadata !{i32 590080, metadata !397, metadata !"flags", metadata !1, i32 930, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!397 = metadata !{i32 589835, metadata !391, i32 930, i32 0, metadata !1, i32 48} ; [ DW_TAG_lexical_block ]
!398 = metadata !{i32 590080, metadata !399, metadata !"r", metadata !1, i32 956, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!399 = metadata !{i32 589835, metadata !391, i32 956, i32 0, metadata !1, i32 49} ; [ DW_TAG_lexical_block ]
!400 = metadata !{i32 590081, metadata !186, metadata !"fd", metadata !1, i32 760, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!401 = metadata !{i32 590081, metadata !186, metadata !"request", metadata !1, i32 760, metadata !27, i32 0} ; [ DW_TAG_arg_variable ]
!402 = metadata !{i32 590080, metadata !403, metadata !"f", metadata !1, i32 762, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!403 = metadata !{i32 589835, metadata !186, i32 760, i32 0, metadata !1, i32 50} ; [ DW_TAG_lexical_block ]
!404 = metadata !{i32 590080, metadata !403, metadata !"ap", metadata !1, i32 763, metadata !393, i32 0} ; [ DW_TAG_auto_variable ]
!405 = metadata !{i32 590080, metadata !403, metadata !"buf", metadata !1, i32 764, metadata !139, i32 0} ; [ DW_TAG_auto_variable ]
!406 = metadata !{i32 590080, metadata !407, metadata !"stat", metadata !1, i32 780, metadata !408, i32 0} ; [ DW_TAG_auto_variable ]
!407 = metadata !{i32 589835, metadata !403, i32 780, i32 0, metadata !1, i32 51} ; [ DW_TAG_lexical_block ]
!408 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !409} ; [ DW_TAG_pointer_type ]
!409 = metadata !{i32 589843, metadata !1, metadata !"stat", metadata !20, i32 40, i64 704, i64 32, i64 0, i32 0, null, metadata !410, i32 0, null} ; [ DW_TAG_structure_type ]
!410 = metadata !{metadata !411, metadata !412, metadata !413, metadata !414, metadata !415, metadata !416, metadata !417, metadata !418, metadata !419, metadata !420, metadata !422, metadata !423, metadata !425, metadata !426, metadata !427, metadata !428, metadata !429}
!411 = metadata !{i32 589837, metadata !409, metadata !"st_dev", metadata !20, i32 41, i64 64, i64 64, i64 0, i32 0, metadata !21} ; [ DW_TAG_member ]
!412 = metadata !{i32 589837, metadata !409, metadata !"__pad1", metadata !20, i32 42, i64 16, i64 16, i64 64, i32 0, metadata !199} ; [ DW_TAG_member ]
!413 = metadata !{i32 589837, metadata !409, metadata !"st_ino", metadata !20, i32 44, i64 32, i64 32, i64 96, i32 0, metadata !26} ; [ DW_TAG_member ]
!414 = metadata !{i32 589837, metadata !409, metadata !"st_mode", metadata !20, i32 48, i64 32, i64 32, i64 128, i32 0, metadata !29} ; [ DW_TAG_member ]
!415 = metadata !{i32 589837, metadata !409, metadata !"st_nlink", metadata !20, i32 49, i64 32, i64 32, i64 160, i32 0, metadata !31} ; [ DW_TAG_member ]
!416 = metadata !{i32 589837, metadata !409, metadata !"st_uid", metadata !20, i32 50, i64 32, i64 32, i64 192, i32 0, metadata !33} ; [ DW_TAG_member ]
!417 = metadata !{i32 589837, metadata !409, metadata !"st_gid", metadata !20, i32 51, i64 32, i64 32, i64 224, i32 0, metadata !35} ; [ DW_TAG_member ]
!418 = metadata !{i32 589837, metadata !409, metadata !"st_rdev", metadata !20, i32 52, i64 64, i64 64, i64 256, i32 0, metadata !21} ; [ DW_TAG_member ]
!419 = metadata !{i32 589837, metadata !409, metadata !"__pad2", metadata !20, i32 53, i64 16, i64 16, i64 320, i32 0, metadata !199} ; [ DW_TAG_member ]
!420 = metadata !{i32 589837, metadata !409, metadata !"st_size", metadata !20, i32 55, i64 32, i64 32, i64 352, i32 0, metadata !421} ; [ DW_TAG_member ]
!421 = metadata !{i32 589846, metadata !22, metadata !"__off_t", metadata !22, i32 142, i64 0, i64 0, i64 0, i32 0, metadata !43} ; [ DW_TAG_typedef ]
!422 = metadata !{i32 589837, metadata !409, metadata !"st_blksize", metadata !20, i32 59, i64 32, i64 32, i64 384, i32 0, metadata !42} ; [ DW_TAG_member ]
!423 = metadata !{i32 589837, metadata !409, metadata !"st_blocks", metadata !20, i32 62, i64 32, i64 32, i64 416, i32 0, metadata !424} ; [ DW_TAG_member ]
!424 = metadata !{i32 589846, metadata !22, metadata !"__blkcnt_t", metadata !22, i32 170, i64 0, i64 0, i64 0, i32 0, metadata !43} ; [ DW_TAG_typedef ]
!425 = metadata !{i32 589837, metadata !409, metadata !"st_atim", metadata !20, i32 73, i64 64, i64 32, i64 448, i32 0, metadata !47} ; [ DW_TAG_member ]
!426 = metadata !{i32 589837, metadata !409, metadata !"st_mtim", metadata !20, i32 74, i64 64, i64 32, i64 512, i32 0, metadata !47} ; [ DW_TAG_member ]
!427 = metadata !{i32 589837, metadata !409, metadata !"st_ctim", metadata !20, i32 75, i64 64, i64 32, i64 576, i32 0, metadata !47} ; [ DW_TAG_member ]
!428 = metadata !{i32 589837, metadata !409, metadata !"__unused4", metadata !20, i32 88, i64 32, i64 32, i64 640, i32 0, metadata !27} ; [ DW_TAG_member ]
!429 = metadata !{i32 589837, metadata !409, metadata !"__unused5", metadata !20, i32 89, i64 32, i64 32, i64 672, i32 0, metadata !27} ; [ DW_TAG_member ]
!430 = metadata !{i32 590080, metadata !431, metadata !"ts", metadata !1, i32 784, metadata !432, i32 0} ; [ DW_TAG_auto_variable ]
!431 = metadata !{i32 589835, metadata !407, i32 784, i32 0, metadata !1, i32 52} ; [ DW_TAG_lexical_block ]
!432 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !433} ; [ DW_TAG_pointer_type ]
!433 = metadata !{i32 589843, metadata !1, metadata !"termios", metadata !434, i32 30, i64 480, i64 32, i64 0, i32 0, null, metadata !435, i32 0, null} ; [ DW_TAG_structure_type ]
!434 = metadata !{i32 589865, metadata !"termios.h", metadata !"/usr/include/i386-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!435 = metadata !{metadata !436, metadata !438, metadata !439, metadata !440, metadata !441, metadata !443, metadata !445, metadata !447}
!436 = metadata !{i32 589837, metadata !433, metadata !"c_iflag", metadata !434, i32 31, i64 32, i64 32, i64 0, i32 0, metadata !437} ; [ DW_TAG_member ]
!437 = metadata !{i32 589846, metadata !434, metadata !"tcflag_t", metadata !434, i32 30, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!438 = metadata !{i32 589837, metadata !433, metadata !"c_oflag", metadata !434, i32 32, i64 32, i64 32, i64 32, i32 0, metadata !437} ; [ DW_TAG_member ]
!439 = metadata !{i32 589837, metadata !433, metadata !"c_cflag", metadata !434, i32 33, i64 32, i64 32, i64 64, i32 0, metadata !437} ; [ DW_TAG_member ]
!440 = metadata !{i32 589837, metadata !433, metadata !"c_lflag", metadata !434, i32 34, i64 32, i64 32, i64 96, i32 0, metadata !437} ; [ DW_TAG_member ]
!441 = metadata !{i32 589837, metadata !433, metadata !"c_line", metadata !434, i32 35, i64 8, i64 8, i64 128, i32 0, metadata !442} ; [ DW_TAG_member ]
!442 = metadata !{i32 589846, metadata !434, metadata !"cc_t", metadata !434, i32 25, i64 0, i64 0, i64 0, i32 0, metadata !201} ; [ DW_TAG_typedef ]
!443 = metadata !{i32 589837, metadata !433, metadata !"c_cc", metadata !434, i32 36, i64 256, i64 8, i64 136, i32 0, metadata !444} ; [ DW_TAG_member ]
!444 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 256, i64 8, i64 0, i32 0, metadata !442, metadata !171, i32 0, null} ; [ DW_TAG_array_type ]
!445 = metadata !{i32 589837, metadata !433, metadata !"c_ispeed", metadata !434, i32 37, i64 32, i64 32, i64 416, i32 0, metadata !446} ; [ DW_TAG_member ]
!446 = metadata !{i32 589846, metadata !434, metadata !"speed_t", metadata !434, i32 26, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!447 = metadata !{i32 589837, metadata !433, metadata !"c_ospeed", metadata !434, i32 38, i64 32, i64 32, i64 448, i32 0, metadata !446} ; [ DW_TAG_member ]
!448 = metadata !{i32 590080, metadata !449, metadata !"ws", metadata !1, i32 853, metadata !450, i32 0} ; [ DW_TAG_auto_variable ]
!449 = metadata !{i32 589835, metadata !407, i32 853, i32 0, metadata !1, i32 53} ; [ DW_TAG_lexical_block ]
!450 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !451} ; [ DW_TAG_pointer_type ]
!451 = metadata !{i32 589843, metadata !1, metadata !"winsize", metadata !452, i32 29, i64 64, i64 16, i64 0, i32 0, null, metadata !453, i32 0, null} ; [ DW_TAG_structure_type ]
!452 = metadata !{i32 589865, metadata !"ioctl-types.h", metadata !"/usr/include/i386-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!453 = metadata !{metadata !454, metadata !455, metadata !456, metadata !457}
!454 = metadata !{i32 589837, metadata !451, metadata !"ws_row", metadata !452, i32 30, i64 16, i64 16, i64 0, i32 0, metadata !199} ; [ DW_TAG_member ]
!455 = metadata !{i32 589837, metadata !451, metadata !"ws_col", metadata !452, i32 31, i64 16, i64 16, i64 16, i32 0, metadata !199} ; [ DW_TAG_member ]
!456 = metadata !{i32 589837, metadata !451, metadata !"ws_xpixel", metadata !452, i32 32, i64 16, i64 16, i64 32, i32 0, metadata !199} ; [ DW_TAG_member ]
!457 = metadata !{i32 589837, metadata !451, metadata !"ws_ypixel", metadata !452, i32 33, i64 16, i64 16, i64 48, i32 0, metadata !199} ; [ DW_TAG_member ]
!458 = metadata !{i32 590080, metadata !459, metadata !"res", metadata !1, i32 876, metadata !460, i32 0} ; [ DW_TAG_auto_variable ]
!459 = metadata !{i32 589835, metadata !407, i32 876, i32 0, metadata !1, i32 54} ; [ DW_TAG_lexical_block ]
!460 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !67} ; [ DW_TAG_pointer_type ]
!461 = metadata !{i32 590080, metadata !462, metadata !"r", metadata !1, i32 901, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!462 = metadata !{i32 589835, metadata !403, i32 901, i32 0, metadata !1, i32 55} ; [ DW_TAG_lexical_block ]
!463 = metadata !{i32 590081, metadata !189, metadata !"fd", metadata !1, i32 676, metadata !11, i32 0} ; [ DW_TAG_arg_variable ]
!464 = metadata !{i32 590081, metadata !189, metadata !"dirp", metadata !1, i32 676, metadata !192, i32 0} ; [ DW_TAG_arg_variable ]
!465 = metadata !{i32 590081, metadata !189, metadata !"count", metadata !1, i32 676, metadata !11, i32 0} ; [ DW_TAG_arg_variable ]
!466 = metadata !{i32 590080, metadata !467, metadata !"f", metadata !1, i32 677, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!467 = metadata !{i32 589835, metadata !189, i32 676, i32 0, metadata !1, i32 56} ; [ DW_TAG_lexical_block ]
!468 = metadata !{i32 590080, metadata !469, metadata !"i", metadata !1, i32 691, metadata !11, i32 0} ; [ DW_TAG_auto_variable ]
!469 = metadata !{i32 589835, metadata !467, i32 691, i32 0, metadata !1, i32 57} ; [ DW_TAG_lexical_block ]
!470 = metadata !{i32 590080, metadata !469, metadata !"pad", metadata !1, i32 691, metadata !11, i32 0} ; [ DW_TAG_auto_variable ]
!471 = metadata !{i32 590080, metadata !469, metadata !"bytes", metadata !1, i32 691, metadata !11, i32 0} ; [ DW_TAG_auto_variable ]
!472 = metadata !{i32 590080, metadata !473, metadata !"df", metadata !1, i32 701, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!473 = metadata !{i32 589835, metadata !469, i32 701, i32 0, metadata !1, i32 58} ; [ DW_TAG_lexical_block ]
!474 = metadata !{i32 590080, metadata !475, metadata !"os_pos", metadata !1, i32 723, metadata !11, i32 0} ; [ DW_TAG_auto_variable ]
!475 = metadata !{i32 589835, metadata !467, i32 723, i32 0, metadata !1, i32 59} ; [ DW_TAG_lexical_block ]
!476 = metadata !{i32 590080, metadata !475, metadata !"res", metadata !1, i32 724, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!477 = metadata !{i32 590080, metadata !475, metadata !"s", metadata !1, i32 724, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!478 = metadata !{i32 590080, metadata !479, metadata !"pos", metadata !1, i32 740, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!479 = metadata !{i32 589835, metadata !475, i32 740, i32 0, metadata !1, i32 60} ; [ DW_TAG_lexical_block ]
!480 = metadata !{i32 590080, metadata !481, metadata !"dp", metadata !1, i32 747, metadata !192, i32 0} ; [ DW_TAG_auto_variable ]
!481 = metadata !{i32 589835, metadata !479, i32 747, i32 0, metadata !1, i32 61} ; [ DW_TAG_lexical_block ]
!482 = metadata !{i32 590081, metadata !206, metadata !"fd", metadata !1, i32 373, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!483 = metadata !{i32 590081, metadata !206, metadata !"offset", metadata !1, i32 373, metadata !70, i32 0} ; [ DW_TAG_arg_variable ]
!484 = metadata !{i32 590081, metadata !206, metadata !"whence", metadata !1, i32 373, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!485 = metadata !{i32 590080, metadata !486, metadata !"new_off", metadata !1, i32 374, metadata !70, i32 0} ; [ DW_TAG_auto_variable ]
!486 = metadata !{i32 589835, metadata !206, i32 373, i32 0, metadata !1, i32 62} ; [ DW_TAG_lexical_block ]
!487 = metadata !{i32 590080, metadata !486, metadata !"f", metadata !1, i32 375, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!488 = metadata !{i32 590081, metadata !209, metadata !"fd", metadata !1, i32 620, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!489 = metadata !{i32 590081, metadata !209, metadata !"buf", metadata !1, i32 620, metadata !16, i32 0} ; [ DW_TAG_arg_variable ]
!490 = metadata !{i32 590080, metadata !491, metadata !"f", metadata !1, i32 621, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!491 = metadata !{i32 589835, metadata !209, i32 620, i32 0, metadata !1, i32 63} ; [ DW_TAG_lexical_block ]
!492 = metadata !{i32 590080, metadata !493, metadata !"r", metadata !1, i32 632, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!493 = metadata !{i32 589835, metadata !491, i32 632, i32 0, metadata !1, i32 64} ; [ DW_TAG_lexical_block ]
!494 = metadata !{i32 590081, metadata !210, metadata !"path", metadata !1, i32 449, metadata !57, i32 0} ; [ DW_TAG_arg_variable ]
!495 = metadata !{i32 590081, metadata !210, metadata !"buf", metadata !1, i32 449, metadata !16, i32 0} ; [ DW_TAG_arg_variable ]
!496 = metadata !{i32 590080, metadata !497, metadata !"dfile", metadata !1, i32 450, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!497 = metadata !{i32 589835, metadata !210, i32 449, i32 0, metadata !1, i32 65} ; [ DW_TAG_lexical_block ]
!498 = metadata !{i32 590080, metadata !499, metadata !"r", metadata !1, i32 460, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!499 = metadata !{i32 589835, metadata !497, i32 460, i32 0, metadata !1, i32 66} ; [ DW_TAG_lexical_block ]
!500 = metadata !{i32 590081, metadata !213, metadata !"path", metadata !1, i32 430, metadata !57, i32 0} ; [ DW_TAG_arg_variable ]
!501 = metadata !{i32 590081, metadata !213, metadata !"buf", metadata !1, i32 430, metadata !16, i32 0} ; [ DW_TAG_arg_variable ]
!502 = metadata !{i32 590080, metadata !503, metadata !"dfile", metadata !1, i32 431, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!503 = metadata !{i32 589835, metadata !213, i32 430, i32 0, metadata !1, i32 67} ; [ DW_TAG_lexical_block ]
!504 = metadata !{i32 590080, metadata !505, metadata !"r", metadata !1, i32 441, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!505 = metadata !{i32 589835, metadata !503, i32 441, i32 0, metadata !1, i32 68} ; [ DW_TAG_lexical_block ]
!506 = metadata !{i32 590081, metadata !214, metadata !"fd", metadata !1, i32 233, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!507 = metadata !{i32 590081, metadata !214, metadata !"buf", metadata !1, i32 233, metadata !139, i32 0} ; [ DW_TAG_arg_variable ]
!508 = metadata !{i32 590081, metadata !214, metadata !"count", metadata !1, i32 233, metadata !94, i32 0} ; [ DW_TAG_arg_variable ]
!509 = metadata !{i32 590080, metadata !510, metadata !"f", metadata !1, i32 235, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!510 = metadata !{i32 589835, metadata !214, i32 233, i32 0, metadata !1, i32 69} ; [ DW_TAG_lexical_block ]
!511 = metadata !{i32 590080, metadata !512, metadata !"r", metadata !1, i32 262, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!512 = metadata !{i32 589835, metadata !510, i32 263, i32 0, metadata !1, i32 70} ; [ DW_TAG_lexical_block ]
!513 = metadata !{i32 590081, metadata !217, metadata !"df", metadata !1, i32 507, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!514 = metadata !{i32 590081, metadata !217, metadata !"mode", metadata !1, i32 507, metadata !76, i32 0} ; [ DW_TAG_arg_variable ]
!515 = metadata !{i32 590081, metadata !220, metadata !"fd", metadata !1, i32 542, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!516 = metadata !{i32 590081, metadata !220, metadata !"mode", metadata !1, i32 542, metadata !76, i32 0} ; [ DW_TAG_arg_variable ]
!517 = metadata !{i32 590080, metadata !518, metadata !"f", metadata !1, i32 545, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!518 = metadata !{i32 589835, metadata !220, i32 542, i32 0, metadata !1, i32 72} ; [ DW_TAG_lexical_block ]
!519 = metadata !{i32 590080, metadata !520, metadata !"r", metadata !1, i32 562, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!520 = metadata !{i32 589835, metadata !518, i32 562, i32 0, metadata !1, i32 73} ; [ DW_TAG_lexical_block ]
!521 = metadata !{i32 590081, metadata !223, metadata !"path", metadata !1, i32 520, metadata !57, i32 0} ; [ DW_TAG_arg_variable ]
!522 = metadata !{i32 590081, metadata !223, metadata !"mode", metadata !1, i32 520, metadata !76, i32 0} ; [ DW_TAG_arg_variable ]
!523 = metadata !{i32 590080, metadata !524, metadata !"dfile", metadata !1, i32 523, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!524 = metadata !{i32 589835, metadata !223, i32 520, i32 0, metadata !1, i32 74} ; [ DW_TAG_lexical_block ]
!525 = metadata !{i32 590080, metadata !526, metadata !"r", metadata !1, i32 535, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!526 = metadata !{i32 589835, metadata !524, i32 535, i32 0, metadata !1, i32 75} ; [ DW_TAG_lexical_block ]
!527 = metadata !{i32 590081, metadata !226, metadata !"fd", metadata !1, i32 301, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!528 = metadata !{i32 590081, metadata !226, metadata !"buf", metadata !1, i32 301, metadata !139, i32 0} ; [ DW_TAG_arg_variable ]
!529 = metadata !{i32 590081, metadata !226, metadata !"count", metadata !1, i32 301, metadata !94, i32 0} ; [ DW_TAG_arg_variable ]
!530 = metadata !{i32 590080, metadata !531, metadata !"f", metadata !1, i32 303, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!531 = metadata !{i32 589835, metadata !226, i32 301, i32 0, metadata !1, i32 76} ; [ DW_TAG_lexical_block ]
!532 = metadata !{i32 590080, metadata !533, metadata !"r", metadata !1, i32 321, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!533 = metadata !{i32 589835, metadata !531, i32 323, i32 0, metadata !1, i32 77} ; [ DW_TAG_lexical_block ]
!534 = metadata !{i32 590080, metadata !535, metadata !"actual_count", metadata !1, i32 346, metadata !94, i32 0} ; [ DW_TAG_auto_variable ]
!535 = metadata !{i32 589835, metadata !531, i32 346, i32 0, metadata !1, i32 78} ; [ DW_TAG_lexical_block ]
!536 = metadata !{i32 590081, metadata !227, metadata !"pathname", metadata !1, i32 128, metadata !57, i32 0} ; [ DW_TAG_arg_variable ]
!537 = metadata !{i32 590081, metadata !227, metadata !"flags", metadata !1, i32 128, metadata !67, i32 0} ; [ DW_TAG_arg_variable ]
!538 = metadata !{i32 590081, metadata !227, metadata !"mode", metadata !1, i32 128, metadata !76, i32 0} ; [ DW_TAG_arg_variable ]
!539 = metadata !{i32 590080, metadata !540, metadata !"df", metadata !1, i32 129, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!540 = metadata !{i32 589835, metadata !227, i32 128, i32 0, metadata !1, i32 79} ; [ DW_TAG_lexical_block ]
!541 = metadata !{i32 590080, metadata !540, metadata !"f", metadata !1, i32 130, metadata !62, i32 0} ; [ DW_TAG_auto_variable ]
!542 = metadata !{i32 590080, metadata !540, metadata !"fd", metadata !1, i32 131, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!543 = metadata !{i32 590080, metadata !544, metadata !"os_fd", metadata !1, i32 181, metadata !67, i32 0} ; [ DW_TAG_auto_variable ]
!544 = metadata !{i32 589835, metadata !540, i32 181, i32 0, metadata !1, i32 80} ; [ DW_TAG_lexical_block ]
!545 = metadata !{i32 73, i32 0, metadata !157, null}
!546 = metadata !{i32 39, i32 0, metadata !0, metadata !547}
!547 = metadata !{i32 74, i32 0, metadata !348, null}
!548 = metadata !{i32 40, i32 0, metadata !232, metadata !547}
!549 = metadata !{i32 43, i32 0, metadata !232, metadata !547}
!550 = metadata !{i32 46, i32 0, metadata !232, metadata !547}
!551 = metadata !{i32 47, i32 0, metadata !232, metadata !547}
!552 = metadata !{i32 48, i32 0, metadata !235, metadata !547}
!553 = metadata !{null}
!554 = metadata !{i32 49, i32 0, metadata !235, metadata !547}
!555 = metadata !{i32 76, i32 0, metadata !348, null}
!556 = metadata !{i32 1265, i32 0, metadata !146, metadata !557}
!557 = metadata !{i32 81, i32 0, metadata !350, null}
!558 = metadata !{i32 1252, i32 0, metadata !136, metadata !559}
!559 = metadata !{i32 1266, i32 0, metadata !314, metadata !557}
!560 = metadata !{i32 1254, i32 0, metadata !304, metadata !559}
!561 = metadata !{i32 1255, i32 0, metadata !304, metadata !559}
!562 = metadata !{i32 0}
!563 = metadata !{i32 1269, i32 0, metadata !314, metadata !557}
!564 = metadata !{i32 1270, i32 0, metadata !317, metadata !557}
!565 = metadata !{i32 1271, i32 0, metadata !317, metadata !557}
!566 = metadata !{i32 1273, i32 0, metadata !317, metadata !557}
!567 = metadata !{i32 1276, i32 0, metadata !317, metadata !557}
!568 = metadata !{i32 1279, i32 0, metadata !319, metadata !557}
!569 = metadata !{i32 1280, i32 0, metadata !319, metadata !557}
!570 = metadata !{i32 1281, i32 0, metadata !319, metadata !557}
!571 = metadata !{i32 1282, i32 0, metadata !319, metadata !557}
!572 = metadata !{i32 82, i32 0, metadata !350, null}
!573 = metadata !{i32 83, i32 0, metadata !350, null}
!574 = metadata !{i32 79, i32 0, metadata !348, null}
!575 = metadata !{i32 88, i32 0, metadata !73, null}
!576 = metadata !{i32 89, i32 0, metadata !242, null}
!577 = metadata !{i32 90, i32 0, metadata !242, null}
!578 = metadata !{i32 91, i32 0, metadata !242, null}
!579 = metadata !{i32 1294, i32 0, metadata !80, null}
!580 = metadata !{i32 1295, i32 0, metadata !581, null}
!581 = metadata !{i32 589835, metadata !80, i32 1294, i32 0, metadata !1, i32 6} ; [ DW_TAG_lexical_block ]
!582 = metadata !{i32 1296, i32 0, metadata !581, null}
!583 = metadata !{i32 1297, i32 0, metadata !581, null}
!584 = metadata !{i32 1300, i32 0, metadata !581, null}
!585 = metadata !{i32 1304, i32 0, metadata !581, null}
!586 = metadata !{i32 1305, i32 0, metadata !581, null}
!587 = metadata !{i32 1306, i32 0, metadata !581, null}
!588 = metadata !{i32 1078, i32 0, metadata !83, null}
!589 = metadata !{i32 39, i32 0, metadata !0, metadata !590}
!590 = metadata !{i32 1079, i32 0, metadata !252, null}
!591 = metadata !{i32 40, i32 0, metadata !232, metadata !590}
!592 = metadata !{i32 43, i32 0, metadata !232, metadata !590}
!593 = metadata !{i32 46, i32 0, metadata !232, metadata !590}
!594 = metadata !{i32 47, i32 0, metadata !232, metadata !590}
!595 = metadata !{i32 48, i32 0, metadata !235, metadata !590}
!596 = metadata !{i32 49, i32 0, metadata !235, metadata !590}
!597 = metadata !{i32 1080, i32 0, metadata !252, null}
!598 = metadata !{i32 1082, i32 0, metadata !252, null}
!599 = metadata !{i32 1083, i32 0, metadata !252, null}
!600 = metadata !{i32 1084, i32 0, metadata !252, null}
!601 = metadata !{i32 1085, i32 0, metadata !252, null}
!602 = metadata !{i32 1086, i32 0, metadata !252, null}
!603 = metadata !{i32 1087, i32 0, metadata !252, null}
!604 = metadata !{i32 1089, i32 0, metadata !252, null}
!605 = metadata !{i32 1090, i32 0, metadata !252, null}
!606 = metadata !{i32 1094, i32 0, metadata !252, null}
!607 = metadata !{i32 1095, i32 0, metadata !252, null}
!608 = metadata !{i32 1096, i32 0, metadata !252, null}
!609 = metadata !{i32 1060, i32 0, metadata !84, null}
!610 = metadata !{i32 39, i32 0, metadata !0, metadata !611}
!611 = metadata !{i32 1061, i32 0, metadata !255, null}
!612 = metadata !{i32 40, i32 0, metadata !232, metadata !611}
!613 = metadata !{i32 43, i32 0, metadata !232, metadata !611}
!614 = metadata !{i32 46, i32 0, metadata !232, metadata !611}
!615 = metadata !{i32 47, i32 0, metadata !232, metadata !611}
!616 = metadata !{i32 48, i32 0, metadata !235, metadata !611}
!617 = metadata !{i32 49, i32 0, metadata !235, metadata !611}
!618 = metadata !{i32 1062, i32 0, metadata !255, null}
!619 = metadata !{i32 1064, i32 0, metadata !255, null}
!620 = metadata !{i32 1065, i32 0, metadata !255, null}
!621 = metadata !{i32 1066, i32 0, metadata !255, null}
!622 = metadata !{i32 1068, i32 0, metadata !255, null}
!623 = metadata !{i32 1069, i32 0, metadata !255, null}
!624 = metadata !{i32 1073, i32 0, metadata !255, null}
!625 = metadata !{i32 1074, i32 0, metadata !255, null}
!626 = metadata !{i32 1075, i32 0, metadata !255, null}
!627 = metadata !{i32 1099, i32 0, metadata !90, null}
!628 = metadata !{i32 39, i32 0, metadata !0, metadata !629}
!629 = metadata !{i32 1100, i32 0, metadata !263, null}
!630 = metadata !{i32 40, i32 0, metadata !232, metadata !629}
!631 = metadata !{i32 43, i32 0, metadata !232, metadata !629}
!632 = metadata !{i32 46, i32 0, metadata !232, metadata !629}
!633 = metadata !{i32 47, i32 0, metadata !232, metadata !629}
!634 = metadata !{i32 48, i32 0, metadata !235, metadata !629}
!635 = metadata !{i32 49, i32 0, metadata !235, metadata !629}
!636 = metadata !{i32 1101, i32 0, metadata !263, null}
!637 = metadata !{i32 1104, i32 0, metadata !263, null}
!638 = metadata !{i32 1105, i32 0, metadata !263, null}
!639 = metadata !{i32 1106, i32 0, metadata !263, null}
!640 = metadata !{i32 1107, i32 0, metadata !263, null}
!641 = metadata !{i32 1108, i32 0, metadata !263, null}
!642 = metadata !{i32 1109, i32 0, metadata !263, null}
!643 = metadata !{i32 1110, i32 0, metadata !263, null}
!644 = metadata !{i32 1112, i32 0, metadata !263, null}
!645 = metadata !{i32 1113, i32 0, metadata !263, null}
!646 = metadata !{i32 1116, i32 0, metadata !265, null}
!647 = metadata !{i32 1117, i32 0, metadata !265, null}
!648 = metadata !{i32 1118, i32 0, metadata !265, null}
!649 = metadata !{i32 1000, i32 0, metadata !95, null}
!650 = metadata !{i32 63, i32 0, metadata !59, metadata !651}
!651 = metadata !{i32 1001, i32 0, metadata !268, null}
!652 = metadata !{i32 64, i32 0, metadata !239, metadata !651}
!653 = metadata !{i32 65, i32 0, metadata !238, metadata !651}
!654 = metadata !{i32 66, i32 0, metadata !238, metadata !651}
!655 = metadata !{i32 1003, i32 0, metadata !268, null}
!656 = metadata !{i32 1004, i32 0, metadata !268, null}
!657 = metadata !{i32 1005, i32 0, metadata !268, null}
!658 = metadata !{i32 1006, i32 0, metadata !268, null}
!659 = metadata !{i32 1009, i32 0, metadata !270, null}
!660 = metadata !{i32 1010, i32 0, metadata !270, null}
!661 = metadata !{i32 1011, i32 0, metadata !270, null}
!662 = metadata !{i32 980, i32 0, metadata !98, null}
!663 = metadata !{i32 63, i32 0, metadata !59, metadata !664}
!664 = metadata !{i32 981, i32 0, metadata !274, null}
!665 = metadata !{i32 64, i32 0, metadata !239, metadata !664}
!666 = metadata !{i32 65, i32 0, metadata !238, metadata !664}
!667 = metadata !{i32 66, i32 0, metadata !238, metadata !664}
!668 = metadata !{i32 983, i32 0, metadata !274, null}
!669 = metadata !{i32 984, i32 0, metadata !274, null}
!670 = metadata !{i32 985, i32 0, metadata !274, null}
!671 = metadata !{i32 988, i32 0, metadata !274, null}
!672 = metadata !{i32 989, i32 0, metadata !274, null}
!673 = metadata !{i32 990, i32 0, metadata !274, null}
!674 = metadata !{i32 991, i32 0, metadata !274, null}
!675 = metadata !{i32 993, i32 0, metadata !276, null}
!676 = metadata !{i32 994, i32 0, metadata !276, null}
!677 = metadata !{i32 995, i32 0, metadata !276, null}
!678 = metadata !{i32 643, i32 0, metadata !129, null}
!679 = metadata !{i32 63, i32 0, metadata !59, metadata !680}
!680 = metadata !{i32 645, i32 0, metadata !280, null}
!681 = metadata !{i32 64, i32 0, metadata !239, metadata !680}
!682 = metadata !{i32 65, i32 0, metadata !238, metadata !680}
!683 = metadata !{i32 66, i32 0, metadata !238, metadata !680}
!684 = metadata !{i32 647, i32 0, metadata !280, null}
!685 = metadata !{i32 649, i32 0, metadata !280, null}
!686 = metadata !{i32 650, i32 0, metadata !280, null}
!687 = metadata !{i32 651, i32 0, metadata !280, null}
!688 = metadata !{i32 654, i32 0, metadata !280, null}
!689 = metadata !{i32 655, i32 0, metadata !280, null}
!690 = metadata !{i32 656, i32 0, metadata !280, null}
!691 = metadata !{i32 657, i32 0, metadata !280, null}
!692 = metadata !{i32 660, i32 0, metadata !280, null}
!693 = metadata !{i32 661, i32 0, metadata !280, null}
!694 = metadata !{i32 662, i32 0, metadata !280, null}
!695 = metadata !{i32 663, i32 0, metadata !280, null}
!696 = metadata !{i32 668, i32 0, metadata !282, null}
!697 = metadata !{i32 670, i32 0, metadata !282, null}
!698 = metadata !{i32 671, i32 0, metadata !282, null}
!699 = metadata !{i32 588, i32 0, metadata !132, null}
!700 = metadata !{i32 63, i32 0, metadata !59, metadata !701}
!701 = metadata !{i32 589, i32 0, metadata !294, null}
!702 = metadata !{i32 64, i32 0, metadata !239, metadata !701}
!703 = metadata !{i32 65, i32 0, metadata !238, metadata !701}
!704 = metadata !{i32 66, i32 0, metadata !238, metadata !701}
!705 = metadata !{i32 591, i32 0, metadata !294, null}
!706 = metadata !{i32 592, i32 0, metadata !294, null}
!707 = metadata !{i32 593, i32 0, metadata !294, null}
!708 = metadata !{i32 596, i32 0, metadata !294, null}
!709 = metadata !{%struct.exe_disk_file_t* null}
!710 = metadata !{i32 569, i32 0, metadata !85, metadata !711}
!711 = metadata !{i32 597, i32 0, metadata !294, null}
!712 = metadata !{i32 570, i32 0, metadata !713, metadata !711}
!713 = metadata !{i32 589835, metadata !85, i32 569, i32 0, metadata !1, i32 9} ; [ DW_TAG_lexical_block ]
!714 = metadata !{i32 571, i32 0, metadata !713, metadata !711}
!715 = metadata !{i32 599, i32 0, metadata !296, null}
!716 = metadata !{i32 600, i32 0, metadata !296, null}
!717 = metadata !{i32 601, i32 0, metadata !296, null}
!718 = metadata !{i32 486, i32 0, metadata !135, null}
!719 = metadata !{i32 63, i32 0, metadata !59, metadata !720}
!720 = metadata !{i32 487, i32 0, metadata !299, null}
!721 = metadata !{i32 64, i32 0, metadata !239, metadata !720}
!722 = metadata !{i32 65, i32 0, metadata !238, metadata !720}
!723 = metadata !{i32 66, i32 0, metadata !238, metadata !720}
!724 = metadata !{i32 489, i32 0, metadata !299, null}
!725 = metadata !{i32 490, i32 0, metadata !299, null}
!726 = metadata !{i32 491, i32 0, metadata !299, null}
!727 = metadata !{i32 494, i32 0, metadata !299, null}
!728 = metadata !{i32 495, i32 0, metadata !299, null}
!729 = metadata !{i32 496, i32 0, metadata !299, null}
!730 = metadata !{i32 497, i32 0, metadata !299, null}
!731 = metadata !{i32 499, i32 0, metadata !301, null}
!732 = metadata !{i32 500, i32 0, metadata !301, null}
!733 = metadata !{i32 501, i32 0, metadata !301, null}
!734 = metadata !{i32 1217, i32 0, metadata !143, null}
!735 = metadata !{i32 1221, i32 0, metadata !311, null}
!736 = metadata !{i32 1223, i32 0, metadata !311, null}
!737 = metadata !{i32 1224, i32 0, metadata !311, null}
!738 = metadata !{i32 1225, i32 0, metadata !311, null}
!739 = metadata !{i32 1226, i32 0, metadata !311, null}
!740 = metadata !{i32 1229, i32 0, metadata !311, null}
!741 = metadata !{i32 1230, i32 0, metadata !311, null}
!742 = metadata !{i32 1024}
!743 = metadata !{i32 1231, i32 0, metadata !311, null}
!744 = metadata !{i32 1232, i32 0, metadata !311, null}
!745 = metadata !{i32 1252, i32 0, metadata !136, metadata !746}
!746 = metadata !{i32 1235, i32 0, metadata !311, null}
!747 = metadata !{i32 1254, i32 0, metadata !304, metadata !746}
!748 = metadata !{i32 1255, i32 0, metadata !304, metadata !746}
!749 = metadata !{i32 1259, i32 0, metadata !140, metadata !750}
!750 = metadata !{i32 1236, i32 0, metadata !311, null}
!751 = metadata !{i32 1260, i32 0, metadata !307, metadata !750}
!752 = metadata !{i32 1261, i32 0, metadata !307, metadata !750}
!753 = metadata !{i32 1240, i32 0, metadata !311, null}
!754 = metadata !{i32 1241, i32 0, metadata !311, null}
!755 = metadata !{i32 1242, i32 0, metadata !311, null}
!756 = metadata !{i32 1243, i32 0, metadata !311, null}
!757 = metadata !{i32 1244, i32 0, metadata !311, null}
!758 = metadata !{i32 963, i32 0, metadata !149, null}
!759 = metadata !{i32 39, i32 0, metadata !0, metadata !760}
!760 = metadata !{i32 964, i32 0, metadata !323, null}
!761 = metadata !{i32 40, i32 0, metadata !232, metadata !760}
!762 = metadata !{i32 43, i32 0, metadata !232, metadata !760}
!763 = metadata !{i32 46, i32 0, metadata !232, metadata !760}
!764 = metadata !{i32 47, i32 0, metadata !232, metadata !760}
!765 = metadata !{i32 48, i32 0, metadata !235, metadata !760}
!766 = metadata !{i32 49, i32 0, metadata !235, metadata !760}
!767 = metadata !{i32 965, i32 0, metadata !323, null}
!768 = metadata !{i32 967, i32 0, metadata !323, null}
!769 = metadata !{i32 968, i32 0, metadata !323, null}
!770 = metadata !{i32 969, i32 0, metadata !323, null}
!771 = metadata !{i32 1265, i32 0, metadata !146, metadata !772}
!772 = metadata !{i32 973, i32 0, metadata !325, null}
!773 = metadata !{i32 1252, i32 0, metadata !136, metadata !774}
!774 = metadata !{i32 1266, i32 0, metadata !314, metadata !772}
!775 = metadata !{i32 1254, i32 0, metadata !304, metadata !774}
!776 = metadata !{i32 1255, i32 0, metadata !304, metadata !774}
!777 = metadata !{i32 1269, i32 0, metadata !314, metadata !772}
!778 = metadata !{i32 1270, i32 0, metadata !317, metadata !772}
!779 = metadata !{i32 1271, i32 0, metadata !317, metadata !772}
!780 = metadata !{i32 1273, i32 0, metadata !317, metadata !772}
!781 = metadata !{i32 1276, i32 0, metadata !317, metadata !772}
!782 = metadata !{i32 1279, i32 0, metadata !319, metadata !772}
!783 = metadata !{i32 1280, i32 0, metadata !319, metadata !772}
!784 = metadata !{i32 1281, i32 0, metadata !319, metadata !772}
!785 = metadata !{i32 1282, i32 0, metadata !319, metadata !772}
!786 = metadata !{i32 974, i32 0, metadata !325, null}
!787 = metadata !{i32 975, i32 0, metadata !325, null}
!788 = metadata !{i32 606, i32 0, metadata !152, null}
!789 = metadata !{i32 39, i32 0, metadata !0, metadata !790}
!790 = metadata !{i32 608, i32 0, metadata !330, null}
!791 = metadata !{i32 40, i32 0, metadata !232, metadata !790}
!792 = metadata !{i32 43, i32 0, metadata !232, metadata !790}
!793 = metadata !{i32 46, i32 0, metadata !232, metadata !790}
!794 = metadata !{i32 47, i32 0, metadata !232, metadata !790}
!795 = metadata !{i32 48, i32 0, metadata !235, metadata !790}
!796 = metadata !{i32 49, i32 0, metadata !235, metadata !790}
!797 = metadata !{i32 610, i32 0, metadata !330, null}
!798 = metadata !{i32 569, i32 0, metadata !85, metadata !799}
!799 = metadata !{i32 611, i32 0, metadata !330, null}
!800 = metadata !{i32 570, i32 0, metadata !713, metadata !799}
!801 = metadata !{i32 571, i32 0, metadata !713, metadata !799}
!802 = metadata !{i32 1265, i32 0, metadata !146, metadata !803}
!803 = metadata !{i32 613, i32 0, metadata !332, null}
!804 = metadata !{i32 1252, i32 0, metadata !136, metadata !805}
!805 = metadata !{i32 1266, i32 0, metadata !314, metadata !803}
!806 = metadata !{i32 1254, i32 0, metadata !304, metadata !805}
!807 = metadata !{i32 1255, i32 0, metadata !304, metadata !805}
!808 = metadata !{i32 1269, i32 0, metadata !314, metadata !803}
!809 = metadata !{i32 1270, i32 0, metadata !317, metadata !803}
!810 = metadata !{i32 1271, i32 0, metadata !317, metadata !803}
!811 = metadata !{i32 1273, i32 0, metadata !317, metadata !803}
!812 = metadata !{i32 1276, i32 0, metadata !317, metadata !803}
!813 = metadata !{i32 1279, i32 0, metadata !319, metadata !803}
!814 = metadata !{i32 1280, i32 0, metadata !319, metadata !803}
!815 = metadata !{i32 1281, i32 0, metadata !319, metadata !803}
!816 = metadata !{i32 1282, i32 0, metadata !319, metadata !803}
!817 = metadata !{i32 614, i32 0, metadata !332, null}
!818 = metadata !{i32 615, i32 0, metadata !332, null}
!819 = metadata !{i32 575, i32 0, metadata !155, null}
!820 = metadata !{i32 39, i32 0, metadata !0, metadata !821}
!821 = metadata !{i32 576, i32 0, metadata !337, null}
!822 = metadata !{i32 40, i32 0, metadata !232, metadata !821}
!823 = metadata !{i32 43, i32 0, metadata !232, metadata !821}
!824 = metadata !{i32 46, i32 0, metadata !232, metadata !821}
!825 = metadata !{i32 47, i32 0, metadata !232, metadata !821}
!826 = metadata !{i32 48, i32 0, metadata !235, metadata !821}
!827 = metadata !{i32 49, i32 0, metadata !235, metadata !821}
!828 = metadata !{i32 578, i32 0, metadata !337, null}
!829 = metadata !{i32 569, i32 0, metadata !85, metadata !830}
!830 = metadata !{i32 579, i32 0, metadata !337, null}
!831 = metadata !{i32 570, i32 0, metadata !713, metadata !830}
!832 = metadata !{i32 571, i32 0, metadata !713, metadata !830}
!833 = metadata !{i32 1265, i32 0, metadata !146, metadata !834}
!834 = metadata !{i32 581, i32 0, metadata !339, null}
!835 = metadata !{i32 1252, i32 0, metadata !136, metadata !836}
!836 = metadata !{i32 1266, i32 0, metadata !314, metadata !834}
!837 = metadata !{i32 1254, i32 0, metadata !304, metadata !836}
!838 = metadata !{i32 1255, i32 0, metadata !304, metadata !836}
!839 = metadata !{i32 1269, i32 0, metadata !314, metadata !834}
!840 = metadata !{i32 1270, i32 0, metadata !317, metadata !834}
!841 = metadata !{i32 1271, i32 0, metadata !317, metadata !834}
!842 = metadata !{i32 1273, i32 0, metadata !317, metadata !834}
!843 = metadata !{i32 1276, i32 0, metadata !317, metadata !834}
!844 = metadata !{i32 1279, i32 0, metadata !319, metadata !834}
!845 = metadata !{i32 1280, i32 0, metadata !319, metadata !834}
!846 = metadata !{i32 1281, i32 0, metadata !319, metadata !834}
!847 = metadata !{i32 1282, i32 0, metadata !319, metadata !834}
!848 = metadata !{i32 582, i32 0, metadata !339, null}
!849 = metadata !{i32 583, i32 0, metadata !339, null}
!850 = metadata !{i32 468, i32 0, metadata !156, null}
!851 = metadata !{i32 39, i32 0, metadata !0, metadata !852}
!852 = metadata !{i32 469, i32 0, metadata !342, null}
!853 = metadata !{i32 40, i32 0, metadata !232, metadata !852}
!854 = metadata !{i32 43, i32 0, metadata !232, metadata !852}
!855 = metadata !{i32 46, i32 0, metadata !232, metadata !852}
!856 = metadata !{i32 47, i32 0, metadata !232, metadata !852}
!857 = metadata !{i32 48, i32 0, metadata !235, metadata !852}
!858 = metadata !{i32 49, i32 0, metadata !235, metadata !852}
!859 = metadata !{i32 471, i32 0, metadata !342, null}
!860 = metadata !{i32 473, i32 0, metadata !342, null}
!861 = metadata !{i32 474, i32 0, metadata !342, null}
!862 = metadata !{i32 475, i32 0, metadata !342, null}
!863 = metadata !{i32 1265, i32 0, metadata !146, metadata !864}
!864 = metadata !{i32 479, i32 0, metadata !344, null}
!865 = metadata !{i32 1252, i32 0, metadata !136, metadata !866}
!866 = metadata !{i32 1266, i32 0, metadata !314, metadata !864}
!867 = metadata !{i32 1254, i32 0, metadata !304, metadata !866}
!868 = metadata !{i32 1255, i32 0, metadata !304, metadata !866}
!869 = metadata !{i32 1269, i32 0, metadata !314, metadata !864}
!870 = metadata !{i32 1270, i32 0, metadata !317, metadata !864}
!871 = metadata !{i32 1271, i32 0, metadata !317, metadata !864}
!872 = metadata !{i32 1273, i32 0, metadata !317, metadata !864}
!873 = metadata !{i32 1276, i32 0, metadata !317, metadata !864}
!874 = metadata !{i32 1279, i32 0, metadata !319, metadata !864}
!875 = metadata !{i32 1280, i32 0, metadata !319, metadata !864}
!876 = metadata !{i32 1281, i32 0, metadata !319, metadata !864}
!877 = metadata !{i32 1282, i32 0, metadata !319, metadata !864}
!878 = metadata !{i32 480, i32 0, metadata !344, null}
!879 = metadata !{i32 481, i32 0, metadata !344, null}
!880 = metadata !{i32 1131, i32 0, metadata !160, null}
!881 = metadata !{i32 1132, i32 0, metadata !160, null}
!882 = metadata !{i32 1133, i32 0, metadata !357, null}
!883 = metadata !{i32 1134, i32 0, metadata !357, null}
!884 = metadata !{i32 1136, i32 0, metadata !357, null}
!885 = metadata !{i32 1140, i32 0, metadata !357, null}
!886 = metadata !{i32 1137, i32 0, metadata !357, null}
!887 = metadata !{i32 1138, i32 0, metadata !357, null}
!888 = metadata !{i32 1143, i32 0, metadata !357, null}
!889 = metadata !{i32 1147, i32 0, metadata !357, null}
!890 = metadata !{i32 1144, i32 0, metadata !357, null}
!891 = metadata !{i32 1145, i32 0, metadata !357, null}
!892 = metadata !{i32 1150, i32 0, metadata !357, null}
!893 = metadata !{i32 1154, i32 0, metadata !357, null}
!894 = metadata !{i32 1151, i32 0, metadata !357, null}
!895 = metadata !{i32 1152, i32 0, metadata !357, null}
!896 = metadata !{i32 1157, i32 0, metadata !357, null}
!897 = metadata !{i32 1158, i32 0, metadata !357, null}
!898 = metadata !{i32 1159, i32 0, metadata !357, null}
!899 = metadata !{i32 1162, i32 0, metadata !357, null}
!900 = metadata !{i32 1163, i32 0, metadata !357, null}
!901 = metadata !{i32 64, i32 0, metadata !239, metadata !902}
!902 = metadata !{i32 1164, i32 0, metadata !367, null}
!903 = metadata !{i32 66, i32 0, metadata !238, metadata !902}
!904 = metadata !{i32 1165, i32 0, metadata !367, null}
!905 = metadata !{i32 63, i32 0, metadata !59, metadata !902}
!906 = metadata !{i32 1166, i32 0, metadata !367, null}
!907 = metadata !{i32 1167, i32 0, metadata !367, null}
!908 = metadata !{i32 1168, i32 0, metadata !367, null}
!909 = metadata !{i32 1170, i32 0, metadata !367, null}
!910 = metadata !{i32 1171, i32 0, metadata !367, null}
!911 = metadata !{i32 1172, i32 0, metadata !367, null}
!912 = metadata !{i32 1173, i32 0, metadata !367, null}
!913 = metadata !{i32 1175, i32 0, metadata !367, null}
!914 = metadata !{i32 1176, i32 0, metadata !367, null}
!915 = metadata !{i32 1177, i32 0, metadata !367, null}
!916 = metadata !{i32 1178, i32 0, metadata !367, null}
!917 = metadata !{i32 1183, i32 0, metadata !357, null}
!918 = metadata !{i32 1186, i32 0, metadata !369, null}
!919 = metadata !{i32 1188, i32 0, metadata !369, null}
!920 = metadata !{i32 1190, i32 0, metadata !369, null}
!921 = metadata !{i32 1193, i32 0, metadata !369, null}
!922 = metadata !{i32 1194, i32 0, metadata !369, null}
!923 = metadata !{i32 1195, i32 0, metadata !369, null}
!924 = metadata !{i32 1198, i32 0, metadata !369, null}
!925 = metadata !{i32 1201, i32 0, metadata !369, null}
!926 = metadata !{i32 64, i32 0, metadata !239, metadata !927}
!927 = metadata !{i32 1202, i32 0, metadata !372, null}
!928 = metadata !{i32 66, i32 0, metadata !238, metadata !927}
!929 = metadata !{i32 1203, i32 0, metadata !372, null}
!930 = metadata !{i32 1204, i32 0, metadata !372, null}
!931 = metadata !{i32 1205, i32 0, metadata !372, null}
!932 = metadata !{i32 1206, i32 0, metadata !372, null}
!933 = metadata !{i32 201, i32 0, metadata !180, null}
!934 = metadata !{i32 204, i32 0, metadata !375, null}
!935 = metadata !{i32 206, i32 0, metadata !375, null}
!936 = metadata !{i32 63, i32 0, metadata !59, metadata !937}
!937 = metadata !{i32 208, i32 0, metadata !375, null}
!938 = metadata !{i32 64, i32 0, metadata !239, metadata !937}
!939 = metadata !{i32 65, i32 0, metadata !238, metadata !937}
!940 = metadata !{i32 66, i32 0, metadata !238, metadata !937}
!941 = metadata !{i32 209, i32 0, metadata !375, null}
!942 = metadata !{i32 210, i32 0, metadata !375, null}
!943 = metadata !{i32 211, i32 0, metadata !375, null}
!944 = metadata !{i32 214, i32 0, metadata !375, null}
!945 = metadata !{i32 215, i32 0, metadata !375, null}
!946 = metadata !{i32 216, i32 0, metadata !375, null}
!947 = metadata !{i32 217, i32 0, metadata !375, null}
!948 = metadata !{i32 228, i32 0, metadata !375, null}
!949 = metadata !{i32 230, i32 0, metadata !375, null}
!950 = metadata !{i32 1016, i32 0, metadata !181, null}
!951 = metadata !{i32 63, i32 0, metadata !59, metadata !952}
!952 = metadata !{i32 1017, i32 0, metadata !380, null}
!953 = metadata !{i32 64, i32 0, metadata !239, metadata !952}
!954 = metadata !{i32 65, i32 0, metadata !238, metadata !952}
!955 = metadata !{i32 66, i32 0, metadata !238, metadata !952}
!956 = metadata !{i32 1019, i32 0, metadata !380, null}
!957 = metadata !{i32 1020, i32 0, metadata !380, null}
!958 = metadata !{i32 1021, i32 0, metadata !380, null}
!959 = metadata !{i32 1023, i32 0, metadata !382, null}
!960 = metadata !{i32 1024, i32 0, metadata !382, null}
!961 = metadata !{i32 201, i32 0, metadata !180, metadata !960}
!962 = metadata !{i32 204, i32 0, metadata !375, metadata !960}
!963 = metadata !{i32 206, i32 0, metadata !375, metadata !960}
!964 = metadata !{i32 63, i32 0, metadata !59, metadata !965}
!965 = metadata !{i32 208, i32 0, metadata !375, metadata !960}
!966 = metadata !{i32 64, i32 0, metadata !239, metadata !965}
!967 = metadata !{i32 65, i32 0, metadata !238, metadata !965}
!968 = metadata !{i32 209, i32 0, metadata !375, metadata !960}
!969 = metadata !{i32 210, i32 0, metadata !375, metadata !960}
!970 = metadata !{i32 211, i32 0, metadata !375, metadata !960}
!971 = metadata !{i32 214, i32 0, metadata !375, metadata !960}
!972 = metadata !{i32 215, i32 0, metadata !375, metadata !960}
!973 = metadata !{i32 216, i32 0, metadata !375, metadata !960}
!974 = metadata !{i32 217, i32 0, metadata !375, metadata !960}
!975 = metadata !{i32 228, i32 0, metadata !375, metadata !960}
!976 = metadata !{i32 230, i32 0, metadata !375, metadata !960}
!977 = metadata !{i32 1028, i32 0, metadata !382, null}
!978 = metadata !{i32 1030, i32 0, metadata !382, null}
!979 = metadata !{i32 1037, i32 0, metadata !382, null}
!980 = metadata !{i32 1041, i32 0, metadata !184, null}
!981 = metadata !{i32 63, i32 0, metadata !59, metadata !982}
!982 = metadata !{i32 1042, i32 0, metadata !385, null}
!983 = metadata !{i32 64, i32 0, metadata !239, metadata !982}
!984 = metadata !{i32 65, i32 0, metadata !238, metadata !982}
!985 = metadata !{i32 66, i32 0, metadata !238, metadata !982}
!986 = metadata !{i32 1043, i32 0, metadata !385, null}
!987 = metadata !{i32 1044, i32 0, metadata !385, null}
!988 = metadata !{i32 1045, i32 0, metadata !385, null}
!989 = metadata !{i32 1049, i32 0, metadata !387, null}
!990 = metadata !{i32 1048, i32 0, metadata !387, null}
!991 = metadata !{i32 1051, i32 0, metadata !387, null}
!992 = metadata !{i32 1052, i32 0, metadata !387, null}
!993 = metadata !{i32 1053, i32 0, metadata !387, null}
!994 = metadata !{i32 1055, i32 0, metadata !387, null}
!995 = metadata !{i32 908, i32 0, metadata !185, null}
!996 = metadata !{i32 910, i32 0, metadata !391, null}
!997 = metadata !{i32 63, i32 0, metadata !59, metadata !998}
!998 = metadata !{i32 909, i32 0, metadata !391, null}
!999 = metadata !{i32 64, i32 0, metadata !239, metadata !998}
!1000 = metadata !{i32 65, i32 0, metadata !238, metadata !998}
!1001 = metadata !{i32 66, i32 0, metadata !238, metadata !998}
!1002 = metadata !{i32 913, i32 0, metadata !391, null}
!1003 = metadata !{i32 914, i32 0, metadata !391, null}
!1004 = metadata !{i32 915, i32 0, metadata !391, null}
!1005 = metadata !{i32 918, i32 0, metadata !391, null}
!1006 = metadata !{i32 922, i32 0, metadata !391, null}
!1007 = metadata !{i32 923, i32 0, metadata !391, null}
!1008 = metadata !{i32 924, i32 0, metadata !391, null}
!1009 = metadata !{i32 927, i32 0, metadata !391, null}
!1010 = metadata !{i32 928, i32 0, metadata !391, null}
!1011 = metadata !{i32 930, i32 0, metadata !397, null}
!1012 = metadata !{i32 931, i32 0, metadata !397, null}
!1013 = metadata !{i32 1}
!1014 = metadata !{i32 932, i32 0, metadata !397, null}
!1015 = metadata !{i32 936, i32 0, metadata !391, null}
!1016 = metadata !{i32 937, i32 0, metadata !391, null}
!1017 = metadata !{i32 938, i32 0, metadata !391, null}
!1018 = metadata !{i32 951, i32 0, metadata !391, null}
!1019 = metadata !{i32 952, i32 0, metadata !391, null}
!1020 = metadata !{i32 953, i32 0, metadata !391, null}
!1021 = metadata !{i32 956, i32 0, metadata !399, null}
!1022 = metadata !{i32 957, i32 0, metadata !399, null}
!1023 = metadata !{i32 958, i32 0, metadata !399, null}
!1024 = metadata !{i32 760, i32 0, metadata !186, null}
!1025 = metadata !{i32 763, i32 0, metadata !403, null}
!1026 = metadata !{i32 63, i32 0, metadata !59, metadata !1027}
!1027 = metadata !{i32 762, i32 0, metadata !403, null}
!1028 = metadata !{i32 64, i32 0, metadata !239, metadata !1027}
!1029 = metadata !{i32 65, i32 0, metadata !238, metadata !1027}
!1030 = metadata !{i32 66, i32 0, metadata !238, metadata !1027}
!1031 = metadata !{i32 770, i32 0, metadata !403, null}
!1032 = metadata !{i32 771, i32 0, metadata !403, null}
!1033 = metadata !{i32 772, i32 0, metadata !403, null}
!1034 = metadata !{i32 775, i32 0, metadata !403, null}
!1035 = metadata !{i32 776, i32 0, metadata !403, null}
!1036 = metadata !{i32 777, i32 0, metadata !403, null}
!1037 = metadata !{i32 779, i32 0, metadata !403, null}
!1038 = metadata !{i32 780, i32 0, metadata !407, null}
!1039 = metadata !{i32 782, i32 0, metadata !407, null}
!1040 = metadata !{i32 784, i32 0, metadata !431, null}
!1041 = metadata !{i32 786, i32 0, metadata !431, null}
!1042 = metadata !{i32 789, i32 0, metadata !431, null}
!1043 = metadata !{i32 792, i32 0, metadata !431, null}
!1044 = metadata !{i32 793, i32 0, metadata !431, null}
!1045 = metadata !{i32 794, i32 0, metadata !431, null}
!1046 = metadata !{i32 795, i32 0, metadata !431, null}
!1047 = metadata !{i32 796, i32 0, metadata !431, null}
!1048 = metadata !{i32 797, i32 0, metadata !431, null}
!1049 = metadata !{i32 798, i32 0, metadata !431, null}
!1050 = metadata !{i32 799, i32 0, metadata !431, null}
!1051 = metadata !{i32 800, i32 0, metadata !431, null}
!1052 = metadata !{i32 801, i32 0, metadata !431, null}
!1053 = metadata !{i32 802, i32 0, metadata !431, null}
!1054 = metadata !{i32 803, i32 0, metadata !431, null}
!1055 = metadata !{i32 804, i32 0, metadata !431, null}
!1056 = metadata !{i32 805, i32 0, metadata !431, null}
!1057 = metadata !{i32 806, i32 0, metadata !431, null}
!1058 = metadata !{i32 807, i32 0, metadata !431, null}
!1059 = metadata !{i32 808, i32 0, metadata !431, null}
!1060 = metadata !{i32 809, i32 0, metadata !431, null}
!1061 = metadata !{i32 810, i32 0, metadata !431, null}
!1062 = metadata !{i32 811, i32 0, metadata !431, null}
!1063 = metadata !{i32 812, i32 0, metadata !431, null}
!1064 = metadata !{i32 813, i32 0, metadata !431, null}
!1065 = metadata !{i32 814, i32 0, metadata !431, null}
!1066 = metadata !{i32 815, i32 0, metadata !431, null}
!1067 = metadata !{i32 816, i32 0, metadata !431, null}
!1068 = metadata !{i32 818, i32 0, metadata !431, null}
!1069 = metadata !{i32 819, i32 0, metadata !431, null}
!1070 = metadata !{i32 824, i32 0, metadata !407, null}
!1071 = metadata !{i32 825, i32 0, metadata !407, null}
!1072 = metadata !{i32 828, i32 0, metadata !407, null}
!1073 = metadata !{i32 829, i32 0, metadata !407, null}
!1074 = metadata !{i32 834, i32 0, metadata !407, null}
!1075 = metadata !{i32 835, i32 0, metadata !407, null}
!1076 = metadata !{i32 838, i32 0, metadata !407, null}
!1077 = metadata !{i32 839, i32 0, metadata !407, null}
!1078 = metadata !{i32 844, i32 0, metadata !407, null}
!1079 = metadata !{i32 845, i32 0, metadata !407, null}
!1080 = metadata !{i32 848, i32 0, metadata !407, null}
!1081 = metadata !{i32 849, i32 0, metadata !407, null}
!1082 = metadata !{i32 853, i32 0, metadata !449, null}
!1083 = metadata !{i32 854, i32 0, metadata !449, null}
!1084 = metadata !{i32 855, i32 0, metadata !449, null}
!1085 = metadata !{i32 856, i32 0, metadata !449, null}
!1086 = metadata !{i32 857, i32 0, metadata !449, null}
!1087 = metadata !{i32 860, i32 0, metadata !449, null}
!1088 = metadata !{i32 861, i32 0, metadata !449, null}
!1089 = metadata !{i32 866, i32 0, metadata !407, null}
!1090 = metadata !{i32 867, i32 0, metadata !407, null}
!1091 = metadata !{i32 868, i32 0, metadata !407, null}
!1092 = metadata !{i32 869, i32 0, metadata !407, null}
!1093 = metadata !{i32 871, i32 0, metadata !407, null}
!1094 = metadata !{i32 872, i32 0, metadata !407, null}
!1095 = metadata !{i32 876, i32 0, metadata !459, null}
!1096 = metadata !{i32 877, i32 0, metadata !459, null}
!1097 = metadata !{i32 878, i32 0, metadata !459, null}
!1098 = metadata !{i32 879, i32 0, metadata !459, null}
!1099 = metadata !{i32 880, i32 0, metadata !459, null}
!1100 = metadata !{i32 884, i32 0, metadata !459, null}
!1101 = metadata !{i32 886, i32 0, metadata !459, null}
!1102 = metadata !{i32 887, i32 0, metadata !459, null}
!1103 = metadata !{i32 891, i32 0, metadata !407, null}
!1104 = metadata !{i32 892, i32 0, metadata !407, null}
!1105 = metadata !{i32 893, i32 0, metadata !407, null}
!1106 = metadata !{i32 896, i32 0, metadata !407, null}
!1107 = metadata !{i32 897, i32 0, metadata !407, null}
!1108 = metadata !{i32 898, i32 0, metadata !407, null}
!1109 = metadata !{i32 901, i32 0, metadata !462, null}
!1110 = metadata !{i32 902, i32 0, metadata !462, null}
!1111 = metadata !{i32 903, i32 0, metadata !462, null}
!1112 = metadata !{i32 676, i32 0, metadata !189, null}
!1113 = metadata !{i32 63, i32 0, metadata !59, metadata !1114}
!1114 = metadata !{i32 677, i32 0, metadata !467, null}
!1115 = metadata !{i32 64, i32 0, metadata !239, metadata !1114}
!1116 = metadata !{i32 65, i32 0, metadata !238, metadata !1114}
!1117 = metadata !{i32 66, i32 0, metadata !238, metadata !1114}
!1118 = metadata !{i32 679, i32 0, metadata !467, null}
!1119 = metadata !{i32 680, i32 0, metadata !467, null}
!1120 = metadata !{i32 681, i32 0, metadata !467, null}
!1121 = metadata !{i32 684, i32 0, metadata !467, null}
!1122 = metadata !{i32 685, i32 0, metadata !467, null}
!1123 = metadata !{i32 686, i32 0, metadata !467, null}
!1124 = metadata !{i32 687, i32 0, metadata !467, null}
!1125 = metadata !{i32 689, i32 0, metadata !467, null}
!1126 = metadata !{i32 691, i32 0, metadata !469, null}
!1127 = metadata !{i32 694, i32 0, metadata !469, null}
!1128 = metadata !{i32 695, i32 0, metadata !469, null}
!1129 = metadata !{i32 700, i32 0, metadata !469, null}
!1130 = metadata !{i32 697, i32 0, metadata !469, null}
!1131 = metadata !{i32 698, i32 0, metadata !469, null}
!1132 = metadata !{i32 701, i32 0, metadata !473, null}
!1133 = metadata !{i32 702, i32 0, metadata !473, null}
!1134 = metadata !{i32 703, i32 0, metadata !473, null}
!1135 = metadata !{i32 704, i32 0, metadata !473, null}
!1136 = metadata !{i32 705, i32 0, metadata !473, null}
!1137 = metadata !{i32 706, i32 0, metadata !473, null}
!1138 = metadata !{i32 707, i32 0, metadata !473, null}
!1139 = metadata !{i32 708, i32 0, metadata !473, null}
!1140 = metadata !{i32 709, i32 0, metadata !473, null}
!1141 = metadata !{i32 713, i32 0, metadata !469, null}
!1142 = metadata !{i32 714, i32 0, metadata !469, null}
!1143 = metadata !{i32 715, i32 0, metadata !469, null}
!1144 = metadata !{i32 716, i32 0, metadata !469, null}
!1145 = metadata !{i32 717, i32 0, metadata !469, null}
!1146 = metadata !{i32 718, i32 0, metadata !469, null}
!1147 = metadata !{i32 719, i32 0, metadata !469, null}
!1148 = metadata !{i32 720, i32 0, metadata !469, null}
!1149 = metadata !{i32 721, i32 0, metadata !469, null}
!1150 = metadata !{i32 723, i32 0, metadata !475, null}
!1151 = metadata !{i32 733, i32 0, metadata !475, null}
!1152 = metadata !{i32 734, i32 0, metadata !475, null}
!1153 = metadata !{i32 735, i32 0, metadata !475, null}
!1154 = metadata !{i32 736, i32 0, metadata !475, null}
!1155 = metadata !{i32 737, i32 0, metadata !475, null}
!1156 = metadata !{i32 738, i32 0, metadata !475, null}
!1157 = metadata !{i32 740, i32 0, metadata !479, null}
!1158 = metadata !{i32 742, i32 0, metadata !479, null}
!1159 = metadata !{i32 746, i32 0, metadata !479, null}
!1160 = metadata !{i32 748, i32 0, metadata !481, null}
!1161 = metadata !{i32 749, i32 0, metadata !481, null}
!1162 = metadata !{i32 373, i32 0, metadata !206, null}
!1163 = metadata !{i32 63, i32 0, metadata !59, metadata !1164}
!1164 = metadata !{i32 375, i32 0, metadata !486, null}
!1165 = metadata !{i32 64, i32 0, metadata !239, metadata !1164}
!1166 = metadata !{i32 65, i32 0, metadata !238, metadata !1164}
!1167 = metadata !{i32 66, i32 0, metadata !238, metadata !1164}
!1168 = metadata !{i32 377, i32 0, metadata !486, null}
!1169 = metadata !{i32 378, i32 0, metadata !486, null}
!1170 = metadata !{i32 379, i32 0, metadata !486, null}
!1171 = metadata !{i32 382, i32 0, metadata !486, null}
!1172 = metadata !{i32 389, i32 0, metadata !486, null}
!1173 = metadata !{i32 390, i32 0, metadata !486, null}
!1174 = metadata !{i32 392, i32 0, metadata !486, null}
!1175 = metadata !{i32 396, i32 0, metadata !486, null}
!1176 = metadata !{i32 397, i32 0, metadata !486, null}
!1177 = metadata !{i32 398, i32 0, metadata !486, null}
!1178 = metadata !{i32 402, i32 0, metadata !486, null}
!1179 = metadata !{i32 403, i32 0, metadata !486, null}
!1180 = metadata !{i32 404, i32 0, metadata !486, null}
!1181 = metadata !{i32 407, i32 0, metadata !486, null}
!1182 = metadata !{i32 408, i32 0, metadata !486, null}
!1183 = metadata !{i32 411, i32 0, metadata !486, null}
!1184 = metadata !{i32 413, i32 0, metadata !486, null}
!1185 = metadata !{i32 414, i32 0, metadata !486, null}
!1186 = metadata !{i32 416, i32 0, metadata !486, null}
!1187 = metadata !{i32 417, i32 0, metadata !486, null}
!1188 = metadata !{i32 421, i32 0, metadata !486, null}
!1189 = metadata !{i32 422, i32 0, metadata !486, null}
!1190 = metadata !{i32 423, i32 0, metadata !486, null}
!1191 = metadata !{i32 426, i32 0, metadata !486, null}
!1192 = metadata !{i32 427, i32 0, metadata !486, null}
!1193 = metadata !{i32 620, i32 0, metadata !209, null}
!1194 = metadata !{i32 63, i32 0, metadata !59, metadata !1195}
!1195 = metadata !{i32 621, i32 0, metadata !491, null}
!1196 = metadata !{i32 64, i32 0, metadata !239, metadata !1195}
!1197 = metadata !{i32 65, i32 0, metadata !238, metadata !1195}
!1198 = metadata !{i32 66, i32 0, metadata !238, metadata !1195}
!1199 = metadata !{i32 623, i32 0, metadata !491, null}
!1200 = metadata !{i32 624, i32 0, metadata !491, null}
!1201 = metadata !{i32 625, i32 0, metadata !491, null}
!1202 = metadata !{i32 628, i32 0, metadata !491, null}
!1203 = metadata !{i32 632, i32 0, metadata !493, null}
!1204 = metadata !{i32 634, i32 0, metadata !493, null}
!1205 = metadata !{i32 635, i32 0, metadata !493, null}
!1206 = metadata !{i32 639, i32 0, metadata !491, null}
!1207 = metadata !{i32 640, i32 0, metadata !491, null}
!1208 = metadata !{i32 449, i32 0, metadata !210, null}
!1209 = metadata !{i32 39, i32 0, metadata !0, metadata !1210}
!1210 = metadata !{i32 450, i32 0, metadata !497, null}
!1211 = metadata !{i32 40, i32 0, metadata !232, metadata !1210}
!1212 = metadata !{i32 43, i32 0, metadata !232, metadata !1210}
!1213 = metadata !{i32 46, i32 0, metadata !232, metadata !1210}
!1214 = metadata !{i32 47, i32 0, metadata !232, metadata !1210}
!1215 = metadata !{i32 48, i32 0, metadata !235, metadata !1210}
!1216 = metadata !{i32 49, i32 0, metadata !235, metadata !1210}
!1217 = metadata !{i32 451, i32 0, metadata !497, null}
!1218 = metadata !{i32 452, i32 0, metadata !497, null}
!1219 = metadata !{i32 453, i32 0, metadata !497, null}
!1220 = metadata !{i32 1265, i32 0, metadata !146, metadata !1221}
!1221 = metadata !{i32 460, i32 0, metadata !499, null}
!1222 = metadata !{i32 1252, i32 0, metadata !136, metadata !1223}
!1223 = metadata !{i32 1266, i32 0, metadata !314, metadata !1221}
!1224 = metadata !{i32 1254, i32 0, metadata !304, metadata !1223}
!1225 = metadata !{i32 1255, i32 0, metadata !304, metadata !1223}
!1226 = metadata !{i32 1269, i32 0, metadata !314, metadata !1221}
!1227 = metadata !{i32 1270, i32 0, metadata !317, metadata !1221}
!1228 = metadata !{i32 1271, i32 0, metadata !317, metadata !1221}
!1229 = metadata !{i32 1273, i32 0, metadata !317, metadata !1221}
!1230 = metadata !{i32 1276, i32 0, metadata !317, metadata !1221}
!1231 = metadata !{i32 1279, i32 0, metadata !319, metadata !1221}
!1232 = metadata !{i32 1280, i32 0, metadata !319, metadata !1221}
!1233 = metadata !{i32 1281, i32 0, metadata !319, metadata !1221}
!1234 = metadata !{i32 1282, i32 0, metadata !319, metadata !1221}
!1235 = metadata !{i32 462, i32 0, metadata !499, null}
!1236 = metadata !{i32 463, i32 0, metadata !499, null}
!1237 = metadata !{i32 430, i32 0, metadata !213, null}
!1238 = metadata !{i32 39, i32 0, metadata !0, metadata !1239}
!1239 = metadata !{i32 431, i32 0, metadata !503, null}
!1240 = metadata !{i32 40, i32 0, metadata !232, metadata !1239}
!1241 = metadata !{i32 43, i32 0, metadata !232, metadata !1239}
!1242 = metadata !{i32 46, i32 0, metadata !232, metadata !1239}
!1243 = metadata !{i32 47, i32 0, metadata !232, metadata !1239}
!1244 = metadata !{i32 48, i32 0, metadata !235, metadata !1239}
!1245 = metadata !{i32 49, i32 0, metadata !235, metadata !1239}
!1246 = metadata !{i32 432, i32 0, metadata !503, null}
!1247 = metadata !{i32 433, i32 0, metadata !503, null}
!1248 = metadata !{i32 434, i32 0, metadata !503, null}
!1249 = metadata !{i32 1265, i32 0, metadata !146, metadata !1250}
!1250 = metadata !{i32 441, i32 0, metadata !505, null}
!1251 = metadata !{i32 1252, i32 0, metadata !136, metadata !1252}
!1252 = metadata !{i32 1266, i32 0, metadata !314, metadata !1250}
!1253 = metadata !{i32 1254, i32 0, metadata !304, metadata !1252}
!1254 = metadata !{i32 1255, i32 0, metadata !304, metadata !1252}
!1255 = metadata !{i32 1269, i32 0, metadata !314, metadata !1250}
!1256 = metadata !{i32 1270, i32 0, metadata !317, metadata !1250}
!1257 = metadata !{i32 1271, i32 0, metadata !317, metadata !1250}
!1258 = metadata !{i32 1273, i32 0, metadata !317, metadata !1250}
!1259 = metadata !{i32 1276, i32 0, metadata !317, metadata !1250}
!1260 = metadata !{i32 1279, i32 0, metadata !319, metadata !1250}
!1261 = metadata !{i32 1280, i32 0, metadata !319, metadata !1250}
!1262 = metadata !{i32 1281, i32 0, metadata !319, metadata !1250}
!1263 = metadata !{i32 1282, i32 0, metadata !319, metadata !1250}
!1264 = metadata !{i32 443, i32 0, metadata !505, null}
!1265 = metadata !{i32 444, i32 0, metadata !505, null}
!1266 = metadata !{i32 233, i32 0, metadata !214, null}
!1267 = metadata !{i32 237, i32 0, metadata !510, null}
!1268 = metadata !{i32 239, i32 0, metadata !510, null}
!1269 = metadata !{i32 242, i32 0, metadata !510, null}
!1270 = metadata !{i32 243, i32 0, metadata !510, null}
!1271 = metadata !{i32 244, i32 0, metadata !510, null}
!1272 = metadata !{i32 63, i32 0, metadata !59, metadata !1273}
!1273 = metadata !{i32 247, i32 0, metadata !510, null}
!1274 = metadata !{i32 64, i32 0, metadata !239, metadata !1273}
!1275 = metadata !{i32 65, i32 0, metadata !238, metadata !1273}
!1276 = metadata !{i32 66, i32 0, metadata !238, metadata !1273}
!1277 = metadata !{i32 249, i32 0, metadata !510, null}
!1278 = metadata !{i32 250, i32 0, metadata !510, null}
!1279 = metadata !{i32 251, i32 0, metadata !510, null}
!1280 = metadata !{i32 254, i32 0, metadata !510, null}
!1281 = metadata !{i32 255, i32 0, metadata !510, null}
!1282 = metadata !{i32 256, i32 0, metadata !510, null}
!1283 = metadata !{i32 257, i32 0, metadata !510, null}
!1284 = metadata !{i32 260, i32 0, metadata !510, null}
!1285 = metadata !{i32 1252, i32 0, metadata !136, metadata !1286}
!1286 = metadata !{i32 263, i32 0, metadata !512, null}
!1287 = metadata !{i32 1254, i32 0, metadata !304, metadata !1286}
!1288 = metadata !{i32 1255, i32 0, metadata !304, metadata !1286}
!1289 = metadata !{i32 1259, i32 0, metadata !140, metadata !1290}
!1290 = metadata !{i32 264, i32 0, metadata !512, null}
!1291 = metadata !{i32 1260, i32 0, metadata !307, metadata !1290}
!1292 = metadata !{i32 1261, i32 0, metadata !307, metadata !1290}
!1293 = metadata !{i32 268, i32 0, metadata !512, null}
!1294 = metadata !{i32 269, i32 0, metadata !512, null}
!1295 = metadata !{i32 270, i32 0, metadata !512, null}
!1296 = metadata !{i32 272, i32 0, metadata !512, null}
!1297 = metadata !{i32 274, i32 0, metadata !512, null}
!1298 = metadata !{i32 275, i32 0, metadata !512, null}
!1299 = metadata !{i32 276, i32 0, metadata !512, null}
!1300 = metadata !{i32 279, i32 0, metadata !512, null}
!1301 = metadata !{i32 280, i32 0, metadata !512, null}
!1302 = metadata !{i32 284, i32 0, metadata !510, null}
!1303 = metadata !{i32 285, i32 0, metadata !510, null}
!1304 = metadata !{i32 289, i32 0, metadata !510, null}
!1305 = metadata !{i32 290, i32 0, metadata !510, null}
!1306 = metadata !{i32 293, i32 0, metadata !510, null}
!1307 = metadata !{i32 294, i32 0, metadata !510, null}
!1308 = metadata !{i32 296, i32 0, metadata !510, null}
!1309 = metadata !{i32 240, i32 0, metadata !510, null}
!1310 = metadata !{i32 542, i32 0, metadata !220, null}
!1311 = metadata !{i32 63, i32 0, metadata !59, metadata !1312}
!1312 = metadata !{i32 545, i32 0, metadata !518, null}
!1313 = metadata !{i32 64, i32 0, metadata !239, metadata !1312}
!1314 = metadata !{i32 65, i32 0, metadata !238, metadata !1312}
!1315 = metadata !{i32 66, i32 0, metadata !238, metadata !1312}
!1316 = metadata !{i32 547, i32 0, metadata !518, null}
!1317 = metadata !{i32 548, i32 0, metadata !518, null}
!1318 = metadata !{i32 549, i32 0, metadata !518, null}
!1319 = metadata !{i32 552, i32 0, metadata !518, null}
!1320 = metadata !{i32 553, i32 0, metadata !518, null}
!1321 = metadata !{i32 554, i32 0, metadata !518, null}
!1322 = metadata !{i32 555, i32 0, metadata !518, null}
!1323 = metadata !{i32 556, i32 0, metadata !518, null}
!1324 = metadata !{i32 559, i32 0, metadata !518, null}
!1325 = metadata !{i32 507, i32 0, metadata !217, metadata !1326}
!1326 = metadata !{i32 560, i32 0, metadata !518, null}
!1327 = metadata !{i32 508, i32 0, metadata !1328, metadata !1326}
!1328 = metadata !{i32 589835, metadata !217, i32 507, i32 0, metadata !1, i32 71} ; [ DW_TAG_lexical_block ]
!1329 = metadata !{i32 509, i32 0, metadata !1328, metadata !1326}
!1330 = metadata !{i32 510, i32 0, metadata !1328, metadata !1326}
!1331 = metadata !{i32 511, i32 0, metadata !1328, metadata !1326}
!1332 = metadata !{i32 513, i32 0, metadata !1328, metadata !1326}
!1333 = metadata !{i32 515, i32 0, metadata !1328, metadata !1326}
!1334 = metadata !{i32 516, i32 0, metadata !1328, metadata !1326}
!1335 = metadata !{i32 562, i32 0, metadata !520, null}
!1336 = metadata !{i32 563, i32 0, metadata !520, null}
!1337 = metadata !{i32 564, i32 0, metadata !520, null}
!1338 = metadata !{i32 520, i32 0, metadata !223, null}
!1339 = metadata !{i32 39, i32 0, metadata !0, metadata !1340}
!1340 = metadata !{i32 523, i32 0, metadata !524, null}
!1341 = metadata !{i32 40, i32 0, metadata !232, metadata !1340}
!1342 = metadata !{i32 43, i32 0, metadata !232, metadata !1340}
!1343 = metadata !{i32 46, i32 0, metadata !232, metadata !1340}
!1344 = metadata !{i32 47, i32 0, metadata !232, metadata !1340}
!1345 = metadata !{i32 48, i32 0, metadata !235, metadata !1340}
!1346 = metadata !{i32 49, i32 0, metadata !235, metadata !1340}
!1347 = metadata !{i32 51, i32 0, metadata !235, metadata !1340}
!1348 = metadata !{i32 525, i32 0, metadata !524, null}
!1349 = metadata !{i32 526, i32 0, metadata !524, null}
!1350 = metadata !{i32 527, i32 0, metadata !524, null}
!1351 = metadata !{i32 528, i32 0, metadata !524, null}
!1352 = metadata !{i32 529, i32 0, metadata !524, null}
!1353 = metadata !{i32 532, i32 0, metadata !524, null}
!1354 = metadata !{i32 507, i32 0, metadata !217, metadata !1355}
!1355 = metadata !{i32 533, i32 0, metadata !524, null}
!1356 = metadata !{i32 508, i32 0, metadata !1328, metadata !1355}
!1357 = metadata !{i32 509, i32 0, metadata !1328, metadata !1355}
!1358 = metadata !{i32 510, i32 0, metadata !1328, metadata !1355}
!1359 = metadata !{i32 511, i32 0, metadata !1328, metadata !1355}
!1360 = metadata !{i32 513, i32 0, metadata !1328, metadata !1355}
!1361 = metadata !{i32 515, i32 0, metadata !1328, metadata !1355}
!1362 = metadata !{i32 516, i32 0, metadata !1328, metadata !1355}
!1363 = metadata !{i32 1265, i32 0, metadata !146, metadata !1364}
!1364 = metadata !{i32 535, i32 0, metadata !526, null}
!1365 = metadata !{i32 1252, i32 0, metadata !136, metadata !1366}
!1366 = metadata !{i32 1266, i32 0, metadata !314, metadata !1364}
!1367 = metadata !{i32 1254, i32 0, metadata !304, metadata !1366}
!1368 = metadata !{i32 1255, i32 0, metadata !304, metadata !1366}
!1369 = metadata !{i32 1269, i32 0, metadata !314, metadata !1364}
!1370 = metadata !{i32 1270, i32 0, metadata !317, metadata !1364}
!1371 = metadata !{i32 1271, i32 0, metadata !317, metadata !1364}
!1372 = metadata !{i32 1273, i32 0, metadata !317, metadata !1364}
!1373 = metadata !{i32 1276, i32 0, metadata !317, metadata !1364}
!1374 = metadata !{i32 1279, i32 0, metadata !319, metadata !1364}
!1375 = metadata !{i32 1280, i32 0, metadata !319, metadata !1364}
!1376 = metadata !{i32 1281, i32 0, metadata !319, metadata !1364}
!1377 = metadata !{i32 1282, i32 0, metadata !319, metadata !1364}
!1378 = metadata !{i32 536, i32 0, metadata !526, null}
!1379 = metadata !{i32 537, i32 0, metadata !526, null}
!1380 = metadata !{i32 301, i32 0, metadata !226, null}
!1381 = metadata !{i32 305, i32 0, metadata !531, null}
!1382 = metadata !{i32 63, i32 0, metadata !59, metadata !1383}
!1383 = metadata !{i32 307, i32 0, metadata !531, null}
!1384 = metadata !{i32 64, i32 0, metadata !239, metadata !1383}
!1385 = metadata !{i32 65, i32 0, metadata !238, metadata !1383}
!1386 = metadata !{i32 66, i32 0, metadata !238, metadata !1383}
!1387 = metadata !{i32 309, i32 0, metadata !531, null}
!1388 = metadata !{i32 310, i32 0, metadata !531, null}
!1389 = metadata !{i32 311, i32 0, metadata !531, null}
!1390 = metadata !{i32 314, i32 0, metadata !531, null}
!1391 = metadata !{i32 315, i32 0, metadata !531, null}
!1392 = metadata !{i32 316, i32 0, metadata !531, null}
!1393 = metadata !{i32 317, i32 0, metadata !531, null}
!1394 = metadata !{i32 320, i32 0, metadata !531, null}
!1395 = metadata !{i32 1252, i32 0, metadata !136, metadata !1396}
!1396 = metadata !{i32 323, i32 0, metadata !533, null}
!1397 = metadata !{i32 1254, i32 0, metadata !304, metadata !1396}
!1398 = metadata !{i32 1255, i32 0, metadata !304, metadata !1396}
!1399 = metadata !{i32 1259, i32 0, metadata !140, metadata !1400}
!1400 = metadata !{i32 324, i32 0, metadata !533, null}
!1401 = metadata !{i32 1260, i32 0, metadata !307, metadata !1400}
!1402 = metadata !{i32 1261, i32 0, metadata !307, metadata !1400}
!1403 = metadata !{i32 328, i32 0, metadata !533, null}
!1404 = metadata !{i32 329, i32 0, metadata !533, null}
!1405 = metadata !{i32 330, i32 0, metadata !533, null}
!1406 = metadata !{i32 331, i32 0, metadata !533, null}
!1407 = metadata !{i32 333, i32 0, metadata !533, null}
!1408 = metadata !{i32 334, i32 0, metadata !533, null}
!1409 = metadata !{i32 335, i32 0, metadata !533, null}
!1410 = metadata !{i32 338, i32 0, metadata !533, null}
!1411 = metadata !{i32 339, i32 0, metadata !533, null}
!1412 = metadata !{i32 340, i32 0, metadata !533, null}
!1413 = metadata !{i32 346, i32 0, metadata !535, null}
!1414 = metadata !{i32 347, i32 0, metadata !535, null}
!1415 = metadata !{i32 350, i32 0, metadata !535, null}
!1416 = metadata !{i32 351, i32 0, metadata !535, null}
!1417 = metadata !{i32 353, i32 0, metadata !535, null}
!1418 = metadata !{i32 354, i32 0, metadata !535, null}
!1419 = metadata !{i32 358, i32 0, metadata !535, null}
!1420 = metadata !{i32 359, i32 0, metadata !535, null}
!1421 = metadata !{i32 361, i32 0, metadata !535, null}
!1422 = metadata !{i32 362, i32 0, metadata !535, null}
!1423 = metadata !{i32 364, i32 0, metadata !535, null}
!1424 = metadata !{i32 365, i32 0, metadata !535, null}
!1425 = metadata !{i32 367, i32 0, metadata !535, null}
!1426 = metadata !{i32 368, i32 0, metadata !535, null}
!1427 = metadata !{i32 128, i32 0, metadata !227, null}
!1428 = metadata !{i32 133, i32 0, metadata !540, null}
!1429 = metadata !{i32 134, i32 0, metadata !540, null}
!1430 = metadata !{i32 136, i32 0, metadata !540, null}
!1431 = metadata !{i32 137, i32 0, metadata !540, null}
!1432 = metadata !{i32 138, i32 0, metadata !540, null}
!1433 = metadata !{i32 141, i32 0, metadata !540, null}
!1434 = metadata !{i32 144, i32 0, metadata !540, null}
!1435 = metadata !{i32 39, i32 0, metadata !0, metadata !1436}
!1436 = metadata !{i32 146, i32 0, metadata !540, null}
!1437 = metadata !{i32 40, i32 0, metadata !232, metadata !1436}
!1438 = metadata !{i32 43, i32 0, metadata !232, metadata !1436}
!1439 = metadata !{i32 46, i32 0, metadata !232, metadata !1436}
!1440 = metadata !{i32 47, i32 0, metadata !232, metadata !1436}
!1441 = metadata !{i32 48, i32 0, metadata !235, metadata !1436}
!1442 = metadata !{i32 49, i32 0, metadata !235, metadata !1436}
!1443 = metadata !{i32 147, i32 0, metadata !540, null}
!1444 = metadata !{i32 150, i32 0, metadata !540, null}
!1445 = metadata !{i32 153, i32 0, metadata !540, null}
!1446 = metadata !{i32 154, i32 0, metadata !540, null}
!1447 = metadata !{i32 168, i32 0, metadata !540, null}
!1448 = metadata !{i32 169, i32 0, metadata !540, null}
!1449 = metadata !{i32 170, i32 0, metadata !540, null}
!1450 = metadata !{i32 173, i32 0, metadata !540, null}
!1451 = metadata !{i32 97, i32 0, metadata !77, metadata !1450}
!1452 = metadata !{i32 99, i32 0, metadata !246, metadata !1450}
!1453 = metadata !{i32 101, i32 0, metadata !246, metadata !1450}
!1454 = metadata !{i32 107, i32 0, metadata !246, metadata !1450}
!1455 = metadata !{i32 118, i32 0, metadata !246, metadata !1450}
!1456 = metadata !{i32 121, i32 0, metadata !246, metadata !1450}
!1457 = metadata !{i32 174, i32 0, metadata !540, null}
!1458 = metadata !{i32 175, i32 0, metadata !540, null}
!1459 = metadata !{i32 178, i32 0, metadata !540, null}
!1460 = metadata !{i32 1265, i32 0, metadata !146, metadata !1461}
!1461 = metadata !{i32 181, i32 0, metadata !544, null}
!1462 = metadata !{i32 1252, i32 0, metadata !136, metadata !1463}
!1463 = metadata !{i32 1266, i32 0, metadata !314, metadata !1461}
!1464 = metadata !{i32 1254, i32 0, metadata !304, metadata !1463}
!1465 = metadata !{i32 1255, i32 0, metadata !304, metadata !1463}
!1466 = metadata !{i32 1269, i32 0, metadata !314, metadata !1461}
!1467 = metadata !{i32 1270, i32 0, metadata !317, metadata !1461}
!1468 = metadata !{i32 1271, i32 0, metadata !317, metadata !1461}
!1469 = metadata !{i32 1273, i32 0, metadata !317, metadata !1461}
!1470 = metadata !{i32 1276, i32 0, metadata !317, metadata !1461}
!1471 = metadata !{i32 1279, i32 0, metadata !319, metadata !1461}
!1472 = metadata !{i32 1280, i32 0, metadata !319, metadata !1461}
!1473 = metadata !{i32 1281, i32 0, metadata !319, metadata !1461}
!1474 = metadata !{i32 1282, i32 0, metadata !319, metadata !1461}
!1475 = metadata !{i32 182, i32 0, metadata !544, null}
!1476 = metadata !{i32 183, i32 0, metadata !544, null}
!1477 = metadata !{i32 184, i32 0, metadata !544, null}
!1478 = metadata !{i32 186, i32 0, metadata !544, null}
!1479 = metadata !{i32 190, i32 0, metadata !540, null}
!1480 = metadata !{i32 189, i32 0, metadata !540, null}
!1481 = metadata !{i32 191, i32 0, metadata !540, null}
!1482 = metadata !{i32 193, i32 0, metadata !540, null}
!1483 = metadata !{i32 195, i32 0, metadata !540, null}
