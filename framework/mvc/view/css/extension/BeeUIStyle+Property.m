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

#undef  FLOORF
#define FLOORF(v)	(v)	// floorf(v)

#import "BeeUIStyle+Property.h"

#pragma mark -

@interface BeeUIStyle(PropertyPrivate)
- (CGFloat)__estimateWidth:(BeeUIMetrics *)m byFrame:(CGRect)parentFrame;
- (CGFloat)__estimateHeight:(BeeUIMetrics *)m byFrame:(CGRect)parentFrame;
@end

#pragma mark -

@implementation BeeUIStyle(Property)

DEF_STRING( ALIGN_CENTER,			@"center" )
DEF_STRING( ALIGN_LEFT,				@"left" )
DEF_STRING( ALIGN_TOP,				@"top" )
DEF_STRING( ALIGN_BOTTOM,			@"bottom" )
DEF_STRING( ALIGN_RIGHT,			@"right" )

DEF_STRING( ORIENTATION_HORIZONAL,	@"h" )
DEF_STRING( ORIENTATION_VERTICAL,	@"v" )

DEF_STRING( POSITION_ABSOLUTE,		@"absolute" )
DEF_STRING( POSITION_RELATIVE,		@"relative" )
DEF_STRING( POSITION_LINEAR,		@"linear" )

DEF_STRING( COMPOSITION_ABSOLUTE,	@"absolute" )
DEF_STRING( COMPOSITION_RELATIVE,	@"relative" )
DEF_STRING( COMPOSITION_LINEAR,		@"linear" )

DEF_STRING( DISPLAY_NONE,           @"none" )
DEF_STRING( DISPLAY_BLOCK,          @"block" )

DEF_STRING( OVERFLOW_VISIBLE,		@"visible" )
DEF_STRING( OVERFLOW_HIDDEN,		@"hidden" )
DEF_STRING( OVERFLOW_SCROLL,		@"scroll" )
DEF_STRING( OVERFLOW_AUTO,			@"auto" )
DEF_STRING( OVERFLOW_INHERIT,		@"inherit" )

@dynamic x;
@dynamic y;
@dynamic w;
@dynamic h;
@dynamic top;
@dynamic left;
@dynamic right;
@dynamic bottom;
@dynamic position;
@dynamic composition;
@dynamic margin_top;
@dynamic margin_bottom;
@dynamic margin_left;
@dynamic margin_right;
@dynamic min_width;
@dynamic max_width;
@dynamic min_height;
@dynamic max_height;
@dynamic padding_top;
@dynamic padding_bottom;
@dynamic padding_left;
@dynamic padding_right;
@dynamic align;
@dynamic v_align;
@dynamic floating;
@dynamic v_floating;
@dynamic orientation;
@dynamic text;
@dynamic package;
@dynamic display;
@dynamic overflow;

@dynamic X;
@dynamic Y;
@dynamic W;
@dynamic H;
@dynamic TOP;
@dynamic LEFT;
@dynamic RIGHT;
@dynamic BOTTOM;
@dynamic POSITION;
@dynamic COMPOSITION;
@dynamic MARGIN;
@dynamic MARGIN_TOP;
@dynamic MARGIN_BOTTOM;
@dynamic MARGIN_LEFT;
@dynamic MARGIN_RIGHT;
@dynamic MIN_WIDTH;
@dynamic MAX_WIDTH;
@dynamic MIN_HEIGHT;
@dynamic MAX_HEIGHT;
@dynamic PADDING;
@dynamic PADDING_TOP;
@dynamic PADDING_BOTTOM;
@dynamic PADDING_LEFT;
@dynamic PADDING_RIGHT;
@dynamic ALIGN;
@dynamic V_ALIGN;
@dynamic FLOATING;
@dynamic V_FLOATING;
@dynamic ORIENTATION;
@dynamic TEXT;
@dynamic PACKAGE;
@dynamic DISPLAY;
@dynamic OVERFLOW;

- (BeeUIMetrics *)x
{
	return [self left];
}

- (BeeUIMetrics *)y
{
	return [self top];
}

- (BeeUIMetrics *)w
{
	BeeUIMetrics * value = [self.properties objectForKey:@"w"];
	if ( nil == value )
	{
//		return [BeeUIMetrics wrapContent];
		return [BeeUIMetrics percent:100];
	}
	
	return value;
}

