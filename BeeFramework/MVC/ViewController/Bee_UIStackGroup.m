//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
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
//
//  Bee_UIStackGroup.m
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "Bee_UIBoard.h"
#import "Bee_UIStack.h"
#import "Bee_UIStackGroup.h"
#import "Bee_UISignal.h"

#import "NSObject+BeeNotification.h"
#import "NSArray+BeeExtension.h"

#pragma mark -

@interface BeeUIStackGroup(Private)
- (void)arrange;
@end

#pragma mark -

@implementation BeeUIStackGroup

@synthesize stacks = _stacks;
@synthesize topIndex;
@synthesize topStack;

DEF_SINGLETON(BeeUIStackGroup)

DEF_SIGNAL( INDEX_CHANGED );

+ (BeeUIStackGroup *)group
{
	return [[[BeeUIStackGroup alloc] init] autorelease];
}

- (void)load
{
	[super load];
	
	_stacks = [[NSMutableArray alloc] init];
	_index = -1;

	[self observeNotification:UIApplicationDidEnterBackgroundNotification];
	[self observeNotification:UIApplicationWillEnterForegroundNotification];
}

- (void)unload
{	
	[self unobserveAllNotifications];

	[_stacks removeAllObjects];
	[_stacks release];
	
	[super unload];
}

- (BeeUIStack *)reflect:(NSString *)name
{
	for ( BeeUIStack * nav in _stacks )
	{
		if ( [nav.name isEqualToString:name] )
		{
			return nav;
		}
	}
	
	return nil;
}

- (void)append:(BeeUIStack *)nav
{
	if ( nil == nav )
		return;
	
	if ( NO == [_stacks containsObject:nav] )
	{
		[_stacks addObject:nav];
		[self.view addSubview:nav.view];
		[self present:nav];
	}
}

- (void)remove:(BeeUIStack *)nav
{
	if ( nil == nav )
		return;
	
	if ( YES == [_stacks containsObject:nav] )
	{
		if ( [nav isViewLoaded] )
		{
			[nav.view removeFromSuperview];			
		}
		
		[_stacks removeObject:nav];
	}	
}

- (NSInteger)topIndex
{
	return _index;
}

- (BeeUIStack *)topStack
{
	if ( _stacks.count )
	{
		return (BeeUIStack *)[_stacks objectAtIndex:0];
	}
	else
	{
		return nil;
	}
}

- (void)present:(BeeUIStack *)nav
{
	if ( nil == nav )
		return;
	
	if ( 0 == _stacks.count || NO == [_stacks containsObject:nav] )
		return;

	BeeUIStack * top = nil;
	if ( _index >= 0 )
	{
		top = [_stacks objectAtIndex:_index];
		if ( top == nav )
			return;

		[top viewWillDisappear:NO];
		[top viewDidDisappear:NO];
	}

	for ( BeeUIStack * stack in _stacks )
	{
		if ( stack != nav )
		{
			[stack.view setHidden:YES];
		}
	}

	_index = [_stacks indexOfObject:nav];
	_index = (_index >= _stacks.count) ? (_stacks.count - 1) : _index;
		
	[self.view bringSubviewToFront:nav.view];

	[nav.view setHidden:NO];	
	[nav viewWillAppear:NO];
	[nav viewDidAppear:NO];
	
	[self sendUISignal:BeeUIStackGroup.INDEX_CHANGED];
}

- (void)handleNotification:(NSNotification *)notification
{
	if ( [notification is:UIApplicationDidEnterBackgroundNotification] )
	{
		for ( BeeUIStack * nav in _stacks )
		{
			[nav __enterBackground];
		}
	}
	else if ( [notification is:UIApplicationWillEnterForegroundNotification] )
	{
		for ( BeeUIStack * nav in _stacks )
		{
			[nav __enterForeground];
		}
	}
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	if ( signal.source != self )
	{
		BeeUIStack * stack = self.topStack;
		if ( stack )
		{
			[signal forward:stack];
		}
	}
	else
	{
		[super handleUISignal:signal];
		
		if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
		{
			if ( [signal is:BeeUIBoard.WILL_APPEAR] )
			{
				for ( BeeUIStack * stack in _stacks )
				{
					[stack viewWillAppear:NO];
				}
			}
			else if ( [signal is:BeeUIBoard.DID_APPEAR] )
			{
				for ( BeeUIStack * stack in _stacks )
				{
					[stack viewDidAppear:NO];
				}
			}
			else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
			{
				for ( BeeUIStack * stack in _stacks )
				{
					[stack viewWillDisappear:NO];
				}
			}
			else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
			{
				for ( BeeUIStack * stack in _stacks )
				{
					[stack viewDidDisappear:NO];
				}
			}
		}
	}
}

@end
