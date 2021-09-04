TITLE Proyecti        (Proyecto.asm)


INCLUDE Irvine32.inc
INCLUDE macros.inc

.data
	X1 REAL8 ?
	Y1 REAL8 ?
	R1 REAL8 ?
	X2 REAL8 ?
	Y2 REAL8 ?
	R2 REAL8 ?


	DeltaX REAL8 ?										;Variable que guarda el cuadrado de la diferencia de las coordenadas X de los centro
	DEltaY REAL8 ?										;Variable que guarda el cuadrado de la diferencia de las coordenadas Y de los centro
	DistC REAL8 ?										;Variable que guarda la distancia entre centros
	TX	REAL8 ?											;Variable que guarda el valor de la coordenada X del punto tangente
	TY	REAL8 ?											;Variable que guarda el valor de la coordenada Y del punto tangente
	Aux REAL8 0.0										;Variable que guarda operciones en el momento de calcular los puntos interseccion
	TX1	REAL8 ?											;Variable que guarda el valor de la coordenada X del otro punto si la relacion fue clasificada como secante
	TY1	REAL8 ?											;Variable que guarda el valor de la coordenada Y del otro punto si la relacion fue clasificada como secante

	MOne REAL8 -1.0										;Variable referente al valor -1 de ensamblador
	Zero REAL8  0.0										;Variable referente al valor 0 de ensamblador
	One REAL8 1.0										;Variable referente al valor 1 de ensamblador
	Two REAL8 2.0										;Variable referente al valor 2 de ensamblador

	Bool REAL8 ?										;Variable para retornar al inicio si se desea volver a ejecutar el codigo

.code
main PROC
	FINIT
	
	MWRITE "Bienvenido a la practica 1 de la asignatura Arquitectura de Computadores 2021-I, los integrantes del equipo son Mariana Betancur, Felipe Merino y Mateo Rincon"
	CALL CRLF
	MWRITE "La funcion principal del programa es clasificar la relacion que tienen dos circunferencias en exteriores, tangentes exteriormente, secantes, tangentes interiormente, " 
	MWRITE "interiores excentricas, interiores concentricas y coincidentes, dadas las coordenadas (X,Y) del centro de cada circunferencia y su respectivo radio. Ademas, si "
	MWRITE "la relación encontrada entre las circunferencias presenta puntos de interseccion, el algoritmo imprimira las coordenadas de estos."
	CALL CRLF
	CALL CRLF


inicio:

	MWRITE "Por favor, ingrese los siguientes datos sobre las circunferencias." 
	CALL CRLF
	CALL CRLF
	MWRITE "La coordenada X del centro del primer circulo es:"
	CALL READFLOAT
	FSTP X1
	
	MWRITE "La coordenada Y del centro del primer circulo es:"
	CALL READFLOAT
	FSTP Y1

	MWRITE "El radio del primer circulo es:"
	CALL READFLOAT
	FSTP R1
	
	MWRITE "La coordenada X del centro del segundo circulo es:"
	CALL READFLOAT
	FSTP X2
	
	MWRITE "La coordenada Y del centro del segundo circulo es:"
	CALL READFLOAT
	FSTP Y2
	
	MWRITE "El radio del segundo circulo es:"
	CALL READFLOAT
	FSTP R2
	
	CALL CRLF


	FINIT                                               ;Inicia el algoritmo, ya se tienen los datos necesarios para realizar los calculos necesarios.
														
	FLD X1												; Calculamos la distancia entre los radios  distC = (deltaX + deltaY)^(1/2), deltaX = (x1-x2)^2, deltaY = (y1-y2)^2
	FSUB X2
	FSTP DeltaX
	FLD DeltaX
	FMUL DeltaX
	FSTP DeltaX

	FLD Y1
	FSUB Y2
	FSTP DeltaY
	FLD DeltaY
	FMUL DeltaY
	FSTP DeltaY

	FLD DeltaX
	FADD DeltaY
	FSQRT
	FSTP DistC

	JMP criterio1										

criterio1:												;Criterio 1, nos servira para poder clasificar en 2 grandes grupos las relaciones dada la distancia entre los centros de las circunferencias.
	FINIT
	
	FLD Zero
	FLD distC
	FCOMIP ST(0), ST(1)									;Si la distancia entre centros no es 0, pasamos al siguiente criterio de clasificacion.
		JNE criterio2

	FLD r1
	FLD r2
	FCOMIP ST(0), ST(1)									;Si la distancia entre centros es 0 y los radios son diferentes, entonces la relacion de clasificacion es: concentricas.
		JNE concentricas
	
	JMP coincidentes									;Si la distancia entre centros es 0 y los radios son iguales, entonces la relacion de clasificacion es: coincidentes.




coincidentes:											;La relacion al ser clasificada como coincidente, imprimira el resultado y luego saltara al final del programa

	MWRITE "El resultado de la clasificacion de la relacion entre las circuenferencias es que estas son coincidentes"							
	CALL CRLF
	JMP final

