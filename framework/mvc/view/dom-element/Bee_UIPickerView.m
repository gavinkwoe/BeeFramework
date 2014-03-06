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

#import "Bee_UIPickerView.h"
#import "UIView+BeeUISignal.h"
#import "UIView+LifeCycle.h"

#pragma mark -

@interface BeeUIPickerView()
{
	BOOL					_inited;
	
	UIActionSheet *			_actionSheet;
	UIView *				_parentView;
	NSObject *				_userData;
	
	NSMutableArray *		_columnIndexs;
	NSMutableArray *		_columnTitles;
	NSUInteger				_columns;
	
	NSUInteger				_selectedRow;
	NSUInteger				_selectedColumn;
}

- (void)initSelf;

@end

@implementation BeeUIPickerView

DEF_SIGNAL( WILL_PRESENT )
DEF_SIGNAL( DID_PRESENT )
DEF_SIGNAL( WILL_DISMISS )
DEF_SIGNAL( DID_DISMISS )
DEF_SIGNAL( CHANGED )
DEF_SIGNAL( CONFIRMED )

@synthesize userData = _userData;
@synthesize parentView = _parentView;
@synthesize columnTitles = _columnTitles;
@synthesize columns = _columns;

- (void)initSelf
{
	if ( NO == _inited )
	{
		self.dataSource = self;
		self.delegate = self;
		self.showsSelectionIndicator = YES;

		_columnIndexs = [[NSMutableArray alloc] init];
		_columnTitles = [[NSMutableArray alloc] init];	
		_columns = 1;
		
		_inited = YES;
		
//		[self load];
		[self performLoad];
	}
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (void)dealloc
{
//	[self unload];
	[self performUnload];
	
	[_columnIndexs removeAllObjects];
	[_columnIndexs release];

	[_columnTitles removeAllObjects];
	[_columnTitles release];

	[_userData release];
	
	[_parentView release];
	
	[super dealloc];
}

- (NSString *)selectedTitleInColumn:(NSUInteger)column
{
	NSMutableArray * array = [_columnTitles safeObjectAtIndex:column];
	if ( nil == array )
		return nil;

	return [array safeObjectAtIndex:[self selectedRowInColumn:column]];
}

- (NSUInteger)selectedRowInColumn:(NSUInteger)column
{
	NSNumber * index = [_columnIndexs safeObjectAtIndex:column];
	if ( nil == index )
		return 0;
	
	return [index unsignedIntegerValue];
}

- (void)addTitle:(NSString *)title
{
	[self addTitle:title forColumn:0];
}

- (void)addTitle:(NSString *)title forColumn:(NSUInteger)column
{
	if ( nil == title )
		return;

	[self prepareColumns];
	
	NSMutableArray * array = [_columnTitles safeObjectAtIndex:column];
	if ( array )
	{
		[array addObject:title];
	}
}

- (void)addTitles:(NSArray *)titles forColumn:(NSUInteger)column
{
	if ( nil == titles )
		return;
	
	[self prepareColumns];

	NSMutableArray * array = [_columnTitles safeObjectAtIndex:column];
	if ( array )
	{
		[array addObjectsFromArray:titles];
	}
}

- (void)removeTitles
{
	[_columnTitles removeAllObjects];
//	[_columnIndexs removeAllObjects];

	[self prepareColumns];
}

- (void)removeTitlesForColumn:(NSUInteger)column
{
	[_columnTitles replaceObjectAtIndex:column withObject:[NSMutableArray array]];
	[_columnIndexs replaceObjectAtIndex:column withObject:[NSNumber numberWithInteger:0]];
}

- (void)prepareColumns
{
	while ( _columnTitles.count < _columns )
	{
		[_columnTitles addObject:[NSMutableArray array]];
	}

	while ( _columnIndexs.count < _columns )
	{
		[_columnIndexs addObject:[NSNumber numberWithInteger:0]];
	}
}

- (UIActionSheet *)actionSheet
{
	if ( nil == _actionSheet )
	{
		_actionSheet = [[[UIActionSheet alloc] init] autorelease];
		_actionSheet.delegate = self;

		if ( IOS7_OR_LATER )
		{
			_actionSheet.title = @"\n\n\n\n\n\n\n\n\n\n\n";
		}
		else
		{
			_actionSheet.title = @"\n\n\n\n\n\n\n\n\n\n\n";
		}

		_actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		_actionSheet.cancelButtonIndex = [_actionSheet addButtonWithTitle:@"确定"];
	}
	return _actionSheet;
}

- (void)showFromToolbar:(UIToolbar *)view
{
	self.parentView = view;

	self.frame = CGRectMake(0, 0, 320, 200);
	
	[[self actionSheet] addSubview:self];
	[[self actionSheet] showInView:view];
}

- (void)showFromTabBar:(UITabBar *)view
{
	self.parentView = view;

	self.frame = CGRectMake(0, 0, 320, 200);

	[[self actionSheet] addSubview:self];
	[[self actionSheet] showInView:view];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
	if ( item.target && [item.target isKindOfClass:[UIView class]] )
	{
		self.parentView = item.target;
	}

	self.frame = CGRectMake(0, 0, 320, 200);

	[[self actionSheet] addSubview:self];
	[[self actionSheet] showFromBarButtonItem:item animated:animated];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
{
	self.parentView = view;

	self.frame = CGRectMake(0, 0, 320, 200);

	[[self actionSheet] addSubview:self];
	[[self actionSheet] showFromRect:rect inView:view animated:animated];
}

- (void)showInView:(UIView *)view
{
	self.parentView = view;
	
	self.frame = CGRectMake(0, 0, 320, 200);

	[[self actionSheet] addSubview:self];
	[[self actionSheet] showInView:view];
}

- (void)showInViewController:(UIViewController *)controller
{
	[self presentForController:controller];
}

- (void)presentForController:(UIViewController *)controller
{
	self.parentView = controller.view;
	
	self.frame = CGRectMake(0, 0, 320, 200);

	[[self actionSheet] addSubview:self];
	[[self actionSheet] showInView:controller.view];
}

- (void)dismissAnimated:(BOOL)animated
{
	[[self actionSheet] dismissWithClickedButtonIndex:_actionSheet.cancelButtonIndex
											 animated:animated];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

// after animation
- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
	[self sendUISignal:BeeUIPickerView.DID_PRESENT
			withObject:nil
					to:(_parentView ? _parentView : self)];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ( buttonIndex == [self actionSheet].cancelButtonIndex )
	{
		[self sendUISignal:BeeUIPickerView.CHANGED
				withObject:nil
						to:(_parentView ? _parentView : self)];

		[self sendUISignal:BeeUIPickerView.CONFIRMED
				withObject:nil
						to:(_parentView ? _parentView : self)];
	}
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
}

// before animation and showing view
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
	[self sendUISignal:BeeUIPickerView.WILL_PRESENT
			withObject:nil
					to:(_parentView ? _parentView : self)];
}

// before animation and hiding view
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self sendUISignal:BeeUIPickerView.WILL_DISMISS
			withObject:nil
					to:(_parentView ? _parentView : self)];
}

// after animation
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self sendUISignal:BeeUIPickerView.DID_DISMISS
			withObject:nil
					to:(_parentView ? _parentView : self)];
}

#pragma mark -
#pragma mark UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return self.columns;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	NSArray * objects = [self.columnTitles safeObjectAtIndex:component];

	if ( objects && [objects isKindOfClass:[NSArray class]] )
	{
		return objects.count;
	}
	
	return 0;
}

#pragma mark -
#pragma mark UIPickerViewDelegate

// returns width of column and height of row for each component.
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//	return 0.0f;
//}

//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//	return 0.0f;
//}

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSArray * objects = [self.columnTitles safeObjectAtIndex:component];
	if ( objects && [objects isKindOfClass:[NSArray class]] )
	{
		return [objects safeObjectAtIndex:row];
	}

	return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	[_columnIndexs replaceObjectAtIndex:component withObject:[NSNumber numberWithInteger:row]];
	
	[self sendUISignal:BeeUIPickerView.CHANGED
			withObject:nil
					to:(_parentView ? _parentView : self)];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
