//
//  Lesson5Board.m
//

#import "Lesson5Board.h"
#import "Bee_Runtime.h"

#pragma mark -

@implementation Lesson5CellLayout1

DEF_SINGLETON(Lesson5CellLayout1)

+ (CGSize)sizeInBound:(CGSize)bound forData:(NSObject *)data
{
	return CGSizeMake( bound.width, 100.0f );
}

- (void)layoutInBound:(CGSize)bound forCell:(BeeUIGridCell *)cell
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

@implementation Lesson5CellLayout2

DEF_SINGLETON(Lesson5CellLayout2)

+ (CGSize)sizeInBound:(CGSize)bound forData:(NSObject *)data
{
	return CGSizeMake( bound.width, 200.0f );
}

- (void)layoutInBound:(CGSize)bound forCell:(BeeUIGridCell *)cell
{
	CGRect photoFrame;
	photoFrame.origin = CGPointZero;
	photoFrame.size.width = 212.0f;
	photoFrame.size.height = bound.height;

	[cell subview:@"_photo1"].frame = photoFrame;
	
	photoFrame.origin.x = CGRectGetMaxX(photoFrame);
	photoFrame.origin.y = 0.0f;
	photoFrame.size.width = bound.width - photoFrame.size.width;
	photoFrame.size.height = bound.height / 2.0f;

	[cell subview:@"_photo2"].frame = photoFrame;
	[cell subview:@"_photo3"].frame = CGRectOffset( photoFrame, 0.0f, photoFrame.size.height );
}

@end

#pragma mark -

@implementation Lesson5Cell

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

- (void)dataWillChange
{
	[super dataWillChange];
}

- (void)dataDidChanged
{
	if ( self.cellData )
	{
		_photo1.url = @"http://dribbble.s3.amazonaws.com/users/2862/screenshots/802586/asiabear.jpg";
		_photo2.url = @"http://dribbble.s3.amazonaws.com/users/91300/screenshots/802850/d109_dark_side_buddy.jpg";
		_photo3.url = @"http://dribbble.s3.amazonaws.com/users/161397/screenshots/802804/screen_shot_2012-11-06_at_9.20.44_am.png";
	}
	else
	{
		_photo1.image = nil;
		_photo2.image = nil;
		_photo3.image = nil;
	}
}

@end

#pragma mark -

@implementation Lesson5Board

DEF_SINGLETON( Lesson5Board );

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
}

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		[self setTitleString:@"Lesson 5"];
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
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSNumber * data = [_datas objectAtIndex:indexPath.row];
	if ( 0 == [data intValue] )
	{
		CGSize bound = CGSizeMake( self.view.bounds.size.width, 0.0f );
		return [Lesson5CellLayout1 sizeInBound:bound forData:data].height;
	}
	else
	{
		CGSize bound = CGSizeMake( self.view.bounds.size.width, 0.0f );
		return [Lesson5CellLayout2 sizeInBound:bound forData:data].height;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BeeUITableViewCell * cell = (BeeUITableViewCell *)[self dequeueWithContentClass:[Lesson5Cell class]];
	if ( cell )
	{		
		NSNumber * data = [_datas objectAtIndex:indexPath.row];
		if ( 0 == [data intValue] )
		{
			cell.cellLayout = [Lesson5CellLayout1 sharedInstance];
		}
		else
		{
			cell.cellLayout = [Lesson5CellLayout2 sharedInstance];
		}
		
		cell.cellData = data;
		return cell;
	}

	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
