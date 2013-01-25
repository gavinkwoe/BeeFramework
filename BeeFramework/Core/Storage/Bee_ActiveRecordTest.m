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

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

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

@interface User : BeeActiveRecord

@property (nonatomic, retain) NSNumber *	uid;
@property (nonatomic, retain) NSString *	name;
@property (nonatomic, retain) NSString *	gender;
@property (nonatomic, retain) NSString *	city;
@property (nonatomic, retain) NSDate *		birth;

@end

#pragma mark -

@implementation User

@synthesize uid;
@synthesize name;
@synthesize gender;
@synthesize city;
@synthesize birth;

+ (void)mapRelation
{
	[super mapRelation];
	[super useJSON];
	[super useAutoIncrement];
}

@end

#pragma mark -

@interface User2 : User

@property (nonatomic, retain) Location *	location;

@end

#pragma mark -

@implementation User2

@synthesize location;

@end

#pragma mark -

TEST_CASE(BeeActiveRecord_BeeDatabase)
{
	// Clear table
	
	User2.DB.EMPTY();
	
	// Insert 2 records into table 'table_User2'
	
	User2.DB
	.SET( @"name", @"gavin" )
	.SET( @"gender", @"male" )
	.INSERT();
	
	User2.DB
	.SET( @"name", @"amanda" )
	.SET( @"gender", @"female" )
	.SET( @"city", @"Columbus" )
	.SET( @"birth", [NSDate date] )
	.INSERT();
	
	// Update records
	
	User2.DB
	.WHERE( @"name", @"gavin" )
	.SET( @"city", @"Columbus" )
	.UPDATE();
	
	// Query records
	
	User2.DB.WHERE( @"city", @"Columbus" ).GET();	// Results are NSDictionary
	NSAssert( User2.DB.succeed, @"" );
	NSAssert( User2.DB.resultCount == 2, @"" );
	
	for ( NSDictionary * dict in User2.DB.resultArray )
	{
		VAR_DUMP( dict );
	}

	// Delete records
	
	User2.DB.WHERE( @"city", @"Columbus" ).DELETE();
	
	// Count records
	
	User2.DB.COUNT();
	NSAssert( User2.DB.succeed, @"" );
	NSAssert( User2.DB.resultCount == 0, @"" );
}
TEST_CASE_END

#pragma mark -

