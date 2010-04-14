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

puts "Solving"

solver = BreadthSolver.new(board)
solver.solve { |depth| puts " search depth: #{depth}" }
solver.print

solver.step_colors.each_with_index do |color, index|
	island, _ = board.island_and_neighbors_of(0, 0)
	completion = island.length.to_f / (board.width * board.height)
	puts "#{completion}: #{solver.step_colors.length - index}"
	board = board.swap_island_at(0, 0, color)
end