#!/home/crisefd/.rvm/rubies/ruby-2.1.5/bin/ruby
# encoding: utf-8
# Program: evaluador.rb
# Author: Cristhian Fuertes, Fabian Cano, Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co, fabian.cano@correounivalle.edu.co, oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-06-24 19:00

def dd arg
	p arg
 end
=begin
@author Cristhian Fuertes
Esta clase realiza llamados a algoritmoGenetico.rb
para realizar pruebas de ejecución al algoritmo genetico de las NReinas.
Los resultados de las pruebas se almacenan en directorios cuyos nombres
corresponden a los tres tipos de modalidad de selección del AG.

Para ejecutar la prueba se usa el comando: ruby evaluador.rb <iteraciones> <paso> <pruebas> <dimension_tablero> <generaciones> <modalidades>
Donde:
<iteraciones> La cantidad de veces que se le aumentara el paso a la dimension del tablero.
<paso> es un entero que determina que tanto aumentara la dimension
del tablero durante las iteraciones de prueba de una modalidad.
<pruebas> es un entero.
<dimension_tablero> Es un entero que representan la dimension del tablero.
<generaciones> Es un entero que representa la máxima cantidad de generaciones
que especifica la cantidad de pruebas que se hara por cada iteración.
 <modalidades>
son las iniciales que representan el tipo de modalidad(t: torneo, d: diversidad, e:elitismo).

Por ejemplo: ruby evaluador.rb 5 20 5 8 1000 t d
=end
class Evaluador
  #Constante entera que determina el aumento de la dimension del tablero
  #durante las iteraciones de prueba de una modalidad
  $PASO = 0

	#Constante entera que determina la cantidad de pruebas que se haran por cada
	#iteración
	$NUM_PRUEBAS = 0

	#Constante entera que determina la dimensión del tablero
	$DIMENSION_TABLERO = 8

	#Constante entera que determian la máxima cantidad de generacioens en el AG
	$GENERACIONES = 100000

	#Constante entera que determina la cantidad de iteraciones del AG
	$ITERACIONES = 5

private

  #Método que crea los directorios dónde se almacenarán los archivos con
  #los resultados de la ejecución de las pruebas.
  #
  #@return [void]
  def crear_diretorios_pruebas
    if ARGV.include? "t" then
      system("mkdir torneo")
    end
  if ARGV.include? "d" then
      system("mkdir diversidad")
    end
  if ARGV.include? "e" then
      system("mkdir elitismo")
    end
  end

  #Método que realiza las pruebas de ejecución en la modalidad de torneo
  #
  #@return [void]
  def evaluar_por_torneo
    dd "Evaluando por torneo..."
    arg1 = $DIMENSION_TABLERO
    arg2 = "torneo"
    #arg3 = $
    1.upto($ITERACIONES){|i|
			dd "Iteración #{i}"
      linea = ""
      1.upto($NUM_PRUEBAS){ |j|
				dd "Prueba #{j}"
				if i == 1 and j== 1 then
					linea = "ruby algoritmo_genetico.rb #{arg1} #{arg2} #{$GENERACIONES} 0"
				else
					linea = "ruby algoritmo_genetico.rb #{arg1} #{arg2} #{$GENERACIONES} 1"
				end

        system(linea)
      }
      arg1 += $PASO
    }
    dd "OK"
  end

  #Método que realiza las pruebas de ejecución en la modalidad de diversidad
  #
  #@return [void]
  def evaluar_por_diversidad
    arg1 = $DIMENSION_TABLERO
    arg2 = "diversidad"
    #arg3 = 100000
    dd "Evaluando por diversidad"
    1.upto($ITERACIONES){|i|
			dd "Iteración #{i}"
      linea = ""
			1.upto($NUM_PRUEBAS){ |j|
				dd "Prueba #{j}"
				if i == 1 and j== 1 then
					linea = "ruby algoritmo_genetico.rb #{arg1} #{arg2} #{$GENERACIONES} 0"
				else
					linea = "ruby algoritmo_genetico.rb #{arg1} #{arg2} #{$GENERACIONES} 1"
				end

        system(linea)
      }
      arg1 += $PASO
    }
    dd "OK"
  end

  #Método que realiza las pruebas de ejecución en la modalidad de elitismo
  #
  #@return [void]
  def evaluar_por_elitismo
    arg1 = $DIMENSION_TABLERO
    arg2 = "elitismo"
    #arg3 = 100000
    dd "Evaluando por elitismo"
    1.upto($ITERACIONES){|i|
			dd "Iteración #{i}"
			linea = ''
			1.upto($NUM_PRUEBAS){ |j|
				dd "Prueba #{j}"
				if i == 1 and j== 1 then
					linea = "ruby algoritmo_genetico.rb #{arg1} #{arg2} #{$GENERACIONES} 0"
				else
						linea = "ruby algoritmo_genetico.rb #{arg1} #{arg2} #{$GENERACIONES} 1"
				end

        system(linea)
      }

      arg1 += $PASO
    }
    dd "OK"
  end

public

  #Método principal de la clase. Realiza los llamados a las demas funciones de
  #evaluación.
  #
  #@return [void]
  def evaluar
		begin
			$ITERACIONES = ARGV[0].to_i
	    $PASO = ARGV[1].to_i
			$NUM_PRUEBAS = ARGV[2].to_i
			$DIMENSION_TABLERO = ARGV[3].to_i
			$GENERACIONES = ARGV[4].to_i
		rescue Error => e
			p e
			abort
		end
  	crear_diretorios_pruebas
    if ARGV.include? "t" then
      evaluar_por_torneo
  end
    if ARGV.include? "d" then
      evaluar_por_diversidad
    end
  if ARGV.include? "e" then
      evaluar_por_elitismo
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  ev = Evaluador.new
  ev.evaluar
end
