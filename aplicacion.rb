#!/home/crisefd/.rvm/rubies/ruby-2.1.5/bin/ruby
# encoding: utf-8
# Program: aplicacion.rb
# Author: Cristhian Fuertes, Fabian Cano, Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co, fabian.cano@correounivalle.edu.co, oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-05-19 21:20
require 'rubygems'
require 'bundler/setup'

=begin
Crosomoma es un array de genes. O sea, hereda de Array. 
Y los genes son números enteros. La posición en el Array indica la columna del tablero 
y el contenido indica la fila donde se encuentra la Reina en esa columna. 
El Cromosoma también debe contener su aptitud. 
Al crear y mutar el Cromosoma hay que garantizar que no haya valores de los genes repetidos. 
Con esta codificación se asegura que no haya ataques en filas ni en columnas, 
y solo queda verificar en diagonales.  Las funciones que debe tener el Cromosoma son, 
al menos:
* Crear cromosomas con nun numero de genes dado y con los valores
  Para los genes al azar y sin repetirse
* Mutar por intercambio de genes
* Cruce uniforme 	
=end
class Cromosoma < Array
  attr_accessor :aptitud

  def inicializar_genes()
  	self.sort_by!{rand()}
  	puts self
  end
end

=begin 
NReinas hereda de array y almacena cromosomas.
Las funciones que debe tener son, al menos:
* Crear la población con un numero de cromosomas dado
* Ejecutar (durante un número de generaciones dada; 
   y en cada generación se hace evaluación de los Cromosomas, 
   selección, mutación y reemplazo).
* Evaluar cromosoma:Esta es la función más laboriosa, 
  donde deben pensar como detectar ataques de Reinas en las 
  diagonales. Esta función debe retornar el número de ataques 
  con signo negativo, y a ello le llamamos "aptitud". 
  Lo ideal es llegar a aptitud==0. Si hay ataques, 
  la aptitud empeora (se vuelve más negativa).
=end
class NReinas < Array

	def inicializar_cromosomas(num_cromosomas=10)
		@num_cromosomas = num_cromosomas
		i = 0
		while i < self.length do
			#rand_array = (0..@n).collect{rand(@n)}
			array = (0...@num_cromosomas).to_a
			cromosoma = Cromosoma.new array
			cromosoma.inicializar_genes
			cromosoma.aptitud = 0
			self[i] = cromosoma
			#puts "==========="
			i += 1
		end
	end
end

nr = NReinas.new
nr.inicializar_cromosomas
