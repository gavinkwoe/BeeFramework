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

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "ServiceDebugger_Window.h"
#import "ServiceDebugger_DashBoard.h"
#import "ServiceDebugger_MemoryModel.h"
#import "ServiceDebugger_MessageModel.h"
#import "ServiceDebugger_NetworkModel.h"
#import "ServiceDebugger.h"

#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@implementation ServiceDebugger_Window

DEF_SINGLETON( ServiceDebugger_Window )

- (id)init
{
	self = [super initWithFrame:[UIScreen mainScreen].bounds];
	if ( self )
	{
		[ServiceDebugger_MemoryModel sharedInstance];
		[ServiceDebugger_MessageModel sharedInstance];
		[ServiceDebugger_NetworkModel sharedInstance];
		
		self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
		self.hidden = YES;
		self.windowLevel = UIWindowLevelNormal + 1.0f;

		self.rootViewController = [ServiceDebugger_DashBoard board];
		self.rootViewController.view;
	}
	return self;
}

- (void)dealloc
{
	self.rootViewController = nil;
	
	[super dealloc];
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
