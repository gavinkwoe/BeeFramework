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

#import "DribbbleWebBoardTab_iPhone.h"

#pragma mark -

@implementation DribbbleWebBoardTab_iPhone

SUPPORT_RESOURCE_LOADING(YES)
SUPPORT_AUTOMATIC_LAYOUT(YES)

DEF_OUTLET( BeeUIButton, go_backward );
DEF_OUTLET( BeeUIButton, go_forward );
DEF_OUTLET( BeeUIButton, refresh );

@dynamic canGoBack;
@dynamic canGoForward;
@dynamic loading;

- (void)setCanGoBack:(BOOL)flag
{
	self.go_backward.data = [UIImage imageNamed:@"browser-baritem-back.png"];
	self.go_backward.enabled = flag;
	self.go_backward.alpha = flag ? 1.0f : 0.4f;
}

- (void)setCanGoForward:(BOOL)flag
{
	self.go_forward.data = [UIImage imageNamed:@"browser-baritem-forward.png"];
	self.go_forward.enabled = flag;
	self.go_forward.alpha = flag ? 1.0f : 0.4f;
}

- (void)setLoading:(BOOL)flag
{
	if ( flag )
	{
		self.refresh.data = [UIImage imageNamed:@"browser-baritem-stop.png"];
	}
	else
	{
		self.refresh.data = [UIImage imageNamed:@"browser-baritem-refresh.png"];
	}
}

@end
