//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
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
//
//  Bee_UILayout.m
//

#import "Bee_Log.h"
#import "Bee_UILayout.h"
#import "NSArray+BeeExtension.h"
#import "UIView+BeeExtension.h"
#import "CGRect+BeeExtension.h"

#import <objc/runtime.h>

#pragma mark -

#undef	LAYOUT_MAX_WIDTH
#define LAYOUT_MAX_WIDTH	(99999.0f)

#undef	LAYOUT_MAX_HEIGHT
#define LAYOUT_MAX_HEIGHT	(99999.0f)

#pragma mark -

@implementation BeeUIValue

DEF_INT( PIXEL,			0 )
DEF_INT( PERCENT,		1 )
DEF_INT( FILL_PARENT,	2 )
DEF_INT( WRAP_CONTENT,	3 )

@synthesize type = _type;
@synthesize value = _value;

- (NSString *)description
{
	if ( self.PIXEL == self.type )
	{
		return [NSString stringWithFormat:@"%.1fpx", _value];
	}
	else if ( self.PERCENT == self.type )
	{
		return [NSString stringWithFormat:@"%.1f%%", _value];
	}
	else if ( self.FILL_PARENT == self.type )
	{
		return @"fill_parent";
	}
	else if ( self.WRAP_CONTENT == self.type )
	{
		return @"wrap_content";
	}

	return @"";
}

+ (BeeUIValue *)pixel:(CGFloat)val
{
	BeeUIValue * value = [[[BeeUIValue alloc] init] autorelease];
	value.type = self.PIXEL;
	value.value = val;
	return value;
}

+ (BeeUIValue *)percent:(CGFloat)val
{
	BeeUIValue * value = [[[BeeUIValue alloc] init] autorelease];
	value.type = self.PERCENT;
	value.value = val;
	return value;
}

+ (BeeUIValue *)fillParent
{
	BeeUIValue * value = [[[BeeUIValue alloc] init] autorelease];
	value.type = self.FILL_PARENT;
	return value;
}

+ (BeeUIValue *)wrapContent
{
	BeeUIValue * value = [[[BeeUIValue alloc] init] autorelease];
	value.type = self.WRAP_CONTENT;
	return value;
}

+ (BeeUIValue *)fromString:(NSString *)str
{
	if ( 0 == str.length )
		return nil;
	
	BeeUIValue * value = [[[BeeUIValue alloc] init] autorelease];
	if ( value )
	{
		if ( [str hasSuffix:@"px"] )
		{
			value.type = self.PIXEL;
		}
		else if ( [str hasSuffix:@"%"] )
		{
			value.type = self.PERCENT;
		}
		else if ( NSOrderedSame == [str compare:@"fill_parent" options:NSCaseInsensitiveSearch] )
		{
			value.type = self.FILL_PARENT;
		}
		else if ( NSOrderedSame == [str compare:@"wrap_content" options:NSCaseInsensitiveSearch] )
		{
			value.type = self.WRAP_CONTENT;
		}
		else
		{
			value.type = self.PIXEL;
		}
		
		value.value = [str floatValue];
	}
	return value;
}

@end

#pragma mark -

@implementation BeeUILayout

DEF_STRING( ALIGN_CENTER,			@"center" )
DEF_STRING( ALIGN_LEFT,				@"left" )
DEF_STRING( ALIGN_TOP,				@"top" )
DEF_STRING( ALIGN_BOTTOM,			@"bottom" )
DEF_STRING( ALIGN_RIGHT,			@"right" )

DEF_STRING( ORIENTATION_HORIZONAL,	@"horizonal" )
DEF_STRING( ORIENTATION_VERTICAL,	@"vertical" )

DEF_STRING( POSITION_ABSOLUTE,		@"absolute" )
DEF_STRING( POSITION_RELATIVE,		@"relative" )

