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
//  Bee_DebugSampleView.h
//

#import "Bee_Precompile.h"
#import "Bee.h"

#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

#import "Bee_DebugSampleView.h"

#pragma mark -

@implementation BeeDebugSampleView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.backgroundColor = [UIColor clearColor];
		
		CGRect blockFrame = CGRectMake( 0, 0, self.bounds.size.height, self.bounds.size.height );
		_blockView = [[UIView alloc] initWithFrame:CGRectInset(blockFrame, 2.0f, 2.0f)];
		_blockView.backgroundColor = [UIColor clearColor];
		[self addSubview:_blockView];

		CGRect textFrame = CGRectMake( self.bounds.size.height + 4.0f, 0, self.bounds.size.width - self.bounds.size.height - 6.0f, self.bounds.size.height );
		_textLabel = [[BeeUILabel alloc] initWithFrame:textFrame];
		_textLabel.textAlignment = UITextAlignmentLeft;
		_textLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_textLabel.lineBreakMode = UILineBreakModeClip;
		_textLabel.numberOfLines = 1;
		[self addSubview:_textLabel];
	}
	return self;
}

- (void)dealloc
{
	SAFE_RELEASE_SUBVIEW( _blockView );
	SAFE_RELEASE_SUBVIEW( _textLabel );
	
	[super dealloc];
}

- (void)setColor:(UIColor *)color text:(NSString *)text
{
	_blockView.backgroundColor = color;
	_textLabel.text = text;
}

@end

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__
