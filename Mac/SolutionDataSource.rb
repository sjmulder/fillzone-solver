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

class SolutionDataSource
	Step = Struct.new(:num, :color, :board)
	
	def fillWithColorSteps(colors, board: board)
		@steps = []
		@steps << Step.new('', 'Start', board)
		
		current_board = board
		colors.each_with_index do |color, index|
			current_board = current_board.swap_island_at(0, 0, color)
			color_name = color.to_s
			color_name = color_name[0].upcase + color_name[1, color_name.length - 1]
			@steps << Step.new("#{index + 1}.", color_name, current_board)
		end
	end
	
	def numberOfRowsInTableView(table)
		return 0 if @steps.nil?
		@steps.length
	end
	
	def tableView(table, objectValueForTableColumn: column, row: row)
		case column.identifier
			when 'num' then @steps[row].num
			when 'description' then @steps[row].color
			else ''
		end
	end
	
	def boardAtRow(row)
		nil if @steps.nil?
		@steps[row].board
	end
end