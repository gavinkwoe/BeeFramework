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

#import "Bee_UILayout.h"
#import "Bee_UIStyle.h"

#import "UIView+BeeUISignal.h"
#import "UIView+BeeUIStyle.h"
#import "UIView+BeeUILayout.h"
#import "UIView+Tag.h"
#import "UIView+Traversing.h"

#pragma mark -

#undef	LAYOUT_MAX_WIDTH
#define LAYOUT_MAX_WIDTH	(5000.0f)

#undef	LAYOUT_MAX_HEIGHT
#define LAYOUT_MAX_HEIGHT	(5000.0f)

#pragma mark -

@implementation NSObject(BeeUISizeEstimating)

+ (BOOL)supportForUISizeEstimating
{
	return NO;
}

+ (CGSize)estimateUISizeByBound:(CGSize)bound forData:(id)data
{
	return CGSizeZero;
}

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
	return CGSizeMake( width, 0.0f );
}

+ (CGSize)estimateUISizeByHeight:(CGFloat)height forData:(id)data
{
	return CGSizeMake( 0.0f, height );
}

- (CGSize)estimateUISizeByBound:(CGSize)bound
{
	return CGSizeZero;
}

- (CGSize)estimateUISizeByWidth:(CGFloat)width
{
	return CGSizeMake( width, 0.0f );
}

- (CGSize)estimateUISizeByHeight:(CGFloat)height
{
	return CGSizeMake( 0.0f, height );
}

@end

#pragma mark -

@interface BeeUILayout()
{
	NSString *				_uniqueID;
	NSMutableArray *		_stack;
	BeeUILayout *			_root;
	BeeUILayout *			_parent;
	NSString *				_name;
	NSString *				_value;
	BeeUIStyle *			_style;
	NSString *				_styleID;
	NSMutableArray *        _styleClasses;
	UIView *				_canvas;
	Class					_classType;
	NSString *				_className;
	NSMutableArray *		_childs;
	NSMutableDictionary *	_childFrames;
	BOOL					_containable;
	BOOL					_visible;
	
	BOOL					_isRoot;
	NSMutableDictionary *	_rootStyles;
}
@end

#pragma mark -

@implementation BeeUILayout

@synthesize uniqueID = _uniqueID;
@synthesize containable = _containable;
@synthesize visible = _visible;
@synthesize root = _root;
@synthesize parent = _parent;
@synthesize name = _name;
@dynamic prettyName;
@synthesize value = _value;
@synthesize styleID = _styleID;
@synthesize styleClasses = _styleClasses;
@synthesize style = _style;
@synthesize classType = _classType;
@synthesize className = _className;
@synthesize childs = _childs;
@synthesize childFrames = _childFrames;
@dynamic canvas;
@dynamic view;

@synthesize isRoot = _isRoot;
@synthesize rootStyles = _rootStyles;

@dynamic ADD;
@dynamic REMOVE;
@dynamic REMOVE_ALL;

@dynamic EMPTY;
@dynamic REBUILD;
@dynamic RELAYOUT;

@dynamic BEGIN_LAYOUT;
@dynamic END_LAYOUT;
@dynamic BEGIN_CONTAINER;
@dynamic END_CONTAINER;
@dynamic VIEW;

@dynamic DUMP;

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ (%@, %@, %@, %@)",
			self.name,
			self.style.x ? [self.style.x description] : @"nil",
			self.style.y ? [self.style.y description] : @"nil",
			self.style.w ? [self.style.w description] : @"nil",
			self.style.h ? [self.style.h description] : @"nil"];
}

- (NSString *)prettyName
{
	NSMutableString * classes = [NSMutableString string];

	for ( NSString * str in _styleClasses )
	{
		[classes appendFormat:@"%@ ", str];
	}
	
	return [NSString stringWithFormat:@"%@ %@", _name, classes];
}

+ (NSString *)generateName
{
	static NSUInteger __seed = 0;
	return [NSString stringWithFormat:@"layout_%u", __seed++];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.uniqueID = [BeeUILayout generateName];
		self.containable = YES;
		self.visible = YES;
		self.root = self;
		self.parent = nil;
		self.name = self.uniqueID;
		self.value = nil;
		self.styleID = nil;
		self.styleClasses = [NSMutableArray array];
		self.styleInline = [[[BeeUIStyle alloc] init] autorelease];
		self.style = [[[BeeUIStyle alloc] init] autorelease];
		self.classType = nil;
		self.className = nil;
		self.childs = [NSMutableArray array];
		self.childFrames = [NSMutableDictionary dictionary];
		self.rootStyles = [[[NSMutableDictionary alloc] init] autorelease];
	}
	return self;
}

