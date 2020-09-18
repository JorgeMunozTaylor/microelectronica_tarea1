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

module test_1
(
    output reg  enable, 
    output reg  clk, 
    output reg  reset, 
    output reg  [1:0] mode, 
    output reg  [3:0] D,

    input       load, 
    input       rco, 
    input [3:0] Q
);

    `ifndef TASKS_V
    `include "./src/tasks.v"
    `endif

    integer log;

    reg Q_fallo;
    reg rco_fallo;
    reg load_fallo;
    reg [3:0] Q_anterior;

    // Inicia el reloj en 0.
    initial clk = 0;
    always #5 clk = !clk;

    initial 
    begin
        log = $fopen("./logs/contadorA.log");
        $fdisplay(log, "tiempo =%2d, inicia la simulación", $time);
    end

    // Al iniciar el test resetea el circuito.
    initial enable     = 0;
    initial #10 enable = 1; 
    initial reset      = 1;
    initial #10 reset  = 0;
    
    initial
    begin
        mode = `CARGA_D;
        D = 0;

        $fdisplay(log, "\ntiempo =%2d, *** MODOS EN ORDEN ***\n", $time);

        // Prueba el modo 00.
        #10 mode = `CUENTA_TRES_TRES;
        $fdisplay(log, "tiempo =%2d, modo 00", $time);
        
        // Prueba el modo 01.
        #350 mode = `CUENTA_MENOS_UNO;
        $fdisplay(log, "\ntiempo =%2d, modo 01", $time);

        // Prueba el modo 10.
        #350 mode = `CUENTA_MAS_UNO;
        $fdisplay(log, "\ntiempo =%2d, modo 10", $time);

        // Prueba el modo 11.
        #350 mode = `CARGA_D;
        $fdisplay(log, "\ntiempo =%2d, modo 11", $time);
        
        // Prueba modos aleatoriamente.
        #350 $fdisplay(log, "\ntiempo =%2d, *** MODOS ALEATORIOS ***", $time);
        mode = $random;
        $fdisplay(log, "\ntiempo =%2d, modo %1b", $time, mode);

        forever
        begin
            #350 mode = $random;
            $fdisplay(log, "\ntiempo =%2d, modo %1b", $time, mode);
        end

    end

    always
    begin
        #100 D <= $random; 
    end

    

    // Guarda el estado anterior de Q.
    always @( posedge clk )
    begin
        Q_anterior <= Q;           
    end

    

    always @( posedge clk )
    begin
        verificar_Q
        (
            enable, 
            reset, 
            mode, 
            D,
            Q,
            Q_anterior,
            Q_fallo
        );

        if ( Q_fallo === `ALTO )
        begin
            $fdisplay(log, "    tiempo = %2d, Q falló", $time);
        end

        verificar_LOAD
        (
            enable, 
            reset, 
            mode, 
            load,
            load_fallo
        );

        if ( load_fallo === `ALTO )
        begin
            $fdisplay(log, "    tiempo = %2d, load falló", $time);
        end

        verificar_rco
        (
            Q,
            Q_anterior,
            rco,
            rco_fallo
        );

        if ( rco_fallo === `ALTO )
        begin
            $fdisplay(log, "    tiempo = %2d, rco falló", $time);
        end
    end

endmodule