- (BeeUIMetrics *)h
{
	BeeUIMetrics * value = [self.properties objectForKey:@"h"];
	if ( nil == value )
	{
		//		return [BeeUIMetrics wrapContent];
		return [BeeUIMetrics percent:100];
	}
	
	return value;
}

- (BeeUIMetrics *)top
{
	return [self.properties objectForKey:@"top"];
}

- (BeeUIMetrics *)left
{
	return [self.properties objectForKey:@"left"];
}

- (BeeUIMetrics *)right
{
	return [self.properties objectForKey:@"right"];
}

- (BeeUIMetrics *)bottom
{
	return [self.properties objectForKey:@"bottom"];
}

- (BeeUIMetrics *)min_width
{
	BeeUIMetrics * value = [self.properties objectForKey:@"min_width"];
	if ( nil == value )
	{
		return nil;
//		return [BeeUIMetrics pixel:0.0f];
//		return [BeeUIMetrics percent:100];
	}
	
	return value;
}

- (BeeUIMetrics *)max_width
{
	BeeUIMetrics * value = [self.properties objectForKey:@"max_width"];
	if ( nil == value )
	{
		return nil;
//		return [BeeUIMetrics wrapContent];
//		return [BeeUIMetrics percent:100];
	}

	return value;
}

- (BeeUIMetrics *)min_height
{
	BeeUIMetrics * value = [self.properties objectForKey:@"min_height"];
	if ( nil == value )
	{
		return nil;
//		return [BeeUIMetrics pixel:0.0f];
//		return [BeeUIMetrics percent:100];
	}

	return value;
}

- (BeeUIMetrics *)max_height
{
	BeeUIMetrics * value = [self.properties objectForKey:@"max_height"];
	if ( nil == value )
	{
		return nil;
//		return [BeeUIMetrics wrapContent];
//		return [BeeUIMetrics percent:100];
	}
	
	return value;
}

- (NSString *)position
{
	return [self.properties objectForKey:@"position"];
}

- (NSString *)composition
{
	return [self.properties objectForKey:@"composition"];
}

- (BeeUIMetrics *)margin_left
{
	return [self.properties objectForKey:@"margin_left"];
}

- (BeeUIMetrics *)margin_right
{
	return [self.properties objectForKey:@"margin_right"];
}

- (BeeUIMetrics *)margin_top
{
	return [self.properties objectForKey:@"margin_top"];
}

- (BeeUIMetrics *)margin_bottom
{
	return [self.properties objectForKey:@"margin_bottom"];
}

- (BeeUIMetrics *)padding_left
{
	return [self.properties objectForKey:@"padding_left"];
}

- (BeeUIMetrics *)padding_right
{
	return [self.properties objectForKey:@"padding_right"];
}

- (BeeUIMetrics *)padding_top
{
	return [self.properties objectForKey:@"padding_top"];
}

- (BeeUIMetrics *)padding_bottom
{
	return [self.properties objectForKey:@"padding_bottom"];
}

- (NSString *)align
{
	return [self.properties objectForKey:@"align"];
}

- (NSString *)v_align
{
	return [self.properties objectForKey:@"v_align"];
}

- (NSString *)floating
{
	return [self.properties objectForKey:@"float"];
}

- (NSString *)v_floating
{
	return [self.properties objectForKey:@"v_float"];
}

- (NSString *)orientation
{
	return [self.properties objectForKey:@"orientation"];
}

- (NSString *)text
{
	return [self.properties objectForKey:@"text"];
}

- (NSString *)package
{
	return [self.properties objectForKey:@"package"];
}

- (NSString *)display
{
    return [self.properties objectForKey:@"display"];
}

- (NSString *)overflow
{
    return [self.properties objectForKey:@"overflow"];
}

#pragma mark -

- (BeeUIStyleBlockN)X
{
	return [self LEFT];
}

- (BeeUIStyleBlockN)Y
{
	return [self TOP];
}