@synthesize always = _always;
@synthesize containable = _containable;
@synthesize visible = _visible;
@synthesize root = _root;
@synthesize parent = _parent;
@synthesize name = _name;
@synthesize value = _value;
@synthesize styleID = _styleID;
@synthesize style = _style;
@synthesize classType = _classType;
@synthesize properties = _properties;
@synthesize childs = _childs;
@dynamic canvas;

@synthesize autoresizingWidth = _autoresizingWidth;
@synthesize autoresizingHeight = _autoresizingHeight;

@dynamic ADD;
@dynamic REMOVE;
@dynamic REMOVE_ALL;

@dynamic x;
@dynamic y;
@dynamic w;
@dynamic h;
@dynamic position;
@dynamic align;
@dynamic v_align;
@dynamic orientation;

@dynamic X;
@dynamic Y;
@dynamic W;
@dynamic H;
@dynamic POSITION;
@dynamic ALIGN;
@dynamic V_ALIGN;
@dynamic ORIENTATION;
@dynamic AUTORESIZE_WIDTH;
@dynamic AUTORESIZE_HEIGHT;
@dynamic VISIBLE;
@dynamic ALWAYS;
@dynamic FULLFILL;

@dynamic EMPTY;
@dynamic REBUILD;
@dynamic RELAYOUT;

@dynamic BEGIN_LAYOUT;
@dynamic END_LAYOUT;
@dynamic BEGIN_CONTAINER;
@dynamic END_CONTAINER;
@dynamic VIEW;
@dynamic SPACE;

@dynamic DUMP;

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ (%@, %@, %@, %@)",
			self.name,
			self.x ? [self.x description] : @"nil",
			self.y ? [self.y description] : @"nil",
			self.w ? [self.w description] : @"nil",
			self.h ? [self.h description] : @"nil"];
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
		self.always = NO;
		self.containable = YES;
		self.visible = YES;
		self.root = self;
		self.parent = nil;
		self.name = [BeeUILayout generateName];
		self.value = nil;
		self.styleID = nil;
		self.style = nil;
		self.classType = nil;
		self.properties = [NSMutableDictionary dictionary];
		self.childs = [NSMutableArray array];

		self.autoresizingWidth = NO;
		self.autoresizingHeight = NO;
	}
	return self;
}

- (void)dealloc
{
	[self.properties removeAllObjects];
	self.properties = nil;

	[self.childs removeAllObjects];
	self.childs = nil;

	self.root = nil;
	self.parent = nil;
	self.name = nil;
	self.value = nil;
	self.styleID = nil;
	self.style = nil;
	self.classType = nil;

	[_stack removeAllObjects];
	[_stack release];
	_stack = nil;

	[super dealloc];
}

- (void)dump
{
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__

	CC( @"%@(%d childs)", self.name, self.childs.count );

	BeeLogIndent( 1 );

	for ( BeeUILayout * child in self.childs )
	{
		[child dump];
	}

	BeeLogUnindent( 1 );
	
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
}

- (void)setCanvas:(UIView *)c;
{
	_canvas = c;
	
	for ( BeeUILayout * layout in self.childs )
	{
		[layout setCanvas:c];
	}
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

	CC( @"buildView %@", [self.classType description] );
	
	UIView * view = [[[self.classType alloc] initWithFrame:CGRectZero] autorelease];
	if ( view )
	{
		view.tagString = self.name;
	}

	if ( self.style )
	{
		[self.style applyFor:view];
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
		CC( @"canvas not found" );
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
		CC( @"canvas not found" );
		return;
	}

	for ( BeeUILayout * layout in self.childs )
	{
		[layout reorderSubviewsFor:c];
	}

	UIView * view = [c viewWithTagString:self.name];
	if ( view )
	{
		[c bringSubviewToFront:view];
	}
}

- (CGPoint)estimateOriginForCanvas
{
	return [self estimateOriginBy:(_canvas ? _canvas.bounds : CGRectZero)];
}

