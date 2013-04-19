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
//  UIView+BeeUISignal.h
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "NSObject+BeeProperty.h"

#pragma mark -

#define AS_SIGNAL( __name )		AS_STATIC_PROPERTY( __name )
#define DEF_SIGNAL( __name )	DEF_STATIC_PROPERTY3( __name, @"signal", [self description] )

#pragma mark -

@interface NSObject(BeeUISignalResponder)

+ (NSString *)SIGNAL;
+ (NSString *)SIGNAL_TYPE;

- (BOOL)isUISignalResponder;

@end

#pragma mark -

@interface BeeUISignal : NSObject
{
	BOOL				_foreign;
	NSObject *			_foreignSource;
	
	BOOL				_dead;
	BOOL				_reach;
	NSUInteger			_jump;
	id					_source;
	id					_target;
	NSString *			_name;
	NSString *			_namePrefix;
	NSObject *			_object;
	NSObject *			_returnValue;
	NSString *			_preSelector;

	NSTimeInterval		_initTimeStamp;
	NSTimeInterval		_sendTimeStamp;
	NSTimeInterval		_reachTimeStamp;	

#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	NSMutableString *	_callPath;
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
}

@property (nonatomic, assign) BOOL				foreign;
@property (nonatomic, assign) id				foreignSource;

@property (nonatomic, assign) BOOL				dead;			// 杀死SIGNAL
@property (nonatomic, assign) BOOL				reach;			// 是否触达顶级ViewController
@property (nonatomic, assign) NSUInteger		jump;			// 转发次数
@property (nonatomic, assign) id				source;			// 发送来源
@property (nonatomic, assign) id				target;			// 转发目标
@property (nonatomic, retain) NSString *		name;			// Signal名字
@property (nonatomic, retain) NSString *		namePrefix;		// Signal前辍
@property (nonatomic, retain) NSObject *		object;			// 附带参数
@property (nonatomic, retain) NSObject *		returnValue;	// 返回值，默认为空
@property (nonatomic, retain) NSString *		preSelector;	// 返回值，默认为空

@property (nonatomic, assign) NSTimeInterval	initTimeStamp;
@property (nonatomic, assign) NSTimeInterval	sendTimeStamp;
@property (nonatomic, assign) NSTimeInterval	reachTimeStamp;

@property (nonatomic, readonly) NSTimeInterval	timeElapsed;		// 整体耗时
@property (nonatomic, readonly) NSTimeInterval	timeCostPending;	// 等待耗时
@property (nonatomic, readonly) NSTimeInterval	timeCostExecution;	// 处理耗时

#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
@property (nonatomic, retain) NSMutableString *	callPath;
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__

AS_STATIC_PROPERTY( YES_VALUE );
AS_STATIC_PROPERTY( NO_VALUE );

- (BOOL)is:(NSString *)name;
- (BOOL)isKindOf:(NSString *)prefix;
- (BOOL)isSentFrom:(id)source;

- (BOOL)send;
- (BOOL)forward:(id)target;

- (void)clear;

// 只有某些特殊的SIGNAL需要加传真假值，如WebView
- (BOOL)boolValue;
- (void)returnYES;
- (void)returnNO;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
