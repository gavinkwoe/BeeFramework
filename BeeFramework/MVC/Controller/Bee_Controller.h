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
//  Bee_Controller.h
//

#import "Bee_Precompile.h"
#import "Bee_Core.h"
#import "Bee_Message.h"

#pragma mark -

@interface BeeController : NSObject<BeeMessageExecutor>
{
	NSString *				_prefix;
	NSMutableDictionary *	_mapping;
}

@property (nonatomic, retain) NSString *			prefix;
@property (nonatomic, retain) NSMutableDictionary *	mapping;

AS_SINGLETON( BeeController );

+ (NSString *)MESSAGE;		// 消息类别
+ (NSString *)MESSAGE_TYPE;	// = MESSAGE

+ (NSArray *)allControllers;

+ (BeeController *)routes:(NSString *)message;

- (void)load;
- (void)unload;

- (void)index:(BeeMessage *)msg;
- (void)route:(BeeMessage *)msg;

- (void)map:(NSString *)name action:(SEL)action;
- (void)map:(NSString *)name action:(SEL)action target:(id)target;

@end
