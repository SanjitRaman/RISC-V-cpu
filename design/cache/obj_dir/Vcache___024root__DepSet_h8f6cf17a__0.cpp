// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcache.h for the primary calling header

#include "verilated.h"

#include "Vcache__Syms.h"
#include "Vcache___024root.h"

void Vcache___024root___eval_act(Vcache___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcache__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcache___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vcache___024root___nba_sequent__TOP__0(Vcache___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcache__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcache___024root___nba_sequent__TOP__0\n"); );
    // Body
    vlSelf->__Vdlyvset__cache__DOT__cache_array__v2 = 0U;
    vlSelf->__Vdlyvset__cache__DOT__cache_array__v0 = 0U;
    vlSelf->__Vdlyvset__cache__DOT__cache_array__v1 = 0U;
}

VL_INLINE_OPT void Vcache___024root___nba_sequent__TOP__1(Vcache___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcache__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcache___024root___nba_sequent__TOP__1\n"); );
    // Body
    vlSelf->WE3Cache = 0U;
    vlSelf->WE2Cache = 0U;
    vlSelf->WE1Cache = 0U;
    vlSelf->WE0Cache = 0U;
}

VL_INLINE_OPT void Vcache___024root___nba_sequent__TOP__3(Vcache___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcache__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcache___024root___nba_sequent__TOP__3\n"); );
    // Body
    if (vlSelf->MemRead) {
        vlSelf->__Vdlyvval__cache__DOT__cache_array__v2[0U] 
            = (IData)((0x1000000000000000ULL | (((QData)((IData)(
                                                                 (vlSelf->A 
                                                                  >> 4U))) 
                                                 << 0x20U) 
                                                | (QData)((IData)(
                                                                  ((0xff000000U 
                                                                    & (((- (IData)((IData)(vlSelf->WE3))) 
                                                                        << 0x18U) 
                                                                       & vlSelf->WD)) 
                                                                   | ((0xff0000U 
                                                                       & (((- (IData)((IData)(vlSelf->WE2))) 
                                                                           << 0x10U) 
                                                                          & vlSelf->WD)) 
                                                                      | ((0xff00U 
                                                                          & (((- (IData)((IData)(vlSelf->WE1))) 
                                                                              << 8U) 
                                                                             & vlSelf->WD)) 
                                                                         | (0xffU 
                                                                            & ((- (IData)((IData)(vlSelf->WE0))) 
                                                                               & vlSelf->WD))))))))));
        vlSelf->__Vdlyvval__cache__DOT__cache_array__v2[1U] 
            = (IData)(((0x1000000000000000ULL | (((QData)((IData)(
                                                                  (vlSelf->A 
                                                                   >> 4U))) 
                                                  << 0x20U) 
                                                 | (QData)((IData)(
                                                                   ((0xff000000U 
                                                                     & (((- (IData)((IData)(vlSelf->WE3))) 
                                                                         << 0x18U) 
                                                                        & vlSelf->WD)) 
                                                                    | ((0xff0000U 
                                                                        & (((- (IData)((IData)(vlSelf->WE2))) 
                                                                            << 0x10U) 
                                                                           & vlSelf->WD)) 
                                                                       | ((0xff00U 
                                                                           & (((- (IData)((IData)(vlSelf->WE1))) 
                                                                               << 8U) 
                                                                              & vlSelf->WD)) 
                                                                          | (0xffU 
                                                                             & ((- (IData)((IData)(vlSelf->WE0))) 
                                                                                & vlSelf->WD))))))))) 
                       >> 0x20U));
        vlSelf->__Vdlyvval__cache__DOT__cache_array__v2[2U] = 0U;
        vlSelf->__Vdlyvval__cache__DOT__cache_array__v2[3U] = 0U;
        vlSelf->__Vdlyvset__cache__DOT__cache_array__v2 = 1U;
        vlSelf->__Vdlyvdim0__cache__DOT__cache_array__v2 
            = (3U & (vlSelf->A >> 2U));
    }
}

VL_INLINE_OPT void Vcache___024root___nba_sequent__TOP__4(Vcache___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcache__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcache___024root___nba_sequent__TOP__4\n"); );
    // Body
    vlSelf->RD = 0U;
    vlSelf->WDCache = 0U;
    vlSelf->ACache = 0U;
    vlSelf->WECache = 0U;
    vlSelf->hit = 0U;
}

VL_INLINE_OPT void Vcache___024root___nba_sequent__TOP__5(Vcache___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcache__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcache___024root___nba_sequent__TOP__5\n"); );
    // Init
    IData/*27:0*/ cache__DOT__tag0;
    cache__DOT__tag0 = 0;
    IData/*27:0*/ cache__DOT__tag1;
    cache__DOT__tag1 = 0;
    VlWide<4>/*127:0*/ __Vtemp_6;
    VlWide<4>/*127:0*/ __Vtemp_11;
    VlWide<4>/*127:0*/ __Vtemp_12;
    // Body
    cache__DOT__tag0 = (0xfffffffU & ((vlSelf->cache__DOT__cache_array
                                       [(3U & (vlSelf->A 
                                               >> 2U))][3U] 
                                       << 2U) | (vlSelf->cache__DOT__cache_array
                                                 [(3U 
                                                   & (vlSelf->A 
                                                      >> 2U))][2U] 
                                                 >> 0x1eU)));
    cache__DOT__tag1 = (0xfffffffU & vlSelf->cache__DOT__cache_array
                        [(3U & (vlSelf->A >> 2U))][1U]);
    if (vlSelf->MemWrite) {
        vlSelf->cache__DOT__V0 = (1U & (vlSelf->cache__DOT__cache_array
                                        [(3U & (vlSelf->A 
                                                >> 2U))][3U] 
                                        >> 0x1aU));
        vlSelf->cache__DOT__D1 = (1U & (vlSelf->cache__DOT__cache_array
                                        [(3U & (vlSelf->A 
                                                >> 2U))][1U] 
                                        >> 0x1dU));
        if (vlSelf->cache__DOT__V0) {
            vlSelf->WDCache = vlSelf->cache__DOT__cache_array
                [(3U & (vlSelf->A >> 2U))][0U];
            vlSelf->WECache = vlSelf->cache__DOT__D1;
            __Vtemp_6[0U] = vlSelf->cache__DOT__cache_array
                [(3U & (vlSelf->A >> 2U))][0U];
            __Vtemp_6[1U] = vlSelf->cache__DOT__cache_array
                [(3U & (vlSelf->A >> 2U))][1U];
            __Vtemp_6[2U] = vlSelf->cache__DOT__cache_array
                [(3U & (vlSelf->A >> 2U))][2U];
            __Vtemp_6[3U] = vlSelf->cache__DOT__cache_array
                [(3U & (vlSelf->A >> 2U))][3U];
            vlSelf->ACache = ((((0x7bU >= (0x7fU & cache__DOT__tag1)) 
                                & (__Vtemp_6[(3U & 
                                              (cache__DOT__tag1 
                                               >> 5U))] 
                                   >> (0x1fU & cache__DOT__tag1))) 
                               << 4U) | (0xcU & vlSelf->A));
            __Vtemp_11[0U] = vlSelf->cache__DOT__cache_array
                [(3U & (vlSelf->A >> 2U))][0U];
            __Vtemp_11[1U] = vlSelf->cache__DOT__cache_array
                [(3U & (vlSelf->A >> 2U))][1U];
            __Vtemp_11[2U] = vlSelf->cache__DOT__cache_array
                [(3U & (vlSelf->A >> 2U))][2U];
            __Vtemp_11[3U] = vlSelf->cache__DOT__cache_array
                [(3U & (vlSelf->A >> 2U))][3U];
            VL_SHIFTR_WWI(124,124,32, __Vtemp_12, __Vtemp_11, 0x3eU);
            vlSelf->__Vdlyvval__cache__DOT__cache_array__v0[0U] 
                = __Vtemp_12[0U];
            vlSelf->__Vdlyvval__cache__DOT__cache_array__v0[1U] 
                = ((((- (IData)((IData)(vlSelf->WE0))) 
                     & vlSelf->WD) << 0x1eU) | __Vtemp_12[1U]);
            vlSelf->__Vdlyvval__cache__DOT__cache_array__v0[2U] 
                = (((0xc0000000U & (vlSelf->A << 0x1aU)) 
                    | (0x3fffffffU & ((0x3fc00000U 
                                       & (((- (IData)((IData)(vlSelf->WE3))) 
                                           << 0x16U) 
                                          & (vlSelf->WD 
                                             >> 2U))) 
                                      | ((0x3fc000U 
                                          & (((- (IData)((IData)(vlSelf->WE2))) 
                                              << 0xeU) 
                                             & (vlSelf->WD 
                                                >> 2U))) 
                                         | ((0x3fc0U 
                                             & (((- (IData)((IData)(vlSelf->WE1))) 
                                                 << 6U) 
                                                & (vlSelf->WD 
                                                   >> 2U))) 
                                            | (0x3fU 
                                               & (((- (IData)((IData)(vlSelf->WE0))) 
                                                   & vlSelf->WD) 
                                                  >> 2U))))))) 
                   | __Vtemp_12[2U]);
            vlSelf->__Vdlyvval__cache__DOT__cache_array__v0[3U] 
                = (0xfffffffU & (0xc000000U | ((0x3fffffffU 
                                                & (vlSelf->A 
                                                   >> 6U)) 
                                               | __Vtemp_12[3U])));
            vlSelf->__Vdlyvset__cache__DOT__cache_array__v0 = 1U;
            vlSelf->__Vdlyvdim0__cache__DOT__cache_array__v0 
                = (3U & (vlSelf->A >> 2U));
        } else {
            vlSelf->__Vdlyvval__cache__DOT__cache_array__v1[0U] = 0U;
            vlSelf->__Vdlyvval__cache__DOT__cache_array__v1[1U] 
                = (((- (IData)((IData)(vlSelf->WE0))) 
                    & vlSelf->WD) << 0x1eU);
            vlSelf->__Vdlyvval__cache__DOT__cache_array__v1[2U] 
                = ((0xc0000000U & (vlSelf->A << 0x1aU)) 
                   | (0x3fffffffU & ((0x3fc00000U & 
                                      (((- (IData)((IData)(vlSelf->WE3))) 
                                        << 0x16U) & 
                                       (vlSelf->WD 
                                        >> 2U))) | 
                                     ((0x3fc000U & 
                                       (((- (IData)((IData)(vlSelf->WE2))) 
                                         << 0xeU) & 
                                        (vlSelf->WD 
                                         >> 2U))) | 
                                      ((0x3fc0U & (
                                                   ((- (IData)((IData)(vlSelf->WE1))) 
                                                    << 6U) 
                                                   & (vlSelf->WD 
                                                      >> 2U))) 
                                       | (0x3fU & (
                                                   ((- (IData)((IData)(vlSelf->WE0))) 
                                                    & vlSelf->WD) 
                                                   >> 2U)))))));
            vlSelf->__Vdlyvval__cache__DOT__cache_array__v1[3U] 
                = (0xc000000U | (0x3fffffffU & (vlSelf->A 
                                                >> 6U)));
            vlSelf->__Vdlyvset__cache__DOT__cache_array__v1 = 1U;
            vlSelf->__Vdlyvdim0__cache__DOT__cache_array__v1 
                = (3U & (vlSelf->A >> 2U));
            vlSelf->WECache = 0U;
        }
    }
    if (vlSelf->MemRead) {
        vlSelf->RD = vlSelf->cache__DOT__cache_array
            [(3U & (vlSelf->A >> 2U))][0U];
        vlSelf->hit = ((vlSelf->cache__DOT__cache_array
                        [(3U & (vlSelf->A >> 2U))][3U] 
                        >> 0x1bU) & ((vlSelf->A >> 4U) 
                                     == cache__DOT__tag0));
    }
}

VL_INLINE_OPT void Vcache___024root___nba_sequent__TOP__7(Vcache___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcache__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcache___024root___nba_sequent__TOP__7\n"); );
    // Body
    if (vlSelf->__Vdlyvset__cache__DOT__cache_array__v0) {
        vlSelf->cache__DOT__cache_array[vlSelf->__Vdlyvdim0__cache__DOT__cache_array__v0][0U] 
            = vlSelf->__Vdlyvval__cache__DOT__cache_array__v0[0U];
        vlSelf->cache__DOT__cache_array[vlSelf->__Vdlyvdim0__cache__DOT__cache_array__v0][1U] 
            = vlSelf->__Vdlyvval__cache__DOT__cache_array__v0[1U];
        vlSelf->cache__DOT__cache_array[vlSelf->__Vdlyvdim0__cache__DOT__cache_array__v0][2U] 
            = vlSelf->__Vdlyvval__cache__DOT__cache_array__v0[2U];
        vlSelf->cache__DOT__cache_array[vlSelf->__Vdlyvdim0__cache__DOT__cache_array__v0][3U] 
            = vlSelf->__Vdlyvval__cache__DOT__cache_array__v0[3U];
    }
    if (vlSelf->__Vdlyvset__cache__DOT__cache_array__v1) {
        vlSelf->cache__DOT__cache_array[vlSelf->__Vdlyvdim0__cache__DOT__cache_array__v1][0U] 
            = vlSelf->__Vdlyvval__cache__DOT__cache_array__v1[0U];
        vlSelf->cache__DOT__cache_array[vlSelf->__Vdlyvdim0__cache__DOT__cache_array__v1][1U] 
            = vlSelf->__Vdlyvval__cache__DOT__cache_array__v1[1U];
        vlSelf->cache__DOT__cache_array[vlSelf->__Vdlyvdim0__cache__DOT__cache_array__v1][2U] 
            = vlSelf->__Vdlyvval__cache__DOT__cache_array__v1[2U];
        vlSelf->cache__DOT__cache_array[vlSelf->__Vdlyvdim0__cache__DOT__cache_array__v1][3U] 
            = vlSelf->__Vdlyvval__cache__DOT__cache_array__v1[3U];
    }
    if (vlSelf->__Vdlyvset__cache__DOT__cache_array__v2) {
        vlSelf->cache__DOT__cache_array[vlSelf->__Vdlyvdim0__cache__DOT__cache_array__v2][0U] 
            = vlSelf->__Vdlyvval__cache__DOT__cache_array__v2[0U];
        vlSelf->cache__DOT__cache_array[vlSelf->__Vdlyvdim0__cache__DOT__cache_array__v2][1U] 
            = vlSelf->__Vdlyvval__cache__DOT__cache_array__v2[1U];
        vlSelf->cache__DOT__cache_array[vlSelf->__Vdlyvdim0__cache__DOT__cache_array__v2][2U] 
            = vlSelf->__Vdlyvval__cache__DOT__cache_array__v2[2U];
        vlSelf->cache__DOT__cache_array[vlSelf->__Vdlyvdim0__cache__DOT__cache_array__v2][3U] 
            = vlSelf->__Vdlyvval__cache__DOT__cache_array__v2[3U];
    }
}

void Vcache___024root___eval_nba(Vcache___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcache__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcache___024root___eval_nba\n"); );
    // Body
    if ((0x10ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vcache___024root___nba_sequent__TOP__0(vlSelf);
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vcache___024root___nba_sequent__TOP__1(vlSelf);
    }
    if ((4ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vcache___024root___nba_sequent__TOP__3(vlSelf);
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vcache___024root___nba_sequent__TOP__4(vlSelf);
    }
    if ((2ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vcache___024root___nba_sequent__TOP__5(vlSelf);
    }
    if ((0x10ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vcache___024root___nba_sequent__TOP__7(vlSelf);
    }
}

void Vcache___024root___eval_triggers__act(Vcache___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vcache___024root___dump_triggers__act(Vcache___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vcache___024root___dump_triggers__nba(Vcache___024root* vlSelf);
#endif  // VL_DEBUG

void Vcache___024root___eval(Vcache___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcache__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcache___024root___eval\n"); );
    // Init
    VlTriggerVec<5> __VpreTriggered;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        __VnbaContinue = 0U;
        vlSelf->__VnbaTriggered.clear();
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            vlSelf->__VactContinue = 0U;
            Vcache___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    Vcache___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("cache.sv", 1, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
                Vcache___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                Vcache___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("cache.sv", 1, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vcache___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vcache___024root___eval_debug_assertions(Vcache___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcache__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcache___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->CLK & 0xfeU))) {
        Verilated::overWidthError("CLK");}
    if (VL_UNLIKELY((vlSelf->RST & 0xfeU))) {
        Verilated::overWidthError("RST");}
    if (VL_UNLIKELY((vlSelf->WE0 & 0xfeU))) {
        Verilated::overWidthError("WE0");}
    if (VL_UNLIKELY((vlSelf->WE1 & 0xfeU))) {
        Verilated::overWidthError("WE1");}
    if (VL_UNLIKELY((vlSelf->WE2 & 0xfeU))) {
        Verilated::overWidthError("WE2");}
    if (VL_UNLIKELY((vlSelf->WE3 & 0xfeU))) {
        Verilated::overWidthError("WE3");}
    if (VL_UNLIKELY((vlSelf->MemRead & 0xfeU))) {
        Verilated::overWidthError("MemRead");}
    if (VL_UNLIKELY((vlSelf->MemWrite & 0xfeU))) {
        Verilated::overWidthError("MemWrite");}
}
#endif  // VL_DEBUG
