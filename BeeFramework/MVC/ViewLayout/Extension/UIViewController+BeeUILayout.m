//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
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
//
//  UIViewController+BeeUILayout.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_Log.h"
#import "Bee_UILayout.h"
#import "Bee_UITemplate.h"
#import "UIViewController+BeeUILayout.h"
#include <objc/runtime.h>
#include <execinfo.h>

#pragma mark -

#undef	KEY_LAYOUT
#define KEY_LAYOUT	"UIView.layout"

#pragma mark -

@implementation UIViewController(BeeUILayout)

@dynamic templateResource;
@dynamic templateFile;

@dynamic layout;
@dynamic BEGIN_LAYOUT;
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

- (BeeUILayout *)layout
{
	BeeUILayout * layout = objc_getAssociatedObject( self, KEY_LAYOUT );
	if ( nil == layout )
	{
		layout = [[[BeeUILayout alloc] init] autorelease];
		layout.canvas = self.view;
		layout.name = @"root";
		objc_setAssociatedObject( self, KEY_LAYOUT, layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	}
	return layout;
}

- (void)setLayout:(BeeUILayout *)newLayout
{
	BeeUILayout * layout = objc_getAssociatedObject( self, KEY_LAYOUT );
	if ( layout != newLayout )
	{
		newLayout.canvas = self.view;
		objc_setAssociatedObject( self, KEY_LAYOUT, newLayout, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	}
}

- (BeeUILayoutBlock)BEGIN_LAYOUT
{
	BeeUILayoutBlock block = ^ BeeUILayout * ( void )
	{
		CC( @"begin layout" );
		
		BeeLogIndent( 1 );
		
		BeeUILayout * layout = [self layout];
		[layout.childs removeAllObjects];
		return layout;
	};

	return [[block copy] autorelease];
}

- (BeeUILayoutBlock)RELAYOUT
{
	BeeUILayoutBlock block = ^ BeeUILayout * ( void )
	{
		BeeUILayout * layout = [self layout];
		if ( layout )
		{
			layout.RELAYOUT();
		}
		else
		{
			[self.view layoutSubviews];
		}
		return layout;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlockS)FROM_RESOURCE
{
	BeeUILayoutBlockS block = ^ BeeUILayout * ( NSString * res )
	{
		BeeUITemplate * temp = [BeeUITemplate fromResource:res];
		if ( temp && temp.rootLayout )
		{
			self.layout = temp.rootLayout;
			self.layout.canvas = self.view;
			self.layout.REBUILD();
		}
		
		return self.layout;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlockS)FROM_FILE
{
	BeeUILayoutBlockS block = ^ BeeUILayout * ( NSString * file )
	{
		BeeUITemplate * temp = [BeeUITemplate fromFile:file];
		if ( temp && temp.rootLayout )
		{
			self.layout = temp.rootLayout;
			self.layout.canvas = self.view;
			self.layout.REBUILD();
		}
		
		return self.layout;
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
