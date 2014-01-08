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

#import "Bee_Precompile.h"
#import "Bee_Foundation.h"

#pragma mark -

@class BeeUISignal;

#pragma mark -

#undef	IS_UISIGNAL_RESPONDER
#define IS_UISIGNAL_RESPONDER( __flag ) \
		+ (BOOL)isUISignalResponder { return __flag; } \
		- (BOOL)isUISignalResponder { return __flag; }

#pragma mark -

#define AS_SIGNAL( __name )					AS_STATIC_PROPERTY( __name )
#define DEF_SIGNAL( __name )				DEF_STATIC_PROPERTY3( __name, @"signal", [self description] )
#define DEF_SIGNAL_ALIAS( __name, __alias )	DEF_STATIC_PROPERTY4( __name, __alias, @"signal", [self description] )

#undef	ON_SIGNAL
#define ON_SIGNAL( __signal ) \
		- (void)handleUISignal:(BeeUISignal *)__signal

#undef	ON_SIGNAL2
#define ON_SIGNAL2( __filter, __signal ) \
		- (void)handleUISignal_##__filter:(BeeUISignal *)__signal

#undef	ON_SIGNAL3
#define ON_SIGNAL3( __class, __name, __signal ) \
		- (void)handleUISignal_##__class##_##__name:(BeeUISignal *)__signal

#pragma mark -

typedef	BeeUISignal *	(^BeeUISignalBlock)( void );
typedef	BeeUISignal *	(^BeeUISignalBlockN)( id first, ... );
typedef BeeUISignal *	(^BeeUISignalBlockS)( NSString * tag );
typedef BeeUISignal *	(^BeeUISignalBlockB)( BOOL flag );

#pragma mark -

@interface NSObject(BeeUISignalResponder)

@property (nonatomic, assign) id signalReceiver;

+ (NSString *)SIGNAL;
+ (NSString *)SIGNAL_TYPE;

- (BOOL)isUISignalResponder;

- (NSString *)signalNamespace;
- (NSString *)signalTag;
- (NSObject *)signalTarget;

- (void)handleUISignal:(BeeUISignal *)signal;

@end

#pragma mark -

@interface BeeUISignal : NSObject

AS_INT( STATE_INIT )
AS_INT( STATE_SENDING )
AS_INT( STATE_ARRIVED )
AS_INT( STATE_DEAD )

@property (nonatomic, assign) BOOL					foreign;
@property (nonatomic, assign) id					foreignSource;
@property (nonatomic, assign) id					source;
@property (nonatomic, assign) id					target;

@property (nonatomic, assign) NSUInteger			state;
@property (nonatomic, assign) BOOL					sending;
@property (nonatomic, assign) BOOL					arrived;
@property (nonatomic, assign) BOOL					dead;

@property (nonatomic, readonly) NSUInteger			jumpCount;
@property (nonatomic, readonly) NSArray *			jumpPath;

@property (nonatomic, readonly) NSString *			prettyName;
@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSString *			prefix;
@property (nonatomic, retain) id					object;
@property (nonatomic, retain) id					returnValue;

@property (nonatomic, readonly) NSTimeInterval		initTimeStamp;
@property (nonatomic, readonly) NSTimeInterval		sendTimeStamp;
@property (nonatomic, readonly) NSTimeInterval		arriveTimeStamp;

@property (nonatomic, readonly) NSTimeInterval		timeElapsed;
@property (nonatomic, readonly) NSTimeInterval		timeCostPending;
@property (nonatomic, readonly) NSTimeInterval		timeCostExecution;

@property (nonatomic, readonly) BeeUISignalBlockN	SOURCE;
@property (nonatomic, readonly) BeeUISignalBlockN	TARGET;
@property (nonatomic, readonly) BeeUISignalBlockN	OBJECT;
@property (nonatomic, readonly) BeeUISignalBlock	DIE;
@property (nonatomic, readonly) BeeUISignalBlockN	RETURN;
@property (nonatomic, readonly) BeeUISignalBlock	RETURN_YES;
@property (nonatomic, readonly) BeeUISignalBlock	RETURN_NO;

+ (BeeUISignal *)signal;

- (BOOL)is:(NSString *)name;
- (BOOL)isKindOf:(NSString *)prefix;
- (BOOL)isSentFrom:(id)source;

- (void)changeState:(NSUInteger)newState;
- (void)log:(id)source;

- (BOOL)send;
- (BOOL)forward;
- (BOOL)forward:(id)target;

- (void)returnYES;
- (void)returnNO;
- (void)returnValue:(id)value;

- (BOOL)boolValue;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
