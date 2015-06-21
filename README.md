# ProyectoCE
Proyecto final del curso de Computación Evolutiva de la Escuela de Ingeniería de Sistemas y Computación de la Universidad del Valle(Colombia)

El trabajo consiste en escribir un algoritmo genético (GA) en paradigma OO y lenguaje Ruby,siguiendo una metodología de desarrollo ágil basada en pruebas (Cucumber), y aplicarlo para resolver un problema fácil parametrizado en el tamaño del problema N, concretamente las N-damas: 
en un tablero de ajedrez de NxN casillas, colocar N damas de modo que no se ataquen mutuamente. 



Final project of the course of Evolutionary Computation, School of Systems Engineering and computation of the Universidad del Valle (Colombia)

The objective of this project is to write a genetic algorithm (GA) using the Ruby programming language, following an agile development methodology based on evidence (Cucumber), and apply it to solve an easy problem parameterized in the problem size N, namely N Queen Puzzle:
an NxN chessboard squares, place N queens so as not to attack one another.


Para la instalación de Ruby y Cucumber sistemas operativos basados en Debian, siga los siguientes pasos:


To install Ruby and Cucumber in any Debain base operating , follow these steps:


# Instalación de rvm  ruby, cucumber, etc.
La forma sofisticada (si vamos a trabajar con frecuencia con este lenguaje, para poder manejar en cada proyecto distintas versiones del compilador y de las gemas):

Se instalan en una cuenta normal, sin permisos de root. Ojo: no poner "sudo" delante. La documentación de rvm (manejador de versiones de Ruby) está en https://rvm.io/


1) Abrir la terminal

	$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

Si lo anterior no funciona, intente:

	$ curl -sSL https://rvm.io/mpapis.asc | gpg --import -

2) 

	$ curl -sSL https://get.rvm.io | bash -s stable

3)

	$ source ~/.rvm/scripts/rvm

4)

	$ sudo apt-get update

5) Se instala la versión 2.1.5 de Ruby

	$ rvm install 2.1.5

6)

	$ rvm docs generate-ri

7) Se especifica la versión que se usara en el proyecto

	$ rvm use 2.1.5

8) Se instalan las gemas del proyecto

	$ gem install rspec cucumber bundler yard

9)Para que gedit coloree adecuadamente los archivos .feature:
Buscar el directorio donde se guardan los esquemas de color para cada lenguaje

	$ locate gtksourceview | grep 'javascript.lang$'

Copiar el archivo gherkin.lang (lo pueden buscar en la web) a ese directorio (requiere permisos de root).

10) Para crear un proyecto de Ruby:

10.1) Crear un directorio de trabajo (no es necesario si ya clonaste el repositorio)
	
	$ mkdir CE_proyecto
	$ cd CE_proyecto

10.2) Se inicializa el archivo de las gemas (no es necesario si ya clonaste el repositorio)
	
	$ bundle init

11) Editar el archivo Gemfile (no es necesario si ya clonaste el repositorio)

	$ gedit Gemfile

11.1) Se escribe lo siguiente:
	
	source 'http://rubygems.org'
	gem 'cucumber'
	gem 'rspec'
	gem 'yard'

11.2) Salvar y salir

12) Se agregan las gemas al directorio del proyecto

	$ bundle install

13) Crear el archivo de Ruby, por ejemplo (no es necesario si ya clonaste el repositorio)

	$ gedit algoritmoGenetico.rb 

14) En las primeras lìneas poner (no es necesario si ya clonaste el repositorio)

	require 'rubygems'
	require 'bundler/setup'
	
# Usando el Software
Con cucumber cada vez que haya una iteración, verificarlo así(estando en el directorio raíz):

	$ bundle exec cucumber
Para mayor información sobre Cucumber, visitar: https://cucumber.io/

Para ejecutar el programa desde terminal:

	$ ruby aplicacion.rb

Para generar la documentaciónos de YARD, debe colocar los archivos fuente(.rb) en una subcarpeta llamada "lib" y 
desde arriba de esta(/../dir_raiz/lib/aplicacion.rb) se usa el comando:

	$ yard

Para más información sobre YARD, visitar http://yardoc.org/
