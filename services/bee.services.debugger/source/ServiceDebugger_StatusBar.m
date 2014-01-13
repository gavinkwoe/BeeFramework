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

#import "ServiceDebugger_StatusBar.h"
#import "ServiceDebugger_PercentageView.h"
#import "ServiceDebugger.h"
#import "ServiceDebugger_CPUModel.h"
#import "ServiceDebugger_MemoryModel.h"
#import "ServiceDebugger_NetworkModel.h"
#import "ServiceDebugger_Unit.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@interface ServiceDebugger_StatusBar()
{
	ServiceDebugger_PercentageView *	_cpu;
	ServiceDebugger_PercentageView *	_memory;
	ServiceDebugger_PercentageView *	_network;
}
@end

#pragma mark -

@implementation ServiceDebugger_StatusBar

DEF_SINGLETON( ServiceDebugger_StatusBar )

- (void)load
{
	CGRect windowFrame = self.frame;
	windowFrame.size = [UIApplication sharedApplication].statusBarFrame.size;

	self.frame = windowFrame;
	self.backgroundColor = [UIColor clearColor];
	self.hidden = YES;
	self.windowLevel = UIWindowLevelStatusBar + 1.0f;

	CGRect viewFrame;
	viewFrame.origin = CGPointZero;
	viewFrame.size.width = self.width / 3.0f;
	viewFrame.size.height = 20.0f;

	_cpu = [[ServiceDebugger_PercentageView alloc] initWithFrame:viewFrame];
	_cpu.name = @"CPU";
	[self addSubview:_cpu];

	viewFrame.origin.x += viewFrame.size.width;
	
	_memory = [[ServiceDebugger_PercentageView alloc] initWithFrame:viewFrame];
	_memory.name = @"MEM";
	[self addSubview:_memory];
	
	viewFrame.origin.x += viewFrame.size.width;

	_network = [[ServiceDebugger_PercentageView alloc] initWithFrame:viewFrame];
	_network.name = @"NET";
	[self addSubview:_network];

	[self observeTick];
}

- (void)unload
{
	[self unobserveTick];
	
	[_cpu removeFromSuperview];
	[_cpu release];

	[_memory removeFromSuperview];
	[_memory release];

	[_network removeFromSuperview];
	[_network release];
}

ON_TICK( tick )
{
	_cpu.percent = [ServiceDebugger_CPUModel sharedInstance].usage;
	_cpu.value = [NSString stringWithFormat:@"%.1f%%", _cpu.percent * 100];
	[_cpu setNeedsDisplay];

	_memory.percent = [ServiceDebugger_MemoryModel sharedInstance].usage;
	_memory.value = [ServiceDebugger_Unit format:[ServiceDebugger_MemoryModel sharedInstance].usedBytes];
	[_memory setNeedsDisplay];

	NSUInteger concurrent = [ServiceDebugger_NetworkModel sharedInstance].concurrent;
	_network.percent = (concurrent > 10) ? 1.0f : (concurrent * 1.0f / 10.0f);
	_network.value = [NSString stringWithFormat:@"%@ / %@",
					  [ServiceDebugger_Unit format:[ServiceDebugger_NetworkModel sharedInstance].uploadBytes],
					  [ServiceDebugger_Unit format:[ServiceDebugger_NetworkModel sharedInstance].downloadBytes]];
	[_network setNeedsDisplay];
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
