#!/home/crisefd/.rvm/rubies/ruby-2.1.5/bin/ruby
# encoding: utf-8
# Program: aplicacion.rb
# Author: Cristhian Fuertes, Fabian Cano, Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co, fabian.cano@correounivalle.edu.co, oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-05-19 21:20
require 'rubygems'
require 'bundler/setup'

=begin
Crosomoma es un array de genes. o sea, hereda de Array. 
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

  #Se define el atributo aptitude del cromosoma, la igual
  #que los métodos de acceso
  attr_accessor :aptitud, :num_genes

  #Da valores al azar a los genes y garantiza
  #que no se repitan
  def inicializar_genes()
  	@num_genes = self.length
  	@aptitud = 0
  	self.sort_by!{rand()}
  end

  #Muta el cromosoma por intercambio de genes
  def mutar
  	pos1 = rand(0...@num_genes)
  	pos2 = -1
  	while true do
  		pos2 = rand(0...@num_genes)
  		if pos1 != pos2 then
  			break
  		end
  	end
  	self[pos1], self[pos2] = self[pos2], self[pos1]
  	end

  

  #Funcion de cruce uniforme
  def cruzar!(cromosoma)
  	#mascara = Array.new
  	copia_cromosoma = Array.new(self)
  	iteraciones = @num_genes - 1
  	iteraciones.downto(0){|i|
  		bit = rand(0..1)
  		if bit == 0 then
  			self[i] = copia_cromosoma[i]
  		elsif bit == 1 then
  			self[i] = cromosoma[i]
  		end

  		
  	}

  end


  	#Funcion de evaluacion del cromosoma
  	#Es necesario validar que reinas se estan
	#Atancado usando la formula de la pendiete:
	# m = (X2 - X1)/(Y2 - Y1)
   def evaluar!()
		num_ataques = 0
		for y2 in 0...@num_genes
			x2 = self[y2]
			for y1 in 0...@num_genes 
				x1 = self[y1]
				if y1 == y2 then
					next
				end
				m = 1.0 * (x2 - x1) / (y2 - y1)
				if m == -1.0 then
					num_ataques += 1
				end
			end

		end
		@aptitud = -1.0 * num_ataques
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

	def inicializar_cromosomas(dimension_tablero = 8)
		@num_cromosomas = self.length
		i = 0
		while i < @num_cromosomas do
			array = (0...dimension_tablero).to_a
			cromosoma = Cromosoma.new array
			cromosoma.inicializar_genes
			self[i] = cromosoma
			i += 1
		end
	end

	#Funcion principal del algoritmo. 
	#num_generaciones = iteraciones
	def ejecutar(num_generaciones = 50)

	end

	
	

	#Funcion que determina que cromosomas
	#Pasaran a la siguiente generacion.
	# Se hace seleccion por torneo escogiendo
	#k = 40% de los cromosomas y se toman de a
	# 2 cromosomas por torneo
	def seleccionar_cromosomas!
		k = (0.4 * @num_cromosomas).to_i
		k.downto(0) { |n|
			while true do
				x = rand(0...@num_cromosomas)
				y = rand(0...@num_cromosomas)
				if x == y then
					break
				end
			end
			crom_1 = self[x]
			crom_2 = self[y]
			if crom_1.aptitud > crom_2.aptitud then
				self.delete_at(y)
			else
				self.delete_at(x)
			end
			@num_cromosomas -= 1
		  }
	end
end

nr = NReinas.new
nr.inicializar_cromosomas
nr.ejecutar