TEST_CASE(BeeActiveRecord)
{
// Clear table

	User2.DB.EMPTY();

// test
	
	User2 * me;
	User2 * copy;

	me = [User2 record];
	me.name = @"gavin";			// set value by property
	me.city = @"beijing";		// set value by property
	me.location.lat = __INT(888);
	me.location.lon = __INT(999);
	[me.JSON setObject:@"m" forKey:@"gender"];							// set value by JSON
	[me.JSON setObject:[[NSDate date] description] forKey:@"birth"];	// set value by JSON
	me.SAVE();

	User2.DB.GET_RECORDS();	// Results are BeeActiveRecord
	for ( User2 * info in User2.DB.resultArray )
	{
		VAR_DUMP( info );
	}
	
	NSAssert( [me.name isEqualToString:@"gavin"], @"" );							// get value by property
	NSAssert( [me.city isEqualToString:@"beijing"], @"" );							// get value by property
	NSAssert( [me.gender isEqualToString:@"m"], @"" );								// get value by property
	NSAssert( [me.location.lat isEqualToNumber:__INT(888)], @"" );
	NSAssert( [me.location.lon isEqualToNumber:__INT(999)], @"" );

	NSAssert( [[me.JSON objectForKey:@"name"] isEqualToString:@"gavin"], @"" );		// get value by JSON
	NSAssert( [[me.JSON objectForKey:@"city"] isEqualToString:@"beijing"], @"" );	// get value by JSON
	NSAssert( [[me.JSON objectForKey:@"gender"] isEqualToString:@"m"], @"" );		// get value by JSON
	NSAssert( [[me.JSON numberAtPath:@"location.lat"] isEqualToNumber:__INT(888)], @"" );	// get value by JSON
	NSAssert( [[me.JSON numberAtPath:@"location.lon"] isEqualToNumber:__INT(999)], @"" );		// get value by JSON

	VAR_DUMP( me.JSON );		// convert object to JSON object
	VAR_DUMP( me.JSONString );	// convert object to JSON string
	VAR_DUMP( me.JSONData );	// convert object to JSON data

// create by ActiveRecord

	copy = [User2 record:me];
	NSAssert( [copy.name isEqualToString:me.name], @"" );
	NSAssert( [copy.city isEqualToString:me.city], @"" );
	NSAssert( [copy.gender isEqualToString:me.gender], @"" );
	NSAssert( [copy.location.lat isEqualToNumber:__INT(888)], @"" );
	NSAssert( [copy.location.lon isEqualToNumber:__INT(999)], @"" );
	copy.SAVE();
	copy.DELETE();

	User2.DB.GET_RECORDS();	// Results are BeeActiveRecord
	for ( User2 * info in User2.DB.resultArray )
	{
		VAR_DUMP( info );
	}
	
// create by JSON

	copy = [User2 record:me.JSON];
	NSAssert( [copy.name isEqualToString:me.name], @"" );
	NSAssert( [copy.city isEqualToString:me.city], @"" );
	NSAssert( [copy.gender isEqualToString:me.gender], @"" );
	NSAssert( [copy.location.lat isEqualToNumber:__INT(888)], @"" );
	NSAssert( [copy.location.lon isEqualToNumber:__INT(999)], @"" );
	copy.SAVE();
	copy.DELETE();

	User2.DB.GET_RECORDS();	// Results are BeeActiveRecord
	for ( User2 * info in User2.DB.resultArray )
	{
		VAR_DUMP( info );
	}
	
// create by JSON String

	copy = [User2 record:me.JSONString];
	NSAssert( [copy.name isEqualToString:me.name], @"" );
	NSAssert( [copy.city isEqualToString:me.city], @"" );
	NSAssert( [copy.gender isEqualToString:me.gender], @"" );
	NSAssert( [copy.location.lat isEqualToNumber:__INT(888)], @"" );
	NSAssert( [copy.location.lon isEqualToNumber:__INT(999)], @"" );
	copy.SAVE();
	copy.DELETE();

	User2.DB.GET_RECORDS();	// Results are BeeActiveRecord
	for ( User2 * info in User2.DB.resultArray )
	{
		VAR_DUMP( info );
	}
	
// create by JSON Data

	copy = [User2 record:me.JSONData];
	NSAssert( [copy.name isEqualToString:me.name], @"" );
	NSAssert( [copy.city isEqualToString:me.city], @"" );
	NSAssert( [copy.gender isEqualToString:me.gender], @"" );
	NSAssert( [copy.location.lat isEqualToNumber:__INT(888)], @"" );
	NSAssert( [copy.location.lon isEqualToNumber:__INT(999)], @"" );
	copy.SAVE();
	copy.DELETE();

	User2.DB.GET_RECORDS();	// Results are BeeActiveRecord
	for ( User2 * info in User2.DB.resultArray )
	{
		VAR_DUMP( info );
	}
	
// create by String

	copy = [User2 record:@"{ \
			'name' : 'gavin', \
			'city' : 'beijing', \
			'gender' : 'm', \
			'location' : { 'lat' : 888, 'lid' : 100, 'lon' : 999 } \
			}"];
	NSAssert( [copy.name isEqualToString:me.name], @"" );
	NSAssert( [copy.city isEqualToString:me.city], @"" );
	NSAssert( [copy.gender isEqualToString:me.gender], @"" );
	NSAssert( [copy.location.lat isEqualToNumber:__INT(888)], @"" );
	NSAssert( [copy.location.lon isEqualToNumber:__INT(999)], @"" );
	copy.SAVE();
	copy.DELETE();

	User2.DB.GET_RECORDS();	// Results are BeeActiveRecord
	for ( User2 * info in User2.DB.resultArray )
	{
		VAR_DUMP( info );
	}
	
	me.DELETE();
	
	User2.DB.GET_RECORDS();	// Results are BeeActiveRecord
	for ( User2 * info in User2.DB.resultArray )
	{
		VAR_DUMP( info );
	}
	
// Insert 2 records into table 'table_User2'

	User2 * record1 = [User2 record];
	record1.name = @"gavin";
	record1.gender = @"male";
	record1.SAVE();

	VAR_DUMP( record1.JSON );
	VAR_DUMP( record1.JSONString );
	VAR_DUMP( record1.JSONData );
	
	[record1.JSON setObject:@"1234" forKey:@"undefinedKey"];
	[record1.JSON setObject:@"gavin.kwoe" forKey:@"name"];
	
	record1.city = @"Columbus";
	record1.SAVE();

	User2 * record2 = [User2 record];
	record2.name = @"amanda";
	record2.gender = @"female";
	record2.city = @"Columbus";
	record2.birth = [NSDate date];
	record2.SAVE();

	
// Query records
	
	User2.DB.GET_RECORDS();	// Results are BeeActiveRecord
	NSAssert( User2.DB.succeed, @"" );
	NSAssert( User2.DB.resultCount > 0, @"" );

	for ( User2 * info in User2.DB.resultArray )
	{
		VAR_DUMP( info );
	}

	User2.DB.WHERE( @"city", @"Columbus" ).GET_RECORDS(); // Results are BeeActiveRecord
	NSAssert( User2.DB.succeed, @"" );
	NSAssert( User2.DB.resultCount > 0, @"" );
	
	for ( User2 * info in User2.DB.resultArray )
	{
		VAR_DUMP( info );
	}

// Delete records

	record1.DELETE();
	record2.DELETE();

	User2.DB.GET_RECORDS();	// Results are BeeActiveRecord
//	NSAssert( User2.DB.succeed, @"" );
//	NSAssert( User2.DB.resultCount == 0, @"" );
	
	for ( User2 * info in User2.DB.resultArray )
	{
		VAR_DUMP( info );
	}
	
// Count records

	User2.DB.COUNT();
	NSAssert( User2.DB.succeed, @"" );
	NSAssert( User2.DB.resultCount == 0, @"" );
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
