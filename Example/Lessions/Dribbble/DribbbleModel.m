//
//  DribbbleModel.m
//

#import "DribbbleModel.h"
#import "DribbbleController.h"

#pragma mark -

@interface DribbbleModel(Private)
- (void)asyncSaveCache;
@end

@implementation DribbbleModel

@synthesize total = _total;
@synthesize shots = _shots;

- (void)load
{
	[super load];
	
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

@end

#pragma mark -

@implementation DribbbleEveryoneModel
DEF_SINGLETON(DribbbleEveryoneModel);
@end

@implementation DribbbleDebutsModel
DEF_SINGLETON(DribbbleDebutsModel);
@end

@implementation DribbblePopularModel
DEF_SINGLETON(DribbblePopularModel);
@end
