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

#import "Bee_Precompile.h"
#import "Bee_Singleton.h"

#pragma mark -

typedef enum
{
	BeeLogLevelNone			= 0,
	BeeLogLevelInfo			= 100,
	BeeLogLevelPerf			= 100 + 1,
	BeeLogLevelProgress		= 100 + 2,
	BeeLogLevelWarn			= 200,
	BeeLogLevelError		= 300
} BeeLogLevel;

#pragma mark -

#undef	CC
#define CC( ... )			[[BeeLogger sharedInstance] level:BeeLogLevelNone format:__VA_ARGS__];

#undef	INFO
#define INFO( ... )			[[BeeLogger sharedInstance] level:BeeLogLevelInfo format:__VA_ARGS__];

#undef	PERF
#define PERF( ... )			[[BeeLogger sharedInstance] level:BeeLogLevelPerf format:__VA_ARGS__];

#undef	WARN
#define WARN( ... )			[[BeeLogger sharedInstance] level:BeeLogLevelWarn format:__VA_ARGS__];

#undef	ERROR
#define ERROR( ... )		[[BeeLogger sharedInstance] level:BeeLogLevelError format:__VA_ARGS__];

#undef	PROGRESS
#define PROGRESS( ... )		[[BeeLogger sharedInstance] level:BeeLogLevelProgress format:__VA_ARGS__];

#undef	VAR_DUMP
#define VAR_DUMP( __obj )	[[BeeLogger sharedInstance] level:BeeLogLevelNone format:[__obj description]];

#undef	OBJ_DUMP
#define OBJ_DUMP( __obj )	[[BeeLogger sharedInstance] level:BeeLogLevelNone format:[__obj objectToDictionary]];

#undef	TODO
#define TODO( desc, ... )

#pragma mark -

@interface BeeBacklog : NSObject
@property (nonatomic, assign) BeeLogLevel		level;
@property (nonatomic, retain) NSDate *			time;
@property (nonatomic, retain) NSString *		text;
@end

#pragma mark -

@interface BeeLogger : NSObject

AS_SINGLETON( BeeLogger );

@property (nonatomic, assign) BOOL				enabled;
@property (nonatomic, assign) BOOL				backlog;
@property (nonatomic, retain) NSMutableArray *	backlogs;
@property (nonatomic, assign) NSUInteger		indentTabs;

- (void)toggle;
- (void)enable;
- (void)disable;

- (void)indent;
- (void)indent:(NSUInteger)tabs;
- (void)unindent;
- (void)unindent:(NSUInteger)tabs;

- (void)level:(BeeLogLevel)level format:(NSString *)format, ...;
- (void)level:(BeeLogLevel)level format:(NSString *)format args:(va_list)args;

@end

#pragma mark -

#if __cplusplus
extern "C" {
#endif

	void BeeLog( NSString * format, ... );
	
#if __cplusplus
};
#endif
