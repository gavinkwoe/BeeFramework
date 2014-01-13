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
//	Hypertext Transfer Protocol -- HTTP/1.1
//	http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
//

#import "Bee_Precompile.h"
#import "Bee_Foundation.h"

#pragma mark -

typedef enum
{
	BeeHTTPVersion_UNKNOWN	= 0,
	BeeHTTPVersion_9		= 9,
	BeeHTTPVersion_10		= 10,
	BeeHTTPVersion_11		= 11,
} BeeHTTPVersion;

typedef enum
{
	BeeHTTPMethod_UNKNOWN	= 0,
	BeeHTTPMethod_GET,
	BeeHTTPMethod_HEAD,
	BeeHTTPMethod_POST,
	BeeHTTPMethod_PUT,
	BeeHTTPMethod_DELETE
} BeeHTTPMethod;

typedef enum
{
	BeeHTTPStatus_CONTINUE                 =	100,
	BeeHTTPStatus_SWITCHING_PROTOCOLS      =	101,
	BeeHTTPStatus_PROCESSING               =	102,
	
	BeeHTTPStatus_OK                       =	200,
	BeeHTTPStatus_CREATED                  =	201,
	BeeHTTPStatus_ACCEPTED                 =	202,
	BeeHTTPStatus_NON_AUTH_INFORMATION     =	203,
	BeeHTTPStatus_NO_CONTENT               =	204,
	BeeHTTPStatus_RESET_CONTENT            =	205,
	BeeHTTPStatus_PARTIAL_CONTENT          =	206,
	BeeHTTPStatus_MULTI_STATUS             =	207,
	
	BeeHTTPStatus_SPECIAL_RESPONSE         =	300,
	BeeHTTPStatus_MOVED_PERMANENTLY        =	301,
	BeeHTTPStatus_MOVED_TEMPORARILY        =	302,
	BeeHTTPStatus_SEE_OTHER                =	303,
	BeeHTTPStatus_NOT_MODIFIED             =	304,
	BeeHTTPStatus_USE_PROXY                =	305,
	BeeHTTPStatus_SWITCH_PROXY             =	306,
	BeeHTTPStatus_TEMPORARY_REDIRECT       =	307,
	
	BeeHTTPStatus_BAD_REQUEST              =	400,
	BeeHTTPStatus_UNAUTHORIZED             =	401,
	BeeHTTPStatus_PAYMENT_REQUIRED         =	402,
	BeeHTTPStatus_FORBIDDEN                =	403,
	BeeHTTPStatus_NOT_FOUND                =	404,
	BeeHTTPStatus_NOT_ALLOWED              =	405,
	BeeHTTPStatus_NOT_ACCEPTABLE           =	406,
	BeeHTTPStatus_PROXY_AUTH_REQUIRED      =	407,
	BeeHTTPStatus_REQUEST_TIMEOUT          =	408,
	BeeHTTPStatus_CONFLICT                 =	409,
	BeeHTTPStatus_GONE                     =	410,
	BeeHTTPStatus_LENGTH_REQUIRED          =	411,
	BeeHTTPStatus_PRECONDITION_FAILED      =	412,
	BeeHTTPStatus_REQUEST_ENTITY_TOO_LARGE =	413,
	BeeHTTPStatus_REQUEST_URI_TOO_LARGE    =	414,
	BeeHTTPStatus_UNSUPPORTED_MEDIA_TYPE   =	415,
	BeeHTTPStatus_RANGE_NOT_SATISFIABLE    =	416,
	BeeHTTPStatus_EXPECTATION_FAILED       =	417,
	BeeHTTPStatus_TOO_MANY_CONNECTIONS     =	421,
	BeeHTTPStatus_UNPROCESSABLE_ENTITY     =	422,
	BeeHTTPStatus_LOCKED                   =	423,
	BeeHTTPStatus_FAILED_DEPENDENCY        =	424,
	BeeHTTPStatus_UNORDERED_COLLECTION     =	425,
	BeeHTTPStatus_UPGRADE_REQUIRED         =	426,
	BeeHTTPStatus_RETRY_WITH               =	449,

	BeeHTTPStatus_INTERNAL_SERVER_ERROR    =	500,
	BeeHTTPStatus_NOT_IMPLEMENTED          =	501,
	BeeHTTPStatus_BAD_GATEWAY              =	502,
	BeeHTTPStatus_SERVICE_UNAVAILABLE      =	503,
	BeeHTTPStatus_GATEWAY_TIMEOUT          =	504,
	BeeHTTPStatus_VERSION_NOT_SUPPORTED    =	505,
	BeeHTTPStatus_VARIANT_ALSO_NEGOTIATES  =	506,
	BeeHTTPStatus_INSUFFICIENT_STORAGE     =	507,
	BeeHTTPStatus_LOOP_DETECTED            =	508,
	BeeHTTPStatus_BANDWIDTH_LIMIT_EXCEEDED =	509,
	BeeHTTPStatus_NOT_EXTENED              =	510,
	
	BeeHTTPStatus_UNPARSEABLE_HEADERS      =	600
} BeeHTTPStatus;

#pragma mark -

#undef	AS_HTTP_HEADER
#define	AS_HTTP_HEADER( name ) \
		@property (nonatomic, retain) NSString * name;

#undef	DEF_HTTP_HEADER
#define	DEF_HTTP_HEADER( name, key ) \
		@dynamic name; \
		- (NSString *)name \
		{ \
			return [self.headers objectForKey:key]; \
		} \
		- (void)set##name:(NSString *)value \
		{ \
			if ( value ) \
			{ \
				if ( nil == self.headers ) \
				{ \
					self.headers = [NSMutableDictionary dictionary]; \
				} \
				[self.headers setObject:value forKey:key]; \
			} \
			else \
			{ \
				[self.headers removeObjectForKey:key]; \
			} \
		}

#pragma mark -

@interface BeeHTTPProtocol2 : NSObject

@property (nonatomic, assign) BOOL					headValid;
@property (nonatomic, assign) NSUInteger			headLength;
@property (nonatomic, retain) NSString *			headLine;
@property (nonatomic, retain) NSMutableDictionary *	headers;

@property (nonatomic, retain) NSString *			eol;
@property (nonatomic, retain) NSString *			eol2;
@property (nonatomic, assign) BOOL					eolValid;

@property (nonatomic, assign) BOOL					bodyValid;
@property (nonatomic, assign) NSUInteger			bodyOffset;
@property (nonatomic, assign) NSUInteger			bodyLength;
@property (nonatomic, retain) NSMutableData *		bodyData;

+ (NSString *)statusMessage:(BeeHTTPStatus)status;

#pragma mark -

- (NSData *)pack;
- (NSData *)packIncludeBody:(BOOL)flag;

- (BOOL)unpack:(NSData *)data;
- (BOOL)unpack:(NSData *)data includeBody:(BOOL)flag;

#pragma mark -

- (NSString *)packHead;
- (NSData *)packBody;

- (BOOL)unpackHead:(NSString *)text;
- (BOOL)unpackBody:(NSData *)data;

#pragma mark -

- (void)addHeader:(NSString *)key value:(NSString *)value;
- (void)addHeaders:(NSDictionary *)dict;
- (void)removeHeader:(NSString *)key;

@end
