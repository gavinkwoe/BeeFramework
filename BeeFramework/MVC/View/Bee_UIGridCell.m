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

#import <QuartzCore/QuartzCore.h>
#import "Bee_UIGridCell.h"
#import "Bee_UISignal.h"

#pragma mark -

@implementation NSObject(BeeUIGridCell)

+ (CGSize)cellSize:(NSObject *)data bound:(CGSize)bound
{
	return bound;
}

- (void)cellLayout:(BeeUIGridCell *)cell bound:(CGSize)bound
{
	
}

@end

#pragma mark -

@interface BeeUIGridCell(Private)
- (void)initSelf;
@end

@implementation BeeUIGridCell

@synthesize autoLayout = _autoLayout;
@synthesize cellData = _cellData;
@synthesize category = _category;
@synthesize layout = _layout;
@synthesize subCells = _subCells;
@synthesize zoomsTouchWhenHighlighted = _zoomsTouchWhenHighlighted;

+ (BeeUIGridCell *)spawn
{
	return [[[BeeUIGridCell alloc] init] autorelease];
}

- (id)init
{
	self = [super init]; // will call initWithFrame
	if ( self )
	{
//		[self initSelf];
//		[self load];
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
	}
	return self;
}

- (void)initSelf
{
	self.backgroundColor = [UIColor clearColor];
	self.alpha = 1.0f;
	self.layer.masksToBounds = YES;
	self.layer.opaque = YES;
	
	_layout = self;
	_autoLayout = YES;
	_subCells = [[NSMutableArray alloc] init];
	_zoomsTouchWhenHighlighted = NO;
}

- (void)load
{
}

- (void)unload
{	
}

- (BeeUIGridCell *)supercell
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

- (NSString *)description
{
	return _category ? _category : @"unknown";
}

- (NSMutableArray *)subCellsIncludeCategory:(NSString *)cate
{
	if ( 0 == [_subCells count] )
	{
		return nil;
	}
	else
	{
		NSMutableArray * array = [[NSMutableArray alloc] init];
		for ( BeeUIGridCell * cell in _subCells )
		{
			if ( YES == [cell.category isEqualToString:cate] )
			{
				[array addObject:cell];
			}
		}
		return [array autorelease];
	}
}

- (NSMutableArray *)subCellsExcludeCategory:(NSString *)cate
{
	if ( 0 == [_subCells count] )
	{
		return nil;
	}
	else
	{
		NSMutableArray * array = [[NSMutableArray alloc] init];
		for ( BeeUIGridCell * cell in _subCells )
		{
			if ( NO == [cell.category isEqualToString:cate] )
			{
				[array addObject:cell];
			}
		}
		return [array autorelease];
	}
}

- (void)addSubcell:(BeeUIGridCell *)cell
{
	if ( NO == [_subCells containsObject:cell] )
	{
		[_subCells addObject:cell];
		[self addSubview:cell];
	}
}

- (void)removeSubcell:(BeeUIGridCell *)cell
{
	if ( YES == [_subCells containsObject:cell] )
	{
		[_subCells removeObject:cell];
		[cell removeFromSuperview];
		[cell release];
	}
}

- (void)removeAllSubcells
{
	for ( BeeUIGridCell * cell in _subCells )
	{
		[cell removeFromSuperview];
	}

	[_subCells removeAllObjects];
}

- (void)setFrame:(CGRect)rc
{
	if ( NO == CGSizeEqualToSize(rc.size, self.frame.size) )
	{
		[super setFrame:rc];

		if ( _autoLayout )
		{
			[self layoutAllSubcells];			
		}
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
		
		if ( _autoLayout )
		{
			[self layoutAllSubcells];
		}
	}
	else
	{
		[super setCenter:pt];
	}
}

- (void)layoutAllSubcells
{
	if ( CGSizeEqualToSize(self.bounds.size, CGSizeZero) )
		return;
	
	if ( _layout && [_layout respondsToSelector:@selector(cellLayout:bound:)] )
	{
		[_layout cellLayout:self bound:self.bounds.size];
	}

	for ( BeeUIGridCell * cell in _subCells )
	{
		if ( cell && [cell respondsToSelector:@selector(layoutAllSubcells)] )
		{
			[cell layoutAllSubcells];
		}
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	
	if ( _zoomsTouchWhenHighlighted )
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.1f];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationBeginsFromCurrentState:YES];
		
		CATransform3D transform = CATransform3DIdentity;
		transform.m34 = -(1.0f / 2500.0f);
		transform = CATransform3DTranslate( transform, 0.0f, 0.0f, -250.0f );
		self.layer.transform = transform;
		
		[UIView commitAnimations];		
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	
	if ( _zoomsTouchWhenHighlighted )
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.1f];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationBeginsFromCurrentState:YES];
		
		self.layer.transform = CATransform3DIdentity;
		
		[UIView commitAnimations];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];
	
	if ( _zoomsTouchWhenHighlighted )
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.1f];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationBeginsFromCurrentState:YES];
		
		self.layer.transform = CATransform3DIdentity;
		
		[UIView commitAnimations];
	}
}

- (void)clearData
{
	
}

- (void)bindData:(NSObject *)data
{
	if ( nil == data )
		return;
	
//	if ( data != self.cellData )
//	{
		self.cellData = data;

		[self layoutAllSubcells];		
//	}
}

- (BeeUIGridCell *)hitTestSubCells:(CGPoint)point
{
	for ( BeeUIGridCell * cell in _subCells )
	{
		if ( CGRectContainsPoint(cell.frame, point) )
		{
			return cell;
		}
	}
	
	return nil;
}

- (void)beginLayout
{
	_autoLayout = NO;
}

- (void)commitLayout
{
	_autoLayout = YES;
	
	[self layoutAllSubcells];
}

- (void)dealloc
{
	[self unload];
	[self removeAllSubcells];
	
	[_cellData release];
	[_category release];
	[_subCells release];
	[_layout release];

	[super dealloc];
}

@end
