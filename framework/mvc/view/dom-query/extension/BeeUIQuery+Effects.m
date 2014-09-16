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

#import "BeeUIQuery+Effects.h"
#import "UIView+Animation.h"
#import "Bee_UIStyle.h"
#import "Bee_UIAnimation.h"
#import "Bee_UIAnimationAlpha.h"
#import "Bee_UIAnimationBounce.h"
#import "Bee_UIAnimationFade.h"
#import "Bee_UIAnimationStyling.h"
#import "Bee_UIAnimationZoom.h"

#pragma mark -

@implementation BeeUIQuery(Effects)

@dynamic hidden;
@dynamic visible;
@dynamic animating;

@dynamic AND;
@dynamic THEN;

@dynamic ANIMATE;
@dynamic COMMIT;
@dynamic CANCEL;
@dynamic STOP;	// equals to CANCEL

@dynamic CURVE;
@dynamic DELAY;
@dynamic DURATION;

@dynamic ON_BEGIN;
@dynamic ON_COMPLETE;
@dynamic ON_CANCEL;
@dynamic ON_STOP;	// equals to ON_CANCEL

@dynamic FADE_IN;
@dynamic FADE_OUT;
@dynamic FADE_TO;
@dynamic FADE_TOGGLE;
@dynamic BOUNCE;
@dynamic DISSOLVE;
@dynamic ZOOM_IN;
@dynamic ZOOM_OUT;

#pragma mark -

- (BOOL)hidden
{
	for ( UIView * view in self.views )
	{
		if ( view.hidden )
			return YES;
	}

	return NO;
}

- (BOOL)visible
{
	for ( UIView * view in self.views )
	{
		if ( view.hidden )
			return NO;
	}
	
	return YES;
}

- (BOOL)animating
{
	for ( UIView * view in self.views )
	{
		BeeUIAnimation * anim = [BeeUIAnimation lastAnimationForView:view];
		if ( anim && anim.performing )
		{
			return YES;
		}
	}
	
	return NO;
}

#pragma mark -

- (BeeUIQueryObjectBlock)HIDE
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			v.hidden = YES;
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)SHOW
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			v.hidden = NO;
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)TOGGLE
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			v.hidden = v.hidden ? NO : YES;
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

#pragma mark -

