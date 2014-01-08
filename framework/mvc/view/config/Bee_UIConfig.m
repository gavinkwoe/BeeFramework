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

#import "Bee_UIConfig.h"

#pragma mark -

DEF_PACKAGE( BeePackage_UI, BeeUIConfig, config );

#pragma mark -

@interface BeeUIConfig()
{
	BeeUIInterfaceMode		_interfaceMode;
	BeeUISignalingMode		_signalingMode;
	BeeUIPerformanceMode	_performanceMode;
	BOOL					_cacheAsyncLoad;
	BOOL					_cacheAsyncSave;
}
@end

#pragma mark -

@implementation BeeUIConfig

@synthesize interfaceMode = _interfaceMode;
@dynamic iOS6Mode;
@dynamic iOS7Mode;

@dynamic baseOffset;
@dynamic baseInsets;

@synthesize signalingMode = _signalingMode;
@dynamic ASR;
@dynamic MSR;

@synthesize performanceMode = _performanceMode;
@dynamic normalPerformance;
@dynamic highPerformance;

@synthesize cacheAsyncLoad = _cacheAsyncLoad;
@synthesize cacheAsyncSave = _cacheAsyncSave;

DEF_SINGLETON( BeeUIConfig )

+ (BOOL)autoLoad
{
	[BeeUIConfig sharedInstance];
	return YES;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.interfaceMode = IOS7_OR_LATER ? BeeUIInterfaceMode_iOS7 : BeeUIInterfaceMode_iOS6;
		self.signalingMode = BeeUISignalingMode_Manual;
		self.performanceMode = BeeUIPerformanceMode_Normal;
		self.cacheAsyncLoad = NO;
		self.cacheAsyncSave = NO;

		[self loadConfig];
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (void)loadConfig
{
	NSString * manifestPath = [[NSBundle mainBundle] pathForResource:@"manifest" ofType:@"json"];
	NSString * manifestData = [NSString stringWithContentsOfFile:manifestPath encoding:NSUTF8StringEncoding error:NULL];
	if ( nil == manifestData )
		return;
	
	NSDictionary * dict = [manifestData objectFromJSONString];
	if ( nil == dict )
		return;

	for ( NSString * key in dict.allKeys )
	{
		NSString * value = [dict objectForKey:key];
		
		if ( [key matchAnyOf:@[@"ui.interfaceMode"]] )
		{
			if ( [value matchAnyOf:@[@"ios6"]] )
			{
				self.interfaceMode = BeeUIInterfaceMode_iOS6;
			}
			else if ( [value matchAnyOf:@[@"ios7"]] )
			{
				self.interfaceMode = BeeUIInterfaceMode_iOS7;
			}
		}
		else if ( [key matchAnyOf:@[@"ui.signalingModel"]] )
		{
			if ( [value matchAnyOf:@[@"asr"]] )
			{
				self.signalingMode = BeeUISignalingMode_Auto;
			}
			else if ( [value matchAnyOf:@[@"msr"]] )
			{
				self.signalingMode = BeeUISignalingMode_Manual;
			}
		}
		else if ( [key matchAnyOf:@[@"ui.performanceMode"]] )
		{
			if ( [value matchAnyOf:@[@"high"]] )
			{
				self.signalingMode = BeeUIPerformanceMode_High;
			}
			else if ( [value matchAnyOf:@[@"normal"]] )
			{
				self.signalingMode = BeeUIPerformanceMode_Normal;
			}
		}
		else if ( [key matchAnyOf:@[@"ui.cacheAsyncLoad"]] )
		{
			if ( value )
			{
				self.cacheAsyncLoad = [value boolValue];
			}
		}
		else if ( [key matchAnyOf:@[@"ui.cacheAsyncSave"]] )
		{
			if ( value )
			{
				self.cacheAsyncSave = [value boolValue];
			}
		}
	}
}

- (BOOL)iOS6Mode
{
	return BeeUIInterfaceMode_iOS6 == self.interfaceMode ? YES : NO;
}

- (void)setIOS6Mode:(BOOL)flag
{
	if ( flag )
	{
		self.interfaceMode = BeeUIInterfaceMode_iOS6;
	}
}

- (BOOL)iOS7Mode
{
	return BeeUIInterfaceMode_iOS7 == self.interfaceMode ? YES : NO;
}

- (void)setIOS7Mode:(BOOL)flag
{
	if ( flag )
	{
		self.interfaceMode = BeeUIInterfaceMode_iOS7;
	}
}

- (BOOL)ASR
{
	return BeeUISignalingMode_Auto == self.signalingMode ? YES : NO;
}

- (void)setASR:(BOOL)flag
{
	if ( flag )
	{
		self.signalingMode = BeeUISignalingMode_Auto;
	}
}

- (BOOL)MSR
{
	return BeeUISignalingMode_Manual == self.signalingMode ? YES : NO;
}

- (void)setMSR:(BOOL)flag
{
	if ( flag )
	{
		self.signalingMode = BeeUISignalingMode_Manual;
	}
}

- (BOOL)normalPerformance
{
	return BeeUIPerformanceMode_Normal == self.performanceMode ? YES : NO;
}

- (void)setNormalPerformance:(BOOL)flag
{
	if ( flag )
	{
		self.performanceMode = BeeUIPerformanceMode_Normal;
	}
}

- (BOOL)highPerformance
{
	return BeeUIPerformanceMode_High == self.performanceMode ? YES : NO;
}

- (void)setHighPerformance:(BOOL)flag
{
	if ( flag )
	{
		self.performanceMode = BeeUIPerformanceMode_High;
	}
}

- (CGSize)baseOffset
{
	if ( IOS7_OR_LATER )
	{
		if ( self.iOS6Mode )
		{
			return CGSizeMake( 0.0f, 64.0f );
		}
		else
		{
			return CGSizeMake( 0.0f, 0.0f );
		}
	}
	else
	{
		return CGSizeMake( 0.0f, 0.0f );
	}
}

- (UIEdgeInsets)baseInsets
{
	if ( IOS7_OR_LATER )
	{
		if ( self.iOS6Mode )
		{
			return UIEdgeInsetsMake( 0.0f, 0.0f, 0.0f, 0.0f );
		}
		else
		{
			return UIEdgeInsetsMake( 64.0f, 0.0f, 0.0f, 0.0f );
		}
	}
	else
	{
		return UIEdgeInsetsMake( 0.0f, 0.0f, 0.0f, 0.0f );
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
