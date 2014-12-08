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

#import "Bee_UIRouter.h"
#import "Bee_UISignalBus.h"
#import "Bee_UIStack.h"

#import "UIView+LifeCycle.h"
#import "UIViewController+LifeCycle.h"
#import "UIViewController+BeeUISignal.h"

#pragma mark -

DEF_PACKAGE( BeePackage_UI, BeeUIRouter, router );

#pragma mark -

@interface BeeUIRouterItem : NSObject
{
	NSUInteger		_order;
	NSNumber *		_type;
	NSObject *		_value;
	BeeUIStack *	_stack;
}

AS_NUMBER( TYPE_UNKNOWN )		// unknown
AS_NUMBER( TYPE_CLASS )			// class
AS_NUMBER( TYPE_BOARD )			// board
AS_NUMBER( TYPE_STACK )			// stack

@property (nonatomic, assign) NSUInteger	order;
@property (nonatomic, retain) NSString *	rule;
@property (nonatomic, retain) NSNumber *	type;
@property (nonatomic, retain) NSObject *	value;
@property (nonatomic, retain) BeeUIStack *	stack;

- (BOOL)buildStack;

@end

#pragma mark -

@implementation BeeUIRouterItem

DEF_NUMBER( TYPE_UNKNOWN,	0 )	// unknown
DEF_NUMBER( TYPE_CLASS,		1 )	// class
DEF_NUMBER( TYPE_BOARD,		2 )	// board
DEF_NUMBER( TYPE_STACK,		3 )	// stack

@synthesize order = _order;
@synthesize rule = _rule;
@synthesize type = _type;
@synthesize value = _value;
@synthesize stack = _stack;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.type = self.TYPE_UNKNOWN;
	}
	return self;
}

- (BOOL)buildStack
{
	if ( nil == self.stack )
	{
		if ( [self.type isEqualToNumber:self.TYPE_CLASS] )
		{
			Class clazz = NSClassFromString( (NSString *)self.value );
			id instance = nil;

			if ( [clazz respondsToSelector:@selector(sharedInstance)] )
			{
				instance = [clazz sharedInstance];
			}
			else
			{
				instance = [[[clazz alloc] init] autorelease];
			}

			if ( [clazz isSubclassOfClass:[UINavigationController class]] )
			{
				self.stack = instance;
			}
			else if ( [clazz isSubclassOfClass:[BeeUIBoard class]] )
			{
				self.stack = [BeeUIStack stackWithFirstBoard:instance];
			}
		}
		else if ( [self.type isEqualToNumber:self.TYPE_BOARD] )
		{
			if ( [self.value isKindOfClass:[BeeUIBoard class]] )
			{
				self.stack = [BeeUIStack stackWithFirstBoard:(BeeUIBoard *)self.value];
			}
		}
		
		self.stack.name = self.rule;
	}

	return self.stack ? YES : NO;
}

- (void)dealloc
{
	self.rule = nil;
	self.type = nil;
	self.value = nil;
	self.stack = nil;

	[super dealloc];
}

@end

#pragma mark -

@interface BeeUIRouter()
{
	BeeUIRouterEffect		_effect;
	NSUInteger				_seed;
	NSString *				_url;
	NSMutableDictionary *	_mapping;
}

@property (nonatomic, assign) NSUInteger			seed;
@property (nonatomic, retain) NSString *			url;
@property (nonatomic, retain) NSMutableDictionary *	mapping;

@end

#pragma mark -

@implementation BeeUIRouter

DEF_SIGNAL( WILL_CHANGE )
DEF_SIGNAL( DID_CHANGED )

DEF_NOTIFICATION( STACK_WILL_CHANGE )
DEF_NOTIFICATION( STACK_DID_CHANGED )

DEF_SINGLETON( BeeUIRouter )

@synthesize seed = _seed;
@synthesize url = _url;
@synthesize mapping = _mapping;

