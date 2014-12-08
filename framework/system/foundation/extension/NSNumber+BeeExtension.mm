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

#import "NSNumber+BeeExtension.h"

#import "Bee_UnitTest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSNumber(BeeExtension)

@dynamic dateValue;

- (NSDate *)dateValue
{
	return [NSDate dateWithTimeIntervalSince1970:self.doubleValue];
}

- (NSString *)stringWithDateFormat:(NSString *)format
{
#if 0
	
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
	NSString * result = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self doubleValue]]];
	[dateFormatter release];
	return result;
	
#else
	
	// thanks @lancy, changed: "NSDate depend on NSNumber" to "NSNumber depend on NSDate"
	
	return [[NSDate dateWithTimeIntervalSince1970:[self doubleValue]] stringWithDateFormat:format];
	
#endif
}

- (NSString *)decimalStyleString
{
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString * result = [formatter stringFromNumber:self];
    [formatter release];
    return result;
}

- (NSString *)currencyStyleString
{
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSString * result = [formatter stringFromNumber:self];
    [formatter release];
    return result;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( NSNumber_BeeExtension )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
