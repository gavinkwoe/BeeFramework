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

#import "Bee_UIAnimation.h"
#import "Bee_UIAnimationAlpha.h"
#import "Bee_UIAnimationBounce.h"
#import "Bee_UIAnimationFade.h"
#import "Bee_UIAnimationStyling.h"
#import "Bee_UIAnimationZoom.h"
#import "Bee_UIStyle.h"

#pragma mark -

#undef	DEFAULT_DURATION
#define DEFAULT_DURATION	(0.75f)

#pragma mark -

@interface BeeUIAnimation()
{
	NSDate *				_createDate;
	NSString *				_name;
	BeeUIAnimationType		_type;
	NSUInteger				_state;
	UIViewAnimationCurve	_curve;
	BOOL					_reversed;
	BOOL					_autoCommit;
	BOOL					_hideWhenStop;
	BOOL					_showWhenStop;
	BOOL					_then;
	CGFloat					_delay;
	CGFloat					_duration;
	NSMutableDictionary *	_params;
	NSMutableArray *		_childAnimations;
	
	BeeUIAnimationBlock		_whenBegin;
	BeeUIAnimationBlock		_whenComplete;
	BeeUIAnimationBlock		_whenCancel;

	id						_target;
	SEL						_action;
}
@end

#pragma mark -

@implementation BeeUIAnimation

DEF_INT( STATE_IDLE,		0 )
DEF_INT( STATE_PERFORMING,	1 )
DEF_INT( STATE_COMPLETED,	2 )
DEF_INT( STATE_CANCELLED,	3 )

@synthesize createDate = _createDate;
@synthesize name = _name;
@synthesize type = _type;
@synthesize state = _state;
@synthesize curve = _curve;
@dynamic curveReversed;
@synthesize reversed = _reversed;
@synthesize autoCommit = _autoCommit;
@synthesize hideWhenStop = _hideWhenStop;
@synthesize showWhenStop = _showWhenStop;
@synthesize then = _then;
@synthesize delay = _delay;
@synthesize duration = _duration;

@synthesize parentAnimation = _parentAnimation;
@synthesize childAnimations = _childAnimations;

@synthesize whenBegin = _whenBegin;
@synthesize whenComplete = _whenComplete;
@synthesize whenCancel = _whenCancel;

@synthesize performer = _performer;
@synthesize target = _target;
@synthesize action = _action;

@dynamic idle;
@dynamic performing;
@dynamic completed;
@dynamic cancelled;

static NSMutableArray * __allAnimations = nil;

+ (NSArray *)allAnimations
{
	if ( nil == __allAnimations )
		return nil;
	
	NSMutableArray * anims = [NSMutableArray nonRetainingArray];
	[anims addObjectsFromArray:__allAnimations];
	return anims;
}

+ (NSArray *)animationsForView:(UIView *)view
{
	if ( nil == __allAnimations )
		return nil;
	
	NSMutableArray * anims = [NSMutableArray nonRetainingArray];
	
	for ( BeeUIAnimation * anim in __allAnimations )
	{
		for ( UIView * view in anim.views )
		{
			if ( anim.view == view )
			{
				[anims addObject:anim];
				break;
			}
		}
	}

	return anims;
}

+ (id)lastAnimationForView:(UIView *)view
{
	NSArray * anims = [self animationsForView:view];
	if ( nil == anims || 0 == anims.count )
		return nil;
	
	return [anims lastObject];
}

+ (id)animationWithType:(BeeUIAnimationType)type
{
	if ( BeeUIAnimationTypeAlpha == type )
	{
		return [[[BeeUIAnimationAlpha alloc] init] autorelease];
	}
	else if ( BeeUIAnimationTypeBounce == type )
	{
		return [[[BeeUIAnimationAlpha alloc] init] autorelease];
	}
	else if ( BeeUIAnimationTypeDissolve == type )
	{
		return [[[BeeUIAnimationDissolve alloc] init] autorelease];
	}
	else if ( BeeUIAnimationTypeFadeOut == type )
	{
		return [[[BeeUIAnimationFadeOut alloc] init] autorelease];
	}
	else if ( BeeUIAnimationTypeFadeOut == type )
	{
		return [[[BeeUIAnimationFadeOut alloc] init] autorelease];
	}
	else if ( BeeUIAnimationTypeFadeIn == type )
	{
		return [[[BeeUIAnimationFadeIn alloc] init] autorelease];
	}
	else if ( BeeUIAnimationTypeStyling == type )
	{
		return [[[BeeUIAnimationStyling alloc] init] autorelease];
	}
	else if ( BeeUIAnimationTypeZoomIn == type )
	{
		return [[[BeeUIAnimationZoomIn alloc] init] autorelease];
	}
	else if ( BeeUIAnimationTypeZoomOut == type )
	{
		return [[[BeeUIAnimationZoomOut alloc] init] autorelease];
	}

	return [[[BeeUIAnimation alloc] init] autorelease];
}

- (id)animationWithType:(BeeUIAnimationType)type
{
	BeeUIAnimation * anim = [BeeUIAnimation animationWithType:type];
	if ( anim )
	{
		anim.parentAnimation = self;
		[self.childAnimations addObject:anim];
	}
	return anim;
}

+ (void)cancelAnimations
{
	for ( BeeUIAnimation * anim in __allAnimations )
	{
		[anim cancel];
	}
}

+ (void)cancelAnimationsByView:(UIView *)view
{
	for ( BeeUIAnimation * anim in __allAnimations )
	{
		if ( anim.view == view )
		{
			[anim cancel];
			break;
		}
	}
}

