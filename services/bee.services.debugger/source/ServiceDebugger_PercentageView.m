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

#import "ServiceDebugger_PercentageView.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@interface ServiceDebugger_PercentageView()
{
	BOOL		_fill;
	BOOL		_border;
	UIColor *	_textColor;
	UIColor *	_borderColor;
	UIColor *	_fillColor;
	CGFloat		_percent;
	NSString *	_name;
	NSString *	_value;
}
@end

#pragma mark -

@implementation ServiceDebugger_PercentageView

@synthesize fill = _fill;
@synthesize border = _border;
@synthesize textColor = _textColor;
@synthesize borderColor = _borderColor;
@synthesize fillColor = _fillColor;
@synthesize percent = _percent;
@synthesize name = _name;
@synthesize value = _value;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.backgroundColor = [UIColor blackColor];
		
		self.fill = YES;
		self.border = YES;
		self.textColor = [UIColor whiteColor];
		self.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.9f];
		self.borderColor = [UIColor darkGrayColor];
		self.percent = 0.0f;
		self.name = nil;
		self.value = 0;
	}
	return self;
}

- (void)dealloc
{
	[_textColor release];
	[_fillColor release];
	[_borderColor release];
	[_name release];
	[_value release];
	
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
			[self.fillColor set];
			
			CGRect fillRect;
			fillRect.origin.x = 2.0f;
			fillRect.origin.y = 2.0f;
			fillRect.size.width = (rect.size.width - 4.0f) * (self.percent > 1.0f ? 1.0f : self.percent);
			fillRect.size.height = rect.size.height - 4.0f;

			CGContextFillRect( context, fillRect );
		}

		if ( self.border )
		{
			[self.borderColor set];
			CGContextSetLineWidth( context, 2.0f );
			CGContextStrokeRect( context, rect );
		}
		
		[self.textColor set];

		CGRect textFrame;
		textFrame.origin.x = 0;
		textFrame.origin.y = floorf( (rect.size.height - 10.0f) / 2.0f ) - 1.0f;
		textFrame.size.width = rect.size.width;
		textFrame.size.height = 10.0f;
		
		NSString * text = [NSString stringWithFormat:@"%@: %@", self.name, self.value ? self.value : @""];
		[text drawInRect:textFrame
				withFont:[UIFont boldSystemFontOfSize:10.0f]
		   lineBreakMode:UILineBreakModeClip
			   alignment:UITextAlignmentCenter];
	}
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
