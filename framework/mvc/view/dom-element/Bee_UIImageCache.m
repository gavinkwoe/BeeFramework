////
////	 ______    ______    ______
////	/\  __ \  /\  ___\  /\  ___\
////	\ \  __<  \ \  __\_ \ \  __\_
////	 \ \_____\ \ \_____\ \ \_____\
////	  \/_____/  \/_____/  \/_____/
////
////
////	Copyright (c) 2013-2014, {Bee} open source community
////	http://www.bee-framework.com
////
////
////	Permission is hereby granted, free of charge, to any person obtaining a
////	copy of this software and associated documentation files (the "Software"),
////	to deal in the Software without restriction, including without limitation
////	the rights to use, copy, modify, merge, publish, distribute, sublicense,
////	and/or sell copies of the Software, and to permit persons to whom the
////	Software is furnished to do so, subject to the following conditions:
////
////	The above copyright notice and this permission notice shall be included in
////	all copies or substantial portions of the Software.
////
////	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
////	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
////	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
////	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
////	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
////	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
////	IN THE SOFTWARE.
////
//
//#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
//
//#import "Bee_UIImageCache.h"
//#import "Bee_UIConfig.h"
//
//#import "Bee_Cache.h"
//#import "Bee_Network.h"
//
//#pragma mark -
//
//@implementation BeeImageCache
//{
//	NSLock *	_lock;
//}
//
//DEF_SINGLETON( BeeImageCache );
//
//@synthesize fileCache;
//@synthesize memoryCache;
//
//- (id)init
//{
//	self = [super init];
//	if ( self )
//	{
//		_lock = [[NSLock alloc] init];
//		
//		self.fileCache = [[[BeeFileCache alloc] init] autorelease];
//		self.fileCache.cachePath = [NSString stringWithFormat:@"%@/ImageCache/", [BeeSandbox libCachePath]];
//		self.fileCache.cacheUser = nil;
//		
//		self.memoryCache = [[[BeeMemoryCache alloc] init] autorelease];
//		self.memoryCache.clearWhenMemoryLow = YES;
//		self.memoryCache.maxCacheCount = 32;
//	}
//	return self;
//}
//
//- (void)dealloc
//{
//	self.fileCache = nil;
//	self.memoryCache = nil;
//	
//	[_lock release];
//	_lock = nil;
//	
//	[super dealloc];
//}
//
//- (void)lock
//{
//	[_lock lock];
//}
//
//- (void)unlock
//{
//	[_lock unlock];
//}
//
//- (id)objectForKey:(NSString *)url
//{
//	if ( nil == url || 0 == url.length )
//		return nil;
//
//	NSString *	cacheKey = [url MD5];
//	UIImage *	result = nil;
//	
//	[_lock lock];
//	
//	result = [self.memoryCache objectForKey:cacheKey];
//	if ( nil == result )
//	{
//		NSString * fullPath = [self.fileCache fileNameForKey:cacheKey];
//		if ( fullPath )
//		{
//			result = [[[UIImage alloc] initWithContentsOfFile:fullPath] autorelease];
//			if ( result )
//			{
//				[self.memoryCache setObject:result forKey:cacheKey];
//			}
//		}
//	}
//	
//	[_lock unlock];
//
//	return result;
//}
//
//- (BOOL)hasObjectForKey:(NSString *)url
//{
//	if ( nil == url || 0 == url.length )
//		return NO;
//
//	NSString * cacheKey = [url MD5];
//	
//	[_lock lock];
//
//	BOOL flag = [self.memoryCache hasObjectForKey:cacheKey];
//	if ( NO == flag )
//	{
//		flag = [self.fileCache hasObjectForKey:cacheKey];
//	}
//	
//	[_lock unlock];
//
//	return flag;
//}
//
//- (void)setObject:(id)object forKey:(NSString *)url
//{
//	if ( nil == url || 0 == url.length )
//		return;
//
//	NSString * cacheKey = [url MD5];
//
//	[_lock lock];
//
//	[self.memoryCache setObject:object forKey:cacheKey];
//	[self.fileCache setObject:UIImagePNGRepresentation(object) forKey:cacheKey];
//
//	[_lock unlock];
//}
//
//- (void)removeObjectForKey:(NSString *)url
//{
//	if ( nil == url || 0 == url.length )
//		return;
//	
//	NSString * cacheKey = [url MD5];
//	
//	[_lock lock];
//
//	[self.memoryCache removeObjectForKey:cacheKey];
//	[self.fileCache removeObjectForKey:cacheKey];
//
//	[_lock unlock];
//}
//
//- (void)removeAllObjects
//{
//	[_lock lock];
//	
//	[self.memoryCache removeAllObjects];
//	[self.fileCache removeAllObjects];
//	
//	[_lock unlock];
//}
//
//- (id)objectForKeyedSubscript:(id)key
//{
//	return [self objectForKey:key];
//}
//
//- (void)setObject:(id)obj forKeyedSubscript:(id)key
//{
//	[self setObject:obj forKey:key];
//}
//
//@end
//
//#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
