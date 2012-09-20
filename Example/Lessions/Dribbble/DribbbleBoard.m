//
//  DribbbleBoard.m
//

#import "DribbbleBoard.h"
#import "DribbbleController.h"
#import "DribbblePhotoBoard.h"

#pragma mark -

@implementation DribbbleCell

+ (CGSize)cellSize:(NSObject *)data bound:(CGSize)bound
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
	else
	{
		return [super cellSize:data bound:bound];
	}
}

- (void)cellLayout:(BeeUIGridCell *)cell bound:(CGSize)bound
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
	_title.font = [BeeUIFont height:12.0f bold:YES];
	[self addSubview:_title];

	_time = [[BeeUILabel alloc] init];
	_time.textAlignment = UITextAlignmentRight;
	_time.textColor = [UIColor whiteColor];
	_time.font = [BeeUIFont height:12.0f bold:YES];
	[self addSubview:_time];
	
	_name = [[BeeUILabel alloc] init];
	_name.textAlignment = UITextAlignmentLeft;
	_name.textColor = [UIColor lightGrayColor];
	_name.font = [BeeUIFont height:12.0f bold:YES];
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

- (void)bindData:(NSObject *)data
{
	[_photo GET:[(NSDictionary *)data stringAtPath:@"/image_teaser_url"] useCache:YES];
	[_avatar GET:[(NSDictionary *)data stringAtPath:@"/player/avatar_url"] useCache:YES];
	[_title setText:[(NSDictionary *)data stringAtPath:@"/title"]];
	[_time setText:[[(NSDictionary *)data stringAtPath:@"/created_at"] substringToIndex:10]];
	[_name setText:[NSString stringWithFormat:@"by %@", [(NSDictionary *)data stringAtPath:@"/player/name"]]];

	[super bindData:data];
}

- (void)clearData
{
	[_photo setImage:nil];
	[_avatar setImage:nil];
	[_title setText:nil];
	[_name setText:nil];
}

@end

#pragma mark -

#define TAG_EVERYONE	(0)
#define TAG_DEBUTS		(1)
#define TAG_POPULAR		(2)

#define COUNT_PER_PAGE	(30)

@interface DribbbleBoard(Private)
- (void)refresh;
- (NSArray *)shots;
@end

@implementation DribbbleBoard

DEF_SINGLETON( DribbbleBoard );

- (void)load
{
	[super load];
	
	// init controllers
	[DribbbleController sharedInstance];
	
	// init models
	[DribbbleEveryoneModel sharedInstance];
	[DribbbleDebutsModel sharedInstance];
	[DribbblePopularModel sharedInstance];
}

- (void)unload
{
	[super unload];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			[self showNavigationBarAnimated:NO];
			
			BeeUISegmentedControl * seg = [BeeUISegmentedControl spawn];
			[seg addTitle:@"everyone" tag:TAG_EVERYONE];
			[seg addTitle:@"debuts" tag:TAG_DEBUTS];
			[seg addTitle:@"popular" tag:TAG_POPULAR];
			[self setTitleView:seg];
			 
			[self showPullLoader:YES animated:NO];
//			[self showBarButton:BEE_UIBOARD_BARBUTTON_LEFT title:@"Clear"];
			[self showBarButton:BEE_UIBOARD_BARBUTTON_RIGHT system:UIBarButtonSystemItemRefresh];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
		}
		else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
		{
			[[DribbbleEveryoneModel sharedInstance] loadCache];
			[[DribbbleDebutsModel sharedInstance] loadCache];
			[[DribbblePopularModel sharedInstance] loadCache];
		}
		else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
		{
			if ( self.firstEnter )
			{
				BeeUISegmentedControl * titleView = (BeeUISegmentedControl *)self.titleView;
				titleView.selectedTag = TAG_EVERYONE;
			}

			[self refresh];
		}
		else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
		{
		}
		else if ( [signal is:BeeUIBoard.BACK_BUTTON_TOUCHED] )
		{
			
		}
		else if ( [signal is:BeeUIBoard.DONE_BUTTON_TOUCHED] )
		{
			[self refresh];
		}
	}
	else if ( [signal isKindOf:BeeUISegmentedControl.SIGNAL] )
	{
		if ( [signal is:BeeUISegmentedControl.HIGHLIGHT_CHANGED] )
		{
			[self reloadData];
			[self scrollToTop:YES];
			
			[self refresh];
		}
	}
}

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg isKindOf:DribbbleController.SHOTS] )
	{
		if ( msg.sending )
		{
			BeeUIActivityIndicatorView * indicator = [BeeUIActivityIndicatorView spawn];
			[self showBarButton:BEE_UIBOARD_BARBUTTON_RIGHT custom:indicator];
			[indicator startAnimating];						

			[self showPullLoader:YES animated:YES];
		}
		else
		{
			[self showBarButton:BEE_UIBOARD_BARBUTTON_RIGHT system:UIBarButtonSystemItemRefresh];
			[self showPullLoader:NO animated:YES];
		}
		
		if ( msg.succeed || msg.failed )
		{
			[self.tableView flashScrollIndicators];
		}

		[self asyncReloadData];
	}
}

- (void)refresh
{	
	[self cancelMessages];

	BeeUISegmentedControl * titleView = (BeeUISegmentedControl *)self.titleView;
	if ( TAG_EVERYONE == titleView.selectedTag )
	{
		[[self sendMessage:DribbbleController.SHOTS_EVERYONE timeoutSeconds:10.0f] input:
		 @"page", __INT(0),
		 @"size", __INT(COUNT_PER_PAGE),
		 nil];
	}
	else if ( TAG_DEBUTS == titleView.selectedTag )
	{
		[[self sendMessage:DribbbleController.SHOTS_DEBUTS timeoutSeconds:10.0f] input:
		 @"page", __INT(0),
		 @"size", __INT(COUNT_PER_PAGE),
		 nil];
	}
	else if ( TAG_POPULAR == titleView.selectedTag )
	{
		[[self sendMessage:DribbbleController.SHOTS_POPULAR timeoutSeconds:10.0f] input:
		 @"page", __INT(0),
		 @"size", __INT(COUNT_PER_PAGE),
		 nil];
	}
}

- (NSArray *)shots
{
	BeeUISegmentedControl * titleView = (BeeUISegmentedControl *)self.titleView;
	
	if ( TAG_EVERYONE == titleView.selectedTag )
	{
		return [DribbbleEveryoneModel sharedInstance].shots;
	}
	else if ( TAG_DEBUTS == titleView.selectedTag )
	{
		return [DribbbleDebutsModel sharedInstance].shots;
	}
	else if ( TAG_POPULAR == titleView.selectedTag )
	{
		return [DribbblePopularModel sharedInstance].shots;
	}

	return [NSArray array];
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSData * data = [self.shots objectAtIndex:indexPath.row];
	CGSize bound = CGSizeMake( self.view.bounds.size.width, 0.0f );
	return [DribbbleCell cellSize:data bound:bound].height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.shots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BeeUITableViewCell * cell = (BeeUITableViewCell *)[self dequeueWithContentClass:[DribbbleCell class]];
	if ( cell )
	{		
		[cell bindData:[self.shots objectAtIndex:indexPath.row]];
		return cell;
	}

	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	
	DribbblePhotoBoard * board = [[[DribbblePhotoBoard alloc] init] autorelease];
	board.feed = [self.shots objectAtIndex:indexPath.row];
	[self.stack pushBoard:board animated:YES];
}

@end
