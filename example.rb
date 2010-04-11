# FillzoneSolver example
# A simple solver for the Fillzone game
# Sijmen Mulder, April 2010
#
# I, the copyright holder of this work, hereby release it into the public
# domain. This applies worldwide.
#
# In case this is not legally possible: I grant anyone the right to use this
# work for any purpose, without any conditions, unless such conditions are
# required by law.

require 'solver.rb'

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

solver = FillzoneSolver.new(board)
solver.step
solver.solve
solver.print