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
//  Bee_UISignal.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UISignal.h"
#import "Bee_Log.h"
#import "UIView+BeeUISignal.h"
#import "UIView+BeeExtension.h"

#import <objc/runtime.h>

#pragma mark -

@implementation UIView(BeeUISignal)

+ (NSString *)SIGNAL
{
	return [self SIGNAL_TYPE];
}

+ (NSString *)SIGNAL_TYPE
{
	return [NSString stringWithFormat:@"signal.%@.", [self description]];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	if ( self.superview )
	{
		[signal forward:self.superview];
	}
	else
	{
		signal.reach = YES;

	#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
		CC( @"[%@] > %@", signal.name, signal.callPath );
	#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	}
}

- (BeeUISignal *)sendUISignal:(NSString *)name
{
	return [self sendUISignal:name withObject:nil from:self];
}

- (BeeUISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object
{
	return [self sendUISignal:name withObject:object from:self];
}

- (BeeUISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object from:(id)source
{
	BeeUISignal * signal = [[[BeeUISignal alloc] init] autorelease];
	if ( signal )
	{
		NSString * selName = self.tagString.lowercaseString;
		selName = [selName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
//		selName = [selName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
		
		signal.preSelector = selName;	// v0.3.0 new feature, signal binding
		signal.source = source ? source : self;
		signal.target = self;
		signal.name = name;		
		signal.object = object;
		[signal send];
	}
	return signal;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
