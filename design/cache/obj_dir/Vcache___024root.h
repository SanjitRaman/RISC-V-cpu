// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vcache.h for the primary calling header

#ifndef VERILATED_VCACHE___024ROOT_H_
#define VERILATED_VCACHE___024ROOT_H_  // guard

#include "verilated.h"


class Vcache__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vcache___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(CLK,0,0);
    VL_IN8(RST,0,0);
    VL_IN8(WE0,0,0);
    VL_IN8(WE1,0,0);
    VL_IN8(WE2,0,0);
    VL_IN8(WE3,0,0);
    VL_IN8(MemRead,0,0);
    VL_IN8(MemWrite,0,0);
    VL_OUT8(hit,0,0);
    VL_OUT8(WECache,0,0);
    VL_OUT8(WE0Cache,0,0);
    VL_OUT8(WE1Cache,0,0);
    VL_OUT8(WE2Cache,0,0);
    VL_OUT8(WE3Cache,0,0);
    CData/*0:0*/ cache__DOT__V0;
    CData/*0:0*/ cache__DOT__D1;
    CData/*1:0*/ __Vdlyvdim0__cache__DOT__cache_array__v0;
    CData/*0:0*/ __Vdlyvset__cache__DOT__cache_array__v0;
    CData/*1:0*/ __Vdlyvdim0__cache__DOT__cache_array__v1;
    CData/*0:0*/ __Vdlyvset__cache__DOT__cache_array__v1;
    CData/*1:0*/ __Vdlyvdim0__cache__DOT__cache_array__v2;
    CData/*0:0*/ __Vdlyvset__cache__DOT__cache_array__v2;
    CData/*0:0*/ __Vtrigprevexpr___TOP__RST__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__CLK__0;
    CData/*0:0*/ __VactContinue;
    VL_IN(A,31,0);
    VL_IN(WD,31,0);
    VL_OUT(ACache,31,0);
    VL_OUT(WDCache,31,0);
    VL_OUT(RD,31,0);
    VlWide<4>/*123:0*/ __Vdlyvval__cache__DOT__cache_array__v0;
    VlWide<4>/*123:0*/ __Vdlyvval__cache__DOT__cache_array__v1;
    VlWide<4>/*123:0*/ __Vdlyvval__cache__DOT__cache_array__v2;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<VlWide<4>/*123:0*/, 4> cache__DOT__cache_array;
    VlTriggerVec<5> __VactTriggered;
    VlTriggerVec<5> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vcache__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vcache___024root(Vcache__Syms* symsp, const char* v__name);
    ~Vcache___024root();
    VL_UNCOPYABLE(Vcache___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
