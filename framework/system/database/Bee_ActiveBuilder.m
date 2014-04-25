//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
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

#import "Bee_Precompile.h"
#import "Bee_ActiveBuilder.h"
#import "Bee_ActiveObject.h"
#import "Bee_ActiveProtocol.h"

#import "Bee_Database.h"
#import "NSObject+BeeDatabase.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface BeeActiveBuilder()
{
	NSMutableDictionary * _builtFlags;
}

AS_SINGLETON( BeeActiveBuilder )

@end

#pragma mark -

@implementation BeeActiveBuilder

DEF_SINGLETON( BeeActiveBuilder )

+ (void)load
{
	[BeeActiveBuilder sharedInstance];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		_builtFlags = [[NSMutableDictionary alloc] init];

		[self observeNotification:BeeDatabase.SHARED_DB_OPEN];
		[self observeNotification:BeeDatabase.SHARED_DB_CLOSE];
	}
	return self;
}

- (void)dealloc
{
	[self unobserveAllNotifications];

	[_builtFlags release];
	
	[super dealloc];
}

+ (void)buildTableFor:(Class)clazz
{
	[[BeeActiveBuilder sharedInstance] buildTableFor:clazz untilRootClass:[NSObject class]];
}

+ (void)buildTableFor:(Class)clazz untilRootClass:(Class)rootClass
{
	[[BeeActiveBuilder sharedInstance] buildTableFor:clazz untilRootClass:rootClass];
}

- (void)buildTableFor:(Class)clazz untilRootClass:(Class)rootClass
{
	NSString * className = [clazz description];
	NSNumber * builtFlag = [_builtFlags objectForKey:className];
	if ( builtFlag && builtFlag.boolValue )
		return;

// Step1, map relation between property and field

	[clazz mapRelation];

// Step2, create table
	
	[NSObject DB].TABLE( clazz.tableName );
	[NSObject DB].FIELD( clazz.activePrimaryKey, @"INTEGER" ).UNIQUE().PRIMARY_KEY();

	if ( [clazz usingAutoIncrement] )
	{
		[NSObject DB].AUTO_INREMENT();
	}

	if ( [clazz usingJSON] )
	{
		[NSObject DB]
		.TABLE( clazz.tableName )
		.FIELD( clazz.activeJSONKey, @"TEXT" ).DEFAULT( @"" );
	}

	NSDictionary * propertySet = clazz.activePropertySet;
	if ( propertySet && propertySet.count )
	{
		for ( Class clazzType = clazz; clazzType != rootClass; )
		{
			unsigned int		propertyCount = 0;
			objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );

			for ( NSUInteger i = 0; i < propertyCount; i++ )
			{
				const char *	name = property_getName(properties[i]);
				NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
				
				NSMutableDictionary * property = [propertySet objectForKey:propertyName];
				if ( property )
				{
					const char *	attr = property_getAttributes(properties[i]);
					NSUInteger		type = [BeeTypeEncoding typeOf:attr];
					
					NSString *		field = [property objectForKey:@"field"];
					NSObject *		value = [property objectForKey:@"value"];
					
					if ( BeeTypeEncoding.NSNUMBER == type )
					{
						[NSObject DB].FIELD( field, @"INTEGER" );
					}
					else if ( BeeTypeEncoding.NSSTRING == type )
					{
						[NSObject DB].FIELD( field, @"TEXT" );
					}
					else if ( BeeTypeEncoding.NSDATE == type )
					{
						[NSObject DB].FIELD( field, @"TEXT" );
					}
					else if ( BeeTypeEncoding.NSDICTIONARY == type )
					{
						[NSObject DB].FIELD( field, @"TEXT" );			// save as JSON
					}
					else if ( BeeTypeEncoding.NSARRAY == type )
					{
						[NSObject DB].FIELD( field, @"TEXT" );			// save as "id,id,id" or JSON
					}
					else if ( BeeTypeEncoding.OBJECT == type )
					{
						Class fieldClass = [BeeTypeEncoding classOfAttribute:attr];
						if ( [fieldClass isSubclassOfClass:rootClass] )
						{
							[NSObject DB].FIELD( field, @"INTEGER" );	// save as primary ID
						}
						else
						{
							[NSObject DB].FIELD( field, @"TEXT" );		// save as JSON
						}
					}
					else
					{
						[NSObject DB].FIELD( field, @"INTEGER" );
					}

					if ( [clazzType usingAutoIncrementForProperty:field] )
					{
						[NSObject DB].AUTO_INREMENT();
					}
					
					if ( [clazzType usingUniqueForProperty:field] )
					{
						[NSObject DB].UNIQUE();
					}

					if ( value && NO == [value isKindOfClass:[BeeNonValue class]] )
					{
						[NSObject DB].DEFAULT( value );
					}

					[property setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
				}
			}

			free( properties );
			
			clazzType = class_getSuperclass( clazzType );
			if ( nil == clazzType )
				break;
		}
	}

	[NSObject DB].CREATE_IF_NOT_EXISTS();

// Step3, do migration if needed

// TODO:
//	"pragma table_info(\"test\")";
//	"alter table \"test\" add column name";

// Step4, create index

	[NSObject DB].TABLE( clazz.tableName ).INDEX_ON( clazz.activePrimaryKey, nil );

	[_builtFlags setObject:[NSNumber numberWithBool:YES] forKey:className];
}

+ (BOOL)isTableBuiltFor:(Class)clazz
{
	return [[BeeActiveBuilder sharedInstance] isTableBuiltFor:clazz];
}

- (BOOL)isTableBuiltFor:(Class)clazz
{
	NSString * className = [clazz description];

	NSNumber * builtFlag = [_builtFlags objectForKey:className];	
	if ( builtFlag && builtFlag.boolValue )
	{
		return YES;
	}

	return NO;
}

- (void)handleNotification:(NSNotification *)notice
{
	if ( [notice is:BeeDatabase.SHARED_DB_OPEN] )
	{
		// TODO:
	}
	else if ( [notice is:BeeDatabase.SHARED_DB_CLOSE] )
	{
		[_builtFlags removeAllObjects];
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( BeeActiveBuilder )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
