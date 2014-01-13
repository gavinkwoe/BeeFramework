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

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_Package.h"
#import "Bee_Foundation.h"
#import "Bee_ViewPackage.h"

#pragma mark -

AS_PACKAGE( BeePackage_UI, BeeUIConfig, config );

#pragma mark -

typedef enum
{
	BeeUIInterfaceMode_iOS6 = 0,
	BeeUIInterfaceMode_iOS7
} BeeUIInterfaceMode;

#pragma mark -

typedef enum
{
	BeeUISignalingMode_Manual = 0,
	BeeUISignalingMode_Auto
} BeeUISignalingMode;

#pragma mark -

typedef enum
{
	BeeUIPerformanceMode_Normal = 0,
	BeeUIPerformanceMode_High
} BeeUIPerformanceMode;

#pragma mark -

@interface BeeUIConfig : NSObject

@property (nonatomic, assign) BeeUIInterfaceMode	interfaceMode;
@property (nonatomic, assign) BOOL					iOS6Mode;
@property (nonatomic, assign) BOOL					iOS7Mode;

@property (nonatomic, assign) CGSize				baseOffset;
@property (nonatomic, assign) UIEdgeInsets			baseInsets;

@property (nonatomic, assign) BeeUISignalingMode	signalingMode;
@property (nonatomic, assign) BOOL					ASR;
@property (nonatomic, assign) BOOL					MSR;

@property (nonatomic, assign) BeeUIPerformanceMode	performanceMode;
@property (nonatomic, assign) BOOL					normalPerformance;
@property (nonatomic, assign) BOOL					highPerformance;

@property (nonatomic, assign) BOOL					cacheAsyncLoad;
@property (nonatomic, assign) BOOL					cacheAsyncSave;

AS_SINGLETON( BeeUIConfig )

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
