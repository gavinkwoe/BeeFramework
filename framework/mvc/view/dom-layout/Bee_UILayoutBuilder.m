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

#import "Bee_UILayoutBuilder.h"
#import "Bee_UILayoutBuilder_v1.h"
#import "Bee_UILayoutBuilder_v2.h"
#import "Bee_UILayout.h"

#pragma mark -

@implementation BeeUILayoutBuilder

@synthesize rootCanvas = _rootCanvas;
@synthesize rootLayout = _rootLayout;

+ (BeeUILayoutBuilder *)builder
{
	return [self builder:0];
}

+ (BeeUILayoutBuilder *)builder:(NSUInteger)version
{
	if ( version <= 1 )
	{
		return [[[BeeUILayoutBuilder_v1 alloc] init] autorelease];
	}
	else if ( version == 2 )
	{
		return [[[BeeUILayoutBuilder_v2 alloc] init] autorelease];
	}
	else
	{
		return [[[BeeUILayoutBuilder_v1 alloc] init] autorelease];
	}
}

- (id)init
{
	self = [super init];
	if ( self )
	{
//		[self load];
		[self performLoad];
	}
	return self;
}

- (void)dealloc
{
//	[self unload];
	[self performUnload];
	
	self.rootCanvas = nil;
	self.rootLayout = nil;

	[super dealloc];
}

- (void)load
{
}

- (void)unload
{
}

- (void)buildTree
{
	
}

- (void)layoutTree:(CGRect)bound
{
	
}

- (CGSize)estimateSize:(CGRect)bound
{
	return [self estimateRect:bound].size;
}

- (CGRect)estimateRect:(CGRect)bound
{
	return CGRectZero;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
