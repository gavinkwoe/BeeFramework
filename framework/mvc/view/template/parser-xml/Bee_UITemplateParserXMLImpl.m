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

#import "Bee_UITemplateParserXMLImpl.h"
#import "Bee_UITemplateParserXMLImpl_v1.h"
//#import "Bee_UITemplateParserXMLImpl_v2.h"
#import "Bee_UIStyleParser.h"

#import "Bee_UILayout.h"
#import "Bee_UIStyle.h"

#pragma mark -

@implementation BeeUITemplateParserXMLImpl

@synthesize document = _document;
@synthesize packagePath = _packagePath;

+ (BeeUITemplateParserXMLImpl *)impl
{
	return [self impl:0];
}

+ (BeeUITemplateParserXMLImpl *)impl:(NSUInteger)version
{
	BeeUITemplateParserXMLImpl * impl = nil;
	
	if ( version <= 1 )
	{
		impl = [[[BeeUITemplateParserXMLImpl_v1 alloc] init] autorelease];
	}
//	else if ( version == 2 )
//	{
//		impl = [[[BeeUITemplateParserXMLImpl_v2 alloc] init] autorelease];
//	}
	
	if ( nil == impl )
	{
		impl = [[[BeeUITemplateParserXMLImpl_v1 alloc] init] autorelease];
	}

	return impl;
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

	self.document = nil;
	self.packagePath = nil;
	
	[super dealloc];
}

- (void)load
{	
}

- (void)unload
{
}

- (BeeUITemplate *)parse
{
	return nil;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
