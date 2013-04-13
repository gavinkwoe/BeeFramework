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
//  Bee_ActiveRecordTest.h
//

#import "Bee.h"
#import "Bee_UnitTest.h"

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

#pragma mark -

@interface User : BeeActiveRecord

@property (nonatomic, retain) NSNumber *	uid;
@property (nonatomic, retain) NSString *	name;
@property (nonatomic, retain) NSString *	gender;
@property (nonatomic, retain) NSDate *		birth;

@end

#pragma mark -

@implementation User

@synthesize uid;
@synthesize name;
@synthesize gender;
@synthesize birth;

+ (void)mapRelation
{
	[super mapRelation];
	[super useJSON];
	[super useAutoIncrement];
}

@end

#pragma mark -

TEST_CASE( ar )
{
	TIMES( 3 )
	{
	// open close DB
		
		[BeeDatabase closeSharedDatabase];
		EXPECTED( nil == [BeeDatabase sharedDatabase] );

		[BeeDatabase openSharedDatabase:@"ar"];
		EXPECTED( [BeeDatabase sharedDatabase] );
	}

	TIMES( 3 )
	{
	// empty
		
		User.DB.EMPTY();
		EXPECTED( User.DB.succeed );
		EXPECTED( User.DB.total == 0 );

	// insert & get
		
		User.DB.SET( @"name", @"gavin" ).SET( @"gender", @"male" ).SET( @"birth", [NSDate date] ).INSERT();
		EXPECTED( User.DB.succeed );
		EXPECTED( User.DB.total == 1 );

		User.DB.WHERE( @"name", @"gavin" ).GET();
		EXPECTED( User.DB.succeed );
		EXPECTED( User.DB.resultCount == 1 );
		
		NSDictionary * user = [User.DB.resultArray objectAtIndex:0];
		EXPECTED( user );
		EXPECTED( [[user objectForKey:@"name"] isEqualToString:@"gavin"] );
		EXPECTED( [[user objectForKey:@"gender"] isEqualToString:@"male"] );
		EXPECTED( [user objectForKey:@"birth"] );

	// insert & get again
		
		User.DB.SET( @"name", @"amanda" ).SET( @"gender", @"female" ).SET( @"birth", [NSDate date] ).INSERT();
		EXPECTED( User.DB.succeed );
		EXPECTED( User.DB.total == 2 );

		User.DB.WHERE( @"name", @"amanda" ).GET();
		EXPECTED( User.DB.succeed );
		EXPECTED( User.DB.resultCount == 1 );

		NSDictionary * user2 = [User.DB.resultArray objectAtIndex:0];
		EXPECTED( user2 );
		EXPECTED( [[user2 objectForKey:@"name"] isEqualToString:@"amanda"] );
		EXPECTED( [[user2 objectForKey:@"gender"] isEqualToString:@"female"] );
		EXPECTED( [user2 objectForKey:@"birth"] );

	// update

		User.DB.SET( @"birth", [NSDate date] ).WHERE( @"name", @"gavin" ).UPDATE();
		EXPECTED( User.DB.succeed );
		EXPECTED( User.DB.total == 2 );

	// delete
		
		User.DB.WHERE( @"name", @"gavin" ).DELETE();
		EXPECTED( User.DB.succeed );
		EXPECTED( User.DB.total == 1 );

		User.DB.WHERE( @"name", @"amanda" ).DELETE();
		EXPECTED( User.DB.succeed );
		EXPECTED( User.DB.total == 0 );
		
	// count

		User.DB.COUNT();
		EXPECTED( User.DB.succeed );
		EXPECTED( User.DB.resultCount == 0 );
	}
	
	[BeeDatabase closeSharedDatabase];
	EXPECTED( nil == [BeeDatabase sharedDatabase] );
}
TEST_CASE_END

#pragma mark -

@interface Location : BeeActiveRecord

@property (nonatomic, retain) NSNumber *	lid;
@property (nonatomic, retain) NSNumber *	lat;
@property (nonatomic, retain) NSNumber *	lon;

@end

#pragma mark -

@implementation Location

@synthesize lid;
@synthesize lat;
@synthesize lon;

@end

#pragma mark -

@interface User2 : User

@property (nonatomic, retain) NSString *	city;
@property (nonatomic, retain) Location *	location;

@end

#pragma mark -

@implementation User2

@synthesize city;
@synthesize location;

@end

#pragma mark -

