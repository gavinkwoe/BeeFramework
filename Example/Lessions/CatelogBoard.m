//
//  CatelogBoard.m
//

#import "CatelogBoard.h"
#import "Bee_Debug.h"
#import "Bee_Runtime.h"

#pragma mark -

@implementation CatelogCell

+ (CGSize)cellSize:(NSObject *)data bound:(CGSize)bound
{
	return CGSizeMake( bound.width, 60.0f );
}

- (void)cellLayout:(BeeUIGridCell *)cell bound:(CGSize)bound
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

- (void)bindData:(NSObject *)data
{
	[_title setText:[(NSArray *)data objectAtIndex:1]];
	[_intro setText:[(NSArray *)data objectAtIndex:2]];
	
	[super bindData:data];
}

- (void)clearData
{
	[_title setText:nil];
	[_intro setText:nil];
}

@end

#pragma mark -

@implementation CatelogBoard

- (void)load
{
	[super load];

	_lessions = [[NSMutableArray alloc] init];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession1Board", @"Lession 1", @"How to use BeeUIBoard", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession2Board", @"Lession 2", @"How to use BeeUISignal", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession3Board", @"Lession 3", @"How to use BeeUIStack", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession4Board", @"Lession 4", @"How to use BeeUIStackGroup", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession5Board", @"Lession 5", @"How to use BeeUITableBoard", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession6Board", @"Lession 6", @"How to use BeeUIFlowBoard", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession7Board", @"Lession 7 (New)", @"How to use Bee controls", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession8Board", @"Lession 8 (New)", @"How to use BeeNetwork", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession9Board", @"Lession 9 (New)", @"How to use BeeController", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession10Board", @"Lession 10 (New)", @"How to use BeeModel & BeeCache", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession11Board", @"Lession 11 (New)", @"How to use BeeActiveRecord", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"DribbbleBoard", @"Dribbble.com (New)", @"Demo for dribbble.com", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"WebViewBoard", @"WebView Demo (New)", @"Demo for BeeUIWebView", nil]];
}

- (void)unload
{
	[_lessions removeAllObjects];
	[_lessions release];
	
	[super unload];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			[self setTitleString:@"Examples"];
			[self showNavigationBarAnimated:NO];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize bound = CGSizeMake( self.view.bounds.size.width, 0.0f );
	return [CatelogCell cellSize:nil bound:bound].height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_lessions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BeeUITableViewCell * cell = (BeeUITableViewCell *)[self dequeueWithContentClass:[CatelogCell class]];
	if ( cell )
	{
		if ( indexPath.row % 2 )
		{
			[cell.innerCell setBackgroundColor:[UIColor whiteColor]];
		}
		else
		{
			[cell.innerCell setBackgroundColor:[UIColor colorWithWhite:0.95f alpha:1.0f]];
		}
		
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		[cell bindData:[_lessions objectAtIndex:indexPath.row]];
		return cell;
	}
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	
	NSArray * data = [_lessions objectAtIndex:indexPath.row];
	BeeUIBoard * board = [[(BeeUIBoard *)[BeeRuntime allocByClassName:(NSString *)[data objectAtIndex:0]] init] autorelease];
	if ( board )
	{
		[self.stack pushBoard:board animated:YES];
	}
}

@end
