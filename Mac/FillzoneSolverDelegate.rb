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
	attr_accessor :window
	attr_accessor :overlayView
	
	def awakeFromNib
		window.setAutorecalculatesContentBorderThickness(true, forEdge: NSMinYEdge)
		window.setContentBorderThickness(24, forEdge: NSMinYEdge)
		window.setOpaque(false)
		window.setLevel(NSFloatingWindowLevel)
	end
	
	def windowDidMove(notification)
		puts "Moved!"
		overlayView.captureBoard
	end
end