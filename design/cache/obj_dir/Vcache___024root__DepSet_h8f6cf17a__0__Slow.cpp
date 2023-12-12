// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcache.h for the primary calling header

#include "verilated.h"

#include "Vcache__Syms.h"
#include "Vcache___024root.h"

VL_ATTR_COLD void Vcache___024root___eval_static(Vcache___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcache__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcache___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vcache___024root___eval_initial(Vcache___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcache__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcache___024root___eval_initial\n"); );
    // Body
    vlSelf->__Vtrigprevexpr___TOP__RST__0 = vlSelf->RST;
    vlSelf->__Vtrigprevexpr___TOP__CLK__0 = vlSelf->CLK;
}

VL_ATTR_COLD void Vcache___024root___eval_final(Vcache___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcache__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcache___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vcache___024root___eval_settle(Vcache___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcache__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcache___024root___eval_settle\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcache___024root___dump_triggers__act(Vcache___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcache__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcache___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge RST)\n");
    }
    if ((2ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @(posedge CLK)\n");
    }
    if ((4ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 2 is active: @(negedge CLK)\n");
    }
    if ((8ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 3 is active: @(posedge CLK or posedge RST)\n");
    }
    if ((0x10ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 4 is active: @(edge CLK)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcache___024root___dump_triggers__nba(Vcache___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcache__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcache___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge RST)\n");
    }
    if ((2ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @(posedge CLK)\n");
    }
    if ((4ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 2 is active: @(negedge CLK)\n");
    }
    if ((8ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 3 is active: @(posedge CLK or posedge RST)\n");
    }
    if ((0x10ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 4 is active: @(edge CLK)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vcache___024root___ctor_var_reset(Vcache___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcache__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcache___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->CLK = VL_RAND_RESET_I(1);
    vlSelf->RST = VL_RAND_RESET_I(1);
    vlSelf->WE0 = VL_RAND_RESET_I(1);
    vlSelf->WE1 = VL_RAND_RESET_I(1);
    vlSelf->WE2 = VL_RAND_RESET_I(1);
    vlSelf->WE3 = VL_RAND_RESET_I(1);
    vlSelf->MemRead = VL_RAND_RESET_I(1);
    vlSelf->MemWrite = VL_RAND_RESET_I(1);
    vlSelf->A = VL_RAND_RESET_I(32);
    vlSelf->WD = VL_RAND_RESET_I(32);
    vlSelf->hit = VL_RAND_RESET_I(1);
    vlSelf->WECache = VL_RAND_RESET_I(1);
    vlSelf->WE0Cache = VL_RAND_RESET_I(1);
    vlSelf->WE1Cache = VL_RAND_RESET_I(1);
    vlSelf->WE2Cache = VL_RAND_RESET_I(1);
    vlSelf->WE3Cache = VL_RAND_RESET_I(1);
    vlSelf->ACache = VL_RAND_RESET_I(32);
    vlSelf->WDCache = VL_RAND_RESET_I(32);
    vlSelf->RD = VL_RAND_RESET_I(32);
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        VL_RAND_RESET_W(124, vlSelf->cache__DOT__cache_array[__Vi0]);
    }
    vlSelf->cache__DOT__V0 = VL_RAND_RESET_I(1);
    vlSelf->__Vdlyvdim0__cache__DOT__cache_array__v0 = 0;
    VL_RAND_RESET_W(124, vlSelf->__Vdlyvval__cache__DOT__cache_array__v0);
    vlSelf->__Vdlyvset__cache__DOT__cache_array__v0 = 0;
    vlSelf->__Vdlyvdim0__cache__DOT__cache_array__v1 = 0;
    VL_RAND_RESET_W(124, vlSelf->__Vdlyvval__cache__DOT__cache_array__v1);
    vlSelf->__Vdlyvset__cache__DOT__cache_array__v1 = 0;
    vlSelf->__Vdlyvdim0__cache__DOT__cache_array__v2 = 0;
    VL_RAND_RESET_W(124, vlSelf->__Vdlyvval__cache__DOT__cache_array__v2);
    vlSelf->__Vdlyvset__cache__DOT__cache_array__v2 = 0;
    vlSelf->__Vtrigprevexpr___TOP__RST__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__CLK__0 = VL_RAND_RESET_I(1);
}