@dynamic currentBoard;
@dynamic currentStack;
@dynamic stacks;

- (void)load
{
	_seed = 0;
	_effect = BeeUIRouterEffectNone;
	_mapping = [[NSMutableDictionary alloc] init];

	[self observeNotification:UIApplicationDidEnterBackgroundNotification];
	[self observeNotification:UIApplicationWillEnterForegroundNotification];
//	[self observeNotification:UIApplicationDidFinishLaunchingNotification];
}

- (void)unload
{	
	[self unobserveAllNotifications];

	[_mapping removeAllObjects];
	[_mapping release];
	_mapping = nil;
	
	[_url release];
	_url = nil;
}

- (void)map:(NSString *)rule toClass:(Class)clazz
{
	if ( nil == rule || nil == clazz )
		return;

	BeeUIRouterItem * item = [_mapping objectForKey:rule];
	if ( nil == item )
	{
		item = [[[BeeUIRouterItem alloc] init] autorelease];
		if ( item )
		{
			item.order = self.seed++;
			item.rule = rule;
			item.type = BeeUIRouterItem.TYPE_CLASS;
			item.value = [clazz description];

			[_mapping setObject:item forKey:rule];
		}
	}
}

- (void)map:(NSString *)rule toBoard:(BeeUIBoard *)board
{
	if ( nil == rule || nil == board )
		return;

	BeeUIRouterItem * item = [_mapping objectForKey:rule];
	if ( nil == item )
	{
		item = [[[BeeUIRouterItem alloc] init] autorelease];
		if ( item )
		{
			item.order = self.seed++;
			item.rule = rule;
			item.type = BeeUIRouterItem.TYPE_BOARD;
			item.value = board;

			[_mapping setObject:item forKey:rule];
		}
	}
}

- (void)map:(NSString *)rule toStack:(BeeUIStack *)stack
{
	if ( nil == rule || nil == stack )
		return;
	
	BeeUIRouterItem * item = [_mapping objectForKey:rule];
	if ( nil == item )
	{
		item = [[[BeeUIRouterItem alloc] init] autorelease];
		if ( item )
		{
			item.order = self.seed++;
			item.rule = rule;
			item.type = BeeUIRouterItem.TYPE_STACK;
			item.value = stack;
			
			[_mapping setObject:item forKey:rule];
		}
	}
}

- (BOOL)open:(NSString *)url
{
	return [self open:url animated:NO];
}

