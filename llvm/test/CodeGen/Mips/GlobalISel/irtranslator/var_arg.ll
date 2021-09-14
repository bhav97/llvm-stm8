; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -O0 -mtriple=mipsel-linux-gnu -global-isel -stop-after=irtranslator -verify-machineinstrs %s -o - | FileCheck %s -check-prefixes=MIPS32

@.str = private unnamed_addr constant [11 x i8] c"string %s\0A\00", align 1
declare void @llvm.va_start(i8*)
declare void @llvm.va_copy(i8*, i8*)
declare i32 @printf(i8*, ...)

define void @testVaCopyArg(i8* %fmt, ...) {
  ; MIPS32-LABEL: name: testVaCopyArg
  ; MIPS32: bb.1.entry:
  ; MIPS32:   liveins: $a0, $a1, $a2, $a3
  ; MIPS32:   [[COPY:%[0-9]+]]:_(p0) = COPY $a0
  ; MIPS32:   [[COPY1:%[0-9]+]]:_(s32) = COPY $a1
  ; MIPS32:   [[FRAME_INDEX:%[0-9]+]]:_(p0) = G_FRAME_INDEX %fixed-stack.2
  ; MIPS32:   G_STORE [[COPY1]](s32), [[FRAME_INDEX]](p0) :: (store (s32) into %fixed-stack.2)
  ; MIPS32:   [[COPY2:%[0-9]+]]:_(s32) = COPY $a2
  ; MIPS32:   [[FRAME_INDEX1:%[0-9]+]]:_(p0) = G_FRAME_INDEX %fixed-stack.1
  ; MIPS32:   G_STORE [[COPY2]](s32), [[FRAME_INDEX1]](p0) :: (store (s32) into %fixed-stack.1)
  ; MIPS32:   [[COPY3:%[0-9]+]]:_(s32) = COPY $a3
  ; MIPS32:   [[FRAME_INDEX2:%[0-9]+]]:_(p0) = G_FRAME_INDEX %fixed-stack.0
  ; MIPS32:   G_STORE [[COPY3]](s32), [[FRAME_INDEX2]](p0) :: (store (s32) into %fixed-stack.0)
  ; MIPS32:   [[GV:%[0-9]+]]:_(p0) = G_GLOBAL_VALUE @.str
  ; MIPS32:   [[COPY4:%[0-9]+]]:_(p0) = COPY [[GV]](p0)
  ; MIPS32:   [[FRAME_INDEX3:%[0-9]+]]:_(p0) = G_FRAME_INDEX %stack.0.fmt.addr
  ; MIPS32:   [[FRAME_INDEX4:%[0-9]+]]:_(p0) = G_FRAME_INDEX %stack.1.ap
  ; MIPS32:   [[FRAME_INDEX5:%[0-9]+]]:_(p0) = G_FRAME_INDEX %stack.2.aq
  ; MIPS32:   [[FRAME_INDEX6:%[0-9]+]]:_(p0) = G_FRAME_INDEX %stack.3.s
  ; MIPS32:   G_STORE [[COPY]](p0), [[FRAME_INDEX3]](p0) :: (store (p0) into %ir.fmt.addr)
  ; MIPS32:   G_VASTART [[FRAME_INDEX4]](p0) :: (store (s32) into %ir.ap1, align 1)
  ; MIPS32:   G_INTRINSIC_W_SIDE_EFFECTS intrinsic(@llvm.va_copy), [[FRAME_INDEX5]](p0), [[FRAME_INDEX4]](p0)
  ; MIPS32:   [[LOAD:%[0-9]+]]:_(p0) = G_LOAD [[FRAME_INDEX5]](p0) :: (dereferenceable load (p0) from %ir.aq)
  ; MIPS32:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 4
  ; MIPS32:   [[PTR_ADD:%[0-9]+]]:_(p0) = G_PTR_ADD [[LOAD]], [[C]](s32)
  ; MIPS32:   G_STORE [[PTR_ADD]](p0), [[FRAME_INDEX5]](p0) :: (store (p0) into %ir.aq)
  ; MIPS32:   [[LOAD1:%[0-9]+]]:_(p0) = G_LOAD [[LOAD]](p0) :: (load (p0) from %ir.2)
  ; MIPS32:   G_STORE [[LOAD1]](p0), [[FRAME_INDEX6]](p0) :: (store (p0) into %ir.s)
  ; MIPS32:   [[LOAD2:%[0-9]+]]:_(p0) = G_LOAD [[FRAME_INDEX6]](p0) :: (dereferenceable load (p0) from %ir.s)
  ; MIPS32:   ADJCALLSTACKDOWN 16, 0, implicit-def $sp, implicit $sp
  ; MIPS32:   $a0 = COPY [[COPY4]](p0)
  ; MIPS32:   $a1 = COPY [[LOAD2]](p0)
  ; MIPS32:   JAL @printf, csr_o32, implicit-def $ra, implicit-def $sp, implicit $a0, implicit $a1, implicit-def $v0
  ; MIPS32:   [[COPY5:%[0-9]+]]:_(s32) = COPY $v0
  ; MIPS32:   ADJCALLSTACKUP 16, 0, implicit-def $sp, implicit $sp
  ; MIPS32:   RetRA
entry:
  %fmt.addr = alloca i8*, align 4
  %ap = alloca i8*, align 4
  %aq = alloca i8*, align 4
  %s = alloca i8*, align 4
  store i8* %fmt, i8** %fmt.addr, align 4
  %ap1 = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap1)
  %0 = bitcast i8** %aq to i8*
  %1 = bitcast i8** %ap to i8*
  call void @llvm.va_copy(i8* %0, i8* %1)
  %argp.cur = load i8*, i8** %aq, align 4
  %argp.next = getelementptr inbounds i8, i8* %argp.cur, i32 4
  store i8* %argp.next, i8** %aq, align 4
  %2 = bitcast i8* %argp.cur to i8**
  %3 = load i8*, i8** %2, align 4
  store i8* %3, i8** %s, align 4
  %4 = load i8*, i8** %s, align 4
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i32 0, i32 0), i8* %4)
  ret void
}