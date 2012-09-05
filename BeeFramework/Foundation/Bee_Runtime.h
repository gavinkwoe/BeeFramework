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
//  Bee_Runtime.h
//

#pragma mark -

#undef	PRINT_CALLSTACK
#define PRINT_CALLSTACK( __n )	 [BeeRuntime printCallstack:__n]

#pragma mark -

typedef enum
{
	BEE_CALLFRAME_TYPE_UNKNOWN = 0,
	BEE_CALLFRAME_TYPE_OBJC,
	BEE_CALLFRAME_TYPE_NATIVEC
} BeeCallFrameType;

#pragma mark -

@interface BeeCallFrame : NSObject
{
	BeeCallFrameType	_type;
	NSString *			_process;
	NSUInteger			_entry;
	NSUInteger			_offset;
	NSString *			_clazz;
	NSString *			_method;
}

@property (nonatomic, assign) BeeCallFrameType	type;
@property (nonatomic, retain) NSString *			process;
@property (nonatomic, assign) NSUInteger			entry;
@property (nonatomic, assign) NSUInteger			offset;
@property (nonatomic, retain) NSString *			clazz;
@property (nonatomic, retain) NSString *			method;

+ (id)parse:(NSString *)line;
+ (id)unknown;

@end

#pragma mark -

@interface BeeRuntime : NSObject
{
}

+ (id)allocByClass:(Class)clazz;
+ (id)allocByClassName:(NSString *)clazzName;

+ (NSArray *)callstack:(NSUInteger)depth;
+ (NSArray *)callframes:(NSUInteger)depth;

+ (void)printCallstack:(NSUInteger)depth;

@end
