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

#import "ShotCommentsModel.h"

#pragma mark -

#undef	PER_PAGE
#define PER_PAGE	(10)

#pragma mark -

@implementation ShotCommentsModel

@synthesize shot_id = _shot_id;
@synthesize comments = _comments;

- (void)load
{
	[super load];
	
	self.comments = [NSMutableArray array];
}

- (void)unload
{
	self.shot_id = nil;
	self.comments = nil;

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


#pragma mark -

- (void)firstPage
{
	[API_SHOTS_ID_COMMENTS cancel];
	
	API_SHOTS_ID_COMMENTS * api = [API_SHOTS_ID_COMMENTS apiWithResponder:self];
	api.id = [self.shot_id asNSString];
	api.req.page = @1;
	api.req.per_page = @(PER_PAGE);
	[api send];
}

- (void)prevPage
{
	[self firstPage];
}

- (void)nextPage
{
	if ( 0 == self.comments.count )
		return;
	
	[API_SHOTS_ID_COMMENTS cancel];
	
	API_SHOTS_ID_COMMENTS * api = [API_SHOTS_ID_COMMENTS apiWithResponder:self];
	api.id = [self.shot_id asNSString];
	api.req.page = @(self.comments.count / PER_PAGE + 1);
	api.req.per_page = @(PER_PAGE);
	[api send];
}

#pragma mark -

- (void)API_SHOTS_ID_COMMENTS:(API_SHOTS_ID_COMMENTS *)api
{
	if ( api.succeed )
	{
		if ( nil == api.resp )
		{
			api.failed = YES;
			return;
		}
		
		if ( [api.req.page isEqualToNumber:@1] )
		{
			[self.comments removeAllObjects];
		}
		
		[self.comments addObjectsFromArray:api.resp.comments];
		self.loaded = YES;

		[self saveCache];
	}
}

@end
