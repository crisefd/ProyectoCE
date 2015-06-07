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


  #Variable de clase que cuenta la cantidad
  # de veces que se llama a la función
  #evaluar
  @@num_evaluaciones = 0

  #Se define el atributo aptitude del cromosoma, la igual
  #que los métodos de acceso
  attr_accessor :aptitud, :diversidad,:num_genes

  #Da valores al azar a los genes y garantiza
  #que no se repitan
  def inicializar_genes()
  	@num_genes = self.length
  	@aptitud = 0
  	@diversidad = 0
  	self.sort_by!{rand()}
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
   def evaluar!
   		@@num_evaluaciones += 1
		num_ataques = 0
		for y2 in 0...@num_genes
			x2 = self[y2]
			for y1 in 0...@num_genes 
				x1 = self[y1]
				if y1 == y2 then
					next
				end
				m = 1.0 * (x2 - x1) / (y2 - y1)
				#p "Resultado de evaluacion para cromosoma #{self} es m =#{m}"
				if m == -1.0 then
					num_ataques += 1
				end
			end

		end
		@aptitud = -1.0 * num_ataques
	end

	#Metodo getter para la variable de clase
	# del numero de evaluaciones
	def self.num_evaluaciones
		@@num_evaluaciones
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
		#p "Inicializando #{dimension_tablero} cromosomas"
		@num_cromosomas = dimension_tablero
		p "Inicializando con num cromosomas = #{@num_cromosomas}"
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
	def ejecutar(num_generaciones = 50, tipo_seleccion = 'torneo')
		p "Ejecutando con num generaciones = #{num_generaciones} y con tipo de seleccion = #{tipo_seleccion}"
		if tipo_seleccion == 'torneo' then
			1.upto(num_generaciones){|generacion|
				p "============> Generacion : #{generacion}"
				evaluar_cromosomas!
				seleccionar_cromosomas! tipo_seleccion
				}
			mejor_apt, mejor_crom = encontrar_mejor_cromosoma
			p "El mejor cromosoma con aptitud= #{mejor_apt} es #{mejor_crom}"
		elsif tipo_seleccion == 'diversidad' then
			p "Falta implementar"
		end
	end
	
	#Funcion que retorna el mejor cromosoma y su aptitud
	def encontrar_mejor_cromosoma
		apt = self[0].aptitud
		cro = self[0]
		each{|cromosoma|
			if cromosoma.aptitud >= apt then
				cro = cromosoma
				apt = cromosoma.aptitud
			end
		}
		return apt, cro
	end


	def evaluar_cromosomas!
		self.each_index { |i| 
			self[i].evaluar!
		 }
	end

	#Muta el cromosoma por intercambio de genes
  	def mutar(cromosoma)
  		cromosoma_mutado = cromosoma.clone
  		pos1 = rand(0...cromosoma_mutado.num_genes)
  		pos2 = -1
  		while true do
  			pos2 = rand(0...cromosoma_mutado.num_genes)
  			if pos1 != pos2 then
  				break
  			end
  		end
  		cromosoma_mutado[pos1], cromosoma_mutado[pos2] = cromosoma_mutado[pos2], cromosoma_mutado[pos1]
  		p "Cromosoma mutado = #{cromosoma_mutado} "
  		cromosoma_mutado
  	end

	
	

	#Funcion que determina que cromosomas
	#Pasaran a la siguiente generacion.
	# Se hace seleccion por torneo escogiendo
	#k = 2 de los cromosomas y se toman de a
	# 2 cromosomas por torneo. Al final se insertan
	# los mutados a la población
	def seleccionar_cromosomas!(tipo_seleccion)
		p "Seleccionando cromosomas"
		if tipo_seleccion == 'torneo'
			k = 2
			x = -1
			y = -1
			k.downto(1) { |n|
				while true do
					x = rand(0...@num_cromosomas)
					y = rand(0...@num_cromosomas)
					#p "x = #{x}, y= #{y}"
					if x != y then
						break
					end
				end
				#p "x = #{x}, y= #{y}"
				crom_1 = self[x]
				crom_2 = self[y]
				p "cromosoma 1 =#{crom_1}, cromosoma 2=#{crom_2}"
				if crom_1.aptitud > crom_2.aptitud then
					p "El cromosoma 1 gana"
					self.delete_at(y)
					self.push(mutar(crom_1))
				else
					p "El cromosoma 2 gana"
					self.delete_at(x)
					self.push(mutar(crom_2))
				end
			  }
		elsif tipo_seleccion == 'diversidad'
			#p "Falta implementar"
			aptitudes = Array.new(@num_cromosomas)
			aptitudes.each_index { |i|
				aptitudes[i] = self[i].aptitud  
			}
			max = aptitudes.max
			min = aptitudes.min
			array_cuentas = Array.new(-1 * min)
			aptitudes.each{|aptitud|
				array_cuentas[-1 * aptitud] += 1
			}

			ind_1 = array_cuentas.index(array_cuentas.min)
			ind_2 = aptitudes.index(-1 * ind_1)
			cromosoma = self[ind_2].clone
			self.delete_at(ind_2)
			self.push(mutar(cromosoma))
			
	    end
	end
end

#Clase principal de la aplicacion.
#Realiza funciones de entrada de datos por consola
class AG_NReinas
	
	#Constructor que instancia los parametros para el AG
	def initialize
		while true do
			puts "¿Tamaño del tablero?"  
			STDOUT.flush  
			tamaño = gets.chomp  
			if tamaño == '' then
				@tamaño = 8
				break
			else
				begin
					@tamaño = tamaño.to_i
					break
				rescue
					next
				end
			end
		end
		while true do
			puts "¿Tipo de seleccion (torneo/diversidad)?"
			tipo = gets.chomp
			if tipo == '' || tipo == 'torneo'then
				@tipo = 'torneo'
				break
			elsif tipo == 'diversidad' then
				@tipo = 'diversidad'
				break
			else
				next
			end
		end
		while true do
			puts "¿Numero de generaciones?"
			num_generaciones = gets.chomp
			if num_generaciones == '' then
				@num_generaciones = 50
				break
			else
				begin
					@num_generaciones = num_generaciones.to_i
					break
				rescue
					next
				end
			end
		end

	end
	
	#Metodo que ejecuta el AG
	def ejecutar_AG
		nr = NReinas.new
		nr.inicializar_cromosomas @tamaño
		nr.ejecutar @num_generaciones, @tipo
	end
	
	
end



ag = AG_NReinas.new
ag.ejecutar_AG
