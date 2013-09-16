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

#import "Bee_UIStyle.h"

#pragma mark -

@implementation NSObject(BeeUIStyling)

+ (BOOL)supportForUIStyling
{
	return NO;
}

- (void)resetUIStyleProperties
{
}

- (void)applyUIStyleProperties:(NSDictionary *)properties
{
}

@end

#pragma mark -

@interface BeeUIStyle()
{
	NSString *				_name;
	NSMutableDictionary *	_properties;
}

+ (NSString *)generateName;

@end

#pragma mark -

@implementation BeeUIStyle

DEF_STRING( ALIGN_CENTER,			@"center" )
DEF_STRING( ALIGN_LEFT,				@"left" )
DEF_STRING( ALIGN_TOP,				@"top" )
DEF_STRING( ALIGN_BOTTOM,			@"bottom" )
DEF_STRING( ALIGN_RIGHT,			@"right" )

DEF_STRING( ORIENTATION_HORIZONAL,	@"horizonal" )
DEF_STRING( ORIENTATION_VERTICAL,	@"vertical" )

DEF_STRING( POSITION_ABSOLUTE,		@"absolute" )
DEF_STRING( POSITION_RELATIVE,		@"relative" )
DEF_STRING( POSITION_LINEAR,		@"linear" )

DEF_STRING( COMPOSITION_ABSOLUTE,	@"absolute" )
DEF_STRING( COMPOSITION_RELATIVE,	@"relative" )
DEF_STRING( COMPOSITION_LINEAR,		@"linear" )

@synthesize name = _name;
@synthesize properties = _properties;

@dynamic PROPERTY;

@dynamic css;
@dynamic CSS;

@dynamic APPLY_FOR;

@dynamic x;
@dynamic y;
@dynamic w;
@dynamic h;
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

@dynamic X;
@dynamic Y;
@dynamic W;
@dynamic H;
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
@dynamic VISIBLE;

+ (NSString *)generateName
{
	static NSUInteger __seed = 0;
	return [NSString stringWithFormat:@"style_%u", __seed++];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.name = [BeeUIStyle generateName];
		self.properties = [NSMutableDictionary dictionary];
	}
	return self;
}

- (void)dealloc
{
	self.name = nil;
	self.properties = nil;
	
	[super dealloc];
}

#pragma mark -

- (BeeUIStyleBlockN)PROPERTY
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		NSMutableDictionary * dict = nil;
		
		if ( [first isKindOfClass:[NSString class]] )
		{
			NSString * json = [(NSString *)first stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
			if ( json && json.length )
			{
				dict = [json objectFromJSONString];
				if ( nil == dict || NO == [dict isKindOfClass:[NSDictionary class]] )
				{
					va_list args;
					va_start( args, first );
					
					NSString * key = (NSString *)first;
					NSString * val = va_arg( args, NSString * );
					
					va_end( args );
					
					dict = [NSMutableDictionary dictionaryWithObject:val forKey:key];
				}
			}
		}
		else if ( [first isKindOfClass:[NSDictionary class]] )
		{
			dict = (NSMutableDictionary *)first;
		}
		
        self.CSS( dict );
        
		return self;
	};
	
	return [[block copy] autorelease];
}

- (NSString *)css
{
	NSMutableString * cssText = [NSMutableString string];
	
	for ( NSString * key in self.properties.allKeys )
	{
		NSString * value = [self.properties objectForKey:key];
		[cssText appendFormat:@"%@ : %@;", key, value];
	}

	return cssText;
}

