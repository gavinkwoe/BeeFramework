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
//  Bee_Performance.h
//

#import "Bee_Precompile.h"
#import "Bee_Singleton.h"
#import "Bee_Log.h"

#pragma mark -

#if defined(__BEE_PERFORMANCE__) && __BEE_PERFORMANCE__

#define	PERF_MARK( __TAG )			[BeePerformance mark:__TAG];
#define	PERF_TIME( __TAG1, __TAG2 )	[BeePerformance between:__TAG1 and:__TAG2 remove:YES];

#define PERF_ENTER \
		[BeePerformance mark:[NSString stringWithFormat:@"enter %s", __PRETTY_FUNCTION__]];

#define PERF_ENTER_( __X ) \
		[BeePerformance mark:[NSString stringWithFormat:@"enter %s (%s)", __PRETTY_FUNCTION__, #__X]];

#define PERF_LEAVE \
		[BeePerformance mark:[NSString stringWithFormat:@"leave %s", __PRETTY_FUNCTION__]]; \
		CC( @"[PERF] \t%s, elapsed = %f", \
			__PRETTY_FUNCTION__, \
			[BeePerformance between:[NSString stringWithFormat:@"enter %s", __PRETTY_FUNCTION__] \
								and:[NSString stringWithFormat:@"leave %s", __PRETTY_FUNCTION__] \
							 remove:YES] );

#define PERF_LEAVE_( __X ) \
		[BeePerformance mark:[NSString stringWithFormat:@"leave %s (%s)", __PRETTY_FUNCTION__, #__X]]; \
		CC( @"[PERF] \t%s (%s), elapsed = %f", \
			__PRETTY_FUNCTION__, #__X, \
			[BeePerformance between:[NSString stringWithFormat:@"enter %s (%s)", __PRETTY_FUNCTION__, #__X] \
								and:[NSString stringWithFormat:@"leave %s (%s)", __PRETTY_FUNCTION__, #__X] \
							 remove:YES] );

#else	// #if defined(__BEE_PERFORMANCE__) && __BEE_PERFORMANCE__

#define	PERF_MARK( __TAG )
#define	PERF_TIME( __TAG1, __TAG2 )

#define PERF_ENTER
#define PERF_LEAVE

#define PERF_ENTER_( __X )
#define PERF_LEAVE_( __X )

#endif	// #if defined(__BEE_PERFORMANCE__) && __BEE_PERFORMANCE__

#pragma mark -

@interface BeePerformance : NSObject
{
	NSMutableDictionary *	_tags;
}

AS_SINGLETON( BeePerformance );

@property (nonatomic, retain) NSMutableDictionary *	tags;

+ (double)timestamp;

+ (double)mark:(NSString *)tag;
+ (double)between:(NSString *)tag1 and:(NSString *)tag2;
+ (double)between:(NSString *)tag1 and:(NSString *)tag2 remove:(BOOL)remove;

@end
