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
    begin
        /**/
        if ( enable === `DESACTIVADO && reset === `DESACTIVADO )
        begin  
            Q_fallo <= ( Q === `HiZ )? `BAJO:`ALTO;   
        end

        /**/
        else if ( enable ===  `DESACTIVADO && reset === `ACTIVO )
        begin
            Q_fallo <= ( Q === `BAJO )? `BAJO:`ALTO;           
        end


        /**/
        else if ( enable === `ACTIVO && reset === `DESACTIVADO )
        
            case (mode)

                `CUENTA_TRES_TRES: 
                begin 
                    Q_anterior += 3;   
                    Q_fallo <= ( Q === Q_anterior )? `BAJO:`ALTO;                  
                end

                `CUENTA_MENOS_UNO: 
                begin
                    Q_anterior -= 1;    
                    Q_fallo <= ( Q === Q_anterior )? `BAJO:`ALTO;                                       
                end

                `CUENTA_MAS_UNO: 
                begin
                    Q_anterior += 1;    
                    Q_fallo <= ( Q === Q_anterior )? `BAJO:`ALTO;
                end

                `CARGA_D: 
                begin
                    Q_fallo <= ( Q === D )? `BAJO:`ALTO;                
                end

                default: $display ("Error: Ese modo no existe!");
            endcase 
        

    

        /**/
        else if ( enable === `ACTIVO && reset === `ACTIVO )
        begin        
            Q_fallo <= ( Q === `BAJO )? `BAJO:`ALTO; 
        end
  
    end

endtask



task verificar_LOAD
(
    input enable, 
    input reset, 
    input [1:0] mode, 
    input load,

    output reg load_fallo //Si es 1 indica que load falló la prueba.
 ); 
    begin
        /**/
        if ( enable === `DESACTIVADO && reset === `DESACTIVADO )
        begin
            load_fallo = ( load !== `BAJO )? `ALTO:`BAJO;            
        end


        /**/
        if ( enable ===  `DESACTIVADO && reset === `ACTIVO )
        begin
            load_fallo = ( load !== `BAJO )? `ALTO:`BAJO;        
        end


        /**/
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
                    $display ("adasdsdsad");
            endcase  


        /**/
        if ( enable === `ACTIVO && reset === `ACTIVO )
        begin
            load_fallo = ( load !== `BAJO )? `ALTO:`BAJO;
        end
  
    end

endtask






task verificar_rco
(
    input [3:0] Q,
    input [3:0] Q_anterior,
    input rco,

    output rco_fallo //Si es 1 indica que rco falló la prueba.
);
    begin
        
        if ( Q_anterior === `Qmax && Q === `Qmin )
        begin
            rco_fallo = ( rco !== `ALTO )? `ALTO:`BAJO;
        end

        else if ( Q_anterior === `Qmin && Q === `Qmax )
        begin
            rco_fallo = ( rco !== `ALTO )? `ALTO:`BAJO;
        end

    end

endtask



task display
(
    input Q_fallo_final, 
    input rco_fallo_final,
    input load_fallo_final
);
    begin

        if ( Q_fallo_final == 1 )
        begin
            $display("%c[1;31m",27);
            $display("***************************************");
            $display("******** Q no pasó las pruebas ********");
            $display("***************************************");
            $display("%c[0m",27);            
        end
        else
        begin
            $display("%c[1;34m",27);
            $display("***************************************");
            $display("********* Q pasó las pruebas **********");
            $display("***************************************");
            $write("%c[0m",27);
        end


        if ( rco_fallo_final == 1 )
        begin
            $display("%c[1;31m",27);
            $display("***************************************");
            $display("******* rco no pasó las pruebas *******");
            $display("***************************************");
            $display("%c[0m",27);            
        end
        else
        begin
            $display("%c[1;34m",27);
            $display("***************************************");
            $display("******** rco pasó las pruebas *********");
            $display("***************************************");
            $write("%c[0m",27);
        end

        if ( load_fallo_final == 1 )
        begin
            $display("%c[1;31m",27);
            $display("***************************************");
            $display("****** load no pasó las pruebas *******");
            $display("***************************************");
            $display("%c[0m",27);            
        end
        else
        begin
            $display("%c[1;34m",27);
            $display("***************************************");
            $display("******* load pasó las pruebas *********");
            $display("***************************************");
            $write("%c[0m",27);
        end

    end
endtask