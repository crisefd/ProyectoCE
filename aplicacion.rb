#!/home/crisefd/.rvm/rubies/ruby-2.1.5/bin/ruby
# encoding: utf-8
# Program: aplicacion.rb
# Author: Cristhian Fuertes, Fabian Cano, Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co, fabian.cano@correounivalle.edu.co, oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-05-19 21:20
require 'rubygems'
require 'bundler/setup'



=begin
@author Cristhian Fuertes
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
* Mutar un cromosomaa por intercambio de genes
* Cruzar uniformemente un par de cromosomas 
=end
class Cromosoma < Array


	#Variable de clase que cuenta la cantidad
	#de veces que se llama a la función
	#evaluar
	@@num_evaluaciones = 0
	
	#Se define el atributo aptitude del cromosoma, al igual
	#que los métodos de acceso
	attr_accessor :aptitud, :diversidad, :num_genes
	
	#Método que da valores al azar a los genes y garantiza
	#que no se repitan
	def inicializar_genes
		@num_genes = self.length
		@aptitud = 0
		@diversidad = 0
		self.sort_by!{rand()}
	end

	#Método de evaluacion del cromosoma
	#es necesario validar que reinas se estan
	#atancado usando la formula de la pendiete:
	# m = (X2 - X1)/(Y2 - Y1)
	#@note Este método altera el estado del objeto Cromosoma
	

	def evaluar!
		@@num_evaluaciones += 1
		num_ataques = 0
		for x2 in 0...@num_genes
			y2 = self[x2]
			for x1 in 0...@num_genes 
				y1 = self[x1]
				if x1 == x2 then
					next
				end
				m = 1.0 * (x1 - x2) / (y1 - y2)
				#p "Resultado de evaluacion para cromosoma #{self} es m =#{m}"
				if m == -1.0 || m == 1.0 then
					p "Ataque x1=#{x1}, x2= #{x2}, y1=#{y1}, y2=#{y2}"
					num_ataques += 1
				end
			end

		end
		@aptitud = -0.5 * num_ataques
		p "Evaluando #{self} Aptitud = #{@aptitud}"
		
	end

	#Método getter para la variable de clase
	# del numero de evaluaciones
	#@return num_evaluaciones [Integer] El numero de evaluaciones en los cromosomas
	def self.num_evaluaciones
		@@num_evaluaciones
	end
	
	#Método que muta el cromosoma por intercambio de genes.
	#@param cromosoma [Cromosoma] El objeto cromosoma a mutar
	#@return cromosoma_mutado [Cromosoma] El cromosoma despues de ser mutado
  	def self.mutar(cromosoma)
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
  	
  	#Funcion de cruce uniforme
  	#@param cromosoma1 [Cromosoma] El primer cromosoma padre
  	#@param cromosoma2 [Cromosoma] El segundo cromosoma padre
  	#@return nuevo_cromosoma [Cromosoma] El cromosoma hijo producto del cruce
	def self.cruzar(cromosoma1, cromosoma2)
		nuevo_cromosoma = Cromosoma.new cromosoma1.length
		iteraciones = cromosoma1.num_genes - 1
		iteraciones.downto(0){|i|
  		bit = rand(0..1)
  		if bit == 0 then
  			nuevo_cromosoma[i] = cromosoma1[i]
  		elsif bit == 1 then
  			nuevo_cromosoma[i] = cromosoma2[i]
  		end
  	}
  	nuevo_cromosoma
	end


end

=begin 
@author Cristhian Fuertes
NReinas hereda de Array y almacena cromosomas.
Las funciones que debe tener son, al menos:
* Crear la población con un numero de cromosomas dado
* Ejecutar (durante un número de generaciones dada; 
   y en cada generación se hace evaluación de los Cromosomas, 
   selección, mutación y reemplazo).
* Evaluar cromosoma:detectar ataques de Reinas en las 
  diagonales. Esta función debe retornar el número de ataques 
  con signo negativo, y a ello le llamamos "aptitud". 
  Lo ideal es llegar a aptitud==0. Si hay ataques, 
  la aptitud empeora (se vuelve más negativa).
