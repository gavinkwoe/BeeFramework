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

#import "Bee_UIProgressView.h"
#import "UIView+BeeUISignal.h"
#import "UIView+LifeCycle.h"

#pragma mark -

@interface BeeUIProgressView()
{
	BOOL	_inited;
}

- (void)initSelf:(UIProgressViewStyle)style;

@end

@implementation BeeUIProgressView

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
	if ( NO == _inited )
	{
		self.progressViewStyle = UIProgressViewStyleDefault;
		
	#if defined(__IPHONE_5_0)
		if ( IOS5_OR_LATER )
		{
			self.progressTintColor = [UIColor whiteColor];
//			self.trackTintColor = ;
//			self.progressImage = ;
//			self.trackImage = ;
		}
	#endif
		
		_inited = YES;
		
//		[self load];
		[self performLoad];
	}
}

- (void)dealloc
{
//	[self unload];
	[self performUnload];

	[super dealloc];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