- (void)dealloc
{
	[self.childs removeAllObjects];
	self.childs = nil;

	[self.childFrames removeAllObjects];
	self.childFrames = nil;

	self.root = nil;
	self.parent = nil;
	self.name = nil;
	self.value = nil;
	self.styleID = nil;
	self.styleClasses = nil;
	self.styleInline = nil;
	self.style = nil;
	self.classType = nil;
	self.className = nil;
	self.uniqueID = nil;
	self.rootStyles = nil;

	[_stack removeAllObjects];
	[_stack release];
	_stack = nil;

	[super dealloc];
}

- (void)dump
{
#if (__ON__ == __BEE_DEVELOPMENT__)

	INFO( @"%@(%d childs) %@", self.name, self.childs.count, self );

	[[BeeLogger sharedInstance] indent];

	for ( BeeUILayout * child in self.childs )
	{
		[child dump];
	}

	[[BeeLogger sharedInstance] unindent];
	
#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
}

- (void)setCanvas:(UIView *)c;
{
	_canvas = c;
	
	for ( BeeUILayout * layout in self.childs )
	{
		[layout setCanvas:c];
	}
}

- (UIView *)view
{
	if ( nil == _canvas || nil == _name )
		return nil;
	
	return [_canvas viewWithTagString:_name];
}

- (UIView *)canvas
{
	return _canvas;
}

- (UIView *)buildView
{
	if ( nil == self.classType )
		return nil;

	if ( self.classType != [UIView class] && NO == [self.classType isSubclassOfClass:[UIView class]] )
		return nil;

//	INFO( @"buildView %@", [self.classType description] );
	
	UIView * view = [[[self.classType alloc] initWithFrame:CGRectZero] autorelease];
    
	if ( view )
	{
		view.tagString = self.name;
		view.tagClasses = self.styleClasses;
		view.nameSpace = self.root.name;
	}

	if ( self.style )
	{
		self.style.APPLY_FOR( view );
	}

	return view;
}

- (UIView *)buildViewAndSubviews
{
	UIView * view = [self buildView];
	if ( view )
	{
		for ( UIView * subview in [[view.subviews copy] autorelease] )
		{
			[subview removeFromSuperview];
		}

		[self buildSubviewsFor:view];
	}
	return view;
}

- (void)buildSubviewsForCanvas
{
	[self buildSubviewsFor:_canvas];
}

- (void)buildSubviewsFor:(UIView *)c depth:(NSUInteger)depth
{
	if ( nil == c )
	{
		ERROR( @"canvas not found" );
		return;
	}

	for ( BeeUILayout * layout in self.childs )
	{
		UIView * view = [layout buildView];
		if ( view )
		{
			[c addSubview:view];
			[c bringSubviewToFront:view];
		}
	}

	for ( BeeUILayout * layout in self.childs )
	{
		[layout buildSubviewsFor:c depth:(depth + 1)];
	}
	
	if ( 0 == depth )
	{
		[self reorderSubviewsFor:c];
	}
}

- (void)buildSubviewsFor:(UIView *)c
{
	[self buildSubviewsFor:c depth:0];
}

- (void)reorderSubviewsFor:(UIView *)c
{
	if ( nil == c )
	{
		ERROR( @"canvas not found" );
		return;
	}

	for ( BeeUILayout * layout in self.childs )
	{
		[layout reorderSubviewsFor:c];
	}

	UIView * view = self.view;
	if ( view )
	{
		[c bringSubviewToFront:view];
	}
}

- (BOOL)isRelativePosition
{
	if ( nil == self.style || nil == self.style.position )
	{
		return YES;	// default is relative
	}

	return [self.style.position isEqualToString:BeeUIStyle.POSITION_RELATIVE];
}

- (CGFloat)estimateXBy:(CGRect)parentFrame
{
	CGFloat newX = parentFrame.origin.x;

	BeeUIMetrics * x = self.style.x;
    if ( x )
    {
        if ( BeeUIMetrics.PIXEL == x.type )
        {
			newX = newX + x.value;
        }
        else if ( BeeUIMetrics.PERCENT == x.type )
        {
			newX = newX + floorf(  parentFrame.size.width * x.value / 100.0f );
        }
    }
    
	return newX;
}

- (CGFloat)estimateYBy:(CGRect)parentFrame
{
	CGFloat newY = parentFrame.origin.y;

	BeeUIMetrics * y = self.style.y;
    if ( y )
    {
        if ( BeeUIMetrics.PIXEL == y.type )
        {
			newY = newY + y.value;
        }
        else if ( BeeUIMetrics.PERCENT == y.type )
        {
			newY = newY + floorf( parentFrame.size.height * y.value / 100.0f );
        }
    }
	
	return newY;
}

- (CGPoint)estimateOriginForCanvas
{
	return [self estimateOriginBy:(_canvas ? _canvas.bounds : CGRectZero)];
}

- (CGPoint)estimateOriginBy:(CGRect)parentFrame
{
	CGPoint	origin = parentFrame.origin;
	origin.x = [self estimateXBy:parentFrame];
	origin.y = [self estimateYBy:parentFrame];
	return origin;
}

