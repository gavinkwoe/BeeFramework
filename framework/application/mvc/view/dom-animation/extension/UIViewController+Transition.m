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

#import "UIViewController+Transition.h"

#pragma mark -

@implementation UIViewController(Transition)

- (void)transition:(BeeUITransitionType)type
{
	[self.view transition:type];
}

- (void)transition:(BeeUITransitionType)type from:(BeeUITransitionFrom)from
{
	[self.view transition:type from:from];
}

- (void)transitionFade
{
	[self.view transitionFade];
}

- (void)transitionFade:(BeeUITransitionFrom)from
{
	[self.view transitionFade:from];
}

- (void)transitionCube
{
	[self.view transitionCube];
}

- (void)transitionCube:(BeeUITransitionFrom)from
{
	[self.view transitionCube:from];
}

- (void)transitionPush
{
	[self.view transitionPush];
}

- (void)transitionPush:(BeeUITransitionFrom)from
{
	[self.view transitionPush:from];
}

- (void)transitionFlip
{
	[self.view transitionFlip];
}

- (void)transitionFlip:(BeeUITransitionFrom)from
{
	[self.view transitionFlip:from];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
