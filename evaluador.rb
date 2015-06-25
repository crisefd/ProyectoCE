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

Para ejecutar la prueba se usa el comando: ruby evaluador.rb <paso> <modalidades>
Donde <paso> es un entero que determina que tanto aumentara la dimension
del tablero durante las iteraciones de prueba de una modalidad. Y <modalidades>
son las iniciales que representan el tipo de modalidad(t: torneo, d: diversidad, e:elitismo).

Por ejemplo: ruby evaluador.rb 20 t d
=end
class Evaluador
  #Constante entera que determina el aumento de la dimension del tablero
  #durante las iteraciones de prueba de una modalidad
  $PASO = 2

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
    arg1 = 8
    arg2 = "torneo"
    arg3 = 100000
    0.upto(5){|i|
      linea = "ruby algoritmoGenetico.rb #{arg1} #{arg2} #{arg3}"
      #5.downto(0){ |j|
        system(linea)
    #  }
      arg1 += $PASO
    }
    dd "OK"
  end

  #Método que realiza las pruebas de ejecución en la modalidad de diversidad
  #
  #@return [void]
  def evaluar_por_diversidad
    arg1 = 8
    arg2 = "diversidad"
    arg3 = 100000
    dd "Evaluando por diversidad"
    0.upto(5){|i|
      linea = "ruby algoritmoGenetico.rb #{arg1} #{arg2} #{arg3}"
    #  5.downto(0){ |j|
        system(linea)
    #  }
      arg1 += $PASO
    }
    dd "OK"
  end

  #Método que realiza las pruebas de ejecución en la modalidad de elitismo
  #
  #@return [void]
  def evaluar_por_elitismo
    arg1 = 8
    arg2 = "elitismo"
    arg3 = 100000
    dd "Evaluando por elitismo"
    0.upto(5){|i|
      linea = "ruby algoritmoGenetico.rb #{arg1} #{arg2} #{arg3}"
    #  5.downto(0){ |j|
        system(linea)
    #  }

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
    $PASO = ARGV[0].to_i
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