- (BOOL)isFlexiableW
{
	BeeUIMetrics * w = self.style.w;
	if ( w )
	{
		if ( BeeUIMetrics.PERCENT == w.type )
		{
			return YES;
		}
		else if ( BeeUIMetrics.FILL_PARENT == w.type )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)isFlexiableH
{
	BeeUIMetrics * h = self.style.h;
	if ( h )
	{
		if ( BeeUIMetrics.PERCENT == h.type )
		{
			return YES;
		}
		else if ( BeeUIMetrics.FILL_PARENT == h.type )
		{
			return YES;
		}
	}

	return NO;
}

- (CGFloat)estimateWBy:(CGRect)parentFrame
{
	CGSize	size = parentFrame.size;
	CGFloat	wPixels = 0.0f;

	BeeUIMetrics * w = self.style.w;
	if ( w )
	{
		if ( BeeUIMetrics.PIXEL == w.type )
		{
			wPixels = w.value;
		}
		else if ( BeeUIMetrics.PERCENT == w.type )
		{
			wPixels = floorf( size.width * w.value / 100.0f );
		}
		else if ( BeeUIMetrics.FILL_PARENT == w.type )
		{
			wPixels = size.width;
		}
		else if ( BeeUIMetrics.WRAP_CONTENT == w.type )
		{
			wPixels = -1.0f;
		}
		else
		{
			wPixels = size.width;
		}
	}
	else
	{
		wPixels = size.width;
	}

	return wPixels;
}

- (CGFloat)estimateHBy:(CGRect)parentFrame
{
	CGSize	size = parentFrame.size;
	CGFloat	hPixels = 0.0f;

	BeeUIMetrics * h = self.style.h;
	if ( h )
	{
		if ( BeeUIMetrics.PIXEL == h.type )
		{
			hPixels = h.value;
		}
		else if ( BeeUIMetrics.PERCENT == h.type )
		{
			hPixels = floorf( size.height * h.value / 100.0f );
		}
		else if ( BeeUIMetrics.FILL_PARENT == h.type )
		{
			hPixels = size.height;
		}
		else if ( BeeUIMetrics.WRAP_CONTENT == h.type )
		{
			hPixels = -1.0f;
		}
		else
		{
			hPixels = size.height;
		}
	}
	else
	{
		hPixels = size.height;
	}
	
	return hPixels;
}

- (CGSize)estimateSizeForCanvas
{
	CGRect parentFrame = (_canvas ? _canvas.bounds : CGRectZero);
	return [self estimateSizeBy:parentFrame];
}

- (CGSize)estimateSizeBy:(CGRect)parentFrame
{
	CGSize size;
	size.width = [self estimateWBy:parentFrame];
	size.height = [self estimateHBy:parentFrame];
	return size;
}

- (UIEdgeInsets)estimateMarginBy:(CGRect)parentFrame
{
    BeeUIMetrics * l = self.style.margin_left;
	BeeUIMetrics * r = self.style.margin_right;
	BeeUIMetrics * t = self.style.margin_top;
	BeeUIMetrics * b = self.style.margin_bottom;
    
	UIEdgeInsets edge = UIEdgeInsetsZero;
	
	if ( l )
	{
		edge.left = [l valueBy:parentFrame.size.width];
	}
	
	if ( r )
	{
		edge.right = [r valueBy:parentFrame.size.width];
	}
	
	if ( t )
	{
		edge.top = [t valueBy:parentFrame.size.height];
	}
	
	if ( b )
	{
		edge.bottom = [b valueBy:parentFrame.size.height];
	}
	
	return edge;
}

- (UIEdgeInsets)estimatePaddingBy:(CGRect)parentFrame
{
	BeeUIMetrics * l = self.style.padding_left;
	BeeUIMetrics * r = self.style.padding_right;
	BeeUIMetrics * t = self.style.padding_top;
	BeeUIMetrics * b = self.style.padding_bottom;
    
	UIEdgeInsets edge = UIEdgeInsetsZero;
	
	if ( l )
	{
		edge.left = [l valueBy:parentFrame.size.width];
	}
	
	if ( r )
	{
		edge.right = [r valueBy:parentFrame.size.width];
	}
	
	if ( t )
	{
		edge.top = [t valueBy:parentFrame.size.height];
	}
	
	if ( b )
	{
		edge.bottom = [b valueBy:parentFrame.size.height];
	}
	
	return edge;
}

- (CGRect)getViewFrame
{
	if ( nil == _name )
		return CGRectZero;

	NSValue * value = [self.root.childFrames objectForKey:_name];
	if ( nil == value )
		return CGRectZero;
	
	return [value CGRectValue];
}

- (void)setViewFrame:(CGRect)frame
{
	if ( nil == _name )
		return;

//	INFO( @"setFrame '%@', frame = (%.0f, %.0f, %.0f, %.0f)", self.prettyName,
//	   frame.origin.x, frame.origin.y,
//	   frame.size.width, frame.size.height );

	[self.root.childFrames setObject:[NSValue valueWithCGRect:frame] forKey:self.name];
}

- (BOOL)needAdjust:(BeeUIMetrics *)value
{
	BOOL need = NO;
	
	if ( value )
    {
		if ( BeeUIMetrics.PERCENT == value.type )
        {
			need = YES;
        }
		else if ( BeeUIMetrics.FILL_PARENT == value.type )
        {
			need = YES;
        }
    }

	return need;
}

- (void)adjustFloatingBy:(CGRect)parentFrame margin:(UIEdgeInsets)margin padding:(UIEdgeInsets)padding
{
	for ( BeeUILayout * child in self.childs )
	{
		if ( NO == [child isRelativePosition] )
		{
			CGRect frame = [child getViewFrame];
			
			if ( frame.size.width >= LAYOUT_MAX_WIDTH )
			{
				frame.size.width = [child estimateWBy:parentFrame];
			}
			
			if ( frame.size.height >= LAYOUT_MAX_HEIGHT )
			{
				frame.size.height = [child estimateHBy:parentFrame];
			}

//			UIEdgeInsets padding = [child estimatePaddingBy:parentFrame];
//			frame.origin.x += padding.left;
//			frame.origin.y += padding.top;
//			frame.size.width -= (padding.left + padding.right);
//			frame.size.height -= (padding.top + padding.bottom);

			[child setViewFrame:frame];
			
			continue;
		}

		NSString * floating = child.style.floating;
		NSString * v_floating = child.style.v_floating;
		
		if ( nil == floating && nil == v_floating )
			continue;

		CGRect frame = [child getViewFrame];
		CGSize offset = CGSizeZero;

		if ( [child isRelativePosition] )
		{
			if ( [child needAdjust:child.style.x] )
			{
				frame.origin.x = [child estimateXBy:parentFrame];
			}
			
			if ( [child needAdjust:child.style.y] )
			{
				frame.origin.y = [child estimateYBy:parentFrame];
			}
		}
		
		if ( [child needAdjust:child.style.w] )
		{
			frame.size.width = [child estimateWBy:parentFrame];
		}
		
		if ( [child needAdjust:child.style.h] )
		{
			frame.size.height = [child estimateHBy:parentFrame];
		}
			
		if ( floating )
		{
			if ( [floating isEqualToString:child.style.ALIGN_CENTER] )
			{
				frame = CGRectAlignX( frame, parentFrame );
			}
			else if ( [floating isEqualToString:child.style.ALIGN_RIGHT] )
			{
				frame = CGRectAlignRight( frame, parentFrame );
			}
			else
			{
				frame = CGRectAlignLeft( frame, parentFrame );
			}

			CGSize size = CGRectGetDistance( parentFrame, frame );

			offset.width += size.width;
//			offset.height += size.height;
		}
		
		if ( v_floating )
		{
			if ( [v_floating isEqualToString:child.style.ALIGN_CENTER] )
			{
				frame = CGRectAlignY( frame, parentFrame );
			}
			else if ( [v_floating isEqualToString:child.style.ALIGN_BOTTOM] )
			{
				frame = CGRectAlignBottom( frame, parentFrame );
			}
			else
			{
				frame = CGRectAlignTop( frame, parentFrame );
			}
			
			// reset the childs'frame
			CGSize size = CGRectGetDistance( parentFrame, frame );

//			offset.width += size.width;
			offset.height += size.height;
		}

		if ( NO == CGSizeEqualToSize(offset, CGSizeZero) )
		{
			[child offsetChildsFrameBy:offset];
		}

//		UIEdgeInsets margin = [child estimateMarginBy:parentFrame];
//		frame.origin.x += margin.left;
//		frame.origin.y += margin.top;

		UIEdgeInsets padding = [child estimatePaddingBy:parentFrame];		
		frame.origin.x += padding.left;
		frame.origin.y += padding.top;
		frame.size.width -= (padding.left + padding.right);
		frame.size.height -= (padding.top + padding.bottom);

		[child setViewFrame:frame];

		NSMutableString * classes = [NSMutableString string];
		for ( NSString * str in child.styleClasses )
		{
			[classes appendFormat:@"%@ ", str];
		}

//		INFO( @"adjustFrame '%@', frame = (%.0f, %.0f, %.0f, %.0f)", child.prettyName,
//		   frame.origin.x, frame.origin.y,
//		   frame.size.width, frame.size.height );
	}
}

- (void)adjustAlignmentBy:(CGRect)thisFrame margin:(UIEdgeInsets)margin padding:(UIEdgeInsets)padding
{
	NSString * align = self.style.align;
	NSString * v_align = self.style.v_align;

	if ( nil == align && nil == v_align )
		return;

	for ( BeeUILayout * child in self.childs )
	{
		if ( NO == [child isRelativePosition] )
			continue;

		CGSize offset = CGSizeZero;
		CGRect childFrame = [child getViewFrame];

		NSString * floating = child.style.floating;
		NSString * v_floating = child.style.v_floating;

		if ( align && nil == floating )
		{
			CGRect adjustedFrame = childFrame;
			
			if ( [align isEqualToString:BeeUIStyle.ALIGN_CENTER] )
			{
				adjustedFrame = CGRectAlignX( childFrame, thisFrame );
			}
			else if ( [align isEqualToString:BeeUIStyle.ALIGN_RIGHT] )
			{
				adjustedFrame = CGRectAlignRight( childFrame, thisFrame );
			}
			else if ( [align isEqualToString:BeeUIStyle.ALIGN_LEFT] )
			{
				adjustedFrame = CGRectAlignLeft( childFrame, thisFrame );
			}
			
			CGSize size = CGRectGetDistance( childFrame, adjustedFrame );
			
			offset.width += size.width;
			offset.height += size.height;
		}
		
		if ( v_align && nil == v_floating )
		{
			CGRect adjustedFrame = childFrame;
			
			if ( [v_align isEqualToString:BeeUIStyle.ALIGN_CENTER] )
			{
				adjustedFrame = CGRectAlignY( childFrame, thisFrame );
			}
			else if ( [v_align isEqualToString:BeeUIStyle.ALIGN_BOTTOM] )
			{
				adjustedFrame = CGRectAlignBottom( childFrame, thisFrame );
			}
			else if ( [v_align isEqualToString:BeeUIStyle.ALIGN_TOP] )
			{
				adjustedFrame = CGRectAlignTop( childFrame, thisFrame );
			}
			
			CGSize size = CGRectGetDistance( childFrame, adjustedFrame );

			offset.width += size.width;
			offset.height += size.height;
		}
		
		if ( NO == CGSizeEqualToSize( offset, CGSizeZero ) )
		{
			[child offsetFrameBy:offset];
			[child offsetChildsFrameBy:offset];
		}
	}
}

- (CGRect)estimateFrameForCanvas
{
	return [self estimateFrameBy:(_canvas ? _canvas.bounds : CGRectZero)];
}

- (CGRect)estimateFrameBy:(CGRect)parentFrame
{
	UIView * view = self.view;

//	BREAK_POINT_IF( [self.name isEqualToString:@"intro"] );
//	BREAK_POINT_IF( [self.name isEqualToString:@"view-num"] );
	
//	if ( self.isRoot )
//	{
//		INFO( @"------------------------------------------------------------" );
//	}
	
// Step1, calculate this frame

	CGRect thisFrame;
	thisFrame.origin = [self estimateOriginBy:parentFrame];
	thisFrame.size = [self estimateSizeBy:parentFrame];
	
	UIEdgeInsets margin = [self estimateMarginBy:thisFrame];
	UIEdgeInsets padding = [self estimatePaddingBy:thisFrame];

	BOOL wWrapping = (thisFrame.size.width < 0.0f) ? YES : NO;
	BOOL hWrapping = (thisFrame.size.height < 0.0f) ? YES : NO;
	BOOL horizonal = [self.style.orientation isEqualToString:BeeUIStyle.ORIENTATION_HORIZONAL] ? YES : NO;

	CGRect layoutBound = CGRectZero;
	
	layoutBound.origin = thisFrame.origin;
	layoutBound.size.width = wWrapping ? LAYOUT_MAX_WIDTH : thisFrame.size.width;
	layoutBound.size.height = hWrapping ? LAYOUT_MAX_HEIGHT : thisFrame.size.height;

	layoutBound.origin.x += padding.left;
	layoutBound.origin.y += padding.top;
	layoutBound.size.width -= (padding.left + padding.right);
	layoutBound.size.height -= (padding.top + padding.bottom);

	if ( self.childs.count )
	{
// Step2.1, calc thisFrame by childs

		CGRect lineWindow = layoutBound;
		CGSize lineMaxSize = CGSizeZero;
		CGSize layoutMaxSize = CGSizeZero;

		for ( BeeUILayout * child in self.childs )
		{
			UIView * childView = child.view;
			if ( childView && childView.hidden )
				continue;

			CGSize relativeSize;
			relativeSize.width = [child isFlexiableW] ? layoutBound.size.width : lineWindow.size.width;
			relativeSize.height = [child isFlexiableH] ? layoutBound.size.height : lineWindow.size.height;

			CGRect relativeBound;
			relativeBound.origin = [child isRelativePosition] ? lineWindow.origin : layoutBound.origin;
			relativeBound.size = relativeSize;

			CGRect childFrame = [child estimateFrameBy:relativeBound];
            
			// no need calculate child's position by lineWindow if the position equals "absolute"
			if ( [child isRelativePosition] )
			{
				if ( horizonal )
				{
				// Step 2.1.1)
				// move window

					lineWindow.origin.x += childFrame.size.width;
					lineWindow.origin.x += (childFrame.origin.x - relativeBound.origin.x);
					lineWindow.size.width -= childFrame.size.width;
					lineWindow.size.width -= (childFrame.origin.x - relativeBound.origin.x);

					if ( childFrame.size.height > lineMaxSize.height )
					{
						lineMaxSize.height = childFrame.size.height;
					}

					if ( (lineWindow.origin.x - layoutBound.origin.x) > lineMaxSize.width )
					{
						lineMaxSize.width = (lineWindow.origin.x - layoutBound.origin.x);
					}

				// Step 2.1.2)
				// calculate max size

					if ( lineMaxSize.height > layoutMaxSize.height )
					{
						layoutMaxSize.height = lineMaxSize.height;
					}

					if ( lineMaxSize.width > layoutMaxSize.width )
					{
						layoutMaxSize.width = lineMaxSize.width;
					}

				// Step 2.1.3)
				// break line if reach right edge
					
					if ( (lineWindow.origin.y - layoutBound.origin.y) > layoutMaxSize.height )
					{
						layoutMaxSize.height = (lineWindow.origin.y - layoutBound.origin.y);
					}

					if ( lineWindow.size.width <= 0.0f )
					{
						lineWindow.origin.x = layoutBound.origin.x;
						lineWindow.size.width = layoutBound.size.width;

						lineWindow.origin.y += lineMaxSize.height;
						lineWindow.size.height -= lineMaxSize.height;
						
						lineMaxSize = CGSizeZero;
					}

					if ( (lineWindow.origin.x - layoutBound.origin.x) > layoutMaxSize.width )
					{
						layoutMaxSize.width = (lineWindow.origin.x - layoutBound.origin.x);
					}
				}
				else
				{
				// Step 2.1.1)
				// move window

					lineWindow.origin.y += childFrame.size.height;
					lineWindow.origin.y += (childFrame.origin.y - relativeBound.origin.y);
					lineWindow.size.height -= childFrame.size.height;
					lineWindow.size.height -= (childFrame.origin.y - relativeBound.origin.y);
					
					if ( childFrame.size.width > lineMaxSize.width )
					{
						lineMaxSize.width = childFrame.size.width;
					}
					
					if ( (lineWindow.origin.y - layoutBound.origin.y) > lineMaxSize.height )
					{
						lineMaxSize.height = (lineWindow.origin.y - layoutBound.origin.y);
					}
					
				// Step 2.1.2)
				// calculate max size
					
					if ( lineMaxSize.width > layoutMaxSize.width )
					{
						layoutMaxSize.width = lineMaxSize.width;
					}
					
					if ( lineMaxSize.height > layoutMaxSize.height )
					{
						layoutMaxSize.height = lineMaxSize.height;
					}

				// Step 2.1.3)
				// break line if reach bottom edge

					if ( (lineWindow.origin.x - layoutBound.origin.x) > layoutMaxSize.width )
					{
						layoutMaxSize.width = (lineWindow.origin.x - layoutBound.origin.x);
					}

					if ( lineWindow.size.height <= 0.0f )
					{
						lineWindow.origin.y = layoutBound.origin.y;
						lineWindow.size.height = layoutBound.size.height;

						lineWindow.origin.x += layoutMaxSize.width;
						lineWindow.size.width -= lineMaxSize.width;
						
						lineMaxSize = CGSizeZero;
					}

					if ( (lineWindow.origin.y - layoutBound.origin.y) > layoutMaxSize.height )
					{
						layoutMaxSize.height = (lineWindow.origin.y - layoutBound.origin.y);
					}
				}
			}
		}

		if ( self.isRoot )
		{
			thisFrame.size = layoutMaxSize;
		}
		else
		{
			if ( wWrapping )
			{
				thisFrame.size.width = layoutMaxSize.width;
			}
			if ( hWrapping )
			{
				thisFrame.size.height = layoutMaxSize.height;
			}
		}
	}
	else
	{
// Step2.2, calc thisFrame by contentSize

		if ( view && [[view class] supportForUISizeEstimating] )
		{
			if ( wWrapping && hWrapping )
			{
				thisFrame.size = [view estimateUISizeByBound:layoutBound.size];
			}
			else
			{
				if ( wWrapping )
				{
					thisFrame.size.width = [view estimateUISizeByHeight:layoutBound.size.height].width;
				}
				if ( hWrapping )
				{
					thisFrame.size.height = [view estimateUISizeByWidth:layoutBound.size.width].height;
				}
			}
		}
	}
	
// float

	CGRect innerBound = thisFrame;
	innerBound.origin.x += padding.left;
	innerBound.origin.y += padding.top;
	innerBound.size.width -= (padding.left + padding.right);
	innerBound.size.height -= (padding.top + padding.bottom);

	[self adjustAlignmentBy:thisFrame margin:margin padding:padding];
	[self adjustFloatingBy:innerBound margin:margin padding:padding];

// change frame
	
//	NSString * floating = self.style.floating;
//	NSString * v_floating = self.style.v_floating;

	CGRect viewFrame = thisFrame;
	
	viewFrame.origin.x += margin.left;
	viewFrame.origin.y += margin.top;
//	viewFrame.size.width += margin.right;
//	viewFrame.size.height += margin.bottom;

	viewFrame.origin.x += padding.left;
	viewFrame.origin.y += padding.top;
	viewFrame.size.width -= (padding.left + padding.right);
	viewFrame.size.height -= (padding.top + padding.bottom);
//	viewFrame.size.width -= padding.right;
//	viewFrame.size.height -= padding.bottom;
	
	[self setViewFrame:viewFrame];
	[self offsetChildsFrameBy:CGSizeMake(margin.left, margin.top)];

	CGRect outerBound = thisFrame;
	outerBound.size.width += (margin.left + margin.right);
	outerBound.size.height += (margin.top + margin.bottom);
	
//	if ( self.isRoot )
//	{
//		INFO( @"------------------------------------------------------------" );
//		INFO( @"boundSize = (%.0f, %.0f)\n", outerBound.size.width, outerBound.size.height );
//	}
	
	return outerBound;
}

- (void)changeFrame:(CGRect)frame
{
//	INFO( @"changeFrame '%@', frame' = (%.0f, %.0f, %.0f, %.0f)", self.prettyName,
//	   frame.origin.x, frame.origin.y,
//	   frame.size.width, frame.size.height );

	UIView * view = self.view;
	if ( view )
	{
		view.frame = frame;
	}
}

- (void)offsetFrameBy:(CGSize)size
{
	UIView * view = self.view;
	if ( view )
	{
		CGRect viewFrame = [self getViewFrame];
        viewFrame = CGRectOffset( viewFrame, size.width, size.height );
        [self setViewFrame:viewFrame];
	}
}

- (void)offsetChildsFrameBy:(CGSize)size
{
	if ( CGSizeEqualToSize(size, CGSizeZero) )
		return;
	
	for ( BeeUILayout * child in self.childs )
	{
		[child offsetFrameBy:size];
		[child offsetChildsFrameBy:size];
	}
}

- (CGRect)relayoutForCanvas;
{
	return [self relayoutForBound:_canvas.bounds];
}

- (CGRect)relayoutForBound:(CGRect)parentFrame
{
	PERF_MARK( tag1 );

	CGRect frame = [self estimateFrameBy:parentFrame];
	
	PERF_MARK( tag2 );

	if ( self.canvas )
	{
//		INFO( @"------------------------------------------------------------" );

		for ( UIView * view in self.canvas.subviews )
		{
			NSString * name = view.tagString;
			if ( nil == name )
				continue;
			
//			INFO( @"result '%@', frame = (%.0f, %.0f, %.0f, %.0f)", name,
//				 view.frame.origin.x, view.frame.origin.y,
//				 view.frame.size.width, view.frame.size.height );
			
			NSValue * value = [self.root.childFrames objectForKey:name];
			if ( value )
			{
				CGRect viewFrame = value.CGRectValue;
				view.frame = viewFrame;
			}
		}
		
//		INFO( @"------------------------------------------------------------" );
	}

	PERF_MARK( tag3 );
	
	PERF( @"'%@' layout, time1 = %.2f, time2 = %.2f",
		 [[self.canvas class] description], PERF_TIME(tag1, tag2), PERF_TIME(tag2, tag3) );

//	self.canvas.bounds = CGSizeMakeBound( frame.size );

	return frame;
}

#pragma mark -

- (BeeUILayout *)topLayout
{
	if ( nil == _stack || 0 == _stack.count )
		return self;
	
	return _stack.lastObject;
}

- (void)pushLayout:(BeeUILayout *)layout
{
	if ( nil == layout )
		return;
	
	if ( nil == _stack )
	{
		_stack = [[NSMutableArray alloc] init];
	}
	
	[_stack pushTail:layout];
}

- (void)popLayout
{
	if ( _stack )
	{
		[_stack popTail];
	}
}

- (BOOL)hasStyleClass:(NSString * )className
{
	for ( NSString * clazz in self.styleClasses )
	{
		if ( [clazz isEqualToString:className] )
		{
			return YES;
		}
	}
	
	return NO;
}

- (void)addStyleClass:(NSString * )className
{
	BOOL exists = [self hasStyleClass:className];
	if ( exists )
		return;
	
	[self.styleClasses addObject:className];
}

- (void)removeStyleClass:(NSString * )className
{
	for ( NSString * clazz in self.styleClasses )
	{
		if ( [clazz isEqualToString:className] )
		{
			[self.styleClasses removeObject:clazz];
			return;
		}
	}
}

- (void)toggleStyleClass:(NSString * )className
{
	if ( [self hasStyleClass:className] )
	{
		[self removeStyleClass:className];
	}
	else
	{
		[self addStyleClass:className];
	}
}

- (void)mergeStyle
{
	BeeUIStyle * merged = [[[BeeUIStyle alloc] init] autorelease];
	if ( merged )
	{
		// single style
		
		BeeUIStyle * style1 = self.styleInline;
		BeeUIStyle * style2 = [self.root.rootStyles objectForKey:[NSString stringWithFormat:@"#%@", self.name]];
		BeeUIStyle * style3 = [self.root.rootStyles objectForKey:self.className];
		
		if ( style3 && style3.properties.count )
		{
			[style3 mergeToStyle:merged];
		}
		
		if ( style2 && style2.properties.count )
		{
			[style2 mergeToStyle:merged];
		}
		
		if ( style1 && style1.properties.count )
		{
			[style1 mergeToStyle:merged];
		}
		
		// style classes
		
		for ( NSString * styleClass in self.styleClasses )
		{
			BeeUIStyle * style = [self.root.rootStyles objectForKey:[NSString stringWithFormat:@".%@", styleClass]];
			if ( style )
			{
				[style mergeToStyle:merged];
			}
		}
		
		self.style = merged;
		
//		INFO( @"mergeStyle '%@', style =\n%@", self.name, self.style.properties );
	}
}

- (void)applyStyle
{
	[self.view applyUIStyleProperties:self.style.properties];
}

#pragma mark -

- (BeeUILayoutBlockB)VISIBLE
{
	BeeUILayoutBlockB block = ^ BeeUILayout * ( BOOL flag )
	{
		self.visible = flag;
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlock)EMPTY
{
	BeeUILayoutBlock block = ^ BeeUILayout * ( void )
	{
//		INFO( @"empty layout" );
		
		[self.childs removeAllObjects];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlock)REBUILD
{
	BeeUILayoutBlock block = ^ BeeUILayout * ( void )
	{
//		INFO( @"build layout" );
		
		[self buildSubviewsForCanvas];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlock)RELAYOUT
{
	BeeUILayoutBlock block = ^ BeeUILayout * ( void )
	{
		[self relayoutForCanvas];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlock)BEGIN_LAYOUT
{
	BeeUILayoutBlock block = ^ BeeUILayout * ( void )
	{
//		INFO( @"begin layout" );
		
		[[BeeLogger sharedInstance] indent];
		
		[self.childs removeAllObjects];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlock)END_LAYOUT
{
	BeeUILayoutBlock block = ^ BeeUILayout * ( void )
	{
		BeeUILayout * layout = self;
		
		while ( layout && layout.parent )
		{
			layout = layout.parent;
		}
		
		[[BeeLogger sharedInstance] unindent];
		
//		INFO( @"end layout" );
		
		return layout;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlockS)BEGIN_CONTAINER
{
	BeeUILayoutBlockS block = ^ BeeUILayout * ( NSString * tag )
	{
		[[BeeLogger sharedInstance] indent];

		BeeUILayout * layout = [[[BeeUILayout alloc] init] autorelease];
		if ( layout )
		{
			layout.containable = YES;
			layout.root = self.root;
			layout.parent = self.containable ? self : self.parent;
			layout.canvas = self.canvas;
			layout.classType = nil;
			layout.className = nil;
			layout.visible = layout.parent.visible;

			if ( tag && tag.length )
			{
				layout.name = tag;
			}
            
//			layout.W( @"wrap_content" );
//			layout.H( @"wrap_content" );

			[layout.parent.childs addObject:layout];
		}
		
//		INFO( @"container %@", layout.name );
        
		[self.root pushLayout:layout];
		return [self.root topLayout];
	};

	return [[block copy] autorelease];
}

- (BeeUILayoutBlock)END_CONTAINER
{
	BeeUILayoutBlock block = ^ BeeUILayout * ( void )
	{
		[[BeeLogger sharedInstance] unindent];

//		INFO( @"end of container '%@'", self.name );

		[self.root popLayout];
		return [self.root topLayout];
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlockCS)VIEW
{
	BeeUILayoutBlockCS block = ^ BeeUILayout * ( Class clazz, NSString * tag )
	{
		BeeUILayout * layout = [[[BeeUILayout alloc] init] autorelease];
		if ( layout )
		{
			layout.containable = NO;
			layout.root = self.root;
			layout.parent = self.containable ? self : self.parent;
			layout.canvas = self.canvas;
			layout.classType = clazz;
			layout.className = [NSString stringWithUTF8String:class_getName(clazz)];
			layout.visible = layout.parent.visible;

			if ( tag && tag.length )
			{
				layout.name = tag;
			}
            
			[layout.parent.childs addObject:layout];
		}

//		INFO( @"view(%@) %@", [clazz description], layout.name );

		return layout;
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)