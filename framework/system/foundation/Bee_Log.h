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
#import "Bee_Package.h"
#import "Bee_Package.h"
#import "Bee_Singleton.h"
#import "Bee_SystemConfig.h"
#import "Bee_SystemPackage.h"

#pragma mark -

AS_PACKAGE( BeePackage_System, BeeLogger, logger );

#pragma mark -

typedef enum
{
	BeeLogLevelNone		= 0,
	BeeLogLevelInfo		= 100,
	BeeLogLevelPerf		= 200,
	BeeLogLevelWarn		= 300,
	BeeLogLevelError	= 400
} BeeLogLevel;

#pragma mark -

#if __BEE_LOG__

#if __BEE_DEVELOPMENT__

#undef	CC
#define CC( ... )		[[BeeLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:BeeLogLevelNone format:__VA_ARGS__];

#undef	INFO
#define INFO( ... )		[[BeeLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:BeeLogLevelInfo format:__VA_ARGS__];

#undef	PERF
#define PERF( ... )		[[BeeLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:BeeLogLevelPerf format:__VA_ARGS__];

#undef	WARN
#define WARN( ... )		[[BeeLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:BeeLogLevelWarn format:__VA_ARGS__];

#undef	ERROR
#define ERROR( ... )	[[BeeLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:BeeLogLevelError format:__VA_ARGS__];

#undef	PRINT
#define PRINT( ... )	[[BeeLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:BeeLogLevelNone format:__VA_ARGS__];

#else	// #if __BEE_DEVELOPMENT__

#undef	CC
#define CC( ... )		[[BeeLogger sharedInstance] level:BeeLogLevelNone format:__VA_ARGS__];

#undef	INFO
#define INFO( ... )		[[BeeLogger sharedInstance] level:BeeLogLevelInfo format:__VA_ARGS__];

#undef	PERF
#define PERF( ... )		[[BeeLogger sharedInstance] level:BeeLogLevelPerf format:__VA_ARGS__];

#undef	WARN
#define WARN( ... )		[[BeeLogger sharedInstance] level:BeeLogLevelWarn format:__VA_ARGS__];

#undef	ERROR
#define ERROR( ... )	[[BeeLogger sharedInstance] level:BeeLogLevelError format:__VA_ARGS__];

#undef	PRINT
#define PRINT( ... )	[[BeeLogger sharedInstance] level:BeeLogLevelNone format:__VA_ARGS__];

#endif	// #if __BEE_DEVELOPMENT__

#undef	VAR_DUMP
#define VAR_DUMP( __obj )	PRINT( [__obj description] );

#undef	OBJ_DUMP
#define OBJ_DUMP( __obj )	PRINT( [__obj objectToDictionary] );

#else	// #if __BEE_LOG__

#undef	CC
#define CC( ... )

#undef	INFO
#define INFO( ... )

#undef	PERF
#define PERF( ... )

#undef	WARN
#define WARN( ... )

#undef	ERROR
#define ERROR( ... )

#undef	PRINT
#define PRINT( ... )

#undef	VAR_DUMP
#define VAR_DUMP( __obj )

#undef	OBJ_DUMP
#define OBJ_DUMP( __obj )

#endif	// #if __BEE_LOG__

#undef	TODO
#define TODO( desc, ... )

#pragma mark -

@interface BeeBacklog : NSObject
@property (nonatomic, retain) NSString *		module;
@property (nonatomic, assign) BeeLogLevel		level;
@property (nonatomic, readonly) NSString *		levelString;
@property (nonatomic, retain) NSString *		file;
@property (nonatomic, assign) NSUInteger		line;
@property (nonatomic, retain) NSString *		func;
@property (nonatomic, retain) NSDate *			time;
@property (nonatomic, retain) NSString *		text;
@end

#pragma mark -

@interface BeeLogger : NSObject

AS_SINGLETON( BeeLogger );

@property (nonatomic, assign) BOOL				showLevel;
@property (nonatomic, assign) BOOL				showModule;
@property (nonatomic, assign) BOOL				enabled;
@property (nonatomic, retain) NSMutableArray *	backlogs;
@property (nonatomic, assign) NSUInteger		indentTabs;

- (void)toggle;
- (void)enable;
- (void)disable;

- (void)indent;
- (void)indent:(NSUInteger)tabs;
- (void)unindent;
- (void)unindent:(NSUInteger)tabs;

#if __BEE_DEVELOPMENT__
- (void)file:(NSString *)file line:(NSUInteger)line function:(NSString *)function level:(BeeLogLevel)level format:(NSString *)format, ...;
- (void)file:(NSString *)file line:(NSUInteger)line function:(NSString *)function level:(BeeLogLevel)level format:(NSString *)format args:(va_list)args;
#else	// #if __BEE_DEVELOPMENT__
- (void)level:(BeeLogLevel)level format:(NSString *)format, ...;
- (void)level:(BeeLogLevel)level format:(NSString *)format args:(va_list)args;
#endif	// #if __BEE_DEVELOPMENT__

@end

#pragma mark -

#if __cplusplus
extern "C" {
#endif

	void BeeLog( NSString * format, ... );
	
#if __cplusplus
};
#endif
