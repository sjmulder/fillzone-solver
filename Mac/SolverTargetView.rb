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

class SolverTargetView < NSView
	NUM_ROWS = 14
	NUM_COLS = 14
	BLOCK_WIDTH = 22
	BLOCK_HEIGHT = 22
	START_X = 12
	START_Y = 12
	LOOK_OFFSET_X = 5
	LOOK_OFFSET_Y = 18
	
	BOARD_WIDTH = BLOCK_WIDTH * NUM_COLS
	BOARD_HEIGHT = BLOCK_HEIGHT * NUM_ROWS
	BOARD_TOP = START_X
	BOARD_LEFT = START_Y
	BOARD_BOTTOM = START_Y + BOARD_HEIGHT
	BOARD_RIGHT = START_X + BOARD_WIDTH
	
	COLORS = [
		[:pink, NSColor.magentaColor],
		[:white, NSColor.colorWithCalibratedRed(1, green: 1, blue: 1, alpha: 1)],
		[:red, NSColor.redColor],
		[:green, NSColor.greenColor],
		[:blue, NSColor.blueColor],
		[:yellow, NSColor.yellowColor]
	]
	
	ColorDistance = Struct.new(:color_name, :distance)
	
	attr_reader :board
	attr_reader :liveMode
	
	def awakeFromNib
		@liveMode = true
	end
	
	def drawRect(rect)		
		context = NSGraphicsContext.currentContext
		context.saveGraphicsState
		context.setCompositingOperation(NSCompositeCopy)
	
		white = @liveMode ? 0 : 0.25
		alpha = @liveMode ? 0.25 : 0.5
		NSColor.colorWithDeviceWhite(white, alpha: alpha).set
		
		path = NSBezierPath.bezierPathWithRoundedRect(bounds, xRadius: 12, yRadius: 12)
		path.fill
	
		context.restoreGraphicsState

		unless @board.nil?
			@board.for_all_tiles do |row, col, color|
				next if color.nil?
				x = BOARD_LEFT + col * BLOCK_WIDTH
				y = BOARD_TOP + row * BLOCK_HEIGHT

				colors = COLORS.find { |c| c[0] == color }
				colors[1].colorWithAlphaComponent(0.75).set

				right = x + BLOCK_WIDTH - 1
				bottom = y + BLOCK_WIDTH - 1
				
				unless @liveMode
					NSRectFillUsingOperation(
						NSMakeRect(x, y, BLOCK_WIDTH - 1, BLOCK_HEIGHT - 1),
						context.compositingOperation
					)
				
					colors[1].set
				end
				
				path = NSBezierPath.new
				path.moveToPoint(NSMakePoint(right, y))
				path.lineToPoint(NSMakePoint(right, bottom))
				path.lineToPoint(NSMakePoint(x, bottom))
				path.fill
			end
		end
	end

	def captureBoardBitmap
		rect = CGRectMake(BOARD_LEFT, BOARD_TOP, BOARD_WIDTH, BOARD_HEIGHT)
		rect = convertRectToBase(rect)
		rect.origin = window.convertBaseToScreen(rect.origin)
		rect.origin.y = window.screen.frame.size.height - rect.origin.y - rect.size.height
		
		cgImage = CGWindowListCreateImage(
			rect,
			KCGWindowListOptionOnScreenBelowWindow, 
			window.windowNumber, 
			KCGWindowImageDefault
		)
		
		bitmapRep = NSBitmapImageRep.alloc.initWithCGImage(cgImage)
		CGImageRelease(cgImage)
		
		bitmapRep
	end
	
	def closestColorName(color)
		distances = COLORS.map do |colors|
			distance =
				(colors[1].redComponent - color.redComponent).abs +
				(colors[1].greenComponent - color.greenComponent).abs +
				(colors[1].blueComponent - color.blueComponent).abs
			ColorDistance.new(
				colors[0],
				distance
			)
		end
		closest = distances.min { |a, b| a.distance <=> b.distance }
		closest.color_name
	end
	
	def captureBoard
		bitmap = captureBoardBitmap

		@board = FillzoneBoard.new(NUM_COLS, NUM_ROWS)
		@board.for_all_tiles do |row, col|
			x = col * BLOCK_WIDTH + LOOK_OFFSET_X
			y = row * BLOCK_HEIGHT + LOOK_OFFSET_Y
			color = bitmap.colorAtX(x, y: y)
			color_name = closestColorName(color)		
			@board.set_color_at(col, row, color_name)
		end
		
		setNeedsDisplay(true)
	end

	def isFlipped
		true
	end
	
	def board=(value)
		@board = value
		setNeedsDisplay(true)
	end
	
	def liveMode=(value)
		@liveMode = value
		captureBoard if @live_mode
		setNeedsDisplay(true)
	end
end