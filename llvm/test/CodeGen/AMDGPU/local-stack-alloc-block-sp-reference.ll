; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx906 < %s | FileCheck -check-prefixes=GCN,GFX9 %s

; Make sure we use the correct frame offset is used with the local
; frame area.
;
; %pin.low is allocated to offset 0.
;
; %local.area is assigned to the local frame offset by the
; LocalStackSlotAllocation pass at offset 4096.
;
; The %load1 access to %gep.large.offset initially used the stack
; pointer register and directly referenced the frame index. After
; LocalStackSlotAllocation, it would no longer refer to a frame index
; so eliminateFrameIndex would not adjust the access to use the
; correct FP offset.

define amdgpu_kernel void @local_stack_offset_uses_sp(i64 addrspace(1)* %out, i8 addrspace(1)* %in) {
; GCN-LABEL: local_stack_offset_uses_sp:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_load_dwordx2 s[4:5], s[4:5], 0x0
; GCN-NEXT:    s_add_u32 flat_scratch_lo, s6, s9
; GCN-NEXT:    s_addc_u32 flat_scratch_hi, s7, 0
; GCN-NEXT:    s_add_u32 s0, s0, s9
; GCN-NEXT:    v_mov_b32_e32 v1, 0x3000
; GCN-NEXT:    s_addc_u32 s1, s1, 0
; GCN-NEXT:    v_add_u32_e32 v0, 64, v1
; GCN-NEXT:    v_mov_b32_e32 v2, 0
; GCN-NEXT:    v_mov_b32_e32 v3, 0x2000
; GCN-NEXT:    s_mov_b32 s6, 0
; GCN-NEXT:    buffer_store_dword v2, v3, s[0:3], 0 offen
; GCN-NEXT:  BB0_1: ; %loadstoreloop
; GCN-NEXT:    ; =>This Inner Loop Header: Depth=1
; GCN-NEXT:    v_add_u32_e32 v3, s6, v1
; GCN-NEXT:    s_add_i32 s6, s6, 1
; GCN-NEXT:    s_cmpk_lt_u32 s6, 0x2120
; GCN-NEXT:    buffer_store_byte v2, v3, s[0:3], 0 offen
; GCN-NEXT:    s_cbranch_scc1 BB0_1
; GCN-NEXT:  ; %bb.2: ; %split
; GCN-NEXT:    v_mov_b32_e32 v1, 0x3000
; GCN-NEXT:    v_add_u32_e32 v1, 0x20d0, v1
; GCN-NEXT:    buffer_load_dword v2, v1, s[0:3], 0 offen
; GCN-NEXT:    buffer_load_dword v1, v1, s[0:3], 0 offen offset:4
; GCN-NEXT:    buffer_load_dword v3, v0, s[0:3], 0 offen
; GCN-NEXT:    buffer_load_dword v4, v0, s[0:3], 0 offen offset:4
; GCN-NEXT:    s_waitcnt vmcnt(1)
; GCN-NEXT:    v_add_co_u32_e32 v0, vcc, v2, v3
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v2, s4
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_addc_co_u32_e32 v1, vcc, v1, v4, vcc
; GCN-NEXT:    v_mov_b32_e32 v3, s5
; GCN-NEXT:    global_store_dwordx2 v[2:3], v[0:1], off
; GCN-NEXT:    s_endpgm
entry:
  %pin.low = alloca i32, align 8192, addrspace(5)
  %local.area = alloca [1060 x i64], align 4096, addrspace(5)
  store volatile i32 0, i32 addrspace(5)* %pin.low
  %local.area.cast = bitcast [1060 x i64] addrspace(5)* %local.area to i8 addrspace(5)*
  call void @llvm.memset.p5i8.i32(i8 addrspace(5)* align 4 %local.area.cast, i8 0, i32 8480, i1 true)
  %gep.large.offset = getelementptr inbounds [1060 x i64], [1060 x i64] addrspace(5)* %local.area, i64 0, i64 1050
  %gep.small.offset = getelementptr inbounds [1060 x i64], [1060 x i64] addrspace(5)* %local.area, i64 0, i64 8
  %load0 = load volatile i64, i64 addrspace(5)* %gep.large.offset
  %load1 = load volatile i64, i64 addrspace(5)* %gep.small.offset
  %add0 = add i64 %load0, %load1
  store volatile i64 %add0, i64 addrspace(1)* %out
  ret void
}

