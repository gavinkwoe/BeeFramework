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

#import "SplashBoard_iPhone.h"

#pragma mark -

@implementation SplashBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

DEF_NOTIFICATION( PLAY_DONE )

#pragma mark -

- (void)load
{
}

- (void)unload
{
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
	self.navigationBarShown = NO;
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
	$(@"#slogan, #logo").ALPHA( 0.0f );
}

ON_DID_APPEAR( signal )
{
	[self performSelector:@selector(playAnimation) withObject:nil afterDelay:0.5f];
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)playAnimation
{
	$(@"#logo, #slogan")
	.FADE_IN()
	.DURATION( 0.5f )
	.DELAY( 1.0f )
	.ON_COMPLETE( ^{

		$(@"#logo")
		.BOUNCE()
		.DURATION( 0.5f )
		.DELAY( 1.0f )
		.ON_COMPLETE( ^{
			
			$(self)
			.FADE_OUT()
			.DURATION( 0.5f )
			.DELAY( 0.25f );

			$(self)
			.ZOOM_IN( $(@"#zoom-in-here").frame )
			.DURATION( 0.75f )
			.ON_COMPLETE( ^{
				
				[self postNotification:self.PLAY_DONE];
				
			});
		});
	});
}

@end
