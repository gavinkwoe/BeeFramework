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
//  Bee_UIFont.m
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Bee_UIFont.h"

#pragma mark -

@interface BeeUIFont(Private)
- (UIFont *)height:(CGFloat)fontSize bold:(BOOL)bold;
@end

@implementation BeeUIFont

DEF_SINGLETON( BeeUIFont );

@synthesize fontName = _fontName;
@synthesize boldFontName = _boldFontName;

- (id)init
{
	self = [super init];
	if ( self )
	{
		_fontName = nil;
		_boldFontName = nil;
	}	
	return self;
}

- (void)dealloc
{
	[_fontName release];
	[_boldFontName release];

	[super dealloc];
}

+ (UIFont *)height:(CGFloat)fontSize
{
	return [[BeeUIFont sharedInstance] height:fontSize bold:NO];
}

+ (UIFont *)height:(CGFloat)fontSize bold:(BOOL)bold
{
	return [[BeeUIFont sharedInstance] height:fontSize bold:bold];
}

- (UIFont *)height:(CGFloat)fontSize bold:(BOOL)bold
{
	if ( [_fontName length] )
	{
		if ( bold )
		{
			return [UIFont fontWithName:_boldFontName size:fontSize];
		}
		else
		{
			return [UIFont fontWithName:_fontName size:fontSize];
		}
	}
	else
	{
		if ( bold )
		{
			return [UIFont boldSystemFontOfSize:fontSize];
		}
		else
		{
			return [UIFont systemFontOfSize:fontSize];
		}		
	}	
}

@end
