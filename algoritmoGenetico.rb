#!/home/crisefd/.rvm/rubies/ruby-2.1.5/bin/ruby
# encoding: utf-8
# Program: algoritmoGenetico.rb
# Author: Cristhian Fuertes, Fabian Cano, Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co, fabian.cano@correounivalle.edu.co, oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-05-19 21:20
require 'rubygems'
require 'bundler/setup'
require 'date'

def dd arg
	p arg
 end

=begin
@author Cristhian Fuertes
Crosomoma es un array de genes. o sea, hereda de Array.
Y los genes son números enteros. La posición en el Array indica la columna del tablero
y el contenido indica la fila donde se encuentra la reina en esa columna.
El Cromosoma también debe contener su aptitud.
Al crear y mutar el Cromosoma hay que garantizar que no haya valores de los genes repetidos.
Con esta codificación se asegura que no haya ataques en filas ni en columnas,
y solo queda verificar en diagonales.  Las funciones que tienel cromosoma son:
* Crear cromosomas con nun número de genes dado y con los valores
  Para los genes al azar y sin repetirse
* Mutar un cromosomaa por intercambio de genes
* Cruzar uniformemente un par de cromosomas
=end
class Cromosoma < Array


	#Variable de clase que cuenta la cantidad
	#de veces que se llama a la función
	#evaluar (inicialmente es 0)
	@@num_evaluaciones = 0


	#@!attribute aptitud
	#	@return [Float] un valor <= 0 que mide la aptitud del cromosoma definido como el inverso aditivo del #ataques
	attr_accessor :aptitud

	#@!attribute diversidad
	#	@return [Integer] un valor >= 0 que mide la aptitud del cromosoma definido como la ocurrencia de una aptitud
	attr_accessor :diversidad

	#@!attribute num_genes
	#	@return [Integer] un valor >= 0 que indica la cantidad de genes del cromosoma
	attr_accessor :num_genes

	#Método que da valores al azar a los genes y garantiza
	#que no se repitan.
	#
	#@note La codificación del cromosoma elimina la posibilidad de ataques de reinas
	# por filas o por columnas
	#@return [void]
	def inicializar_genes
		@num_genes = self.length
		@aptitud = 0
		@diversidad = 0
		self.sort_by!{rand()}
	end

	#Método inicializar_genes2
	#
	#@note Este método fue implementado para propositos de pruebas y de depuración. No tiene ningun uso en realidad
	#@return [void]
	def inicializar_genes2
		@num_genes = self.length
		@aptitud = 0
		@diversidad = 0
	end

	#Método de evaluación del cromosoma.
	#Es necesario validar que reinas se estan
	#atancado usando la formula de la pendiente:
	# m = (X2 - X1)/(Y2 - Y1)
	#
	#@return [void]
	#@note Este método altera el estado del objeto Cromosoma
	def evaluar!
		@@num_evaluaciones += 1
		num_ataques = 0
		verificador_ataques = Array.new @num_genes, 0
		for x2 in 0...@num_genes
			y2 = self[x2]
			for x1 in 0...@num_genes
				y1 = self[x1]
				if x1 == x2 then
					next
				end
				m = 1.0 * (x1 - x2) / (y1 - y2)
				if m == -1.0 || m == 1.0 then
					if verificador_ataques[x1] == 0 || verificador_ataques[x2] == 0 then
						verificador_ataques[x1], verificador_ataques[x2] = 1, 1
						num_ataques += 1
					end
				end
			end

		end
		@aptitud = -1.0 * num_ataques
	end

	#Método de clase que cumple la función de getter para la variable de clase del mismo nombre
	#
	#@return [Integer] num_evaluaciones. El número de evaluaciones en los cromosomas
	def self.num_evaluaciones
		@@num_evaluaciones
	end

	#Método de clase que muta el cromosoma por intercambio de genes.
	# Se toman al azar dos genes diferentes en el cromosoma y se intercambian
	#
	#@param cromosoma [Cromosoma] El objeto cromosoma a mutar
	#@return [Cromosoma] cromosoma_mutado. El objeto cromosoma despues de ser mutado
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
  		#p "Cromosoma mutado = #{cromosoma_mutado} "
  		cromosoma_mutado
  	end

  	#Método que realiza cruce uniforme a partir de dos cromosomas
  	#
  	#@param cromosoma1 [Cromosoma] El primer cromosoma padre
  	#@param cromosoma2 [Cromosoma] El segundo cromosoma padre
  	#@return [Cromosoma] nuevo_cromosoma. El cromosoma hijo producto del cruce
  	#@note El cruce uniforme no se usa en practica en este AG. La implementación es solo por razones didacticas
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
Las funciones que tiene son:
* Crear la población con un número de cromosomas dado
* Ejecutar durante un número de generaciones dada.
  En cada generación se hace evaluación de los Cromosomas,
  selección, mutación y reemplazo).