concentricas:											;La relacion al ser clasificada como concentrica, imprimira el resultado y luego saltara al final del programa

	MWRITE "El resultado de la clasificacion de la relacion entre las circuenferencias es que estas son concentricas"							
	CALL CRLF				
	JMP final

criterio2:												;Sabiendo que los centros de las circunferencias estan en diferentes coordenadas
	FINIT

	FLD distC
	FLD r1
	FSUB r2
	FABS
	FCOMIP ST(0), ST(1)									;Se verifica si la distancia entre los centros es igual en magnitud a la diferencia entre los radios, en caso tal, estas serian clasificadas como tangentes interiormente.
		JE tanInteriores								;JE tanInteriores

	FLD distC
	FLD r1
	FADD r2
	FCOMIP ST(0), ST(1)									;Se verifica si la distancia entre los centros es igual a la suma de los radios, en caso tal, estas serian clasificadas como tangentes exteriormente.
		JE tanExteriores

	FLD distC
	FLD r1
	FSUB r2
	FABS
	FCOMIP ST(0), ST(1)									;Se verifica si la distancia entre los centros es menor en magnitud a la diferencia entre los radios, en caso tal, estas serian clasificadas como interiores excentricas.
		JA excentricas									;JA excentricas

	FLD distC
	FLD r1
	FADD r2
	FCOMIP ST(0), ST(1)									;Se verifica si la distancia entre los centros es menor a la suma de los radios, en caso tal, estas serian clasificadas como secantes.
		JA secantes

	JMP exteriores


tanInteriores:											;La relacion al ser clasificada como tangentes interiormente, calculara el punto de tangencia, imprimira el resultado y luego saltara al final del programa
	FINIT

	FLD X1												;Calcular la coordenada X del punto de tangencia
	FADD X2												;TX = (X1 + X2)/2
	FDIV Two
	FSTP TX

	FLD R2												;TX = TX + (X2-X1)*(R1^2-R2^2)/(2*DistC^2)
	FMUL R2
	FLD R1
	FMUL R1
	FSUB ST(0), ST(1)
	FDIV Two
	FDIV DistC
	FDIV DistC
	FLD X2
	FSUB X1
	FMUL ST(0), ST(1)
	FADD TX
	FSTP TX


	FLD Y1												;Calcular la coordenada Y del punto de tangencia
	FADD Y2												;TY = (Y1 + Y2)/2
	FDIV Two
	FSTP TY

	FLD R2												;TY = TY + (Y2-Y1)*(R1^2-R2^2)/(2*DistC^2)
	FMUL R2
	FLD R1
	FMUL R1
	FSUB ST(0), ST(1)
	FDIV Two
	FDIV DistC
	FDIV DistC
	FLD Y2
	FSUB Y1
	FMUL ST(0), ST(1)
	FADD TY
	FSTP TY

	MWRITE "El resultado de la clasificacion de la relacion entre las circuenferencias es que estas son tangentes interiormente y su punto de interseccion es:"
	MWRITE "( "
	FLD TX
	CALL WRITEFLOAT
	FINIT
	MWRITE " , "
	FLD TY
	CALL WRITEFLOAT
	MWRITE " )"
	CALL CRLF
	JMP final



tanExteriores:											;La relacion al ser clasificada como tangentes exteriormente, calculara el punto de tangencia, imprimira el resultado y luego saltara al final del programa
	FINIT
	
	FLD X1												;Calcular la coordenada X del punto de tangencia
	FADD X2												;TX = (X1 + X2)/2
	FDIV Two
	FSTP TX

	FLD R2												;TX = TX + (X2-X1)*(R1^2-R2^2)/(2*DistC^2)
	FMUL R2
	FLD R1
	FMUL R1
	FSUB ST(0), ST(1)
	FDIV Two
	FDIV DistC
	FDIV DistC
	FLD X2
	FSUB X1
	FMUL ST(0), ST(1)
	FADD TX
	FSTP TX


	FLD Y1												;Calcular la coordenada Y del punto de tangencia
	FADD Y2												;TY = (Y1 + Y2)/2
	FDIV Two
	FSTP TY

	FLD R2												;TY = TY + (Y2-Y1)*(R1^2-R2^2)/(2*DistC^2)
	FMUL R2
	FLD R1
	FMUL R1
	FSUB ST(0), ST(1)
	FDIV Two
	FDIV DistC
	FDIV DistC
	FLD Y2
	FSUB Y1
	FMUL ST(0), ST(1)
	FADD TY
	FSTP TY


	MWRITE "El resultado de la clasificacion de la relacion entre las circuenferencias es que estas son tangentes exteriormente y su punto de interseccion es:"
	MWRITE "( "
	FLD TX
	CALL WRITEFLOAT
	FINIT
	MWRITE " , "
	FLD TY
	CALL WRITEFLOAT
	MWRITE " )"
	CALL CRLF
	JMP final



