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

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_UIImageLoader.h"
#import "Bee_UIImageCache.h"
#import "Bee_UIConfig.h"

#import "Bee_Cache.h"
#import "Bee_Network.h"

#pragma mark -

@implementation BeeUIImageJob

@synthesize id;
@synthesize state;
@synthesize url;
@synthesize image;

static NSUInteger		__jobSeed = 0;
static dispatch_queue_t	__ioQueue = nil;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.id = __jobSeed++;
	}
	return self;
}

- (void)dealloc
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	self.url = nil;
	self.image = nil;
	self.delegate = nil;
	
	[super dealloc];
}

#pragma mark -

- (void)execute
{
	@synchronized(self)
	{
		if ( nil == __ioQueue )
		{
			__ioQueue = dispatch_queue_create("com.0xbee.imageCache", DISPATCH_QUEUE_SERIAL);
		}

		INFO( @"Job #%d, url = '%@'", self.id, self.url );

		dispatch_async( dispatch_get_main_queue(), ^
		{
			self.state = BeeUIImageJobState_Loading;

			if ( self.delegate )
			{
				[self.delegate performSelectorOnMainThread:@selector(imageJobUpdate:) withObject:self waitUntilDone:YES];
			}
		});

		dispatch_async( __ioQueue, ^
		{
			NSString *		key = [self.url MD5];
			BeeImageCache *	cache = [BeeImageCache sharedInstance];

			BOOL exists = [cache hasObjectForKey:key];
			if ( exists )
			{
				UIImage * result = [cache objectForKey:key];
				if ( result )
				{
					dispatch_async( dispatch_get_main_queue(), ^
					{
						self.image = result;
						self.state = BeeUIImageJobState_Found;
						
						if ( self.delegate )
						{
							[self.delegate performSelectorOnMainThread:@selector(imageJobUpdate:) withObject:self waitUntilDone:YES];
						}
						
						self.delegate = nil;
						self.image = nil;
						self.state = BeeUIImageJobState_Dead;
					});
				}
				else
				{
					dispatch_async( dispatch_get_main_queue(), ^
					{
						self.image = nil;
						self.state = BeeUIImageJobState_NotFound;
						
						if ( self.delegate )
						{
							[self.delegate performSelectorOnMainThread:@selector(imageJobUpdate:) withObject:self waitUntilDone:YES];
						}
						
						self.delegate = nil;
						self.image = nil;
						self.state = BeeUIImageJobState_Dead;
					});
				}
			}
			else
			{
				dispatch_async( dispatch_get_main_queue(), ^
				{
					[self GET:self.url];
				});
			}
		});
	}
}

- (void)start
{
	@synchronized(self)
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self];

//		[self performSelector:@selector(execute)
//				   withObject:nil
//				   afterDelay:0.1f];
		[self performSelector:@selector(execute)
				   withObject:nil
				   afterDelay:0.01f
					  inModes:[NSArray arrayWithObjects:NSRunLoopCommonModes, nil]];
	}
}

- (void)cancel
{
	@synchronized(self)
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		
		if ( [self requestingURL] )
		{
			[self cancelRequests];
		}
		else
		{
			self.delegate = nil;
			self.image = nil;
			self.state = BeeUIImageJobState_Dead;
		}
	}
}

#pragma mark -

