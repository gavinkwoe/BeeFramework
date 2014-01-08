//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//
//  Copyright (c) 2014-2015, Geek Zoo Studio
//  http://www.bee-framework.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "ServiceWizard_Config.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation ServiceWizard_Config

DEF_SINGLETON( ServiceWizard_Config )

@synthesize showBackground = _showBackground;
@synthesize showPageControl = _showPageControl;

@synthesize backgroundImage = _backgroundImage;

@synthesize pageDotSize = _pageDotSize;
@synthesize pageDotNormal = _pageDotNormal;
@synthesize pageDotHighlighted = _pageDotHighlighted;
@synthesize pageDotLast = _pageDotLast;

@synthesize splashes = _splashes;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.splashes = [NSMutableArray array];
	}
	return self;
}

- (void)dealloc
{
	self.splashes = nil;
	self.backgroundImage = nil;
	self.pageDotNormal = nil;
	self.pageDotHighlighted = nil;
	self.pageDotLast = nil;

	[super dealloc];
}

@end

#endif  // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
