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
//  Bee_UIWebBoard.m
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "Bee_UIWebBoard.h"

#pragma mark -

@implementation BeeUIWebBoard

@synthesize webView = _webView;

- (void)load
{
}

- (void)unload
{
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			_webView = [[BeeUIWebView alloc] initWithFrame:self.viewBound];
			[self.view addSubview:_webView];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
			SAFE_RELEASE_SUBVIEW( _webView );
		}
		else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
		{
		}
		else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
		{
		}
		else if ( [signal is:BeeUIBoard.FREE_DATAS] )
		{
		}
		else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
		{
		}
		else if ( [signal is:BeeUIBoard.DID_APPEAR] )
		{
		}
		else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
		{	
		}
		else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
		{
		}
	}
	else if ( [signal isKindOf:BeeUIWebView.SIGNAL] )
	{
		if ( [signal is:BeeUIWebView.DID_LOAD_FINISH] )
		{
			// TODO: change title
		}
	}
}

@end
