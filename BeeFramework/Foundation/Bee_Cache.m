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
//  Bee_Cache.m
//

#import <QuartzCore/QuartzCore.h>
#import "JSONKit.h"

#import "Bee_Singleton.h"
#import "Bee_SystemInfo.h"
#import "Bee_Sandbox.h"
#import "Bee_Cache.h"
#import "Bee_Log.h"

#import "NSObject+BeeNotification.h"

#pragma mark -

@interface BeeFileCache(Private)
- (NSString *)cacheFileName:(NSString *)uniqueID;
@end

#pragma mark -

@implementation BeeFileCache

@synthesize cachePath = _cachePath;
@synthesize cacheUser = _cacheUser;

DEF_SINGLETON( BeeFileCache );

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.cacheUser = @"";
		self.cachePath = [NSString stringWithFormat:@"%@/%@/cache/", [BeeSandbox libCachePath], [BeeSystemInfo appVersion]];
	}
	return self;
}

- (void)dealloc
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	self.cachePath = nil;
	self.cacheUser = nil;
	
	[super dealloc];
}

- (NSString *)cacheFileName:(NSString *)key
{
	NSString * pathName = nil;
	if ( self.cacheUser && [self.cacheUser length] )
	{
		pathName = [self.cachePath stringByAppendingFormat:@"%@/", self.cacheUser];
	}
	else
	{
		pathName = self.cachePath;
	}
	
	if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:pathName] )
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:pathName
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
	}

	return [pathName stringByAppendingString:key];
}

- (BOOL)hasCached:(NSString *)key
{
	return [[NSFileManager defaultManager] fileExistsAtPath:[self cacheFileName:key]];
}

- (NSData *)dataForKey:(NSString *)key
{
	CC( @"load cache, %@", key );
	
	NSString * filePath = [self cacheFileName:key];
	return [NSData dataWithContentsOfFile:filePath];
}

- (void)saveData:(NSData *)data forKey:(NSString *)key
{
	if ( nil == data )
	{
		[self deleteKey:key];
	}
	else
	{
		[data writeToFile:[self cacheFileName:key] options:NSDataWritingAtomic error:NULL];
	}
}

- (NSData *)serialize:(NSObject *)obj
{
	if ( [obj isKindOfClass:[NSData class]] )
		return (NSData *)obj;
	
	if ( [obj isKindOfClass:[NSString class]] )
	{
		return [(NSString *)obj JSONData];
	}
	else if ( [obj isKindOfClass:[NSArray class]] )
	{
		return [(NSArray *)obj JSONData];
	}
	else if ( [obj isKindOfClass:[NSArray class]] )
	{
		return [(NSArray *)obj JSONData];
	}
	return nil;
}

- (NSObject *)unserialize:(NSData *)data
{
	return [data objectFromJSONData];
}

- (NSObject *)objectForKey:(NSString *)key
{
	NSData * data = [self dataForKey:key];
	if ( data )
	{
		return [self unserialize:data];		
	}

	return nil;
}

- (void)saveObject:(NSObject *)object forKey:(NSString *)key
{
	if ( nil == object )
	{
		[self deleteKey:key];
	}
	else
	{
		NSData * data = [self serialize:object];
		if ( data )
		{
			[self saveData:data forKey:key];
		}
	}
}

- (void)deleteKey:(NSString *)key
{
	[[NSFileManager defaultManager] removeItemAtPath:[self cacheFileName:key] error:nil];
}

- (void)deleteAll
{
	[[NSFileManager defaultManager] removeItemAtPath:_cachePath error:NULL];
	[[NSFileManager defaultManager] createDirectoryAtPath:_cachePath
							  withIntermediateDirectories:YES
											   attributes:nil
													error:NULL];
}

@end

#pragma mark -

#define DEFAULT_MAX_COUNT	(16)

@implementation BeeMemoryCache

@synthesize clearWhenMemoryLow = _clearWhenMemoryLow;
@synthesize maxCacheCount = _maxCacheCount;
@synthesize cachedCount = _cachedCount;
@synthesize cacheKeys = _cacheKeys;
@synthesize cacheObjs = _cacheObjs;

DEF_SINGLETON( BeeMemoryCache );

- (id)init
{
	self = [super init];
	if ( self )
	{
		_clearWhenMemoryLow = YES;
		_maxCacheCount = DEFAULT_MAX_COUNT;
		_cachedCount = 0;
		
		_cacheKeys = [[NSMutableArray alloc] init];
		_cacheObjs = [[NSMutableDictionary alloc] init];

		[self observeNotification:UIApplicationDidReceiveMemoryWarningNotification];
	}

	return self;
}

- (void)dealloc
{
	[self unobserveAllNotifications];
	
	[_cacheObjs removeAllObjects];
    [_cacheObjs release];
	
	[_cacheKeys removeAllObjects];
	[_cacheKeys release];
	
    [super dealloc];
}

- (BOOL)hasCached:(NSString *)key
{
	return [_cacheObjs objectForKey:key] ? YES : NO;
}

- (NSData *)dataForKey:(NSString *)key
{
	NSObject * obj = [self objectForKey:key];
	if ( obj && [obj isKindOfClass:[NSData class]] )
	{
		return (NSData *)obj;
	}
	
	return nil;
}

- (void)saveData:(NSData *)data forKey:(NSString *)key
{
	[self saveObject:data forKey:key];
}

- (NSObject *)objectForKey:(NSString *)key
{
	return [_cacheObjs objectForKey:key];
}

- (void)saveObject:(NSObject *)object forKey:(NSString *)key
{
	if ( nil == key )
		return;
	
	if ( nil == object )
		return;
	
	_cachedCount += 1;

	while ( _cachedCount >= _maxCacheCount )
	{
		NSString * tempKey = [_cacheKeys objectAtIndex:0];

		[_cacheObjs removeObjectForKey:tempKey];
		[_cacheKeys removeObjectAtIndex:0];

		_cachedCount -= 1;
	}

	[_cacheKeys addObject:key];
	[_cacheObjs setObject:object forKey:key];
}

- (void)deleteKey:(NSString *)key
{
	if ( [_cacheObjs objectForKey:key] )
	{
		[_cacheKeys removeObjectIdenticalTo:key];
		[_cacheObjs removeObjectForKey:key];

		_cachedCount -= 1;
	}	
}

- (void)deleteAll
{
	[_cacheKeys removeAllObjects];
	[_cacheObjs removeAllObjects];
	
	_cachedCount = 0;
}

- (void)handleNotification:(NSNotification *)notification
{
	if ( _clearWhenMemoryLow )
	{
		[self deleteAll];
	}
}

@end
