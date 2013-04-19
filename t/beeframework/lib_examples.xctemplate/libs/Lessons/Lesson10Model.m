//
//  Lesson10Model.m
//

#import "Lesson10Model.h"

#pragma mark -

@implementation Lesson10Model

@synthesize date = _date;
@synthesize text = _text;

- (void)load
{
	[super load];
}

- (void)unload
{
	[_date release];
	[_text release];
	
	[super unload];
}

- (void)loadCache
{
	NSDictionary * dict = (NSDictionary *)[[BeeFileCache sharedInstance] objectForKey:self.name];
	if ( dict )
	{
		self.date = [NSDate dateWithTimeIntervalSince1970:[dict numberAtPath:@"/date"].doubleValue];
		self.text = [dict stringAtPath:@"/text"];
	}
}

- (void)saveCache
{
	NSDictionary * dict = [NSMutableDictionary keyValues:
						   @"date",	__DOUBLE(self.date.timeIntervalSince1970),
						   @"text",	self.text,
						   nil];
	
	[[BeeFileCache sharedInstance] saveObject:dict forKey:self.name];
}

- (void)clearCache
{
	[[BeeFileCache sharedInstance] deleteKey:self.name];
}

@end
