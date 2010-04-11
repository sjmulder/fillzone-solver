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

class BreadthSolver
	Path = Struct.new(:steps, :board)
	
	attr_reader :initial_board
	attr_reader :step_colors
	
	def initialize(board)
		@initial_board = board
		@step_colors = []
	end
	
	def solve
		return if initial_board.finished?
		
		paths = [Path.new([], initial_board)]
		colors = initial_board.unique_colors
		solution = nil
		
		while solution.nil? do
			paths.map! do |path|
				_, neighbors = path.board.island_and_neighbors_of(0, 0)
				colors = neighbors.map { |pos| path.board.color_at(pos[0], pos[1]) }
				colors.uniq!
				colors.map do |color| 
					Path.new(
						path.steps.dup << color,
						path.board.swap_island_at(0, 0, color)
					)
				end
			end
			paths.flatten!
			puts " search depth: #{paths[0].steps.length}"
			solution = paths.find { |path| path.board.finished? }
		end
		
		@step_colors = solution.steps
	end
	
	def print
		puts step_colors.join(", ")
	end
end