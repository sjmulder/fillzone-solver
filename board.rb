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

class FillzoneBoard
	attr_reader :width
	attr_reader :height
	
	def initialize(width, height, colors = {})
		@width = width
		@height = height
		@colors = colors
	end
	
	def color_at(x, y)
		@colors[[x, y]]
	end
	
	def set_color_at(x, y, value)
		@colors[[x, y]] = value
	end
	
	def for_rows
		(0...@height).each do |y|
			yield y
		end
	end
	
	def for_columns
		(0...@width).each do |x|
			yield x
		end
	end
	
	def for_all_tiles
		for_rows do |y|
			for_columns do |x|
				yield y, x, color_at(x, y)
			end
		end
	end
	
	def tile_exists?(x, y)
		x >= 0 &&
		y >= 0 &&
		x < @width &&
		y < @height
	end
	
	def print
		for_rows do |y|
			row = []
			for_columns { |x| row << color_at(x, y) }
			puts row.join(", ")
		end
	end
	
	def finished?
		first_color = color_at(0, 0)
		for_all_tiles do |x, y, color|
			return false if color != first_color
		end
		true
	end
	
	def unique_colors
		@colors.values.uniq
	end
	
	def island_and_neighbors_of(start_x, start_y)
		return [] if !tile_exists?(start_x, start_y)
		
		island = []
		target_color = color_at(start_x, start_y)
		neighbors = [[start_x, start_y]]

		index = 0
		while index < neighbors.length
			pos = neighbors[index]
			x, y = pos[0], pos[1]

			index += 1

			next if !tile_exists?(x, y)
			next if color_at(x, y) != target_color
			
			index -= 1
			neighbors.delete(pos)
			
			next if island.include?(pos)
			island << pos
			
			neighbors << [x, y - 1]
			neighbors << [x, y + 1]
			neighbors << [x + 1, y]
			neighbors << [x - 1, y]
		end
		
		neighbors.delete_if do |pos|
			!tile_exists?(pos[0], pos[1])
		end
		
		return island, neighbors
	end
	
	def swap_island_at(x, y, new_color)
		new_board = FillzoneBoard.new(@width, @height, @colors.dup)
		island_tiles, _ = island_and_neighbors_of(x, y)

		island_tiles.each do |pos|
			new_board.set_color_at(pos[0], pos[1], new_color)
		end
		
		new_board
	end
end
