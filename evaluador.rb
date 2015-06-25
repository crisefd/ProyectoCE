#!/home/crisefd/.rvm/rubies/ruby-2.1.5/bin/ruby
# encoding: utf-8
# Program: aplicacion.rb
# Author: Cristhian Fuertes, Fabian Cano, Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co, fabian.cano@correounivalle.edu.co, oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-06-24 19:00

class Evaluador
  def evaluar
    arg1 = 8
    arg2 = "torneo"
    arg3 = 1000
    linea = "ruby algoritmoGenetico.rb #{arg1} #{arg2} #{arg3}"
    system(linea)
  end
end
if __FILE__ == $PROGRAM_NAME
  ev = Evaluador.new
  ev.evaluar
end