define void @func_local_stack_offset_uses_sp(i64 addrspace(1)* %out, i8 addrspace(1)* %in) {
; GCN-LABEL: func_local_stack_offset_uses_sp:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_add_u32 s4, s32, 0x7ffc0
; GCN-NEXT:    s_mov_b32 s5, s33
; GCN-NEXT:    s_and_b32 s33, s4, 0xfff80000
; GCN-NEXT:    v_lshrrev_b32_e64 v3, 6, s33
; GCN-NEXT:    v_add_u32_e32 v3, 0x1000, v3
; GCN-NEXT:    v_mov_b32_e32 v4, 0
; GCN-NEXT:    v_add_u32_e32 v2, 64, v3
; GCN-NEXT:    s_mov_b32 s4, 0
; GCN-NEXT:    s_add_u32 s32, s32, 0x180000
; GCN-NEXT:    buffer_store_dword v4, off, s[0:3], s33
; GCN-NEXT:  BB1_1: ; %loadstoreloop
; GCN-NEXT:    ; =>This Inner Loop Header: Depth=1
; GCN-NEXT:    v_add_u32_e32 v5, s4, v3
; GCN-NEXT:    s_add_i32 s4, s4, 1
; GCN-NEXT:    s_cmpk_lt_u32 s4, 0x2120
; GCN-NEXT:    buffer_store_byte v4, v5, s[0:3], 0 offen
; GCN-NEXT:    s_cbranch_scc1 BB1_1
; GCN-NEXT:  ; %bb.2: ; %split
; GCN-NEXT:    v_lshrrev_b32_e64 v3, 6, s33
; GCN-NEXT:    v_add_u32_e32 v3, 0x1000, v3
; GCN-NEXT:    v_add_u32_e32 v3, 0x20d0, v3
; GCN-NEXT:    buffer_load_dword v4, v3, s[0:3], 0 offen
; GCN-NEXT:    buffer_load_dword v3, v3, s[0:3], 0 offen offset:4
; GCN-NEXT:    buffer_load_dword v5, v2, s[0:3], 0 offen
; GCN-NEXT:    buffer_load_dword v6, v2, s[0:3], 0 offen offset:4
; GCN-NEXT:    s_sub_u32 s32, s32, 0x180000
; GCN-NEXT:    s_mov_b32 s33, s5
; GCN-NEXT:    s_waitcnt vmcnt(1)
; GCN-NEXT:    v_add_co_u32_e32 v2, vcc, v4, v5
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_addc_co_u32_e32 v3, vcc, v3, v6, vcc
; GCN-NEXT:    global_store_dwordx2 v[0:1], v[2:3], off
; GCN-NEXT:    s_setpc_b64 s[30:31]
entry:
  %pin.low = alloca i32, align 8192, addrspace(5)
  %local.area = alloca [1060 x i64], align 4096, addrspace(5)
  store volatile i32 0, i32 addrspace(5)* %pin.low
  %local.area.cast = bitcast [1060 x i64] addrspace(5)* %local.area to i8 addrspace(5)*
  call void @llvm.memset.p5i8.i32(i8 addrspace(5)* align 4 %local.area.cast, i8 0, i32 8480, i1 true)
  %gep.large.offset = getelementptr inbounds [1060 x i64], [1060 x i64] addrspace(5)* %local.area, i64 0, i64 1050
  %gep.small.offset = getelementptr inbounds [1060 x i64], [1060 x i64] addrspace(5)* %local.area, i64 0, i64 8
  %load0 = load volatile i64, i64 addrspace(5)* %gep.large.offset
  %load1 = load volatile i64, i64 addrspace(5)* %gep.small.offset
  %add0 = add i64 %load0, %load1
  store volatile i64 %add0, i64 addrspace(1)* %out
  ret void
}

declare void @llvm.memset.p5i8.i32(i8 addrspace(5)* nocapture writeonly, i8, i32, i1 immarg) #0

attributes #0 = { argmemonly nounwind willreturn writeonly }
