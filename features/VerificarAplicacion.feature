# language: es
# encoding: utf-8
# Archivo: VerificarCuentaBancaria.feature
# Autor: Fabian Andres Cano
# Email:  fabian.cano@correounivalle.edu.co
# Fecha creación: 2015-06-06
# Fecha última modificación: 2015-06-06
# Versión: 0.2
# Licencia: GPL

Característica: Ejecutar correctamente el algoritmo genetico del problema de n reinas con las caracteristicas enseñadas en el curso Computacion Evolutiva

  Antecedentes: Crear un cromosoma
    Dado que se necesita un cromosoma este se crea

  Escenario: Verificar que un cromosoma tenga sus genes distintos
    Cuando miro dos genes del cromosoma
    Entonces debe decir que no son iguales

  Escenario: Verificar que funcione la mutacion de un cromosoma
    Cuando miro un cromosoma y su respectiva mutacion
    Entonces debe decir que estos cromosomas son distintos

  Escenario: Verificar que funcione el cruce uniforme
    Cuando miro dos cromosomas y su cromosoma hijo
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
