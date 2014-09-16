//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//
//  Copyright (c) 2014-2015, Geek Zoo Studio
//  http://www.bee-framework.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "ServiceWizard_Board.h"
#import "ServiceWizard_PhotoCell.h"
#import "ServiceWizard_TemplateCell.h"
#import "ServiceWizard_Window.h"
#import "ServiceWizard.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation ServiceWizard_Board

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView,	list )
DEF_OUTLET( BeeUIPageControl,	pager )

- (void)load
{
}

- (void)unload
{
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
	ServiceWizard * service = [ServiceWizard sharedInstance];

	if ( service.config.showBackground )
	{
		self.view.backgroundImage = service.config.backgroundImage;
	}

	if ( service.config.showPageControl )
	{
		if ( NO == CGSizeEqualToSize( service.config.pageDotSize, CGSizeZero ) )
		{
			self.pager.dotSize = service.config.pageDotSize;
		}
		
		self.pager.dotImageNormal = service.config.pageDotNormal;
		self.pager.dotImageHilite = service.config.pageDotHighlighted;
		self.pager.dotImageLast = service.config.pageDotLast;
	}

	self.list.pagingEnabled = YES;
	self.list.reuseEnable = NO;
	self.list.whenReloading = ^
	{
		self.list.total = service.config.splashes.count;
		
		for ( BeeUIScrollItem * item in self.list.items )
		{
			id cellData = [service.config.splashes objectAtIndex:item.index];

			if ( [cellData isKindOfClass:[NSString class]] )
			{
				NSString * resourceName = (NSString *)cellData;
				NSString * resourceExt = [resourceName pathExtension];
				
				if ( [resourceExt matchAnyOf:@[@"png", @"jpg", @"jpeg"]] )
				{
					item.clazz = [ServiceWizard_PhotoCell class];
				}
				else if ( [BeeUITemplateParser supportForType:[resourceName pathExtension]] )
				{
					item.clazz = [ServiceWizard_TemplateCell class];
				}
			}
			else if ( [cellData isKindOfClass:[UIImage class]] )
			{
				item.clazz = [ServiceWizard_PhotoCell class];
			}

			item.rule = BeeUIScrollLayoutRule_Tile;
			item.size = self.list.bounds.size;
			item.data = cellData;
		}
		
		self.pager.numberOfPages = service.config.splashes.count;
	};
	self.list.whenScrolling = ^
	{
		CGFloat edge = self.list.contentSize.width + 40.0f;
		CGPoint point = self.list.contentOffset;

		if ( point.x + self.list.width >= edge )
		{
			[[ServiceWizard_Window sharedInstance] close];
		}

		self.pager.currentPage = self.list.pageIndex;
	};
}

ON_DELETE_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
	[self.list reloadData];
	[self.pager updateDotImages];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
