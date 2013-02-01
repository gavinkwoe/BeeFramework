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
//  Bee_UIDatePicker.m
//

#import "Bee_Precompile.h"
#import "Bee_UIPickerView.h"
#import "Bee_UISignal.h"
#import "UIView+BeeExtension.h"
#import "UIView+BeeUISignal.h"

#pragma mark -

@interface BeeUIPickerView(Private)
- (void)initSelf;
- (void)didDateChanged;
@end

@implementation BeeUIPickerView

DEF_SIGNAL( WILL_PRESENT )
DEF_SIGNAL( DID_PRESENT )
DEF_SIGNAL( WILL_DISMISS )
DEF_SIGNAL( DID_DISMISS )
DEF_SIGNAL( CHANGED )
DEF_SIGNAL( CONFIRMED )

@synthesize datas = _datas;
@synthesize userData = _userData;
@synthesize parentView = _parentView;

+ (BeeUIPickerView *)spawn
{
	return [[[BeeUIPickerView alloc] init] autorelease];
}

+ (BeeUIPickerView *)spawn:(NSString *)tagString
{
	BeeUIPickerView * view = [[[BeeUIPickerView alloc] init] autorelease];
	view.tagString = tagString;
	return view;
}

- (void)initSelf
{
	self.delegate = self;
	self.datas = [NSArray array];
	self.title = @"\n\n\n\\n\n\n\n\n\n\n\n\n\n\n";
	self.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    //	self.actionSheetStyle = UIActionSheetStyleDefault;
	self.cancelButtonIndex = [self addButtonWithTitle:@"确定"];
    
	_pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
	_pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = YES;
	[self addSubview:_pickerView];
}

-(void) setPickerTitle:(NSString *)pickerTitle{
    self.title = [NSString stringWithFormat:@"%@\n\n\n\\n\n\n\n\n\n\n\n\n\n\n",pickerTitle];
    _pickerView.frame = CGRectMake(0, 40, 320, 260);
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
	SAFE_RELEASE_SUBVIEW( _pickerView );
    
	[_userData release];
	
	[super dealloc];
}

-(void)setSelectRow:(NSInteger)selectRow{
    [_pickerView selectRow:selectRow inComponent:0 animated:YES];
}

-(NSInteger) selectRow{
    return [_pickerView selectedRowInComponent:0];
}

- (void)showFromToolbar:(UIToolbar *)view
{
	_parentView = view;
	
	[self showInView:view];
}

- (void)showFromTabBar:(UITabBar *)view
{
	_parentView = view;
	
	[self showInView:view];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
	if ( item.target && [item.target isKindOfClass:[UIView class]] )
	{
		_parentView = item.target;
	}
	
	[super showFromBarButtonItem:item animated:animated];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
{
	_parentView = view;
	
	[super showFromRect:rect inView:view animated:animated];
}

- (void)showInView:(UIView *)view
{
	_parentView = view;
	[self didDateChanged];
	[super showInView:view];
}

- (void)showInViewController:(UIViewController *)controller
{
    
	[self presentForController:controller];
}

- (void)presentForController:(UIViewController *)controller
{
	_parentView = controller.view;
	
	[self showInView:controller.view];
}

- (void)dismissAnimated:(BOOL)animated
{
	[self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:animated];
}

#pragma mark -
#pragma mark UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_datas count];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_datas objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self didDateChanged];
}


#pragma mark -
#pragma mark UIActionSheetDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ( buttonIndex == self.cancelButtonIndex )
	{
        NSInteger row = [_pickerView selectedRowInComponent:0];
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[_datas objectAtIndex:row], @"data", nil];
		if ( _parentView )
		{
			[_parentView sendUISignal:BeeUIPickerView.CONFIRMED withObject:dict from:self];
		}
		else
		{
			[self sendUISignal:BeeUIPickerView.CONFIRMED withObject:dict from:self];
		}
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
	if ( _parentView )
	{
		[_parentView sendUISignal:BeeUIPickerView.WILL_PRESENT withObject:nil from:self];
	}
	else
	{
		[self sendUISignal:BeeUIPickerView.WILL_PRESENT withObject:nil from:self];
	}
}

- (void)didDateChanged
{
    NSInteger row = [_pickerView selectedRowInComponent:0];
	NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[_datas objectAtIndex:row], @"data", nil];
    if (_userData) {
        [_userData release];
        _userData = nil;
    }
    self.userData = [_datas objectAtIndex:row];
	if ( _parentView )
	{
		[_parentView sendUISignal:BeeUIPickerView.CHANGED withObject:dict from:self];
	}
	else
	{
		[self sendUISignal:BeeUIPickerView.CHANGED withObject:dict from:self];
	}
}

// after animation
- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
	if ( _parentView )
	{
		[_parentView sendUISignal:BeeUIPickerView.DID_PRESENT withObject:nil from:self];
	}
	else
	{
		[self sendUISignal:BeeUIPickerView.DID_PRESENT withObject:nil from:self];
	}
}

// before animation and hiding view
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ( _parentView )
	{
		[_parentView sendUISignal:BeeUIPickerView.WILL_DISMISS withObject:nil from:self];
	}
	else
	{
		[self sendUISignal:BeeUIPickerView.WILL_DISMISS withObject:nil from:self];
	}
}

// after animation
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ( _parentView )
	{
		[_parentView sendUISignal:BeeUIPickerView.DID_DISMISS withObject:nil from:self];
	}
	else
	{
		[self sendUISignal:BeeUIPickerView.DID_DISMISS withObject:nil from:self];
	}
}

@end
