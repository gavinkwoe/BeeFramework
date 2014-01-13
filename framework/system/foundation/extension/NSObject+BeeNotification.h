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

#pragma mark -

#undef	AS_NOTIFICATION
#define AS_NOTIFICATION( __name ) \
		AS_STATIC_PROPERTY( __name )

#undef	DEF_NOTIFICATION
#define DEF_NOTIFICATION( __name ) \
		DEF_STATIC_PROPERTY3( __name, @"notify", [self description] )

#undef	ON_NOTIFICATION
#define ON_NOTIFICATION( __notification ) \
		- (void)handleNotification:(NSNotification *)__notification

#undef	ON_NOTIFICATION2
#define ON_NOTIFICATION2( __filter, __notification ) \
		- (void)handleNotification_##__filter:(NSNotification *)__notification

#undef	ON_NOTIFICATION3
#define ON_NOTIFICATION3( __class, __name, __notification ) \
		- (void)handleNotification_##__class##_##__name:(NSNotification *)__notification

#pragma mark -

@interface NSNotification(BeeNotification)

- (BOOL)is:(NSString *)name;
- (BOOL)isKindOf:(NSString *)prefix;

@end

#pragma mark -

@interface NSObject(BeeNotification)

+ (NSString *)NOTIFICATION;
+ (NSString *)NOTIFICATION_TYPE;

- (void)handleNotification:(NSNotification *)notification;

- (void)observeNotification:(NSString *)name;
- (void)observeAllNotifications;

- (void)unobserveNotification:(NSString *)name;
- (void)unobserveAllNotifications;

+ (BOOL)postNotification:(NSString *)name;
+ (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object;

- (BOOL)postNotification:(NSString *)name;
- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object;

@end
