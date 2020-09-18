#    Tarea 1
#    Microelectrónica
#    Creado por Jorge Muñoz Taylor
#    Carné A53863
#    II-2020

#ALL: compilar simular

probarA:
	mkdir -p ./bin
	mkdir -p ./logs
	iverilog -o ./bin/PRUEBA_A ./testbench/testbenchA.v 
	vvp ./bin/PRUEBA_A
	gtkwave ./bin/prueba_A.vcd

probarB:
	mkdir -p ./bin
	mkdir -p ./logs
	iverilog -o ./bin/PRUEBA_B ./testbench/testbenchB.v
	vvp ./bin/PRUEBA_B
	gtkwave ./bin/prueba_B.vcd

probarC:
	mkdir -p ./bin
	mkdir -p ./logs
	iverilog -o ./bin/PRUEBA_C ./testbench/testbenchC.v
	vvp ./bin/PRUEBA_C
	gtkwave ./bin/prueba_C.vcd

clean:
	rm -rf ./bin ./logs