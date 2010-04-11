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

class FillzoneSolverDelegate
	LIVE_WIDTH = 354
	SOLUTION_WIDTH = 533
	
	attr_accessor :window
	attr_accessor :overlayView
	attr_accessor :statusLabel
	attr_accessor :solveButton
	attr_accessor :solutionScroller
	
	def initialize
		@liveMode = true
	end
	
	def awakeFromNib
		window.setAutorecalculatesContentBorderThickness(true, forEdge: NSMinYEdge)
		window.setContentBorderThickness(24, forEdge: NSMinYEdge)
		window.setOpaque(false)
		window.setLevel(NSFloatingWindowLevel)
		statusLabel.cell.setBackgroundStyle(NSBackgroundStyleRaised)
	end
	
	def applicationDidFinishLaunching(notification)
		overlayView.captureBoard if @liveMode
	end

	def windowDidMove(notification)
		overlayView.captureBoard if @liveMode
	end
	
	def solve(sender)
		@liveMode = !@liveMode

		solveButton.title = @liveMode ? 'Solve' : 'New'
		overlayView.liveMode = @liveMode
		statusLabel.animator.alphaValue = @liveMode ? 1 : 0

		frame = window.frame
		frame.size.width = @liveMode ? LIVE_WIDTH : SOLUTION_WIDTH
		window.animator.setFrame(frame, display: true)
	end
end