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

#import "ShotListModel.h"

#pragma mark -

#undef	PER_PAGE
#define PER_PAGE	(10)

#pragma mark -

@implementation ShotListModel

@synthesize type = _type;
@synthesize shots = _shots;

- (void)load
{
	[super load];
	
	self.shots = [NSMutableArray array];
	
	[self loadCache];
}

- (void)unload
{
	[self saveCache];
	
	self.shots = nil;
	self.type = nil;
	
	[super unload];
}

#pragma mark -

- (void)loadCache
{
	[self.shots removeAllObjects];
	[self.shots addObjectsFromArray:[SHOT readObjectForKey:self.type]];
}

- (void)saveCache
{
	[SHOT saveObject:self.shots forKey:self.type];
}

- (void)clearCache
{
	[self.shots removeAllObjects];
	
	[SHOT removeObjectForKey:self.type];
}

#pragma mark -

- (void)firstPage
{
	[API_SHOTS_LIST cancel];

	API_SHOTS_LIST * api = [API_SHOTS_LIST apiWithResponder:self];
	api.list = self.type;
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
	if ( 0 == self.shots.count )
		return;

	[API_SHOTS_LIST cancel];
	
	API_SHOTS_LIST * api = [API_SHOTS_LIST apiWithResponder:self];
	api.list = self.type;
	api.req.page = @(self.shots.count / PER_PAGE + 1);
	api.req.per_page = @(PER_PAGE);
	[api send];
}

#pragma mark -

- (void)API_SHOTS_LIST:(API_SHOTS_LIST *)api
{
	if ( api.succeed )
	{
		if ( nil == api.resp.shots )
		{
			api.failed = YES;
			return;
		}

		if ( [api.req.page isEqualToNumber:@1] )
		{
			[self.shots removeAllObjects];
		}
		
		[self.shots addObjectsFromArray:api.resp.shots];
		self.loaded = YES;
		
		[self saveCache];
	}
}

@end

#pragma mark -

@implementation ShotEveryoneListModel

- (void)load
{
	self.type = LIST_EVERYONE;

	[super load];
}

@end

#pragma mark -

@implementation ShotPopularListModel

- (void)load
{
	self.type = LIST_POPULAR;

	[super load];
}

@end

#pragma mark -

@implementation ShotDebutsListModel

- (void)load
{
	self.type = LIST_DEBUTS;

	[super load];
}

@end
