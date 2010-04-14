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

COLORS = [:pink, :blue, :white, :yellow, :white]

turns_needed = (2..10).map do |size|
	board = FillzoneBoard.new(size, size)
	board.for_all_tiles do |x, y|
		color = COLORS[rand(COLORS.length)]
		board.set_color_at(x, y, color)
	end
	
	puts "Solving #{size}x#{size}"
	solver = BreadthSolver.new(board)
	solver.solve { |depth| puts " search depth: #{depth}" }
	
	[size, solver.step_colors.length]
end

turns_needed.each do |turns_pair|
	size, turns = turns_pair
	puts "#{size}: #{turns}"
end