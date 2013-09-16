//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
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

#import "ShotInfoModel.h"

#pragma mark -

@implementation ShotInfoModel

@synthesize shot_id = _shot_id;
@synthesize shot = _shot;

- (void)load
{
	[super load];
}

- (void)unload
{
	self.shot_id = nil;
	self.shot = nil;

	[super unload];
}

#pragma mark -

- (void)loadCache
{
}

- (void)saveCache
{
}

- (void)clearCache
{
}

#pragma mark -

- (void)firstPage
{
	[API_SHOTS_ID cancel];

	API_SHOTS_ID * api = [API_SHOTS_ID apiWithResponder:self];
	api.id = [self.shot_id asNSString];
	[api send];
}

#pragma mark -

- (void)API_SHOTS_ID:(API_SHOTS_ID *)api
{
	if ( api.succeed )
	{
		if ( nil == api.resp )
		{
			api.failed = YES;
			return;
		}
		
		self.shot = api.resp;
		self.loaded = YES;
		
		[self saveCache];
	}
}

@end
