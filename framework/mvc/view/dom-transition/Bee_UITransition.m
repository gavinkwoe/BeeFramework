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

#import "Bee_UITransition.h"
#import "Bee_UITransitionCube.h"
#import "Bee_UITransitionFade.h"
#import "Bee_UITransitionFlip.h"
#import "Bee_UITransitionPush.h"

#pragma mark -

@implementation BeeUITransition

@synthesize name = _name;

static BeeUITransition * __transition = nil;

+ (void)load
{
	[self setDefaultTransition:[BeeUITransitionPush sharedInstance]];
}

+ (BeeUITransition *)transitionWithType:(BeeUITransitionType)type
{
	if ( BeeUITransitionTypeCube == type )
	{
		return [BeeUITransitionCube sharedInstance];
	}
	else if ( BeeUITransitionTypeFade == type )
	{
		return [BeeUITransitionFade sharedInstance];
	}
	else if ( BeeUITransitionTypeFlip == type )
	{
		return [BeeUITransitionFlip sharedInstance];
	}
	else if ( BeeUITransitionTypePush == type )
	{
		return [BeeUITransitionPush sharedInstance];
	}

	return [BeeUITransitionPush sharedInstance];
}

+ (BeeUITransition *)defaultTransition
{
	return __transition;
}

+ (void)setDefaultTransition:(BeeUITransition *)trans
{
	__transition = trans;
}

+ (NSString *)CATransitionFrom:(BeeUITransitionDirection)dir;
{
	if ( dir == BeeUITransitionDirectionRight )
	{
		return kCATransitionFromRight;
	}
	else if ( dir == BeeUITransitionDirectionLeft )
	{
		return kCATransitionFromLeft;
	}
	else if ( dir == BeeUITransitionDirectionTop )
	{
		return kCATransitionFromTop;
	}
	else if ( dir == BeeUITransitionDirectionBottom )
	{
		return kCATransitionFromBottom;
	}
	
	return kCATransitionFromRight;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
//		[self load];
		[self performLoad];
	}
	return self;
}

- (void)dealloc
{
//	[self unload];
	[self performUnload];

	[super dealloc];
}

- (void)load
{
}

- (void)unload
{
}

- (void)transiteFor:(UIView *)container direction:(BeeUITransitionDirection)direction
{
	// TODO:
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
