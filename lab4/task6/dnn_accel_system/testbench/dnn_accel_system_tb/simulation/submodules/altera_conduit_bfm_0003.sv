// (C) 2001-2019 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/main/ip/sopc/components/verification/altera_tristate_conduit_bfm/altera_tristate_conduit_bfm.sv.terp#7 $
// $Revision: #7 $
// $Date: 2010/08/05 $
// $Author: klong $
//-----------------------------------------------------------------------------
// =head1 NAME
// altera_conduit_bfm
// =head1 SYNOPSIS
// Bus Functional Model (BFM) for a Standard Conduit BFM
//-----------------------------------------------------------------------------
// =head1 DESCRIPTION
// This is a Bus Functional Model (BFM) for a Standard Conduit Master.
// This BFM sampled the input/bidirection port value or driving user's value to 
// output ports when user call the API.  
// This BFM's HDL is been generated through terp file in Qsys/SOPC Builder.
// Generation parameters:
// output_name:                                       altera_conduit_bfm_0003
// role:width:direction:                              vga_blu:8:input,vga_clk:1:input,vga_grn:8:input,vga_hsync:1:input,vga_red:8:input,vga_vsync:1:input
// 0
//-----------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module altera_conduit_bfm_0003
(
   sig_vga_blu,
   sig_vga_clk,
   sig_vga_grn,
   sig_vga_hsync,
   sig_vga_red,
   sig_vga_vsync
);

   //--------------------------------------------------------------------------
   // =head1 PINS 
   // =head2 User defined interface
   //--------------------------------------------------------------------------
   input [7 : 0] sig_vga_blu;
   input sig_vga_clk;
   input [7 : 0] sig_vga_grn;
   input sig_vga_hsync;
   input [7 : 0] sig_vga_red;
   input sig_vga_vsync;

   // synthesis translate_off
   import verbosity_pkg::*;
   
   typedef logic [7 : 0] ROLE_vga_blu_t;
   typedef logic ROLE_vga_clk_t;
   typedef logic [7 : 0] ROLE_vga_grn_t;
   typedef logic ROLE_vga_hsync_t;
   typedef logic [7 : 0] ROLE_vga_red_t;
   typedef logic ROLE_vga_vsync_t;

   logic [7 : 0] sig_vga_blu_in;
   logic [7 : 0] sig_vga_blu_local;
   logic [0 : 0] sig_vga_clk_in;
   logic [0 : 0] sig_vga_clk_local;
   logic [7 : 0] sig_vga_grn_in;
   logic [7 : 0] sig_vga_grn_local;
   logic [0 : 0] sig_vga_hsync_in;
   logic [0 : 0] sig_vga_hsync_local;
   logic [7 : 0] sig_vga_red_in;
   logic [7 : 0] sig_vga_red_local;
   logic [0 : 0] sig_vga_vsync_in;
   logic [0 : 0] sig_vga_vsync_local;

   //--------------------------------------------------------------------------
   // =head1 Public Methods API
   // =pod
   // This section describes the public methods in the application programming
   // interface (API). The application program interface provides methods for 
   // a testbench which instantiates, controls and queries state in this BFM 
   // component. Test programs must only use these public access methods and 
   // events to communicate with this BFM component. The API and module pins
   // are the only interfaces of this component that are guaranteed to be
   // stable. The API will be maintained for the life of the product. 
   // While we cannot prevent a test program from directly accessing internal
   // tasks, functions, or data private to the BFM, there is no guarantee that
   // these will be present in the future. In fact, it is best for the user
   // to assume that the underlying implementation of this component can 
   // and will change.
   // =cut
   //--------------------------------------------------------------------------
   
   event signal_input_vga_blu_change;
   event signal_input_vga_clk_change;
   event signal_input_vga_grn_change;
   event signal_input_vga_hsync_change;
   event signal_input_vga_red_change;
   event signal_input_vga_vsync_change;
   
   function automatic string get_version();  // public
      // Return BFM version string. For example, version 9.1 sp1 is "9.1sp1" 
      string ret_version = "19.1";
      return ret_version;
   endfunction

   // -------------------------------------------------------
   // vga_blu
   // -------------------------------------------------------
   function automatic ROLE_vga_blu_t get_vga_blu();
   
      // Gets the vga_blu input value.
      $sformat(message, "%m: called get_vga_blu");
      print(VERBOSITY_DEBUG, message);
      return sig_vga_blu_in;
      
   endfunction

   // -------------------------------------------------------
   // vga_clk
   // -------------------------------------------------------
   function automatic ROLE_vga_clk_t get_vga_clk();
   
      // Gets the vga_clk input value.
      $sformat(message, "%m: called get_vga_clk");
      print(VERBOSITY_DEBUG, message);
      return sig_vga_clk_in;
      
   endfunction

   // -------------------------------------------------------
   // vga_grn
   // -------------------------------------------------------
   function automatic ROLE_vga_grn_t get_vga_grn();
   
      // Gets the vga_grn input value.
      $sformat(message, "%m: called get_vga_grn");
      print(VERBOSITY_DEBUG, message);
      return sig_vga_grn_in;
      
   endfunction

   // -------------------------------------------------------
   // vga_hsync
   // -------------------------------------------------------
   function automatic ROLE_vga_hsync_t get_vga_hsync();
   
      // Gets the vga_hsync input value.
      $sformat(message, "%m: called get_vga_hsync");
      print(VERBOSITY_DEBUG, message);
      return sig_vga_hsync_in;
      
   endfunction

   // -------------------------------------------------------
   // vga_red
   // -------------------------------------------------------
   function automatic ROLE_vga_red_t get_vga_red();
   
      // Gets the vga_red input value.
      $sformat(message, "%m: called get_vga_red");
      print(VERBOSITY_DEBUG, message);
      return sig_vga_red_in;
      
   endfunction

   // -------------------------------------------------------
   // vga_vsync
   // -------------------------------------------------------
   function automatic ROLE_vga_vsync_t get_vga_vsync();
   
      // Gets the vga_vsync input value.
      $sformat(message, "%m: called get_vga_vsync");
      print(VERBOSITY_DEBUG, message);
      return sig_vga_vsync_in;
      
   endfunction

   assign sig_vga_blu_in = sig_vga_blu;
   assign sig_vga_clk_in = sig_vga_clk;
   assign sig_vga_grn_in = sig_vga_grn;
   assign sig_vga_hsync_in = sig_vga_hsync;
   assign sig_vga_red_in = sig_vga_red;
   assign sig_vga_vsync_in = sig_vga_vsync;


   always @(sig_vga_blu_in) begin
      if (sig_vga_blu_local != sig_vga_blu_in)
         -> signal_input_vga_blu_change;
      sig_vga_blu_local = sig_vga_blu_in;
   end
   
   always @(sig_vga_clk_in) begin
      if (sig_vga_clk_local != sig_vga_clk_in)
         -> signal_input_vga_clk_change;
      sig_vga_clk_local = sig_vga_clk_in;
   end
   
   always @(sig_vga_grn_in) begin
      if (sig_vga_grn_local != sig_vga_grn_in)
         -> signal_input_vga_grn_change;
      sig_vga_grn_local = sig_vga_grn_in;
   end
   
   always @(sig_vga_hsync_in) begin
      if (sig_vga_hsync_local != sig_vga_hsync_in)
         -> signal_input_vga_hsync_change;
      sig_vga_hsync_local = sig_vga_hsync_in;
   end
   
   always @(sig_vga_red_in) begin
      if (sig_vga_red_local != sig_vga_red_in)
         -> signal_input_vga_red_change;
      sig_vga_red_local = sig_vga_red_in;
   end
   
   always @(sig_vga_vsync_in) begin
      if (sig_vga_vsync_local != sig_vga_vsync_in)
         -> signal_input_vga_vsync_change;
      sig_vga_vsync_local = sig_vga_vsync_in;
   end
   


// synthesis translate_on

endmodule

