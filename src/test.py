import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def dummy_test(dut):

    dut._log.info("Start")
    clock_in = Clock(dut.clk, 1, units="us")
    cocotb.start_soon(clock_in.start())
    clock_ext = Clock(dut.clk_external, 1, units="ms")
    cocotb.start_soon(clock_ext.start())
    # Initialize sim
    dut._log.info("Initialize")
    dut.rst_n.value = 0
    dut.clk_sel.value = 1
    dut.osc_sel.value = 0
    dut.en_inv_osc.value = 0
    dut.en_nand_osc.value = 0
    dut.rx.value = 1
    await Timer(100000, units='ns')
    dut.en_inv_osc.value = 1
    await Timer(15000, units='ns')
    dut.rst_n.value = 1
    await Timer(52083, units='ns')
    await Timer(1000000, units='ns')
    #Begin UART transmission
    dut._log.info("Begin UART transmission")
    dut.rx.value = 0 #Start bit
    await Timer(1000000, units='ns')
    dut.rx.value = 0 #Bit 1
    await Timer(1000000, units='ns')
    dut.rx.value = 0 #Bit 2
    await Timer(1000000, units='ns')
    dut.rx.value = 0 #Bit 3
    await Timer(1000000, units='ns')
    dut.rx.value = 0 #Bit 4
    await Timer(1000000, units='ns')
    dut.rx.value = 0 #Bit 5
    await Timer(1000000, units='ns')
    dut.rx.value = 0 #Bit 6
    await Timer(1000000, units='ns')
    dut.rx.value = 0 #Bit 7
    await Timer(1000000, units='ns')
    dut.rx.value = 0 #Bit 8
    await Timer(1000000, units='ns')
    dut.rx.value = 0 #End bit
    dut._log.info("Finish transmission")
    await Timer(1000000, units='ns')