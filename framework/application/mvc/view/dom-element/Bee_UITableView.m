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

#import "Bee_UITableView.h"
#import "UIView+BeeUISignal.h"
#include <objc/runtime.h>

#pragma mark -

@implementation UITableViewCell (BeeUICell)

@dynamic contentCell;

- (void)setFrame:(CGRect)rc
{
	[super setFrame:rc];
	[self.contentCell setFrame:self.bounds];
    //	[_gridCell layoutSubcells];
}

- (void)setCenter:(CGPoint)pt
{
	[super setCenter:pt];
	[self.contentCell setFrame:self.bounds];
    //	[_gridCell layoutSubcells];
}


-(void)setContentCell:(UIView *)contentCell{
    if (!self.contentCell) {
        objc_setAssociatedObject( self, "UITableViewCell.bee_contentCell", contentCell, OBJC_ASSOCIATION_RETAIN );
        if ( contentCell.superview != self.contentView )
        {
            [contentCell.superview removeFromSuperview];
        }
        [self.contentView addSubview:contentCell];
    }else{
        if ( self.contentCell != contentCell )
        {
            [self.contentCell release];
            objc_setAssociatedObject( self, "UITableViewCell.bee_contentCell", contentCell, OBJC_ASSOCIATION_RETAIN );
            if ( contentCell.superview != self.contentView )
            {
                [contentCell.superview removeFromSuperview];
            }
            [self.contentView addSubview:contentCell];
        }
    }
}

-(UIView *)contentCell{
    NSObject * obj = objc_getAssociatedObject( self, "UITableViewCell.bee_contentCell" );
	if ( obj && [obj isKindOfClass:[UIView class]] )
		return (UIView *)obj;
	return nil;
}
@end

@implementation UITableView (BeeUICell)

- (id)dequeueWithContentClass:(Class)clazz;{
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:[clazz description]];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[cell description]]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.editingAccessoryType = UITableViewCellAccessoryNone;
		cell.showsReorderControl = NO;
		cell.shouldIndentWhileEditing = NO;
		cell.indentationLevel = 0;
		cell.indentationWidth = 0.0f;
		self.alpha = 1.0f;
		self.layer.masksToBounds = YES;
		self.layer.opaque = YES;
        
		cell.contentView.layer.masksToBounds = YES;
		cell.contentView.layer.opaque = YES;
		cell.contentView.autoresizesSubviews = YES;
        if ( [clazz isSubclassOfClass:[UIView class]] )
		{
			cell.contentCell = (UIView *)[BeeRuntime allocByClass:clazz];;
		}
    }
    return cell;

}

@end

@implementation BeeUITableView
// TODO:
@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
