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

#import "Bee_UITabBar.h"
#import "Bee_UISignal.h"

#pragma mark -

@interface BeeUITabBar(Private)
- (void)initSelf;
@end

#pragma mark -

@implementation BeeUITabBar

DEF_SIGNAL( HIGHLIGHT_CHANGED )

@synthesize selectedIndex;

+ (BeeUITabBar *)spawn
{
	return [[[BeeUITabBar alloc] initWithFrame:CGRectZero] autorelease];
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

- (void)initSelf
{
	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];
	self.delegate = self;
	self.items = [NSArray array];
	self.selectedItem = nil;
	
	_barItems = [[NSMutableArray alloc] init];
}

- (void)dealloc
{
	[_barItems removeAllObjects];
	[_barItems release];
	
    [super dealloc];
}

- (void)hilite:(NSInteger)tag
{
	for ( UITabBarItem * item in _barItems )
	{
		if ( item.tag == tag )
		{
			self.selectedItem = item;
			break;
		}
	}
}

- (void)addTitle:(NSString *)title
{
	[self addTitle:title image:nil tag:_barItems.count];
}

- (void)addTitle:(NSString *)title tag:(NSInteger)tag;
{
	[self addTitle:title image:nil tag:tag];
}

- (void)addImage:(UIImage *)image
{
	[self addTitle:nil image:image tag:_barItems.count];
}

- (void)addImage:(UIImage *)image tag:(NSInteger)tag
{
	[self addTitle:nil image:image tag:tag];
}

- (void)addTitle:(NSString *)title image:(UIImage *)image
{
	[self addTitle:title image:image tag:_barItems.count];
}

- (void)addTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag
{
	UITabBarItem * item = [[[UITabBarItem alloc] initWithTitle:title image:image tag:tag] autorelease];
	[_barItems addObject:item];
	[self setItems:_barItems animated:NO];
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

#pragma mark -

// called when a new view is selected by the user (but not programatically)
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	[self sendUISignal:BeeUITabBar.HIGHLIGHT_CHANGED
			withObject:[NSNumber numberWithInt:item.tag]];
}

@end
