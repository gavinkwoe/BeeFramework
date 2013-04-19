//
//  DribbbleModel.m
//

#import "DribbbleModel.h"
#import "DribbbleController.h"
#import "Bee_Database.h"

#pragma mark -

#define DEFAULT_PER_PAGE	(10)

#pragma mark -

@interface DribbbleModel(Private)
- (void)asyncSaveCache;
- (void)addShot:(NSObject *)shot;
- (void)addShots:(NSArray *)shots;
- (void)removeShost:(NSObject *)shot;
- (void)removeShosts:(NSArray *)shots;
- (void)removeAllShots;
@end

@implementation DribbbleModel

@synthesize category = _category;
@synthesize perPage = _perPage;
@synthesize total = _total;
@synthesize shots = _shots;

- (void)load
{
	[super load];

	_category = nil;
	_perPage = DEFAULT_PER_PAGE;
	_total = 0;
	_shots = [[NSMutableArray alloc] init];
}

- (void)unload
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	_total = 0;
	
	[_shots removeAllObjects];
	[_shots release];
	_shots = nil;
	
	[_category release];
	
	[super unload];
}

- (void)loadCache
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
		
	NSDictionary * dict = (NSDictionary *)[[BeeFileCache sharedInstance] objectForKey:self.name];
	if ( dict )
	{
		_total = [[dict numberAtPath:@"total" otherwise:__INT(0)] intValue];

		[_shots removeAllObjects];
		[_shots addObjectsFromArray:[dict arrayAtPath:@"shots" otherwise:[NSArray array]]];
	}
}

- (void)saveCache
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self performSelector:@selector(asyncSaveCache) withObject:nil afterDelay:0.1f];	
}

- (void)asyncSaveCache
{
	NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:__INT(_total), @"total", _shots, @"shots", nil];
	[[BeeFileCache sharedInstance] saveObject:dict forKey:self.name];
}

- (void)addShot:(NSObject *)shot
{
	[self addShot:[NSArray arrayWithObject:shot]];
}

- (void)addShots:(NSArray *)shots
{
	// TODO: 排重
	
	[_shots addObjectsFromArray:shots];	
	[_shots sortUsingComparator:^(NSDictionary * value1, NSDictionary * value2){
		NSString * date1 = [value1 stringAtPath:@"/created_at"];
		NSString * date2 = [value2 stringAtPath:@"/created_at"];
		return [date1 compare:date2];
	}];

	[self saveCache];
}

- (void)removeShost:(NSObject *)shot
{
	[self removeShosts:[NSArray arrayWithObject:shot]];
}

- (void)removeShosts:(NSArray *)shots
{
	[_shots removeObjectsInArray:shots];
	[_shots sortUsingComparator:^(NSDictionary * feed1, NSDictionary * feed2){
		NSString * date1 = [feed1 stringAtPath:@"/created_at"];
		NSString * date2 = [feed2 stringAtPath:@"/created_at"];
		return [date1 compare:date2];
	}];

	[self saveCache];
}

- (void)removeAllShots
{
	[_shots removeAllObjects];
	[self saveCache];
}

- (void)fetchShots
{
	[[self sendMessage:DribbbleController.GET_SHOTS timeoutSeconds:30.0f] input:
	 @"cate", _category,
	 @"page", __INT(0),
	 @"size", __INT(_perPage),
	 nil];	
}

- (void)handleMessage:(BeeMessage *)msg
{
	[super handleMessage:msg];
}

- (void)handleDribbbleController:(BeeMessage *)msg
{
	[super handleMessage:msg];

	if ( [msg is:DribbbleController.GET_SHOTS] )
	{
		if ( msg.succeed )
		{
			NSNumber * page = [msg.input numberAtPath:@"/page" otherwise:__INT(0)];
			if ( 0 == [page intValue] )
			{
				[self removeAllShots];
			}
			
			[self setTotal:[msg.output numberAtPath:@"/total"].intValue];
			[self addShots:[msg.output arrayAtPath:@"/shots"]];
		}
	}
}

@end

#pragma mark -

@implementation DribbbleEveryoneModel

- (void)load
{
	[super load];

	self.category = @"everyone";
}

@end

#pragma mark -

@implementation DribbbleDebutsModel

- (void)load
{
	[super load];

	self.category = @"debuts";
}

@end

#pragma mark -

@implementation DribbblePopularModel

- (void)load
{
	[super load];

	self.category = @"popular";
}

@end
