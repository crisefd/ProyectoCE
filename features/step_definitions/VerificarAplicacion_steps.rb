# encoding: utf-8
# Archivo: VerificarAplicacion_steps.rb
# Autor: Fabian Andres Cano
# Email:  fabian.cano@correounivalle.edu.co
# Fecha creación: 2015-06-15
# Fecha última modificación: 2015-06-15
# Versión: 0.3
# Licencia: GPL


Cuando /^creo un cromosoma de tamano (.+?)$/ do |tamano|
  tamanoCromosoma=tamano.to_i
  array = (0...tamanoCromosoma).to_a
  @cromosoma = Cromosoma.new array
  @cromosoma.inicializar_genes
end


Entonces /^debe decir que todos sus genes son distintos y son valores entre 0 y N-1$/ do
 @iguales=false
 contador=0
 contadorInterno=1
 while contador<@cromosoma.size do
   while contadorInterno<@cromosoma.size do
      if @cromosoma[contador]==@cromosoma[contadorInterno] or @cromosoma[contador]>@cromosoma.size then
         @iguales=true
         contador=@cromosoma.size
         contadorInterno=@cromosoma.size
      end
      contadorInterno=contadorInterno+1
   end
 contador=contador+1
 contadorInterno=contador+1
 end
 expect(@iguales).to be false
end

Cuando /^creo un cromosoma y su respectiva mutacion de tamano (.+?)$/ do |tamano|
  tamanoCromosoma=tamano.to_i
  array = (0...tamanoCromosoma).to_a
  @cromosoma = Cromosoma.new array
  @cromosoma.inicializar_genes
  @mutacion=Cromosoma.mutar(@cromosoma)
end


Entonces /^debe decir que estos cromosomas son distintos$/ do
  @contador=0
  @distintos=false
  while @contador<10 do
  	if @mutacion[@contador]!=@cromosoma[@contador] then
           @distintos=true
  	   break
        end
        @contador=@contador+1
  end
 expect(@distintos).to be true
 end
 Cuando /^creo dos cromosomas y su cromosoma hijo de tamano (.+?)$/ do |tamano|
  tamanoCromosoma=tamano.to_i
  array = (0...tamanoCromosoma).to_a
  @cromosoma1 = Cromosoma.new array
  @cromosoma1.inicializar_genes
  @cromosoma2 = Cromosoma.new array
  @cromosoma2.inicializar_genes
  @cromosomaHijo= Cromosoma.cruzar(@cromosoma1,@cromosoma2)

end


Entonces /^debe decir que cada gen del cromosoma hijo hace parte del cromosoma padre o madre$/ do
  @contador=0
  @iguales=true
  while @contador<@cromosoma1.size do
  	if @cromosoma1[@contador] != @cromosomaHijo[@contador]  and @cromosoma2[@contador] != @cromosomaHijo[@contador] then
           @iguales=false
  	   break
        end
        @contador=@contador+1
  end
 expect(@iguales).to be true
 end

Cuando /^el tablero es$/ do |tabla|
   @tablero = tabla.raw
end


Entonces /^al evaluarlo debe dar (.+?) conflicto$/ do |conflictosEsperados|
 @conflictos=1
 @contadorFilas=0
 @contadorColumnas=0
 @filas=@tablero.size
 @columnas=@tablero.size
 array =  Array.new(@columnas, 0)
 while @contadorFilas<@filas do
       while @contadorColumnas<@columnas do
             @tableroFila=@tablero[@contadorFilas]
             if @tableroFila[@contadorColumnas]=="X" then
                array[@contadorColumnas]=array[@contadorColumnas]+@contadorFilas
             end
             @contadorColumnas=@contadorColumnas+1
             end
 @contadorColumnas=0
 @contadorFilas=@contadorFilas+1
 end

@cromosomaNuevo = Cromosoma.new array
 @cromosomaNuevo.inicializar_genes2
 @conflictos=-1*@cromosomaNuevo.evaluar!
 expect(@conflictos.to_i).to eq conflictosEsperados.to_i
 end
