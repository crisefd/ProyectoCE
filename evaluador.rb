#!/home/crisefd/.rvm/rubies/ruby-2.1.5/bin/ruby
# encoding: utf-8
# Program: aplicacion.rb
# Author: Cristhian Fuertes, Fabian Cano, Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co, fabian.cano@correounivalle.edu.co, oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-06-24 19:00

class Evaluador

  $PASO = 2
private
  def crear_diretorios_pruebas
    system("mkdir torneo")
    system("mkdir diversidad")
    system("mkdir elitismo")
  end

  def evaluar_por_torneo
    arg1 = 8
    arg2 = "torneo"
    arg3 = 100000
    5.downto(0){|i|
      linea = "ruby algoritmoGenetico.rb #{arg1} #{arg2} #{arg3}"
      system(linea)
      arg1 += $PASO
    }
  end

  def evaluar_por_diversidad
    arg1 = 8
    arg2 = "diversidad"
    arg3 = 100000
    5.downto(0){|i|
      linea = "ruby algoritmoGenetico.rb #{arg1} #{arg2} #{arg3}"
      system(linea)
      arg1 += $PASO
    }
  end

  def evaluar_por_elitismo
    arg1 = 8
    arg2 = "elitismo"
    arg3 = 100000
    5.downto(0){|i|
      linea = "ruby algoritmoGenetico.rb #{arg1} #{arg2} #{arg3}"
      system(linea)
      arg1 += $PASO
    }
  end

public
  def evaluar
    crear_diretorios_pruebas
    evaluar_por_torneo
    #evaluar_por_diversidad
    #evaluar_por_elitismo
  end
end

if __FILE__ == $PROGRAM_NAME
  ev = Evaluador.new
  ev.evaluar
end