* Evaluar cromosoma: detectar ataques de Reinas en las
  diagonales. Esta función debe retornar el número de ataques
  con signo negativo, y a ello le llamamos "aptitud".
  Lo ideal es llegar a aptitud==0. Si hay ataques,
  la aptitud empeora (se vuelve más negativa).
=end
class NReinas < Array

	#Método que inicializa los cromomosomas
	#
	#@param dimension_tablero [Integer] la magnitud N = cantidad de reinas
	#@return [void]
	def inicializar_cromosomas(dimension_tablero = 8)
		@num_cromosomas = dimension_tablero
		i = 0
		while i < @num_cromosomas do
			array = (0...dimension_tablero).to_a
			cromosoma = Cromosoma.new array
			cromosoma.inicializar_genes
			self[i] = cromosoma
			i += 1
		end
		@mejor_cromosoma = nil
	end

	#Método que ejecuta el AG por generaciones.
	#
	#@param num_generaciones [Integer] La cantidad de generaciones(iteraciones)
	#@param tipo_seleccion [String] Texto que presenta el tipo de selección del AG
	#@return [String]  salida. Texto que contiene la información sobre la ejecución del AG
	def ejecutar(num_generaciones = 50, tipo_seleccion = 'torneo')
		total_generaciones = 0
		tiempo_inicial = Time.now
		1.upto(num_generaciones){|generacion|
			total_generaciones = generacion
			res = evaluar_cromosomas!
			if res == 'detener' then
				break
			elsif res == 'continuar' then
				if generacion < num_generaciones then
					seleccionar_cromosomas! tipo_seleccion
				end
			end

			}
		tiempo_ejecucion = Time.now - tiempo_inicial
		salida = "=======================ENTRADAS===========================\n"
		salida += "La dimension del tablero fue #{@num_cromosomas}\n"
		salida += "El maximo de generaciones fue #{num_generaciones}\n"
		salida += "El tipo de selección fue #{tipo_seleccion}\n"
		salida += "=====================RESULTADOS==========================\n"
		salida += "Recuerde que una posición en la lista representa un columna en el tablero.\n Y el valor en cada posición representa una fila\n\n"
		salida += "El mejor cromosoma con aptitud= #{@mejor_cromosoma.aptitud} fue #{@mejor_cromosoma}\n"
		salida += "El numero de evaluaciones fue  #{Cromosoma.num_evaluaciones} de un total de #{(1..@num_cromosomas).reduce(1, :*)}\n"
		salida += "El total de generaciones fue  #{total_generaciones}\n"
		salida += "El tiempo de ejecución fue de #{tiempo_ejecucion} segundos"
		salida
	end

