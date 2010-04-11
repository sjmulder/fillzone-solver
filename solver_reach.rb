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

class ReachFillzoneSolver
	attr_reader :boards
	attr_reader :step_colors
	
	def initialize(board)
		@boards = [board]
		@step_colors = []
	end

	def board
		@boards.last
	end
	
	def color_reaches
		island, neighbors = board.island_and_neighbors_of(0, 0)
		reached_tiles = {}
		
		neighbors.each do |pos|
			x, y = pos[0], pos[1]
			tile_color = board.color_at(x, y)
			
			tile_island, tile_reach = board.island_and_neighbors_of(x, y)
			tile_reach -= island
			tile_reach -= neighbors
			tile_reach += tile_island
			
			reached_tiles[tile_color] ||= []
			reached_tiles[tile_color] += tile_reach
			reached_tiles[tile_color].uniq!
		end
		
		reach_counts = {}
		reached_tiles.map do |color, tiles|
			reach_counts[color] = tiles.length
		end
		
		reach_counts
	end
	
	def highest_reach_color
		max = color_reaches.max { |a, b| a[1] <=> b[1] }
		max[0]
	end
	
	def step
		return if board.finished?
		color = highest_reach_color
		boards << board.swap_island_at(0, 0, color)
		step_colors << color
	end
	
	def solve
		step until board.finished?
		step_colors
	end
	
	def print
		puts step_colors.join(", ")
	end
end