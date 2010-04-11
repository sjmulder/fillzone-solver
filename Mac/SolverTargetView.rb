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

class SolverTargetView < NSView
	NUM_ROWS = 14
	NUM_COLS = 14
	BLOCK_WIDTH = 22
	BLOCK_HEIGHT = 22
	START_X = 12
	START_Y = 12
	
	def drawRect(rect)		
		context = NSGraphicsContext.currentContext
		context.saveGraphicsState
		context.setCompositingOperation(NSCompositeCopy)
	
		NSColor.colorWithDeviceWhite(0, alpha: 0.25).set
		
		path = NSBezierPath.bezierPathWithRoundedRect(bounds, xRadius: 12, yRadius: 12)
		path.fill
	
		context.restoreGraphicsState
		context.saveGraphicsState
	
		lineCorrectTransform = NSAffineTransform.new
		lineCorrectTransform.translateXBy(-0.5, yBy: -0.5)
		lineCorrectTransform.concat
	
		width = BLOCK_WIDTH * NUM_COLS
		height = BLOCK_HEIGHT * NUM_ROWS
		top = START_X
		left = START_Y
		bottom = START_Y + height
		right = START_X + width
	
		grid = NSBezierPath.new;
		grid.moveToPoint(NSMakePoint(left, top))
		grid.lineToPoint(NSMakePoint(right, top))
		grid.moveToPoint(NSMakePoint(left, top))
		grid.lineToPoint(NSMakePoint(left, bottom))
		
		NUM_ROWS.times do |row|
			y = top + (row + 1) * BLOCK_HEIGHT
			grid.moveToPoint(NSMakePoint(left, y))
			grid.lineToPoint(NSMakePoint(right, y))
		end

		NUM_COLS.times do |col|
			x = left + (col + 1) * BLOCK_WIDTH
			grid.moveToPoint(NSMakePoint(x, top))
			grid.lineToPoint(NSMakePoint(x, bottom))
		end
	
		lineInsetTransform = NSAffineTransform.new
		lineInsetTransform.translateXBy(-1, yBy: -1)
		lineInsetTransform.concat
	
		NSColor.colorWithDeviceWhite(0, alpha: 0.3).set
		grid.stroke

		lineInsetTransform.invert
		lineInsetTransform.concat

		NSColor.colorWithDeviceWhite(1, alpha: 0.3).set
		grid.stroke
	
		context.restoreGraphicsState
	end

	def isFlipped
		true
	end
end