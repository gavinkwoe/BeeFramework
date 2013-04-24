//
//  UITableView+BeeUIGirdCell.m
//  618
//
//  Created by he songhang on 13-4-24.
//  Copyright (c) 2013年 he songhang. All rights reserved.
//

#import "UITableView+BeeUIGirdCell.h"
#import "Bee.h"

@implementation UITableViewCell(BeeUIGirdCell)

@dynamic gridCell;

- (void)setFrame:(CGRect)rc
{
	[super setFrame:CGRectZeroNan(rc)];
    
	[self.gridCell setFrame:self.bounds];
    //	[_gridCell layoutSubcells];
}

- (void)setCenter:(CGPoint)pt
{
	[super setCenter:pt];
	
	[self.gridCell setFrame:self.bounds];
    //	[_gridCell layoutSubcells];
}


-(void)setGridCell:(BeeUIGridCell *)gridCell{
    if (!self.gridCell) {
        objc_setAssociatedObject( self, "UITableViewCell.gridCell", gridCell, OBJC_ASSOCIATION_RETAIN );
        self.gridCell.autoresizesSubviews = YES;
        self.gridCell.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        if ( gridCell.superview != self.contentView )
        {
            [gridCell.superview removeFromSuperview];
        }
        [self.contentView addSubview:gridCell];
        
        
    }else{
        if ( self.gridCell != gridCell )
        {
            [self.gridCell release];
            objc_setAssociatedObject( self, "UITableViewCell.gridCell", gridCell, OBJC_ASSOCIATION_RETAIN );
            self.gridCell.autoresizesSubviews = YES;
            self.gridCell.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            
            if ( gridCell.superview != self.contentView )
            {
                [gridCell.superview removeFromSuperview];
            }
            [self.contentView addSubview:gridCell];
            
        }
    }
}

-(BeeUIGridCell *)gridCell{
    NSObject * obj = objc_getAssociatedObject( self, "UITableViewCell.gridCell" );
	if ( obj && [obj isKindOfClass:[BeeUIGridCell class]] )
		return (BeeUIGridCell *)obj;
	return nil;
}

@end


@implementation UITableView (BeeUIGirdCell)

-(UITableViewCell *) dequeueReusableCellWithBeeUIGirdCellClass:(Class) clazz{
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
        if ( [clazz isSubclassOfClass:[BeeUIGridCell class]] )
		{
			cell.gridCell = [(BeeUIGridCell *)[[BeeRuntime allocByClass:clazz] init] autorelease];
		}
    }
    return cell;
}

@end

