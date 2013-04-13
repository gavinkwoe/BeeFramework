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
#import "Bee_UnitTest.h"

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( db )
{
	TIMES( 3 )
	{
		// open close DB
		
		[BeeDatabase closeSharedDatabase];
		EXPECTED( nil == [BeeDatabase sharedDatabase] );
		
		[BeeDatabase openSharedDatabase:@"test"];
		EXPECTED( [BeeDatabase sharedDatabase] );
	}

	TIMES( 0 )
	{
	// create table
		
		self
		.DB
		.TABLE( @"blogs" )
		.FIELD( @"id", @"INTEGER" ).PRIMARY_KEY().AUTO_INREMENT()
		.FIELD( @"type", @"TEXT" )
		.FIELD( @"date", @"TEXT" )
		.FIELD( @"content", @"TEXT" )
		.CREATE_IF_NOT_EXISTS();
		
		EXPECTED( self.DB.succeed );
		
	// index table
		
		self
		.DB
		.TABLE( @"blogs" )
		.INDEX_ON( @"id", nil );
		
		EXPECTED( self.DB.succeed );

	// empty
		
		self
		.DB
		.FROM( @"blogs" )
		.EMPTY();
		
		EXPECTED( self.DB.succeed );

	// insert
		
		self
		.DB
		.FROM( @"blogs" )
		.SET( @"type", @"Test" )
		.SET( @"date", [[NSDate date] description] )
		.SET( @"content", @"Hello, world!" )
		.INSERT();	// write once

		EXPECTED( self.DB.succeed );
		
	// delete
		
		self
		.DB
		.FROM( @"blogs" )
		.WHERE( @"id", __INT(self.DB.insertID) )
		.DELETE();
		
		EXPECTED( self.DB.succeed );
		
	// count
		
		self
		.DB
		.FROM( @"blogs" )
		.COUNT();
		
		EXPECTED( self.DB.succeed );
		EXPECTED( self.DB.resultCount == 0 );
		
	// insert 30 rows
		
		for ( NSUInteger i = 0; i < 30; ++i )
		{
			self
			.DB
			.FROM( @"blogs" )
			.SET( @"date", [[NSDate date] description] )
			.SET( @"content", [NSString stringWithFormat:@"Some content %u", i] );

			if ( 0 == (i % 3) )
			{
				self.DB.SET( @"type", @"A" );
			}
			else if ( 1 == (i % 3) )
			{
				self.DB.SET( @"type", @"B" );
			}
			else if ( 2 == (i % 3) )
			{
				self.DB.SET( @"type", @"C" );
			}

			self.DB.INSERT();

			EXPECTED( self.DB.succeed );
			EXPECTED( self.DB.insertID > 0 );
		}
		
	// count all
		
		self
		.DB
		.FROM( @"blogs" )
		.COUNT();
		
		EXPECTED( self.DB.succeed );
		EXPECTED( self.DB.resultCount == 30 );
		
	// count 'A'
		
		self
		.DB
		.FROM( @"blogs" )
		.WHERE( @"type", @"A" )
		.COUNT();
		
		EXPECTED( self.DB.succeed );
		EXPECTED( self.DB.resultCount == 10 );
		
	// query
		
		for ( NSUInteger i = 0; i < 3; ++i )
		{
			self
			.DB
			.FROM( @"blogs" )
			.OFFSET( 10 * i )
			.LIMIT( 10 )
			.GET();
			
			EXPECTED( self.DB.succeed );
			EXPECTED( self.DB.resultCount > 0 );
			EXPECTED( self.DB.resultCount == self.DB.resultArray.count );
		}
		
	// close
		
		[BeeDatabase closeSharedDatabase];
	}
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
