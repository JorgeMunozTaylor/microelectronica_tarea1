/*
    Tarea 1
    Microelectrónica
    Creado por Jorge Muñoz Taylor
    Carné A53863
    II-2020
*/
`ifndef DEFINES_V
`include "./src/defines.v"
`endif

/*
    Módulo que genera las señales de prueba que se inyectarán en el contador.
*/
module test_1 #( parameter FILE = "./logs/log_A.txt" )
(
    output reg  enable, 
    output reg  clk, 
    output reg  reset, 
    output reg  [1:0] mode, 
    output reg  [3:0] D
);

    integer log;

    // Inicia el reloj en 0.
    initial clk = 0;
    always #5 clk = !clk;

    // Crea el archivo de logs.
    initial 
    begin
        log = $fopen (FILE); //("./logs/log_A.txt");
        $display ("\n\n********** Start simulation **********\n");
        $fdisplay(log, "********** Start simulation **********\n");
    end

    // Al iniciar el test resetea el circuito.
    initial enable     = 0;
    initial #10 enable = 1; 
    initial reset      = 1;
    initial #10 reset  = 0;
    
    initial #1410 enable = `DESACTIVADO;
    initial #1410 reset  = `DESACTIVADO;
    initial #1760 enable = `ACTIVO;
    initial #1760 reset  = `DESACTIVADO;


    // Se coloca el protocolo de verificación.
    initial
    begin
        mode = `CARGA_D;
        D = 0;

        // Prueba el modo 00.
        #10 mode = `CUENTA_TRES_TRES;
                
        // Prueba el modo 01.
        #350 mode = `CUENTA_MENOS_UNO;
        
        // Prueba el modo 10.
        #350 mode = `CUENTA_MAS_UNO;
        
        // Prueba el modo 11.
        #350 mode = `CARGA_D;
                
        // Se probarán los modos de forma aleatoria hasta el final de la simulación.
        // También las entradas enable-reset cambiarán aleatoriamente.
        forever
        begin
            #350 mode <= $random;
            #($urandom_range(50,100)) enable <= $random;
            #($urandom_range(50,100)) reset  <= $random; 
        end

    end


    // D es aleatorio durante toda la simulación.
    always
    begin
        #100 D <= $random; 
    end

endmodule