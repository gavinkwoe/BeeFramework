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

#import "Bee_UILabel.h"
#import "UIView+BeeUIStyle.h"
#import "UIView+LifeCycle.h"
#import "UIView+Tag.h"

#pragma mark -

@interface BeeUILabel()
{
	BOOL	_inited;
}

- (void)initSelf;

@end

@implementation BeeUILabel

- (id)init
{
	self = [super initWithFrame:CGRectZero];
	if ( self )
	{
		[self initSelf];
	}
	return self;	
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (void)initSelf
{
	if ( NO == _inited )
	{
		self.backgroundColor = [UIColor clearColor];
//		self.layer.masksToBounds = YES;
//		self.layer.opaque = NO; // YES;

		self.font = [UIFont systemFontOfSize:12.0f];
		self.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		self.textAlignment = UITextAlignmentCenter;
		self.textColor = [UIColor whiteColor];
		self.backgroundColor = [UIColor clearColor];
		self.lineBreakMode = UILineBreakModeTailTruncation;

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

- (void)setText:(NSString *)newText
{
	if ( [newText isEqualToString:self.text] )
	{
		return;
	}
	
	[super setText:newText];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
