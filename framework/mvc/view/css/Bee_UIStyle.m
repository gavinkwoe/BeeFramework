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

#import "Bee_UIStyle.h"
#import "Bee_UIStyleParser.h"
#import "Bee_UICapability.h"
#import "BeeUIStyle+Builder.h"
#import "BeeUIStyle+Property.h"
#import "UIView+Tag.h"
#import "CSSStyleSheet.h"

#pragma mark -

@interface BeeUIStyle()
{
	NSUInteger				_version;
	NSString *				_name;
	NSMutableDictionary *	_properties;

	BOOL					_isRoot;
	BeeUIStyle *			_root;
	BeeUIStyle *			_parent;
	NSMutableDictionary *	_childs;
}

@end

#pragma mark -

@implementation BeeUIStyle

@synthesize version = _version;
@synthesize name = _name;
@synthesize properties = _properties;

@synthesize isRoot = _isRoot;
@synthesize root = _root;
@synthesize parent = _parent;
@synthesize childs = _childs;

+ (NSString *)generateName
{
	static NSUInteger __seed = 0;
	return [NSString stringWithFormat:@"__style_%u", __seed++];
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.version = 1;
		self.name = [BeeUIStyle generateName];
		self.properties = [NSMutableDictionary dictionary];
		self.childs = [NSMutableDictionary dictionary];
	}
	return self;
}

- (void)dealloc
{
    self.styleSheet = nil;
    
	self.name = nil;
	self.properties = nil;

	self.root = nil;
	self.parent = nil;
	self.childs = nil;
	
	[super dealloc];
}

+ (BeeUIStyle *)style
{
	return [[[BeeUIStyle alloc] init] autorelease];
}

+ (BeeUIStyle *)style:(NSUInteger)version
{
	BeeUIStyle * style = [[[BeeUIStyle alloc] init] autorelease];
	style.version = version;
	return style;
}

+ (BeeUIStyle *)styleWithDictionary:(NSDictionary *)dict
{
	BeeUIStyle * style = [[[BeeUIStyle alloc] init] autorelease];
	if ( style )
	{
		style.CSS( dict );
	}
	return style;
}

+ (BeeUIStyle *)styleWithStylesheet:(CSSStyleSheet *)sheet
{
    BeeUIStyle * style = [[[BeeUIStyle alloc] init] autorelease];
    style.styleSheet = [CSSStyleSheet styleSheet];
    [style.styleSheet mergeStyleSheet:sheet];
    return style;
}

#pragma mark -

- (void)applyTo:(id)object
{
	if ( nil == object || 0 == self.properties.count )
		return;
	
	if ( [[object class] supportForUIStyling] )
	{
		if ( [object isKindOfClass:[UIView class]] )
		{
			[object applyUIStyling:self.properties];
		}
		else if ( [object isKindOfClass:[UIViewController class]] )
		{
			[object applyUIStyling:self.properties];
		}
		else if ( [object isKindOfClass:[NSArray class]] )
		{
			for ( NSObject * obj in (NSArray *)object )
			{
				if ( [obj isKindOfClass:[UIView class]] )
				{
					[obj applyUIStyling:self.properties];
				}
				else if ( [obj isKindOfClass:[UIViewController class]] )
				{
					[obj applyUIStyling:self.properties];
				}
			}
		}
		else if ( [object isKindOfClass:[BeeUICollection class]] )
		{
			for ( NSObject * obj in ((BeeUICollection *)object).views )
			{
				[obj applyUIStyling:self.properties];
			}
		}
	}
}

- (CSSStyleSheet *)styleSheet
{
    if ( nil == _styleSheet )
    {
        _styleSheet = [[CSSStyleSheet alloc] init];
    }
    
    return _styleSheet;
}

- (void)mergeTo:(BeeUIStyle *)style
{
	if ( nil == style )
		return;

	if ( self.properties.count )
	{
		[style appendCSS:self.properties];
	}
}

- (BeeUIStyle *)combine:(BeeUIStyle *)style
{
	BeeUIStyle * newStyle = [BeeUIStyle style];
	[newStyle appendCSS:self];
	[newStyle appendCSS:style];
	return newStyle;
}

- (NSString *)propertyForKey:(NSString *)key
{
	return [self.properties objectForKey:key];
}

- (NSString *)propertyForKeyArray:(NSArray *)array
{
	for ( NSString * key in array )
	{
		NSString * value = [self.properties objectForKey:key];
		if ( value )
		{
			return value;
		}
	}
	
	return nil;
}

- (void)setProperty:(NSString *)value forKey:(NSString *)key
{
	[self.properties setObject:value forKey:key];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