private
	#Método que itera sobre los cromosomas e
	#invoca su funcion de evaluacion.
	#
	#@return [String] respuesta. Una cadena que indica si se ha alcanzado la mejor aptitud posible (= 0)
	#@note Este método cambia el estado de los cromosomas
	def evaluar_cromosomas!
		respuesta = 'continuar'
		each_index { |i|
			self[i].evaluar!
			if Cromosoma.num_evaluaciones == 1 then
				@mejor_cromosoma = self[0].clone
			elsif self[i].aptitud == 0 then
				@mejor_cromosoma = self[i].clone
				respuesta = 'detener'
				break
			elsif self[i].aptitud >= @mejor_cromosoma.aptitud then
				@mejor_cromosoma = self[i].clone
			end
		 }
		 respuesta
	end

	#Método que determina que cromosomas
	#pasaran a la siguiente generación.
	#
	#Tiene tres modalidades:
	#
	# 1) Se hace selección por torneo escogiendo
	# k = 2 de los cromosomas. Es decir, se toman de a
	# 2 cromosomas por torneo. Al final se mutan los cromosomas ganadores y se
	#insertan a la población, sin eliminar a los anteriores.
	#
	#2) Se hace selección por diversidad. Es decir, se busca
	# cromosoma cuya aptitud tenga la ocurrencia mas baja.
	#
	#3) Tambien es una estrategia mixta entre 1) y 2). Se ordena los cromosomas en función de su diversidad,
	# pero esta vez se aplica elitismo. Se mantienen el 10% de los cromosomas del top y se aplica torneo(con la aptitud)
	# al 90% restante
	#
	#@param tipo_seleccion [String] Texto que representa el tipo de selección del AG
	#@return [void]
	#@note Este método cambia el estado de los cromosomas
	#@note La modalidad 3 es la mejor estrategia para tamaños de entrada grandes
	def seleccionar_cromosomas!(tipo_seleccion)
		if tipo_seleccion == 'torneo'
			seleccionar_por_torneo!
		elsif tipo_seleccion == 'diversidad' then
			seleccionar_por_diversidad!
		elsif tipo_seleccion == 'elitismo' then
			seleccionar_por_elitismo!
	  end
	end

	#Método que selecciona los cromosomas por torneo.
	#Eligiendo dos veces dos cromosomas al azar , comparando su aptitud, mutando
	#a los ganadores e insertandolos en la población
	#
	#@return [void]
	def seleccionar_por_torneo!
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
			#p "cromosoma 1 =#{crom_1}, cromosoma 2=#{crom_2}"
			if crom_1.aptitud > crom_2.aptitud then
				#p "El cromosoma 1 gana"
				delete_at y
				push Cromosoma.mutar(crom_1)
			else
				#p "El cromosoma 2 gana"
				delete_at x
				push Cromosoma.mutar(crom_2)
			end
			}
	end

	#Método que selecciona los cromosomas por diversidad.
	#Eligiendo el cromosoma cuya aptitud tenga la menor ocurrencia para mutarlo
	#e insertanlo en la población.
	#
	#@return [void]
	def seleccionar_por_diversidad!
		aptitudes = Array.new(@num_cromosomas)
		aptitudes.each_index { |i|
			aptitudes[i] = self[i].aptitud
		}
		#p "Aptitudes = #{aptitudes}"
		max = aptitudes.max.to_i
		min = aptitudes.min.to_i
		#p "min #{min}"
		#p "max #{max}"
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
		#p "El cromosoma #{cromosoma} con aptitud= #{cromosoma.aptitud} y diversidad = #{cromosoma.diversidad} es el mejor"
		self.delete_at ind_1
		self.push Cromosoma.mutar(cromosoma)
	end

	#Método mixto (con torneo y diversidad). Los cromosomas se ordenan
	#ascendentemente deacuerdo a su diversidad. El 10% que se encuentre en el top
	#se mantienen para la siguiente genereación y el 90% restante son sometidos a
	#torneo por aptitud
	#
	#@return [void]
	def seleccionar_por_elitismo!
		aptitudes = Array.new(@num_cromosomas)
		aptitudes.each_index { |i|
			aptitudes[i] = self[i].aptitud
		}
		max = aptitudes.max.to_i
		min = aptitudes.min.to_i
		array_cuentas = Array.new -1 * min, 0
		aptitudes.each{|aptitud|
			k = (-1 * aptitud.to_i) - 1
			array_cuentas[k] += 1
		}
		each_index{|i|
			k = (-1 * aptitudes[i].to_i) - 1
			self[i].diversidad = array_cuentas[k]
		}

		cromosomas_ordenados = self.sort{|crom_izq, crom_der| crom_izq.diversidad <=> crom_der.diversidad}
		#p "Cromosomas ordenado #{cromosomas_ordenados}"
		p = (0.1 * @num_cromosomas).to_i
		banderas_crom_elitistas = Array.new @num_cromosomas, 0
		for i in 0..p
			banderas_crom_elitistas[i] = 1
		end

		k = 2
		x = -1
		y = -1
		k.downto(1) { |n|
			while true do
				x = rand(0...@num_cromosomas)
				y = rand(0...@num_cromosomas)
				#p "x = #{x}, y= #{y}"
				if x != y && banderas_crom_elitistas[x] == 0 && banderas_crom_elitistas[y] == 0 then
					break
				end
			end
			#p "x = #{x}, y= #{y}"
			crom_1 = self[x]
			crom_2 = self[y]
			#p "cromosoma 1 =#{crom_1}, cromosoma 2=#{crom_2}"
			if crom_1.aptitud > crom_2.aptitud then
			#	p "El cromosoma 1 gana"
				delete_at y
				push Cromosoma.mutar(crom_1)
			else
				#p "El cromosoma 2 gana"
				delete_at x
				push Cromosoma.mutar(crom_2)
			end
		}
	end

