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
#import "Bee_Foundation.h"

#if (TARGET_OS_MAC)

#pragma mark -

AS_PACKAGE( BeePackage, BeeCLI, cli );

#pragma mark -

@class BeeCLI;
typedef BeeCLI * (^BeeCLIBlock)( void );
typedef BeeCLI * (^BeeCLIBlockS)( NSString * text );
typedef BeeCLI * (^BeeCLIBlockN)( id first, ... );

#pragma mark -

@interface BeeCLI : NSObject

AS_SINGLETON( BeeCLI );

@property (nonatomic, retain) NSString *		color;
@property (nonatomic, assign) BOOL				autoChangeBack;

@property (nonatomic, readonly) BeeCLIBlockN	ECHO;
@property (nonatomic, readonly) BeeCLIBlockN	LINE;
@property (nonatomic, readonly) BeeCLIBlock		RED;
@property (nonatomic, readonly) BeeCLIBlock		BLUE;
@property (nonatomic, readonly) BeeCLIBlock		CYAN;
@property (nonatomic, readonly) BeeCLIBlock		GREEN;
@property (nonatomic, readonly) BeeCLIBlock		YELLOW;
@property (nonatomic, readonly) BeeCLIBlock		LIGHT_RED;
@property (nonatomic, readonly) BeeCLIBlock		LIGHT_BLUE;
@property (nonatomic, readonly) BeeCLIBlock		LIGHT_CYAN;
@property (nonatomic, readonly) BeeCLIBlock		LIGHT_GREEN;
@property (nonatomic, readonly) BeeCLIBlock		LIGHT_YELLOW;
@property (nonatomic, readonly) BeeCLIBlock		NO_COLOR;

@property (nonatomic, retain) NSString *		workingDirectory;
@property (nonatomic, retain) NSString *		execPath;
@property (nonatomic, retain) NSString *		execName;
@property (nonatomic, retain) NSMutableArray *	arguments;

- (void)argc:(int)argc argv:(const char * [])argv;

- (NSString *)pathArgumentAtIndex:(NSUInteger)index;
- (NSString *)fileArgumentAtIndex:(NSUInteger)index;

@end

#endif	// #if (TARGET_OS_MAC)
