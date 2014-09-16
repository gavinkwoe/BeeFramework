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

#import "Bee_UISegmentedControl.h"
#import "UIView+BeeUISignal.h"
#import "UIView+LifeCycle.h"

#pragma mark -

@interface BeeUISegmentedControl()
{
	BOOL				_inited;
	NSMutableArray *	_binding;
}

- (void)initSelf;
- (void)didSelectionChanged:(id)sender;

@end

#pragma mark -

@implementation BeeUISegmentedControl

IS_CONTAINABLE( YES )

DEF_SIGNAL( HIGHLIGHT_CHANGED )

@synthesize selectedTag;

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		[self initSelf];
		[self setFrame:frame];
	}
	return self;
}

- (id)initWithItems:(NSArray *)items
{
	self = [super initWithItems:items];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (void)initSelf
{
	if ( NO == _inited )
	{
		self.backgroundColor = [UIColor clearColor];

		self.momentary = NO;
		self.segmentedControlStyle = UISegmentedControlStyleBar;
		self.selectedSegmentIndex = 0;

		[self addTarget:self action:@selector(didSelectionChanged:) forControlEvents:UIControlEventValueChanged];

		_binding = [[NSMutableArray alloc] init];
		_inited = YES;

//		[self load];
		[self performLoad];
	}
}

- (void)dealloc
{
//	[self unload];
	[self performUnload];

	[_binding removeAllObjects];
	[_binding release];

	[super dealloc];
}

- (NSInteger)selectedTag
{
	if ( self.selectedSegmentIndex < _binding.count )
	{
		NSDictionary * dict = [_binding objectAtIndex:self.selectedSegmentIndex];
		if ( dict )
		{
			NSNumber * tag = [dict objectForKey:@"tag"];
			if ( tag )
			{
				return tag.intValue;
			}
		}
	}

	return -1;
}

- (void)setSelectedTag:(NSInteger)tag
{
	for ( NSDictionary * dict in _binding )
	{
		NSNumber * tagNumber = [dict objectForKey:@"tag"];
		if ( [tagNumber intValue] == tag )
		{
			self.selectedSegmentIndex = [_binding indexOfObject:dict];
			break;
		}
	}
}

- (void)addTitle:(NSString *)title
{
	[self addTitle:title tag:(-1) signal:nil];
}

- (void)addTitle:(NSString *)title tag:(NSInteger)tag
{
	[self addTitle:title tag:tag signal:nil];
}

- (void)addTitle:(NSString *)title signal:(NSString *)signal
{
	[self addTitle:title tag:(-1) signal:signal];
}

- (void)addTitle:(NSString *)title tag:(NSInteger)tag signal:(NSString *)signal
{
	if ( tag < 0 )
	{
		tag = _binding.count;
	}

	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	[dict setObject:[NSNumber numberWithInt:tag] forKey:@"tag"];

	if ( signal )
	{
		[dict setObject:signal forKey:@"signal"];
	}

	[_binding addObject:dict];

	[self insertSegmentWithTitle:title atIndex:self.numberOfSegments animated:NO];
}

- (void)addImage:(UIImage *)image
{
	[self addImage:image tag:(-1) signal:nil];
}

- (void)addImage:(UIImage *)image tag:(NSInteger)tag
{
	[self addImage:image tag:tag signal:nil];
}

- (void)addImage:(UIImage *)image signal:(NSString *)signal
{
	[self addImage:image tag:(-1) signal:signal];
}

- (void)addImage:(UIImage *)image tag:(NSInteger)tag signal:(NSString *)signal
{
	if ( tag < 0 )
	{
		tag = _binding.count;
	}

	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	[dict setObject:[NSNumber numberWithInt:tag] forKey:@"tag"];
	
	if ( signal )
	{
		[dict setObject:signal forKey:@"signal"];
	}

	[_binding addObject:dict];

	[self insertSegmentWithImage:image atIndex:self.numberOfSegments animated:NO];
}

- (void)didSelectionChanged:(id)sender
{
	if ( self.selectedSegmentIndex < _binding.count )
	{
		NSDictionary * dict = [_binding objectAtIndex:self.selectedSegmentIndex];
		if ( dict )
		{
			NSNumber * tagNumber = [dict objectForKey:@"tag"];
			NSString * signalName = [dict objectForKey:@"signal"];

			if ( signalName )
			{
				[self sendUISignal:signalName withObject:tagNumber];
			}
			else
			{
				[self sendUISignal:BeeUISegmentedControl.HIGHLIGHT_CHANGED withObject:tagNumber];
			}
		}
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