- (CGPoint)estimateOriginBy:(CGRect)parentFrame
{
	BeeUIValue * x = self.x;
	BeeUIValue * y = self.y;
	NSString * pos = self.position;
	CGPoint origin = CGPointZero;
    
    CGFloat xPixels = 0.0f;
    CGFloat yPixels = 0.0f;
    
    if ( x )
    {
        if ( BeeUIValue.PIXEL == x.type )
        {
            xPixels = x.value;
        }
        else if ( BeeUIValue.PERCENT == x.type )
        {
            xPixels = floorf(  parentFrame.size.width * x.value / 100.0f );
        }
    }
    
    if ( y )
    {
        if ( BeeUIValue.PIXEL == y.type )
        {
            yPixels = y.value;
        }
        else if ( BeeUIValue.PERCENT == y.type )
        {
            yPixels = floorf( parentFrame.size.width * y.value / 100.0f );
        }
    }
    
    // Relative : the origin is ParentFrame.origin
    // Absolute : thr origin is CGPointZero
    
	if ( [pos isEqualToString:self.POSITION_ABSOLUTE] )
	{
		origin = CGPointZero;
	}
	else if ( [pos isEqualToString:self.POSITION_RELATIVE] )
	{
		origin = parentFrame.origin;
	}
	else
	{
		origin = parentFrame.origin;
	}

    origin.x += xPixels;
    origin.y += yPixels;
    
	return origin;
}

- (CGSize)estimateSizeForCanvas
{
	return [self estimateSizeBy:(_canvas ? _canvas.bounds : CGRectZero)];
}

- (CGSize)estimateSizeBy:(CGRect)parentFrame
{
	BeeUIValue * w = self.w;
	BeeUIValue * h = self.h;
	CGSize size = CGSizeZero;
	
	if ( w )
	{
		CGFloat wPixels = 0.0f;
		
		if ( BeeUIValue.PIXEL == w.type )
		{
			wPixels = w.value;
		}
		else if ( BeeUIValue.PERCENT == w.type )
		{
			wPixels = floorf( parentFrame.size.width * w.value / 100.0f );
		}
		else if ( BeeUIValue.FILL_PARENT == w.type )
		{
			wPixels = parentFrame.size.width;
		}
		else if ( BeeUIValue.WRAP_CONTENT == w.type )
		{
			wPixels = parentFrame.size.width;
		}
		
		size.width = wPixels;
	}
	else
	{
		size.width = parentFrame.size.width;
	}
	
	if ( h )
	{
		CGFloat hPixels = 0.0f;
		
		if ( BeeUIValue.PIXEL == h.type )
		{
			hPixels = h.value;
		}
		else if ( BeeUIValue.PERCENT == h.type )
		{
			hPixels = floorf( parentFrame.size.height * h.value / 100.0f );
		}
		else if ( BeeUIValue.FILL_PARENT == h.type )
		{
			hPixels = parentFrame.size.height;
		}
		else if ( BeeUIValue.WRAP_CONTENT == h.type )
		{
			hPixels = parentFrame.size.height;
		}
		
		size.height = hPixels;
	}
	else
	{
		size.height = parentFrame.size.height;
	}
	
	return size;
}

- (CGRect)estimateFrameForCanvas
{
	return [self estimateFrameBy:(_canvas ? _canvas.bounds : CGRectZero)];
}

- (CGRect)estimateFrameBy:(CGRect)parentFrame
{
	return [self estimateFrameBy:parentFrame changeViewFrame:NO];
}

