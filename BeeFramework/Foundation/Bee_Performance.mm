//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
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
//
//  Bee_Performance.h
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "Bee_Performance.h"

#pragma mark -

@implementation BeePerformance

DEF_SINGLETON( BeePerformance );

@synthesize tags = _tags;

- (id)init
{
	self = [super init];
	if ( self )
	{
		_tags = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_tags removeAllObjects];
	[_tags release];
	
	[super dealloc];
}

+ (double)timestamp
{
	return CACurrentMediaTime();
}

+ (double)mark:(NSString *)tag
{
	double curr = CACurrentMediaTime();
	
	NSNumber * time = [NSNumber numberWithDouble:curr];
	[[BeePerformance sharedInstance].tags setObject:time forKey:tag];
	
	return curr;
}

+ (double)elapsed:(NSString *)tag
{
	NSNumber * time = [[BeePerformance sharedInstance].tags objectForKey:tag];
	if ( nil == time )
		return 0.0;
	
	return CACurrentMediaTime() - [time doubleValue];
}

+ (double)between:(NSString *)tag1 and:(NSString *)tag2
{
	NSNumber * time1 = [[BeePerformance sharedInstance].tags objectForKey:tag1];
	NSNumber * time2 = [[BeePerformance sharedInstance].tags objectForKey:tag2];
	
	if ( nil == time1 || nil == time2 )
		return 0.0;

	double time = fabs( [time2 doubleValue] - [time1 doubleValue] );
	
	[[BeePerformance sharedInstance].tags removeObjectForKey:tag1];
	[[BeePerformance sharedInstance].tags removeObjectForKey:tag2];

	return time;
}

+ (double)between:(NSString *)tag1 and:(NSString *)tag2 remove:(BOOL)remove
{
	NSNumber * time1 = [[BeePerformance sharedInstance].tags objectForKey:tag1];
	NSNumber * time2 = [[BeePerformance sharedInstance].tags objectForKey:tag2];
	
	if ( nil == time1 || nil == time2 )
		return 0.0;
	
	double time = fabs( [time2 doubleValue] - [time1 doubleValue] );
	
	if ( remove )
	{
		[[BeePerformance sharedInstance].tags removeObjectForKey:tag1];
		[[BeePerformance sharedInstance].tags removeObjectForKey:tag2];
	}
	
	return time;
}

@end
