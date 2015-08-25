; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=ALL --check-prefix=SSE --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=ALL --check-prefix=SSE --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=ALL --check-prefix=SSE --check-prefix=SSE42
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512BW

;
; Signed Maximum (GT)
;

define <2 x i64> @max_gt_v2i64(<2 x i64> %a, <2 x i64> %b) {
; SSE2-LABEL: max_gt_v2i64:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [2147483648,0,2147483648,0]
; SSE2-NEXT:    movdqa %xmm1, %xmm3
; SSE2-NEXT:    pxor %xmm2, %xmm3
; SSE2-NEXT:    pxor %xmm0, %xmm2
; SSE2-NEXT:    movdqa %xmm2, %xmm4
; SSE2-NEXT:    pcmpgtd %xmm3, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm3, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; SSE2-NEXT:    pand %xmm5, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm4[1,1,3,3]
; SSE2-NEXT:    por %xmm2, %xmm3
; SSE2-NEXT:    pand %xmm3, %xmm0
; SSE2-NEXT:    pandn %xmm1, %xmm3
; SSE2-NEXT:    por %xmm3, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_gt_v2i64:
; SSE41:       # BB#0:
; SSE41-NEXT:    movdqa %xmm0, %xmm2
; SSE41-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE41-NEXT:    movdqa %xmm1, %xmm3
; SSE41-NEXT:    pxor %xmm0, %xmm3
; SSE41-NEXT:    pxor %xmm2, %xmm0
; SSE41-NEXT:    movdqa %xmm0, %xmm4
; SSE41-NEXT:    pcmpgtd %xmm3, %xmm4
; SSE41-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm3, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; SSE41-NEXT:    pand %xmm5, %xmm3
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm4[1,1,3,3]
; SSE41-NEXT:    por %xmm3, %xmm0
; SSE41-NEXT:    blendvpd %xmm2, %xmm1
; SSE41-NEXT:    movapd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_gt_v2i64:
; SSE42:       # BB#0:
; SSE42-NEXT:    movdqa %xmm0, %xmm2
; SSE42-NEXT:    pcmpgtq %xmm1, %xmm0
; SSE42-NEXT:    blendvpd %xmm2, %xmm1
; SSE42-NEXT:    movapd %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: max_gt_v2i64:
; AVX:       # BB#0:
; AVX-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm2
; AVX-NEXT:    vblendvpd %xmm2, %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = icmp sgt <2 x i64> %a, %b
  %2 = select <2 x i1> %1, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %2
}

