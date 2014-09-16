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

#import "Bee_HTTPServerRouter2.h"
#import "Bee_HTTPUtility2.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( BeeHTTPServer2, BeeHTTPServerRouter2, urls );
DEF_PACKAGE( BeeHTTPServer2, BeeHTTPServerRouter2, router );

#pragma mark -

@interface BeeHTTPServerRouter2()
{
	NSMutableDictionary *		_routes;
	BeeHTTPServerRouter2Block	_index;
}
@end

#pragma mark -

@implementation BeeHTTPServerRouter2

DEF_SINGLETON( BeeHTTPServerRouter2 )

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
		self.index = ^
		{
			line( @"<html>" );
			line( @"<body>" );
			line( @"<pre>" );
			line( @"It works!" );
			line( @"\n" );
			line( @"	 ______    ______    ______" );
			line( @"	/\\  __ \\  /\\  ___\\  /\\  ___\\" );
			line( @"	\\ \\  __<  \\ \\  __\\_ \\ \\  __\\_" );
			line( @"	 \\ \\_____\\ \\ \\_____\\ \\ \\_____\\" );
			line( @"	  \\/_____/  \\/_____/  \\/_____/" );
			line( @"\n" );
			line( @"	Copyright (c) 2014-2015, Geek Zoo Studio" );
			line( @"	http://www.bee-framework.com" );
			line( @"</pre>" );
			line( @"</body>" );
			line( @"</html>" );
		};
		
		self[@"404"] = ^
		{
			line( @"<html>" );
			line( @"<body>" );
			line( @"<pre>" );
			line( @"404 not found" );
			line( @"</pre>" );
			line( @"</body>" );
			line( @"</html>" );
		};
		
		self[@"500"] = ^
		{
			line( @"<html>" );
			line( @"<body>" );
			line( @"<pre>" );
			line( @"500 internal error" );
			line( @"</pre>" );
			line( @"</body>" );
			line( @"</html>" );
		};
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

- (void)indexAction:(BeeHTTPServerRouter2Block)block
{
	self.index = block;
}

- (void)otherAction:(BeeHTTPServerRouter2Block)block url:(NSString *)url;
{
	[self.routes setObject:[[block copy] autorelease] forKey:url];
}

- (void)error404Action:(BeeHTTPServerRouter2Block)block
{
	[self.routes setObject:[[block copy] autorelease] forKey:@"404"];
}

- (void)error500Action:(BeeHTTPServerRouter2Block)block
{
	[self.routes setObject:[[block copy] autorelease] forKey:@"500"];
}

- (BOOL)routes:(NSString *)url
{
	NSString * path = nil;
	
	if ( nil == url || 0 == url.length )
		return NO;
	
	if ( [url hasPrefix:@"http://"] || [url hasPrefix:@"https://"] )
	{
		NSURL * url2 = [NSURL URLWithString:url];
		if ( nil == url2 )
			return NO;

		path = url2.path;
	}
	else
	{
		path = url;
	}

	BeeHTTPServerRouter2Block block = [self.routes objectForKey:path];
	BeeHTTPServerRouter2Block defaultBlock = self.index;

	if ( block )
	{
		block();
		return YES;
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
			return YES;
		}
	}
//	else
//	{
//		if ( defaultBlock )
//		{
//			defaultBlock();
//			return YES;
//		}
//	}
	
	return NO;
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
