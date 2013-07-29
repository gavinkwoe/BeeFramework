//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_UICell.h"
#import "UIView+LifeCycle.h"
#import "UIView+BeeUILayout.h"
#import "UIView+BeeUIStyle.h"
#import "UIView+BeeUITemplate.h"

#import "Bee_UIStyle.h"
#import "Bee_UILayout.h"
#import "Bee_UITemplate.h"
#import "Bee_UIDataBinding.h"

#pragma mark -

@interface BeeUICell()
{
	id			_data;
	NSUInteger	_state;
}

+ (BeeUICell *)temporary;

- (void)initSelf;
- (void)relayoutSubviews;

@end

#pragma mark -

@implementation BeeUICell

DEF_INT( STATE_NORMAL,		0 )
DEF_INT( STATE_DISABLED,	1 )
DEF_INT( STATE_SELECTED,	2 )
DEF_INT( STATE_HIGHLIGHTED,	3 )

@dynamic data;
@dynamic state;

@dynamic disabled;
@dynamic selected;
@dynamic highlighted;

@dynamic RELAYOUT;

#pragma mark -

+ (BOOL)supportForUIAutomaticLayout
{
	return YES;
}

+ (BeeUICell *)temporary
{
	BeeUICell * cell = nil;

	if ( [self supportForUIAutomaticLayout] )
	{
		static NSMutableDictionary * __temporaries = nil;

		if ( nil == __temporaries )
		{
			__temporaries = [[NSMutableDictionary alloc] init];
		}

		if ( __temporaries )
		{
			NSString * identifier = [[self class] description];

			cell = [__temporaries objectForKey:identifier];
			if ( nil == cell )
			{
				cell = [[[[self class] alloc] init] autorelease];
				cell.frame = CGRectZero;

				[__temporaries setObject:cell forKey:identifier];
			}
		}
	}
	
	return cell;
}

#pragma mark -

+ (BOOL)supportForUISizeEstimating
{
	return NO;
}

+ (CGSize)estimateUISizeByBound:(CGSize)bound forData:(id)data
{
	if ( [self respondsToSelector:@selector(sizeInBound:forData:)] )
	{
		return [self sizeInBound:bound forData:data];
	}
	
	BeeUICell * cell = [self temporary];
	if ( cell )
	{
		cell.data = data;

		CGRect cellFrame = [cell.layout estimateFrameBy:CGSizeMakeBound(bound)];
		return cellFrame.size;
	}
	
	return [super estimateUISizeByBound:bound forData:data];
}

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
	if ( [self respondsToSelector:@selector(sizeInBound:forData:)] )
	{
		return [self sizeInBound:CGSizeMake(width, 0) forData:data];
	}

	BeeUICell * cell = [self temporary];
	if ( cell )
	{
		cell.data = data;
		
		CGRect cellBound = CGRectMake( 0.0f, 0.0f, width, 0.0f );
		CGRect cellFrame = [cell.layout estimateFrameBy:cellBound];
		return cellFrame.size;
	}
	
	return [super estimateUISizeByWidth:width forData:data];
}

+ (CGSize)estimateUISizeByHeight:(CGFloat)height forData:(id)data
{
	if ( [self respondsToSelector:@selector(sizeInBound:forData:)] )
	{
		return [self sizeInBound:CGSizeMake(0, height) forData:data];
	}

	BeeUICell * cell = [self temporary];
	if ( cell )
	{
		cell.data = data;

		CGRect cellBound = CGRectMake( 0.0f, 0.0f, 0.0f, height );
		CGRect cellFrame = [cell.layout estimateFrameBy:cellBound];
		return cellFrame.size;
	}
	
	return [super estimateUISizeByHeight:height forData:data];
}

- (CGSize)estimateUISizeByBound:(CGSize)bound
{
	if ( [self respondsToSelector:@selector(sizeInBound:forData:)] )
	{
		return [[self class] sizeInBound:bound forData:nil];
	}

	BeeUILayout * layout = self.layout;
	if ( layout )
	{
		return [layout estimateUISizeByBound:bound];
	}
	else
	{
		return CGSizeZero;
	}
}

- (CGSize)estimateUISizeByWidth:(CGFloat)width
{
	if ( [self respondsToSelector:@selector(sizeInBound:forData:)] )
	{
		return [[self class] sizeInBound:CGSizeMake(width, 0) forData:nil];
	}

	BeeUILayout * layout = self.layout;
	if ( layout )
	{
		return [layout estimateUISizeByWidth:width];
	}
	else
	{
		return CGSizeZero;
	}	
}

- (CGSize)estimateUISizeByHeight:(CGFloat)height
{
	if ( [self respondsToSelector:@selector(sizeInBound:forData:)] )
	{
		return [[self class] sizeInBound:CGSizeMake(0, height) forData:nil];
	}

	BeeUILayout * layout = self.layout;
	if ( layout )
	{
		return [layout estimateUISizeByHeight:height];
	}
	else
	{
		return CGSizeZero;
	}	
}