- (CGRect)estimateFrameBy:(CGRect)parentFrame changeViewFrame:(BOOL)flag
{
    NSString * align = self.align;
	NSString * valign = self.v_align;
    
	CGRect thisFrame;
	thisFrame.origin = [self estimateOriginBy:parentFrame];
	thisFrame.size = [self estimateSizeBy:parentFrame];
    
	CGRect layoutBound;
	layoutBound.origin = thisFrame.origin;
	layoutBound.size.width = self.autoresizingWidth ? LAYOUT_MAX_WIDTH : thisFrame.size.width;
	layoutBound.size.height = self.autoresizingHeight ? LAYOUT_MAX_HEIGHT : thisFrame.size.height;

	CGRect lineWindow = layoutBound;
	CGSize layoutMaxSize = CGSizeZero;

	NSString * orient = self.orientation;

	BOOL horizonal = (NSOrderedSame == [orient compare:self.ORIENTATION_HORIZONAL options:NSCaseInsensitiveSearch]) ? YES : NO;
    
	for ( BeeUILayout * child in self.childs )
	{
		if ( NO == child.visible && NO == child.always )
			continue;
		
        CGRect relativeBound;
		
		if ( [child.position isEqualToString:self.POSITION_ABSOLUTE] )
		{
			relativeBound.origin = thisFrame.origin;
			relativeBound.size = layoutBound.size;
		}
		else
		{
			relativeBound.origin = lineWindow.origin;
			relativeBound.size = layoutBound.size;

			// relativeBound.origin default frame is lineWindow.origin, but when the align/v_algin
			// is valued it should be layoutBound.origin, the really parentFrame.origin

			if ( child.align )
			{
				relativeBound.origin.x = layoutBound.origin.x;
			}
			
			if ( child.v_align )
			{
				relativeBound.origin.y = layoutBound.origin.y;
			}
		}
        
        CGRect childFrame = [child relayoutForBound:relativeBound];
        
		if ( horizonal )
		{
		// Step 1)
		// move window

			lineWindow.origin.x += childFrame.size.width;
			lineWindow.size.width -= childFrame.size.width;

			if ( childFrame.size.height > lineWindow.size.height )
			{
				lineWindow.size.height = childFrame.size.height;
			}

		// Step 2)
		// calculate max size
            
        // todo : if the lineWindow.size.width <= 0.0f, layoutMaxSize calculate error
            
			if ( lineWindow.origin.x > layoutMaxSize.width )
			{
				layoutMaxSize.width = lineWindow.origin.x;
			}
            
			if ( childFrame.size.height > layoutMaxSize.height )
			{
				layoutMaxSize.height = childFrame.size.height;
			}
            
		// Step 3)
		// break line if reach right edge

			if ( lineWindow.size.width <= 0.0f )
			{
				lineWindow.origin.x = layoutBound.origin.x;
				lineWindow.origin.y += layoutMaxSize.height;
				lineWindow.size.width = layoutBound.size.width;
				lineWindow.size.height = layoutBound.size.height - lineWindow.origin.y;

				if ( lineWindow.origin.y > layoutMaxSize.height )
				{
					layoutMaxSize.height = lineWindow.origin.y;
				}
			}
		}
		else
		{
            
		// Step 1)
		// move window

			lineWindow.origin.y += childFrame.size.height;
			lineWindow.size.height -= childFrame.size.height;
			
			if ( childFrame.size.width > lineWindow.size.width )
			{
				lineWindow.size.width = childFrame.size.width;
			}
			
		// Step 2)
		// calculate max size
			
			if ( childFrame.size.width > layoutMaxSize.width )
			{
				layoutMaxSize.width = childFrame.size.width;
			}

			if ( lineWindow.origin.y > layoutMaxSize.height )
			{
				layoutMaxSize.height = lineWindow.origin.y;
			}
			
		// Step 3)
		// break line if reach bottom edge

			if ( lineWindow.size.height <= 0.0f )
			{
				lineWindow.origin.y = layoutBound.origin.y;
				lineWindow.origin.x += layoutMaxSize.width;
				lineWindow.size.height = layoutBound.size.height;
				lineWindow.size.width = layoutBound.size.width - lineWindow.origin.x;

				if ( lineWindow.origin.x > layoutMaxSize.width )
				{
					layoutMaxSize.width = lineWindow.origin.x;
				}
			}
		}
    }
    
	if ( self.autoresizingWidth )
	{
		thisFrame.size.width = layoutMaxSize.width;
	}
    else
    {
        if ( [align isEqualToString:self.ALIGN_CENTER] )
        {
            thisFrame = CGRectAlignX( thisFrame , parentFrame );
        }
        else if ( [align isEqualToString:self.ALIGN_LEFT] )
        {
            thisFrame = CGRectAlignLeft( thisFrame , parentFrame );
        }
        else if ( [align isEqualToString:self.ALIGN_RIGHT] )
        {
            thisFrame = CGRectAlignRight( thisFrame , parentFrame );
        }
    }

	if ( self.autoresizingHeight )
	{
		thisFrame.size.height = layoutMaxSize.height;
	}
    else
    {
        if ( [valign isEqualToString:self.ALIGN_CENTER] )
        {
            thisFrame = CGRectAlignY( thisFrame , parentFrame );
        }
        else if ( [valign isEqualToString:self.ALIGN_TOP] )
        {
            thisFrame = CGRectAlignTop( thisFrame , parentFrame );
        }
        else if ( [valign isEqualToString:self.ALIGN_BOTTOM] )
        {
            thisFrame = CGRectAlignBottom( thisFrame , parentFrame );
        }
    }
    
	if ( flag )
	{
		if ( _canvas && _name )
		{
			UIView * view = [_canvas viewWithTagString:_name];
			if ( view )
			{
				view.frame = thisFrame;
			}
		}
	}
    
    return thisFrame;
}