end


=begin
@author Oscar Tigreros
Clase principal de la aplicacion.
Realiza funciones de entrada de datos por consola
y escritura de los resultados en archivos de texto plano
=end
class AG_NReinas

	#Constructor de la clase principal del AG.
	#Toma el vector de argumentos e inicializa las variables de entrada
	#
	#@return [void]
	def initialize
		@dimension_tablero = ARGV[0].to_i
		@tipo_seleccion = ARGV[1]
		@generaciones = ARGV[2].to_i
		@bandera = ARGV[3].to_i
		if @tipo_seleccion == "t" then
			@tipo_seleccion = "torneo"
		elsif @tipo_seleccion == "d" then
			@tipo_seleccion = "diversidad"
		elsif @tipo_seleccion == "e" then
			@tipo_seleccion = "elitismo"
		end
	end

	#Método principal del  AG.
	#Inicialializa y ejecuta el AG, ademas de
	#guardar los resultados en archivos
	#
	#@return [void]
	def ejecutar_AG
		nr = NReinas.new
		nr.inicializar_cromosomas @dimension_tablero
		txt_salida = nr.ejecutar @generaciones, @tipo_seleccion
		nombre_arch = ""
		if @tipo_seleccion == "torneo" then
			system("cd torneo")
			num_arch = Dir.glob(File.join(Dir.pwd, "**", "*")).count
			nombre_arch = ''
			if @bandera == 0 then
				nombre_arch = "torneo/#{num_arch + 1}"
			elsif @bandera == 1 then
				nombre_arch = "torneo/#{num_arch}"
		end
			system("cd ..")
		elsif @tipo_seleccion == "diversidad" then
			system("cd diversidad")
			num_arch = Dir.glob(File.join(Dir.pwd, "**", "*")).count
			nombre_arch = ''
			if @bandera == 0 then
				nombre_arch = "diversidad/#{num_arch + 1}"
			elsif @bandera == 1 then
				nombre_arch = "diversidad/#{num_arch}"
		end
			system("cd ..")
		elsif @tipo_seleccion == "elitismo" then
			system("cd elitismo")
			nombre_arch = ''
			if @bandera == 0 then
				nombre_arch = "elitismo/#{num_arch + 1}"
			elsif @bandera == 1 then
				nombre_arch = "elitismo/#{num_arch}"
		end
			system("cd ..")
		end
		archivo_salida = open(nombre_arch, 'w')
		archivo_salida.write(txt_salida)
		archivo_salida.close
	end


end


if __FILE__ == $PROGRAM_NAME
	if ARGV.size != 4 then
		p "Error de argumentos, se esperaban 3 se recibieron #{ARGV.size}"
		abort
	end
	ag = AG_NReinas.new
	ag.ejecutar_AG
end
