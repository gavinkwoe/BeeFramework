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

#import "BeeUIQuery+Transform.h"
#import "UIView+Animation.h"
#import "Bee_UIStyle.h"
#import "Bee_UIAnimation.h"
#import "Bee_UIAnimationAlpha.h"
#import "Bee_UIAnimationBounce.h"
#import "Bee_UIAnimationFade.h"
#import "Bee_UIAnimationStyling.h"
#import "Bee_UIAnimationZoom.h"

#pragma mark -

@implementation BeeUIQuery(Transform)

@dynamic ALPHA;
@dynamic SCALE;
@dynamic ROTATE;
@dynamic TRANSLATE;

#pragma mark -

- (BeeUIQueryObjectBlockF)ALPHA
{
	BeeUIQueryObjectBlockF block = ^ BeeUIQuery * ( CGFloat alpha )
	{
		for ( UIView * view in self.views )
		{
			view.alpha = alpha;
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockFF)SCALE
{
	BeeUIQueryObjectBlockFF block = ^ BeeUIQuery * ( CGFloat scaleW, CGFloat scaleH )
	{
		for ( UIView * view in self.views )
		{
			view.transform = CGAffineTransformScale( CGAffineTransformIdentity, scaleW, scaleH );
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockF)ROTATE
{
	BeeUIQueryObjectBlockF block = ^ BeeUIQuery * ( CGFloat angle )
	{
		for ( UIView * view in self.views )
		{
			view.transform = CGAffineTransformRotate( CGAffineTransformIdentity, M_PI / 180.0f * angle );
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockFF)TRANSLATE
{
	BeeUIQueryObjectBlockFF block = ^ BeeUIQuery * ( CGFloat moveX, CGFloat moveY )
	{
		for ( UIView * view in self.views )
		{
			view.transform = CGAffineTransformTranslate( CGAffineTransformIdentity, moveX, moveY );
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
