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
//  Bee_Cache.h
//

#import <Foundation/Foundation.h>
#import "Bee_Singleton.h"

#pragma mark -

@protocol BeeCacheProtocol<NSObject>

- (BOOL)hasCached:(NSString *)key;

- (NSData *)dataForKey:(NSString *)key;
- (void)saveData:(NSData *)data forKey:(NSString *)key;

- (NSObject *)objectForKey:(NSString *)key;
- (void)saveObject:(NSObject *)object forKey:(NSString *)key;

- (void)deleteKey:(NSString *)key;
- (void)deleteAll;

@end

#pragma mark -

@interface BeeFileCache : NSObject<BeeCacheProtocol>
{
	NSString *				_cachePath;
	NSString *				_cacheUser;
}

@property (nonatomic, retain) NSString *			cachePath;
@property (nonatomic, retain) NSString *			cacheUser;

AS_SINGLETON( BeeFileCache );

- (NSData *)serialize:(NSObject *)obj;
- (NSObject *)unserialize:(NSData *)data;

@end

#pragma mark -

@interface BeeMemoryCache : NSObject<BeeCacheProtocol>
{
	BOOL					_clearWhenMemoryLow;
	NSUInteger				_maxCacheCount;
	NSUInteger				_cachedCount;
	NSMutableArray *		_cacheKeys;
	NSMutableDictionary *	_cacheObjs;
}

@property (nonatomic, assign) BOOL					clearWhenMemoryLow;
@property (nonatomic, assign) NSUInteger			maxCacheCount;
@property (nonatomic, assign) NSUInteger			cachedCount;
@property (nonatomic, retain) NSMutableArray *		cacheKeys;
@property (nonatomic, retain) NSMutableDictionary *	cacheObjs;

AS_SINGLETON( BeeMemoryCache );

@end
