//
//  Lession5Board.m
//

#import "Lession5Board.h"
#import "Bee_Runtime.h"

#pragma mark -

@implementation Lession5CellLayout1

DEF_SINGLETON(Lession5CellLayout1)

+ (CGSize)cellSize:(NSObject *)data bound:(CGSize)bound
{
	return CGSizeMake( bound.width, 100.0f );
}

- (void)cellLayout:(BeeUIGridCell *)cell bound:(CGSize)bound
{
	CGRect photoFrame;
	photoFrame.origin = CGPointZero;
	photoFrame.size.width = bound.width / 3.0f;
	photoFrame.size.height = 100.0f;

	[cell subview:@"_photo1"].frame = photoFrame;
	[cell subview:@"_photo2"].frame = CGRectOffset( photoFrame, photoFrame.size.width, 0.0f );
	[cell subview:@"_photo3"].frame = CGRectOffset( photoFrame, photoFrame.size.width * 2.0f, 0.0f );
}

@end

#pragma mark -

@implementation Lession5CellLayout2

DEF_SINGLETON(Lession5CellLayout2)

+ (CGSize)cellSize:(NSObject *)data bound:(CGSize)bound
{
	return CGSizeMake( bound.width, 100.0f );
}

- (void)cellLayout:(BeeUIGridCell *)cell bound:(CGSize)bound
{
	CGRect photoFrame;
	photoFrame.origin = CGPointZero;
	photoFrame.size.width = bound.width / 2.0f;
	photoFrame.size.height = 100.0f;

	[cell subview:@"_photo1"].frame = photoFrame;
	
	photoFrame.origin.x = bound.width / 2.0f;
	photoFrame.origin.y = 0.0f;
	photoFrame.size.width = bound.width / 2.0f;
	photoFrame.size.height = bound.height / 2.0f;

	[cell subview:@"_photo2"].frame = photoFrame;
	[cell subview:@"_photo3"].frame = CGRectOffset( photoFrame, 0.0f, photoFrame.size.height );
}

@end

#pragma mark -

@implementation Lession5Cell

- (void)load
{
	[super load];
	
	self.layer.borderColor = [UIColor blackColor].CGColor;
	self.layer.borderWidth = 2.0f;
	
	_photo1 = [[BeeUIImageView alloc] init];
	_photo1.layer.borderColor = [UIColor blackColor].CGColor;
	_photo1.layer.borderWidth = 1.0f;
	_photo1.contentMode = UIViewContentModeScaleAspectFill;
	_photo1.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	[_photo1 makeTappable];
	[self addSubview:_photo1];

	_photo2 = [[BeeUIImageView alloc] init];
	_photo2.layer.borderColor = [UIColor blackColor].CGColor;
	_photo2.layer.borderWidth = 1.0f;
	_photo2.contentMode = UIViewContentModeScaleAspectFill;
	_photo2.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	[_photo2 makeTappable];
	[self addSubview:_photo2];

	_photo3 = [[BeeUIImageView alloc] init];
	_photo3.layer.borderColor = [UIColor blackColor].CGColor;
	_photo3.layer.borderWidth = 1.0f;
	_photo3.contentMode = UIViewContentModeScaleAspectFill;
	_photo3.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	[_photo3 makeTappable];
	[self addSubview:_photo3];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _photo1 );
	SAFE_RELEASE_SUBVIEW( _photo2 );
	SAFE_RELEASE_SUBVIEW( _photo3 );
	
	[super unload];
}

- (void)bindData:(NSObject *)data
{
	_photo1.resource = @"icon.png";
	_photo2.resource = @"icon.png";
	_photo3.resource = @"icon.png";

	[super bindData:data];
}

- (void)clearData
{
	_photo1.image = nil;
	_photo2.image = nil;
	_photo3.image = nil;
}

@end

#pragma mark -

@implementation Lession5Board

DEF_SINGLETON( Lession5Board );

- (void)load
{
	[super load];
	
	_datas = [[NSMutableArray alloc] init];
	[_datas addObject:__INT(0)];
	[_datas addObject:__INT(1)];
	[_datas addObject:__INT(0)];
	[_datas addObject:__INT(1)];
	[_datas addObject:__INT(0)];
	[_datas addObject:__INT(1)];
}

- (void)unload
{
	[_datas removeAllObjects];
	[_datas release];
	
	[super unload];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			[self setTitleString:@"Lession 5"];
			[self showNavigationBarAnimated:NO];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
		}
		else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
		{
		}
		else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
		{
		}
		else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
		{
		}
		else if ( [signal is:BeeUIBoard.BACK_BUTTON_TOUCHED] )
		{
			
		}
		else if ( [signal is:BeeUIBoard.DONE_BUTTON_TOUCHED] )
		{
		}
	}
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSNumber * data = [_datas objectAtIndex:indexPath.row];
	if ( 0 == [data intValue] )
	{
		CGSize bound = CGSizeMake( self.view.bounds.size.width, 0.0f );
		return [Lession5CellLayout1 cellSize:data bound:bound].height;
	}
	else
	{
		CGSize bound = CGSizeMake( self.view.bounds.size.width, 0.0f );
		return [Lession5CellLayout2 cellSize:data bound:bound].height;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BeeUITableViewCell * cell = (BeeUITableViewCell *)[self dequeueWithContentClass:[Lession5Cell class]];
	if ( cell )
	{		
		NSNumber * data = [_datas objectAtIndex:indexPath.row];
		if ( 0 == [data intValue] )
		{
			[cell.innerCell setLayout:[Lession5CellLayout1 sharedInstance]];
		}
		else
		{
			[cell.innerCell setLayout:[Lession5CellLayout2 sharedInstance]];
		}
		[cell bindData:data];
		return cell;
	}

	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
