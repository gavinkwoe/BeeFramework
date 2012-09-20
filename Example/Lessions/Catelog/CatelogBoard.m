//
//  CatelogBoard.m
//

#import "CatelogBoard.h"
#import "Bee_Runtime.h"

#pragma mark -

@implementation CatelogCell

+ (CGSize)cellSize:(NSObject *)data bound:(CGSize)bound
{
	return CGSizeMake( bound.width, 60.0f );
}

- (void)cellLayout:(BeeUIGridCell *)cell bound:(CGSize)bound
{
	_icon.frame = CGRectMake( 10.0f, 5.0f, 28.0f, 28.0f );
	_title.frame = CGRectMake( 45.0f, 5.0f, cell.bounds.size.width - 55.0f, 30.0f );
	_intro.frame = CGRectMake( 45.0f, 32.0f, cell.bounds.size.width - 55.0f, 20.0f );
}

- (void)load
{
	[super load];
	
	_icon = [[BeeUIImageView alloc] init];
	_icon.contentMode = UIViewContentModeScaleAspectFit;
	_icon.resource = @"icon.png";
	[self addSubview:_icon];

	_title = [[BeeUILabel alloc] init];
	_title.font = [BeeUIFont height:20.0f bold:YES];
	_title.textColor = [UIColor blackColor];
	_title.textAlignment = UITextAlignmentLeft;
	[self addSubview:_title];

	_intro = [[BeeUILabel alloc] init];
	_intro.font = [BeeUIFont height:14.0f];
	_intro.textColor = [UIColor grayColor];
	_intro.textAlignment = UITextAlignmentLeft;
	[self addSubview:_intro];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _icon );
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

DEF_SINGLETON( CatelogBoard );

- (void)load
{
	[super load];
	
	_lessions = [[NSMutableArray alloc] init];
	[_lessions addObject:[NSArray arrayWithObjects:@"DribbbleBoard", @"DribbleClient", @"dribbble.com client demo", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession1Board", @"Lession 1", @"创建UIBoard，理解生命周期", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession2Board", @"Lession 2", @"处理UISignal，理解传递方式", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession3Board", @"Lession 3", @"使用UIStack，管理界面Stack", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession4Board", @"Lession 4", @"使用UIStackGroup，管理多个Stack", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession5Board", @"Lession 5", @"使用UITableBoard", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession6Board", @"Lession 6", @"使用UIFlowBoard", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession7Board", @"Lession 7 (待完成)", @"使用各种UIView控件", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession8Board", @"Lession 8 (待完成)", @"使用Network", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession9Board", @"Lession 9 (待完成)", @"使用Model & Cache", nil]];
	[_lessions addObject:[NSArray arrayWithObjects:@"Lession10Board", @"Lession 10 (待完成)", @"使用Controller", nil]];
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
			[self setTitleString:@"Example"];
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
