//
//  Lession6Board.m
//

#import "Lession6Board.h"

#pragma mark -

@implementation Lession6Cell

+ (CGSize)cellSize:(NSObject *)data bound:(CGSize)bound
{
	return CGSizeMake( bound.width, [(NSNumber *)data floatValue] );
}

- (void)cellLayout:(BeeUIGridCell *)cell bound:(CGSize)bound
{
	CGRect photoFrame;
	photoFrame.origin = CGPointZero;
	photoFrame.size.width = bound.width;
	photoFrame.size.height = [(NSNumber *)cell.cellData floatValue];
	[cell subview:@"_photo"].frame = photoFrame;
	
	CGRect labelFrame;
	labelFrame.size.width = bound.width;
	labelFrame.size.height = 20.0f;
	labelFrame.origin.x = 0.0f;
	labelFrame.origin.y = photoFrame.size.height - labelFrame.size.height;
	[cell subview:@"_label"].frame = labelFrame;
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

	_label = [[BeeUILabel alloc] init];
	_label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
	_label.textAlignment = UITextAlignmentCenter;
	_label.textColor = [UIColor whiteColor];
	_label.font = [BeeUIFont height:12.0f bold:YES];
	[self addSubview:_label];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _photo );
	SAFE_RELEASE_SUBVIEW( _label );
	
	[super unload];
}

- (void)bindData:(NSObject *)data
{
	_photo.resource = @"icon.png";
	_label.text = [NSString stringWithFormat:@"height = %.0f", [(NSNumber *)data floatValue]];

	[super bindData:data];
}

- (void)clearData
{
	_photo.image = nil;
	_label.text = nil;
}

@end

#pragma mark -

@implementation Lession6Board

DEF_SINGLETON( Lession6Board );

- (void)load
{
	[super load];
	
	_datas = [[NSMutableArray alloc] init];
	for ( CGFloat i = 50.0f; i < 520.0f; i += 20.0f )
	{
		[_datas addObject:__FLOAT(i)];		
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

	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			[self setTitleString:@"Lession 6"];
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

- (NSInteger)numberOfColumns
{
	return 3.0f;
}

- (NSInteger)numberOfViews
{
	return _datas.count;
}

- (UIView *)viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	NSNumber * data = [_datas objectAtIndex:index];
	Lession6Cell * cell = (Lession6Cell *)[self dequeueWithContentClass:[Lession6Cell class]];
	if ( cell )
	{
		[cell bindData:data];
	}
	return cell;
}

- (CGSize)sizeForIndex:(NSInteger)index
{
	CGSize cellSize;
	cellSize.width = self.viewSize.width / 3.0f;
	cellSize.height = [(NSNumber *)[_datas objectAtIndex:index] floatValue];
	return cellSize;
}

@end
