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

#import "UIViewController+BeeUITemplate.h"
#import "UIView+BeeUITemplate.h"

#import "Bee_UILayout.h"
#import "Bee_UITemplate.h"

#import "UIView+BeeUILayout.h"
#import "UIView+BeeUIStyle.h"
#import "UIViewController+BeeUILayout.h"

#pragma mark -

@implementation UIViewController(BeeUITemplate)

@dynamic templateName;
@dynamic templateFile;
@dynamic templateResource;

@dynamic FROM_NAME;
@dynamic FROM_FILE;
@dynamic FROM_RESOURCE;

- (void)setTemplateName:(NSString *)name
{
	[self.view setTemplateName:name];
}

- (void)setTemplateFile:(NSString *)file
{
	[self.view setTemplateFile:file];
}

- (void)setTemplateResource:(NSString *)res
{
	[self.view setTemplateResource:res];
}

- (BeeUITemplateBlockS)FROM_NAME
{
	return self.view.FROM_NAME;
}

- (BeeUITemplateBlockS)FROM_RESOURCE
{
	return self.view.FROM_RESOURCE;
}

- (BeeUITemplateBlockS)FROM_FILE
{
	return self.view.FROM_FILE;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
