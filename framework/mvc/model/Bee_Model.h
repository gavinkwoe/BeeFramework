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

#import "Bee_Precompile.h"
#import "Bee_Foundation.h"

#pragma mark -

#undef	IN
#define IN

#undef	OUT
#define OUT

#undef	INOUT
#define INOUT

#pragma mark -

#undef	AS_MODEL
#define	AS_MODEL( __class, __tag ) \
		@property (nonatomic, retain) __class *	__tag;

#undef	DEF_MODEL
#define	DEF_MODEL( __class, __tag ) \
		@synthesize __tag = _##__tag;

#undef	SAFE_RELEASE_MODEL
#define SAFE_RELEASE_MODEL( __x ) \
		[__x removeObserver:self]; \
		[__x cancelMessages]; \
		[__x cancelRequests]; \
		__x = nil;

#pragma mark -

@class BeeModel;

typedef	void	(^BeeModelBlock)( void );
typedef	void	(^BeeModelBlockN)( id first, ... );

#pragma mark -

@interface BeeModel : NSObject

@property (nonatomic, assign) BOOL				autoLoad;
@property (nonatomic, assign) BOOL				autoSave;

@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSMutableArray *	observers;

+ (id)model;
+ (id)modelWithObserver:(id)observer;

+ (NSMutableArray *)models;
+ (NSMutableArray *)modelsByClass:(Class)clazz;
+ (NSMutableArray *)modelsByName:(NSString *)name;

- (void)addObserver:(id)obj;
- (void)removeObserver:(id)obj;
- (void)removeAllObservers;

- (void)loadCache;
- (void)saveCache;
- (void)clearCache;

@end
