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
//  NSObject+BeeProperty.m
//

#import "Bee_Precompile.h"

#import "NSDate+BeeExtension.h"
#import "NSNumber+BeeExtension.h"

#pragma mark -

@implementation NSDate(BeeExtension)

@dynamic string;
@dynamic number;

- (NSString *)string
{
	return self.description;
}

- (NSNumber *)number
{
	return [NSNumber numberWithDouble:self.timeIntervalSince1970];
}

- (NSString *)stringWithDateFormat:(NSString *)format
{
#if 0
	
	NSTimeInterval time = [self timeIntervalSince1970];
	NSUInteger timeUint = (NSUInteger)time;
	return [[NSNumber numberWithUnsignedInteger:timeUint] stringWithDateFormat:format];
	
#else
	
	// thansk @lancy, changed: "NSDate depend on NSNumber" to "NSNumber depend on NSDate"
	
	NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:format];
	return [dateFormatter stringFromDate:self];
	
#endif
}

+ (NSUInteger)timeStamp
{
	NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate];
	return (NSUInteger)(time * 1000.0f);
}

+ (NSDate *)dateWithString:(NSString *)string
{
    NSDateFormatter * dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone localTimeZone]];
    //    [dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate * date = nil;
    NSString * regDateAndTimeString = @"^(\\d{4})([/-])(\\d{2})([/-])(\\d{2}) (\\d{2}):(\\d{2})(:)(\\d{2})$";
    NSString * regDateString = @"(\\d{4})([/-])(\\d{2})([/-])(\\d{2})";
    NSString * regTimeString = @"(\\d{2}):(\\d{2})(:)(\\d{2})";
    //date and time
    NSRegularExpression * reg = [NSRegularExpression regularExpressionWithPattern:regDateAndTimeString
                                                                          options:NSRegularExpressionCaseInsensitive
                                                                            error:nil];
    if ([reg numberOfMatchesInString:string
                             options:NSMatchingReportProgress
                               range:NSMakeRange(0, string.length)] > 0)
    {
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    //date
    reg = [NSRegularExpression regularExpressionWithPattern:regDateString
                                                    options:NSRegularExpressionCaseInsensitive
                                                      error:nil];
    if ([reg numberOfMatchesInString:string
                             options:NSMatchingReportProgress
                               range:NSMakeRange(0, string.length)] > 0)
    {
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    //time
    reg = [NSRegularExpression regularExpressionWithPattern:regTimeString
                                                    options:NSRegularExpressionCaseInsensitive
                                                      error:nil];
    if ([reg numberOfMatchesInString:string
                             options:NSMatchingReportProgress
                               range:NSMakeRange(0, string.length)] > 0)
    {
        [dateformatter setDateFormat:@"HH:mm:ss"];
    }
    date = [dateformatter dateFromString:string];
    SAFE_RELEASE( dateformatter );
    
    return date;

//	return nil;
}

@end
