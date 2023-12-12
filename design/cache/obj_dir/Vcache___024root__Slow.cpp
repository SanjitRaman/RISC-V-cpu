// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcache.h for the primary calling header

#include "verilated.h"

#include "Vcache__Syms.h"
#include "Vcache__Syms.h"
#include "Vcache___024root.h"

void Vcache___024root___ctor_var_reset(Vcache___024root* vlSelf);

Vcache___024root::Vcache___024root(Vcache__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vcache___024root___ctor_var_reset(this);
}

void Vcache___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vcache___024root::~Vcache___024root() {
}