- (BeeUIStyleBlockN)CSS
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		NSMutableDictionary * dict = nil;

        if ( first )
        {
            if ( [first isKindOfClass:[NSString class]] )
            {
                dict = [NSMutableDictionary dictionary];
                
                NSString *	text = (NSString *)first;
                NSArray *	segments = [text componentsSeparatedByString:@";"];
                
                for ( NSString * seg in segments )
                {
                    NSArray * keyValue = [seg componentsSeparatedByString:@":"];
                    if ( keyValue.count == 2 )
                    {
                        NSString * key = [keyValue objectAtIndex:0];
                        NSString * val = [keyValue objectAtIndex:1];
                        
                        key = key.trim.unwrap;
                        val = val.trim.unwrap;
                        
                        [dict setObject:val forKey:key];
                    }
                }
                
                [self.properties addEntriesFromDictionary:dict];
            }
            else if ( [first isKindOfClass:[NSDictionary class]] )
            {
                dict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)first];
            }
        }
        
		if ( dict && dict.count )
		{
			for ( NSString * key in dict.allKeys )
			{
				NSObject * value = [dict objectForKey:key];

				if ( value && [value isKindOfClass:[NSString class]] )
				{
					if ( [(NSString *)value rangeOfString:@"!important"].length )
					{
						NSString * newValue;
						newValue = [(NSString *)value stringByReplacingOccurrencesOfString:@"!important" withString:@""];
						newValue = newValue.trim;
						
						[dict setObject:newValue forKey:key];
					}
				}
			}

            NSString * x = [dict stringOfAny:@[@"x", @"left"]];
            if ( x )
            {
				[dict removeObjectForKey:@"x"];
				[dict removeObjectForKey:@"left"];
				
                self.X( x );
            }
            
			NSString * y = [dict stringOfAny:@[@"y", @"top"]];
			if ( y )
            {
				[dict removeObjectForKey:@"y"];
				[dict removeObjectForKey:@"top"];

                self.Y( y );
            }

			NSString * w = [dict stringOfAny:@[@"w", @"width"]];
            if ( w )
            {
				[dict removeObjectForKey:@"w"];
				[dict removeObjectForKey:@"width"];

                self.W( w );
            }

			NSString * h = [dict stringOfAny:@[@"h", @"height"]];
            if ( h )
            {
				[dict removeObjectForKey:@"h"];
				[dict removeObjectForKey:@"height"];

                self.H( h );
            }

			NSString * max_w = [dict stringOfAny:@[@"max-w", @"max-width"]];
            if ( max_w )
            {
				[dict removeObjectForKey:@"max-w"];
				[dict removeObjectForKey:@"max-width"];

                self.MAX_WIDTH( max_w );
            }

			NSString * max_h = [dict stringOfAny:@[@"max-h", @"max-height"]];
            if ( max_h )
            {
				[dict removeObjectForKey:@"max-h"];
				[dict removeObjectForKey:@"max-height"];

                self.MAX_HEIGHT( max_h );
            }
			
			NSString * min_w = [dict stringOfAny:@[@"min-w", @"min-width"]];
            if ( min_w )
            {
				[dict removeObjectForKey:@"min-w"];
				[dict removeObjectForKey:@"min-width"];
				
                self.MIN_WIDTH( min_w );
            }
			
			NSString * min_h = [dict stringOfAny:@[@"min-h", @"min-height"]];
            if ( min_h )
            {
				[dict removeObjectForKey:@"min-h"];
				[dict removeObjectForKey:@"min-height"];
				
                self.MIN_HEIGHT( max_h );
            }

			NSString * pos = [dict stringOfAny:@[@"position"]];
            if ( pos )
            {
				[dict removeObjectForKey:@"position"];

                self.POSITION( pos );
            }
            
            NSString * align = [dict stringOfAny:@[@"align"]];
            if ( align )
            {
				[dict removeObjectForKey:@"align"];
				
                self.ALIGN( align );
            }
            
            NSString * v_align = [dict stringOfAny:@[@"valign", @"v-align", @"vertical-align"]];
            if ( v_align )
            {
				[dict removeObjectForKey:@"valign"];
				[dict removeObjectForKey:@"v-align"];
				[dict removeObjectForKey:@"vertical-align"];
				
                self.V_ALIGN( v_align );
            }
            
            NSString * floating = [dict stringOfAny:@[@"float"]];
            if ( floating )
            {
				[dict removeObjectForKey:@"float"];
				
                self.FLOATING( floating );
            }
            
            NSString * v_floating = [dict stringOfAny:@[@"v-float", @"vertical-float"]];
            if ( v_floating )
            {
				[dict removeObjectForKey:@"v-float"];
				[dict removeObjectForKey:@"vertical-float"];
				
                self.V_FLOATING( v_floating );
            }
            
            NSString * orientation = [dict stringOfAny:@[@"orient", @"orientation"]];
            if ( orientation )
            {
				[dict removeObjectForKey:@"orient"];
				[dict removeObjectForKey:@"orientation"];

                if ( [orientation matchAnyOf:@[@"h", @"horizonal"]] )
                {
                    self.ORIENTATION( BeeUIStyle.ORIENTATION_HORIZONAL );
                }
                else if ( [orientation matchAnyOf:@[@"v", @"vertical"]] )
                {
                    self.ORIENTATION( BeeUIStyle.ORIENTATION_VERTICAL );
                }
                else
                {
                    self.ORIENTATION( BeeUIStyle.ORIENTATION_VERTICAL );
                }
            }
            
            NSString * margin = [dict stringOfAny:@[@"margin"]];
            if ( margin )
            {
				[dict removeObjectForKey:@"margin"];
				
                NSArray * components = [margin.trim componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ( components.count == 1 )
                {
                    self.MARGIN( ((NSString *)[components objectAtIndex:0]).trim );
                }
                else if ( components.count == 2 )
                {
                    self.MARGIN_TOP( ((NSString *)[components objectAtIndex:0]).trim );
                    self.MARGIN_RIGHT( ((NSString *)[components objectAtIndex:1]).trim );
                    self.MARGIN_BOTTOM( ((NSString *)[components objectAtIndex:0]).trim );
                    self.MARGIN_LEFT( ((NSString *)[components objectAtIndex:1]).trim );
                }
                else if ( components.count == 4 )
                {
                    self.MARGIN_TOP( ((NSString *)[components objectAtIndex:0]).trim );
                    self.MARGIN_RIGHT( ((NSString *)[components objectAtIndex:1]).trim );
                    self.MARGIN_BOTTOM( ((NSString *)[components objectAtIndex:2]).trim );
                    self.MARGIN_LEFT( ((NSString *)[components objectAtIndex:3]).trim );
                }
            }
            else
            {
                NSString * margin_left = [dict stringOfAny:@[@"margin-left"]];
                if ( margin_left )
                {
					[dict removeObjectForKey:@"margin-left"];
					
                    self.MARGIN_LEFT( margin_left.trim );
                }
                
                NSString * margin_right = [dict stringOfAny:@[@"margin-right"]];
                if ( margin_right )
                {
					[dict removeObjectForKey:@"margin-right"];

                    self.MARGIN_RIGHT( margin_right.trim );
                }
                
                NSString * margin_top = [dict stringOfAny:@[@"margin-top"]];
                if ( margin_top )
                {
					[dict removeObjectForKey:@"margin-top"];
					
                    self.MARGIN_TOP( margin_top.trim );
                }
                
                NSString * margin_bottom = [dict stringOfAny:@[@"margin-bottom"]];
                if ( margin_bottom )
                {
					[dict removeObjectForKey:@"margin-bottom"];

                    self.MARGIN_BOTTOM( margin_bottom.trim );
                }
            }
            
            NSString * padding = [dict stringOfAny:@[@"padding"]];
            if ( padding )
            {
				[dict removeObjectForKey:@"padding"];
				
                NSArray * components = [padding.trim componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ( components.count == 1 )
                {
                    self.PADDING( ((NSString *)[components objectAtIndex:0]).trim );
                }
                else if ( components.count == 2 )
                {
                    self.PADDING_TOP( ((NSString *)[components objectAtIndex:0]).trim );
                    self.PADDING_RIGHT( ((NSString *)[components objectAtIndex:1]).trim );
                    self.PADDING_BOTTOM( ((NSString *)[components objectAtIndex:0]).trim );
                    self.PADDING_LEFT( ((NSString *)[components objectAtIndex:1]).trim );
                }
                else if ( components.count == 4 )
                {
                    self.PADDING_TOP( ((NSString *)[components objectAtIndex:0]).trim );
                    self.PADDING_RIGHT( ((NSString *)[components objectAtIndex:1]).trim );
                    self.PADDING_BOTTOM( ((NSString *)[components objectAtIndex:2]).trim );
                    self.PADDING_LEFT( ((NSString *)[components objectAtIndex:3]).trim );
                }
            }
            else
            {
                NSString * padding_left = [dict stringOfAny:@[@"padding-left"]];
                if ( padding_left )
                {
					[dict removeObjectForKey:@"padding-left"];
					
                    self.PADDING_LEFT( padding_left.trim );
                }
                
                NSString * padding_right = [dict stringOfAny:@[@"padding-right"]];
                if ( padding_right )
                {
					[dict removeObjectForKey:@"padding-right"];
					
                    self.PADDING_RIGHT( padding_right.trim );
                }
                
                NSString * padding_top = [dict stringOfAny:@[@"padding-top"]];
                if ( padding_top )
                {
					[dict removeObjectForKey:@"padding-top"];
					
                    self.PADDING_TOP( padding_top.trim );
                }
                
                NSString * padding_bottom = [dict stringOfAny:@[@"padding-bottom"]];
                if ( padding_bottom )
                {
					[dict removeObjectForKey:@"padding-bottom"];
					
                    self.PADDING_BOTTOM( padding_bottom.trim );
                }
            }
			
			[self.properties addEntriesFromDictionary:dict];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)APPLY_FOR
{
    BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
    {
        [self applyFor:first];
        
		return self;
	};
	
	return [[block copy] autorelease];
}

- (void)applyFor:(id)object
{
	if ( nil == object || 0 == self.properties.count )
		return;
	
	if ( [[object class] supportForUIStyling] )
	{
		if ( [object isKindOfClass:[UIView class]] )
		{
			[object applyUIStyleProperties:self.properties];
		}
		else if ( [object isKindOfClass:[UIViewController class]] )
		{
			[object applyUIStyleProperties:self.properties];
		}
		else if ( [object isKindOfClass:[NSArray class]] )
		{
			for ( NSObject * obj in (NSArray *)object )
			{
				if ( [obj isKindOfClass:[UIView class]] )
				{
					[obj applyUIStyleProperties:self.properties];
				}
				else if ( [obj isKindOfClass:[UIViewController class]] )
				{
					[obj applyUIStyleProperties:self.properties];
				}
			}
		}
		else if ( [object isKindOfClass:[BeeUICollection class]] )
		{
			for ( NSObject * obj in ((BeeUICollection *)object).views )
			{
				[obj applyUIStyleProperties:self.properties];
			}
		}
	}
}

#pragma mark -

- (BeeUIMetrics *)x
{
	return [self.properties objectForKey:@"x"];
}

- (BeeUIMetrics *)y
{
	return [self.properties objectForKey:@"y"];
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

#pragma mark -

- (BeeUIStyleBlockN)X
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
		if ( value )
		{
			[self.properties setObject:value forKey:@"x"];
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)Y
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
		if ( value )
		{
			[self.properties setObject:value forKey:@"y"];
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)W
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
		if ( value )
		{
			[self.properties setObject:value forKey:@"w"];
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)H
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
		if ( value )
		{
			[self.properties setObject:value forKey:@"h"];
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)POSITION
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		[self.properties setObject:first forKey:@"position"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)COMPOSITION
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		[self.properties setObject:first forKey:@"composition"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)MARGIN
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
        BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
		[self.properties setObject:value forKey:@"margin_left"];
		[self.properties setObject:value forKey:@"margin_right"];
		[self.properties setObject:value forKey:@"margin_top"];
		[self.properties setObject:value forKey:@"margin_bottom"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)MARGIN_TOP
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
        BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
		[self.properties setObject:value forKey:@"margin_top"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)MARGIN_BOTTOM
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
        BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
		[self.properties setObject:value forKey:@"margin_bottom"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)MARGIN_LEFT
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
        BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
		[self.properties setObject:value forKey:@"margin_left"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)MARGIN_RIGHT
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
        BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
		[self.properties setObject:value forKey:@"margin_right"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)PADDING
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
        BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
		[self.properties setObject:value forKey:@"padding_left"];
		[self.properties setObject:value forKey:@"padding_right"];
		[self.properties setObject:value forKey:@"padding_top"];
		[self.properties setObject:value forKey:@"padding_bottom"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)PADDING_TOP
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
        BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
		[self.properties setObject:value forKey:@"padding_top"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)PADDING_BOTTOM
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
        BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
		[self.properties setObject:value forKey:@"padding_bottom"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)PADDING_LEFT
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
        BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
		[self.properties setObject:value forKey:@"padding_left"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)PADDING_RIGHT
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
        BeeUIMetrics * value = [BeeUIMetrics fromString:(NSString *)first];
		[self.properties setObject:value forKey:@"padding_right"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)ALIGN
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		[self.properties setObject:first forKey:@"align"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)V_ALIGN
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		[self.properties setObject:first forKey:@"v_align"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)FLOATING
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		[self.properties setObject:first forKey:@"float"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)V_FLOATING
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		[self.properties setObject:first forKey:@"v_float"];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleBlockN)ORIENTATION
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		[self.properties setObject:first forKey:@"orientation"];
		return self;
	};
	
	return [[block copy] autorelease];
}

#pragma mark -

- (void)mergeToStyle:(BeeUIStyle *)style
{
	if ( nil == style )
		return;
	
	style.CSS( self.properties );
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
