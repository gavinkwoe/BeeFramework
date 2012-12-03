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
//  Bee_DatabaseTest.h
//

#import "Bee_Log.h"
#import "Bee_Database.h"
#import "Bee_ActiveRecordTest.h"

#import "NSNumber+BeeExtension.h"

#pragma mark -

@interface UserInfo : BeeActiveRecord
{
	NSNumber *	_uid;
	NSString *	_name;
	NSString *	_gender;
	NSString *	_city;
}

@property (nonatomic, retain) NSNumber *	uid;
@property (nonatomic, retain) NSString *	name;
@property (nonatomic, retain) NSString *	gender;
@property (nonatomic, retain) NSString *	city;

@end

#pragma mark -

@implementation UserInfo

@synthesize uid = _uid;
@synthesize name = _name;
@synthesize gender = _gender;
@synthesize city = _city;

+ (void)mapRelation
{
	[self mapPropertyAsKey:@"uid"];		
	[self mapProperty:@"name"];
	[self mapProperty:@"gender"	defaultValue:@"-"];
	[self mapProperty:@"city"	defaultValue:@"Beijing"];
}

- (void)load
{
	[super load];
}

- (void)unload
{
	self.uid = nil;
	self.name = nil;
	self.gender = nil;

	[super unload];
}

@end

#pragma mark -

@implementation BeeActiveRecordTest

+ (void)testViaDB
{
	// Clear table
	UserInfo.DB.EMPTY();
	
	// Insert 2 records into table 'table_userinfo'
	UserInfo.DB
			.SET( @"name", @"gavin" )
			.SET( @"gender", @"male" )
			.INSERT();
	
	UserInfo.DB
			.SET( @"name", @"amanda" )
			.SET( @"gender", @"female" )
			.SET( @"city", @"Columbus" )
			.INSERT();
	
	// Update records
	UserInfo.DB
			.WHERE( @"name", @"gavin" )
			.SET( @"city", @"Columbus" )
			.UPDATE();
	
	// Query records
	UserInfo.DB
			.WHERE( @"city", @"Columbus" )
			.LIMIT( 10 )
			.GET();	// Results are NSDictionary
	NSAssert( UserInfo.DB.succeed, @"" );
	NSAssert( UserInfo.DB.resultCount == 2, @"" );

	for ( NSDictionary * dict in UserInfo.DB.resultArray )
	{
		VAR_DUMP( dict );
	}
	
	// Delete records
	UserInfo.DB
			.WHERE( @"city", @"Columbus" )
			.DELETE();
	
	// Count records
	UserInfo.DB
			.LIMIT( 10 )
			.COUNT();
	NSAssert( UserInfo.DB.succeed, @"" );
	NSAssert( UserInfo.DB.resultCount == 0, @"" );
}

+ (void)testViaObject
{
	// Clear table
	UserInfo.DB.EMPTY();

	// Insert 2 records into table 'table_userinfo'
	UserInfo * record1 = [[UserInfo alloc] init];
	if ( record1 )
	{
		record1.name = @"gavin";
		record1.gender = @"male";
		record1.INSERT();		
	}

	UserInfo * record2 = [[UserInfo alloc] init];
	if ( record2 )
	{
		record2.name = @"amanda";
		record2.gender = @"female";
		record2.city = @"Columbus";
		record2.INSERT();		
	}

	// Update records
	record1.city = @"Columbus";
	record1.UPDATE();

	// Query records
	UserInfo.DB
		.WHERE( @"city", @"Columbus" )
		.LIMIT( 10 )
		.GET_RECORDS();	// Results are BeeActiveRecord
	NSAssert( UserInfo.DB.succeed, @"" );
	NSAssert( UserInfo.DB.resultCount == 2, @"" );
	
	for ( UserInfo * info in UserInfo.DB.resultArray )
	{
		VAR_DUMP( info );
	}

	// Delete records
	record1.DELETE();
	[record1 release];

	record2.DELETE();
	[record2 release];
	
	// Count records
	UserInfo.DB
			.LIMIT( 10 )
			.COUNT();
	NSAssert( UserInfo.DB.succeed, @"" );
	NSAssert( UserInfo.DB.resultCount == 0, @"" );
}

+ (void)run
{
	if ( [BeeDatabase openSharedDatabase:@"my.db"] )
	{
		[self testViaDB];
		[self testViaObject];		
	}
}

@end
