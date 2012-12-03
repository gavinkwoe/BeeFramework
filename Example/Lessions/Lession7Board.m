//
//  Lession7Board.m
//

#import "Lession7Board.h"

#pragma mark -

@implementation Lession7Cell

+ (CGSize)cellSize:(NSObject *)data bound:(CGSize)bound
{
	return CGSizeMake( bound.width, 60.0f );
}

- (void)cellLayout:(BeeUIGridCell *)cell bound:(CGSize)bound
{
	_title.frame = CGRectMake( 10.0f, 5.0f, cell.bounds.size.width - 20.0f, bound.height - 10.0f );
}

- (void)load
{
	[super load];
	
	_title = [[BeeUILabel alloc] init];
	_title.font = [UIFont boldSystemFontOfSize:18.0f];
	_title.textColor = [UIColor blackColor];
	_title.textAlignment = UITextAlignmentLeft;
	[self addSubview:_title];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _title );

	[super unload];
}

- (void)bindData:(NSObject *)data
{
	[_title setText:[(NSArray *)data objectAtIndex:1]];
	
	[super bindData:data];
}

- (void)clearData
{
	[_title setText:nil];
}

@end

#pragma mark -

@implementation Lession7Board

DEF_SINGLETON( Lession7Board );

- (void)load
{
	[super load];

	_items = [[NSMutableArray alloc] init];
	[_items addObject:[NSArray arrayWithObjects:@"Lession7_1Board",		@"BeeUIActionSheet", nil]];
	[_items addObject:[NSArray arrayWithObjects:@"Lession7_2Board",		@"BeeUIActivityIndicatorView", nil]];
	[_items addObject:[NSArray arrayWithObjects:@"Lession7_3Board",		@"BeeUIAlertView", nil]];
	[_items addObject:[NSArray arrayWithObjects:@"Lession7_4Board",		@"BeeUIButton", nil]];
	[_items addObject:[NSArray arrayWithObjects:@"Lession7_5Board",		@"BeeUIDatePicker", nil]];
	[_items addObject:[NSArray arrayWithObjects:@"Lession7_6Board",		@"(TODO) BeeUIGridCell", nil]];
	[_items addObject:[NSArray arrayWithObjects:@"Lession7_7Board",		@"BeeUIImageView", nil]];
	[_items addObject:[NSArray arrayWithObjects:@"Lession7_8Board",		@"(TODO) BeeUIKeyboard", nil]];
	[_items addObject:[NSArray arrayWithObjects:@"Lession7_9Board",		@"(TODO) BeeUILabel", nil]];
	[_items addObject:[NSArray arrayWithObjects:@"Lession7_10Board",	@"(TODO) BeeUIOrientation", nil]];
	[_items addObject:[NSArray arrayWithObjects:@"Lession7_11Board",	@"(TODO) BeeUIPageControl", nil]];
	[_items addObject:[NSArray arrayWithObjects:@"Lession7_12Board",	@"(TODO) BeeUIProgressView", nil]];
	[_items addObject:[NSArray arrayWithObjects:@"Lession7_13Board",	@"(TODO) BeeUIPullLoader", nil]];
	[_items addObject:[NSArray arrayWithObjects:@"Lession7_14Board",	@"(TODO) BeeUIScrollView", nil]];
}

- (void)unload
{
	[_items removeAllObjects];
	[_items release];
	
	[super unload];
}

#pragma mark -

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];	
}

- (void)handleBeeUIBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			[self setTitleString:@"Lession 7"];
			[self showNavigationBarAnimated:NO];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
		}
	}
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize bound = CGSizeMake( self.view.bounds.size.width, 0.0f );
	return [Lession7Cell cellSize:nil bound:bound].height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BeeUITableViewCell * cell = (BeeUITableViewCell *)[self dequeueWithContentClass:[Lession7Cell class]];
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
		[cell bindData:[_items objectAtIndex:indexPath.row]];
		return cell;
	}
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	
	NSArray * data = [_items objectAtIndex:indexPath.row];
	BeeUIBoard * board = [[(BeeUIBoard *)[BeeRuntime allocByClassName:(NSString *)[data objectAtIndex:0]] init] autorelease];
	if ( board )
	{
		[self.stack pushBoard:board animated:YES];
	}
}

@end
