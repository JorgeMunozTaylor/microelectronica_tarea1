/*
    Tarea 1
    Microelectrónica
    Creado por Jorge Muñoz Taylor
    Carné A53863
    II-2020
*/

/*
    Módulo que se encarga de verificar los resultados provenientes del contador.
*/
module checker #( parameter FILE = "./logs/log_A.txt" )
(
    input enable, 
    input clk, 
    input reset, 
    input [1:0] mode, 
    input [3:0] D,

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
    reg enable_reset_fallo;
    reg [3:0] Q_anterior;
    reg continuar;

    initial Q_fallo            = `BAJO;
    initial rco_fallo          = `BAJO;
    initial load_fallo         = `BAJO;
    initial Q_anterior         = `BAJO;
    initial continuar          = `BAJO;
    initial enable_reset_fallo = `BAJO;

    initial log = $fopen (FILE);

    // Se guarda el estado anterior de Q en Q_anterior.
    always @( posedge clk )
    begin
        Q_anterior = Q;
    end


    // La señal continuar es una bandera que indica cuando sensar las señales,
    // si es 0 no habrá monitoreo, si es 1 se activará. 
    always @(mode)
    begin
        continuar     = `BAJO;
        #20 continuar = `ALTO;
    end


    // Si la señal de entrada cambia se hace un pequeño retardo para esperar
    // que las señales internas del probador se actualicen. 
    always @(D)
    begin
        if (mode==`CARGA_D && enable!=0 && reset!=1)
        begin
            continuar     = `BAJO;
            #10 continuar = `ALTO;
        end
    end


    // Cada flanco positivo se verifican las salidas.
    // Se verifican las entradas enable-reset y se imprime un mensaje si la salida es incorrecta.    
    always @( posedge clk )
    begin
        // Los checkers inician luego de 15 tiempos, esto para que se inicien todos
        // los parámetros.
        if ( continuar == `ALTO )
        begin
            // Verifica el funcionamiento de la salida Q.
            verificar_enable_reset
            (
                enable, 
                reset, 
                Q,
                enable_reset_fallo //Si es 1 indica que Q falló la prueba. 
            );

            if ( enable_reset_fallo === `ALTO )
            begin
                $display ("tiempo =%2d : reset %1b enable %1b : Reset enable fail", $time, reset, enable);
                $fdisplay(log, "tiempo =%2d : reset %1b enable %1b : Reset enable fail", $time, reset, enable);
            end
        end
    end


    // Cada flanco positivo se verifican las salidas. 
    // Se verifica la salida Q y se imprime un mensaje si la salida es incorrecta.   
    always @( posedge clk )
    begin
        // Los checkers inician luego de 15 tiempos, esto para que se inicien todos
        // los parámetros.
        if ( continuar == `ALTO )
        begin
            // Verifica el funcionamiento de la salida Q.
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
                $display ("tiempo =%2d : modo %1b : Q fail", $time, mode);
                $fdisplay(log, "tiempo =%2d : modo %1b : Q fail", $time, mode);
            end
        end
    end


    // Se verifica la salida load y se imprime un mensaje si la salida es incorrecta.
    always @( posedge clk )
    begin
        // Los checkers inician luego de 15 tiempos, esto para que se inicien todos
        // los parámetros.
        if ( continuar == `ALTO )
        begin
            // verifica el funcionamiento de la salida LOAD.
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
                $display ("tiempo =%2d : modo %1b : load fail", $time, mode);
                $fdisplay(log, "tiempo =%2d : modo %1b : load fail", $time, mode);
            end     
        end
    end


    // Se verifican la salida rco y se imprime un mensaje si la salida es incorrecta.
    always @( posedge clk )
    begin
        if ( continuar == `ALTO )
        begin
            // Verifica el funcionamiento de la salida rco.
            verificar_rco
            (
                mode,
                Q,
                Q_anterior,
                rco,
                rco_fallo
            );

            if ( rco_fallo === `ALTO )
            begin
                $display ("tiempo =%2d : modo %1b : rco fail", $time, mode);
                $fdisplay(log, "tiempo =%2d : modo %1b : rco fail", $time, mode);
            end
        end
    end

endmodule