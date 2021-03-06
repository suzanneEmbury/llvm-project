; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=kaveri -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,CI %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX9 %s

; GCN-LABEL: {{^}}atomic_store_monotonic_i32:
; GCN: s_waitcnt
; GFX9-NOT: s_mov_b32 m0
; CI-NEXT: s_mov_b32 m0
; GCN-NEXT: ds_write_b32 v0, v1{{$}}
; GCN-NEXT: s_setpc_b64
define void @atomic_store_monotonic_i32(i32 addrspace(3)* %ptr, i32 %val) {
  store atomic i32 %val, i32 addrspace(3)* %ptr monotonic, align 4
  ret void
}

; GCN-LABEL: {{^}}atomic_store_monotonic_offset_i32:
; GCN: s_waitcnt
; GFX9-NOT: s_mov_b32 m0
; CI-NEXT: s_mov_b32 m0
; GCN-NEXT: ds_write_b32 v0, v1 offset:64{{$}}
; GCN-NEXT: s_setpc_b64
define void @atomic_store_monotonic_offset_i32(i32 addrspace(3)* %ptr, i32 %val) {
  %gep = getelementptr inbounds i32, i32 addrspace(3)* %ptr, i32 16
  store atomic i32 %val, i32 addrspace(3)* %gep monotonic, align 4
  ret void
}

; GCN-LABEL: {{^}}atomic_store_monotonic_i64:
; GCN: s_waitcnt
; GFX9-NOT: s_mov_b32 m0
; CI-NEXT: s_mov_b32 m0
; GCN-NEXT: ds_write_b64 v0, v[1:2]{{$}}
; GCN-NEXT: s_setpc_b64
define void @atomic_store_monotonic_i64(i64 addrspace(3)* %ptr, i64 %val) {
  store atomic i64 %val, i64 addrspace(3)* %ptr monotonic, align 8
  ret void
}

; GCN-LABEL: {{^}}atomic_store_monotonic_offset_i64:
; GCN: s_waitcnt
; GFX9-NOT: s_mov_b32 m0
; CI-NEXT: s_mov_b32 m0
; GCN-NEXT: ds_write_b64 v0, v[1:2] offset:128{{$}}
; GCN-NEXT: s_setpc_b64
define void @atomic_store_monotonic_offset_i64(i64 addrspace(3)* %ptr, i64 %val) {
  %gep = getelementptr inbounds i64, i64 addrspace(3)* %ptr, i64 16
  store atomic i64 %val, i64 addrspace(3)* %gep monotonic, align 8
  ret void
}