- (BOOL)open:(NSString *)url animated:(BOOL)animated
{
	if ( 0 == url.length )
		return NO;

//	if ( [url isEqualToString:self.url] )
//		return YES;

	BeeUIRouterItem * curItem = self.url.length ? [_mapping objectForKey:self.url] : nil;
	BeeUIRouterItem * newItem = [_mapping objectForKey:url];

	if ( curItem == newItem )
		return NO;
	
	if ( animated )
	{
		if ( BeeUIRouterEffectNone == _effect )
		{
			CATransition * transition = [CATransition animation];
			[transition setDuration:0.3f];
			[transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
			[transition setType:kCATransitionFade];
			[self.view.layer addAnimation:transition forKey:nil];
		}
		else if ( BeeUIRouterEffectPush == _effect )
		{
			if ( curItem.order == newItem.order )
			{
				CATransition * transition = [CATransition animation];
				[transition setDuration:0.3f];
				[transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
				[transition setType:kCATransitionFade];
				[self.view.layer addAnimation:transition forKey:nil];
			}
			else if ( curItem.order < newItem.order )
			{
				CATransition * transition = [CATransition animation];
				[transition setDuration:0.3f];
				[transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
				[transition setType:kCATransitionMoveIn];
				[transition setSubtype:kCATransitionFromRight];
				[self.view.layer addAnimation:transition forKey:nil];
			}
			else
			{
				CATransition * transition = [CATransition animation];
				[transition setDuration:0.3f];
				[transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
				[transition setType:kCATransitionMoveIn];
				[transition setSubtype:kCATransitionFromLeft];
				[self.view.layer addAnimation:transition forKey:nil];
			}
		}
	}

	[self postNotification:BeeUIRouter.STACK_WILL_CHANGE];
	[self sendUISignal:BeeUIRouter.WILL_CHANGE];

	for ( BeeUIRouterItem * item in _mapping.allValues )
	{
		if ( [item.rule isEqualToString:url] )
			continue;

		if ( item.stack )
		{
			[item.stack.view setHidden:YES];
		}
	}

	if ( curItem )
	{
		BeeUIStack * stack = curItem.stack;
		if ( stack )
		{
			[stack viewWillDisappear:NO];
			[stack viewDidDisappear:NO];
		}
	}
	
	self.url = url;

	if ( newItem )
	{
		if ( nil == newItem.stack )
		{
			BOOL succeed = [newItem buildStack];
			if ( succeed )
			{
				[self.view addSubview:newItem.stack.view];
			}
		}
		
		if ( newItem.stack )
		{
			[self.view bringSubviewToFront:newItem.stack.view];

			[newItem.stack.view setHidden:NO];
			[newItem.stack viewWillAppear:NO];
			[newItem.stack viewDidAppear:NO];
		}
	}

	[self viewWillAppear:NO];
    [self viewDidAppear:NO];

	[self postNotification:self.STACK_DID_CHANGED];
	[self sendUISignal:self.DID_CHANGED];

	return YES;
}

- (BOOL)openExternal:(NSString *)url
{
	// TODO:
	
	return NO;
}

- (BOOL)openExternal:(NSString *)url withParams:(NSDictionary *)dict
{
	// TODO:
	
	return NO;
}

- (void)close:(NSString *)url
{
    for ( BeeUIRouterItem * item in _mapping.allValues )
	{
		if ( [item.rule isEqualToString:url] )
		{
            if ( item.stack )
            {
                [item.stack.view removeFromSuperview];
                item.stack = nil;

                [_mapping removeObjectForKey:item.rule];
				break;
            }
        }
	}
}

- (BeeUIBoard *)currentBoard
{
	BeeUIStack * stack = [self currentStack];
	if ( stack )
	{
		return stack.topBoard;
	}
	
	return nil;
}

- (BeeUIStack *)currentStack
{
	BeeUIRouterItem * currentItem = self.url.length ? [_mapping objectForKey:self.url] : nil;
	if ( currentItem )
	{
		return currentItem.stack;
	}
	
	return nil;
}

- (NSArray *)stacks
{
	NSMutableArray * array = [NSMutableArray nonRetainingArray];
	
	for ( BeeUIRouterItem * item in _mapping.allValues )
	{
		if ( item.stack )
		{
			[array addObject:item.stack];
		}
	}

	return array;
}

- (void)buildStacks
{
	for ( BeeUIRouterItem * item in _mapping.allValues )
	{
		if ( nil == item.stack )
		{
			BOOL succeed = [item buildStack];
			if ( succeed )
			{
				[self.view addSubview:item.stack.view];
			}
		}
	}
}

- (void)clear
{
    for ( BeeUIRouterItem * item in _mapping.allValues )
	{
        if ( item.stack )
		{
            [item.stack.view removeFromSuperview];
		}
    }

    [_mapping removeAllObjects];
}

- (id)objectForKeyedSubscript:(id)key
{
	if ( nil == key )
		return nil;
	
	BeeUIRouterItem * item = [_mapping objectForKey:key];
	if ( item )
	{
		return item.stack;
	}
	
	return nil;
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	if ( nil == key || nil == obj )
		return;
	
	if ( [obj isKindOfClass:[BeeUIBoard class]] )
	{
		[self map:key toBoard:obj];
	}
	else
	{
		[self map:key toClass:obj];
	}
}

#pragma mark -

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	for ( BeeUIRouterItem * item in _mapping.allValues )
	{
		if ( [item.stack isViewLoaded] && NO == item.stack.view.hidden )
		{
			[item.stack willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
		}
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	for ( BeeUIRouterItem * item in _mapping.allValues )
	{
		if ( [item.stack isViewLoaded] && NO == item.stack.view.hidden )
		{
			[item.stack didRotateFromInterfaceOrientation:fromInterfaceOrientation];
		}
	}
}

#pragma mark -

- (void)handleNotification:(NSNotification *)notification
{
	if ( [notification is:UIApplicationDidEnterBackgroundNotification] )
	{
		for ( BeeUIRouterItem * item in _mapping.allValues )
		{
			if ( item.stack )
			{
				[item.stack __enterBackground];
			}
		}
	}
	else if ( [notification is:UIApplicationWillEnterForegroundNotification] )
	{
		for ( BeeUIRouterItem * item in _mapping.allValues )
		{
			if ( item.stack )
			{
				[item.stack __enterForeground];
			}
		}
	}
	else if ( [notification is:UIApplicationWillChangeStatusBarOrientationNotification] )
	{
		NSNumber * newOrientation = [(NSDictionary *)notification.userInfo objectForKey:UIApplicationStatusBarOrientationUserInfoKey];

		for ( BeeUIRouterItem * item in _mapping.allValues )
		{
			if ( item.stack )
			{
				[item.stack willRotateToInterfaceOrientation:newOrientation.intValue duration:0.0f];
			}
		}
	}
	else if ( [notification is:UIApplicationDidChangeStatusBarOrientationNotification] )
	{
		NSNumber * oldOrientation = [(NSDictionary *)notification.userInfo objectForKey:UIApplicationStatusBarOrientationUserInfoKey];
		
		for ( BeeUIRouterItem * item in _mapping.allValues )
		{
			if ( item.stack )
			{
				[item.stack didRotateFromInterfaceOrientation:oldOrientation.intValue];
			}
		}
	}
}

#pragma mark -

- (void)handleUISignal:(BeeUISignal *)signal
{
	SIGNAL_FORWARD( signal );

	if ( signal.source == self )
	{
		if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
		{
			if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
			{
				// TODO:
				
				self.allowedLandscape = YES;
				self.allowedPortrait = YES;

				[self observeNotification:UIApplicationWillChangeStatusBarOrientationNotification];
				[self observeNotification:UIApplicationDidChangeStatusBarOrientationNotification];
			}
			else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
			{
				// TODO:

				[self unobserveAllNotifications];
			}

			if ( _mapping )
			{
				for ( BeeUIRouterItem * item in _mapping.allValues )
				{
					if ( item.stack )
					{
						if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
						{
							// TODO:
						}
						else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
						{
							// TODO:
						}
						else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
						{
							if ( [item.stack isViewLoaded] && NO == item.stack.view.hidden )
							{
								CGRect bounds = self.view.bounds;
								item.stack.view.frame = bounds;
							}
						}
						else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
						{
							if ( [item.stack isViewLoaded] && NO == item.stack.view.hidden )
							{
								[item.stack viewWillAppear:NO];
							}
						}
						else if ( [signal is:BeeUIBoard.DID_APPEAR] )
						{
							if ( [item.stack isViewLoaded] && NO == item.stack.view.hidden )
							{
								[item.stack viewDidAppear:NO];
							}
						}
						else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
						{
							if ( [item.stack isViewLoaded] && NO == item.stack.view.hidden )
							{
								[item.stack viewWillDisappear:NO];
							}
						}
						else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
						{
							if ( [item.stack isViewLoaded] && NO == item.stack.view.hidden )
							{
								[item.stack viewDidDisappear:NO];
							}
						}
					}
				}
			}
		}
		else
		{
			// TODO:
		}
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
