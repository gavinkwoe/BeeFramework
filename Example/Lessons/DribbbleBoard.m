//
//  DribbbleBoard.m
//

#import "DribbbleBoard.h"
#import "DribbblePhotoBoard.h"

#pragma mark -

@implementation DribbbleCell

+ (CGSize)sizeInBound:(CGSize)bound forData:(NSObject *)data
{
	if ( data )
	{
		CGSize photoSize;
		photoSize.width = [[(NSDictionary *)data numberAtPath:@"/width"] floatValue];
		photoSize.height = [[(NSDictionary *)data numberAtPath:@"/height"] floatValue];
		photoSize = AspectFitSizeByWidth( photoSize, bound.width );
		
		CGSize cellSize;
		cellSize.width = bound.width;
		cellSize.height = photoSize.height;
		return cellSize;
	}
	
	return bound;
}

- (void)layoutInBound:(CGSize)bound forCell:(BeeUIGridCell *)cell
{
	if ( cell.cellData )
	{
		CGSize photoSize;
		photoSize.width = [[(NSDictionary *)cell.cellData numberAtPath:@"/width"] floatValue];
		photoSize.height = [[(NSDictionary *)cell.cellData numberAtPath:@"/height"] floatValue];
		photoSize = AspectFitSizeByWidth( photoSize, bound.width );
		
		_photo.frame = CGRectMake( 0.0f, 0.0f, bound.width, photoSize.height );
		_mask.frame = CGRectMake( 0.0f, bound.height - 40.0f, bound.width, 40.0f );

		_avatar.frame = CGRectMake( 5.0f, CGRectGetMinY(_mask.frame) + 5.0f, 30.0f, 30.0f );
		_title.frame = CGRectMake( 40.0f, CGRectGetMinY(_mask.frame) + 6.0f, bound.width - 40.0f - 80.0f, 14.0f );
		_time.frame = CGRectMake( bound.width - 80.0f, CGRectGetMinY(_title.frame), 80.0f, 14.0f );	
		_name.frame = CGRectMake( 40.0f, CGRectGetMinY(_mask.frame) + 20.0f, bound.width - 40.0f, 14.0f );
	}
}

- (void)load
{
	[super load];

	_photo = [[BeeUIImageView alloc] init];
	_photo.contentMode = UIViewContentModeScaleAspectFit;
	_photo.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	[self addSubview:_photo];

	_mask = [[UIView alloc] init];
	_mask.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
	[self addSubview:_mask];

	_avatar = [[BeeUIImageView alloc] init];
	_avatar.layer.borderColor = [UIColor whiteColor].CGColor;
	_avatar.layer.borderWidth = 2.0f;
	[self addSubview:_avatar];
	
	_title = [[BeeUILabel alloc] init];
	_title.textAlignment = UITextAlignmentLeft;
	_title.textColor = [UIColor whiteColor];
	_title.font = [UIFont boldSystemFontOfSize:12.0f];
	[self addSubview:_title];

	_time = [[BeeUILabel alloc] init];
	_time.textAlignment = UITextAlignmentRight;
	_time.textColor = [UIColor whiteColor];
	_time.font = [UIFont boldSystemFontOfSize:12.0f];
	[self addSubview:_time];
	
	_name = [[BeeUILabel alloc] init];
	_name.textAlignment = UITextAlignmentLeft;
	_name.textColor = [UIColor lightGrayColor];
	_name.font = [UIFont boldSystemFontOfSize:12.0f];
	[self addSubview:_name];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _photo );
	SAFE_RELEASE_SUBVIEW( _mask );
	SAFE_RELEASE_SUBVIEW( _avatar );
	SAFE_RELEASE_SUBVIEW( _title );
	SAFE_RELEASE_SUBVIEW( _time );
	SAFE_RELEASE_SUBVIEW( _name );
	
	[super unload];
}

- (void)dataDidChanged
{
	[super dataDidChanged];
	
	if ( self.cellData )
	{
		[_photo GET:[(NSDictionary *)self.cellData stringAtPath:@"/image_teaser_url"] useCache:YES];
		[_avatar GET:[(NSDictionary *)self.cellData stringAtPath:@"/player/avatar_url"] useCache:YES];
		[_title setText:[(NSDictionary *)self.cellData stringAtPath:@"/title"]];
		[_time setText:[[(NSDictionary *)self.cellData stringAtPath:@"/created_at"] substringToIndex:10]];
		[_name setText:[NSString stringWithFormat:@"by %@", [(NSDictionary *)self.cellData stringAtPath:@"/player/name"]]];
	}
	else
	{
		[_photo setImage:nil];
		[_avatar setImage:nil];
		[_title setText:nil];
		[_name setText:nil];
	}
}

@end

#pragma mark -

#define TAG_EVERYONE	(0)
#define TAG_DEBUTS		(1)
#define TAG_POPULAR		(2)

@interface DribbbleBoard(Private)
- (void)refresh:(BOOL)force;
- (NSArray *)shots;
@end

@implementation DribbbleBoard

