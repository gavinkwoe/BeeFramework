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
//  NSData+BeeExtension.m
//

#import <CommonCrypto/CommonDigest.h>

#import "Bee_Precompile.h"
#import "NSData+BeeExtension.h"

#pragma mark -

@implementation NSData(BeeExtension)

@dynamic string;
@dynamic MD5;
@dynamic MD5String;

- (NSString *)string
{
	return [[[NSString alloc] initWithData:self encoding:NSStringEncodingConversionAllowLossy] autorelease];
}

- (NSData *)MD5
{
	unsigned char md5Result[CC_MD5_DIGEST_LENGTH + 1];
	CC_MD5( [self bytes], [self length], md5Result );
	
	NSMutableData * retData = [[[NSMutableData alloc] init] autorelease];
	if ( nil == retData )
		return nil;
	
	[retData appendBytes:md5Result length:CC_MD5_DIGEST_LENGTH];
	return retData;
}

- (NSString *)MD5String
{
	NSData * value = [self MD5];
	if ( value )
	{
		char			tmp[16];
		unsigned char *	hex = (unsigned char *)malloc( 2048 + 1 );
		unsigned char *	bytes = (unsigned char *)[value bytes];
		unsigned long	length = [value length];
		
		hex[0] = '\0';
		
		for ( unsigned long i = 0; i < length; ++i )
		{
			sprintf( tmp, "%02X", bytes[i] );
			strcat( (char *)hex, tmp );
		}
		
		NSString * result = [NSString stringWithUTF8String:(const char *)hex];
		free( hex );
		return result;
	}
	else
	{
		return nil;
	}
}

@end