excentricas:                                           ;La relacion al ser clasificada como excentricas, imprimira el resultado y luego saltara al final del programa

	MWRITE "El resultado de la clasificacion de la relacion entre las circuenferencias es que estas son interiores excentricas"							
	CALL CRLF
	JMP final



secantes:												;La relacion al ser clasificada como secantes, calculara los puntos de tangencia, imprimira el resultado y luego saltara al final del programa
	FINIT
	
	FLD X1												;Calcular la coordenada X del punto de tangencia
	FADD X2												;TX = (X1 + X2)/2
	FDIV Two
	FSTP TX

	FLD R2												;TX = (R1^2-R2^2)/(2*DistC^2)*(X2-X1) + TX
	FMUL R2
	FLD R1
	FMUL R1
	FSUB ST(0), ST(1)
	FDIV Two
	FDIV DistC
	FDIV DistC
	FLD X2
	FSUB X1
	FMUL ST(0), ST(1)
	FADD TX
	FSTP TX


	FLD Y1												;Calcular la coordenada Y del punto de tangencia
	FADD Y2												;TY = (Y1 + Y2)/2
	FDIV Two
	FSTP TY

	FLD R2												;TY = (R1^2-R2^2)/(2*DistC^2)*(Y2-Y1) + TY
	FMUL R2
	FLD R1
	FMUL R1
	FSUB ST(0), ST(1)
	FDIV Two
	FDIV DistC
	FDIV DistC
	FLD Y2
	FSUB Y1
	FMUL ST(0), ST(1)
	FADD TY
	FSTP TY
														;Se calcula la constante que sera de ayuda para encontrar los puntos, se le llama "SecanteAux"

	FLD R2												;SecanteAux = (R1^2-R2^2)^2/(DistC^4) - 1
	FMUL R2
	FLD R1
	FMUL R1
	FSUB ST(0), ST(1)
	FST Aux
	FMUL Aux
	FDIV DistC
	FDIV DistC
	FDIV DistC
	FDIV DistC
	FADD One
	FSTP Aux
	
	FLD R1												;SecanteAux = ((2*(R1^2 + R2^2)/DistC^2 - SecanteAux)^0.5)/2
	FMUL R1
	FLD R2
	FMUL R2
	FADD ST(0), ST(1)
	FMUL Two
	FDIV DistC
	FDIV DistC
	FSUB Aux
	FSQRT
	FDIV Two
	FSTP Aux

	

	FLD Y2												;TX1 = (Y2-Y1)*-1*SecanteAux + TX
	FSUB Y1
	FMUL Aux
	FMUL MOne
	FADD TX
	FSTP TX1

	FLD X1												;TY1 = (X1-X2)*-1*SecanteAux + TY
	FSUB X2
	FMUL Aux
	FMUL MOne
	FADD TY
	FSTP TY1

	FLD Y2												;TX = (Y2-Y1)*SecanteAux + TX
	FSUB Y1
	FMUL Aux
	FADD TX
	FSTP TX 

	FLD X1												;TY = (X1-X2)*SecanteAux + TY
	FSUB X2
	FMUL Aux
	FADD TY
	FSTP TY


															
	MWRITE "La relacion entre las dos circunferencias es de secantes y sus puntos de interseccion son:"
	
	MWRITE " ( "
	FLD TX
	CALL WRITEFLOAT
	FINIT
	MWRITE " , "
	FLD TY
	CALL WRITEFLOAT
	MWRITE " )   y  ( "
	FINIT
	FLD TX1
	CALL WRITEFLOAT
	FINIT
	MWRITE " , "
	FLD TY1
	CALL WRITEFLOAT
	MWRITE " )."
	
	JMP final

exteriores:												;La relacion al ser clasificada como exteriores, imprimira el resultado y luego saltara al final del programa
	MWRITE "La relacion entre las dos circunferencias es de exteriores."
	JMP final



final:

	FLD Zero                                            ;Se le asigna un valor de 0 a todas las variables antes de hacer una nueva consulta
	FST DeltaX
	FST DeltaY
	FST DistC
	FST TX
	FST TY
	FST Aux
	FST TX1
	FST Bool
	FSTP TY1


	CALL CRLF                                                ;Secuencia de finalizacion en donde se le preguntara al usuario si desea volver a hacer uso del programa o desea finalizar la ejecucion del mismo
	MWRITE <"Ingrese [1] si desea validar la relacion entre otros dos circulos; de lo contrario ingrese [0]">
	CALL READFLOAT
	FST Bool
	CALL CRLF
	FLD Zero
	FCOMI st(0), st(1)
		JNE inicio

	MWRITE <"Gracias por usar el programa, esperamos que te haya servido.">

	exit
main ENDP
END main