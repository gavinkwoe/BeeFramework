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

#import "Bee.h"

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE(BeeDatabase)
{
	// 尝试在默认路径中打开数据库my.db
	if ( [BeeDatabase openSharedDatabase:@"my.db"] )
	{
		// Create and table named 'blogs', consists of 4 fields, 'id'、'type'、'date'、'content'
		self.DB
		.TABLE( @"blogs" )
		.FIELD( @"id", @"INTEGER" ).PRIMARY_KEY().AUTO_INREMENT()
		.FIELD( @"type", @"TEXT" )
		.FIELD( @"date", @"TEXT" )
		.FIELD( @"content", @"TEXT" )
		.CREATE_IF_NOT_EXISTS();
		NSAssert( self.DB.succeed, nil );
		
		// Create an index on 'blogs.id'
		self.DB
		.TABLE( @"blogs" )
		.INDEX_ON( @"id", nil );
		NSAssert( self.DB.succeed, nil );
		
		// Clear 'blogs'
		self.DB
		.FROM( @"blogs" )
		.EMPTY();
		NSAssert( self.DB.succeed, nil );
		
		// Try to insert 1 row
		self.DB
		.FROM( @"blogs" )
		.SET( @"type", @"Test" )
		.SET( @"date", [[NSDate date] description] )
		.SET( @"content", @"Hello, world!" )
		.INSERT();	// write once
		NSAssert( self.DB.succeed, nil );
		
		// Try to delete 1 row
		self.DB
		.FROM( @"blogs" )
		.WHERE( @"id", __INT(self.DB.insertID) )
		.DELETE();
		NSAssert( self.DB.succeed, nil );
		
		// Count all
		self.DB
		.FROM( @"blogs" )
		.COUNT();
		NSAssert( self.DB.succeed, nil );
		NSAssert( self.DB.resultCount == 0, nil );
		
		// Try to insert 30 rows with different 'type's
		for ( NSUInteger i = 0; i < 30; ++i )
		{
			self.DB
			.FROM( @"blogs" )
			.SET( @"date", [[NSDate date] description] )
			.SET( @"content", [NSString stringWithFormat:@"Some content %u", i] );
			
			if ( 0 == (i % 3) )
			{
				self.DB
				.SET( @"type", @"ObjC" );
			}
			else if ( 1 == (i % 3) )
			{
				self.DB
				.SET( @"type", @"MacOS" );
			}
			else if ( 2 == (i % 3) )
			{
				self.DB
				.SET( @"type", @"iOS" );
			}
			
			// Insert
			self.DB
			.INSERT();	// write once
			NSAssert( self.DB.succeed, nil );
			NSAssert( self.DB.insertID > 0, nil );
			
			// Update 'content' with new 'id'
			self.DB
			.FROM( @"blogs" )
			.WHERE( @"id", __INT(self.DB.insertID) )
			.SET( @"content", [NSString stringWithFormat:@"Some content %u", self.DB.insertID] )
			.UPDATE();
			NSAssert( self.DB.succeed, nil );
		}
		
		// Count all
		self.DB
		.FROM( @"blogs" )
		.COUNT();
		NSAssert( self.DB.succeed, nil );
		NSAssert( self.DB.resultCount == 30, nil );
		
		// Count how many rows' 'type' is 'ObjC' there
		self.DB
		.FROM( @"blogs" )
		.WHERE( @"type", @"ObjC" )
		.COUNT();
		NSAssert( self.DB.succeed, nil );
		NSAssert( self.DB.resultCount == 10, nil );
		
		// Query all rows by 3 pages
		for ( NSUInteger i = 0; i < 3; ++i )
		{
			self.DB
			.FROM( @"blogs" )
			.OFFSET( 10 * i )
			.LIMIT( 10 )
			.GET();
			NSAssert( self.DB.succeed, nil );
			NSAssert( self.DB.resultCount > 0, nil );
			NSAssert( self.DB.resultCount == self.DB.resultArray.count, nil );
			
			VAR_DUMP( self.DB.resultArray );
		}
		
		[BeeDatabase closeSharedDatabase];
	}
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
