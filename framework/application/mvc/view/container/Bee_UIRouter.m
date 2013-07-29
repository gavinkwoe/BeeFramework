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

#import "Bee_UIRouter.h"
#import "Bee_UIStack.h"

#import "UIView+LifeCycle.h"
#import "UIViewController+LifeCycle.h"
#import "UIViewController+BeeUISignal.h"

#pragma mark -

@interface BeeUIRouterItem : NSObject
{
	NSNumber *		_type;
	NSObject *		_value;
	BeeUIStack *	_stack;
}

AS_NUMBER( TYPE_UNKNOWN )		// unknown
AS_NUMBER( TYPE_CLASS )			// class
AS_NUMBER( TYPE_BOARD )			// board

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
DEF_NUMBER( TYPE_BOARD,		2 )	// view controller

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

			if ( [clazz isSubclassOfClass:[UINavigationController class]] )
			{
				self.stack = [[[clazz alloc] init] autorelease];
			}
			else if ( [clazz isSubclassOfClass:[BeeUIBoard class]] )
			{
				self.stack = [BeeUIStack stackWithFirstBoardClass:clazz];
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
	NSString *				_url;
	NSMutableDictionary *	_mapping;
}

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

@synthesize url = _url;
@synthesize mapping = _mapping;

@dynamic currentBoard;
@dynamic currentStack;
@dynamic stacks;

- (void)load
{
	[super load];

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
	
	[_url release];

	[super unload];
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
			item.rule = rule;
			item.type = BeeUIRouterItem.TYPE_BOARD;
			item.value = board;

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

	if ( animated )
	{
		CATransition * transition = [CATransition animation];
		[transition setDuration:0.3f];
		[transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
		[transition setType:kCATransitionFade];
		[self.view.layer addAnimation:transition forKey:nil];
	}
	
	[self postNotification:self.STACK_WILL_CHANGE];
	[self sendUISignal:self.WILL_CHANGE];

	BeeUIRouterItem * currentItem = self.url.length ? [_mapping objectForKey:self.url] : nil;
	if ( currentItem )
	{
		BeeUIStack * stack = currentItem.stack;
		if ( stack )
		{
			[stack viewWillDisappear:NO];
			[stack viewDidDisappear:NO];
		}
	}

	for ( BeeUIRouterItem * item in _mapping.allValues )
	{
		if ( [item.rule isEqualToString:url] )
			continue;
			
		if ( item.stack )
		{
			[item.stack.view setHidden:YES];
		}
	}
	
	self.url = url;
	
	BeeUIRouterItem * newItem = [_mapping objectForKey:url];
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
//	else if ( [notification is:UIApplicationDidFinishLaunchingNotification] )
//	{
//		[UIApplication sharedApplication].keyWindow.rootViewController = [BeeUIRouter sharedInstance];
//	}
}

#pragma mark -

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( signal.source == self )
	{
		if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
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
		else
		{
			// TODO:
		}
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
