// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vcache.h"
#include "Vcache__Syms.h"

//============================================================
// Constructors

Vcache::Vcache(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vcache__Syms(contextp(), _vcname__, this)}
    , CLK{vlSymsp->TOP.CLK}
    , RST{vlSymsp->TOP.RST}
    , WE0{vlSymsp->TOP.WE0}
    , WE1{vlSymsp->TOP.WE1}
    , WE2{vlSymsp->TOP.WE2}
    , WE3{vlSymsp->TOP.WE3}
    , MemRead{vlSymsp->TOP.MemRead}
    , MemWrite{vlSymsp->TOP.MemWrite}
    , hit{vlSymsp->TOP.hit}
    , WECache{vlSymsp->TOP.WECache}
    , WE0Cache{vlSymsp->TOP.WE0Cache}
    , WE1Cache{vlSymsp->TOP.WE1Cache}
    , WE2Cache{vlSymsp->TOP.WE2Cache}
    , WE3Cache{vlSymsp->TOP.WE3Cache}
    , A{vlSymsp->TOP.A}
    , WD{vlSymsp->TOP.WD}
    , ACache{vlSymsp->TOP.ACache}
    , WDCache{vlSymsp->TOP.WDCache}
    , RD{vlSymsp->TOP.RD}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vcache::Vcache(const char* _vcname__)
    : Vcache(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vcache::~Vcache() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vcache___024root___eval_debug_assertions(Vcache___024root* vlSelf);
#endif  // VL_DEBUG
void Vcache___024root___eval_static(Vcache___024root* vlSelf);
void Vcache___024root___eval_initial(Vcache___024root* vlSelf);
void Vcache___024root___eval_settle(Vcache___024root* vlSelf);
void Vcache___024root___eval(Vcache___024root* vlSelf);

void Vcache::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vcache::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vcache___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vcache___024root___eval_static(&(vlSymsp->TOP));
        Vcache___024root___eval_initial(&(vlSymsp->TOP));
        Vcache___024root___eval_settle(&(vlSymsp->TOP));
    }
    // MTask 0 start
    VL_DEBUG_IF(VL_DBG_MSGF("MTask0 starting\n"););
    Verilated::mtaskId(0);
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vcache___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfThreadMTask(vlSymsp->__Vm_evalMsgQp);
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vcache::eventsPending() { return false; }

uint64_t Vcache::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vcache::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vcache___024root___eval_final(Vcache___024root* vlSelf);

VL_ATTR_COLD void Vcache::final() {
    Vcache___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vcache::hierName() const { return vlSymsp->name(); }
const char* Vcache::modelName() const { return "Vcache"; }
unsigned Vcache::threads() const { return 1; }
void Vcache::prepareClone() const { contextp()->prepareClone(); }
void Vcache::atClone() const {
    contextp()->threadPoolpOnClone();
}