=end
class NReinas < Array

	#Método que inicializa los cromomosomas
	#@param dimension_tablero [Integer] la magnitud N
	def inicializar_cromosomas(dimension_tablero = 8)
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
		p "Cromosomas iniciales #{self}"
	end

	#Método que ejecuta el AG por generaciones. 
	#@param num_generaciones [Integer] La cantidad de generaciones(iteraciones)
	#@param tipo_seleccion [String] Texto que presenta el tipo de selección del AG
	def ejecutar(num_generaciones = 50, tipo_seleccion = 'torneo')
		p "Ejecutando con num generaciones = #{num_generaciones} y con tipo de seleccion = #{tipo_seleccion}"
		1.upto(num_generaciones){|generacion|
			p "============> Generacion : #{generacion}"
			evaluar_cromosomas!
			if generacion < num_generaciones then
				seleccionar_cromosomas! tipo_seleccion
			end
			}
		mejor_crom = encontrar_mejor_cromosoma
		p "=====================RESULTADOS=========================="
		p "El mejor cromosoma con aptitud= #{mejor_crom.aptitud} es #{mejor_crom}"
		p "El numero de evaluaciones fue de #{Cromosoma.num_evaluaciones}"
	end
	
	#Método que retorna el mejor cromosoma y su aptitud
	#@return crom el mejor cromosoma
	def encontrar_mejor_cromosoma
		p "Encontrando mejor cromosoma"
		crom = self[0].clone
		p "crom inicialmente es #{crom}"
		each{|cromosoma|
			p "cromosoma que esta siendo iterado #{cromosoma}"
			if cromosoma.aptitud >= crom.aptitud then
				crom = cromosoma.clone
				p "crom cambian a #{crom}"
			end
		}
		crom
	end

	#Método que itera sobre los cromosomas e
	#invoca su funcion de evaluacion.
	#@note Este método cambia el estado de los cromosomas
	def evaluar_cromosomas!
		each_index { |i| 
			self[i].evaluar!
		 }
	end

	#Método que determina que cromosomas
	#pasaran a la siguiente generacion.Tiene dos modalidades:
	# 1)Se hace seleccion por torneo escogiendo
	#k = 2 de los cromosomas y se toman de a
	# 2 cromosomas por torneo. Al final se insertan
	# los mutados a la población.
	#2)Se hace selección por diversidad. Es decir, se busca el
	# cromosoma cuya aptitud tenga la ocurrencia mas baja.
	#@param tipo_seleccion [String] Texto que representa el tipo de selección del AG
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
					delete_at(y)
					push(Cromosoma.mutar(crom_1))
				else
					p "El cromosoma 2 gana"
					delete_at(x)
					push(Cromosoma.mutar(crom_2))
				end
			  }
		elsif tipo_seleccion == 'diversidad' then
			aptitudes = Array.new(@num_cromosomas)
			aptitudes.each_index { |i|
				aptitudes[i] = self[i].aptitud  
			}
			#p "Aptitudes = #{aptitudes}"
			max = aptitudes.max.to_i
			min = aptitudes.min.to_i
			#p "min #{min}"
			#p "max #{max}"
			fix_num_max = (2**(0.size * 8 -2) -1)
			array_cuentas = Array.new -1 * min, 0
			aptitudes.each{|aptitud|
				k = (-1 * aptitud.to_i) - 1
				array_cuentas[k] += 1
			}
			#p "Array cuentas = #{array_cuentas}"
			my_min = lambda{|array|
				min_ = array.max
				array.each{|e|
				if e <= min_ && e > 0 then
					min_ = e
				end
				}
				return min_
			}
			min_cuentas = my_min.call array_cuentas
			#p "min_cuentas = #{min_cuentas}"
			ind_1 = array_cuentas.index(min_cuentas)
			#p "ind_1 = #{ind_1}"
			#ind_2 = aptitudes[ind_1]
			ind_2 = aptitudes.index((-1.0 * (ind_1 + 1)))
			#p "ind_2 = #{ind_2}, aptitudes[ind_2] = #{aptitudes[ind_2]}"
			cromosoma = self[ind_2].clone
			cromosoma.diversidad = min_cuentas
			p "El cromosoma #{cromosoma} con aptitud= #{cromosoma.aptitud} y diversidad = #{cromosoma.diversidad} es el mejor"
			self.delete_at(ind_1)
			self.push(Cromosoma.mutar(cromosoma))
			
	    end
	end
end


=begin
@author Oscar Tigreros
Clase principal de la aplicacion.
Realiza funciones de entrada de datos por consola
=end
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
	
	#Método principal del  AG
	def ejecutar_AG
		nr = NReinas.new
		nr.inicializar_cromosomas @tamaño
		nr.ejecutar @num_generaciones, @tipo
	end
	
	
end



#ag = AG_NReinas.new
#ag.ejecutar_AG

c = Cromosoma.new [3, 2, 0, 1]
c.num_genes = 4
c.evaluar!
p "apt: #{c.aptitud}"
