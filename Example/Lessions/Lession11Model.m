//
//  Lession11Model.m
//

#import "Lession11Model.h"

#pragma mark -

@implementation Lession11Record

@synthesize rid = _rid;
@synthesize name = _name;
@synthesize url = _url;

+ (void)mapRelation
{
	[self mapPropertyAsKey:@"rid"];		
	[self mapProperty:@"name"	defaultValue:@"unknown"];
	[self mapProperty:@"url"	defaultValue:@"http://"];
}

- (void)load
{
	[super load];
}

- (void)unload
{
	self.rid = nil;
	self.name = nil;
	self.url = nil;

	[super unload];
}

@end
