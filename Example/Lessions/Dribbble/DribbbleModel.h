//
//  DribbbleBoard.h
//

#import "Bee.h"

#pragma mark -

@interface DribbbleModel : BeeModel
{
	NSInteger			_total;
	NSMutableArray *	_shots;
}

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
AS_SINGLETON( DribbbleEveryoneModel );
@end

@interface DribbbleDebutsModel : DribbbleModel
AS_SINGLETON( DribbbleDebutsModel );
@end

@interface DribbblePopularModel : DribbbleModel
AS_SINGLETON( DribbblePopularModel );
@end
