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
//  Bee_UISegmentedControl.m
//

#import "Bee_UISegmentedControl.h"
#import "Bee_UISignal.h"

#pragma mark -

@interface BeeUISegmentedControl(Private)
- (void)initSelf;
- (void)didSelectionChanged:(id)sender;
@end

#pragma mark -

@implementation BeeUISegmentedControl

DEF_SIGNAL( HIGHLIGHT_CHANGED )

@synthesize selectedTag;

+ (BeeUISegmentedControl *)spawn
{
	return [[[BeeUISegmentedControl alloc] initWithItems:[NSArray array]] autorelease];
}

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
	self.backgroundColor = [UIColor clearColor];
	self.momentary = NO;
	self.segmentedControlStyle = UISegmentedControlStyleBar;
	self.selectedSegmentIndex = 0;
//	self.tintColor = [UIColor darkGrayColor];

	_tags = [[NSMutableArray alloc] init];
	
	[self addTarget:self action:@selector(didSelectionChanged:) forControlEvents:UIControlEventValueChanged];	
}

- (void)dealloc
{
	[_tags removeAllObjects];
	[_tags release];

	[super dealloc];
}

- (NSInteger)selectedTag
{
	if ( self.selectedSegmentIndex < _tags.count )
	{
		return ((NSNumber *)[_tags objectAtIndex:self.selectedSegmentIndex]).intValue;
	}
	else
	{
		return -1;
	}
}

- (void)setSelectedTag:(NSInteger)tag
{
	for ( NSNumber * number in _tags )
	{
		if ( [number intValue] == tag )
		{
			self.selectedSegmentIndex = [_tags indexOfObject:number];
			break;
		}
	}
}

- (void)addTitle:(NSString *)title
{
	[self addTitle:title tag:-1];
}

- (void)addTitle:(NSString *)title tag:(NSInteger)tag
{
	if ( tag < 0 )
	{
		tag = _tags.count;
	}

	[_tags addObject:[NSNumber numberWithInt:tag]];

	[self insertSegmentWithTitle:title atIndex:self.numberOfSegments animated:NO];
}

- (void)addImage:(UIImage *)image
{
	[self addImage:image tag:-1];
}

- (void)addImage:(UIImage *)image tag:(NSInteger)tag
{
	if ( tag < 0 )
	{
		tag = _tags.count;
	}

	[_tags addObject:[NSNumber numberWithInt:tag]];

	[self insertSegmentWithImage:image atIndex:self.numberOfSegments animated:NO];
}

- (void)didSelectionChanged:(id)sender
{
	if ( self.selectedSegmentIndex < [_tags count] )
	{
		NSNumber * tag = [_tags objectAtIndex:self.selectedSegmentIndex];
		[self sendUISignal:BeeUISegmentedControl.HIGHLIGHT_CHANGED withObject:tag];
	}
}

@end