- (CGRect)relayoutForCanvas;
{
	return [self relayoutForBound:_canvas.frame];
}

- (CGRect)relayoutForBound:(CGRect)parentFrame
{
	return [self estimateFrameBy:parentFrame changeViewFrame:YES];
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

#pragma mark -

- (BeeUIValue *)x
{
	return [self.properties objectForKey:@"x"];
}

- (BeeUIValue *)y
{
	return [self.properties objectForKey:@"y"];
}

- (BeeUIValue *)w
{
	return [self.properties objectForKey:@"w"];
}

- (BeeUIValue *)h
{
	return [self.properties objectForKey:@"h"];
}

- (NSString *)position
{
	return [self.properties objectForKey:@"position"];
}

- (NSString *)align
{
	return [self.properties objectForKey:@"align"];
}

- (NSString *)v_align
{
	return [self.properties objectForKey:@"v_align"];
}

- (NSString *)orientation
{
	return [self.properties objectForKey:@"orientation"];
}

#pragma mark -

- (BeeUILayoutBlockN)X
{
	BeeUILayoutBlockN block = ^ BeeUILayout * ( id first, ... )
	{
		BeeUIValue * value = [BeeUIValue fromString:(NSString *)first];
		if ( value )
		{
			[self.properties setObject:value forKey:@"x"];
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlockN)Y
{
	BeeUILayoutBlockN block = ^ BeeUILayout * ( id first, ... )
	{
		BeeUIValue * value = [BeeUIValue fromString:(NSString *)first];
		if ( value )
		{
			[self.properties setObject:value forKey:@"y"];
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlockN)W
{
	BeeUILayoutBlockN block = ^ BeeUILayout * ( id first, ... )
	{
		BeeUIValue * value = [BeeUIValue fromString:(NSString *)first];
		if ( value )
		{
			[self.properties setObject:value forKey:@"w"];
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlockN)H
{
	BeeUILayoutBlockN block = ^ BeeUILayout * ( id first, ... )
	{
		BeeUIValue * value = [BeeUIValue fromString:(NSString *)first];
		if ( value )
		{
			[self.properties setObject:value forKey:@"h"];
		}
		return self;
	};

	return [[block copy] autorelease];
}

- (BeeUILayoutBlockN)POSITION
{
	BeeUILayoutBlockN block = ^ BeeUILayout * ( id first, ... )
	{
		[self.properties setObject:first forKey:@"position"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlockN)ALIGN
{
	BeeUILayoutBlockN block = ^ BeeUILayout * ( id first, ... )
	{
		[self.properties setObject:first forKey:@"align"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlockN)V_ALIGN
{
	BeeUILayoutBlockN block = ^ BeeUILayout * ( id first, ... )
	{
		[self.properties setObject:first forKey:@"v_align"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlockN)ORIENTATION
{
	BeeUILayoutBlockN block = ^ BeeUILayout * ( id first, ... )
	{
		[self.properties setObject:first forKey:@"orientation"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlockB)AUTORESIZE_WIDTH
{
	BeeUILayoutBlockB block = ^ BeeUILayout * ( BOOL flag )
	{
		self.autoresizingWidth = flag;
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlockB)AUTORESIZE_HEIGHT
{
	BeeUILayoutBlockB block = ^ BeeUILayout * ( BOOL flag )
	{
		self.autoresizingHeight = flag;
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlockB)VISIBLE
{
	BeeUILayoutBlockB block = ^ BeeUILayout * ( BOOL flag )
	{
		self.visible = flag;
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlockB)ALWAYS
{
	BeeUILayoutBlockB block = ^ BeeUILayout * ( BOOL flag )
	{
		self.always = flag;
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlock)FULLFILL
{
	BeeUILayoutBlock block = ^ BeeUILayout * ( void )
	{
		[self.properties setObject:[BeeUIValue pixel:0] forKey:@"x"];
		[self.properties setObject:[BeeUIValue pixel:0] forKey:@"y"];
		[self.properties setObject:[BeeUIValue percent:100] forKey:@"w"];
		[self.properties setObject:[BeeUIValue percent:100] forKey:@"h"];

		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlock)EMPTY
{
	BeeUILayoutBlock block = ^ BeeUILayout * ( void )
	{
		CC( @"empty layout" );
		[self.childs removeAllObjects];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlock)REBUILD
{
	BeeUILayoutBlock block = ^ BeeUILayout * ( void )
	{
		CC( @"build layout" );
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
		CC( @"begin layout" );
		BeeLogIndent( 1 );
		
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
		
		BeeLogUnindent( 1 );
		CC( @"end layout" );
		
		return layout;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlockS)BEGIN_CONTAINER
{
	BeeUILayoutBlockS block = ^ BeeUILayout * ( NSString * tag )
	{
		BeeLogIndent( 1 );

		BeeUILayout * layout = [[[BeeUILayout alloc] init] autorelease];
		if ( layout )
		{
			layout.containable = YES;
			layout.root = self.root;
			layout.parent = self.containable ? self : self.parent;
			layout.canvas = self.canvas;
			layout.classType = nil;
			layout.visible = layout.parent.visible;

			[layout.parent.childs addObject:layout];
		}
		
		CC( @"container %@", layout.name );
        
		[self.root pushLayout:layout];
		return [self.root topLayout];
	};

	return [[block copy] autorelease];
}

- (BeeUILayoutBlock)END_CONTAINER
{
	BeeUILayoutBlock block = ^ BeeUILayout * ( void )
	{
		BeeLogUnindent( 1 );

		CC( @"end of container" );

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
			layout.visible = layout.parent.visible;

			if ( tag )
			{
				layout.name = tag;
			}
            
			[layout.parent.childs addObject:layout];
		}

		CC( @"subview(%@) %@", [clazz description], layout.name );

		return layout;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlock)SPACE
{
	BeeUILayoutBlock block = ^ BeeUILayout * ( void )
	{
		BeeUILayout * layout = [[[BeeUILayout alloc] init] autorelease];
		if ( layout )
		{
			layout.containable = NO;
			layout.root = self.root;
			layout.parent = self.containable ? self : self.parent;
			layout.canvas = self.canvas;
			layout.classType = nil;
			layout.visible = layout.parent.visible;

            CC( @"space %@", layout.name );
            
			[layout.parent.childs addObject:layout];
		}
		
		return layout;
	};

	return [[block copy] autorelease];	
}

@end
