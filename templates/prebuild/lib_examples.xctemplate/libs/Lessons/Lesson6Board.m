//
//  Lesson6Board.m
//

#import "Lesson6Board.h"

#pragma mark -

@implementation Lesson6Cell

+ (CGSize)sizeInBound:(CGSize)bound forData:(NSObject *)data
{
	NSNumber * height = (NSNumber *)[(NSArray *)data objectAtIndex:0];
	return CGSizeMake( bound.width, height.floatValue );
}

- (void)layoutInBound:(CGSize)bound forCell:(BeeUIGridCell *)cell
{
	CGRect photoFrame;
	photoFrame.origin = CGPointZero;
	photoFrame.size.width = bound.width;
	photoFrame.size.height = bound.height;
	[cell subview:@"_photo"].frame = photoFrame;
}

- (void)load
{
	[super load];
	
	self.layer.borderColor = [UIColor blackColor].CGColor;
	self.layer.borderWidth = 2.0f;
	
	_photo = [[BeeUIImageView alloc] init];
	_photo.layer.borderColor = [UIColor blackColor].CGColor;
	_photo.layer.borderWidth = 1.0f;
	_photo.contentMode = UIViewContentModeScaleAspectFill;
	_photo.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	[_photo makeTappable];
	[self addSubview:_photo];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _photo );
	
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
		_photo.url = (NSString *)[(NSArray *)self.cellData objectAtIndex:1];
	}
	else
	{
		_photo.image = nil;
	}
}

@end

#pragma mark -

@implementation Lesson6Board

DEF_SINGLETON( Lesson6Board );

- (void)load
{
	[super load];
	
	_datas = [[NSMutableArray alloc] init];
	
	for ( ;; )
	{
		[_datas addObject:[NSArray arrayWithObjects:__INT(100), @"http://dribbble.s3.amazonaws.com/users/2862/screenshots/802586/asiabear.jpg", nil]];
		[_datas addObject:[NSArray arrayWithObjects:__INT(80), @"http://dribbble.s3.amazonaws.com/users/91300/screenshots/802850/d109_dark_side_buddy.jpg", nil]];
		[_datas addObject:[NSArray arrayWithObjects:__INT(120), @"http://dribbble.s3.amazonaws.com/users/161397/screenshots/802804/screen_shot_2012-11-06_at_9.20.44_am.png", nil]];
		[_datas addObject:[NSArray arrayWithObjects:__INT(100), @"http://dribbble.s3.amazonaws.com/users/4678/screenshots/803216/giantsize_1x.png", nil]];
		
		if ( _datas.count >= 500 )
			break;
	}
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
		[self setTitleString:@"Lesson 6"];
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
		[self.scrollView flashScrollIndicators];
	}
	else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
	{
	}
}

#pragma mark -

- (NSInteger)numberOfColumns
{
	return 3;
}

- (NSInteger)numberOfViews
{
	return _datas.count;
}

- (UIView *)viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	NSNumber * data = [_datas objectAtIndex:index];
	Lesson6Cell * cell = (Lesson6Cell *)[self dequeueWithContentClass:[Lesson6Cell class]];
	if ( cell )
	{
		cell.cellData = data;
	}
	return cell;
}

- (CGSize)sizeForIndex:(NSInteger)index
{
	NSArray * item = (NSArray *)[_datas objectAtIndex:index];
	NSNumber * height = (NSNumber *)[item objectAtIndex:0];
	
	CGSize cellSize;
	cellSize.width = self.viewSize.width / self.numberOfColumns;
	cellSize.height = height.floatValue;
	return cellSize;
}

@end