#pragma mark -

- (void)initSelf
{
	self.backgroundColor = [UIColor clearColor];
	self.alpha = 1.0f;
	self.layer.masksToBounds = YES;
	self.layer.opaque = YES;

	_data = nil;
	_state = self.STATE_NORMAL;

	if ( [[self class] supportForUIResourceLoading] )
	{
		self.LOAD_RESOURCE( [self UIResourceName] );
	}

	[self load];
}

- (id)init
{
	self = [super initWithFrame:CGRectZero];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		[self initSelf];
		[self setNeedsLayout];
	}
	return self;
}

- (void)dealloc
{
	[self unload];

	[_data release];
	_data = nil;

	[super dealloc];
}

- (void)load
{
    [super load];	
}

- (void)unload
{
    [super unload];
}

- (void)setFrame:(CGRect)rc
{
	if ( CGSizeEqualToSize(rc.size, CGSizeZero) )
	{
		return;
	}

	if ( NO == CGSizeEqualToSize(rc.size, self.frame.size) )
	{
		[super setFrame:rc];

		[self relayoutSubviews];
	}
	else
	{
		[super setFrame:rc];
	}
}

- (void)setCenter:(CGPoint)pt
{
	if ( NO == CGPointEqualToPoint(pt, self.center) )
	{
		[super setCenter:pt];

		[self relayoutSubviews];
	}
	else
	{
		[super setCenter:pt];
	}
}

- (void)relayoutSubviews
{
	if ( NO == CGSizeEqualToSize(self.bounds.size, CGSizeZero) )
	{
		[self layoutWillBegin];

		for ( UIView * subview in self.subviews )
		{
			if ( [subview isKindOfClass:[BeeUICell class]] )
			{
				[(BeeUICell *)subview relayoutSubviews];
			}

//			BeeUILayout * subviewLayout = [subview layout];
//			if ( subviewLayout )
//			{
//				subviewLayout.RELAYOUT();
//			}
		}

		if ( [self respondsToSelector:@selector(layoutInBound:forCell:)] )
		{
			[self layoutInBound:self.bounds.size forCell:self];
		}
		else
		{
			BeeUILayout * viewLayout = [self layout];
			if ( viewLayout )
			{
				viewLayout.RELAYOUT();
			}
			else
			{
				[self layoutSubviews];
			}			
		}

		[self layoutDidFinish];
	}
}

- (BeeUICellBlock)RELAYOUT
{
	BeeUICellBlock block = ^ BeeUICell * ( void )
	{
		[self relayoutSubviews];
		
		return self;
	};
	
	return [[block copy] autorelease];
}

#pragma mark -

- (id)bindedData
{
	return _data;
}

- (void)bindData:(id)newData
{
	[self dataWillChange];

	if ( _data != newData )
	{
		[newData retain];
		[_data release];
		_data = newData;
	}

	[self dataDidChanged];
	[self relayoutSubviews];
}

- (void)unbindData
{
	[_data release];
	_data = nil;

//	for ( UIView * view in self.subviews )
//	{
//		[view unbindData];
//	}
}

#pragma mark -

- (id)data
{
	return _data;
}

- (void)setData:(id)data
{
	[self unbindData];
	[self bindData:data];
}

- (NSUInteger)state
{
	return _state;
}

- (void)setState:(NSUInteger)value
{
	if ( value != _state )
	{
		[self stateWillChange];
		
		_state = value;
		
		[self stateDidChanged];
		[self relayoutSubviews];
	}
}

- (BOOL)disabled
{
	return (self.STATE_DISABLED == _state) ? YES : NO;
}

- (void)setDisabled:(BOOL)flag
{
	if ( flag )
	{
		[self setState:self.STATE_DISABLED];
	}
	else
	{
		[self setState:self.STATE_NORMAL];
	}
}

- (BOOL)selected
{
	return (self.STATE_SELECTED == _state) ? YES : NO;
}

- (void)setSelected:(BOOL)flag
{
	if ( flag )
	{
		[self setState:self.STATE_SELECTED];
	}
	else
	{
		[self setState:self.STATE_NORMAL];
	}
}

- (BOOL)highlighted
{
	return (self.STATE_HIGHLIGHTED == _state) ? YES : NO;
}

- (void)setHighlighted:(BOOL)flag
{
	if ( flag )
	{
		[self setState:self.STATE_HIGHLIGHTED];
	}
	else
	{
		[self setState:self.STATE_NORMAL];
	}
}

#pragma mark -

- (void)dataWillChange
{
}

- (void)dataDidChanged
{
}

- (void)layoutWillBegin
{
}

- (void)layoutDidFinish
{
}

- (void)stateWillChange
{
}

- (void)stateDidChanged
{
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
