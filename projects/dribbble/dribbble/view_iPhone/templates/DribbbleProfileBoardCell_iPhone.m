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

#import "DribbbleProfileBoardCell_iPhone.h"

#pragma mark -

@implementation DribbbleProfileBoardCell_iPhone

SUPPORT_RESOURCE_LOADING(YES)
SUPPORT_AUTOMATIC_LAYOUT(YES)

DEF_OUTLET( BeeUIImageView,	bg )
DEF_OUTLET( BeeUILabel,		follower )
DEF_OUTLET( BeeUILabel,		following )
DEF_OUTLET( BeeUILabel,		shots )
DEF_OUTLET( BeeUILabel,		name )
DEF_OUTLET( BeeUIImageView,	url_icon )
DEF_OUTLET( BeeUILabel,		url_text )
DEF_OUTLET( BeeUIImageView,	location_icon )
DEF_OUTLET( BeeUILabel,		location_text )
DEF_OUTLET( BeeUIImageView,	avatar )

- (void)dataDidChanged
{
	PLAYER * player = self.data;
	if ( player )
	{
		self.bg.data = @"http://d13yacurqjgara.cloudfront.net/users/14268/screenshots/992731/attachments/116296/huge.jpg";
		self.follower.data = player.followers_count;
		self.following.data = player.following_count;
		self.shots.data = player.shots_count;
		self.name.data = player.name;
		self.url_icon.data = @"";
		self.url_text.data = player.url;
		
		self.location_icon.data = @"";
		
		if ( player.location && player.location.length )
		{
			self.location_text.data = [NSString stringWithFormat:@"From %@", player.location];
		}
		else
		{
			self.location_text.data = @"Unknown";
		}
		
		self.avatar.data = player.avatar_url;
	}
}

@end
