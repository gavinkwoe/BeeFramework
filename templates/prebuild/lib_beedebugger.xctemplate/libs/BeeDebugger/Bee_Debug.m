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
//	Bee_Debug.m
//

#import "Bee_Precompile.h"
#import "Bee.h"

#import "Bee_Debug.h"
#import "Bee_DebugWindow.h"
#import "Bee_DebugMemoryModel.h"
#import "Bee_DebugMessageModel.h"
#import "Bee_DebugNetworkModel.h"
#import "Bee_DebugHeatmapModel.h"
#import "Bee_DebugViewModel.h"

#import "Bee_DebugCrashReporter.h"

@implementation BeeDebugger

+ (void)show
{
#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__
	
	[BeeDebugMemoryModel sharedInstance];
	[BeeDebugMessageModel sharedInstance];
	[BeeDebugNetworkModel sharedInstance];
	[BeeDebugHeatmapModel sharedInstance];
	[BeeDebugViewModel sharedInstance];
	
#if defined(__BEE_CRASHLOG__) && __BEE_CRASHLOG__
	[[BeeDebugCrashReporter sharedInstance] install];
#endif	// #if defined(__BEE_CRASHLOG__) && __BEE_CRASHLOG__

	[BeeDebugShortcut sharedInstance].hidden = NO;
	[BeeDebugWindow sharedInstance].hidden = YES;

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__
}

@end
