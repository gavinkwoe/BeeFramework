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
//  Bee_UIGridCell.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Bee_UISignal.h"

#pragma mark -

@class BeeUIGridCell;

#pragma mark -

@interface NSObject(BeeUIGridCell)
+ (CGSize)cellSize:(NSObject *)data bound:(CGSize)bound;
- (void)cellLayout:(BeeUIGridCell *)cell bound:(CGSize)bound;
@end

@interface BeeUIGridCell : UIView
{
	BOOL					_autoLayout;
	NSObject *				_cellData;
	NSString *				_category;
	NSObject *				_layout;
	NSMutableArray *		_subCells;
	BOOL					_zoomsTouchWhenHighlighted;
}

@property (nonatomic, assign) BOOL						autoLayout;
@property (nonatomic, retain) NSObject *				cellData;
@property (nonatomic, retain) NSString *				category;
@property (nonatomic, retain) NSObject *				layout;
@property (nonatomic, retain) NSMutableArray *			subCells;
@property (nonatomic, assign) BOOL						zoomsTouchWhenHighlighted;
@property (nonatomic, readonly) BeeUIGridCell *			supercell;

+ (BeeUIGridCell *)spawn;

- (void)bindData:(NSObject *)data;
- (void)clearData;

- (NSMutableArray *)subCellsIncludeCategory:(NSString *)cate;
- (NSMutableArray *)subCellsExcludeCategory:(NSString *)cate;

- (void)addSubcell:(BeeUIGridCell *)cell;
- (void)removeSubcell:(BeeUIGridCell *)cell;
- (void)removeAllSubcells;
- (void)layoutAllSubcells;
- (BeeUIGridCell *)hitTestSubCells:(CGPoint)point;

- (void)beginLayout;
- (void)commitLayout;

- (void)load;
- (void)unload;

@end
