// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary model header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef VERILATED_VCACHE_H_
#define VERILATED_VCACHE_H_  // guard

#include "verilated.h"

class Vcache__Syms;
class Vcache___024root;

// This class is the main interface to the Verilated model
class alignas(VL_CACHE_LINE_BYTES) Vcache VL_NOT_FINAL : public VerilatedModel {
  private:
    // Symbol table holding complete model state (owned by this class)
    Vcache__Syms* const vlSymsp;

  public:

    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    VL_IN8(&CLK,0,0);
    VL_IN8(&RST,0,0);
    VL_IN8(&WE0,0,0);
    VL_IN8(&WE1,0,0);
    VL_IN8(&WE2,0,0);
    VL_IN8(&WE3,0,0);
    VL_IN8(&MemRead,0,0);
    VL_IN8(&MemWrite,0,0);
    VL_OUT8(&hit,0,0);
    VL_OUT8(&WECache,0,0);
    VL_OUT8(&WE0Cache,0,0);
    VL_OUT8(&WE1Cache,0,0);
    VL_OUT8(&WE2Cache,0,0);
    VL_OUT8(&WE3Cache,0,0);
    VL_IN(&A,31,0);
    VL_IN(&WD,31,0);
    VL_OUT(&ACache,31,0);
    VL_OUT(&WDCache,31,0);
    VL_OUT(&RD,31,0);

    // CELLS
    // Public to allow access to /* verilator public */ items.
    // Otherwise the application code can consider these internals.

    // Root instance pointer to allow access to model internals,
    // including inlined /* verilator public_flat_* */ items.
    Vcache___024root* const rootp;

    // CONSTRUCTORS
    /// Construct the model; called by application code
    /// If contextp is null, then the model will use the default global context
    /// If name is "", then makes a wrapper with a
    /// single model invisible with respect to DPI scope names.
    explicit Vcache(VerilatedContext* contextp, const char* name = "TOP");
    explicit Vcache(const char* name = "TOP");
    /// Destroy the model; called (often implicitly) by application code
    virtual ~Vcache();
  private:
    VL_UNCOPYABLE(Vcache);  ///< Copying not allowed

  public:
    // API METHODS
    /// Evaluate the model.  Application must call when inputs change.
    void eval() { eval_step(); }
    /// Evaluate when calling multiple units/models per time step.
    void eval_step();
    /// Evaluate at end of a timestep for tracing, when using eval_step().
    /// Application must call after all eval() and before time changes.
    void eval_end_step() {}
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();
    /// Are there scheduled events to handle?
    bool eventsPending();
    /// Returns time at next time slot. Aborts if !eventsPending()
    uint64_t nextTimeSlot();
    /// Retrieve name of this model instance (as passed to constructor).
    const char* name() const;

    // Abstract methods from VerilatedModel
    const char* hierName() const override final;
    const char* modelName() const override final;
    unsigned threads() const override final;
    /// Prepare for cloning the model at the process level (e.g. fork in Linux)
    /// Release necessary resources. Called before cloning.
    void prepareClone() const;
    /// Re-init after cloning the model at the process level (e.g. fork in Linux)
    /// Re-allocate necessary resources. Called after cloning.
    void atClone() const;
};

#endif  // guard
