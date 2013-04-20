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
//  Bee_UITabBar.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UITabBar.h"
#import "Bee_UISignal.h"
#import "UIView+BeeExtension.h"
#import "UIView+BeeUISignal.h"

#pragma mark -

@interface BeeUITabBar(Private)
- (void)initSelf;
@end

#pragma mark -

@implementation BeeUITabBar

DEF_SIGNAL( HIGHLIGHT_CHANGED )

@dynamic selectedIndex;
@dynamic selectedTag;

+ (BeeUITabBar *)spawn
{
	return [[[BeeUITabBar alloc] initWithFrame:CGRectZero] autorelease];
}

+ (BeeUITabBar *)spawn:(NSString *)tagString
{
	BeeUITabBar * view = [[[BeeUITabBar alloc] init] autorelease];
	view.tagString = tagString;
	return view;
}

- (id)init
{
    if( (self = [super initWithFrame:CGRectZero]) )
    {
		[self initSelf];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self initSelf];
    }
    return self;
}

// thanks to @ilikeido
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (void)initSelf
{
	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];
	self.delegate = self;
	self.items = [NSArray array];
	self.selectedItem = nil;
	
    [_barItems release];
	_barItems = [[NSMutableArray alloc] init];
	_barSignals = [[NSMutableDictionary alloc] init];
}

- (void)dealloc
{
	[_barSignals removeAllObjects];
	[_barSignals release];
	
	[_barItems removeAllObjects];
	[_barItems release];
	
    [super dealloc];
}

- (void)hilite:(NSInteger)tag
{
	[self setSelectedTag:tag];
}

- (void)addTitle:(NSString *)title
{
	[self addTitle:title image:nil tag:_barItems.count];
}

- (void)addTitle:(NSString *)title tag:(NSInteger)tag;
{
	[self addTitle:title image:nil tag:tag];
}

- (void)addTitle:(NSString *)title tag:(NSInteger)tag signal:(NSString *)signal
{
	[self addTitle:title image:nil tag:tag signal:signal];
}

- (void)addImage:(UIImage *)image
{
	[self addTitle:nil image:image tag:_barItems.count];
}

- (void)addImage:(UIImage *)image tag:(NSInteger)tag
{
	[self addTitle:nil image:image tag:tag];
}

- (void)addImage:(UIImage *)image tag:(NSInteger)tag signal:(NSString *)signal
{
	[self addTitle:nil image:image tag:tag signal:signal];
}

- (void)addTitle:(NSString *)title image:(UIImage *)image
{
	[self addTitle:title image:image tag:_barItems.count];
}

- (void)addTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag
{
	[self addTitle:title image:image tag:tag signal:nil];
}

- (void)addTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag signal:(NSString *)signal
{
	UITabBarItem * item = [[[UITabBarItem alloc] initWithTitle:title image:image tag:tag] autorelease];
	if ( item )
	{
		[_barItems addObject:item];
		[self setItems:_barItems animated:NO];
		
		if ( signal )
		{
			[_barSignals setObject:signal forKey:[NSString stringWithFormat:@"%p", item]];
		}
	}
}

- (NSInteger)selectedIndex
{
	for ( NSObject * obj in self.items )
	{
		if ( obj == self.selectedItem )
		{
			return [self.items indexOfObject:obj];
		}
	}
	
	return -1;
}

- (void)setSelectedIndex:(NSInteger)index
{
	if ( index < _barItems.count )
	{
		UITabBarItem * item = [_barItems objectAtIndex:index];

		[self setSelectedItem:item];
		[self tabBar:self didSelectItem:item];
	}
	else
	{
		[self setSelectedItem:nil];
//		[self tabBar:self didSelectItem:item];
	}
}

- (NSInteger)selectedTag
{
	return self.selectedItem.tag;
}

- (void)setSelectedTag:(NSInteger)tag
{
	for ( UITabBarItem * item in _barItems )
	{
		if ( item.tag == tag )
		{
			[self setSelectedItem:item];
			[self tabBar:self didSelectItem:item];
			break;
		}
	}
}

#pragma mark -

// called when a new view is selected by the user (but not programatically)
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	NSString * key = [NSString stringWithFormat:@"%p", item];
	NSString * signal = [_barSignals objectForKey:key];
	if ( signal )
	{
		[self sendUISignal:signal
				withObject:[NSNumber numberWithInt:item.tag]];		
	}
	else
	{
		[self sendUISignal:BeeUITabBar.HIGHLIGHT_CHANGED
				withObject:[NSNumber numberWithInt:item.tag]];	
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
