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

#import "UIView+BeeUITemplate.h"

#import "Bee_UILayout.h"
#import "Bee_UITemplate.h"
#import "Bee_UITemplateManager.h"

#import "UIView+BeeUILayout.h"
#import "UIView+BeeUIStyle.h"

#pragma mark -

@implementation UIView(BeeUITemplate)

@dynamic templateName;
@dynamic templateFile;
@dynamic templateResource;

@dynamic FROM_NAME;
@dynamic FROM_FILE;
@dynamic FROM_RESOURCE;

- (void)load
{
	if (  [self supportForUIResourceLoading] && nil == self.layout )
	{
		Class viewClass = [self class];
		for ( ;; )
		{
			if ( [viewClass supportForUIResourceLoading] )
			{
				self.FROM_NAME( [viewClass description] );
				if ( nil != self.layout )
					break;
			}
			
			viewClass = class_getSuperclass( viewClass );
			if ( nil == viewClass || viewClass == [UIResponder class] )
				break;
		}
	}
}

- (void)unload
{
}

- (void)setTemplateName:(NSString *)name
{
	BeeUITemplate * temp = [[BeeUITemplateManager sharedInstance] fromName:name];
	if ( temp && temp.rootLayout )
	{
		self.layout = temp.rootLayout;
		[self.layout buildFor:self];
	}
}

- (void)setTemplateFile:(NSString *)fileName
{
	BeeUITemplate * temp = [[BeeUITemplateManager sharedInstance] fromFile:fileName];
	if ( temp && temp.rootLayout )
	{
		self.layout = temp.rootLayout;
		[self.layout buildFor:self];
	}
}

- (void)setTemplateResource:(NSString *)resName
{
	BeeUITemplate * temp = [[BeeUITemplateManager sharedInstance] fromResource:resName];
	if ( temp && temp.rootLayout )
	{
		self.layout = temp.rootLayout;
		[self.layout buildFor:self];
	}
}

- (BeeUITemplateBlockS)FROM_NAME
{
	BeeUITemplateBlockS block = ^ UIView * ( NSString * className )
	{
		[self setTemplateName:className];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUITemplateBlockS)FROM_FILE
{
	BeeUITemplateBlockS block = ^ UIView * ( NSString * file )
	{
		[self setTemplateFile:file];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUITemplateBlockS)FROM_RESOURCE
{
	BeeUITemplateBlockS block = ^ UIView * ( NSString * res )
	{
		[self setTemplateResource:res];
		return self;
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
