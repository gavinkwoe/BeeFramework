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
//  Bee_DebugPlotsView.m
//

#import "Bee_Precompile.h"
#import "Bee.h"

#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

#import "Bee_DebugPlotsView.h"

#pragma mark -

@implementation BeeDebugPlotsView

@synthesize fill = _fill;
@synthesize border = _border;
@synthesize lineScale = _lineScale;
@synthesize lineColor = _lineColor;
@synthesize lineWidth = _lineWidth;
@synthesize lowerBound = _lowerBound;
@synthesize upperBound = _upperBound;
@synthesize capacity = _capacity;
@synthesize plots = _plots;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.backgroundColor = [UIColor clearColor];
		
		self.fill = YES;
		self.border = YES;
		self.lineScale = 0.8f;
		self.lineColor = [UIColor whiteColor];
		self.lineWidth = 1.0f;
		self.lowerBound = 0.0f;
		self.upperBound = 1.0f;
		self.capacity = 50;
	}
	return self;
}

- (void)dealloc
{
	[_lineColor release];
	[_plots release];
	
	[super dealloc];
}

- (void)drawRect:(CGRect)rect
{	
	[super drawRect:rect];

	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextClearRect( context, self.bounds );
		
		if ( self.fill )
		{
			CGRect bound = CGRectInset( self.bounds, 4.0f, 2.0f );		
			CGPoint baseLine;
			baseLine.x = bound.origin.x;
			baseLine.y = bound.origin.y + bound.size.height;

			UIBezierPath * pathLines = [UIBezierPath bezierPath];
			[pathLines moveToPoint:baseLine];

			NSUInteger step = 0;
			
			for ( NSNumber * value in _plots )
			{
				CGFloat v = value.floatValue;
				
				if ( v < _lowerBound )
				{
					v = _lowerBound;
				}
				else if ( v > _upperBound )
				{
					v = _upperBound;
				}
				
				CGFloat f = (v - _lowerBound) / (_upperBound - _lowerBound) * _lineScale;
				CGPoint p = CGPointMake( baseLine.x, baseLine.y - bound.size.height * f );
				[pathLines addLineToPoint:p];
				
				baseLine.x += bound.size.width / _capacity;
				
				step += 1;
				if ( step >= _capacity )
					break;
			}
			
			[self.lineColor set];
			
			[pathLines addLineToPoint:baseLine];
	//		[pathLines fill];
			[pathLines fillWithBlendMode:kCGBlendModeXOR alpha:0.6f];
		}

		if ( self.border )
		{
			CGRect bound = CGRectInset( self.bounds, 4.0f, 2.0f );		
			CGPoint baseLine;
			baseLine.x = bound.origin.x;
			baseLine.y = bound.origin.y + bound.size.height;

			CGContextMoveToPoint( context, baseLine.x, baseLine.y );
			
			NSUInteger step = 0;
			
			for ( NSNumber * value in _plots )
			{
				CGFloat v = value.floatValue;
				
				if ( v < _lowerBound )
				{
					v = _lowerBound;
				}
				else if ( v > _upperBound )
				{
					v = _upperBound;
				}
				
				CGFloat f = (v - _lowerBound) / (_upperBound - _lowerBound) * _lineScale;
				CGPoint p = CGPointMake( baseLine.x, baseLine.y - bound.size.height * f );
				
				CGContextAddLineToPoint( context, p.x, p.y );
				
				CGContextSetStrokeColorWithColor( context, self.lineColor.CGColor );
				CGContextSetLineWidth( context, self.lineWidth );
				CGContextSetLineCap( context, kCGLineCapRound );
				CGContextSetLineJoin( context, kCGLineJoinRound );
				
				//			float lengths[] = { 3, 3 };  
				//			CGContextSetLineDash( context, 0, lengths, 2 ); 
				
				CGContextStrokePath( context );			
				CGContextMoveToPoint( context, p.x, p.y );
				
				baseLine.x += bound.size.width / _capacity;
				
				step += 1;
				if ( step >= _capacity )
					break;
			}
		}
	}
}

@end

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__
