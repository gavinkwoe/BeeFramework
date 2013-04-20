//
//  Lesson10Model.h
//

#import "Bee.h"

#pragma mark -

@interface Lesson11Record : BeeActiveRecord
{
	NSNumber *	_rid;
	NSString *	_name;
	NSString *	_url;
}

@property (nonatomic, retain) NSNumber *	rid;
@property (nonatomic, retain) NSString *	name;
@property (nonatomic, retain) NSString *	url;

@end
