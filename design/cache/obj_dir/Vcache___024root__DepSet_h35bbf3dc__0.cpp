// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcache.h for the primary calling header

#include "verilated.h"

#include "Vcache__Syms.h"
#include "Vcache__Syms.h"
#include "Vcache___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcache___024root___dump_triggers__act(Vcache___024root* vlSelf);
#endif  // VL_DEBUG

void Vcache___024root___eval_triggers__act(Vcache___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcache__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcache___024root___eval_triggers__act\n"); );
    // Body
    vlSelf->__VactTriggered.set(0U, ((IData)(vlSelf->RST) 
                                     & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__RST__0))));
    vlSelf->__VactTriggered.set(1U, ((IData)(vlSelf->CLK) 
                                     & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__CLK__0))));
    vlSelf->__VactTriggered.set(2U, ((~ (IData)(vlSelf->CLK)) 
                                     & (IData)(vlSelf->__Vtrigprevexpr___TOP__CLK__0)));
    vlSelf->__VactTriggered.set(3U, (((IData)(vlSelf->CLK) 
                                      & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__CLK__0))) 
                                     | ((IData)(vlSelf->RST) 
                                        & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__RST__0)))));
    vlSelf->__VactTriggered.set(4U, ((IData)(vlSelf->CLK) 
                                     ^ (IData)(vlSelf->__Vtrigprevexpr___TOP__CLK__0)));
    vlSelf->__Vtrigprevexpr___TOP__RST__0 = vlSelf->RST;
    vlSelf->__Vtrigprevexpr___TOP__CLK__0 = vlSelf->CLK;
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vcache___024root___dump_triggers__act(vlSelf);
    }
#endif
}
