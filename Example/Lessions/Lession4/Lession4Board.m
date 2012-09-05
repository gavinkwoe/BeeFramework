//
//  Lession3Board.m
//

#import "Lession4Board.h"
#import "Lession4ContentBoard.h"

#pragma mark -

@implementation Lession4Board

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			BeeUISegmentedControl * seg = [BeeUISegmentedControl spawn];
			[seg addTitle:@"Left page" tag:0];
			[seg addTitle:@"Right page" tag:1];
			[seg setSelectedSegmentIndex:0];
			[self setTitleView:seg];
			
			[self showNavigationBarAnimated:NO];

			[self append:[BeeUIStack stackWithFirstBoardClass:[Lession4ContentBoard class]]];
			[self append:[BeeUIStack stackWithFirstBoardClass:[Lession4ContentBoard class]]];
			[self present:[self.stacks objectAtIndex:0]];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
		}
	}
	else if ( [signal isKindOf:BeeUISegmentedControl.SIGNAL] )
	{
		if ( [signal is:BeeUISegmentedControl.HIGHLIGHT_CHANGED] )
		{
			BeeUISegmentedControl * titleView = (BeeUISegmentedControl *)self.titleView;
			[self present:[self.stacks objectAtIndex:titleView.selectedTag]];
		}
	}
}

@end
