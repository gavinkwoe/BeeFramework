//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
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

#import "UIViewController+BeeUITemplate.h"

#import "Bee_UILayout.h"
#import "Bee_UITemplate.h"

#import "UIView+BeeUILayout.h"
#import "UIView+BeeUIStyle.h"
#import "UIViewController+BeeUILayout.h"

#pragma mark -

@implementation UIViewController(BeeUITemplate)

@dynamic templateResource;
@dynamic templateFile;

@dynamic FROM_RESOURCE;
@dynamic FROM_FILE;

- (void)setTemplateFile:(NSString *)templateFile
{
	BeeUITemplate * temp = [BeeUITemplate fromFile:templateFile];
	if ( temp && temp.rootLayout )
	{
		self.layout = temp.rootLayout;
		self.layout.canvas = self.view;
		self.layout.REBUILD();
	}
}

- (void)setTemplateResource:(NSString *)templateResource
{
	BeeUITemplate * temp = [BeeUITemplate fromResource:templateResource];
	if ( temp && temp.rootLayout )
	{
		self.layout = temp.rootLayout;
		self.layout.canvas = self.view;
		self.layout.REBUILD();
	}
}

- (BeeUITemplateBlockS)LOAD_RESOURCE
{
	BeeUITemplateBlockS block = ^ UIView * ( NSString * className )
	{
		NSString *	uiResource = [NSString stringWithFormat:@"%@.ui", className];
		NSString *	xmlResource = [NSString stringWithFormat:@"%@.xml", className];
		NSString *	htmResource = [NSString stringWithFormat:@"%@.htm", className];
		NSString *	htmlResource = [NSString stringWithFormat:@"%@.html", className];
		
		BeeUITemplate * temp = nil;
		
		if ( nil == temp )
		{
			temp = [BeeUITemplate fromResource:uiResource];
		}
		
		if ( nil == temp )
		{
			temp = [BeeUITemplate fromResource:xmlResource];
		}

		if ( nil == temp )
		{
			temp = [BeeUITemplate fromResource:htmResource];
		}

		if ( nil == temp )
		{
			temp = [BeeUITemplate fromResource:htmlResource];
		}

		if ( temp && temp.rootLayout )
		{
			self.layout = temp.rootLayout;
			self.layout.canvas = self.view;
			self.layout.REBUILD();
		}

		return self.view;
	};
	
	return [[block copy] autorelease];
}

- (BeeUITemplateBlockS)FROM_RESOURCE
{
	BeeUITemplateBlockS block = ^ UIView * ( NSString * res )
	{
		BeeUITemplate * temp = [BeeUITemplate fromResource:res];
		if ( temp && temp.rootLayout )
		{
			self.layout = temp.rootLayout;
			self.layout.canvas = self.view;
			self.layout.REBUILD();
		}

		return self.view;
	};
	
	return [[block copy] autorelease];
}

- (BeeUITemplateBlockS)FROM_FILE
{
	BeeUITemplateBlockS block = ^ UIView * ( NSString * file )
	{
		BeeUITemplate * temp = [BeeUITemplate fromFile:file];
		if ( temp && temp.rootLayout )
		{
			self.layout = temp.rootLayout;
			self.layout.canvas = self.view;
			self.layout.REBUILD();
		}
		
		return self.view;
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
