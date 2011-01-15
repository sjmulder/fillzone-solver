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

require 'solver_reach'

class FillzoneSolverDelegate
	LIVE_WIDTH = 354
	SOLUTION_WIDTH = 533
	
	attr_accessor :window
	attr_accessor :overlayView
	attr_accessor :statusLabel
	attr_accessor :solveButton
	attr_accessor :progressIndicator
	attr_accessor :solutionScroller
	attr_accessor :solutionTable
	
	def initialize
		@liveMode = true
		@tableSource = SolutionDataSource.new
	end
	
	def awakeFromNib
		window.setAutorecalculatesContentBorderThickness(true, forEdge: NSMinYEdge)
		window.setContentBorderThickness(24, forEdge: NSMinYEdge)
		window.setOpaque(false)
		window.setLevel(NSFloatingWindowLevel)
		statusLabel.cell.setBackgroundStyle(NSBackgroundStyleRaised)
		
		solutionTable.delegate = self
		solutionTable.dataSource = @tableSource
	end
	
	def applicationDidFinishLaunching(notification)
		overlayView.captureBoard if @liveMode
	end

	def applicationShouldTerminateAfterLastWindowClosed(app)
		false
	end
	
	def applicationShouldOpenUntitledFile(app)
		window.makeKeyAndOrderFront(self)
	end

	def windowDidMove(notification)
		overlayView.captureBoard if @liveMode
	end
	
	def tableViewSelectionDidChange(notification)
		overlayView.board = @tableSource.boardAtRow(solutionTable.selectedRow)
	end
	
	def validateMenuItem(item)
		case item.title
			when 'New' then !@liveMode
			when 'Solve' then @liveMode
			else true
		end
	end
	
	def solveThread(context)
		solver = ReachFillzoneSolver.new(context[:board])
		solution = solver.solve

		callbackContext = { :board => context[:board], :solution => solution }
		self.performSelectorOnMainThread('solvedCallback:', withObject: callbackContext, waitUntilDone: true)
	end
	
	def solvedCallback(context)
		@tableSource.fillWithColorSteps(context[:solution], board: context[:board])
		@solutionTable.reloadData
		@solutionTable.selectRowIndexes(NSIndexSet.indexSetWithIndex(0), byExtendingSelection: false)
		@solutionTable.scrollRowToVisible(0)
		
		statusLabel.stringValue = "Solved in #{context[:solution].length} turns."

		progressIndicator.stopAnimation(self)
		solveButton.title = 'New'
		solveButton.enabled = true
		
		frame = window.frame
		frame.size.width = SOLUTION_WIDTH
		window.animator.setFrame(frame, display: true)
	end
	
	def solve(sender)
		@liveMode = !@liveMode

		unless @liveMode
			progressIndicator.startAnimation(self)
			overlayView.liveMode = false
			solveButton.enabled = false
			statusLabel.stringValue = 'Solving…'
			
			context = { :board => overlayView.board }
			NSThread.detachNewThreadSelector('solveThread:', toTarget: self, withObject: context)
		else
			statusLabel.stringValue = 'Drag window over puzzle.'
			solveButton.title = 'Solve'
			overlayView.liveMode = true
			
			frame = window.frame
			frame.size.width = LIVE_WIDTH
			window.animator.setFrame(frame, display: true)
		end		
	end
end