define <4 x i64> @max_gt_v4i64(<4 x i64> %a, <4 x i64> %b) {
; SSE2-LABEL: max_gt_v4i64:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm4 = [2147483648,0,2147483648,0]
; SSE2-NEXT:    movdqa %xmm3, %xmm5
; SSE2-NEXT:    pxor %xmm4, %xmm5
; SSE2-NEXT:    movdqa %xmm1, %xmm6
; SSE2-NEXT:    pxor %xmm4, %xmm6
; SSE2-NEXT:    movdqa %xmm6, %xmm7
; SSE2-NEXT:    pcmpgtd %xmm5, %xmm7
; SSE2-NEXT:    pshufd {{.*#+}} xmm8 = xmm7[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm5, %xmm6
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm6[1,1,3,3]
; SSE2-NEXT:    pand %xmm8, %xmm5
; SSE2-NEXT:    pshufd {{.*#+}} xmm6 = xmm7[1,1,3,3]
; SSE2-NEXT:    por %xmm5, %xmm6
; SSE2-NEXT:    movdqa %xmm2, %xmm5
; SSE2-NEXT:    pxor %xmm4, %xmm5
; SSE2-NEXT:    pxor %xmm0, %xmm4
; SSE2-NEXT:    movdqa %xmm4, %xmm7
; SSE2-NEXT:    pcmpgtd %xmm5, %xmm7
; SSE2-NEXT:    pshufd {{.*#+}} xmm8 = xmm7[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm5, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSE2-NEXT:    pand %xmm8, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm7[1,1,3,3]
; SSE2-NEXT:    por %xmm4, %xmm5
; SSE2-NEXT:    pand %xmm5, %xmm0
; SSE2-NEXT:    pandn %xmm2, %xmm5
; SSE2-NEXT:    por %xmm5, %xmm0
; SSE2-NEXT:    pand %xmm6, %xmm1
; SSE2-NEXT:    pandn %xmm3, %xmm6
; SSE2-NEXT:    por %xmm6, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_gt_v4i64:
; SSE41:       # BB#0:
; SSE41-NEXT:    movdqa %xmm0, %xmm8
; SSE41-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE41-NEXT:    movdqa %xmm3, %xmm5
; SSE41-NEXT:    pxor %xmm0, %xmm5
; SSE41-NEXT:    movdqa %xmm1, %xmm6
; SSE41-NEXT:    pxor %xmm0, %xmm6
; SSE41-NEXT:    movdqa %xmm6, %xmm7
; SSE41-NEXT:    pcmpgtd %xmm5, %xmm7
; SSE41-NEXT:    pshufd {{.*#+}} xmm4 = xmm7[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm5, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm6 = xmm6[1,1,3,3]
; SSE41-NEXT:    pand %xmm4, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm5 = xmm7[1,1,3,3]
; SSE41-NEXT:    por %xmm6, %xmm5
; SSE41-NEXT:    movdqa %xmm2, %xmm4
; SSE41-NEXT:    pxor %xmm0, %xmm4
; SSE41-NEXT:    pxor %xmm8, %xmm0
; SSE41-NEXT:    movdqa %xmm0, %xmm6
; SSE41-NEXT:    pcmpgtd %xmm4, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm7 = xmm6[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm4, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm4 = xmm0[1,1,3,3]
; SSE41-NEXT:    pand %xmm7, %xmm4
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm6[1,1,3,3]
; SSE41-NEXT:    por %xmm4, %xmm0
; SSE41-NEXT:    blendvpd %xmm8, %xmm2
; SSE41-NEXT:    movdqa %xmm5, %xmm0
; SSE41-NEXT:    blendvpd %xmm1, %xmm3
; SSE41-NEXT:    movapd %xmm2, %xmm0
; SSE41-NEXT:    movapd %xmm3, %xmm1
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_gt_v4i64:
; SSE42:       # BB#0:
; SSE42-NEXT:    movdqa %xmm0, %xmm4
; SSE42-NEXT:    movdqa %xmm1, %xmm5
; SSE42-NEXT:    pcmpgtq %xmm3, %xmm5
; SSE42-NEXT:    pcmpgtq %xmm2, %xmm0
; SSE42-NEXT:    blendvpd %xmm4, %xmm2
; SSE42-NEXT:    movdqa %xmm5, %xmm0
; SSE42-NEXT:    blendvpd %xmm1, %xmm3
; SSE42-NEXT:    movapd %xmm2, %xmm0
; SSE42-NEXT:    movapd %xmm3, %xmm1
; SSE42-NEXT:    retq
;
; AVX1-LABEL: max_gt_v4i64:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpcmpgtq %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm3
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; AVX1-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: max_gt_v4i64:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpcmpgtq %ymm1, %ymm0, %ymm2
; AVX2-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: max_gt_v4i64:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpcmpgtq %ymm1, %ymm0, %ymm2
; AVX512-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX512-NEXT:    retq
  %1 = icmp sgt <4 x i64> %a, %b
  %2 = select <4 x i1> %1, <4 x i64> %a, <4 x i64> %b
  ret <4 x i64> %2
}

define <4 x i32> @max_gt_v4i32(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: max_gt_v4i32:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm2
; SSE2-NEXT:    pand %xmm2, %xmm0
; SSE2-NEXT:    pandn %xmm1, %xmm2
; SSE2-NEXT:    por %xmm0, %xmm2
; SSE2-NEXT:    movdqa %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_gt_v4i32:
; SSE41:       # BB#0:
; SSE41-NEXT:    pmaxsd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_gt_v4i32:
; SSE42:       # BB#0:
; SSE42-NEXT:    pmaxsd %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: max_gt_v4i32:
; AVX:       # BB#0:
; AVX-NEXT:    vpmaxsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = icmp sgt <4 x i32> %a, %b
  %2 = select <4 x i1> %1, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %2
}

define <8 x i32> @max_gt_v8i32(<8 x i32> %a, <8 x i32> %b) {
; SSE2-LABEL: max_gt_v8i32:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa %xmm1, %xmm4
; SSE2-NEXT:    pcmpgtd %xmm3, %xmm4
; SSE2-NEXT:    movdqa %xmm0, %xmm5
; SSE2-NEXT:    pcmpgtd %xmm2, %xmm5
; SSE2-NEXT:    pand %xmm5, %xmm0
; SSE2-NEXT:    pandn %xmm2, %xmm5
; SSE2-NEXT:    por %xmm0, %xmm5
; SSE2-NEXT:    pand %xmm4, %xmm1
; SSE2-NEXT:    pandn %xmm3, %xmm4
; SSE2-NEXT:    por %xmm1, %xmm4
; SSE2-NEXT:    movdqa %xmm5, %xmm0
; SSE2-NEXT:    movdqa %xmm4, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_gt_v8i32:
; SSE41:       # BB#0:
; SSE41-NEXT:    pmaxsd %xmm2, %xmm0
; SSE41-NEXT:    pmaxsd %xmm3, %xmm1
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_gt_v8i32:
; SSE42:       # BB#0:
; SSE42-NEXT:    pmaxsd %xmm2, %xmm0
; SSE42-NEXT:    pmaxsd %xmm3, %xmm1
; SSE42-NEXT:    retq
;
; AVX1-LABEL: max_gt_v8i32:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpmaxsd %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpmaxsd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: max_gt_v8i32:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpmaxsd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: max_gt_v8i32:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpmaxsd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %1 = icmp sgt <8 x i32> %a, %b
  %2 = select <8 x i1> %1, <8 x i32> %a, <8 x i32> %b
  ret <8 x i32> %2
}

define <8 x i16> @max_gt_v8i16(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: max_gt_v8i16:
; SSE:       # BB#0:
; SSE-NEXT:    pmaxsw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: max_gt_v8i16:
; AVX:       # BB#0:
; AVX-NEXT:    vpmaxsw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = icmp sgt <8 x i16> %a, %b
  %2 = select <8 x i1> %1, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %2
}

define <16 x i16> @max_gt_v16i16(<16 x i16> %a, <16 x i16> %b) {
; SSE-LABEL: max_gt_v16i16:
; SSE:       # BB#0:
; SSE-NEXT:    pmaxsw %xmm2, %xmm0
; SSE-NEXT:    pmaxsw %xmm3, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: max_gt_v16i16:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpmaxsw %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpmaxsw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: max_gt_v16i16:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpmaxsw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: max_gt_v16i16:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpmaxsw %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %1 = icmp sgt <16 x i16> %a, %b
  %2 = select <16 x i1> %1, <16 x i16> %a, <16 x i16> %b
  ret <16 x i16> %2
}

define <16 x i8> @max_gt_v16i8(<16 x i8> %a, <16 x i8> %b) {
; SSE2-LABEL: max_gt_v16i8:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    pcmpgtb %xmm1, %xmm2
; SSE2-NEXT:    pand %xmm2, %xmm0
; SSE2-NEXT:    pandn %xmm1, %xmm2
; SSE2-NEXT:    por %xmm0, %xmm2
; SSE2-NEXT:    movdqa %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_gt_v16i8:
; SSE41:       # BB#0:
; SSE41-NEXT:    pmaxsb %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_gt_v16i8:
; SSE42:       # BB#0:
; SSE42-NEXT:    pmaxsb %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: max_gt_v16i8:
; AVX:       # BB#0:
; AVX-NEXT:    vpmaxsb %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = icmp sgt <16 x i8> %a, %b
  %2 = select <16 x i1> %1, <16 x i8> %a, <16 x i8> %b
  ret <16 x i8> %2
}

define <32 x i8> @max_gt_v32i8(<32 x i8> %a, <32 x i8> %b) {
; SSE2-LABEL: max_gt_v32i8:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa %xmm1, %xmm4
; SSE2-NEXT:    pcmpgtb %xmm3, %xmm4
; SSE2-NEXT:    movdqa %xmm0, %xmm5
; SSE2-NEXT:    pcmpgtb %xmm2, %xmm5
; SSE2-NEXT:    pand %xmm5, %xmm0
; SSE2-NEXT:    pandn %xmm2, %xmm5
; SSE2-NEXT:    por %xmm0, %xmm5
; SSE2-NEXT:    pand %xmm4, %xmm1
; SSE2-NEXT:    pandn %xmm3, %xmm4
; SSE2-NEXT:    por %xmm1, %xmm4
; SSE2-NEXT:    movdqa %xmm5, %xmm0
; SSE2-NEXT:    movdqa %xmm4, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_gt_v32i8:
; SSE41:       # BB#0:
; SSE41-NEXT:    pmaxsb %xmm2, %xmm0
; SSE41-NEXT:    pmaxsb %xmm3, %xmm1
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_gt_v32i8:
; SSE42:       # BB#0:
; SSE42-NEXT:    pmaxsb %xmm2, %xmm0
; SSE42-NEXT:    pmaxsb %xmm3, %xmm1
; SSE42-NEXT:    retq
;
; AVX1-LABEL: max_gt_v32i8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpmaxsb %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpmaxsb %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: max_gt_v32i8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpmaxsb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: max_gt_v32i8:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpmaxsb %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %1 = icmp sgt <32 x i8> %a, %b
  %2 = select <32 x i1> %1, <32 x i8> %a, <32 x i8> %b
  ret <32 x i8> %2
}

;
; Signed Maximum (GE)
;

define <2 x i64> @max_ge_v2i64(<2 x i64> %a, <2 x i64> %b) {
; SSE2-LABEL: max_ge_v2i64:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [2147483648,0,2147483648,0]
; SSE2-NEXT:    movdqa %xmm0, %xmm3
; SSE2-NEXT:    pxor %xmm2, %xmm3
; SSE2-NEXT:    pxor %xmm1, %xmm2
; SSE2-NEXT:    movdqa %xmm2, %xmm4
; SSE2-NEXT:    pcmpgtd %xmm3, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm3, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; SSE2-NEXT:    pand %xmm5, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm4[1,1,3,3]
; SSE2-NEXT:    por %xmm2, %xmm3
; SSE2-NEXT:    pcmpeqd %xmm2, %xmm2
; SSE2-NEXT:    pxor %xmm3, %xmm2
; SSE2-NEXT:    pandn %xmm0, %xmm3
; SSE2-NEXT:    pandn %xmm1, %xmm2
; SSE2-NEXT:    por %xmm3, %xmm2
; SSE2-NEXT:    movdqa %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_ge_v2i64:
; SSE41:       # BB#0:
; SSE41-NEXT:    movdqa %xmm0, %xmm2
; SSE41-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE41-NEXT:    movdqa %xmm2, %xmm3
; SSE41-NEXT:    pxor %xmm0, %xmm3
; SSE41-NEXT:    pxor %xmm1, %xmm0
; SSE41-NEXT:    movdqa %xmm0, %xmm4
; SSE41-NEXT:    pcmpgtd %xmm3, %xmm4
; SSE41-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm3, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE41-NEXT:    pand %xmm5, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm4[1,1,3,3]
; SSE41-NEXT:    por %xmm0, %xmm3
; SSE41-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE41-NEXT:    pxor %xmm3, %xmm0
; SSE41-NEXT:    blendvpd %xmm2, %xmm1
; SSE41-NEXT:    movapd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_ge_v2i64:
; SSE42:       # BB#0:
; SSE42-NEXT:    movdqa %xmm0, %xmm2
; SSE42-NEXT:    movdqa %xmm1, %xmm3
; SSE42-NEXT:    pcmpgtq %xmm2, %xmm3
; SSE42-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE42-NEXT:    pxor %xmm3, %xmm0
; SSE42-NEXT:    blendvpd %xmm2, %xmm1
; SSE42-NEXT:    movapd %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: max_ge_v2i64:
; AVX:       # BB#0:
; AVX-NEXT:    vpcmpgtq %xmm0, %xmm1, %xmm2
; AVX-NEXT:    vpcmpeqd %xmm3, %xmm3, %xmm3
; AVX-NEXT:    vpxor %xmm3, %xmm2, %xmm2
; AVX-NEXT:    vblendvpd %xmm2, %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = icmp sge <2 x i64> %a, %b
  %2 = select <2 x i1> %1, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %2
}

define <4 x i64> @max_ge_v4i64(<4 x i64> %a, <4 x i64> %b) {
; SSE2-LABEL: max_ge_v4i64:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm7 = [2147483648,0,2147483648,0]
; SSE2-NEXT:    movdqa %xmm1, %xmm4
; SSE2-NEXT:    pxor %xmm7, %xmm4
; SSE2-NEXT:    movdqa %xmm3, %xmm5
; SSE2-NEXT:    pxor %xmm7, %xmm5
; SSE2-NEXT:    movdqa %xmm5, %xmm6
; SSE2-NEXT:    pcmpgtd %xmm4, %xmm6
; SSE2-NEXT:    pshufd {{.*#+}} xmm8 = xmm6[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm4, %xmm5
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm5[1,1,3,3]
; SSE2-NEXT:    pand %xmm8, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm8 = xmm6[1,1,3,3]
; SSE2-NEXT:    por %xmm4, %xmm8
; SSE2-NEXT:    pcmpeqd %xmm4, %xmm4
; SSE2-NEXT:    movdqa %xmm8, %xmm9
; SSE2-NEXT:    pxor %xmm4, %xmm9
; SSE2-NEXT:    movdqa %xmm0, %xmm6
; SSE2-NEXT:    pxor %xmm7, %xmm6
; SSE2-NEXT:    pxor %xmm2, %xmm7
; SSE2-NEXT:    movdqa %xmm7, %xmm5
; SSE2-NEXT:    pcmpgtd %xmm6, %xmm5
; SSE2-NEXT:    pshufd {{.*#+}} xmm10 = xmm5[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm6, %xmm7
; SSE2-NEXT:    pshufd {{.*#+}} xmm6 = xmm7[1,1,3,3]
; SSE2-NEXT:    pand %xmm10, %xmm6
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm5[1,1,3,3]
; SSE2-NEXT:    por %xmm6, %xmm5
; SSE2-NEXT:    pxor %xmm5, %xmm4
; SSE2-NEXT:    pandn %xmm0, %xmm5
; SSE2-NEXT:    pandn %xmm2, %xmm4
; SSE2-NEXT:    por %xmm5, %xmm4
; SSE2-NEXT:    pandn %xmm1, %xmm8
; SSE2-NEXT:    pandn %xmm3, %xmm9
; SSE2-NEXT:    por %xmm8, %xmm9
; SSE2-NEXT:    movdqa %xmm4, %xmm0
; SSE2-NEXT:    movdqa %xmm9, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_ge_v4i64:
; SSE41:       # BB#0:
; SSE41-NEXT:    movdqa %xmm0, %xmm8
; SSE41-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE41-NEXT:    movdqa %xmm1, %xmm5
; SSE41-NEXT:    pxor %xmm0, %xmm5
; SSE41-NEXT:    movdqa %xmm3, %xmm6
; SSE41-NEXT:    pxor %xmm0, %xmm6
; SSE41-NEXT:    movdqa %xmm6, %xmm7
; SSE41-NEXT:    pcmpgtd %xmm5, %xmm7
; SSE41-NEXT:    pshufd {{.*#+}} xmm4 = xmm7[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm5, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm6 = xmm6[1,1,3,3]
; SSE41-NEXT:    pand %xmm4, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm5 = xmm7[1,1,3,3]
; SSE41-NEXT:    por %xmm6, %xmm5
; SSE41-NEXT:    pcmpeqd %xmm9, %xmm9
; SSE41-NEXT:    pxor %xmm9, %xmm5
; SSE41-NEXT:    movdqa %xmm8, %xmm6
; SSE41-NEXT:    pxor %xmm0, %xmm6
; SSE41-NEXT:    pxor %xmm2, %xmm0
; SSE41-NEXT:    movdqa %xmm0, %xmm7
; SSE41-NEXT:    pcmpgtd %xmm6, %xmm7
; SSE41-NEXT:    pshufd {{.*#+}} xmm4 = xmm7[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm6, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm6 = xmm0[1,1,3,3]
; SSE41-NEXT:    pand %xmm4, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm7[1,1,3,3]
; SSE41-NEXT:    por %xmm6, %xmm0
; SSE41-NEXT:    pxor %xmm9, %xmm0
; SSE41-NEXT:    blendvpd %xmm8, %xmm2
; SSE41-NEXT:    movdqa %xmm5, %xmm0
; SSE41-NEXT:    blendvpd %xmm1, %xmm3
; SSE41-NEXT:    movapd %xmm2, %xmm0
; SSE41-NEXT:    movapd %xmm3, %xmm1
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_ge_v4i64:
; SSE42:       # BB#0:
; SSE42-NEXT:    movdqa %xmm0, %xmm4
; SSE42-NEXT:    movdqa %xmm3, %xmm5
; SSE42-NEXT:    pcmpgtq %xmm1, %xmm5
; SSE42-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE42-NEXT:    pxor %xmm0, %xmm5
; SSE42-NEXT:    movdqa %xmm2, %xmm6
; SSE42-NEXT:    pcmpgtq %xmm4, %xmm6
; SSE42-NEXT:    pxor %xmm6, %xmm0
; SSE42-NEXT:    blendvpd %xmm4, %xmm2
; SSE42-NEXT:    movdqa %xmm5, %xmm0
; SSE42-NEXT:    blendvpd %xmm1, %xmm3
; SSE42-NEXT:    movapd %xmm2, %xmm0
; SSE42-NEXT:    movapd %xmm3, %xmm1
; SSE42-NEXT:    retq
;
; AVX1-LABEL: max_ge_v4i64:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm3
; AVX1-NEXT:    vpcmpgtq %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpcmpeqd %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpxor %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpcmpgtq %xmm0, %xmm1, %xmm4
; AVX1-NEXT:    vpxor %xmm3, %xmm4, %xmm3
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; AVX1-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: max_ge_v4i64:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpcmpgtq %ymm0, %ymm1, %ymm2
; AVX2-NEXT:    vpcmpeqd %ymm3, %ymm3, %ymm3
; AVX2-NEXT:    vpxor %ymm3, %ymm2, %ymm2
; AVX2-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: max_ge_v4i64:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpcmpgtq %ymm0, %ymm1, %ymm2
; AVX512-NEXT:    vpcmpeqd %ymm3, %ymm3, %ymm3
; AVX512-NEXT:    vpxor %ymm3, %ymm2, %ymm2
; AVX512-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX512-NEXT:    retq
  %1 = icmp sge <4 x i64> %a, %b
  %2 = select <4 x i1> %1, <4 x i64> %a, <4 x i64> %b
  ret <4 x i64> %2
}

define <4 x i32> @max_ge_v4i32(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: max_ge_v4i32:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa %xmm1, %xmm3
; SSE2-NEXT:    pcmpgtd %xmm0, %xmm3
; SSE2-NEXT:    pcmpeqd %xmm2, %xmm2
; SSE2-NEXT:    pxor %xmm3, %xmm2
; SSE2-NEXT:    pandn %xmm0, %xmm3
; SSE2-NEXT:    pandn %xmm1, %xmm2
; SSE2-NEXT:    por %xmm3, %xmm2
; SSE2-NEXT:    movdqa %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_ge_v4i32:
; SSE41:       # BB#0:
; SSE41-NEXT:    pmaxsd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_ge_v4i32:
; SSE42:       # BB#0:
; SSE42-NEXT:    pmaxsd %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: max_ge_v4i32:
; AVX:       # BB#0:
; AVX-NEXT:    vpmaxsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = icmp sge <4 x i32> %a, %b
  %2 = select <4 x i1> %1, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %2
}

define <8 x i32> @max_ge_v8i32(<8 x i32> %a, <8 x i32> %b) {
; SSE2-LABEL: max_ge_v8i32:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa %xmm3, %xmm6
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm6
; SSE2-NEXT:    pcmpeqd %xmm4, %xmm4
; SSE2-NEXT:    movdqa %xmm6, %xmm5
; SSE2-NEXT:    pxor %xmm4, %xmm5
; SSE2-NEXT:    movdqa %xmm2, %xmm7
; SSE2-NEXT:    pcmpgtd %xmm0, %xmm7
; SSE2-NEXT:    pxor %xmm7, %xmm4
; SSE2-NEXT:    pandn %xmm0, %xmm7
; SSE2-NEXT:    pandn %xmm2, %xmm4
; SSE2-NEXT:    por %xmm7, %xmm4
; SSE2-NEXT:    pandn %xmm1, %xmm6
; SSE2-NEXT:    pandn %xmm3, %xmm5
; SSE2-NEXT:    por %xmm6, %xmm5
; SSE2-NEXT:    movdqa %xmm4, %xmm0
; SSE2-NEXT:    movdqa %xmm5, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_ge_v8i32:
; SSE41:       # BB#0:
; SSE41-NEXT:    pmaxsd %xmm2, %xmm0
; SSE41-NEXT:    pmaxsd %xmm3, %xmm1
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_ge_v8i32:
; SSE42:       # BB#0:
; SSE42-NEXT:    pmaxsd %xmm2, %xmm0
; SSE42-NEXT:    pmaxsd %xmm3, %xmm1
; SSE42-NEXT:    retq
;
; AVX1-LABEL: max_ge_v8i32:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpmaxsd %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpmaxsd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: max_ge_v8i32:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpmaxsd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: max_ge_v8i32:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpmaxsd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %1 = icmp sge <8 x i32> %a, %b
  %2 = select <8 x i1> %1, <8 x i32> %a, <8 x i32> %b
  ret <8 x i32> %2
}

define <8 x i16> @max_ge_v8i16(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: max_ge_v8i16:
; SSE:       # BB#0:
; SSE-NEXT:    pmaxsw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: max_ge_v8i16:
; AVX:       # BB#0:
; AVX-NEXT:    vpmaxsw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = icmp sge <8 x i16> %a, %b
  %2 = select <8 x i1> %1, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %2
}

define <16 x i16> @max_ge_v16i16(<16 x i16> %a, <16 x i16> %b) {
; SSE-LABEL: max_ge_v16i16:
; SSE:       # BB#0:
; SSE-NEXT:    pmaxsw %xmm2, %xmm0
; SSE-NEXT:    pmaxsw %xmm3, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: max_ge_v16i16:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpmaxsw %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpmaxsw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: max_ge_v16i16:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpmaxsw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: max_ge_v16i16:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpmaxsw %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %1 = icmp sge <16 x i16> %a, %b
  %2 = select <16 x i1> %1, <16 x i16> %a, <16 x i16> %b
  ret <16 x i16> %2
}

define <16 x i8> @max_ge_v16i8(<16 x i8> %a, <16 x i8> %b) {
; SSE2-LABEL: max_ge_v16i8:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa %xmm1, %xmm3
; SSE2-NEXT:    pcmpgtb %xmm0, %xmm3
; SSE2-NEXT:    pcmpeqd %xmm2, %xmm2
; SSE2-NEXT:    pxor %xmm3, %xmm2
; SSE2-NEXT:    pandn %xmm0, %xmm3
; SSE2-NEXT:    pandn %xmm1, %xmm2
; SSE2-NEXT:    por %xmm3, %xmm2
; SSE2-NEXT:    movdqa %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_ge_v16i8:
; SSE41:       # BB#0:
; SSE41-NEXT:    pmaxsb %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_ge_v16i8:
; SSE42:       # BB#0:
; SSE42-NEXT:    pmaxsb %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: max_ge_v16i8:
; AVX:       # BB#0:
; AVX-NEXT:    vpmaxsb %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = icmp sge <16 x i8> %a, %b
  %2 = select <16 x i1> %1, <16 x i8> %a, <16 x i8> %b
  ret <16 x i8> %2
}

define <32 x i8> @max_ge_v32i8(<32 x i8> %a, <32 x i8> %b) {
; SSE2-LABEL: max_ge_v32i8:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa %xmm3, %xmm6
; SSE2-NEXT:    pcmpgtb %xmm1, %xmm6
; SSE2-NEXT:    pcmpeqd %xmm4, %xmm4
; SSE2-NEXT:    movdqa %xmm6, %xmm5
; SSE2-NEXT:    pxor %xmm4, %xmm5
; SSE2-NEXT:    movdqa %xmm2, %xmm7
; SSE2-NEXT:    pcmpgtb %xmm0, %xmm7
; SSE2-NEXT:    pxor %xmm7, %xmm4
; SSE2-NEXT:    pandn %xmm0, %xmm7
; SSE2-NEXT:    pandn %xmm2, %xmm4
; SSE2-NEXT:    por %xmm7, %xmm4
; SSE2-NEXT:    pandn %xmm1, %xmm6
; SSE2-NEXT:    pandn %xmm3, %xmm5
; SSE2-NEXT:    por %xmm6, %xmm5
; SSE2-NEXT:    movdqa %xmm4, %xmm0
; SSE2-NEXT:    movdqa %xmm5, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_ge_v32i8:
; SSE41:       # BB#0:
; SSE41-NEXT:    pmaxsb %xmm2, %xmm0
; SSE41-NEXT:    pmaxsb %xmm3, %xmm1
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_ge_v32i8:
; SSE42:       # BB#0:
; SSE42-NEXT:    pmaxsb %xmm2, %xmm0
; SSE42-NEXT:    pmaxsb %xmm3, %xmm1
; SSE42-NEXT:    retq
;
; AVX1-LABEL: max_ge_v32i8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpmaxsb %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpmaxsb %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: max_ge_v32i8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpmaxsb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: max_ge_v32i8:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpmaxsb %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %1 = icmp sge <32 x i8> %a, %b
  %2 = select <32 x i1> %1, <32 x i8> %a, <32 x i8> %b
  ret <32 x i8> %2
}

;
; Signed Minimum (LT)
;

define <2 x i64> @min_lt_v2i64(<2 x i64> %a, <2 x i64> %b) {
; SSE2-LABEL: min_lt_v2i64:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [2147483648,0,2147483648,0]
; SSE2-NEXT:    movdqa %xmm0, %xmm3
; SSE2-NEXT:    pxor %xmm2, %xmm3
; SSE2-NEXT:    pxor %xmm1, %xmm2
; SSE2-NEXT:    movdqa %xmm2, %xmm4
; SSE2-NEXT:    pcmpgtd %xmm3, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm3, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; SSE2-NEXT:    pand %xmm5, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm4[1,1,3,3]
; SSE2-NEXT:    por %xmm2, %xmm3
; SSE2-NEXT:    pand %xmm3, %xmm0
; SSE2-NEXT:    pandn %xmm1, %xmm3
; SSE2-NEXT:    por %xmm3, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_lt_v2i64:
; SSE41:       # BB#0:
; SSE41-NEXT:    movdqa %xmm0, %xmm2
; SSE41-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE41-NEXT:    movdqa %xmm2, %xmm3
; SSE41-NEXT:    pxor %xmm0, %xmm3
; SSE41-NEXT:    pxor %xmm1, %xmm0
; SSE41-NEXT:    movdqa %xmm0, %xmm4
; SSE41-NEXT:    pcmpgtd %xmm3, %xmm4
; SSE41-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm3, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; SSE41-NEXT:    pand %xmm5, %xmm3
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm4[1,1,3,3]
; SSE41-NEXT:    por %xmm3, %xmm0
; SSE41-NEXT:    blendvpd %xmm2, %xmm1
; SSE41-NEXT:    movapd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_lt_v2i64:
; SSE42:       # BB#0:
; SSE42-NEXT:    movdqa %xmm0, %xmm2
; SSE42-NEXT:    movdqa %xmm1, %xmm0
; SSE42-NEXT:    pcmpgtq %xmm2, %xmm0
; SSE42-NEXT:    blendvpd %xmm2, %xmm1
; SSE42-NEXT:    movapd %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: min_lt_v2i64:
; AVX:       # BB#0:
; AVX-NEXT:    vpcmpgtq %xmm0, %xmm1, %xmm2
; AVX-NEXT:    vblendvpd %xmm2, %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = icmp slt <2 x i64> %a, %b
  %2 = select <2 x i1> %1, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %2
}

define <4 x i64> @min_lt_v4i64(<4 x i64> %a, <4 x i64> %b) {
; SSE2-LABEL: min_lt_v4i64:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm4 = [2147483648,0,2147483648,0]
; SSE2-NEXT:    movdqa %xmm1, %xmm5
; SSE2-NEXT:    pxor %xmm4, %xmm5
; SSE2-NEXT:    movdqa %xmm3, %xmm6
; SSE2-NEXT:    pxor %xmm4, %xmm6
; SSE2-NEXT:    movdqa %xmm6, %xmm7
; SSE2-NEXT:    pcmpgtd %xmm5, %xmm7
; SSE2-NEXT:    pshufd {{.*#+}} xmm8 = xmm7[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm5, %xmm6
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm6[1,1,3,3]
; SSE2-NEXT:    pand %xmm8, %xmm5
; SSE2-NEXT:    pshufd {{.*#+}} xmm6 = xmm7[1,1,3,3]
; SSE2-NEXT:    por %xmm5, %xmm6
; SSE2-NEXT:    movdqa %xmm0, %xmm5
; SSE2-NEXT:    pxor %xmm4, %xmm5
; SSE2-NEXT:    pxor %xmm2, %xmm4
; SSE2-NEXT:    movdqa %xmm4, %xmm7
; SSE2-NEXT:    pcmpgtd %xmm5, %xmm7
; SSE2-NEXT:    pshufd {{.*#+}} xmm8 = xmm7[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm5, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSE2-NEXT:    pand %xmm8, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm7[1,1,3,3]
; SSE2-NEXT:    por %xmm4, %xmm5
; SSE2-NEXT:    pand %xmm5, %xmm0
; SSE2-NEXT:    pandn %xmm2, %xmm5
; SSE2-NEXT:    por %xmm5, %xmm0
; SSE2-NEXT:    pand %xmm6, %xmm1
; SSE2-NEXT:    pandn %xmm3, %xmm6
; SSE2-NEXT:    por %xmm6, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_lt_v4i64:
; SSE41:       # BB#0:
; SSE41-NEXT:    movdqa %xmm0, %xmm8
; SSE41-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE41-NEXT:    movdqa %xmm1, %xmm5
; SSE41-NEXT:    pxor %xmm0, %xmm5
; SSE41-NEXT:    movdqa %xmm3, %xmm6
; SSE41-NEXT:    pxor %xmm0, %xmm6
; SSE41-NEXT:    movdqa %xmm6, %xmm7
; SSE41-NEXT:    pcmpgtd %xmm5, %xmm7
; SSE41-NEXT:    pshufd {{.*#+}} xmm4 = xmm7[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm5, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm6 = xmm6[1,1,3,3]
; SSE41-NEXT:    pand %xmm4, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm5 = xmm7[1,1,3,3]
; SSE41-NEXT:    por %xmm6, %xmm5
; SSE41-NEXT:    movdqa %xmm8, %xmm4
; SSE41-NEXT:    pxor %xmm0, %xmm4
; SSE41-NEXT:    pxor %xmm2, %xmm0
; SSE41-NEXT:    movdqa %xmm0, %xmm6
; SSE41-NEXT:    pcmpgtd %xmm4, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm7 = xmm6[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm4, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm4 = xmm0[1,1,3,3]
; SSE41-NEXT:    pand %xmm7, %xmm4
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm6[1,1,3,3]
; SSE41-NEXT:    por %xmm4, %xmm0
; SSE41-NEXT:    blendvpd %xmm8, %xmm2
; SSE41-NEXT:    movdqa %xmm5, %xmm0
; SSE41-NEXT:    blendvpd %xmm1, %xmm3
; SSE41-NEXT:    movapd %xmm2, %xmm0
; SSE41-NEXT:    movapd %xmm3, %xmm1
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_lt_v4i64:
; SSE42:       # BB#0:
; SSE42-NEXT:    movdqa %xmm0, %xmm4
; SSE42-NEXT:    movdqa %xmm3, %xmm5
; SSE42-NEXT:    pcmpgtq %xmm1, %xmm5
; SSE42-NEXT:    movdqa %xmm2, %xmm0
; SSE42-NEXT:    pcmpgtq %xmm4, %xmm0
; SSE42-NEXT:    blendvpd %xmm4, %xmm2
; SSE42-NEXT:    movdqa %xmm5, %xmm0
; SSE42-NEXT:    blendvpd %xmm1, %xmm3
; SSE42-NEXT:    movapd %xmm2, %xmm0
; SSE42-NEXT:    movapd %xmm3, %xmm1
; SSE42-NEXT:    retq
;
; AVX1-LABEL: min_lt_v4i64:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm3
; AVX1-NEXT:    vpcmpgtq %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpcmpgtq %xmm0, %xmm1, %xmm3
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; AVX1-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: min_lt_v4i64:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpcmpgtq %ymm0, %ymm1, %ymm2
; AVX2-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: min_lt_v4i64:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpcmpgtq %ymm0, %ymm1, %ymm2
; AVX512-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX512-NEXT:    retq
  %1 = icmp slt <4 x i64> %a, %b
  %2 = select <4 x i1> %1, <4 x i64> %a, <4 x i64> %b
  ret <4 x i64> %2
}

define <4 x i32> @min_lt_v4i32(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: min_lt_v4i32:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa %xmm1, %xmm2
; SSE2-NEXT:    pcmpgtd %xmm0, %xmm2
; SSE2-NEXT:    pand %xmm2, %xmm0
; SSE2-NEXT:    pandn %xmm1, %xmm2
; SSE2-NEXT:    por %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_lt_v4i32:
; SSE41:       # BB#0:
; SSE41-NEXT:    pminsd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_lt_v4i32:
; SSE42:       # BB#0:
; SSE42-NEXT:    pminsd %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: min_lt_v4i32:
; AVX:       # BB#0:
; AVX-NEXT:    vpminsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = icmp slt <4 x i32> %a, %b
  %2 = select <4 x i1> %1, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %2
}

define <8 x i32> @min_lt_v8i32(<8 x i32> %a, <8 x i32> %b) {
; SSE2-LABEL: min_lt_v8i32:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa %xmm3, %xmm4
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm4
; SSE2-NEXT:    movdqa %xmm2, %xmm5
; SSE2-NEXT:    pcmpgtd %xmm0, %xmm5
; SSE2-NEXT:    pand %xmm5, %xmm0
; SSE2-NEXT:    pandn %xmm2, %xmm5
; SSE2-NEXT:    por %xmm5, %xmm0
; SSE2-NEXT:    pand %xmm4, %xmm1
; SSE2-NEXT:    pandn %xmm3, %xmm4
; SSE2-NEXT:    por %xmm4, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_lt_v8i32:
; SSE41:       # BB#0:
; SSE41-NEXT:    pminsd %xmm2, %xmm0
; SSE41-NEXT:    pminsd %xmm3, %xmm1
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_lt_v8i32:
; SSE42:       # BB#0:
; SSE42-NEXT:    pminsd %xmm2, %xmm0
; SSE42-NEXT:    pminsd %xmm3, %xmm1
; SSE42-NEXT:    retq
;
; AVX1-LABEL: min_lt_v8i32:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpminsd %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpminsd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: min_lt_v8i32:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpminsd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: min_lt_v8i32:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpminsd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %1 = icmp slt <8 x i32> %a, %b
  %2 = select <8 x i1> %1, <8 x i32> %a, <8 x i32> %b
  ret <8 x i32> %2
}

define <8 x i16> @min_lt_v8i16(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: min_lt_v8i16:
; SSE:       # BB#0:
; SSE-NEXT:    pminsw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: min_lt_v8i16:
; AVX:       # BB#0:
; AVX-NEXT:    vpminsw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = icmp slt <8 x i16> %a, %b
  %2 = select <8 x i1> %1, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %2
}

define <16 x i16> @min_lt_v16i16(<16 x i16> %a, <16 x i16> %b) {
; SSE-LABEL: min_lt_v16i16:
; SSE:       # BB#0:
; SSE-NEXT:    pminsw %xmm2, %xmm0
; SSE-NEXT:    pminsw %xmm3, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: min_lt_v16i16:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpminsw %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpminsw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: min_lt_v16i16:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpminsw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: min_lt_v16i16:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpminsw %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %1 = icmp slt <16 x i16> %a, %b
  %2 = select <16 x i1> %1, <16 x i16> %a, <16 x i16> %b
  ret <16 x i16> %2
}

define <16 x i8> @min_lt_v16i8(<16 x i8> %a, <16 x i8> %b) {
; SSE2-LABEL: min_lt_v16i8:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa %xmm1, %xmm2
; SSE2-NEXT:    pcmpgtb %xmm0, %xmm2
; SSE2-NEXT:    pand %xmm2, %xmm0
; SSE2-NEXT:    pandn %xmm1, %xmm2
; SSE2-NEXT:    por %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_lt_v16i8:
; SSE41:       # BB#0:
; SSE41-NEXT:    pminsb %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_lt_v16i8:
; SSE42:       # BB#0:
; SSE42-NEXT:    pminsb %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: min_lt_v16i8:
; AVX:       # BB#0:
; AVX-NEXT:    vpminsb %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = icmp slt <16 x i8> %a, %b
  %2 = select <16 x i1> %1, <16 x i8> %a, <16 x i8> %b
  ret <16 x i8> %2
}

define <32 x i8> @min_lt_v32i8(<32 x i8> %a, <32 x i8> %b) {
; SSE2-LABEL: min_lt_v32i8:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa %xmm3, %xmm4
; SSE2-NEXT:    pcmpgtb %xmm1, %xmm4
; SSE2-NEXT:    movdqa %xmm2, %xmm5
; SSE2-NEXT:    pcmpgtb %xmm0, %xmm5
; SSE2-NEXT:    pand %xmm5, %xmm0
; SSE2-NEXT:    pandn %xmm2, %xmm5
; SSE2-NEXT:    por %xmm5, %xmm0
; SSE2-NEXT:    pand %xmm4, %xmm1
; SSE2-NEXT:    pandn %xmm3, %xmm4
; SSE2-NEXT:    por %xmm4, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_lt_v32i8:
; SSE41:       # BB#0:
; SSE41-NEXT:    pminsb %xmm2, %xmm0
; SSE41-NEXT:    pminsb %xmm3, %xmm1
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_lt_v32i8:
; SSE42:       # BB#0:
; SSE42-NEXT:    pminsb %xmm2, %xmm0
; SSE42-NEXT:    pminsb %xmm3, %xmm1
; SSE42-NEXT:    retq
;
; AVX1-LABEL: min_lt_v32i8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpminsb %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpminsb %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: min_lt_v32i8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpminsb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: min_lt_v32i8:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpminsb %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %1 = icmp slt <32 x i8> %a, %b
  %2 = select <32 x i1> %1, <32 x i8> %a, <32 x i8> %b
  ret <32 x i8> %2
}

;
; Signed Minimum (LE)
;

define <2 x i64> @min_le_v2i64(<2 x i64> %a, <2 x i64> %b) {
; SSE2-LABEL: min_le_v2i64:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [2147483648,0,2147483648,0]
; SSE2-NEXT:    movdqa %xmm1, %xmm3
; SSE2-NEXT:    pxor %xmm2, %xmm3
; SSE2-NEXT:    pxor %xmm0, %xmm2
; SSE2-NEXT:    movdqa %xmm2, %xmm4
; SSE2-NEXT:    pcmpgtd %xmm3, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm3, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; SSE2-NEXT:    pand %xmm5, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm4[1,1,3,3]
; SSE2-NEXT:    por %xmm2, %xmm3
; SSE2-NEXT:    pcmpeqd %xmm2, %xmm2
; SSE2-NEXT:    pxor %xmm3, %xmm2
; SSE2-NEXT:    pandn %xmm0, %xmm3
; SSE2-NEXT:    pandn %xmm1, %xmm2
; SSE2-NEXT:    por %xmm3, %xmm2
; SSE2-NEXT:    movdqa %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_le_v2i64:
; SSE41:       # BB#0:
; SSE41-NEXT:    movdqa %xmm0, %xmm2
; SSE41-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE41-NEXT:    movdqa %xmm1, %xmm3
; SSE41-NEXT:    pxor %xmm0, %xmm3
; SSE41-NEXT:    pxor %xmm2, %xmm0
; SSE41-NEXT:    movdqa %xmm0, %xmm4
; SSE41-NEXT:    pcmpgtd %xmm3, %xmm4
; SSE41-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm3, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE41-NEXT:    pand %xmm5, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm4[1,1,3,3]
; SSE41-NEXT:    por %xmm0, %xmm3
; SSE41-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE41-NEXT:    pxor %xmm3, %xmm0
; SSE41-NEXT:    blendvpd %xmm2, %xmm1
; SSE41-NEXT:    movapd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_le_v2i64:
; SSE42:       # BB#0:
; SSE42-NEXT:    movdqa %xmm0, %xmm2
; SSE42-NEXT:    pcmpgtq %xmm1, %xmm0
; SSE42-NEXT:    pcmpeqd %xmm3, %xmm3
; SSE42-NEXT:    pxor %xmm3, %xmm0
; SSE42-NEXT:    blendvpd %xmm2, %xmm1
; SSE42-NEXT:    movapd %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: min_le_v2i64:
; AVX:       # BB#0:
; AVX-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm2
; AVX-NEXT:    vpcmpeqd %xmm3, %xmm3, %xmm3
; AVX-NEXT:    vpxor %xmm3, %xmm2, %xmm2
; AVX-NEXT:    vblendvpd %xmm2, %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = icmp sle <2 x i64> %a, %b
  %2 = select <2 x i1> %1, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %2
}

define <4 x i64> @min_le_v4i64(<4 x i64> %a, <4 x i64> %b) {
; SSE2-LABEL: min_le_v4i64:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm7 = [2147483648,0,2147483648,0]
; SSE2-NEXT:    movdqa %xmm3, %xmm4
; SSE2-NEXT:    pxor %xmm7, %xmm4
; SSE2-NEXT:    movdqa %xmm1, %xmm5
; SSE2-NEXT:    pxor %xmm7, %xmm5
; SSE2-NEXT:    movdqa %xmm5, %xmm6
; SSE2-NEXT:    pcmpgtd %xmm4, %xmm6
; SSE2-NEXT:    pshufd {{.*#+}} xmm8 = xmm6[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm4, %xmm5
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm5[1,1,3,3]
; SSE2-NEXT:    pand %xmm8, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm8 = xmm6[1,1,3,3]
; SSE2-NEXT:    por %xmm4, %xmm8
; SSE2-NEXT:    pcmpeqd %xmm4, %xmm4
; SSE2-NEXT:    movdqa %xmm8, %xmm9
; SSE2-NEXT:    pxor %xmm4, %xmm9
; SSE2-NEXT:    movdqa %xmm2, %xmm6
; SSE2-NEXT:    pxor %xmm7, %xmm6
; SSE2-NEXT:    pxor %xmm0, %xmm7
; SSE2-NEXT:    movdqa %xmm7, %xmm5
; SSE2-NEXT:    pcmpgtd %xmm6, %xmm5
; SSE2-NEXT:    pshufd {{.*#+}} xmm10 = xmm5[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm6, %xmm7
; SSE2-NEXT:    pshufd {{.*#+}} xmm6 = xmm7[1,1,3,3]
; SSE2-NEXT:    pand %xmm10, %xmm6
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm5[1,1,3,3]
; SSE2-NEXT:    por %xmm6, %xmm5
; SSE2-NEXT:    pxor %xmm5, %xmm4
; SSE2-NEXT:    pandn %xmm0, %xmm5
; SSE2-NEXT:    pandn %xmm2, %xmm4
; SSE2-NEXT:    por %xmm5, %xmm4
; SSE2-NEXT:    pandn %xmm1, %xmm8
; SSE2-NEXT:    pandn %xmm3, %xmm9
; SSE2-NEXT:    por %xmm8, %xmm9
; SSE2-NEXT:    movdqa %xmm4, %xmm0
; SSE2-NEXT:    movdqa %xmm9, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_le_v4i64:
; SSE41:       # BB#0:
; SSE41-NEXT:    movdqa %xmm0, %xmm8
; SSE41-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE41-NEXT:    movdqa %xmm3, %xmm5
; SSE41-NEXT:    pxor %xmm0, %xmm5
; SSE41-NEXT:    movdqa %xmm1, %xmm6
; SSE41-NEXT:    pxor %xmm0, %xmm6
; SSE41-NEXT:    movdqa %xmm6, %xmm7
; SSE41-NEXT:    pcmpgtd %xmm5, %xmm7
; SSE41-NEXT:    pshufd {{.*#+}} xmm4 = xmm7[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm5, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm6 = xmm6[1,1,3,3]
; SSE41-NEXT:    pand %xmm4, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm5 = xmm7[1,1,3,3]
; SSE41-NEXT:    por %xmm6, %xmm5
; SSE41-NEXT:    pcmpeqd %xmm9, %xmm9
; SSE41-NEXT:    pxor %xmm9, %xmm5
; SSE41-NEXT:    movdqa %xmm2, %xmm6
; SSE41-NEXT:    pxor %xmm0, %xmm6
; SSE41-NEXT:    pxor %xmm8, %xmm0
; SSE41-NEXT:    movdqa %xmm0, %xmm7
; SSE41-NEXT:    pcmpgtd %xmm6, %xmm7
; SSE41-NEXT:    pshufd {{.*#+}} xmm4 = xmm7[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm6, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm6 = xmm0[1,1,3,3]
; SSE41-NEXT:    pand %xmm4, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm7[1,1,3,3]
; SSE41-NEXT:    por %xmm6, %xmm0
; SSE41-NEXT:    pxor %xmm9, %xmm0
; SSE41-NEXT:    blendvpd %xmm8, %xmm2
; SSE41-NEXT:    movdqa %xmm5, %xmm0
; SSE41-NEXT:    blendvpd %xmm1, %xmm3
; SSE41-NEXT:    movapd %xmm2, %xmm0
; SSE41-NEXT:    movapd %xmm3, %xmm1
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_le_v4i64:
; SSE42:       # BB#0:
; SSE42-NEXT:    movdqa %xmm0, %xmm4
; SSE42-NEXT:    movdqa %xmm1, %xmm5
; SSE42-NEXT:    pcmpgtq %xmm3, %xmm5
; SSE42-NEXT:    pcmpeqd %xmm6, %xmm6
; SSE42-NEXT:    pxor %xmm6, %xmm5
; SSE42-NEXT:    pcmpgtq %xmm2, %xmm0
; SSE42-NEXT:    pxor %xmm6, %xmm0
; SSE42-NEXT:    blendvpd %xmm4, %xmm2
; SSE42-NEXT:    movdqa %xmm5, %xmm0
; SSE42-NEXT:    blendvpd %xmm1, %xmm3
; SSE42-NEXT:    movapd %xmm2, %xmm0
; SSE42-NEXT:    movapd %xmm3, %xmm1
; SSE42-NEXT:    retq
;
; AVX1-LABEL: min_le_v4i64:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpcmpgtq %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpcmpeqd %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpxor %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm4
; AVX1-NEXT:    vpxor %xmm3, %xmm4, %xmm3
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; AVX1-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: min_le_v4i64:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpcmpgtq %ymm1, %ymm0, %ymm2
; AVX2-NEXT:    vpcmpeqd %ymm3, %ymm3, %ymm3
; AVX2-NEXT:    vpxor %ymm3, %ymm2, %ymm2
; AVX2-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: min_le_v4i64:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpcmpgtq %ymm1, %ymm0, %ymm2
; AVX512-NEXT:    vpcmpeqd %ymm3, %ymm3, %ymm3
; AVX512-NEXT:    vpxor %ymm3, %ymm2, %ymm2
; AVX512-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX512-NEXT:    retq
  %1 = icmp sle <4 x i64> %a, %b
  %2 = select <4 x i1> %1, <4 x i64> %a, <4 x i64> %b
  ret <4 x i64> %2
}

define <4 x i32> @min_le_v4i32(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: min_le_v4i32:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm2
; SSE2-NEXT:    pcmpeqd %xmm3, %xmm3
; SSE2-NEXT:    pxor %xmm2, %xmm3
; SSE2-NEXT:    pandn %xmm0, %xmm2
; SSE2-NEXT:    pandn %xmm1, %xmm3
; SSE2-NEXT:    por %xmm3, %xmm2
; SSE2-NEXT:    movdqa %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_le_v4i32:
; SSE41:       # BB#0:
; SSE41-NEXT:    pminsd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_le_v4i32:
; SSE42:       # BB#0:
; SSE42-NEXT:    pminsd %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: min_le_v4i32:
; AVX:       # BB#0:
; AVX-NEXT:    vpminsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = icmp sle <4 x i32> %a, %b
  %2 = select <4 x i1> %1, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %2
}

define <8 x i32> @min_le_v8i32(<8 x i32> %a, <8 x i32> %b) {
; SSE2-LABEL: min_le_v8i32:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa %xmm1, %xmm6
; SSE2-NEXT:    pcmpgtd %xmm3, %xmm6
; SSE2-NEXT:    pcmpeqd %xmm7, %xmm7
; SSE2-NEXT:    movdqa %xmm6, %xmm4
; SSE2-NEXT:    pxor %xmm7, %xmm4
; SSE2-NEXT:    movdqa %xmm0, %xmm5
; SSE2-NEXT:    pcmpgtd %xmm2, %xmm5
; SSE2-NEXT:    pxor %xmm5, %xmm7
; SSE2-NEXT:    pandn %xmm0, %xmm5
; SSE2-NEXT:    pandn %xmm2, %xmm7
; SSE2-NEXT:    por %xmm7, %xmm5
; SSE2-NEXT:    pandn %xmm1, %xmm6
; SSE2-NEXT:    pandn %xmm3, %xmm4
; SSE2-NEXT:    por %xmm6, %xmm4
; SSE2-NEXT:    movdqa %xmm5, %xmm0
; SSE2-NEXT:    movdqa %xmm4, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_le_v8i32:
; SSE41:       # BB#0:
; SSE41-NEXT:    pminsd %xmm2, %xmm0
; SSE41-NEXT:    pminsd %xmm3, %xmm1
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_le_v8i32:
; SSE42:       # BB#0:
; SSE42-NEXT:    pminsd %xmm2, %xmm0
; SSE42-NEXT:    pminsd %xmm3, %xmm1
; SSE42-NEXT:    retq
;
; AVX1-LABEL: min_le_v8i32:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpminsd %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpminsd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: min_le_v8i32:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpminsd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: min_le_v8i32:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpminsd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %1 = icmp sle <8 x i32> %a, %b
  %2 = select <8 x i1> %1, <8 x i32> %a, <8 x i32> %b
  ret <8 x i32> %2
}

define <8 x i16> @min_le_v8i16(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: min_le_v8i16:
; SSE:       # BB#0:
; SSE-NEXT:    pminsw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: min_le_v8i16:
; AVX:       # BB#0:
; AVX-NEXT:    vpminsw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = icmp sle <8 x i16> %a, %b
  %2 = select <8 x i1> %1, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %2
}

define <16 x i16> @min_le_v16i16(<16 x i16> %a, <16 x i16> %b) {
; SSE-LABEL: min_le_v16i16:
; SSE:       # BB#0:
; SSE-NEXT:    pminsw %xmm2, %xmm0
; SSE-NEXT:    pminsw %xmm3, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: min_le_v16i16:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpminsw %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpminsw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: min_le_v16i16:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpminsw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: min_le_v16i16:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpminsw %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %1 = icmp sle <16 x i16> %a, %b
  %2 = select <16 x i1> %1, <16 x i16> %a, <16 x i16> %b
  ret <16 x i16> %2
}

define <16 x i8> @min_le_v16i8(<16 x i8> %a, <16 x i8> %b) {
; SSE2-LABEL: min_le_v16i8:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    pcmpgtb %xmm1, %xmm2
; SSE2-NEXT:    pcmpeqd %xmm3, %xmm3
; SSE2-NEXT:    pxor %xmm2, %xmm3
; SSE2-NEXT:    pandn %xmm0, %xmm2
; SSE2-NEXT:    pandn %xmm1, %xmm3
; SSE2-NEXT:    por %xmm3, %xmm2
; SSE2-NEXT:    movdqa %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_le_v16i8:
; SSE41:       # BB#0:
; SSE41-NEXT:    pminsb %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_le_v16i8:
; SSE42:       # BB#0:
; SSE42-NEXT:    pminsb %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: min_le_v16i8:
; AVX:       # BB#0:
; AVX-NEXT:    vpminsb %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = icmp sle <16 x i8> %a, %b
  %2 = select <16 x i1> %1, <16 x i8> %a, <16 x i8> %b
  ret <16 x i8> %2
}

define <32 x i8> @min_le_v32i8(<32 x i8> %a, <32 x i8> %b) {
; SSE2-LABEL: min_le_v32i8:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa %xmm1, %xmm6
; SSE2-NEXT:    pcmpgtb %xmm3, %xmm6
; SSE2-NEXT:    pcmpeqd %xmm7, %xmm7
; SSE2-NEXT:    movdqa %xmm6, %xmm4
; SSE2-NEXT:    pxor %xmm7, %xmm4
; SSE2-NEXT:    movdqa %xmm0, %xmm5
; SSE2-NEXT:    pcmpgtb %xmm2, %xmm5
; SSE2-NEXT:    pxor %xmm5, %xmm7
; SSE2-NEXT:    pandn %xmm0, %xmm5
; SSE2-NEXT:    pandn %xmm2, %xmm7
; SSE2-NEXT:    por %xmm7, %xmm5
; SSE2-NEXT:    pandn %xmm1, %xmm6
; SSE2-NEXT:    pandn %xmm3, %xmm4
; SSE2-NEXT:    por %xmm6, %xmm4
; SSE2-NEXT:    movdqa %xmm5, %xmm0
; SSE2-NEXT:    movdqa %xmm4, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_le_v32i8:
; SSE41:       # BB#0:
; SSE41-NEXT:    pminsb %xmm2, %xmm0
; SSE41-NEXT:    pminsb %xmm3, %xmm1
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_le_v32i8:
; SSE42:       # BB#0:
; SSE42-NEXT:    pminsb %xmm2, %xmm0
; SSE42-NEXT:    pminsb %xmm3, %xmm1
; SSE42-NEXT:    retq
;
; AVX1-LABEL: min_le_v32i8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpminsb %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpminsb %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: min_le_v32i8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpminsb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: min_le_v32i8:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpminsb %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %1 = icmp sle <32 x i8> %a, %b
  %2 = select <32 x i1> %1, <32 x i8> %a, <32 x i8> %b
  ret <32 x i8> %2
}

;
; Constant Folding
;

define <2 x i64> @max_gt_v2i64c() {
; SSE2-LABEL: max_gt_v2i64c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [18446744073709551609,7]
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551615,1]
; SSE2-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE2-NEXT:    movdqa %xmm0, %xmm3
; SSE2-NEXT:    pxor %xmm2, %xmm3
; SSE2-NEXT:    pxor %xmm1, %xmm0
; SSE2-NEXT:    movdqa %xmm0, %xmm4
; SSE2-NEXT:    pcmpgtd %xmm3, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm3, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; SSE2-NEXT:    pand %xmm5, %xmm3
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm4[1,1,3,3]
; SSE2-NEXT:    por %xmm3, %xmm0
; SSE2-NEXT:    movdqa %xmm0, %xmm3
; SSE2-NEXT:    pandn %xmm2, %xmm3
; SSE2-NEXT:    pand %xmm1, %xmm0
; SSE2-NEXT:    por %xmm3, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_gt_v2i64c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551609,7]
; SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [18446744073709551615,1]
; SSE41-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE41-NEXT:    movdqa %xmm0, %xmm3
; SSE41-NEXT:    pxor %xmm1, %xmm3
; SSE41-NEXT:    pxor %xmm2, %xmm0
; SSE41-NEXT:    movdqa %xmm0, %xmm4
; SSE41-NEXT:    pcmpgtd %xmm3, %xmm4
; SSE41-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm3, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; SSE41-NEXT:    pand %xmm5, %xmm3
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm4[1,1,3,3]
; SSE41-NEXT:    por %xmm3, %xmm0
; SSE41-NEXT:    blendvpd %xmm2, %xmm1
; SSE41-NEXT:    movapd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_gt_v2i64c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551609,7]
; SSE42-NEXT:    movdqa {{.*#+}} xmm1 = [18446744073709551615,1]
; SSE42-NEXT:    movdqa %xmm2, %xmm0
; SSE42-NEXT:    pcmpgtq %xmm1, %xmm0
; SSE42-NEXT:    blendvpd %xmm2, %xmm1
; SSE42-NEXT:    movapd %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: max_gt_v2i64c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovdqa {{.*#+}} xmm0 = [18446744073709551609,7]
; AVX-NEXT:    vmovdqa {{.*#+}} xmm1 = [18446744073709551615,1]
; AVX-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm2
; AVX-NEXT:    vblendvpd %xmm2, %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = insertelement <2 x i64> <i64 -7, i64 7>, i64 -7, i32 0
  %2 = insertelement <2 x i64> <i64 -1, i64 1>, i64 -1, i32 0
  %3 = icmp sgt <2 x i64> %1, %2
  %4 = select <2 x i1> %3, <2 x i64> %1, <2 x i64> %2
  ret <2 x i64> %4
}

define <4 x i64> @max_gt_v4i64c() {
; SSE2-LABEL: max_gt_v4i64c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm4 = [18446744073709551609,18446744073709551615]
; SSE2-NEXT:    movdqa {{.*#+}} xmm8 = [1,7]
; SSE2-NEXT:    movdqa {{.*#+}} xmm5 = [18446744073709551615,18446744073709551609]
; SSE2-NEXT:    movdqa {{.*#+}} xmm3 = [7,1]
; SSE2-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE2-NEXT:    movdqa %xmm0, %xmm1
; SSE2-NEXT:    pxor %xmm3, %xmm1
; SSE2-NEXT:    movdqa %xmm0, %xmm6
; SSE2-NEXT:    pxor %xmm8, %xmm6
; SSE2-NEXT:    movdqa %xmm6, %xmm7
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm7
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm7[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm1, %xmm6
; SSE2-NEXT:    pshufd {{.*#+}} xmm6 = xmm6[1,1,3,3]
; SSE2-NEXT:    pand %xmm2, %xmm6
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm7[1,1,3,3]
; SSE2-NEXT:    por %xmm6, %xmm1
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    pxor %xmm5, %xmm2
; SSE2-NEXT:    pxor %xmm4, %xmm0
; SSE2-NEXT:    movdqa %xmm0, %xmm6
; SSE2-NEXT:    pcmpgtd %xmm2, %xmm6
; SSE2-NEXT:    pshufd {{.*#+}} xmm7 = xmm6[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm2, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; SSE2-NEXT:    pand %xmm7, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm6[1,1,3,3]
; SSE2-NEXT:    por %xmm2, %xmm0
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    pandn %xmm5, %xmm2
; SSE2-NEXT:    pand %xmm4, %xmm0
; SSE2-NEXT:    por %xmm2, %xmm0
; SSE2-NEXT:    movdqa %xmm1, %xmm2
; SSE2-NEXT:    pandn %xmm3, %xmm2
; SSE2-NEXT:    pand %xmm8, %xmm1
; SSE2-NEXT:    por %xmm2, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_gt_v4i64c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movdqa {{.*#+}} xmm5 = [18446744073709551609,18446744073709551615]
; SSE41-NEXT:    movdqa {{.*#+}} xmm8 = [1,7]
; SSE41-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551615,18446744073709551609]
; SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [7,1]
; SSE41-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE41-NEXT:    movdqa %xmm0, %xmm3
; SSE41-NEXT:    pxor %xmm1, %xmm3
; SSE41-NEXT:    movdqa %xmm0, %xmm6
; SSE41-NEXT:    pxor %xmm8, %xmm6
; SSE41-NEXT:    movdqa %xmm6, %xmm7
; SSE41-NEXT:    pcmpgtd %xmm3, %xmm7
; SSE41-NEXT:    pshufd {{.*#+}} xmm4 = xmm7[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm3, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm6 = xmm6[1,1,3,3]
; SSE41-NEXT:    pand %xmm4, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm7[1,1,3,3]
; SSE41-NEXT:    por %xmm6, %xmm3
; SSE41-NEXT:    movdqa %xmm0, %xmm4
; SSE41-NEXT:    pxor %xmm2, %xmm4
; SSE41-NEXT:    pxor %xmm5, %xmm0
; SSE41-NEXT:    movdqa %xmm0, %xmm6
; SSE41-NEXT:    pcmpgtd %xmm4, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm7 = xmm6[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm4, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm4 = xmm0[1,1,3,3]
; SSE41-NEXT:    pand %xmm7, %xmm4
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm6[1,1,3,3]
; SSE41-NEXT:    por %xmm4, %xmm0
; SSE41-NEXT:    blendvpd %xmm5, %xmm2
; SSE41-NEXT:    movdqa %xmm3, %xmm0
; SSE41-NEXT:    blendvpd %xmm8, %xmm1
; SSE41-NEXT:    movapd %xmm2, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_gt_v4i64c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movdqa {{.*#+}} xmm4 = [18446744073709551609,18446744073709551615]
; SSE42-NEXT:    movdqa {{.*#+}} xmm5 = [1,7]
; SSE42-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551615,18446744073709551609]
; SSE42-NEXT:    movdqa {{.*#+}} xmm1 = [7,1]
; SSE42-NEXT:    movdqa %xmm5, %xmm3
; SSE42-NEXT:    pcmpgtq %xmm1, %xmm3
; SSE42-NEXT:    movdqa %xmm4, %xmm0
; SSE42-NEXT:    pcmpgtq %xmm2, %xmm0
; SSE42-NEXT:    blendvpd %xmm4, %xmm2
; SSE42-NEXT:    movdqa %xmm3, %xmm0
; SSE42-NEXT:    blendvpd %xmm5, %xmm1
; SSE42-NEXT:    movapd %xmm2, %xmm0
; SSE42-NEXT:    retq
;
; AVX1-LABEL: max_gt_v4i64c:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovapd {{.*#+}} ymm0 = [18446744073709551615,18446744073709551609,7,1]
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm1 = [18446744073709551609,18446744073709551615]
; AVX1-NEXT:    vpcmpgtq {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [1,7]
; AVX1-NEXT:    vpcmpgtq {{.*}}(%rip), %xmm2, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; AVX1-NEXT:    vblendvpd %ymm1, {{.*}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: max_gt_v4i64c:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm0 = [18446744073709551609,18446744073709551615,1,7]
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm1 = [18446744073709551615,18446744073709551609,7,1]
; AVX2-NEXT:    vpcmpgtq %ymm1, %ymm0, %ymm2
; AVX2-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: max_gt_v4i64c:
; AVX512:       # BB#0:
; AVX512-NEXT:    vmovdqa {{.*#+}} ymm0 = [18446744073709551609,18446744073709551615,1,7]
; AVX512-NEXT:    vmovdqa {{.*#+}} ymm1 = [18446744073709551615,18446744073709551609,7,1]
; AVX512-NEXT:    vpcmpgtq %ymm1, %ymm0, %ymm2
; AVX512-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX512-NEXT:    retq
  %1 = insertelement <4 x i64> <i64 -7, i64 -1, i64 1, i64 7>, i64 -7, i32 0
  %2 = insertelement <4 x i64> <i64 -1, i64 -7, i64 7, i64 1>, i64 -1, i32 0
  %3 = icmp sgt <4 x i64> %1, %2
  %4 = select <4 x i1> %3, <4 x i64> %1, <4 x i64> %2
  ret <4 x i64> %4
}

define <4 x i32> @max_gt_v4i32c() {
; SSE2-LABEL: max_gt_v4i32c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [4294967289,4294967295,1,7]
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [4294967295,4294967289,7,1]
; SSE2-NEXT:    movdqa %xmm1, %xmm0
; SSE2-NEXT:    pcmpgtd %xmm2, %xmm0
; SSE2-NEXT:    pand %xmm0, %xmm1
; SSE2-NEXT:    pandn %xmm2, %xmm0
; SSE2-NEXT:    por %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_gt_v4i32c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movaps {{.*#+}} xmm0 = [4294967295,4294967295,7,7]
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_gt_v4i32c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movaps {{.*#+}} xmm0 = [4294967295,4294967295,7,7]
; SSE42-NEXT:    retq
;
; AVX-LABEL: max_gt_v4i32c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} xmm0 = [4294967295,4294967295,7,7]
; AVX-NEXT:    retq
  %1 = insertelement <4 x i32> <i32 -7, i32 -1, i32 1, i32 7>, i32 -7, i32 0
  %2 = insertelement <4 x i32> <i32 -1, i32 -7, i32 7, i32 1>, i32 -1, i32 0
  %3 = icmp sgt <4 x i32> %1, %2
  %4 = select <4 x i1> %3, <4 x i32> %1, <4 x i32> %2
  ret <4 x i32> %4
}

define <8 x i32> @max_gt_v8i32c() {
; SSE2-LABEL: max_gt_v8i32c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [4294967289,4294967291,4294967293,4294967295]
; SSE2-NEXT:    movdqa {{.*#+}} xmm3 = [1,3,5,7]
; SSE2-NEXT:    movdqa {{.*#+}} xmm4 = [4294967295,4294967293,4294967291,4294967289]
; SSE2-NEXT:    movdqa {{.*#+}} xmm5 = [7,5,3,1]
; SSE2-NEXT:    movdqa %xmm3, %xmm1
; SSE2-NEXT:    pcmpgtd %xmm5, %xmm1
; SSE2-NEXT:    movdqa %xmm2, %xmm0
; SSE2-NEXT:    pcmpgtd %xmm4, %xmm0
; SSE2-NEXT:    pand %xmm0, %xmm2
; SSE2-NEXT:    pandn %xmm4, %xmm0
; SSE2-NEXT:    por %xmm2, %xmm0
; SSE2-NEXT:    pand %xmm1, %xmm3
; SSE2-NEXT:    pandn %xmm5, %xmm1
; SSE2-NEXT:    por %xmm3, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_gt_v8i32c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movaps {{.*#+}} xmm0 = [4294967295,4294967293,4294967293,4294967295]
; SSE41-NEXT:    movaps {{.*#+}} xmm1 = [7,5,5,7]
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_gt_v8i32c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movaps {{.*#+}} xmm0 = [4294967295,4294967293,4294967293,4294967295]
; SSE42-NEXT:    movaps {{.*#+}} xmm1 = [7,5,5,7]
; SSE42-NEXT:    retq
;
; AVX-LABEL: max_gt_v8i32c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} ymm0 = [4294967295,4294967293,4294967293,4294967295,7,5,5,7]
; AVX-NEXT:    retq
  %1 = insertelement <8 x i32> <i32 -7, i32 -5, i32 -3, i32 -1, i32 1, i32 3, i32 5, i32 7>, i32 -7, i32 0
  %2 = insertelement <8 x i32> <i32 -1, i32 -3, i32 -5, i32 -7, i32 7, i32 5, i32 3, i32 1>, i32 -1, i32 0
  %3 = icmp sgt <8 x i32> %1, %2
  %4 = select <8 x i1> %3, <8 x i32> %1, <8 x i32> %2
  ret <8 x i32> %4
}

define <8 x i16> @max_gt_v8i16c() {
; SSE-LABEL: max_gt_v8i16c:
; SSE:       # BB#0:
; SSE-NEXT:    movaps {{.*#+}} xmm0 = [65535,65533,65533,65535,7,5,5,7]
; SSE-NEXT:    retq
;
; AVX-LABEL: max_gt_v8i16c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} xmm0 = [65535,65533,65533,65535,7,5,5,7]
; AVX-NEXT:    retq
  %1 = insertelement <8 x i16> <i16 -7, i16 -5, i16 -3, i16 -1, i16 1, i16 3, i16 5, i16 7>, i16 -7, i32 0
  %2 = insertelement <8 x i16> <i16 -1, i16 -3, i16 -5, i16 -7, i16 7, i16 5, i16 3, i16 1>, i16 -1, i32 0
  %3 = icmp sgt <8 x i16> %1, %2
  %4 = select <8 x i1> %3, <8 x i16> %1, <8 x i16> %2
  ret <8 x i16> %4
}

define <16 x i16> @max_gt_v16i16c() {
; SSE-LABEL: max_gt_v16i16c:
; SSE:       # BB#0:
; SSE-NEXT:    movaps {{.*#+}} xmm0 = [65535,65534,65533,65532,65533,65534,65535,0]
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [7,6,5,4,5,6,7,8]
; SSE-NEXT:    retq
;
; AVX-LABEL: max_gt_v16i16c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} ymm0 = [65535,65534,65533,65532,65533,65534,65535,0,7,6,5,4,5,6,7,8]
; AVX-NEXT:    retq
  %1 = insertelement <16 x i16> <i16 -7, i16 -6, i16 -5, i16 -4, i16 -3, i16 -2, i16 -1, i16 0, i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7, i16 8>, i16 -7, i32 0
  %2 = insertelement <16 x i16> <i16 -1, i16 -2, i16 -3, i16 -4, i16 -5, i16 -6, i16 -7, i16 0, i16 7, i16 6, i16 5, i16 4, i16 3, i16 2, i16 1, i16 0>, i16 -1, i32 0
  %3 = icmp sgt <16 x i16> %1, %2
  %4 = select <16 x i1> %3, <16 x i16> %1, <16 x i16> %2
  ret <16 x i16> %4
}

define <16 x i8> @max_gt_v16i8c() {
; SSE2-LABEL: max_gt_v16i8c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [249,250,251,252,253,254,255,0,1,2,3,4,5,6,7,8]
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [255,254,253,252,251,250,249,0,7,6,5,4,3,2,1,0]
; SSE2-NEXT:    movdqa %xmm1, %xmm0
; SSE2-NEXT:    pcmpgtb %xmm2, %xmm0
; SSE2-NEXT:    pand %xmm0, %xmm1
; SSE2-NEXT:    pandn %xmm2, %xmm0
; SSE2-NEXT:    por %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_gt_v16i8c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movaps {{.*#+}} xmm0 = [255,254,253,252,253,254,255,0,7,6,5,4,5,6,7,8]
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_gt_v16i8c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movaps {{.*#+}} xmm0 = [255,254,253,252,253,254,255,0,7,6,5,4,5,6,7,8]
; SSE42-NEXT:    retq
;
; AVX-LABEL: max_gt_v16i8c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} xmm0 = [255,254,253,252,253,254,255,0,7,6,5,4,5,6,7,8]
; AVX-NEXT:    retq
  %1 = insertelement <16 x i8> <i8 -7, i8 -6, i8 -5, i8 -4, i8 -3, i8 -2, i8 -1, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 8>, i8 -7, i32 0
  %2 = insertelement <16 x i8> <i8 -1, i8 -2, i8 -3, i8 -4, i8 -5, i8 -6, i8 -7, i8 0, i8 7, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0>, i8 -1, i32 0
  %3 = icmp sgt <16 x i8> %1, %2
  %4 = select <16 x i1> %3, <16 x i8> %1, <16 x i8> %2
  ret <16 x i8> %4
}

define <2 x i64> @max_ge_v2i64c() {
; SSE2-LABEL: max_ge_v2i64c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [18446744073709551609,7]
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551615,1]
; SSE2-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE2-NEXT:    movdqa %xmm0, %xmm3
; SSE2-NEXT:    pxor %xmm1, %xmm3
; SSE2-NEXT:    pxor %xmm2, %xmm0
; SSE2-NEXT:    movdqa %xmm0, %xmm4
; SSE2-NEXT:    pcmpgtd %xmm3, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm3, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE2-NEXT:    pand %xmm5, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm4[1,1,3,3]
; SSE2-NEXT:    por %xmm0, %xmm3
; SSE2-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE2-NEXT:    pxor %xmm3, %xmm0
; SSE2-NEXT:    pandn %xmm1, %xmm3
; SSE2-NEXT:    pandn %xmm2, %xmm0
; SSE2-NEXT:    por %xmm3, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_ge_v2i64c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551609,7]
; SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [18446744073709551615,1]
; SSE41-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE41-NEXT:    movdqa %xmm0, %xmm3
; SSE41-NEXT:    pxor %xmm2, %xmm3
; SSE41-NEXT:    pxor %xmm1, %xmm0
; SSE41-NEXT:    movdqa %xmm0, %xmm4
; SSE41-NEXT:    pcmpgtd %xmm3, %xmm4
; SSE41-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm3, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE41-NEXT:    pand %xmm5, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm4[1,1,3,3]
; SSE41-NEXT:    por %xmm0, %xmm3
; SSE41-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE41-NEXT:    pxor %xmm3, %xmm0
; SSE41-NEXT:    blendvpd %xmm2, %xmm1
; SSE41-NEXT:    movapd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_ge_v2i64c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551609,7]
; SSE42-NEXT:    movdqa {{.*#+}} xmm1 = [18446744073709551615,1]
; SSE42-NEXT:    movdqa %xmm1, %xmm3
; SSE42-NEXT:    pcmpgtq %xmm2, %xmm3
; SSE42-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE42-NEXT:    pxor %xmm3, %xmm0
; SSE42-NEXT:    blendvpd %xmm2, %xmm1
; SSE42-NEXT:    movapd %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: max_ge_v2i64c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovdqa {{.*#+}} xmm0 = [18446744073709551609,7]
; AVX-NEXT:    vmovdqa {{.*#+}} xmm1 = [18446744073709551615,1]
; AVX-NEXT:    vpcmpgtq %xmm0, %xmm1, %xmm2
; AVX-NEXT:    vpcmpeqd %xmm3, %xmm3, %xmm3
; AVX-NEXT:    vpxor %xmm3, %xmm2, %xmm2
; AVX-NEXT:    vblendvpd %xmm2, %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = insertelement <2 x i64> <i64 -7, i64 7>, i64 -7, i32 0
  %2 = insertelement <2 x i64> <i64 -1, i64 1>, i64 -1, i32 0
  %3 = icmp sge <2 x i64> %1, %2
  %4 = select <2 x i1> %3, <2 x i64> %1, <2 x i64> %2
  ret <2 x i64> %4
}

define <4 x i64> @max_ge_v4i64c() {
; SSE2-LABEL: max_ge_v4i64c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm10 = [18446744073709551609,18446744073709551615]
; SSE2-NEXT:    movdqa {{.*#+}} xmm8 = [1,7]
; SSE2-NEXT:    movdqa {{.*#+}} xmm5 = [18446744073709551615,18446744073709551609]
; SSE2-NEXT:    movdqa {{.*#+}} xmm9 = [7,1]
; SSE2-NEXT:    movdqa {{.*#+}} xmm7 = [2147483648,0,2147483648,0]
; SSE2-NEXT:    movdqa %xmm7, %xmm0
; SSE2-NEXT:    pxor %xmm8, %xmm0
; SSE2-NEXT:    movdqa %xmm7, %xmm1
; SSE2-NEXT:    pxor %xmm9, %xmm1
; SSE2-NEXT:    movdqa %xmm1, %xmm6
; SSE2-NEXT:    pcmpgtd %xmm0, %xmm6
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm6[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,3,3]
; SSE2-NEXT:    pand %xmm2, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm6 = xmm6[1,1,3,3]
; SSE2-NEXT:    por %xmm0, %xmm6
; SSE2-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE2-NEXT:    movdqa %xmm6, %xmm1
; SSE2-NEXT:    pxor %xmm0, %xmm1
; SSE2-NEXT:    movdqa %xmm7, %xmm2
; SSE2-NEXT:    pxor %xmm10, %xmm2
; SSE2-NEXT:    pxor %xmm5, %xmm7
; SSE2-NEXT:    movdqa %xmm7, %xmm3
; SSE2-NEXT:    pcmpgtd %xmm2, %xmm3
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm3[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm2, %xmm7
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm7[1,1,3,3]
; SSE2-NEXT:    pand %xmm4, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[1,1,3,3]
; SSE2-NEXT:    por %xmm2, %xmm3
; SSE2-NEXT:    pxor %xmm3, %xmm0
; SSE2-NEXT:    pandn %xmm10, %xmm3
; SSE2-NEXT:    pandn %xmm5, %xmm0
; SSE2-NEXT:    por %xmm3, %xmm0
; SSE2-NEXT:    pandn %xmm8, %xmm6
; SSE2-NEXT:    pandn %xmm9, %xmm1
; SSE2-NEXT:    por %xmm6, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_ge_v4i64c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movdqa {{.*#+}} xmm9 = [18446744073709551609,18446744073709551615]
; SSE41-NEXT:    movdqa {{.*#+}} xmm8 = [1,7]
; SSE41-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551615,18446744073709551609]
; SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [7,1]
; SSE41-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE41-NEXT:    movdqa %xmm0, %xmm3
; SSE41-NEXT:    pxor %xmm8, %xmm3
; SSE41-NEXT:    movdqa %xmm0, %xmm6
; SSE41-NEXT:    pxor %xmm1, %xmm6
; SSE41-NEXT:    movdqa %xmm6, %xmm7
; SSE41-NEXT:    pcmpgtd %xmm3, %xmm7
; SSE41-NEXT:    pshufd {{.*#+}} xmm4 = xmm7[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm3, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm6 = xmm6[1,1,3,3]
; SSE41-NEXT:    pand %xmm4, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm7[1,1,3,3]
; SSE41-NEXT:    por %xmm6, %xmm3
; SSE41-NEXT:    pcmpeqd %xmm4, %xmm4
; SSE41-NEXT:    pxor %xmm4, %xmm3
; SSE41-NEXT:    movdqa %xmm0, %xmm6
; SSE41-NEXT:    pxor %xmm9, %xmm6
; SSE41-NEXT:    pxor %xmm2, %xmm0
; SSE41-NEXT:    movdqa %xmm0, %xmm7
; SSE41-NEXT:    pcmpgtd %xmm6, %xmm7
; SSE41-NEXT:    pshufd {{.*#+}} xmm5 = xmm7[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm6, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm6 = xmm0[1,1,3,3]
; SSE41-NEXT:    pand %xmm5, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm7[1,1,3,3]
; SSE41-NEXT:    por %xmm6, %xmm0
; SSE41-NEXT:    pxor %xmm4, %xmm0
; SSE41-NEXT:    blendvpd %xmm9, %xmm2
; SSE41-NEXT:    movdqa %xmm3, %xmm0
; SSE41-NEXT:    blendvpd %xmm8, %xmm1
; SSE41-NEXT:    movapd %xmm2, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_ge_v4i64c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movdqa {{.*#+}} xmm4 = [18446744073709551609,18446744073709551615]
; SSE42-NEXT:    movdqa {{.*#+}} xmm5 = [1,7]
; SSE42-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551615,18446744073709551609]
; SSE42-NEXT:    movdqa {{.*#+}} xmm1 = [7,1]
; SSE42-NEXT:    movdqa %xmm1, %xmm3
; SSE42-NEXT:    pcmpgtq %xmm5, %xmm3
; SSE42-NEXT:    pcmpeqd %xmm6, %xmm6
; SSE42-NEXT:    pxor %xmm6, %xmm3
; SSE42-NEXT:    movdqa %xmm2, %xmm0
; SSE42-NEXT:    pcmpgtq %xmm4, %xmm0
; SSE42-NEXT:    pxor %xmm6, %xmm0
; SSE42-NEXT:    blendvpd %xmm4, %xmm2
; SSE42-NEXT:    movdqa %xmm3, %xmm0
; SSE42-NEXT:    blendvpd %xmm5, %xmm1
; SSE42-NEXT:    movapd %xmm2, %xmm0
; SSE42-NEXT:    retq
;
; AVX1-LABEL: max_ge_v4i64c:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovapd {{.*#+}} ymm0 = [18446744073709551615,18446744073709551609,7,1]
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm1 = [7,1]
; AVX1-NEXT:    vpcmpgtq {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpxor %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [18446744073709551615,18446744073709551609]
; AVX1-NEXT:    vpcmpgtq {{.*}}(%rip), %xmm3, %xmm3
; AVX1-NEXT:    vpxor %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm2, %ymm1
; AVX1-NEXT:    vblendvpd %ymm1, {{.*}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: max_ge_v4i64c:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm0 = [18446744073709551609,18446744073709551615,1,7]
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm1 = [18446744073709551615,18446744073709551609,7,1]
; AVX2-NEXT:    vpcmpgtq %ymm0, %ymm1, %ymm2
; AVX2-NEXT:    vpcmpeqd %ymm3, %ymm3, %ymm3
; AVX2-NEXT:    vpxor %ymm3, %ymm2, %ymm2
; AVX2-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: max_ge_v4i64c:
; AVX512:       # BB#0:
; AVX512-NEXT:    vmovdqa {{.*#+}} ymm0 = [18446744073709551609,18446744073709551615,1,7]
; AVX512-NEXT:    vmovdqa {{.*#+}} ymm1 = [18446744073709551615,18446744073709551609,7,1]
; AVX512-NEXT:    vpcmpgtq %ymm0, %ymm1, %ymm2
; AVX512-NEXT:    vpcmpeqd %ymm3, %ymm3, %ymm3
; AVX512-NEXT:    vpxor %ymm3, %ymm2, %ymm2
; AVX512-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX512-NEXT:    retq
  %1 = insertelement <4 x i64> <i64 -7, i64 -1, i64 1, i64 7>, i64 -7, i32 0
  %2 = insertelement <4 x i64> <i64 -1, i64 -7, i64 7, i64 1>, i64 -1, i32 0
  %3 = icmp sge <4 x i64> %1, %2
  %4 = select <4 x i1> %3, <4 x i64> %1, <4 x i64> %2
  ret <4 x i64> %4
}

define <4 x i32> @max_ge_v4i32c() {
; SSE2-LABEL: max_ge_v4i32c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [4294967289,4294967295,1,7]
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [4294967295,4294967289,7,1]
; SSE2-NEXT:    movdqa %xmm2, %xmm3
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm3
; SSE2-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE2-NEXT:    pxor %xmm3, %xmm0
; SSE2-NEXT:    pandn %xmm1, %xmm3
; SSE2-NEXT:    pandn %xmm2, %xmm0
; SSE2-NEXT:    por %xmm3, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_ge_v4i32c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movaps {{.*#+}} xmm0 = [4294967295,4294967295,7,7]
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_ge_v4i32c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movaps {{.*#+}} xmm0 = [4294967295,4294967295,7,7]
; SSE42-NEXT:    retq
;
; AVX-LABEL: max_ge_v4i32c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} xmm0 = [4294967295,4294967295,7,7]
; AVX-NEXT:    retq
  %1 = insertelement <4 x i32> <i32 -7, i32 -1, i32 1, i32 7>, i32 -7, i32 0
  %2 = insertelement <4 x i32> <i32 -1, i32 -7, i32 7, i32 1>, i32 -1, i32 0
  %3 = icmp sge <4 x i32> %1, %2
  %4 = select <4 x i1> %3, <4 x i32> %1, <4 x i32> %2
  ret <4 x i32> %4
}

define <8 x i32> @max_ge_v8i32c() {
; SSE2-LABEL: max_ge_v8i32c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [4294967289,4294967291,4294967293,4294967295]
; SSE2-NEXT:    movdqa {{.*#+}} xmm3 = [1,3,5,7]
; SSE2-NEXT:    movdqa {{.*#+}} xmm4 = [4294967295,4294967293,4294967291,4294967289]
; SSE2-NEXT:    movdqa {{.*#+}} xmm5 = [7,5,3,1]
; SSE2-NEXT:    movdqa %xmm5, %xmm6
; SSE2-NEXT:    pcmpgtd %xmm3, %xmm6
; SSE2-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE2-NEXT:    movdqa %xmm6, %xmm1
; SSE2-NEXT:    pxor %xmm0, %xmm1
; SSE2-NEXT:    movdqa %xmm4, %xmm7
; SSE2-NEXT:    pcmpgtd %xmm2, %xmm7
; SSE2-NEXT:    pxor %xmm7, %xmm0
; SSE2-NEXT:    pandn %xmm2, %xmm7
; SSE2-NEXT:    pandn %xmm4, %xmm0
; SSE2-NEXT:    por %xmm7, %xmm0
; SSE2-NEXT:    pandn %xmm3, %xmm6
; SSE2-NEXT:    pandn %xmm5, %xmm1
; SSE2-NEXT:    por %xmm6, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_ge_v8i32c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movaps {{.*#+}} xmm0 = [4294967295,4294967293,4294967293,4294967295]
; SSE41-NEXT:    movaps {{.*#+}} xmm1 = [7,5,5,7]
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_ge_v8i32c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movaps {{.*#+}} xmm0 = [4294967295,4294967293,4294967293,4294967295]
; SSE42-NEXT:    movaps {{.*#+}} xmm1 = [7,5,5,7]
; SSE42-NEXT:    retq
;
; AVX-LABEL: max_ge_v8i32c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} ymm0 = [4294967295,4294967293,4294967293,4294967295,7,5,5,7]
; AVX-NEXT:    retq
  %1 = insertelement <8 x i32> <i32 -7, i32 -5, i32 -3, i32 -1, i32 1, i32 3, i32 5, i32 7>, i32 -7, i32 0
  %2 = insertelement <8 x i32> <i32 -1, i32 -3, i32 -5, i32 -7, i32 7, i32 5, i32 3, i32 1>, i32 -1, i32 0
  %3 = icmp sge <8 x i32> %1, %2
  %4 = select <8 x i1> %3, <8 x i32> %1, <8 x i32> %2
  ret <8 x i32> %4
}

define <8 x i16> @max_ge_v8i16c() {
; SSE-LABEL: max_ge_v8i16c:
; SSE:       # BB#0:
; SSE-NEXT:    movaps {{.*#+}} xmm0 = [65535,65533,65533,65535,7,5,5,7]
; SSE-NEXT:    retq
;
; AVX-LABEL: max_ge_v8i16c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} xmm0 = [65535,65533,65533,65535,7,5,5,7]
; AVX-NEXT:    retq
  %1 = insertelement <8 x i16> <i16 -7, i16 -5, i16 -3, i16 -1, i16 1, i16 3, i16 5, i16 7>, i16 -7, i32 0
  %2 = insertelement <8 x i16> <i16 -1, i16 -3, i16 -5, i16 -7, i16 7, i16 5, i16 3, i16 1>, i16 -1, i32 0
  %3 = icmp sge <8 x i16> %1, %2
  %4 = select <8 x i1> %3, <8 x i16> %1, <8 x i16> %2
  ret <8 x i16> %4
}

define <16 x i16> @max_ge_v16i16c() {
; SSE-LABEL: max_ge_v16i16c:
; SSE:       # BB#0:
; SSE-NEXT:    movaps {{.*#+}} xmm0 = [65535,65534,65533,65532,65533,65534,65535,0]
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [7,6,5,4,5,6,7,8]
; SSE-NEXT:    retq
;
; AVX-LABEL: max_ge_v16i16c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} ymm0 = [65535,65534,65533,65532,65533,65534,65535,0,7,6,5,4,5,6,7,8]
; AVX-NEXT:    retq
  %1 = insertelement <16 x i16> <i16 -7, i16 -6, i16 -5, i16 -4, i16 -3, i16 -2, i16 -1, i16 0, i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7, i16 8>, i16 -7, i32 0
  %2 = insertelement <16 x i16> <i16 -1, i16 -2, i16 -3, i16 -4, i16 -5, i16 -6, i16 -7, i16 0, i16 7, i16 6, i16 5, i16 4, i16 3, i16 2, i16 1, i16 0>, i16 -1, i32 0
  %3 = icmp sge <16 x i16> %1, %2
  %4 = select <16 x i1> %3, <16 x i16> %1, <16 x i16> %2
  ret <16 x i16> %4
}

define <16 x i8> @max_ge_v16i8c() {
; SSE2-LABEL: max_ge_v16i8c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [249,250,251,252,253,254,255,0,1,2,3,4,5,6,7,8]
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [255,254,253,252,251,250,249,0,7,6,5,4,3,2,1,0]
; SSE2-NEXT:    movdqa %xmm2, %xmm3
; SSE2-NEXT:    pcmpgtb %xmm1, %xmm3
; SSE2-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE2-NEXT:    pxor %xmm3, %xmm0
; SSE2-NEXT:    pandn %xmm1, %xmm3
; SSE2-NEXT:    pandn %xmm2, %xmm0
; SSE2-NEXT:    por %xmm3, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: max_ge_v16i8c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movaps {{.*#+}} xmm0 = [255,254,253,252,253,254,255,0,7,6,5,4,5,6,7,8]
; SSE41-NEXT:    retq
;
; SSE42-LABEL: max_ge_v16i8c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movaps {{.*#+}} xmm0 = [255,254,253,252,253,254,255,0,7,6,5,4,5,6,7,8]
; SSE42-NEXT:    retq
;
; AVX-LABEL: max_ge_v16i8c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} xmm0 = [255,254,253,252,253,254,255,0,7,6,5,4,5,6,7,8]
; AVX-NEXT:    retq
  %1 = insertelement <16 x i8> <i8 -7, i8 -6, i8 -5, i8 -4, i8 -3, i8 -2, i8 -1, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 8>, i8 -7, i32 0
  %2 = insertelement <16 x i8> <i8 -1, i8 -2, i8 -3, i8 -4, i8 -5, i8 -6, i8 -7, i8 0, i8 7, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0>, i8 -1, i32 0
  %3 = icmp sge <16 x i8> %1, %2
  %4 = select <16 x i1> %3, <16 x i8> %1, <16 x i8> %2
  ret <16 x i8> %4
}

define <2 x i64> @min_lt_v2i64c() {
; SSE2-LABEL: min_lt_v2i64c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [18446744073709551609,7]
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551615,1]
; SSE2-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE2-NEXT:    movdqa %xmm0, %xmm3
; SSE2-NEXT:    pxor %xmm1, %xmm3
; SSE2-NEXT:    pxor %xmm2, %xmm0
; SSE2-NEXT:    movdqa %xmm0, %xmm4
; SSE2-NEXT:    pcmpgtd %xmm3, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm3, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; SSE2-NEXT:    pand %xmm5, %xmm3
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm4[1,1,3,3]
; SSE2-NEXT:    por %xmm3, %xmm0
; SSE2-NEXT:    movdqa %xmm0, %xmm3
; SSE2-NEXT:    pandn %xmm2, %xmm3
; SSE2-NEXT:    pand %xmm1, %xmm0
; SSE2-NEXT:    por %xmm3, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_lt_v2i64c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551609,7]
; SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [18446744073709551615,1]
; SSE41-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE41-NEXT:    movdqa %xmm0, %xmm3
; SSE41-NEXT:    pxor %xmm2, %xmm3
; SSE41-NEXT:    pxor %xmm1, %xmm0
; SSE41-NEXT:    movdqa %xmm0, %xmm4
; SSE41-NEXT:    pcmpgtd %xmm3, %xmm4
; SSE41-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm3, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; SSE41-NEXT:    pand %xmm5, %xmm3
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm4[1,1,3,3]
; SSE41-NEXT:    por %xmm3, %xmm0
; SSE41-NEXT:    blendvpd %xmm2, %xmm1
; SSE41-NEXT:    movapd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_lt_v2i64c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551609,7]
; SSE42-NEXT:    movdqa {{.*#+}} xmm1 = [18446744073709551615,1]
; SSE42-NEXT:    movdqa %xmm1, %xmm0
; SSE42-NEXT:    pcmpgtq %xmm2, %xmm0
; SSE42-NEXT:    blendvpd %xmm2, %xmm1
; SSE42-NEXT:    movapd %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: min_lt_v2i64c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovdqa {{.*#+}} xmm0 = [18446744073709551609,7]
; AVX-NEXT:    vmovdqa {{.*#+}} xmm1 = [18446744073709551615,1]
; AVX-NEXT:    vpcmpgtq %xmm0, %xmm1, %xmm2
; AVX-NEXT:    vblendvpd %xmm2, %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = insertelement <2 x i64> <i64 -7, i64 7>, i64 -7, i32 0
  %2 = insertelement <2 x i64> <i64 -1, i64 1>, i64 -1, i32 0
  %3 = icmp slt <2 x i64> %1, %2
  %4 = select <2 x i1> %3, <2 x i64> %1, <2 x i64> %2
  ret <2 x i64> %4
}

define <4 x i64> @min_lt_v4i64c() {
; SSE2-LABEL: min_lt_v4i64c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm4 = [18446744073709551609,18446744073709551615]
; SSE2-NEXT:    movdqa {{.*#+}} xmm8 = [1,7]
; SSE2-NEXT:    movdqa {{.*#+}} xmm5 = [18446744073709551615,18446744073709551609]
; SSE2-NEXT:    movdqa {{.*#+}} xmm3 = [7,1]
; SSE2-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE2-NEXT:    movdqa %xmm0, %xmm1
; SSE2-NEXT:    pxor %xmm8, %xmm1
; SSE2-NEXT:    movdqa %xmm0, %xmm6
; SSE2-NEXT:    pxor %xmm3, %xmm6
; SSE2-NEXT:    movdqa %xmm6, %xmm7
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm7
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm7[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm1, %xmm6
; SSE2-NEXT:    pshufd {{.*#+}} xmm6 = xmm6[1,1,3,3]
; SSE2-NEXT:    pand %xmm2, %xmm6
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm7[1,1,3,3]
; SSE2-NEXT:    por %xmm6, %xmm1
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    pxor %xmm4, %xmm2
; SSE2-NEXT:    pxor %xmm5, %xmm0
; SSE2-NEXT:    movdqa %xmm0, %xmm6
; SSE2-NEXT:    pcmpgtd %xmm2, %xmm6
; SSE2-NEXT:    pshufd {{.*#+}} xmm7 = xmm6[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm2, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; SSE2-NEXT:    pand %xmm7, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm6[1,1,3,3]
; SSE2-NEXT:    por %xmm2, %xmm0
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    pandn %xmm5, %xmm2
; SSE2-NEXT:    pand %xmm4, %xmm0
; SSE2-NEXT:    por %xmm2, %xmm0
; SSE2-NEXT:    movdqa %xmm1, %xmm2
; SSE2-NEXT:    pandn %xmm3, %xmm2
; SSE2-NEXT:    pand %xmm8, %xmm1
; SSE2-NEXT:    por %xmm2, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_lt_v4i64c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movdqa {{.*#+}} xmm5 = [18446744073709551609,18446744073709551615]
; SSE41-NEXT:    movdqa {{.*#+}} xmm8 = [1,7]
; SSE41-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551615,18446744073709551609]
; SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [7,1]
; SSE41-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE41-NEXT:    movdqa %xmm0, %xmm3
; SSE41-NEXT:    pxor %xmm8, %xmm3
; SSE41-NEXT:    movdqa %xmm0, %xmm6
; SSE41-NEXT:    pxor %xmm1, %xmm6
; SSE41-NEXT:    movdqa %xmm6, %xmm7
; SSE41-NEXT:    pcmpgtd %xmm3, %xmm7
; SSE41-NEXT:    pshufd {{.*#+}} xmm4 = xmm7[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm3, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm6 = xmm6[1,1,3,3]
; SSE41-NEXT:    pand %xmm4, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm7[1,1,3,3]
; SSE41-NEXT:    por %xmm6, %xmm3
; SSE41-NEXT:    movdqa %xmm0, %xmm4
; SSE41-NEXT:    pxor %xmm5, %xmm4
; SSE41-NEXT:    pxor %xmm2, %xmm0
; SSE41-NEXT:    movdqa %xmm0, %xmm6
; SSE41-NEXT:    pcmpgtd %xmm4, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm7 = xmm6[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm4, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm4 = xmm0[1,1,3,3]
; SSE41-NEXT:    pand %xmm7, %xmm4
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm6[1,1,3,3]
; SSE41-NEXT:    por %xmm4, %xmm0
; SSE41-NEXT:    blendvpd %xmm5, %xmm2
; SSE41-NEXT:    movdqa %xmm3, %xmm0
; SSE41-NEXT:    blendvpd %xmm8, %xmm1
; SSE41-NEXT:    movapd %xmm2, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_lt_v4i64c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movdqa {{.*#+}} xmm4 = [18446744073709551609,18446744073709551615]
; SSE42-NEXT:    movdqa {{.*#+}} xmm5 = [1,7]
; SSE42-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551615,18446744073709551609]
; SSE42-NEXT:    movdqa {{.*#+}} xmm1 = [7,1]
; SSE42-NEXT:    movdqa %xmm1, %xmm3
; SSE42-NEXT:    pcmpgtq %xmm5, %xmm3
; SSE42-NEXT:    movdqa %xmm2, %xmm0
; SSE42-NEXT:    pcmpgtq %xmm4, %xmm0
; SSE42-NEXT:    blendvpd %xmm4, %xmm2
; SSE42-NEXT:    movdqa %xmm3, %xmm0
; SSE42-NEXT:    blendvpd %xmm5, %xmm1
; SSE42-NEXT:    movapd %xmm2, %xmm0
; SSE42-NEXT:    retq
;
; AVX1-LABEL: min_lt_v4i64c:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovapd {{.*#+}} ymm0 = [18446744073709551615,18446744073709551609,7,1]
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm1 = [18446744073709551615,18446744073709551609]
; AVX1-NEXT:    vpcmpgtq {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [7,1]
; AVX1-NEXT:    vpcmpgtq {{.*}}(%rip), %xmm2, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; AVX1-NEXT:    vblendvpd %ymm1, {{.*}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: min_lt_v4i64c:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm0 = [18446744073709551609,18446744073709551615,1,7]
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm1 = [18446744073709551615,18446744073709551609,7,1]
; AVX2-NEXT:    vpcmpgtq %ymm0, %ymm1, %ymm2
; AVX2-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: min_lt_v4i64c:
; AVX512:       # BB#0:
; AVX512-NEXT:    vmovdqa {{.*#+}} ymm0 = [18446744073709551609,18446744073709551615,1,7]
; AVX512-NEXT:    vmovdqa {{.*#+}} ymm1 = [18446744073709551615,18446744073709551609,7,1]
; AVX512-NEXT:    vpcmpgtq %ymm0, %ymm1, %ymm2
; AVX512-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX512-NEXT:    retq
  %1 = insertelement <4 x i64> <i64 -7, i64 -1, i64 1, i64 7>, i64 -7, i32 0
  %2 = insertelement <4 x i64> <i64 -1, i64 -7, i64 7, i64 1>, i64 -1, i32 0
  %3 = icmp slt <4 x i64> %1, %2
  %4 = select <4 x i1> %3, <4 x i64> %1, <4 x i64> %2
  ret <4 x i64> %4
}

define <4 x i32> @min_lt_v4i32c() {
; SSE2-LABEL: min_lt_v4i32c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [4294967289,4294967295,1,7]
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [4294967295,4294967289,7,1]
; SSE2-NEXT:    movdqa %xmm2, %xmm0
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE2-NEXT:    pand %xmm0, %xmm1
; SSE2-NEXT:    pandn %xmm2, %xmm0
; SSE2-NEXT:    por %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_lt_v4i32c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movaps {{.*#+}} xmm0 = [4294967289,4294967289,1,1]
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_lt_v4i32c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movaps {{.*#+}} xmm0 = [4294967289,4294967289,1,1]
; SSE42-NEXT:    retq
;
; AVX-LABEL: min_lt_v4i32c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} xmm0 = [4294967289,4294967289,1,1]
; AVX-NEXT:    retq
  %1 = insertelement <4 x i32> <i32 -7, i32 -1, i32 1, i32 7>, i32 -7, i32 0
  %2 = insertelement <4 x i32> <i32 -1, i32 -7, i32 7, i32 1>, i32 -1, i32 0
  %3 = icmp slt <4 x i32> %1, %2
  %4 = select <4 x i1> %3, <4 x i32> %1, <4 x i32> %2
  ret <4 x i32> %4
}

define <8 x i32> @min_lt_v8i32c() {
; SSE2-LABEL: min_lt_v8i32c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [4294967289,4294967291,4294967293,4294967295]
; SSE2-NEXT:    movdqa {{.*#+}} xmm3 = [1,3,5,7]
; SSE2-NEXT:    movdqa {{.*#+}} xmm4 = [4294967295,4294967293,4294967291,4294967289]
; SSE2-NEXT:    movdqa {{.*#+}} xmm5 = [7,5,3,1]
; SSE2-NEXT:    movdqa %xmm5, %xmm1
; SSE2-NEXT:    pcmpgtd %xmm3, %xmm1
; SSE2-NEXT:    movdqa %xmm4, %xmm0
; SSE2-NEXT:    pcmpgtd %xmm2, %xmm0
; SSE2-NEXT:    pand %xmm0, %xmm2
; SSE2-NEXT:    pandn %xmm4, %xmm0
; SSE2-NEXT:    por %xmm2, %xmm0
; SSE2-NEXT:    pand %xmm1, %xmm3
; SSE2-NEXT:    pandn %xmm5, %xmm1
; SSE2-NEXT:    por %xmm3, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_lt_v8i32c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movaps {{.*#+}} xmm0 = [4294967289,4294967291,4294967291,4294967289]
; SSE41-NEXT:    movaps {{.*#+}} xmm1 = [1,3,3,1]
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_lt_v8i32c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movaps {{.*#+}} xmm0 = [4294967289,4294967291,4294967291,4294967289]
; SSE42-NEXT:    movaps {{.*#+}} xmm1 = [1,3,3,1]
; SSE42-NEXT:    retq
;
; AVX-LABEL: min_lt_v8i32c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} ymm0 = [4294967289,4294967291,4294967291,4294967289,1,3,3,1]
; AVX-NEXT:    retq
  %1 = insertelement <8 x i32> <i32 -7, i32 -5, i32 -3, i32 -1, i32 1, i32 3, i32 5, i32 7>, i32 -7, i32 0
  %2 = insertelement <8 x i32> <i32 -1, i32 -3, i32 -5, i32 -7, i32 7, i32 5, i32 3, i32 1>, i32 -1, i32 0
  %3 = icmp slt <8 x i32> %1, %2
  %4 = select <8 x i1> %3, <8 x i32> %1, <8 x i32> %2
  ret <8 x i32> %4
}

define <8 x i16> @min_lt_v8i16c() {
; SSE-LABEL: min_lt_v8i16c:
; SSE:       # BB#0:
; SSE-NEXT:    movaps {{.*#+}} xmm0 = [65529,65531,65531,65529,1,3,3,1]
; SSE-NEXT:    retq
;
; AVX-LABEL: min_lt_v8i16c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} xmm0 = [65529,65531,65531,65529,1,3,3,1]
; AVX-NEXT:    retq
  %1 = insertelement <8 x i16> <i16 -7, i16 -5, i16 -3, i16 -1, i16 1, i16 3, i16 5, i16 7>, i16 -7, i32 0
  %2 = insertelement <8 x i16> <i16 -1, i16 -3, i16 -5, i16 -7, i16 7, i16 5, i16 3, i16 1>, i16 -1, i32 0
  %3 = icmp slt <8 x i16> %1, %2
  %4 = select <8 x i1> %3, <8 x i16> %1, <8 x i16> %2
  ret <8 x i16> %4
}

define <16 x i16> @min_lt_v16i16c() {
; SSE-LABEL: min_lt_v16i16c:
; SSE:       # BB#0:
; SSE-NEXT:    movaps {{.*#+}} xmm0 = [65529,65530,65531,65532,65531,65530,65529,0]
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [1,2,3,4,3,2,1,0]
; SSE-NEXT:    retq
;
; AVX-LABEL: min_lt_v16i16c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} ymm0 = [65529,65530,65531,65532,65531,65530,65529,0,1,2,3,4,3,2,1,0]
; AVX-NEXT:    retq
  %1 = insertelement <16 x i16> <i16 -7, i16 -6, i16 -5, i16 -4, i16 -3, i16 -2, i16 -1, i16 0, i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7, i16 8>, i16 -7, i32 0
  %2 = insertelement <16 x i16> <i16 -1, i16 -2, i16 -3, i16 -4, i16 -5, i16 -6, i16 -7, i16 0, i16 7, i16 6, i16 5, i16 4, i16 3, i16 2, i16 1, i16 0>, i16 -1, i32 0
  %3 = icmp slt <16 x i16> %1, %2
  %4 = select <16 x i1> %3, <16 x i16> %1, <16 x i16> %2
  ret <16 x i16> %4
}

define <16 x i8> @min_lt_v16i8c() {
; SSE2-LABEL: min_lt_v16i8c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [249,250,251,252,253,254,255,0,1,2,3,4,5,6,7,8]
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [255,254,253,252,251,250,249,0,7,6,5,4,3,2,1,0]
; SSE2-NEXT:    movdqa %xmm2, %xmm0
; SSE2-NEXT:    pcmpgtb %xmm1, %xmm0
; SSE2-NEXT:    pand %xmm0, %xmm1
; SSE2-NEXT:    pandn %xmm2, %xmm0
; SSE2-NEXT:    por %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_lt_v16i8c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movaps {{.*#+}} xmm0 = [249,250,251,252,251,250,249,0,1,2,3,4,3,2,1,0]
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_lt_v16i8c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movaps {{.*#+}} xmm0 = [249,250,251,252,251,250,249,0,1,2,3,4,3,2,1,0]
; SSE42-NEXT:    retq
;
; AVX-LABEL: min_lt_v16i8c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} xmm0 = [249,250,251,252,251,250,249,0,1,2,3,4,3,2,1,0]
; AVX-NEXT:    retq
  %1 = insertelement <16 x i8> <i8 -7, i8 -6, i8 -5, i8 -4, i8 -3, i8 -2, i8 -1, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 8>, i8 -7, i32 0
  %2 = insertelement <16 x i8> <i8 -1, i8 -2, i8 -3, i8 -4, i8 -5, i8 -6, i8 -7, i8 0, i8 7, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0>, i8 -1, i32 0
  %3 = icmp slt <16 x i8> %1, %2
  %4 = select <16 x i1> %3, <16 x i8> %1, <16 x i8> %2
  ret <16 x i8> %4
}

define <2 x i64> @min_le_v2i64c() {
; SSE2-LABEL: min_le_v2i64c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [18446744073709551609,7]
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551615,1]
; SSE2-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE2-NEXT:    movdqa %xmm0, %xmm3
; SSE2-NEXT:    pxor %xmm2, %xmm3
; SSE2-NEXT:    pxor %xmm1, %xmm0
; SSE2-NEXT:    movdqa %xmm0, %xmm4
; SSE2-NEXT:    pcmpgtd %xmm3, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm3, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE2-NEXT:    pand %xmm5, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm4[1,1,3,3]
; SSE2-NEXT:    por %xmm0, %xmm3
; SSE2-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE2-NEXT:    pxor %xmm3, %xmm0
; SSE2-NEXT:    pandn %xmm1, %xmm3
; SSE2-NEXT:    pandn %xmm2, %xmm0
; SSE2-NEXT:    por %xmm3, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_le_v2i64c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551609,7]
; SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [18446744073709551615,1]
; SSE41-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE41-NEXT:    movdqa %xmm0, %xmm3
; SSE41-NEXT:    pxor %xmm1, %xmm3
; SSE41-NEXT:    pxor %xmm2, %xmm0
; SSE41-NEXT:    movdqa %xmm0, %xmm4
; SSE41-NEXT:    pcmpgtd %xmm3, %xmm4
; SSE41-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm3, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE41-NEXT:    pand %xmm5, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm4[1,1,3,3]
; SSE41-NEXT:    por %xmm0, %xmm3
; SSE41-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE41-NEXT:    pxor %xmm3, %xmm0
; SSE41-NEXT:    blendvpd %xmm2, %xmm1
; SSE41-NEXT:    movapd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_le_v2i64c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551609,7]
; SSE42-NEXT:    movdqa {{.*#+}} xmm1 = [18446744073709551615,1]
; SSE42-NEXT:    movdqa %xmm2, %xmm3
; SSE42-NEXT:    pcmpgtq %xmm1, %xmm3
; SSE42-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE42-NEXT:    pxor %xmm3, %xmm0
; SSE42-NEXT:    blendvpd %xmm2, %xmm1
; SSE42-NEXT:    movapd %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: min_le_v2i64c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovdqa {{.*#+}} xmm0 = [18446744073709551609,7]
; AVX-NEXT:    vmovdqa {{.*#+}} xmm1 = [18446744073709551615,1]
; AVX-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm2
; AVX-NEXT:    vpcmpeqd %xmm3, %xmm3, %xmm3
; AVX-NEXT:    vpxor %xmm3, %xmm2, %xmm2
; AVX-NEXT:    vblendvpd %xmm2, %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = insertelement <2 x i64> <i64 -7, i64 7>, i64 -7, i32 0
  %2 = insertelement <2 x i64> <i64 -1, i64 1>, i64 -1, i32 0
  %3 = icmp sle <2 x i64> %1, %2
  %4 = select <2 x i1> %3, <2 x i64> %1, <2 x i64> %2
  ret <2 x i64> %4
}

define <4 x i64> @min_le_v4i64c() {
; SSE2-LABEL: min_le_v4i64c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm10 = [18446744073709551609,18446744073709551615]
; SSE2-NEXT:    movdqa {{.*#+}} xmm8 = [1,7]
; SSE2-NEXT:    movdqa {{.*#+}} xmm5 = [18446744073709551615,18446744073709551609]
; SSE2-NEXT:    movdqa {{.*#+}} xmm9 = [7,1]
; SSE2-NEXT:    movdqa {{.*#+}} xmm7 = [2147483648,0,2147483648,0]
; SSE2-NEXT:    movdqa %xmm7, %xmm0
; SSE2-NEXT:    pxor %xmm9, %xmm0
; SSE2-NEXT:    movdqa %xmm7, %xmm1
; SSE2-NEXT:    pxor %xmm8, %xmm1
; SSE2-NEXT:    movdqa %xmm1, %xmm6
; SSE2-NEXT:    pcmpgtd %xmm0, %xmm6
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm6[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,3,3]
; SSE2-NEXT:    pand %xmm2, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm6 = xmm6[1,1,3,3]
; SSE2-NEXT:    por %xmm0, %xmm6
; SSE2-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE2-NEXT:    movdqa %xmm6, %xmm1
; SSE2-NEXT:    pxor %xmm0, %xmm1
; SSE2-NEXT:    movdqa %xmm7, %xmm2
; SSE2-NEXT:    pxor %xmm5, %xmm2
; SSE2-NEXT:    pxor %xmm10, %xmm7
; SSE2-NEXT:    movdqa %xmm7, %xmm3
; SSE2-NEXT:    pcmpgtd %xmm2, %xmm3
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm3[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm2, %xmm7
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm7[1,1,3,3]
; SSE2-NEXT:    pand %xmm4, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[1,1,3,3]
; SSE2-NEXT:    por %xmm2, %xmm3
; SSE2-NEXT:    pxor %xmm3, %xmm0
; SSE2-NEXT:    pandn %xmm10, %xmm3
; SSE2-NEXT:    pandn %xmm5, %xmm0
; SSE2-NEXT:    por %xmm3, %xmm0
; SSE2-NEXT:    pandn %xmm8, %xmm6
; SSE2-NEXT:    pandn %xmm9, %xmm1
; SSE2-NEXT:    por %xmm6, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_le_v4i64c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movdqa {{.*#+}} xmm9 = [18446744073709551609,18446744073709551615]
; SSE41-NEXT:    movdqa {{.*#+}} xmm8 = [1,7]
; SSE41-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551615,18446744073709551609]
; SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [7,1]
; SSE41-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,0,2147483648,0]
; SSE41-NEXT:    movdqa %xmm0, %xmm3
; SSE41-NEXT:    pxor %xmm1, %xmm3
; SSE41-NEXT:    movdqa %xmm0, %xmm6
; SSE41-NEXT:    pxor %xmm8, %xmm6
; SSE41-NEXT:    movdqa %xmm6, %xmm7
; SSE41-NEXT:    pcmpgtd %xmm3, %xmm7
; SSE41-NEXT:    pshufd {{.*#+}} xmm4 = xmm7[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm3, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm6 = xmm6[1,1,3,3]
; SSE41-NEXT:    pand %xmm4, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm7[1,1,3,3]
; SSE41-NEXT:    por %xmm6, %xmm3
; SSE41-NEXT:    pcmpeqd %xmm4, %xmm4
; SSE41-NEXT:    pxor %xmm4, %xmm3
; SSE41-NEXT:    movdqa %xmm0, %xmm6
; SSE41-NEXT:    pxor %xmm2, %xmm6
; SSE41-NEXT:    pxor %xmm9, %xmm0
; SSE41-NEXT:    movdqa %xmm0, %xmm7
; SSE41-NEXT:    pcmpgtd %xmm6, %xmm7
; SSE41-NEXT:    pshufd {{.*#+}} xmm5 = xmm7[0,0,2,2]
; SSE41-NEXT:    pcmpeqd %xmm6, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm6 = xmm0[1,1,3,3]
; SSE41-NEXT:    pand %xmm5, %xmm6
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm7[1,1,3,3]
; SSE41-NEXT:    por %xmm6, %xmm0
; SSE41-NEXT:    pxor %xmm4, %xmm0
; SSE41-NEXT:    blendvpd %xmm9, %xmm2
; SSE41-NEXT:    movdqa %xmm3, %xmm0
; SSE41-NEXT:    blendvpd %xmm8, %xmm1
; SSE41-NEXT:    movapd %xmm2, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_le_v4i64c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movdqa {{.*#+}} xmm4 = [18446744073709551609,18446744073709551615]
; SSE42-NEXT:    movdqa {{.*#+}} xmm5 = [1,7]
; SSE42-NEXT:    movdqa {{.*#+}} xmm2 = [18446744073709551615,18446744073709551609]
; SSE42-NEXT:    movdqa {{.*#+}} xmm1 = [7,1]
; SSE42-NEXT:    movdqa %xmm5, %xmm3
; SSE42-NEXT:    pcmpgtq %xmm1, %xmm3
; SSE42-NEXT:    pcmpeqd %xmm6, %xmm6
; SSE42-NEXT:    pxor %xmm6, %xmm3
; SSE42-NEXT:    movdqa %xmm4, %xmm0
; SSE42-NEXT:    pcmpgtq %xmm2, %xmm0
; SSE42-NEXT:    pxor %xmm6, %xmm0
; SSE42-NEXT:    blendvpd %xmm4, %xmm2
; SSE42-NEXT:    movdqa %xmm3, %xmm0
; SSE42-NEXT:    blendvpd %xmm5, %xmm1
; SSE42-NEXT:    movapd %xmm2, %xmm0
; SSE42-NEXT:    retq
;
; AVX1-LABEL: min_le_v4i64c:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovapd {{.*#+}} ymm0 = [18446744073709551615,18446744073709551609,7,1]
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm1 = [1,7]
; AVX1-NEXT:    vpcmpgtq {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpxor %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [18446744073709551609,18446744073709551615]
; AVX1-NEXT:    vpcmpgtq {{.*}}(%rip), %xmm3, %xmm3
; AVX1-NEXT:    vpxor %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm2, %ymm1
; AVX1-NEXT:    vblendvpd %ymm1, {{.*}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: min_le_v4i64c:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm0 = [18446744073709551609,18446744073709551615,1,7]
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm1 = [18446744073709551615,18446744073709551609,7,1]
; AVX2-NEXT:    vpcmpgtq %ymm1, %ymm0, %ymm2
; AVX2-NEXT:    vpcmpeqd %ymm3, %ymm3, %ymm3
; AVX2-NEXT:    vpxor %ymm3, %ymm2, %ymm2
; AVX2-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: min_le_v4i64c:
; AVX512:       # BB#0:
; AVX512-NEXT:    vmovdqa {{.*#+}} ymm0 = [18446744073709551609,18446744073709551615,1,7]
; AVX512-NEXT:    vmovdqa {{.*#+}} ymm1 = [18446744073709551615,18446744073709551609,7,1]
; AVX512-NEXT:    vpcmpgtq %ymm1, %ymm0, %ymm2
; AVX512-NEXT:    vpcmpeqd %ymm3, %ymm3, %ymm3
; AVX512-NEXT:    vpxor %ymm3, %ymm2, %ymm2
; AVX512-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX512-NEXT:    retq
  %1 = insertelement <4 x i64> <i64 -7, i64 -1, i64 1, i64 7>, i64 -7, i32 0
  %2 = insertelement <4 x i64> <i64 -1, i64 -7, i64 7, i64 1>, i64 -1, i32 0
  %3 = icmp sle <4 x i64> %1, %2
  %4 = select <4 x i1> %3, <4 x i64> %1, <4 x i64> %2
  ret <4 x i64> %4
}

define <4 x i32> @min_le_v4i32c() {
; SSE2-LABEL: min_le_v4i32c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [4294967289,4294967295,1,7]
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [4294967295,4294967289,7,1]
; SSE2-NEXT:    movdqa %xmm1, %xmm3
; SSE2-NEXT:    pcmpgtd %xmm2, %xmm3
; SSE2-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE2-NEXT:    pxor %xmm3, %xmm0
; SSE2-NEXT:    pandn %xmm1, %xmm3
; SSE2-NEXT:    pandn %xmm2, %xmm0
; SSE2-NEXT:    por %xmm3, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_le_v4i32c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movaps {{.*#+}} xmm0 = [4294967289,4294967289,1,1]
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_le_v4i32c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movaps {{.*#+}} xmm0 = [4294967289,4294967289,1,1]
; SSE42-NEXT:    retq
;
; AVX-LABEL: min_le_v4i32c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} xmm0 = [4294967289,4294967289,1,1]
; AVX-NEXT:    retq
  %1 = insertelement <4 x i32> <i32 -7, i32 -1, i32 1, i32 7>, i32 -7, i32 0
  %2 = insertelement <4 x i32> <i32 -1, i32 -7, i32 7, i32 1>, i32 -1, i32 0
  %3 = icmp sle <4 x i32> %1, %2
  %4 = select <4 x i1> %3, <4 x i32> %1, <4 x i32> %2
  ret <4 x i32> %4
}

define <8 x i32> @min_le_v8i32c() {
; SSE2-LABEL: min_le_v8i32c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [4294967289,4294967291,4294967293,4294967295]
; SSE2-NEXT:    movdqa {{.*#+}} xmm3 = [1,3,5,7]
; SSE2-NEXT:    movdqa {{.*#+}} xmm4 = [4294967295,4294967293,4294967291,4294967289]
; SSE2-NEXT:    movdqa {{.*#+}} xmm5 = [7,5,3,1]
; SSE2-NEXT:    movdqa %xmm3, %xmm6
; SSE2-NEXT:    pcmpgtd %xmm5, %xmm6
; SSE2-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE2-NEXT:    movdqa %xmm6, %xmm1
; SSE2-NEXT:    pxor %xmm0, %xmm1
; SSE2-NEXT:    movdqa %xmm2, %xmm7
; SSE2-NEXT:    pcmpgtd %xmm4, %xmm7
; SSE2-NEXT:    pxor %xmm7, %xmm0
; SSE2-NEXT:    pandn %xmm2, %xmm7
; SSE2-NEXT:    pandn %xmm4, %xmm0
; SSE2-NEXT:    por %xmm7, %xmm0
; SSE2-NEXT:    pandn %xmm3, %xmm6
; SSE2-NEXT:    pandn %xmm5, %xmm1
; SSE2-NEXT:    por %xmm6, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_le_v8i32c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movaps {{.*#+}} xmm0 = [4294967289,4294967291,4294967291,4294967289]
; SSE41-NEXT:    movaps {{.*#+}} xmm1 = [1,3,3,1]
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_le_v8i32c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movaps {{.*#+}} xmm0 = [4294967289,4294967291,4294967291,4294967289]
; SSE42-NEXT:    movaps {{.*#+}} xmm1 = [1,3,3,1]
; SSE42-NEXT:    retq
;
; AVX-LABEL: min_le_v8i32c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} ymm0 = [4294967289,4294967291,4294967291,4294967289,1,3,3,1]
; AVX-NEXT:    retq
  %1 = insertelement <8 x i32> <i32 -7, i32 -5, i32 -3, i32 -1, i32 1, i32 3, i32 5, i32 7>, i32 -7, i32 0
  %2 = insertelement <8 x i32> <i32 -1, i32 -3, i32 -5, i32 -7, i32 7, i32 5, i32 3, i32 1>, i32 -1, i32 0
  %3 = icmp sle <8 x i32> %1, %2
  %4 = select <8 x i1> %3, <8 x i32> %1, <8 x i32> %2
  ret <8 x i32> %4
}

define <8 x i16> @min_le_v8i16c() {
; SSE-LABEL: min_le_v8i16c:
; SSE:       # BB#0:
; SSE-NEXT:    movaps {{.*#+}} xmm0 = [65529,65531,65531,65529,1,3,3,1]
; SSE-NEXT:    retq
;
; AVX-LABEL: min_le_v8i16c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} xmm0 = [65529,65531,65531,65529,1,3,3,1]
; AVX-NEXT:    retq
  %1 = insertelement <8 x i16> <i16 -7, i16 -5, i16 -3, i16 -1, i16 1, i16 3, i16 5, i16 7>, i16 -7, i32 0
  %2 = insertelement <8 x i16> <i16 -1, i16 -3, i16 -5, i16 -7, i16 7, i16 5, i16 3, i16 1>, i16 -1, i32 0
  %3 = icmp sle <8 x i16> %1, %2
  %4 = select <8 x i1> %3, <8 x i16> %1, <8 x i16> %2
  ret <8 x i16> %4
}

define <16 x i16> @min_le_v16i16c() {
; SSE-LABEL: min_le_v16i16c:
; SSE:       # BB#0:
; SSE-NEXT:    movaps {{.*#+}} xmm0 = [65529,65530,65531,65532,65531,65530,65529,0]
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [1,2,3,4,3,2,1,0]
; SSE-NEXT:    retq
;
; AVX-LABEL: min_le_v16i16c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} ymm0 = [65529,65530,65531,65532,65531,65530,65529,0,1,2,3,4,3,2,1,0]
; AVX-NEXT:    retq
  %1 = insertelement <16 x i16> <i16 -7, i16 -6, i16 -5, i16 -4, i16 -3, i16 -2, i16 -1, i16 0, i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7, i16 8>, i16 -7, i32 0
  %2 = insertelement <16 x i16> <i16 -1, i16 -2, i16 -3, i16 -4, i16 -5, i16 -6, i16 -7, i16 0, i16 7, i16 6, i16 5, i16 4, i16 3, i16 2, i16 1, i16 0>, i16 -1, i32 0
  %3 = icmp sle <16 x i16> %1, %2
  %4 = select <16 x i1> %3, <16 x i16> %1, <16 x i16> %2
  ret <16 x i16> %4
}

define <16 x i8> @min_le_v16i8c() {
; SSE2-LABEL: min_le_v16i8c:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [249,250,251,252,253,254,255,0,1,2,3,4,5,6,7,8]
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [255,254,253,252,251,250,249,0,7,6,5,4,3,2,1,0]
; SSE2-NEXT:    movdqa %xmm1, %xmm3
; SSE2-NEXT:    pcmpgtb %xmm2, %xmm3
; SSE2-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE2-NEXT:    pxor %xmm3, %xmm0
; SSE2-NEXT:    pandn %xmm1, %xmm3
; SSE2-NEXT:    pandn %xmm2, %xmm0
; SSE2-NEXT:    por %xmm3, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: min_le_v16i8c:
; SSE41:       # BB#0:
; SSE41-NEXT:    movaps {{.*#+}} xmm0 = [249,250,251,252,251,250,249,0,1,2,3,4,3,2,1,0]
; SSE41-NEXT:    retq
;
; SSE42-LABEL: min_le_v16i8c:
; SSE42:       # BB#0:
; SSE42-NEXT:    movaps {{.*#+}} xmm0 = [249,250,251,252,251,250,249,0,1,2,3,4,3,2,1,0]
; SSE42-NEXT:    retq
;
; AVX-LABEL: min_le_v16i8c:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} xmm0 = [249,250,251,252,251,250,249,0,1,2,3,4,3,2,1,0]
; AVX-NEXT:    retq
  %1 = insertelement <16 x i8> <i8 -7, i8 -6, i8 -5, i8 -4, i8 -3, i8 -2, i8 -1, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 8>, i8 -7, i32 0
  %2 = insertelement <16 x i8> <i8 -1, i8 -2, i8 -3, i8 -4, i8 -5, i8 -6, i8 -7, i8 0, i8 7, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0>, i8 -1, i32 0
  %3 = icmp sle <16 x i8> %1, %2
  %4 = select <16 x i1> %3, <16 x i8> %1, <16 x i8> %2
  ret <16 x i8> %4
}
