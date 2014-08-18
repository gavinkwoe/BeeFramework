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

#import "Bee_HTTPRouter2.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( BeePackage_HTTP, BeeHTTPRouter2, router );

#pragma mark -

@interface BeeHTTPRouter2()
{
	NSMutableDictionary *	_routes;
	BeeHTTPRouter2Block		_index;
}
@end

#pragma mark -

@implementation BeeHTTPRouter2

DEF_SINGLETON( BeeHTTPRouter2 )

@synthesize routes = _routes;
@synthesize index = _index;

+ (void)load
{
	[self sharedInstance];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.routes = [[[NSMutableDictionary alloc] init] autorelease];
		self.index = nil;
	}
	return self;
}

- (void)dealloc
{
	[self.routes removeAllObjects];
	
	self.routes = nil;
	self.index = nil;

	[super dealloc];
}

- (void)index:(BeeHTTPRouter2Block)block
{
	self.index = block;
}

- (void)route:(NSString *)url action:(BeeHTTPRouter2Block)block
{
	[self.routes setObject:[block copy] forKey:url];
}

- (void)route:(NSString *)url
{
	NSString * path = nil;
	
	if ( nil == url || 0 == url.length )
		return;
	
	if ( [url hasPrefix:@"http://"] || [url hasPrefix:@"https://"] )
	{
		NSURL * url2 = [NSURL URLWithString:url];
		if ( nil == url2 )
			return;

		path = url2.path;
	}
	else
	{
		path = url;
	}

	BeeHTTPRouter2Block block = [self.routes objectForKey:path];
	BeeHTTPRouter2Block defaultBlock = self.index;

	if ( block )
	{
		block();
		return;
	}

	BOOL matched = NO;

	for ( NSString * rule in self.routes.allKeys )
	{
		if ( [rule isEqualToString:@"/"] )
		{
			defaultBlock = [self.routes objectForKey:rule];
		}
		
		if ( [rule isEqualToString:path] )
		{
			matched = YES;
		}
		else
		{
			NSMutableString * expr = [NSMutableString string];
			[expr appendString:@"^"];

			NSArray * segments = [rule componentsSeparatedByString:@"/"];
			for ( NSString * segment in segments )
			{
				if ( segment.length )
				{
					if ( [segment hasPrefix:@":"] )
					{
						[expr appendString:@"([a-z0-9_]+)"];
					}
					else
					{
						NSString * formattedSegment = [segment stringByReplacingOccurrencesOfString:@"." withString:@"\\."];
						[expr appendString:formattedSegment];
					}
				}
				
				if ( [segments lastObject] != segment )
				{
					[expr appendString:@"/"];
				}
			}
			
			[expr appendString:@"$"];
			
			NSError * error = NULL;
			NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expr options:NSRegularExpressionCaseInsensitive error:&error];
			NSTextCheckingResult * result = [regex firstMatchInString:path options:0 range:NSMakeRange(0, [path length])];
			
			matched = (result && (regex.numberOfCaptureGroups + 1) == result.numberOfRanges) ? YES : NO;
		}
		
		if ( matched )
		{
			block = [self.routes objectForKey:rule];
			break;
		}
	}

	if ( matched )
	{
		if ( block )
		{
			block();
		}
	}
	else
	{
		if ( defaultBlock )
		{
			defaultBlock();
		}
	}
}

- (id)objectAtIndexedSubscript:(NSUInteger)index
{
	if ( index >= self.routes.count )
		return self.index;
	
	return [self.routes objectForKey:[self.routes.allKeys objectAtIndex:index]];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)index
{
	ASSERT( 0 );
}

- (id)objectForKeyedSubscript:(id)key
{
	id block = [self.routes objectForKey:key];
	if ( block )
		return block;
	
	return self.index;
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	if ( nil == obj || nil == key )
		return;

	[self.routes setObject:[[obj copy] autorelease] forKey:key];
}

@end
