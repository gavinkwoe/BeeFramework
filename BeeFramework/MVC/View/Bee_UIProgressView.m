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
//  Bee_UIProgressView.m
//

#import <QuartzCore/QuartzCore.h>
#import "Bee_UIProgressView.h"
#import "Bee_UISignal.h"
#import "Bee_SystemInfo.h"

#pragma mark -

@interface BeeUIProgressView(Private)
- (void)initSelf:(UIProgressViewStyle)style;
@end

@implementation BeeUIProgressView

+ (BeeUIProgressView *)spawn
{
	return [[[BeeUIProgressView alloc] init] autorelease];
}

- (id)init
{
	self = [super initWithFrame:CGRectZero];
	if ( self )
	{
		[self initSelf:UIProgressViewStyleBar];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		[self initSelf:UIProgressViewStyleBar];
	}
	return self;
}

- (id)initWithProgressViewStyle:(UIProgressViewStyle)style
{
	self = [super initWithProgressViewStyle:style];
	if ( self )
	{
		[self initSelf:style];
	}
	return self;
}

- (void)initSelf:(UIProgressViewStyle)style
{
	self.progressViewStyle = UIProgressViewStyleBar;
	
#if defined(__IPHONE_5_0)
	if ( IOS5_OR_LATER )
	{
		self.progressTintColor = [UIColor whiteColor];
//		self.trackTintColor = ;
//		self.progressImage = ;
//		self.trackImage = ;
	}
#endif
}

- (void)dealloc
{
	[super dealloc];
}

@end
