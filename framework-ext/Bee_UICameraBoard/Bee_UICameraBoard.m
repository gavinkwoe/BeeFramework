//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open-source orgnization
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

#import "Bee_UICameraBoard.h"

@implementation BeeUICameraBoard
{
	BeeUICameraView * _cameraView;
}

@synthesize cameraView = _cameraView;

ON_SIGNAL3( BeeUIBoard, CREATE_VIEWS, signal )
{
	[super handleUISignal:signal];
	
	_cameraView = [BeeUICameraView view];
	[self.view addSubview:_cameraView];
}

ON_SIGNAL3( BeeUIBoard, DELETE_VIEWS, signal )
{
	[super handleUISignal:signal];

	[_cameraView setRunning:NO];
	[_cameraView removeFromSuperview];
	_cameraView = nil;
}

ON_SIGNAL3( BeeUIBoard, LAYOUT_VIEWS, signal )
{
	[super handleUISignal:signal];
	
	_cameraView.frame = self.bounds;
}

ON_SIGNAL3( BeeUIBoard, WILL_APPEAR, signal )
{
	[super handleUISignal:signal];
	
	_cameraView.continuousFocusAt = CGPointMake( 0.5f, 0.5f );
}

@end

