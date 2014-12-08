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

#import "Bee_UIStyleManager.h"
#import "CSSStyleSheet.h"

#pragma mark -

#undef	__PRELOAD_ALL__
#define __PRELOAD_ALL__		(__OFF__)

#pragma mark -

@interface BeeUIStyleManager()
{
	NSMutableDictionary *	_cache;
	BeeUIStyle *			_defaultStyle;
}

@end

#pragma mark -

@implementation BeeUIStyleManager

DEF_SINGLETON( BeeUIStyleManager )

@synthesize defaultStyle = _defaultStyle;
@dynamic defaultFile;
@dynamic defaultResource;

+ (BOOL)autoLoad
{
#if __PRELOAD_ALL__
	[[BeeUIStyleManager sharedInstance] preloadAll];
#endif	//	#if __PRELOAD_ALL__
	return NO;
}

+ (void)loadDefaultStyleFile:(NSString *)fileName
{
	[[BeeUIStyleManager sharedInstance] setDefaultFile:fileName];
}

+ (void)loadDefaultStyleResource:(NSString *)resName
{
	[[BeeUIStyleManager sharedInstance] setDefaultResource:resName];
}

- (void)setDefaultFile:(NSString *)fileName
{
	BeeUIStyle * style = [self fromFile:fileName useCache:YES];
	if ( style )
	{
		self.defaultStyle = style;
	}
}

- (void)setDefaultResource:(NSString *)resName
{
	BeeUIStyle * style = [self fromResource:resName useCache:YES];
	if ( style )
	{
		self.defaultStyle = style;
	}
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		_cache = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_cache removeAllObjects];
	[_cache release];
	
	[super dealloc];
}

- (BeeUIStyle *)fromResource:(NSString *)resName
{
	return [self fromResource:resName useCache:YES];
}

- (BeeUIStyle *)fromResource:(NSString *)resName useCache:(BOOL)flag
{
	if ( flag )
	{
		BeeUIStyle * cachedStyle = [_cache objectForKey:resName];
		if ( cachedStyle )
		{
			return cachedStyle;
		}
	}

	NSString *	extension = [resName pathExtension];
	NSString *	fullName = [resName substringToIndex:(resName.length - extension.length - 1)];
	
	NSString *	resPath = nil;
	NSString *	resPath2 = nil;
	NSString *	resDefaultPath = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
	
	if ( NSNotFound == [fullName rangeOfString:@"@"].location )
	{
		if ( [BeeSystemInfo isPhoneRetina4] )
		{
			resPath = [[NSBundle mainBundle] pathForResource:[fullName stringByAppendingString:@"-568h@2x"] ofType:extension];
			resPath2 = [[NSBundle mainBundle] pathForResource:[fullName stringByAppendingString:@"-568h"] ofType:extension];
		}
		else if ( [BeeSystemInfo isPhoneRetina35] )
		{
			resPath = [[NSBundle mainBundle] pathForResource:[fullName stringByAppendingString:@"@2x"] ofType:extension];
			resPath2 = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
		}
		else if ( [BeeSystemInfo isPhone35] )
		{
			resPath = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
		}
		else if ( [BeeSystemInfo isPadRetina] )
		{
			resPath = [[NSBundle mainBundle] pathForResource:[fullName stringByAppendingString:@"@2x"] ofType:extension];
			resPath2 = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
		}
		else if ( [BeeSystemInfo isPad] )
		{
			resPath = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
		}
		
        if ( !resPath ) {
            resPath = resDefaultPath;
        }
	}
	
//	INFO( @"'%@' loaded", resName );
	
	NSData * data = [NSData dataWithContentsOfFile:resPath];
	if ( nil == data || 0 == data.length )
	{
		data = [NSData dataWithContentsOfFile:resPath2];
		if ( nil == data || 0 == data.length )
		{
			data = [NSData dataWithContentsOfFile:resDefaultPath];
		}
	}
	
	if ( nil == data || 0 == data.length )
	{
		ERROR( @"'%@' not found", resName );
		return nil;
	}

	NSDictionary * dict = [BeeUIStyleParser parse:data];
	if ( nil == dict )
	{
		ERROR( @"Unknown resource type '%@'", resName );
		return nil;
	}
    
    BeeUIStyle * style = [BeeUIStyle styleWithDictionary:dict];
	if ( nil == style )
	{
		ERROR( @"'%@' not found", resName );
		return nil;
	}
    
	NSString * cssString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	if ( nil == cssString )
	{
		ERROR( @"Unknown resource type '%@'", resName );
		return nil;
	}

	CSSStyleSheet *	sheet = [BeeUIStyleParser parseStyleSheet:cssString];
	if ( nil == sheet )
	{
		ERROR( @"Unknown resource type '%@'", resName );
		return nil;
	}
	
    [sheet ensureRuleSet];
	style.styleSheet = sheet;

	INFO( @"Stylesheet '%@' loaded", resName );
	
	if ( flag )
	{
		[_cache setObject:style forKey:resName];
	}
	
	style.name = resName;
	return style;
}

- (BeeUIStyle *)fromFile:(NSString *)resName
{
	return [self fromFile:resName useCache:YES];
}

- (BeeUIStyle *)fromFile:(NSString *)fileName useCache:(BOOL)flag
{
	if ( flag )
	{
		BeeUIStyle * cachedStyle = [_cache objectForKey:fileName];
		if ( cachedStyle )
		{
			return cachedStyle;
		}
	}
	
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:fileName];
	if ( NO == exists )
	{
		return nil;
	}
	
//	INFO( @"'%@' loaded", fileName );
	
	NSData * data = [NSData dataWithContentsOfFile:fileName];
	if ( nil == data || 0 == data.length )
		return nil;
	
	NSDictionary * dict = [BeeUIStyleParser parse:data];
	if ( nil == dict )
	{
		ERROR( @"Unknown resource type '%@'", fileName );
		return nil;
	}
    
    BeeUIStyle * style = [BeeUIStyle styleWithDictionary:dict];
	if ( nil == style )
	{
		ERROR( @"'%@' not found", fileName );
		return nil;
	}
    
	NSString * cssString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	if ( nil == cssString )
	{
		ERROR( @"Unknown resource type '%@'", fileName );
		return nil;
	}
	
	CSSStyleSheet *	sheet = [BeeUIStyleParser parseStyleSheet:cssString];
	if ( nil == sheet )
	{
		ERROR( @"Unknown resource type '%@'", fileName );
		return nil;
	}
	
    [sheet ensureRuleSet];
	style.styleSheet = sheet;
	
	INFO( @"Stylesheet '%@' loaded", fileName );
	
	if ( flag )
	{
		[_cache setObject:style forKey:fileName];
	}
	
	style.name = fileName;
	return style;
}

- (void)preloadAll
{
//	NSString * resPath = [[[NSBundle mainBundle] resourceURL] absoluteString];
//	if ( resPath )
//	{
//		NSArray * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resPath error:nil];
//
//		for ( NSString * filePath in files )
//		{
//			NSString * fileName = [filePath lastPathComponent];
//			NSString * extension = [filePath pathExtension];
//
//			if ( [BeeUITemplateParser supportForType:extension] )
//			{
//				[self fromResource:fileName useCache:YES];
//			}
//		}
//	}
}

- (void)clearCache
{
	[_cache removeAllObjects];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
