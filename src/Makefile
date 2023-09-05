# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

# normal simulation
ifneq ($(GATES),yes)

# this is the only part you should need to modify:
VERILOG_SOURCES += $(PWD)/tb.v $(PWD)/tt_um_USM_temp_sens_hyst.v $(PWD)/mux.v $(PWD)/contador.v $(PWD)/data_sync.v $(PWD)/FSM_Controller.v
VERILOG_SOURCES += $(PWD)/uart_baud_tick_gen.v $(PWD)/uart_rx.v $(PWD)/FSM_Hysteresis.v $(PWD)/FSM_SendData.v $(PWD)/uart_basic.v
VERILOG_SOURCES += $(PWD)/uart_tx.v $(PWD)/USM_ringoscillator.v
VERILOG_SOURCES += $(PWD)/promedio.v
VERILOG_SOURCES += $(PWD)/sky130_fd_sc_hd.v $(PWD)/primitives.v

else

# gate level simulation requires some extra setup, you shouldn't need to touch this
COMPILE_ARGS    += -DGL_TEST
COMPILE_ARGS    += -DFUNCTIONAL
COMPILE_ARGS    += -DUSE_POWER_PINS
COMPILE_ARGS    += -DSIM
COMPILE_ARGS    += -DUNIT_DELAY=\#1
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PWD)/gl/sky130_fd_sc_hd__inv_override.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v


# this gets copied in by the GDS action workflow
VERILOG_SOURCES += $(PWD)/tb.v $(PWD)/gate_level_netlist.v
endif

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = tb

# MODULE is the basename of the Python test file
MODULE = test

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
