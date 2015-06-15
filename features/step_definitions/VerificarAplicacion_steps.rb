# encoding: utf-8
# Archivo: VerificarAplicacion_steps.rb
# Autor: Fabian Andres Cano
# Email:  fabian.cano@correounivalle.edu.co
# Fecha creación: 2015-06-06
# Fecha última modificación: 2015-06-06
# Versión: 0.3
# Licencia: GPL

Dado /^que se necesita un cromosoma este se crea$/ do
  array = (0...10).to_a
  @cromosoma = Cromosoma.new array
  @cromosoma.inicializar_genes
end


Cuando /^miro dos genes del cromosoma$/ do
  posicion1=rand(10)
  posicion2=rand(10)
  while(posicion1==posicion2) do
      posicion2=rand(10)
  end
  @gen1 = @cromosoma[posicion1]
  @gen2 = @cromosoma[posicion2]
end


Entonces /^debe decir que no son iguales$/ do
 @iguales=false
 if @gen1==@gen2 then
    @iguales=true
 expect(@iguales).to be false
 end
end

Cuando /^miro un cromosoma y su respectiva mutacion$/ do
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
 Cuando /^miro dos cromosomas y su cromosoma hijo$/ do
  array = (0...10).to_a
  @cromosoma1 = Cromosoma.new array
  @cromosoma1.inicializar_genes
  @cromosoma2 = Cromosoma.new array
  @cromosoma2.inicializar_genes
  @cromosomaHijo= Cromosoma.cruzar(@cromosoma1,@cromosoma2)

end


Entonces /^debe decir que cada gen del cromosoma hijo hace parte del cromosoma padre o madre$/ do
  @contador=0
  @iguales=true
  while @contador<10 do
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

