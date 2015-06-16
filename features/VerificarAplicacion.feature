# language: es
# encoding: utf-8
# Archivo: VerificarCuentaBancaria.feature
# Autor: Fabian Andres Cano
# Email:  fabian.cano@correounivalle.edu.co
# Fecha creación: 2015-06-15
# Fecha última modificación: 2015-06-15
# Versión: 0.2
# Licencia: GPL

Característica: Ejecutar correctamente el algoritmo genetico del problema de n reinas con las caracteristicas enseñadas en el curso Computacion Evolutiva


  Escenario: Verificar que un cromosoma tenga sus genes distintos
    Cuando creo un cromosoma de tamano 10
    Entonces debe decir que todos sus genes son distintos y son valores entre 0 y N-1

  Escenario: Verificar que funcione la mutacion de un cromosoma
    Cuando creo un cromosoma y su respectiva mutacion de tamano 10 
    Entonces debe decir que estos cromosomas son distintos

  Escenario: Verificar que funcione el cruce uniforme
    Cuando creo dos cromosomas y su cromosoma hijo de tamano 10 
    Entonces debe decir que cada gen del cromosoma hijo hace parte del cromosoma padre o madre

  Escenario: Verificar que se evaluen correctamente los ataques entre reinas
    Cuando el tablero es 
|   | X |   |   |
|   |   | X |   |
|   |   |   | X |
| X |   |   |   |
    Entonces al evaluarlo debe dar 3 conflicto 

   Escenario: Verificar que se evaluen correctamente los ataques entre reinas
    Cuando el tablero es 
|   | X |   |   |
|   |   | X |   |
| X |   |   |   |
|   |   |   | X |
    Entonces al evaluarlo debe dar 1 conflicto 

   Escenario: Verificar que se evaluen correctamente los ataques entre reinas
    Cuando el tablero es 
| X |   |   |   |
|   | X |   |   |
|   |   | X |   |
|   |   |   | X |
    Entonces al evaluarlo debe dar 3 conflicto 

   Escenario: Verificar que se evaluen correctamente los ataques entre reinas
    Cuando el tablero es 
|   |   | X |   |
| X |   |   |   |
|   |   |   | X |
|   | X |   |   |
    Entonces al evaluarlo debe dar 0 conflicto 

   Escenario: Verificar que se evaluen correctamente los ataques entre reinas
    Cuando el tablero es 
|   |   | X |   |   |
|   | X |   |   |   |
| X |   |   |   |   |
|   |   |   | X |   |
|   |   |   |   | X |
    Entonces al evaluarlo debe dar 4 conflicto 