- (void)load
{
	[super load];

	_debutsModel = [DribbbleDebutsModel new];
	[_debutsModel addObserver:self];

	_popularModel = [DribbblePopularModel new];
	[_popularModel addObserver:self];

	_everyoneModel = [DribbbleEveryoneModel new];
	[_everyoneModel addObserver:self];
}

- (void)unload
{
	[_debutsModel release];
	[_popularModel release];
	[_everyoneModel release];

	[super unload];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
}

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		[self showNavigationBarAnimated:NO];
		[self showPullLoader:YES animated:NO];
		
		self.pullLoader.arrow.image = [UIImage imageNamed:@"bug.png"];

		BeeUISegmentedControl * seg = [BeeUISegmentedControl spawn];
		[seg addTitle:@"everyone" tag:TAG_EVERYONE];
		[seg addTitle:@"debuts" tag:TAG_DEBUTS];
		[seg addTitle:@"popular" tag:TAG_POPULAR];
		self.titleView = seg;
		
//		[self showBarButton:UINavigationBar.BARBUTTON_LEFT title:@"Clear"];
		[self showBarButton:UINavigationBar.BARBUTTON_RIGHT system:UIBarButtonSystemItemRefresh];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
		[_debutsModel loadCache];
		[_popularModel loadCache];
		[_everyoneModel loadCache];
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
		if ( self.firstEnter )
		{
			BeeUISegmentedControl * titleView = (BeeUISegmentedControl *)self.titleView;
			titleView.selectedTag = TAG_EVERYONE;
		}
		
		[self refresh:self.firstEnter];
	}
	else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
	{
	}
}

- (void)handleUISignal_UINavigationBar:(BeeUISignal *)signal
{
	if ( [signal is:UINavigationBar.BACK_BUTTON_TOUCHED] )
	{	
	}
	else if ( [signal is:UINavigationBar.DONE_BUTTON_TOUCHED] )
	{
		[self refresh:YES];
	}	
}

- (void)handleUISignal_BeeUISegmentedControl:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUISegmentedControl.HIGHLIGHT_CHANGED] )
	{
		[self reloadData];
		[self scrollToTop:YES];
		
		[self refresh:NO];
	}
}

- (void)handleUISignal_BeeUITableBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUITableBoard.PULL_REFRESH] )
	{
		[self refresh:YES];
	}
}

- (void)handleMessage:(BeeMessage *)msg
{
	[super handleMessage:msg];
}

- (void)handleMessage_DribbbleController:(BeeMessage *)msg
{
	[super handleMessage:msg];
	
	if ( [msg is:DribbbleController.GET_SHOTS] )
	{
		if ( msg.sending )
		{
			BeeUIActivityIndicatorView * indicator = [BeeUIActivityIndicatorView spawn];
			[self showBarButton:UINavigationBar.BARBUTTON_RIGHT custom:indicator];
			[indicator startAnimating];						
			
			[self setPullLoading:YES];
		}
		else
		{
			[self showBarButton:UINavigationBar.BARBUTTON_RIGHT system:UIBarButtonSystemItemRefresh];
			
			[self setPullLoading:NO];
		}

		if ( msg.succeed || msg.failed )
		{
			[self.tableView flashScrollIndicators];
		}
		
		[self asyncReloadData];
	}
}

- (void)refresh:(BOOL)force
{	
	[self cancelMessages];

	BeeUISegmentedControl * titleView = (BeeUISegmentedControl *)self.titleView;

	if ( TAG_EVERYONE == titleView.selectedTag )
	{
		if ( 0 == _everyoneModel.shots.count || force )
		{
			[_everyoneModel fetchShots];
		}
	}
	else if ( TAG_DEBUTS == titleView.selectedTag )
	{
		if ( 0 == _debutsModel.shots.count || force )
		{
			[_debutsModel fetchShots];
		}
	}
	else if ( TAG_POPULAR == titleView.selectedTag )
	{
		if ( 0 == _popularModel.shots.count || force )
		{
			[_popularModel fetchShots];
		}
	}
}

- (NSArray *)shots
{
	BeeUISegmentedControl * titleView = (BeeUISegmentedControl *)self.titleView;
	
	if ( TAG_EVERYONE == titleView.selectedTag )
	{
		return _everyoneModel.shots;
	}
	else if ( TAG_DEBUTS == titleView.selectedTag )
	{
		return _debutsModel.shots;
	}
	else if ( TAG_POPULAR == titleView.selectedTag )
	{
		return _popularModel.shots;
	}

	return [NSArray array];
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSData * data = [[self shots] safeObjectAtIndex:indexPath.row];
	CGSize bound = CGSizeMake( self.view.bounds.size.width, 0.0f );
	return [DribbbleCell sizeInBound:bound forData:data].height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self shots].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BeeUITableViewCell * cell = (BeeUITableViewCell *)[self dequeueWithContentClass:[DribbbleCell class]];
	if ( cell )
	{
		cell.cellData = [[self shots] safeObjectAtIndex:indexPath.row];
		return cell;
	}

	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];

	DribbblePhotoBoard * board = [[[DribbblePhotoBoard alloc] init] autorelease];
	board.feed = [[self shots] safeObjectAtIndex:indexPath.row];
	[self.stack pushBoard:board animated:YES];
}

@end