- (BeeUIStyleBlockN)W
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			if ( value )
			{
				[self.properties setObject:value forKey:@"w"];
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)H
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			if ( value )
			{
				[self.properties setObject:value forKey:@"h"];
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)TOP
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			if ( value )
			{
				[self.properties setObject:value forKey:@"top"];
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)LEFT
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			if ( value )
			{
				[self.properties setObject:value forKey:@"left"];
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)RIGHT
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			if ( value )
			{
				[self.properties setObject:value forKey:@"right"];
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)BOTTOM
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			if ( value )
			{
				[self.properties setObject:value forKey:@"bottom"];
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)POSITION
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			[self.properties setObject:first forKey:@"position"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)COMPOSITION
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			[self.properties setObject:first forKey:@"composition"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)MARGIN
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			[self.properties setObject:value forKey:@"margin_left"];
			[self.properties setObject:value forKey:@"margin_right"];
			[self.properties setObject:value forKey:@"margin_top"];
			[self.properties setObject:value forKey:@"margin_bottom"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)MARGIN_TOP
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			[self.properties setObject:value forKey:@"margin_top"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)MARGIN_BOTTOM
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			[self.properties setObject:value forKey:@"margin_bottom"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)MARGIN_LEFT
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			[self.properties setObject:value forKey:@"margin_left"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)MARGIN_RIGHT
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			[self.properties setObject:value forKey:@"margin_right"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)MIN_WIDTH
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			[self.properties setObject:value forKey:@"min_width"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)MAX_WIDTH
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			[self.properties setObject:value forKey:@"max_width"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)MIN_HEIGHT
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			[self.properties setObject:value forKey:@"min_height"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)MAX_HEIGHT
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			[self.properties setObject:value forKey:@"max_height"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)PADDING
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			[self.properties setObject:value forKey:@"padding_left"];
			[self.properties setObject:value forKey:@"padding_right"];
			[self.properties setObject:value forKey:@"padding_top"];
			[self.properties setObject:value forKey:@"padding_bottom"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)PADDING_TOP
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			[self.properties setObject:value forKey:@"padding_top"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)PADDING_BOTTOM
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			[self.properties setObject:value forKey:@"padding_bottom"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)PADDING_LEFT
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			[self.properties setObject:value forKey:@"padding_left"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)PADDING_RIGHT
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
			[self.properties setObject:value forKey:@"padding_right"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)ALIGN
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			[self.properties setObject:first forKey:@"align"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)V_ALIGN
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			[self.properties setObject:first forKey:@"v_align"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)FLOATING
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			[self.properties setObject:first forKey:@"float"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)V_FLOATING
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			[self.properties setObject:first forKey:@"v_float"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)ORIENTATION
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			[self.properties setObject:first forKey:@"orientation"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)TEXT
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			[self.properties setObject:first forKey:@"text"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)PACKAGE
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			[self.properties setObject:first forKey:@"package"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)DISPLAY
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			[self.properties setObject:first forKey:@"display"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)OVERFLOW
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		if ( first )
		{
			[self.properties setObject:first forKey:@"overflow"];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

#pragma mark -

- (BOOL)isRelativePosition
{
	if ( nil == self.position )
	{
		return YES;	// default is relative
	}
	
	return [self.position isEqualToString:BeeUIStyle.POSITION_RELATIVE];
}

- (BOOL)isAbsolutePosition
{
	if ( nil == self.position )
	{
		return YES;	// default is relative
	}
	
	return [self.position isEqualToString:BeeUIStyle.POSITION_ABSOLUTE];
}

- (BOOL)isFlexiableW
{
	BeeUIMetrics * w = self.w;
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
	BeeUIMetrics * h = self.h;
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

- (BOOL)needAdjustX
{
	return [self needAdjust:self.x];
}

- (BOOL)needAdjustY
{
	return [self needAdjust:self.y];
}

- (BOOL)needAdjustW
{
	return [self needAdjust:self.w];
}

- (BOOL)needAdjustH
{
	return [self needAdjust:self.h];
}

- (BOOL)isAligning
{
	return self.align ? YES : NO;
}

- (BOOL)isAlignCenter
{
	return [self.align isEqualToString:BeeUIStyle.ALIGN_CENTER];
}

- (BOOL)isAlignLeft
{
	return [self.align isEqualToString:BeeUIStyle.ALIGN_LEFT];
}

- (BOOL)isAlignRight
{
	return [self.align isEqualToString:BeeUIStyle.ALIGN_RIGHT];
}

- (BOOL)isVAligning
{
	return self.v_align ? YES : NO;
}

- (BOOL)isVAlignCenter
{
	return [self.v_align isEqualToString:BeeUIStyle.ALIGN_CENTER];
}

- (BOOL)isVAlignTop
{
	return [self.v_align isEqualToString:BeeUIStyle.ALIGN_TOP];
}

- (BOOL)isVAlignBottom
{
	return [self.v_align isEqualToString:BeeUIStyle.ALIGN_BOTTOM];
}

- (BOOL)isFloating
{
	return self.floating ? YES : NO;
}

- (BOOL)isFloatCenter
{
	return [self.floating isEqualToString:BeeUIStyle.ALIGN_CENTER];
}

- (BOOL)isFloatLeft
{
	return [self.floating isEqualToString:BeeUIStyle.ALIGN_LEFT];
}

- (BOOL)isFloatRight
{
	return [self.floating isEqualToString:BeeUIStyle.ALIGN_RIGHT];
}

- (BOOL)isVFloating
{
	return self.v_floating ? YES : NO;
}

- (BOOL)isVFloatCenter
{
	return [self.v_floating isEqualToString:BeeUIStyle.ALIGN_CENTER];
}

- (BOOL)isVFloatTop
{
	return [self.v_floating isEqualToString:BeeUIStyle.ALIGN_TOP];
}

- (BOOL)isVFloatBottom
{
	return [self.v_floating isEqualToString:BeeUIStyle.ALIGN_BOTTOM];
}

- (BOOL)isHorizontal
{
	if ( nil == self.orientation )
	{
		return NO;
	}
	
	return [self.orientation isEqualToString:BeeUIStyle.ORIENTATION_HORIZONAL] ? YES : NO;
}

- (BOOL)isVertical
{
	if ( nil == self.orientation )
	{
		return NO;
	}
	
	return [self.orientation isEqualToString:BeeUIStyle.ORIENTATION_VERTICAL] ? YES : NO;
}

- (BOOL)isHidden
{
    if ( nil == self.display )
	{
		return NO;
	}
	
	return [self.display isEqualToString:BeeUIStyle.DISPLAY_NONE] ? YES : NO;
}

- (BOOL)hasMinW
{
    return nil != self.min_width;
}

- (BOOL)hasMaxW
{
    return nil != self.max_width;
}

- (BOOL)hasMinH
{
    return nil != self.min_height;
}

- (BOOL)hasMaxH
{
    return nil != self.max_height;
}

- (CGFloat)__estimateWidth:(BeeUIMetrics *)m byFrame:(CGRect)parentFrame
{
    CGSize  size = parentFrame.size;
    CGFloat mPixels = 0.0f;
    
    if ( m )
    {
        if ( BeeUIMetrics.PIXEL == m.type )
        {
            mPixels = m.value;
        }
        else if ( BeeUIMetrics.PERCENT == m.type )
        {
            mPixels = FLOORF( size.width * m.value / 100.0f );
        }
        else if ( BeeUIMetrics.FILL_PARENT == m.type )
        {
            mPixels = size.width;
        }
        else if ( BeeUIMetrics.WRAP_CONTENT == m.type )
        {
            mPixels = -1.0f;
        }
        else
        {
            mPixels = size.width;
        }
    }
    else
    {
        mPixels = size.width;
    }
    
    return mPixels;
}

- (CGFloat)__estimateHeight:(BeeUIMetrics *)m byFrame:(CGRect)parentFrame
{
    CGSize  size = parentFrame.size;
    CGFloat mPixels = 0.0f;
    
    if ( m )
    {
        if ( BeeUIMetrics.PIXEL == m.type )
        {
            mPixels = m.value;
        }
        else if ( BeeUIMetrics.PERCENT == m.type )
        {
            mPixels = FLOORF( size.height * m.value / 100.0f );
        }
        else if ( BeeUIMetrics.FILL_PARENT == m.type )
        {
            mPixels = size.height;
        }
        else if ( BeeUIMetrics.WRAP_CONTENT == m.type )
        {
            mPixels = -1.0f;
        }
        else
        {
            mPixels = size.height;
        }
    }
    else
    {
        mPixels = size.height;
    }
    
    return mPixels;
}

- (CGFloat)estimateWBy:(CGRect)parentFrame
{
    return [self __estimateWidth:self.w byFrame:parentFrame];
}

- (CGFloat)estimateHBy:(CGRect)parentFrame
{
    return [self __estimateHeight:self.h byFrame:parentFrame];
}

- (CGFloat)estimateMinWBy:(CGRect)parentFrame
{
    return [self __estimateWidth:self.min_width byFrame:parentFrame];
}

- (CGFloat)estimateMaxWBy:(CGRect)parentFrame
{
    return [self __estimateWidth:self.max_width byFrame:parentFrame];
}

- (CGFloat)estimateMinHBy:(CGRect)parentFrame
{
    return [self __estimateHeight:self.min_height byFrame:parentFrame];
}

- (CGFloat)estimateMaxHBy:(CGRect)parentFrame
{
    return [self __estimateHeight:self.max_height byFrame:parentFrame];
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
    BeeUIMetrics * l = self.margin_left;
	BeeUIMetrics * r = self.margin_right;
	BeeUIMetrics * t = self.margin_top;
	BeeUIMetrics * b = self.margin_bottom;
    
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
	BeeUIMetrics * l = self.padding_left;
	BeeUIMetrics * r = self.padding_right;
	BeeUIMetrics * t = self.padding_top;
	BeeUIMetrics * b = self.padding_bottom;
    
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

- (CGFloat)estimateXBy:(CGRect)parentFrame
{
	return [self estimateLeftBy:parentFrame];
}

- (CGFloat)estimateYBy:(CGRect)parentFrame
{
	return [self estimateTopBy:parentFrame];
}

- (CGFloat)estimateLeftBy:(CGRect)parentFrame
{
	CGFloat newLeft = parentFrame.origin.x;
	
	BeeUIMetrics * left = self.left;
    if ( left )
    {
        if ( BeeUIMetrics.PIXEL == left.type )
        {
			newLeft = newLeft + left.value;
        }
        else if ( BeeUIMetrics.PERCENT == left.type )
        {
			newLeft = newLeft + FLOORF(  parentFrame.size.width * left.value / 100.0f );
        }
    }
    
	return newLeft;
}

- (CGFloat)estimateTopBy:(CGRect)parentFrame
{
	CGFloat newTop = parentFrame.origin.y;
	
	BeeUIMetrics * top = self.top;
    if ( top )
    {
        if ( BeeUIMetrics.PIXEL == top.type )
        {
			newTop = newTop + top.value;
        }
        else if ( BeeUIMetrics.PERCENT == top.type )
        {
			newTop = newTop + FLOORF( parentFrame.size.height * top.value / 100.0f );
        }
    }
	
	return newTop;
}

- (CGFloat)estimateRightBy:(CGRect)parentFrame
{
	CGFloat newRight = parentFrame.origin.x + parentFrame.size.width;
	
	BeeUIMetrics * right = self.right;
    if ( right )
    {
        if ( BeeUIMetrics.PIXEL == right.type )
        {
			newRight = newRight - right.value;
        }
        else if ( BeeUIMetrics.PERCENT == right.type )
        {
			newRight = newRight - FLOORF(  parentFrame.size.width * right.value / 100.0f );
        }
    }
    
	return newRight;
}

- (CGFloat)estimateBottomBy:(CGRect)parentFrame
{
	CGFloat newBottom = parentFrame.origin.y + parentFrame.size.height;
	
	BeeUIMetrics * bottom = self.bottom;
    if ( bottom )
    {
        if ( BeeUIMetrics.PIXEL == bottom.type )
        {
			newBottom = newBottom - bottom.value;
        }
        else if ( BeeUIMetrics.PERCENT == bottom.type )
        {
			newBottom = newBottom - FLOORF( parentFrame.size.height * bottom.value / 100.0f );
        }
    }

	return newBottom;
}

- (CGPoint)estimateOriginBy:(CGRect)parentFrame
{
	CGPoint	origin = parentFrame.origin;
	origin.x = [self estimateLeftBy:parentFrame];
	origin.y = [self estimateTopBy:parentFrame];
	return origin;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
