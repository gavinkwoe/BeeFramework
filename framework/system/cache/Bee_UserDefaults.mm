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

#import "Bee_UserDefaults.h"
#import "Bee_SystemConfig.h"
#import "Bee_SystemPackage.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( BeePackage_System, BeeUserDefaults, userDefaults );

#pragma mark -

@implementation BeeUserDefaults

DEF_SINGLETON( BeeUserDefaults )

- (BOOL)hasObjectForKey:(id)key
{
	id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	return value ? YES : NO;
}

- (id)objectForKey:(NSString *)key
{
	if ( nil == key )
		return nil;
	
	id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	return value;
}

- (void)setObject:(id)value forKey:(NSString *)key
{
	if ( nil == key || nil == value )
		return;

	[[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeObjectForKey:(NSString *)key
{
	if ( nil == key )
		return;
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeAllObjects
{
	[NSUserDefaults resetStandardUserDefaults];
}

- (id)objectForKeyedSubscript:(id)key
{
	return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	if ( obj )
	{
		[self setObject:obj forKey:key];
	}
	else
	{
		[self removeObjectForKey:key];
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( BeeUserDefaults )
{
	// TODO:
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