TEST_CASE( ar2 )
{
	TIMES( 3 )
	{
	// open close DB

		[BeeDatabase closeSharedDatabase];
		EXPECTED( nil == [BeeDatabase sharedDatabase] );
		
		[BeeDatabase openSharedDatabase:@"ar2"];
		EXPECTED( [BeeDatabase sharedDatabase] );
	}

	TIMES( 3 )
	{
	// clear

		User2.DB.EMPTY();
		EXPECTED( User2.DB.succeed );
		EXPECTED( User2.DB.total == 0 );

	// create record

		User2 * me;

		me = [User2 record];

		EXPECTED( me );
		EXPECTED( me.deleted == NO );
		EXPECTED( me.changed == NO );
		EXPECTED( me.inserted == NO );
		EXPECTED( me.primaryKey && [me.primaryKey isEqualToString:@"uid"] );
		EXPECTED( me.primaryID );
		EXPECTED( me.JSON );
		EXPECTED( me.JSONData );
		EXPECTED( me.JSONString );
		
	// set values by property
		
		me.name = @"gavin";
		me.gender = @"male";
		me.birth = [NSDate date];

		me.city = @"beijing";
		me.location.lat = __INT(888);
		me.location.lon = __INT(999);

	// get values by JSON
		
		EXPECTED( [[me.JSON objectForKey:@"name"] isEqualToString:@"gavin"] );
		EXPECTED( [[me.JSON objectForKey:@"city"] isEqualToString:@"beijing"] );
		EXPECTED( [[me.JSON objectForKey:@"gender"] isEqualToString:@"male"] );
		EXPECTED( [[me.location.JSON objectForKey:@"lat"] isEqualToNumber:__INT(888)] );
		EXPECTED( [[me.location.JSON objectForKey:@"lon"] isEqualToNumber:__INT(999)] );

		EXPECTED( me.JSONData );
		EXPECTED( me.JSONString );

	// insert

		me.SAVE();

		EXPECTED( me.inserted );
		EXPECTED( User2.DB.succeed );
		EXPECTED( User2.DB.total == 1 );

	// update

		me.city = @"shenyang";

		EXPECTED( [[me.JSON objectForKey:@"city"] isEqualToString:@"shenyang"] );

		me.UPDATE();

		EXPECTED( User2.DB.succeed );
		EXPECTED( User2.DB.total == 1 );

	// delete

		me.DELETE();
		me = nil;

		EXPECTED( User2.DB.succeed );
		EXPECTED( User2.DB.total == 0 );
	}
	
	TIMES( 3 )
	{
	// clear
		
		User2.DB.EMPTY();

		EXPECTED( User.DB.succeed );
		EXPECTED( User.DB.total == 0 );

	// set values by JSON

		User2 * me = [User2 record];

		EXPECTED( me );
		EXPECTED( me.deleted == NO );
		EXPECTED( me.changed == NO );
		EXPECTED( me.inserted == NO );
		EXPECTED( me.primaryKey && [me.primaryKey isEqualToString:@"uid"] );
		EXPECTED( me.primaryID );
		EXPECTED( me.JSON );
		EXPECTED( me.JSONData );
		EXPECTED( me.JSONString );

		[me.JSON setObject:@"gavin" atPath:@"name"];
		[me.JSON setObject:@"beijing" atPath:@"city"];
		[me.JSON setObject:@"male" atPath:@"gender"];
		[me.JSON setObject:[[NSDate date] description] atPath:@"birth"];
		[me.location.JSON setObject:__INT(888) atPath:@"lat"];
		[me.location.JSON setObject:__INT(999) atPath:@"lon"];

	// get values by property
		
		EXPECTED( [me.name isEqualToString:@"gavin"] );
		EXPECTED( [me.city isEqualToString:@"beijing"] );
		EXPECTED( [me.gender isEqualToString:@"male"] );
		EXPECTED( [me.location.lat isEqualToNumber:__INT(888)] );
		EXPECTED( [me.location.lon isEqualToNumber:__INT(999)] );
		
		EXPECTED( me.JSONData );
		EXPECTED( me.JSONString );
		
	// insert
		
		me.SAVE();

	// update

		[me.JSON setObject:@"shenyang" atPath:@"city"];

		EXPECTED( [me.city isEqualToString:@"shenyang"] );
		
		me.UPDATE();
		
		EXPECTED( User2.DB.succeed );
		EXPECTED( User2.DB.total == 1 );

		
	// delete
		
		me.DELETE();
		me = nil;
		
		EXPECTED( User2.DB.succeed );
		EXPECTED( User2.DB.total == 0 );
	}
	
	TIMES( 3 )
	{
	// clear
		
		User2.DB.EMPTY();

		EXPECTED( User2.DB.succeed );
		EXPECTED( User2.DB.total == 0 );

	// create
		
		User2 * me = [User2 record];
		
		EXPECTED( me );
		EXPECTED( me.deleted == NO );
		EXPECTED( me.changed == NO );
		EXPECTED( me.inserted == NO );

		me.name = @"gavin";
		me.gender = @"male";
		me.birth = [NSDate date];
		me.city = @"beijing";
		me.location.lat = __INT(888);
		me.location.lon = __INT(999);
		
		TIMES( 3 )
		{
			me.SAVE();

			EXPECTED( User2.DB.succeed );
			EXPECTED( User2.DB.total == 1 );
		}

	// copy by record

		User2 * copy1 = [User2 record:me];

		EXPECTED( copy1 );
		EXPECTED( copy1.deleted == NO );
		EXPECTED( copy1.changed == NO );
		EXPECTED( copy1.inserted == YES );

		EXPECTED( [copy1.name isEqualToString:me.name] );
		EXPECTED( [copy1.city isEqualToString:me.city] );
		EXPECTED( [copy1.gender isEqualToString:me.gender] );
		EXPECTED( [copy1.location.lat isEqualToNumber:me.location.lat] );
		EXPECTED( [copy1.location.lon isEqualToNumber:me.location.lon] );

		copy1.SAVE();

		EXPECTED( User2.DB.succeed );
		EXPECTED( User2.DB.total == 1 );
		
	// copy by JSON

		User2 * copy2 = [User2 record:copy1.JSON];

		EXPECTED( copy2 );
		EXPECTED( copy2.deleted == NO );
		EXPECTED( copy2.changed == NO );
		EXPECTED( copy2.inserted == YES );

		EXPECTED( [copy2.name isEqualToString:me.name] );
		EXPECTED( [copy2.city isEqualToString:me.city] );
		EXPECTED( [copy2.gender isEqualToString:me.gender] );
		EXPECTED( [copy2.location.lat isEqualToNumber:me.location.lat] );
		EXPECTED( [copy2.location.lon isEqualToNumber:me.location.lon] );
		
		copy2.SAVE();
		
		EXPECTED( User2.DB.succeed );
		EXPECTED( User2.DB.total == 1 );

	// create by JSON String

		User2 * copy3 = [User2 record:copy2.JSONString];
		
		EXPECTED( copy3 );
		EXPECTED( copy3.deleted == NO );
		EXPECTED( copy3.changed == NO );
		EXPECTED( copy3.inserted == YES );
		
		EXPECTED( [copy3.name isEqualToString:me.name] );
		EXPECTED( [copy3.city isEqualToString:me.city] );
		EXPECTED( [copy3.gender isEqualToString:me.gender] );
		EXPECTED( [copy3.location.lat isEqualToNumber:me.location.lat] );
		EXPECTED( [copy3.location.lon isEqualToNumber:me.location.lon] );
		
		copy3.SAVE();
		
		EXPECTED( User2.DB.succeed );
		EXPECTED( User2.DB.total == 1 );

	// create by JSON Data
		
		User2 * copy4 = [User2 record:copy2.JSONData];
		
		EXPECTED( copy4 );
		EXPECTED( copy4.deleted == NO );
		EXPECTED( copy4.changed == NO );
		EXPECTED( copy4.inserted == YES );

		EXPECTED( [copy4.name isEqualToString:me.name] );
		EXPECTED( [copy4.city isEqualToString:me.city] );
		EXPECTED( [copy4.gender isEqualToString:me.gender] );
		EXPECTED( [copy4.location.lat isEqualToNumber:me.location.lat] );
		EXPECTED( [copy4.location.lon isEqualToNumber:me.location.lon] );
		
		copy4.SAVE();
		
		EXPECTED( User2.DB.succeed );
		EXPECTED( User2.DB.total == 1 );

	// create by String

		User2 * copy5 = [User2 record:@"{ \
							'name' : 'gavin', \
							'city' : 'beijing', \
							'gender' : 'male', \
							'location' : { 'lat' : 888, 'lid' : 100, 'lon' : 999 } \
						 }"];
		
		EXPECTED( copy5 );
		EXPECTED( copy5.deleted == NO );
		EXPECTED( copy5.changed == NO );
		EXPECTED( copy5.inserted == NO );

		EXPECTED( [copy5.name isEqualToString:@"gavin"] );
		EXPECTED( [copy5.city isEqualToString:@"beijing"] );
		EXPECTED( [copy5.gender isEqualToString:@"male"] );
		EXPECTED( [copy5.location.lat isEqualToNumber:__INT(888)] );
		EXPECTED( [copy5.location.lon isEqualToNumber:__INT(999)] );

		copy5.SAVE();
		
		EXPECTED( User2.DB.succeed );
		EXPECTED( User2.DB.total == 2 );
		
	// Query records
		
		User2.DB.GET_RECORDS();	// Results are BeeActiveRecord
		
		EXPECTED( User2.DB.succeed );
		EXPECTED( User2.DB.resultArray.count == 2 );
		EXPECTED( User2.DB.resultCount == 2 );

	// Delete records

		me.DELETE();
		copy1.DELETE();
		copy2.DELETE();
		copy3.DELETE();
		copy4.DELETE();
		copy5.DELETE();
		
	// Count records

		User2.DB.COUNT();

		NSAssert( User2.DB.succeed, @"" );
		NSAssert( User2.DB.resultCount == 0, @"" );
	}
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
