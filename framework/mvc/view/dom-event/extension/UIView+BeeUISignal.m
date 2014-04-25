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

#import "UIView+BeeUISignal.h"
#import "UIView+UIViewController.h"
#import "UIView+Tag.h"

#pragma mark -

@implementation UIView(BeeUISignal)

IS_UISIGNAL_RESPONDER( YES )

- (void)handleUISignal:(BeeUISignal *)signal
{
	if ( signal.arrived )
		return;
	
	id receiver = self.signalReceiver;
	if ( nil == receiver )
	{
		receiver = self.superview;
	}
	
	if ( receiver )
	{
		[signal forward:receiver];
	}
	else
	{
		[signal log:self];
		
		signal.arrived = YES;
	}
}

- (NSString *)signalNamespace
{
	NSString * ns = self.nameSpace;	// .lowercaseString;

	if ( nil == ns )
	{
		ns = [[self class] description];
	}
	
	return ns;
}

- (NSString *)signalTag
{
	return self.tagString;
}

- (NSObject *)signalTarget
{
	UIViewController * nextController = [self viewController];
	if ( nextController )
	{
		return nextController;
	}

	return self;
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
	BeeUISignal * signal = [BeeUISignal signal];
	if ( signal )
	{
		signal.source = source ? source : self;
		signal.target = self;
		signal.name = name;
		signal.object = object;
		
		[signal send];
	}
	return signal;
}

- (BeeUISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object to:(id)target
{
	BeeUISignal * signal = [BeeUISignal signal];
	if ( signal )
	{
		signal.source = self;
		signal.target = target ? target : self;
		signal.name = name;
		signal.object = object;

		[signal send];
	}
	return signal;	
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
