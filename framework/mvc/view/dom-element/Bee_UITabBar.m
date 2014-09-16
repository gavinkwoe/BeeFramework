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

#import "Bee_UITabBar.h"
#import "UIView+BeeUISignal.h"
#import "UIView+LifeCycle.h"

#pragma mark -

#undef	KEY_NAME
#define KEY_NAME	"UITabBarItem.name"

#undef	KEY_SIGNAL
#define KEY_SIGNAL	"UITabBarItem.signal"

#pragma mark -

@interface UITabBarItem(BeeExtension)
@property (nonatomic, retain) NSString *	name;
@property (nonatomic, retain) NSString *	signal;
@end

#pragma mark -

@implementation UITabBarItem(BeeExtension)

IS_CONTAINABLE( YES )

@dynamic name;
@dynamic signal;

- (NSString *)name
{
	return objc_getAssociatedObject( self, KEY_NAME );
}

- (void)setName:(NSString *)value
{
	objc_setAssociatedObject( self, KEY_NAME, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (NSString *)signal
{
	return objc_getAssociatedObject( self, KEY_SIGNAL );
}

- (void)setSignal:(NSString *)value
{
	objc_setAssociatedObject( self, KEY_SIGNAL, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

@end

#pragma mark -

@interface BeeUITabBar()
{
	BOOL	_inited;
}

- (void)initSelf;

@end

#pragma mark -

@implementation BeeUITabBar

DEF_SIGNAL( HIGHLIGHT_CHANGED )

@dynamic selectedIndex;
@dynamic selectedName;
@dynamic backgroundImage;

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
	if ( _inited )
	{
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;
		self.items = [NSArray array];
		self.selectedItem = nil;

	#if defined(__IPHONE_5_0)
		if ( IOS5_OR_LATER )
		{
			self.tintColor = [UIColor clearColor];
		}

		self.selectedImageTintColor = [UIColor clearColor];
		self.selectionIndicatorImage = nil;
		self.backgroundImage = nil;
	#endif	// #if defined(__IPHONE_5_0)
		
	#if defined(__IPHONE_6_0)
		self.shadowImage = nil;
	#endif	// #if defined(__IPHONE_6_0)
		
		_inited = YES;

//		[self load];
		[self performLoad];
	}
}

- (void)dealloc
{
//	[self unload];
	[self performUnload];

    [super dealloc];
}

- (UIImage *)backgroundImage
{
	return [UIImage imageWithCGImage:(CGImageRef)self.layer.contents];
}

- (void)setBackgroundImage:(UIImage *)image
{
	if ( nil == image )
	{
		self.layer.contents = nil;
	}
	else
	{
		self.layer.contents = (id)image.CGImage;
	}
}

#pragma mark -

- (void)addTitle:(NSString *)title
{
	[self addTitle:title image:nil name:nil signal:nil];
}

- (void)addTitle:(NSString *)title signal:(NSString *)signal
{
	[self addTitle:title image:nil name:nil signal:signal];
}

- (void)addTitle:(NSString *)title name:(NSString *)name
{
	[self addTitle:title image:nil name:name signal:nil];
}

- (void)addTitle:(NSString *)title name:(NSString *)name signal:(NSString *)signal
{
	[self addTitle:title image:nil name:name signal:signal];
}

#pragma mark -

- (void)addImage:(UIImage *)image
{
	[self addTitle:nil image:image name:nil signal:nil];
}

- (void)addImage:(UIImage *)image signal:(NSString *)signal
{
	[self addTitle:nil image:image name:nil signal:signal];
}

- (void)addImage:(UIImage *)image name:(NSString *)name
{
	[self addTitle:nil image:image name:name signal:nil];
}

- (void)addImage:(UIImage *)image name:(NSString *)name signal:(NSString *)signal
{
	[self addTitle:nil image:image name:name signal:signal];
}

#pragma mark -

- (void)addTitle:(NSString *)title image:(UIImage *)image
{
	[self addTitle:title image:image name:nil signal:nil];
}

- (void)addTitle:(NSString *)title image:(UIImage *)image signal:(NSString *)signal
{
	[self addTitle:title image:image name:nil signal:nil];
}

- (void)addTitle:(NSString *)title image:(UIImage *)image name:(NSString *)name
{
	[self addTitle:title image:image name:name signal:nil];
}

- (void)addTitle:(NSString *)title image:(UIImage *)image name:(NSString *)name signal:(NSString *)signal
{
	UITabBarItem * item = [[[UITabBarItem alloc] initWithTitle:title image:image tag:self.items.count] autorelease];
	if ( item )
	{
		item.name = name;
		item.signal = signal;

		NSMutableArray * array = [NSMutableArray arrayWithArray:self.items];
		[array addObject:item];

		[self setItems:array animated:NO];
	}
}

#pragma mark -

- (void)setImage:(UIImage *)image name:(NSString *)name
{
	for ( UITabBarItem * item in self.items )
	{
		if ( [item.name isEqualToString:name] )
		{
			item.image = image;
			break;
		}
	}
}

- (void)setTitle:(NSString *)title name:(NSString *)name
{
	for ( UITabBarItem * item in self.items )
	{
		if ( [item.name isEqualToString:name] )
		{
			item.title = title;
			break;
		}
	}
}

- (void)setTitle:(NSString *)title image:(UIImage *)image name:(NSString *)name
{
	for ( UITabBarItem * item in self.items )
	{
		if ( [item.name isEqualToString:name] )
		{
			item.title = title;
			item.image = image;
			break;
		}
	}	
}

#pragma mark -

- (NSInteger)selectedIndex
{
	for ( UITabBarItem * item in self.items )
	{
		if ( item == self.selectedItem )
		{
			return [self.items indexOfObject:item];
		}
	}

	return -1;
}

- (void)setSelectedIndex:(NSInteger)index
{
	if ( index < self.items.count )
	{
		UITabBarItem * item = [self.items objectAtIndex:index];
		if ( item )
		{
			[self setSelectedItem:item];
			[self tabBar:self didSelectItem:item];
		}
	}
	else
	{
		[self setSelectedItem:nil];
//		[self tabBar:self didSelectItem:item];
	}
}

- (NSString *)selectedName
{
	for ( UITabBarItem * item in self.items )
	{
		if ( item == self.selectedItem )
		{
			return item.name;
		}
	}
	
	return nil;
}

- (void)setSelectedName:(NSString *)name
{
	for ( UITabBarItem * item in self.items )
	{
		if ( [item.name isEqualToString:name] )
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
	if ( item.signal && item.signal.length )
	{
		[self sendUISignal:item.signal withObject:item.name];
	}
	else
	{
		[self sendUISignal:BeeUITabBar.HIGHLIGHT_CHANGED withObject:item.name];
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
