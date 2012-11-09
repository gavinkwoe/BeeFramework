//
//  DribbbleBoard.h
//

#import "Bee.h"
#import "DribbbleController.h"

#pragma mark -

@interface DribbbleModel : BeeModel
{
	NSInteger			_perPage;
	NSInteger			_total;
	NSMutableArray *	_shots;
}

@property (nonatomic, assign) NSInteger			perPage;
@property (nonatomic, assign) NSInteger			total;
@property (nonatomic, retain) NSMutableArray *	shots;

- (void)loadCache;
- (void)saveCache;

- (void)addShot:(NSObject *)shot;
- (void)addShots:(NSArray *)shots;

- (void)removeShost:(NSObject *)shot;
- (void)removeShosts:(NSArray *)shots;
- (void)removeAllShots;

@end

#pragma mark -

@interface DribbbleEveryoneModel : DribbbleModel
- (void)fetchShots;
@end

@interface DribbbleDebutsModel : DribbbleModel
- (void)fetchShots;
@end

@interface DribbblePopularModel : DribbbleModel
- (void)fetchShots;
@end
