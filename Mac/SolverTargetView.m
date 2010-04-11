/* FillzoneSolver
   A simple solver for the Fillzone game
   Sijmen Mulder, April 2010

   I, the copyright holder of this work, hereby release it into the public
   domain. This applies worldwide.

   In case this is not legally possible: I grant anyone the right to use this
   work for any purpose, without any conditions, unless such conditions are
   required by law. */

#import "SolverTargetView.h"

const int NUM_ROWS = 14;
const int NUM_COLS = 14;
const int BLOCK_WIDTH = 22;
const int BLOCK_HEIGHT = 22;
const int START_X = 12;
const int START_Y = 12;

@implementation SolverTargetView

- (void)drawRect:(NSRect)rect
{
	NSGraphicsContext *context = [NSGraphicsContext currentContext];
	[context saveGraphicsState];
	[context setCompositingOperation:NSCompositeCopy];
	
	[[NSColor colorWithDeviceWhite:0 alpha:0.25] set];
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:[self bounds] xRadius:12 yRadius:12];
	[path fill];
	
	[context restoreGraphicsState];
	[context saveGraphicsState];
	
	NSAffineTransform *transform = [NSAffineTransform new];
	[transform translateXBy:-0.5 yBy:-0.5];
	[transform concat];
	
	CGFloat width = BLOCK_WIDTH * NUM_COLS;
	CGFloat height = BLOCK_HEIGHT * NUM_ROWS;
	CGFloat top = START_X;
	CGFloat left = START_Y;
	CGFloat bottom = START_Y + height;
	CGFloat right = START_X + width;
	
	NSBezierPath *grid = [NSBezierPath new];
	[grid moveToPoint:NSMakePoint(left, top)];
	[grid lineToPoint:NSMakePoint(right, top)];
	[grid moveToPoint:NSMakePoint(left, top)];
	[grid lineToPoint:NSMakePoint(left, bottom)];
		
	for (int row = 0; row < NUM_ROWS; row++)
	{	
		CGFloat y = top + (row + 1) * BLOCK_HEIGHT;
		[grid moveToPoint:NSMakePoint(left, y)];
		[grid lineToPoint:NSMakePoint(right, y)];
	}
	
	for (int col = 0; col < NUM_COLS; col++)
	{	
		CGFloat x = left + (col + 1) * BLOCK_WIDTH;
		[grid moveToPoint:NSMakePoint(x, top)];
		[grid lineToPoint:NSMakePoint(x, bottom)];
	}
	
	[[NSColor colorWithDeviceWhite:1 alpha:0.5] set];
	[grid stroke];
	
	[context restoreGraphicsState];
}

- (BOOL)isFlipped { return YES; }

@end
