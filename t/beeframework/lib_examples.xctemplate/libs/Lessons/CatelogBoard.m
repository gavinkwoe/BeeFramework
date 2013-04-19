//
//  CatelogBoard.m
//

#import "CatelogBoard.h"
#import "Bee_Debug.h"
#import "Bee_Runtime.h"

#pragma mark -

@implementation CatelogCell

+ (CGSize)sizeInBound:(CGSize)bound forData:(NSObject *)data
{
	return CGSizeMake( bound.width, 60.0f );
}

- (void)layoutInBound:(CGSize)bound forCell:(BeeUIGridCell *)cell
{
	_title.frame = CGRectMake( 10.0f, 5.0f, cell.bounds.size.width - 20.0f, 30.0f );
	_intro.frame = CGRectMake( 10.0f, 32.0f, cell.bounds.size.width - 20.0f, 20.0f );
}

- (void)load
{
	[super load];

	_title = [[BeeUILabel alloc] init];
	_title.font = [UIFont boldSystemFontOfSize:18.0f];
	_title.textColor = [UIColor blackColor];
	_title.textAlignment = UITextAlignmentLeft;
	[self addSubview:_title];

	_intro = [[BeeUILabel alloc] init];
	_intro.font = [UIFont systemFontOfSize:14.0f];
	_intro.textColor = [UIColor grayColor];
	_intro.textAlignment = UITextAlignmentLeft;
	[self addSubview:_intro];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _title );
	SAFE_RELEASE_SUBVIEW( _intro );
	
	[super unload];
}

- (void)dataWillChange
{
	[super dataWillChange];
}

- (void)dataDidChanged
{
	[super dataDidChanged];
	
	if ( self.cellData )
	{
		[_title setText:[(NSArray *)self.cellData objectAtIndex:1]];
		[_intro setText:[(NSArray *)self.cellData objectAtIndex:2]];
	}
	else
	{
		[_title setText:nil];
		[_intro setText:nil];
	}
}

@end

#pragma mark -

@implementation CatelogBoard

- (void)load
{
	[super load];

	_lessons = [[NSMutableArray alloc] init];

    [_lessons addObject:[NSArray arrayWithObjects:@"Lesson12Board", @"Lesson12 (New)", @"How to coding BeeUILayout", nil]];
    [_lessons addObject:[NSArray arrayWithObjects:@"Lesson13Board", @"Lesson13 (New)", @"How to write BeeUILayout XML", nil]];
	[_lessons addObject:[NSArray arrayWithObjects:@"Lesson14Board", @"Lesson14 (New)", @"How to use BeeUIQuery", nil]];
    [_lessons addObject:[NSArray arrayWithObjects:@"DribbbleBoard", @"Dribbble.com (New)", @"Demo for dribbble.com", nil]];
	[_lessons addObject:[NSArray arrayWithObjects:@"WebViewBoard", @"WebView Demo (New)", @"Demo for BeeUIWebView", nil]];
	[_lessons addObject:[NSArray arrayWithObjects:@"Lesson1Board", @"Lesson 1", @"How to use BeeUIBoard", nil]];
	[_lessons addObject:[NSArray arrayWithObjects:@"Lesson2Board", @"Lesson 2", @"How to use BeeUISignal", nil]];
	[_lessons addObject:[NSArray arrayWithObjects:@"Lesson3Board", @"Lesson 3", @"How to use BeeUIStack", nil]];
	[_lessons addObject:[NSArray arrayWithObjects:@"Lesson4Board", @"Lesson 4", @"How to use BeeUIStackGroup", nil]];
	[_lessons addObject:[NSArray arrayWithObjects:@"Lesson5Board", @"Lesson 5", @"How to use BeeUITableBoard", nil]];
	[_lessons addObject:[NSArray arrayWithObjects:@"Lesson6Board", @"Lesson 6", @"How to use BeeUIFlowBoard", nil]];
	[_lessons addObject:[NSArray arrayWithObjects:@"Lesson7Board", @"Lesson 7 (New)", @"How to use Bee controls", nil]];
	[_lessons addObject:[NSArray arrayWithObjects:@"Lesson8Board", @"Lesson 8 (New)", @"How to use BeeNetwork", nil]];
	[_lessons addObject:[NSArray arrayWithObjects:@"Lesson9Board", @"Lesson 9 (New)", @"How to use BeeController", nil]];
	[_lessons addObject:[NSArray arrayWithObjects:@"Lesson10Board", @"Lesson 10 (New)", @"How to use BeeModel & BeeCache", nil]];
	[_lessons addObject:[NSArray arrayWithObjects:@"Lesson11Board", @"Lesson 11 (New)", @"How to use BeeActiveRecord", nil]];
}

- (void)unload
{
	[_lessons removeAllObjects];
	[_lessons release];
	
	[super unload];
}

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		[self setTitleString:@"Examples"];
		[self showNavigationBarAnimated:NO];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize bound = CGSizeMake( self.view.bounds.size.width, 0.0f );
	return [CatelogCell sizeInBound:bound forData:nil].height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_lessons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BeeUITableViewCell * cell = (BeeUITableViewCell *)[self dequeueWithContentClass:[CatelogCell class]];
	if ( cell )
	{
		if ( indexPath.row % 2 )
		{
			[cell.gridCell setBackgroundColor:[UIColor whiteColor]];
		}
		else
		{
			[cell.gridCell setBackgroundColor:[UIColor colorWithWhite:0.95f alpha:1.0f]];
		}
		
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

		cell.cellData = [_lessons objectAtIndex:indexPath.row];
		return cell;
	}
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	
	NSArray * data = [_lessons objectAtIndex:indexPath.row];
	BeeUIBoard * board = [[(BeeUIBoard *)[BeeRuntime allocByClassName:(NSString *)[data objectAtIndex:0]] init] autorelease];
	if ( board )
	{
		[self.stack pushBoard:board animated:YES];
	}
}

@end
