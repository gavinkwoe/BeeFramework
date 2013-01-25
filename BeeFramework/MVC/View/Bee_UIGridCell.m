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
//  Bee_UIGridCell.m
//

#import "Bee_Precompile.h"
#import "Bee_UISignal.h"
#import "Bee_UIGridCell.h"
#import "UIView+BeeExtension.h"

#pragma mark -

@implementation NSObject(BeeUILayout)

+ (CGSize)sizeInBound:(CGSize)bound forData:(NSObject *)data
{
	return bound;
}

- (void)layoutInBound:(CGSize)bound forCell:(BeeUIGridCell *)cell
{
}

@end

#pragma mark -

@interface BeeUIGridCell(Private)
- (void)initSelf;
@end

@implementation BeeUIGridCell

@dynamic cellData;
@dynamic cellLayout;

@dynamic childCells;
@dynamic superCell;

- (void)initSelf
{
	self.backgroundColor = [UIColor clearColor];
	self.alpha = 1.0f;
	self.layer.masksToBounds = YES;
	self.layer.opaque = YES;

	_cellData = nil;
	_cellLayout = self;
}

- (id)init
{
	self = [super initWithFrame:CGRectZero];
	if ( self )
	{
		[self initSelf];
		[self load];
	}
	return self;	
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		[self initSelf];
		[self load];

		[self setNeedsLayout];
	}
	return self;
}

- (void)dealloc
{
	[self unload];

	[_cellData release];

	[super dealloc];
}

- (void)load
{
}

- (void)unload
{	
}

- (NSArray *)childCells
{
	NSMutableArray * array = [NSMutableArray array];
	
	for ( UIView * subview in self.subviews )
	{
		if ( [subview isKindOfClass:[BeeUIGridCell class]] )
		{
			[array addObject:subview];
		}
	}

	return array;
}

- (BeeUIGridCell *)superCell
{
	if ( [self.superview isKindOfClass:[BeeUIGridCell class]] )
	{
		return (BeeUIGridCell *)self.superview;
	}
	else
	{
		return nil;
	}
}

- (void)setFrame:(CGRect)rc
{
	if ( NO == CGSizeEqualToSize(rc.size, self.frame.size) )
	{
		[super setFrame:rc];

		[self layoutSubcells];
	}
	else
	{
		[super setFrame:rc];
	}
}

- (void)setCenter:(CGPoint)pt
{
	if ( NO == CGPointEqualToPoint(pt, self.center) )
	{
		[super setCenter:pt];
		
		[self layoutSubcells];
	}
	else
	{
		[super setCenter:pt];
	}
}

- (void)layoutSubcells
{
	if ( CGSizeEqualToSize(self.bounds.size, CGSizeZero) )
		return;

	[self layoutWillBegin];

	if ( _cellLayout && [_cellLayout respondsToSelector:@selector(layoutInBound:forCell:)] )
	{
		[_cellLayout layoutInBound:self.bounds.size forCell:self];
//		[_cellLayout cellLayout:self bound:self.bounds.size];
	}

	for ( UIView * subview in self.subviews )
	{
		if ( [subview isKindOfClass:[BeeUIGridCell class]] )
		{
			[(BeeUIGridCell *)subview layoutSubcells];
		}
	}

	[self layoutDidFinish];
}

- (NSObject *)cellData
{
	return _cellData;
}

- (void)setCellData:(NSObject *)data
{
	[self dataWillChange];

	if ( _cellData != data )
	{
		[_cellData release];
		_cellData = [data retain];
	}

	[self dataDidChanged];

	if ( _cellLayout )
	{
		[self layoutSubcells];
	}
}

- (NSObject *)cellLayout
{
	return _cellLayout;
}

- (void)setCellLayout:(NSObject *)layout
{
	if ( _cellLayout != layout )
	{
		_cellLayout = layout;

		if ( _cellLayout )
		{
			[self layoutSubcells];
		}
	}
}

- (void)dataWillChange
{
}

- (void)dataDidChanged
{
}

- (void)layoutWillBegin
{
}

- (void)layoutDidFinish
{
}

@end
