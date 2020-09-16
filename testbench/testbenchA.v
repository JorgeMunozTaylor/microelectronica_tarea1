/*
    Tarea 1
    Microelectrónica
    Creado por Jorge Muñoz Taylor
    Carné A53863
    II-2020
*/

`timescale 1ns/1ps

`include "./test/test_1.v"
`include "./test/checker.v"
`include "./src/contadorA.v"

/*
    Testbench que se usará para el contador A, simplemente conecta todos los
    módulos, indica cuando acaba la simulación y genera el archivo VCD.
*/
module testbench;

    wire       enable; 
    wire       clk; 
    wire       reset; 
    wire [1:0] mode; 
    wire [3:0] D;
    wire       load; 
    wire       rco; 
    wire [3:0] Q;


    test_1 #( .FILE("./logs/log_A.txt") ) TEST_1
    (
        .enable (enable), 
        .clk    (clk), 
        .reset  (reset), 
        .mode   (mode), 
        .D      (D)
    );


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


    checker CHECK
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
        $dumpvars;
        #`TIEMPO $finish;
    end

endmodule