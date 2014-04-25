//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
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
	BOOL		_layouted;
	BOOL		_layoutOnce;
}

+ (BeeUICell *)temporary;

- (void)initSelf;
- (void)relayoutSubviews:(CGRect)bound;

@end

#pragma mark -

@implementation BeeUICell

IS_CONTAINABLE( YES )

DEF_INT( STATE_NORMAL,		0 )
DEF_INT( STATE_DISABLED,	1 )
DEF_INT( STATE_SELECTED,	2 )
DEF_INT( STATE_HIGHLIGHTED,	3 )

//DEF_SIGNAL( DATA_WILL_CHANGE )
//DEF_SIGNAL( DATA_DID_CHANGED )
//
//DEF_SIGNAL( LAYOUT_WILL_BEGIN )
//DEF_SIGNAL( LAYOUT_DID_FINISH )
//
//DEF_SIGNAL( STATE_WILL_CHANGE )
//DEF_SIGNAL( STATE_DID_CHANGED )

SUPPORT_RESOURCE_LOADING( YES )
SUPPORT_SIZE_ESTIMATING( YES )

@dynamic data;
@dynamic state;

@dynamic disabled;
@dynamic selected;
@dynamic highlighted;

@synthesize layouted = _layouted;
@synthesize layoutOnce = _layoutOnce;

@dynamic RELAYOUT;

#pragma mark -

+ (id)cell
{
	return [[[self alloc] init] autorelease];
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

+ (CGSize)estimateUISizeByBound:(CGSize)bound forData:(id)data
{
	BeeUICell * cell = [self temporary];
	if ( cell )
	{
		cell.data = data;

		CGRect cellBound = CGRectMake( 0, 0, bound.width, bound.height );
		CGRect cellFrame = [cell.layout estimateFor:cell inBound:cellBound];
		return cellFrame.size;
	}
	
	return [super estimateUISizeByBound:bound forData:data];
}

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
	BeeUICell * cell = [self temporary];
	if ( cell )
	{
		cell.data = data;
		
		CGRect cellBound = CGRectMake( 0.0f, 0.0f, width, -1.0f );
		CGRect cellFrame = [cell.layout estimateFor:cell inBound:cellBound];
		return cellFrame.size;
	}
	
	return [super estimateUISizeByWidth:width forData:data];
}

+ (CGSize)estimateUISizeByHeight:(CGFloat)height forData:(id)data
{
	BeeUICell * cell = [self temporary];
	if ( cell )
	{
		cell.data = data;

		CGRect cellBound = CGRectMake( 0.0f, 0.0f, -1.0f, height );
		CGRect cellFrame = [cell.layout estimateFor:cell inBound:cellBound];
		return cellFrame.size;
	}
	
	return [super estimateUISizeByHeight:height forData:data];
}

- (CGSize)estimateUISizeByBound:(CGSize)bound
{
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
	self.layer.opaque = YES;
	self.layer.masksToBounds = YES;

	_data = nil;
	_state = self.STATE_NORMAL;

//	[self load];
	[self performLoad];
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
//	[self unload];
	[self performUnload];

	[_data release];
	_data = nil;

	[super dealloc];
}

- (void)setFrame:(CGRect)rc
{
	BOOL shouldChange = [self frameWillChange:rc];
	if ( shouldChange )
	{
		[self frameWillChange];	// backward compatible
		
		[super setFrame:rc];

		if ( NO == CGSizeEqualToSize( [super frame].size, CGSizeZero ) )
		{
			CGRect bound = CGRectMake( 0, 0, rc.size.width, rc.size.height );
			
			[self relayoutSubviews:bound];
			[self setNeedsDisplay];
		}
		
		[self frameDidChanged];
	}
}

- (void)setCenter:(CGPoint)pt
{
	[super setCenter:pt];

	if ( NO == CGSizeEqualToSize( [super frame].size, CGSizeZero ) )
	{
		CGRect bound = CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height );
		
		[self relayoutSubviews:bound];
		[self setNeedsDisplay];
	}
}

- (void)relayoutSubviews:(CGRect)bound
{
	if ( CGSizeEqualToSize( bound.size, CGSizeZero ) )
	{
//		WARN( @"'%@' relayoutSubviews, zero size", [[self class] description] );
		return;
	}
	
	if ( self.layouted && self.layoutOnce )
	{
		return;
	}
	
	[self layoutWillBegin];

	BeeUILayout * viewLayout = [self layout];
	if ( viewLayout )
	{
		[viewLayout layoutFor:self inBound:bound];
	}
	else
	{
		[self layoutSubviews];
	}			

	for ( UIView * subview in self.subviews )
	{
		if ( [subview isKindOfClass:[BeeUICell class]] )
		{
			CGRect subviewBound = CGRectMake( 0, 0, subview.frame.size.width, subview.frame.size.height );
			[(BeeUICell *)subview relayoutSubviews:subviewBound];
		}
	}

	[self layoutDidFinish];
	
	self.layouted = YES;
	
	[self setNeedsDisplay];
}

- (BeeUICellBlock)RELAYOUT
{
	BeeUICellBlock block = ^ BeeUICell * ( void )
	{
		CGRect bound = CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height );
		[self relayoutSubviews:bound];
		
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
	BOOL shouldChange = [self dataWillChange:newData];
	if ( shouldChange )
	{
		[self dataWillChange];

		[newData retain];
		[_data release];
		_data = newData;
		
		[self dataDidChanged];
		
		[self relayoutSubviews:self.bounds];
	}
}

- (void)unbindData
{
	BOOL shouldChange = [self dataWillChange:nil];
	if ( shouldChange )
	{
		[self dataWillChange];
		
		[_data release];
		_data = nil;
		
		[self dataDidChanged];
		[self relayoutSubviews:self.bounds];
	}
}

#pragma mark -

- (id)data
{
	return _data;
}

- (void)setData:(id)data
{
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

		CGRect bound = CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height );
		
		[self relayoutSubviews:bound];
		[self setNeedsDisplay];
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

- (BOOL)frameWillChange:(CGRect)newRect
{
	return YES;
}

- (void)frameWillChange
{
}

- (void)frameDidChanged
{
}

- (BOOL)dataWillChange:(id)newData
{
	return YES;
}

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
