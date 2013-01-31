//
//  DribbbleBoard.h
//

#import "Bee.h"
#import "DribbbleController.h"

#pragma mark -

@interface DribbbleModel : BeeModel
{
	NSString *			_category;
	NSInteger			_perPage;
	NSInteger			_total;
	NSMutableArray *	_shots;
}

@property (nonatomic, retain) NSString *		category;
@property (nonatomic, assign) NSInteger			perPage;
@property (nonatomic, assign) NSInteger			total;
@property (nonatomic, retain) NSMutableArray *	shots;

- (void)loadCache;
- (void)saveCache;
- (void)fetchShots;

@end

#pragma mark -

@interface DribbbleEveryoneModel : DribbbleModel
@end

@interface DribbbleDebutsModel : DribbbleModel
@end

@interface DribbblePopularModel : DribbbleModel
@end
