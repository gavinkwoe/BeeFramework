//
//  DribbbleController.h
//

#import "Bee.h"

#pragma mark -

@interface DribbbleController : BeeController

AS_SINGLETON( DribbbleController )

AS_MESSAGE( GET_SHOTS_EVERYONE )
AS_MESSAGE( GET_SHOTS_DEBUTS )
AS_MESSAGE( GET_SHOTS_POPULAR )

@end
