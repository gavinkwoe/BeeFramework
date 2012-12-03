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
//  Bee_DebugDetailView.h
//

#import "Bee_Precompile.h"
#import "Bee.h"

#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

#import "Bee_DebugDetailView.h"

@implementation BeeDebugTextView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{		
		self.backgroundColor = [UIColor clearColor];
		
		CGRect contentFrame = frame;
		contentFrame.origin = CGPointZero;
		contentFrame = CGRectInset(contentFrame, 10.0f, 10.0f);
		
		_content = [[BeeUITextView alloc] initWithFrame:contentFrame];
		_content.font = [UIFont boldSystemFontOfSize:12.0f];
		_content.textColor = [UIColor blackColor];
		_content.textAlignment = UITextAlignmentLeft;
		_content.editable = NO;
		_content.dataDetectorTypes = UIDataDetectorTypeLink;
		_content.scrollEnabled = YES;
		_content.backgroundColor = [UIColor whiteColor];
		_content.layer.borderColor = [UIColor grayColor].CGColor;
		_content.layer.borderWidth = 2.0f;
		[self addSubview:_content];

		CGRect closeFrame;
		closeFrame.size.width = 40.0f;
		closeFrame.size.height = 40.0f;
		closeFrame.origin.x = frame.size.width - closeFrame.size.width + 5.0f;
		closeFrame.origin.y = -5.0f;
		
		_close = [[BeeUIButton alloc] initWithFrame:closeFrame];
		_close.stateNormal.image = __IMAGE( @"close.png" );
		[_close addSignal:@"CLOSE_TOUCHED" forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_close];
	}
	return self;
}

- (void)setFilePath:(NSString *)path
{
	if ( [path hasSuffix:@".plist"] || [path hasSuffix:@".strings"] )
	{
		_content.text = [[NSDictionary dictionaryWithContentsOfFile:path] description];
	}
	else
	{
		NSData * data = [NSData dataWithContentsOfFile:path];
		_content.text = [NSString stringWithUTF8String:[data bytes]];
	}
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	if ( [signal is:@"CLOSE_TOUCHED"] )
	{
		[self.board dismissModalViewAnimated:YES];
	}
}

- (void)dealloc
{
	SAFE_RELEASE_SUBVIEW( _content );
	SAFE_RELEASE_SUBVIEW( _close );
	
	[super dealloc];
}

@end

#pragma mark -

@implementation BeeDebugImageView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.backgroundColor = [UIColor clearColor];
		
		CGRect bounds = frame;
		bounds.origin = CGPointZero;
		bounds = CGRectInset( bounds, 10.0f, 10.0f );
		
		_imageView = [[BeeUIImageView alloc] initWithFrame:bounds];
		_imageView.contentMode = UIViewContentModeCenter;
		
		_zoomView = [[BeeUIZoomView alloc] initWithFrame:bounds];
		[_zoomView setContentSize:bounds.size];
		[_zoomView setContent:_imageView animated:NO];
		_zoomView.backgroundColor = [UIColor whiteColor];
		_zoomView.layer.borderColor = [UIColor grayColor].CGColor;
		_zoomView.layer.borderWidth = 2.0f;
		[self addSubview:_zoomView];

		CGRect closeFrame;
		closeFrame.size.width = 40.0f;
		closeFrame.size.height = 40.0f;
		closeFrame.origin.x = frame.size.width - closeFrame.size.width + 5.0f;
		closeFrame.origin.y = -5.0f;
		_close = [[BeeUIButton alloc] initWithFrame:closeFrame];
		_close.stateNormal.image = __IMAGE( @"close.png" );
		[_close addSignal:@"CLOSE_TOUCHED" forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_close];
	}
	return self;
}

- (void)setFilePath:(NSString *)path
{
	_imageView.image = [UIImage imageWithContentsOfFile:path];
}

- (void)setURL:(NSString *)url
{
	[_imageView GET:url useCache:YES];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	if ( [signal is:@"CLOSE_TOUCHED"] )
	{
		[self.board dismissModalViewAnimated:YES];
	}
}

- (void)dealloc
{
	SAFE_RELEASE_SUBVIEW( _zoomView );
	SAFE_RELEASE_SUBVIEW( _imageView );
	SAFE_RELEASE_SUBVIEW( _close );
	
	[super dealloc];
}

@end

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__
