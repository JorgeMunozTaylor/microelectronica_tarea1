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
    Verifica si la señal Q genera la salida correcta en base a las entradas
    enable-reset.
*/
task verificar_enable_reset
(
    input enable, 
    input reset, 
    input [3:0] Q,
    output reg enable_reset_fallo //Si es 1 indica que Q falló la prueba. 
); 
    integer temp;

    begin
                
        if ( enable === `DESACTIVADO && reset === `DESACTIVADO )
        begin  
            enable_reset_fallo = ( Q === `HiZ )? `BAJO:`ALTO;   
        end

        else if ( enable ===  `DESACTIVADO && reset === `ACTIVO )
        begin
            enable_reset_fallo = ( Q === `BAJO )? `BAJO:`ALTO;           
        end       

        else if ( enable === `ACTIVO && reset === `DESACTIVADO )
        begin
            enable_reset_fallo = ( Q === `HiZ )? `ALTO:`BAJO; 
        end

        else if ( enable === `ACTIVO && reset === `ACTIVO )
        begin        
            enable_reset_fallo = ( Q == `BAJO )? `BAJO:`ALTO; 
        end
  
    end

endtask



/*
    Recibe la salida Q del contador y su valor anterior para determinar si
    el valor es el correcto.
*/
task verificar_Q
(
    input enable, 
    input reset, 
    input [1:0] mode, 
    input [3:0] D,
    input [3:0] Q,
    input [3:0] Q_anterior,
    
    output reg Q_fallo //Si es 1 indica que Q falló la prueba. 
); 
    integer temp;

    begin     
     
        /**/
        if ( enable === `ACTIVO && reset === `DESACTIVADO )
        
            case (mode)

                `CUENTA_TRES_TRES: 
                begin 
                    temp = (Q_anterior+3)&(4'b1111);
                    Q_fallo = ( Q == temp && temp !== 4'bx )? `BAJO:`ALTO;                  
                end

                `CUENTA_MENOS_UNO: 
                begin
                    temp = (Q_anterior-1)&(4'b1111);   
                    Q_fallo = ( Q == temp && temp !== 4'bx )? `BAJO:`ALTO;                                       
                end

                `CUENTA_MAS_UNO: 
                begin
                    temp = (Q_anterior+1)&(4'b1111);   
                    Q_fallo = ( Q == temp && temp !== 4'bx )? `BAJO:`ALTO;
                end

                `CARGA_D: 
                begin
                    Q_fallo = ( Q == D && temp !== 4'bx )? `BAJO:`ALTO;                
                end

                default: $display ("Error: Ese modo no existe!");
            endcase  
    end

endtask


/*
    Recibe la salida load del contador para determinar si
    el valor es el correcto.
*/
task verificar_LOAD
(
    input enable, 
    input reset, 
    input [1:0] mode, 
    input load,

    output reg load_fallo //Si es 1 indica que load falló la prueba.
 ); 
    begin

        if ( enable === `DESACTIVADO && reset === `DESACTIVADO )
        begin
            load_fallo = ( load !== `BAJO )? `ALTO:`BAJO;            
        end

        if ( enable ===  `DESACTIVADO && reset === `ACTIVO )
        begin
            load_fallo = ( load !== `BAJO )? `ALTO:`BAJO;        
        end

        if ( enable === `ACTIVO && reset === `DESACTIVADO )

            case (mode)

                `CUENTA_TRES_TRES:
                begin    
                    load_fallo = ( load !== `BAJO )? `ALTO:`BAJO;                
                end


               `CUENTA_MENOS_UNO:
                begin     
                    load_fallo = ( load !== `BAJO )? `ALTO:`BAJO;                                             
                end                


                `CUENTA_MAS_UNO:
                begin 
                    load_fallo = ( load !== `BAJO )? `ALTO:`BAJO;
                end
                

                `CARGA_D:
                begin   
                    load_fallo = ( load !== `ALTO )? `ALTO:`BAJO;                  
                end


                default:
                    $display ("ERROR: Ese modo no existe!");
            endcase  

        if ( enable === `ACTIVO && reset === `ACTIVO )
        begin
            load_fallo = ( load !== `BAJO )? `ALTO:`BAJO;
        end
  
    end

endtask


/*
    Recibe la salida rco del contador para determinar si
    el valor es el correcto.
*/
task verificar_rco
(
    input [3:0] mode,
    input [3:0] Q,
    input [3:0] Q_anterior,
    input rco,

    output reg rco_fallo //Si es 1 indica que rco falló la prueba.
);
    begin

        if (mode == `CARGA_D)
        begin
            if (rco != `BAJO) rco_fallo = `ALTO;
            else rco_fallo = `BAJO;
        end

        else
        begin
            if ( Q_anterior === 4'hf && Q === 4'h0 )
            begin
                rco_fallo <= ( rco !== `ALTO )? `ALTO:`BAJO;
            end

            else if ( Q_anterior === 4'h0 && Q === 4'hf )
            begin
                rco_fallo <= ( rco !== `ALTO )? `ALTO:`BAJO;
            end

            else if ( Q_anterior === 4'hD && Q === 4'h0 )
            begin
                rco_fallo <= ( rco !== `ALTO )? `ALTO:`BAJO;
            end

            else if ( Q_anterior === 4'hE && Q === 4'h1 )
            begin
                rco_fallo <= ( rco !== `ALTO )? `ALTO:`BAJO;
            end

            else if ( Q_anterior === 4'hF && Q === 4'h2 )
            begin
                rco_fallo <= ( rco !== `ALTO )? `ALTO:`BAJO;
            end

            else
            begin
                rco_fallo <= ( rco !== `ALTO && rco !== 1'bz && rco !== 1'bx )? `BAJO:`ALTO;
            end

        end

    end

endtask