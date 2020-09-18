/*
    Tarea 1
    Microelectrónica
    Creado por Jorge Muñoz Taylor
    Carné A53863
    II-2020
*/

`timescale 1ns/1ps

`include "./test/test_1.v"
`include "./src/contadorA.v"

module testbench;

    wire       enable; 
    wire       clk; 
    wire       reset; 
    wire [1:0] mode; 
    wire [3:0] D;

    wire       load; 
    wire       rco; 
    wire [3:0] Q;


    counter DUV 
    (
        .enable (enable), 
        .clk    (clk), 
        .reset  (reset), 
        .mode   (mode), 
        .D      (D), 
        .load   (load), 
        .rco    (rco), 
        .Q      (Q)
    );


    test_1 TEST_1
    (
        .enable (enable), 
        .clk    (clk), 
        .reset  (reset), 
        .mode   (mode), 
        .D      (D), 
        .load   (load), 
        .rco    (rco), 
        .Q      (Q)
    );
 

    initial
    begin
        $dumpfile("./bin/prueba_A.vcd");
        //$dumpvars(0, clk, enable, reset, mode, D, load, rco, Q );
        $dumpvars;
        #`TIEMPO $finish;
    end

endmodule