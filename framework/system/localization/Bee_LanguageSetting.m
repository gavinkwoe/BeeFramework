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

#import "Bee_LanguageSetting.h"

#pragma mark -

@interface BeeLanguageSetting()
{
	BeeLanguage *		_current;
	NSMutableArray *	_languages;
}

- (BeeLanguage *)currentLanguage;
- (BeeLanguage *)findLanguage:(NSString *)name;
- (void)applyLanguage:(BeeLanguage *)lang;

@end

#pragma mark -

@implementation BeeLanguageSetting

@dynamic name;

DEF_SINGLETON( BeeLanguageSetting )

DEF_NOTIFICATION( CHANGED )

+ (BOOL)autoLoad
{
	[BeeLanguageSetting setSystemLanguage];
	return YES;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		_current = nil;
		_languages = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_languages removeAllObjects];
	[_languages release];
	
	[super dealloc];
}

- (NSString *)name
{
	BeeLanguage * lang = [self currentLanguage];
	if ( lang )
	{
		return lang.name;
	}
	
	return nil;
}

- (void)setName:(NSString *)n
{
	if ( n && n.length )
	{
		[self setCurrentLanguageName:n];
	}
	else
	{
		[self setSystemLanguage];
	}
}

- (BeeLanguage *)findLanguage:(NSString *)name
{
	for ( BeeLanguage * lang in _languages )
	{
		if ( [lang.name isEqualToString:name] )
		{
			return lang;
		}
	}

	return nil;
}

- (void)applyLanguage:(BeeLanguage *)lang
{
	BOOL shouldNotify = _current ? YES : NO;

	BeeLanguage * lang2 = [self findLanguage:lang.name];
	if ( nil == lang2 )
	{
		[_languages addObject:lang];
	}
	
	_current = lang;

	if ( shouldNotify )
	{
		[self postNotification:self.CHANGED];
	}
}

+ (BeeLanguage *)currentLanguage
{
	return [[BeeLanguageSetting sharedInstance] currentLanguage];
}

- (BeeLanguage *)currentLanguage
{
	return _current;
}

+ (BOOL)setCurrentLanguage:(BeeLanguage *)lang
{
	return [[BeeLanguageSetting sharedInstance] setCurrentLanguage:lang];
}

- (BOOL)setCurrentLanguage:(BeeLanguage *)lang
{
	if ( nil == lang )
		return NO;
	
	[self applyLanguage:lang];
	return YES;
}

+ (BOOL)setCurrentLanguageName:(NSString *)name
{
	return [[BeeLanguageSetting sharedInstance] setCurrentLanguageName:name];
}

- (BOOL)setCurrentLanguageName:(NSString *)name
{
	BeeLanguage * lang = [self findLanguage:name];
	if ( nil == lang )
	{
		NSString * langPath = [[NSBundle mainBundle] pathForResource:name ofType:@"xml"];
		NSString * langPath2 = [[NSBundle mainBundle] pathForResource:name ofType:@"lang"];
		
		NSString * content = [NSString stringWithContentsOfFile:langPath encoding:NSUTF8StringEncoding error:NULL];
		if ( nil == content )
		{
			content = [NSString stringWithContentsOfFile:langPath2 encoding:NSUTF8StringEncoding error:NULL];
		}
		
		if ( content )
		{
			lang = [BeeLanguage language:content];
		}
	}

	if ( lang )
	{
		lang.name = name;
		
		[self applyLanguage:lang];
		return YES;
	}
	
	return NO;
}

+ (BOOL)setSystemLanguage
{
	return [[BeeLanguageSetting sharedInstance] setSystemLanguage];
}

- (BOOL)setSystemLanguage
{
	BOOL succeed = NO;
	
	NSString * langName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
	if ( langName )
	{
		succeed = [self setCurrentLanguageName:langName];
	}

	if ( NO == succeed )
	{
		succeed = [self setCurrentLanguageName:@"en-us"];
		if ( NO == succeed )
		{
			succeed = [self setCurrentLanguageName:@"default"];
		}
	}
	
	return succeed;
}

+ (NSString *)stringWithName:(NSString *)name
{
	return [[BeeLanguageSetting sharedInstance] stringWithName:name];
}

- (NSString *)stringWithName:(NSString *)name
{
	if ( nil == name || 0 == name.length )
		return nil;
	
	BeeLanguage * lang = [BeeLanguageSetting currentLanguage];
	if ( lang )
	{
		NSString * text = [lang stringWithName:name];
		if ( text )
		{
			return  text;
		}
	}

	return NSLocalizedString( name, name );
}

@end