- (void)handleRequest:(BeeHTTPRequest *)request
{
	@synchronized(self)
	{
		if ( request.sending )
		{
			self.state = BeeUIImageJobState_Loading;
		}
		else if ( request.recving )
		{
			self.state = BeeUIImageJobState_Loading;
		}
		else if ( request.succeed )
		{
			NSString * key = [self.url MD5];

			NSData * data = request.responseData;
			if ( data && data.length )
			{
				dispatch_async( __ioQueue, ^
				{
					UIImage * result = [[[UIImage alloc] initWithData:request.responseData] autorelease];
					if ( result )
					{
						[[BeeImageCache sharedInstance] setObject:result forKey:key];

						dispatch_async( dispatch_get_main_queue(), ^
						{
							self.image = result;
							self.state = BeeUIImageJobState_Found;
							
							if ( self.delegate )
							{
								[self.delegate performSelectorOnMainThread:@selector(imageJobUpdate:) withObject:self waitUntilDone:YES];
							}
							
							self.delegate = nil;
							self.image = nil;
							self.state = BeeUIImageJobState_Dead;
						});
					}
					else
					{
						dispatch_async( dispatch_get_main_queue(), ^
						{
							self.image = nil;
							self.state = BeeUIImageJobState_NotFound;
							
							if ( self.delegate )
							{
								[self.delegate performSelectorOnMainThread:@selector(imageJobUpdate:) withObject:self waitUntilDone:YES];
							}
							
							self.delegate = nil;
							self.image = nil;
							self.state = BeeUIImageJobState_Dead;
						});
					}
				});
			}
			else
			{
				dispatch_async( dispatch_get_main_queue(), ^
				{
					self.image = nil;
					self.state = BeeUIImageJobState_NotFound;
					
					if ( self.delegate )
					{
						[self.delegate performSelectorOnMainThread:@selector(imageJobUpdate:) withObject:self waitUntilDone:YES];
					}
					
					self.delegate = nil;
					self.image = nil;
					self.state = BeeUIImageJobState_Dead;
				});
			}
		}
		else if ( request.failed )
		{
			dispatch_async( dispatch_get_main_queue(), ^
			{
				self.image = nil;
				self.state = BeeUIImageJobState_NotFound;
				
				if ( self.delegate )
				{
					[self.delegate performSelectorOnMainThread:@selector(imageJobUpdate:) withObject:self waitUntilDone:YES];
				}
				
				self.delegate = nil;
				self.image = nil;
				self.state = BeeUIImageJobState_Dead;
			});
		}
		else if ( request.cancelled )
		{
			dispatch_async( dispatch_get_main_queue(), ^
			{
				self.image = nil;
				self.state = BeeUIImageJobState_Cancelled;
				
				if ( self.delegate )
				{
					[self.delegate performSelectorOnMainThread:@selector(imageJobUpdate:) withObject:self waitUntilDone:YES];
				}

				self.delegate = nil;
				self.image = nil;
				self.state = BeeUIImageJobState_Dead;
			});
		}
	}
}

@end

#pragma mark -

@implementation BeeUIImageLoader
{
	NSLock *			_lock;
	NSMutableArray *	_jobs;
	NSTimer *			_timer;
}

DEF_SINGLETON( BeeUIImageLoader );

- (id)init
{
	self = [super init];
	if ( self )
	{
		_lock = [[NSLock alloc] init];
		_jobs = [[NSMutableArray alloc] init];
		_timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(cleanFinishedJob) userInfo:nil repeats:YES];
	}
	return self;
}

- (void)dealloc
{
	[_jobs removeAllObjects];
	[_jobs release];
	_jobs = nil;

	[_timer invalidate];
	_timer = nil;

	[_lock release];
	_lock = nil;

    [super dealloc];
}

#pragma mark -

- (void)loadForDelegate:(id<BeeUIImageJobDelegate>)delegate url:(NSString *)url
{
	if ( nil == url || nil == delegate )
		return;

	BeeUIImageJob * job = [[[BeeUIImageJob alloc] init] autorelease];
	if ( job )
	{
		[_lock lock];
		[_jobs addObject:job];
		[_lock unlock];

		[job setUrl:url];
		[job setDelegate:delegate];
		[job start];
	}
}

- (void)cancelForDelegate:(id<BeeUIImageJobDelegate>)delegate
{
	for ( BeeUIImageJob * job in _jobs )
	{
		if ( job.delegate == delegate )
		{
			[job cancel];
		}
	}
}

#pragma mark -

- (void)cleanFinishedJob
{
	NSMutableArray * willRemove = [NSMutableArray nonRetainingArray];
	
	for ( BeeUIImageJob * job in _jobs )
	{
		if ( BeeUIImageJobState_Dead == job.state )
		{
			[willRemove addObject:job];
		}
	}

	if ( willRemove.count )
	{
		INFO( @"Loading jobs = %d, removing jobs = %d", _jobs.count, willRemove.count );

		[_lock lock];
		[_jobs removeObjectsInArray:willRemove];
		[_lock unlock];
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
