// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VCACHE__SYMS_H_
#define VERILATED_VCACHE__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vcache.h"

// INCLUDE MODULE CLASSES
#include "Vcache___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES)Vcache__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vcache* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vcache___024root               TOP;

    // CONSTRUCTORS
    Vcache__Syms(VerilatedContext* contextp, const char* namep, Vcache* modelp);
    ~Vcache__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
};

#endif  // guard
