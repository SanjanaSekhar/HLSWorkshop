############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2017 Xilinx, Inc. All Rights Reserved.
############################################################
open_project MakeHT2
set_top MakeHT
add_files MakeHT2.c
add_files MakeHT2.h
add_files -tb TestMakeHT2.c
open_solution "solutionHT2"
set_part {xc7vx690tffg1927-2} -tool vivado
create_clock -period 6.25 -name default
#source "./MakeHT2/solutionHT2/directives.tcl"
csim_design -compiler gcc
csynth_design
cosim_design
export_design -format ip_catalog
