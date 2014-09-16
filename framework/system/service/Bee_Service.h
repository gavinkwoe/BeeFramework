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
#import "Bee_Package.h"
#import "Bee_Foundation.h"
#import "Bee_SystemConfig.h"
#import "Bee_SystemPackage.h"

#pragma mark -

AS_PACKAGE_( BeePackage, BeePackage_Service, services );

#pragma mark -

@class BeeService;

typedef	void	(^BeeServiceBlock)( void );
typedef	void	(^BeeServiceBlockN)( id first, ... );

#pragma mark -

#undef	AS_SERVICE
#define	AS_SERVICE( __class, __name ) \
		AS_PACKAGE( BeePackage_Service, __class, __name )

#undef	DEF_SERVICE
#define	DEF_SERVICE( __class, __name ) \
		DEF_PACKAGE( BeePackage_Service, __class, __name )

#undef	AS_SUB_SERVICE
#define	AS_SUB_SERVICE( __parent, __class, __name ) \
		AS_PACKAGE( __parent, __class, __name )

#undef	DEF_SUB_SERVICE
#define	DEF_SUB_SERVICE( __parent, __class, __name ) \
		DEF_PACKAGE( __parent, __class, __name )

#pragma mark -

#undef	SERVICE_AUTO_LOADING
#define SERVICE_AUTO_LOADING( __flag ) \
		+ (BOOL)serviceAutoLoading { return __flag; }

#undef	SERVICE_AUTO_POWERON
#define SERVICE_AUTO_POWERON( __flag ) \
		+ (BOOL)serviceAutoPowerOn { return __flag; }

#pragma mark -

@protocol BeeServiceExecutor<NSObject>

- (void)powerOn;
- (void)powerOff;

- (void)serviceWillActive;
- (void)serviceDidActived;
- (void)serviceWillDeactive;
- (void)serviceDidDeactived;

@end

#pragma mark -

@interface BeeService : NSObject<BeeServiceExecutor>

@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSBundle *			bundle;
@property (nonatomic, retain) NSDictionary *		launchParameters;

@property (nonatomic, readonly) BOOL				running;
@property (nonatomic, readonly) BOOL				activating;

@property (nonatomic, readonly) BeeServiceBlock		ON;
@property (nonatomic, readonly) BeeServiceBlock		OFF;

+ (instancetype)sharedInstance;

+ (BOOL)serviceAutoLoading;
+ (BOOL)serviceAutoPowerOn;

+ (BOOL)servicePreLoad;
+ (void)serviceDidLoad;

- (NSArray *)loadedServices;

@end
