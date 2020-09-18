/*
    Tarea 1
    Microelectrónica
    Creado por Jorge Muñoz Taylor
    Carné A53863
    II-2020
*/

`timescale 1ns/1ps

`include "../test/test_1.v"
`include "../src/contadorC.v"

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
        $dumpfile("../bin/prueba_C.vcd");
        $dumpvars;
        #1000 $finish;
    end


    program clr_display();
        class color ;
            task display ();
            begin
                $display("%c[1;34m",27);
                $display("***************************************");
                $display("*********** TEST CASE PASS ************");
                $display("***************************************");
                $write("%c[0m",27);
                
                $display("%c[1;31m",27);
                $display("***************************************");
                $display("*********** TEST CASE FAIL ************");
                $display("***************************************");
                $display("%c[0m",27);
            end
            endtask
        endclass

        initial 
        begin
            color clr;
            clr = new ();
            clr.display ();
        end
    endprogram

endmodule