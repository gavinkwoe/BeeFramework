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
//  Bee_Keychain.h
//

#import "Bee_Precompile.h"
#import "Bee_Keychain.h"

#pragma mark -

#undef	DEFAULT_DOMAIN
#define DEFAULT_DOMAIN	@"BeeKeychain"

@implementation BeeKeychain

static NSString * __defaultDomain = nil;

+ (void)setDefaultDomain:(NSString *)domain
{
	[domain retain];
	[__defaultDomain release];
	__defaultDomain = domain;
}

+ (NSString *)readValueForKey:(NSString *)key
{
	return [BeeKeychain readValueForKey:key andDomain:__defaultDomain];
}

+ (NSString *)readValueForKey:(NSString *)key andDomain:(NSString *)domain
{
	if ( nil == key )
		return nil;
	
	if ( nil == domain )
	{
		domain = __defaultDomain;
		if ( nil == domain )
		{
			domain = DEFAULT_DOMAIN;
		}
	}

	NSArray * keys = [[[NSArray alloc] initWithObjects: (NSString *) kSecClass, kSecAttrAccount, kSecAttrService, nil] autorelease];
	NSArray * objects = [[[NSArray alloc] initWithObjects: (NSString *) kSecClassGenericPassword, key, domain, nil] autorelease];
	
	NSMutableDictionary * query = [[[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];
	NSMutableDictionary * attributeQuery = [query mutableCopy];
	[attributeQuery setObject: (id) kCFBooleanTrue forKey:(id) kSecReturnAttributes];
	
	NSDictionary * attributeResult = NULL;
	OSStatus status = SecItemCopyMatching( (CFDictionaryRef)attributeQuery, (CFTypeRef *)&attributeResult );
	
	[attributeResult release];
	[attributeQuery release];
	
	if ( noErr != status )
		return nil;
	
	NSMutableDictionary * passwordQuery = [query mutableCopy];
	[passwordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
	
	NSData * resultData = nil;
	status = SecItemCopyMatching( (CFDictionaryRef)passwordQuery, (CFTypeRef *)&resultData );

	[resultData autorelease];
	[passwordQuery release];
	
	if ( noErr != status )
		return nil;
	
	if ( nil == resultData )
		return nil;
	
	NSString * password = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];	
	return [password autorelease];
}

+ (void)writeValue:(NSString *)value forKey:(NSString *)key
{
	[BeeKeychain writeValue:value forKey:key andDomain:__defaultDomain];
}

+ (void)writeValue:(NSString *)value forKey:(NSString *)key andDomain:(NSString *)domain
{
	if ( nil == key || nil == value )
		return;

	if ( nil == domain )
	{
		domain = __defaultDomain;
		if ( nil == domain )
		{
			domain = DEFAULT_DOMAIN;
		}
	}

	NSString * password = [BeeKeychain readValueForKey:key andDomain:domain];	
	if ( password ) 
	{
		if ( [password isEqualToString:value] )
			return;

		NSArray * keys = [[[NSArray alloc] initWithObjects:(NSString *)kSecClass, kSecAttrService, kSecAttrLabel, kSecAttrAccount, nil] autorelease];
		NSArray * objects = [[[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword, domain, domain, key, nil] autorelease];			
		
		NSDictionary * query = [[[NSDictionary alloc] initWithObjects:objects forKeys:keys] autorelease];			
		SecItemUpdate( (CFDictionaryRef)query, (CFDictionaryRef)[NSDictionary dictionaryWithObject:[value dataUsingEncoding:NSUTF8StringEncoding] forKey:(NSString *)kSecValueData] );
	}
	else 
	{
		NSArray * keys = [[[NSArray alloc] initWithObjects:(NSString *)kSecClass, kSecAttrService, kSecAttrLabel, kSecAttrAccount, kSecValueData, nil] autorelease];
		NSArray * objects = [[[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword, domain, domain, key, [value dataUsingEncoding:NSUTF8StringEncoding], nil] autorelease];
		
		NSDictionary * query = [[[NSDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];			
		SecItemAdd( (CFDictionaryRef)query, NULL);
	}
}

+ (void)deleteValueForKey:(NSString *)key
{
	[BeeKeychain deleteValueForKey:key andDomain:__defaultDomain];
}

+ (void)deleteValueForKey:(NSString *)key andDomain:(NSString *)domain
{
	if ( nil == key )
		return;
	
	if ( nil == domain )
	{
		domain = __defaultDomain;
		if ( nil == domain )
		{
			domain = DEFAULT_DOMAIN;
		}
	}

	NSArray * keys = [[[NSArray alloc] initWithObjects:(NSString *)kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnAttributes, nil] autorelease];
	NSArray * objects = [[[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword, key, domain, kCFBooleanTrue, nil] autorelease];
	
	NSDictionary * query = [[[NSDictionary alloc] initWithObjects:objects forKeys:keys] autorelease];	
	SecItemDelete( (CFDictionaryRef)query );
}

@end
