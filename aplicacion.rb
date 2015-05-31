#!/home/crisefd/.rvm/rubies/ruby-2.1.5/bin/ruby
# encoding: utf-8
# Program: aplicacion.rb
# Author: Cristhian Fuertes, Fabian Cano, Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co, fabian.cano@correounivalle.edu.co, oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-05-19 21:20
require 'rubygems'
require 'bundler/setup'

class Cromosoma < Array
  
end

class NReinas < Array

	def inicializar_cromosomas(n=8)
		@n = n
		i = 0
		while i < self.length do
			rand_array = (0..@n).collect{rand(@n)}
			cromosoma = Cromosoma.new(rand_array)
			self[i] = cromosoma
			i += 1
		end
	end
end

nr = NReinas.new(10)
nr.inicializar_cromosomas