- (BeeUIQueryObjectBlock)THEN
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * view in self.views )
		{
			BeeUIAnimation * anim = [BeeUIAnimation lastAnimationForView:view];
			if ( anim )
			{
				anim.then = YES;
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)AND
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * view in self.views )
		{
			BeeUIAnimation * anim = [BeeUIAnimation lastAnimationForView:view];
			if ( anim )
			{
				anim.then = NO;
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockX)ANIMATE
{
	BeeUIQueryObjectBlockX block = ^ BeeUIQuery * ( void (^block2)( void ) )
	{
		for ( UIView * view in self.views )
		{
			BeeUIAnimation * newAnim = nil;
			BeeUIAnimation * anim = [BeeUIAnimation lastAnimationForView:view];
			if ( anim && anim.then )
			{
				newAnim = [view animationWithType:BeeUIAnimationTypeDefault];
			}
			else
			{
				newAnim = [BeeUIAnimation animationWithType:BeeUIAnimationTypeDefault];
			}

			if ( newAnim )
			{
				newAnim.retainedObject = self.views;
				
				if ( block2 )
				{
					[newAnim begin];
					
					block2();

					[newAnim commit];
				}
				else
				{
					[newAnim perform];
				}
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)COMMIT
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * view in self.views )
		{
			NSArray * anims = [BeeUIAnimation animationsForView:view];
			
			for ( BeeUIAnimation * anim in anims )
			{
				[anim commit];
			}
		}

		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)STOP
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * view in self.views )
		{
			NSArray * anims = [BeeUIAnimation animationsForView:view];

			for ( BeeUIAnimation * anim in anims )
			{
				[anim cancel];
			}
		}

		return self;
	};

	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)HIDE_ON_STOP
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * view in self.views )
		{
			NSArray * anims = [BeeUIAnimation animationsForView:view];
			
			for ( BeeUIAnimation * anim in anims )
			{
				anim.hideWhenStop = YES;
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)SHOW_ON_STOP
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * view in self.views )
		{
			NSArray * anims = [BeeUIAnimation animationsForView:view];
			
			for ( BeeUIAnimation * anim in anims )
			{
				anim.showWhenStop = YES;
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)CANCEL
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * view in self.views )
		{
			NSArray * anims = [BeeUIAnimation animationsForView:view];
			
			for ( BeeUIAnimation * anim in anims )
			{
				[anim cancel];
			}
		}

		return self;
	};

	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockU)CURVE
{
	BeeUIQueryObjectBlockU block = ^ BeeUIQuery * ( NSUInteger curve )
	{
		for ( UIView * view in self.views )
		{
			BeeUIAnimation * anim = [BeeUIAnimation lastAnimationForView:view];
			if ( anim )
			{
				[anim setCurve:curve];
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockF)DELAY
{
	BeeUIQueryObjectBlockF block = ^ BeeUIQuery * ( CGFloat delay )
	{
		for ( UIView * view in self.views )
		{
			BeeUIAnimation * anim = [BeeUIAnimation lastAnimationForView:view];
			if ( anim )
			{
				[anim setDelay:delay];
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockF)DURATION
{
	BeeUIQueryObjectBlockF block = ^ BeeUIQuery * ( CGFloat duration )
	{
		for ( UIView * view in self.views )
		{
			BeeUIAnimation * anim = [BeeUIAnimation lastAnimationForView:view];
			if ( anim )
			{
				[anim setDuration:duration];
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockX)ON_BEGIN
{
	BeeUIQueryObjectBlockX block = ^ BeeUIQuery * ( void (^block2)( void ) )
	{
		for ( UIView * view in self.views )
		{
			BeeUIAnimation * anim = [BeeUIAnimation lastAnimationForView:view];
			if ( anim )
			{
				anim.whenBegin = block2;
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockX)ON_COMPLETE
{
	BeeUIQueryObjectBlockX block = ^ BeeUIQuery * ( void (^block2)( void ) )
	{
		for ( UIView * view in self.views )
		{
			BeeUIAnimation * anim = [BeeUIAnimation lastAnimationForView:view];
			if ( anim )
			{
				anim.whenComplete = block2;
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockX)ON_CANCEL
{
	BeeUIQueryObjectBlockX block = ^ BeeUIQuery * ( void (^block2)( void ) )
	{
		for ( UIView * view in self.views )
		{
			BeeUIAnimation * anim = [BeeUIAnimation lastAnimationForView:view];
			if ( anim )
			{
				anim.whenCancel = block2;
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockX)ON_STOP
{
	BeeUIQueryObjectBlockX block = ^ BeeUIQuery * ( void (^block2)( void ) )
	{
		for ( UIView * view in self.views )
		{
			BeeUIAnimation * anim = [BeeUIAnimation lastAnimationForView:view];
			if ( anim )
			{
				anim.whenCancel = block2;
			}
		}
		
		return self;
	};

	return [[block copy] autorelease];
}

#pragma mark -

- (BeeUIQueryObjectBlock)FADE_IN
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		BeeUIAnimationFadeIn * anim = [BeeUIAnimation animationWithType:BeeUIAnimationTypeFadeIn];
		if ( anim )
		{
			anim.retainedObject = self.views;
			[anim perform];
		}

		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)FADE_OUT
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		BeeUIAnimationFadeOut * anim = [BeeUIAnimation animationWithType:BeeUIAnimationTypeFadeOut];
		if ( anim )
		{
			anim.retainedObject = self.views;
			[anim perform];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockF)FADE_TO
{
	BeeUIQueryObjectBlockF block = ^ BeeUIQuery * ( CGFloat progress )
	{
		BeeUIAnimationAlpha * anim = [BeeUIAnimation animationWithType:BeeUIAnimationTypeAlpha];
		if ( anim )
		{
			anim.to = progress;
			anim.retainedObject = self.views;
			[anim perform];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)FADE_TOGGLE
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		if ( self.view.hidden )
		{
			BeeUIAnimationFadeIn * anim = [BeeUIAnimation animationWithType:BeeUIAnimationTypeFadeIn];
			if ( anim )
			{
				anim.retainedObject = self.views;
				[anim perform];
			}
		}
		else
		{
			BeeUIAnimationFadeOut * anim = [BeeUIAnimation animationWithType:BeeUIAnimationTypeFadeOut];
			if ( anim )
			{
				anim.retainedObject = self.views;
				[anim perform];
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

#pragma mark -

- (BeeUIQueryObjectBlock)BOUNCE
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		BeeUIAnimationBounce * anim = [BeeUIAnimation animationWithType:BeeUIAnimationTypeBounce];
		if ( anim )
		{
			anim.retainedObject = self.views;
			[anim perform];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)DISSOLVE
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		BeeUIAnimationDissolve * anim = [BeeUIAnimation animationWithType:BeeUIAnimationTypeDissolve];
		if ( anim )
		{
			anim.retainedObject = self.views;
			[anim perform];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

#pragma mark -

- (BeeUIQueryObjectBlockR)ZOOM_IN
{
	BeeUIQueryObjectBlockR block = ^ BeeUIQuery * ( CGRect area )
	{
		BeeUIAnimationZoomIn * anim = [BeeUIAnimation animationWithType:BeeUIAnimationTypeZoomIn];
		if ( anim )
		{
			for ( UIView * view in self.views )
			{
				view.zoomed = YES;
			}
			
			anim.rect = area;
			anim.retainedObject = self.views;
			[anim perform];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)ZOOM_OUT
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		BeeUIAnimationZoomOut * anim = [BeeUIAnimation animationWithType:BeeUIAnimationTypeZoomOut];
		if ( anim )
		{
			for ( UIView * view in self.views )
			{
				view.zoomed = NO;
			}
			
			anim.retainedObject = self.views;
			[anim perform];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
