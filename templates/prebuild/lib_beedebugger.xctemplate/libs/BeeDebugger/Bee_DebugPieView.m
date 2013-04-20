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
//  Bee_DebugPieView.m
//

#import "Bee_Precompile.h"
#import "Bee.h"

#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

#import "Bee_DebugPieView.h"

#pragma mark -

static inline float radians(double degrees) { return degrees * M_PI / 180; }

@implementation BeeDebugPieView

@synthesize datas = _datas;
@synthesize colors = _colors;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

- (void)dealloc
{
	[_datas release];
	[_colors release];
	
	[super dealloc];
}

- (CGPoint)center:(CGPoint)center angle:(CGFloat)angle radius:(CGFloat)radius
{
	CGFloat radian = (M_PI / 180.0f) * angle;
	CGPoint point;
	CGFloat	cos = cosf( radian );
	CGFloat	sin = sinf( radian );
	
	point.x = center.x + radius * cos;
	point.y = center.y + radius * sin;
	
	return point;
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];

	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{		
		CGRect fillRect;
		fillRect.origin = CGPointZero;
		fillRect.size = self.bounds.size;

		CGContextClearRect( context, fillRect );
		
		CGPoint center;
		center.x = fillRect.size.width / 2.0f;
		center.y = fillRect.size.height / 2.0f;
		
		CGFloat startAngle = 0.0f;
		CGFloat radius = fillRect.size.width / 2.0f;
		
		for ( NSUInteger i = 0; i < [_datas count]; ++i )
		{
			NSNumber * value = [_datas objectAtIndex:i];
			UIColor * color = _colors ? [_colors objectAtIndex:i] : [UIColor whiteColor];

			CGFloat endAngle = startAngle + [value floatValue] * 360.0f;
			
			CGContextMoveToPoint( context, center.x, center.y );
			CGContextAddArc( context, center.x, center.y, radius, radians(startAngle), radians(endAngle), 0); 
			CGContextClosePath( context ); 
			
			CGContextSetFillColorWithColor( context, color.CGColor );
			CGContextFillPath( context ); 
			
			startAngle = endAngle;
		}
	}
}

@end

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__
