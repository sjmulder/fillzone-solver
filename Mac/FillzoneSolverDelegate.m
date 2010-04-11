/* FillzoneSolver
   A simple solver for the Fillzone game
   Sijmen Mulder, April 2010

   I, the copyright holder of this work, hereby release it into the public
   domain. This applies worldwide.

   In case this is not legally possible: I grant anyone the right to use this
   work for any purpose, without any conditions, unless such conditions are
   required by law. */

#import "FillzoneSolverDelegate.h"

@implementation FillzoneSolverDelegate

- (void)awakeFromNib
{
	[window setAutorecalculatesContentBorderThickness:YES forEdge:NSMinYEdge];
	[window setContentBorderThickness:24.0 forEdge:NSMinYEdge];
	[window setOpaque:FALSE];
}

@end
