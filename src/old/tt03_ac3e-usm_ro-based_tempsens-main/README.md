![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/wokwi_test/badge.svg)

# Test Ring Oscillator Based Temp Sensor.

> &copy; 2023 Jorge Marin  and Daniel Arevalos, Advanced Center for Electrical and Electronic Engeneering ([AC3E](http://ac3e.usm.cl/)), Universidad Tecnica Federico Santa Maria ([USM](https://usm.cl/)), Valparaiso, Chile

This is the first iteration of the ring oscillator based temp sensor in **Tiny Tapeout 03** from **Matt Venn**.

![photo_5053272115054226319_y](https://user-images.githubusercontent.com/64666124/233799343-270f5787-9671-4128-8acd-5d360de0d02f.jpg)

## Description

The system is composed of two ring oscillator that will be tested separately, the first one is a 99 stages [inversor2](https://antmicro-skywater-pdk-docs.readthedocs.io/en/test-submodules-in-rtd/contents/libraries/sky130_fd_sc_hd/cells/inv/README.html) ring oscillator with a frecuency of 192MHz at 0 degrees and 180MHz at 200 degrees. The second one is a 33 stages [nand4](https://antmicro-skywater-pdk-docs.readthedocs.io/en/test-submodules-in-rtd/contents/libraries/sky130_fd_sc_hd/cells/nand4/README.html) ring oscillator with a frecuency of 185MHz at 0 degrees and 150MHz at 200 degrees. The number of periods within a clock cycle is counted by a counter module, then a series of count results are added to a variable and sent via uart to then perform the division and obtein an average value. Also, part of the count value (8-14 bit) is sent to the output in case the uart doesnt work.

## What is the goal of the system ?

* Have a first approach to the design of a digital sensor.
* Analyze the effects of temperature on 2 different ring oscillator designs.
* Close the loop of the digital design flow to later share the knowledge with other students.

# What is Tiny Tapeout?

TinyTapeout is an educational project that aims to make it easier and cheaper than ever to get your digital designs manufactured on a real chip!

Go to https://tinytapeout.com for instructions!

## How to change the Wokwi project

Edit the [info.yaml](info.yaml) and change the wokwi_id to match your project.

## How to enable the GitHub actions to build the ASIC files

Please see the instructions for:

* [Enabling GitHub Actions](https://tinytapeout.com/faq/#when-i-commit-my-change-the-gds-action-isnt-running)
* [Enabling GitHub Pages](https://tinytapeout.com/faq/#my-github-action-is-failing-on-the-pages-part)

## How does it work?

When you edit the info.yaml to choose a different ID, the [GitHub Action](.github/workflows/gds.yaml) will fetch the digital netlist of your design from Wokwi.

After that, the action uses the open source ASIC tool called [OpenLane](https://www.zerotoasiccourse.com/terminology/openlane/) to build the files needed to fabricate an ASIC.

## Resources

* [FAQ](https://tinytapeout.com/faq/)
* [Digital design lessons](https://tinytapeout.com/digital_design/)
* [Learn how semiconductors work](https://tinytapeout.com/siliwiz/)
* [Join the community](https://discord.gg/rPK2nSjxy8)

## What next?

* Share your GDS on Twitter, tag it [#tinytapeout](https://twitter.com/hashtag/tinytapeout?src=hashtag_click) and [link me](https://twitter.com/matthewvenn)!