+ (NSString *)generateName
{
	static NSUInteger __seed = 0;
	return [NSString stringWithFormat:@"animation_%d", __seed++];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.createDate = [NSDate date];
		self.name = [BeeUIAnimation generateName];
		self.type = BeeUIAnimationTypeDefault;
		self.state = self.STATE_IDLE;
		self.curve = UIViewAnimationCurveEaseIn;
		self.reversed = NO;
		self.then = NO;
		self.delay = 0.0f;
		self.duration = DEFAULT_DURATION;
		self.autoCommit = YES;

		self.parentAnimation = nil;
		self.childAnimations = [NSMutableArray nonRetainingArray];

		self.performer = self;
		self.params = [[[NSMutableDictionary alloc] init] autorelease];

		if ( nil == __allAnimations )
		{
			__allAnimations = [[NSMutableArray alloc] init];
		}

		[__allAnimations addObject:self];

//		[self load];
		[self performLoad];
		
		INFO( @"%d animations are running", __allAnimations.count );
	}
	return self;
}

- (void)dealloc
{	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

//	[self unload];
	[self performUnload];

	self.createDate = nil;
	self.name = nil;
	self.params = nil;

	self.childAnimations = nil;
	self.parentAnimation = nil;

	self.whenBegin = nil;
	self.whenComplete = nil;
	self.whenCancel = nil;

	if ( [__allAnimations containsObject:self] )
	{
		[__allAnimations removeObject:self];
	}

	INFO( @"%d animations are running", __allAnimations.count );
	
	[super dealloc];
}

- (void)load
{
	
}

- (void)unload
{
	
}

- (UIViewAnimationCurve)curveReversed
{
	if ( UIViewAnimationCurveEaseInOut == self.curve )
	{
		return UIViewAnimationCurveEaseInOut;
	}
	else if ( UIViewAnimationCurveEaseIn == self.curve )
	{
		return UIViewAnimationCurveEaseOut;
	}
	else if ( UIViewAnimationCurveEaseOut == self.curve )
	{
		return UIViewAnimationCurveEaseIn;
	}
	else
	{
		return UIViewAnimationCurveLinear;
	}
}

- (BOOL)idle
{
	return (self.state == self.STATE_IDLE) ? YES : NO;
}

- (void)setIdle:(BOOL)value
{
	if ( value )
	{
		self.state = self.STATE_IDLE;
	}
}

- (BOOL)performing
{
	return (self.state == self.STATE_PERFORMING) ? YES : NO;
}

- (void)setPerforming:(BOOL)value
{
	if ( value )
	{
		INFO( @"'%@' performing", self.name );
		
		self.state = self.STATE_PERFORMING;
		
		if ( self.whenBegin )
		{
			self.whenBegin();
		}
	}
}

- (BOOL)completed
{
	return (self.state == self.STATE_COMPLETED) ? YES : NO;
}

- (void)setCompleted:(BOOL)value
{
	if ( value )
	{
		INFO( @"'%@' completed", self.name );
		
		self.state = self.STATE_COMPLETED;

		if ( !(self.showWhenStop && self.hideWhenStop) )
		{
			if ( self.showWhenStop )
			{
				for ( UIView * view in self.views )
				{
					view.hidden = NO;
				}
			}

			if ( self.hideWhenStop )
			{
				for ( UIView * view in self.views )
				{
					view.hidden = YES;
				}
			}
		}
		
		if ( self.target && self.action )
		{
			[self.target performSelector:self.action withObject:self];
		}
		
		if ( self.whenComplete )
		{
			self.whenComplete();
		}
		
		[__allAnimations removeObject:self];
	}
}

- (BOOL)cancelled
{
	return (self.state == self.STATE_CANCELLED) ? YES : NO;
}

- (void)setCancelled:(BOOL)value
{
	if ( value )
	{
		INFO( @"'%@' cancelled", self.name );
		
		self.state = self.STATE_CANCELLED;
		
		if ( self.target && self.action )
		{
			[self.target performSelector:self.action withObject:self];
		}

		if ( self.whenCancel )
		{
			self.whenCancel();
		}

		[__allAnimations removeObject:self];
	}
}

- (void)perform
{
	if ( self.performing )
		return;
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self performSelector:@selector(internalPerform)
			   withObject:nil
			   afterDelay:0.001f];
}

- (void)internalPerform
{
	self.performing = YES;

	if ( self.performer && [self.performer respondsToSelector:@selector(animationPerform)] )
	{
		[self.performer animationPerform];
	}
}

- (void)animationPerform
{
	self.completed = YES;
}

- (void)begin
{
	[self begin:nil];
}

- (void)begin:(SEL)stopSelector
{
	if ( self.performing )
		return;

	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDelay:self.delay];
	[UIView setAnimationDuration:self.duration];
	[UIView setAnimationDelegate:self];
	
	if ( stopSelector )
	{
		[UIView setAnimationDidStopSelector:stopSelector];
	}
	else
	{
		[UIView setAnimationDidStopSelector:@selector(animationDidStop)];
	}
}

- (void)animationDidStop
{
	if ( self.childAnimations )
	{
		for ( BeeUIAnimation * anim in self.childAnimations )
		{
			anim.parentAnimation = nil;
			[anim perform];
		}

		[self.childAnimations removeAllObjects];
	}

	self.completed = YES;
}

- (void)commit
{
	if ( self.performing )
		return;

	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[UIView commitAnimations];

	self.performing = YES;
}

- (void)cancel
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

//	[CATransaction begin];
//	
//	for ( UIView * view in self.views )
//	{
//		[view.layer removeAllAnimations];		
//	}
//
//	[CATransaction commit];
//	
//	self.cancelled = YES;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.001f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidCancel)];
	[UIView commitAnimations];
}

- (void)animationDidCancel
{
	self.cancelled = YES;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
