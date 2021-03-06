# FillzoneSolver
# A simple solver for the Fillzone game
# Sijmen Mulder, April 2010
#
# I, the copyright holder of this work, hereby release it into the public
# domain. This applies worldwide.
#
# In case this is not legally possible: I grant anyone the right to use this
# work for any purpose, without any conditions, unless such conditions are
# required by law.

require 'board'
require 'solver_reach'
require 'solver_breadth'

example_data = [
	:pink,   :pink,  :blue,   :white,  :yellow,
	:blue,   :white, :pink,   :yellow, :white,
	:pink,   :blue,  :pink,   :green,  :white,
	:blue,   :red,   :pink,   :white,  :green,
	:yellow, :pink,  :yellow, :yellow, :green
]

board = FillzoneBoard.new(5, 5)
example_data.each_with_index do |color, i|
	board.set_color_at(i % 5, i / 5, color)
end

use_reach = true
use_breadth = true

if ARGV.length > 0
	use_reach = false
	use_breadth = false
	
	ARGV.each do |argument|
		case argument
			when 'reach': use_reach = true
			when 'breadth': use_breadth = true
				
			else
				puts "Unknown solve method: #{argument}"
				puts "Usage: ruby #{__FILE__} [reach] [breadth]"
				exit
		end
	end
end

if use_reach
	puts "Reach solver:"
	reach_solver = ReachFillzoneSolver.new(board)
	reach_solver.solve
	reach_solver.print
end

if use_breadth
	puts "Breadth solver:"
	breath_solver = BreadthSolver.new(board)
	breath_solver.solve { |depth| puts " search depth: #{depth}" }
	breath_solver.print
end