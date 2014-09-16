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

#import "Bee_UIDatePicker.h"
#import "UIView+BeeUISignal.h"
#import "UIView+LifeCycle.h"

#pragma mark -

@interface BeeUIDatePicker()
{
	BOOL					_inited;
	UIDatePicker *			_datePicker;
	UIView *				_parentView;
	NSObject *				_userData;
}

- (void)initSelf;
- (void)didDateChanged;

@end

@implementation BeeUIDatePicker

DEF_SIGNAL( WILL_PRESENT )
DEF_SIGNAL( DID_PRESENT )
DEF_SIGNAL( WILL_DISMISS )
DEF_SIGNAL( DID_DISMISS )
DEF_SIGNAL( CHANGED )
DEF_SIGNAL( CONFIRMED )

@synthesize userData = _userData;
@synthesize parentView = _parentView;

@dynamic date;
@dynamic datePickerMode;
@dynamic locale;
@dynamic calendar;
@dynamic timeZone;
@dynamic minimumDate;
@dynamic maximumDate;
@dynamic countDownDuration;
@dynamic minuteInterval;

- (void)initSelf
{
	if ( NO == _inited )
	{
		self.delegate = self;
		self.date = [NSDate date];
		
		if ( IOS7_OR_LATER )
		{
			self.title = @"\n\n\n\n\n\n\n\n\n\n\n\n\n";
		}
		else
		{
			self.title = @"\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
		}

		self.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	//	self.actionSheetStyle = UIActionSheetStyleDefault;
		self.cancelButtonIndex = [self addButtonWithTitle:@"确定"];

		_datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
		_datePicker.date = [NSDate date];
		_datePicker.datePickerMode = UIDatePickerModeDate;
		_datePicker.calendar = [NSCalendar currentCalendar];
		_datePicker.maximumDate = [NSDate date];
		[_datePicker addTarget:self action:@selector(didDateChanged) forControlEvents:UIControlEventValueChanged];
		[self addSubview:_datePicker];
		
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

	[_datePicker removeFromSuperview];
	[_datePicker release];

	[_userData release];
	
	[_parentView release];
	
	[super dealloc];
}

- (void)setDate:(NSDate *)date
{
	_datePicker.date = date;
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated
{
	[_datePicker setDate:date animated:animated];
}

- (NSDate *)date
{
	return _datePicker.date;
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
	_datePicker.datePickerMode = datePickerMode;
}

- (UIDatePickerMode)datePickerMode
{
	return _datePicker.datePickerMode;
}

- (void)setLocale:(NSLocale *)locale
{
	_datePicker.locale = locale;
}

- (NSLocale *)locale
{
	return _datePicker.locale;
}

- (void)setCalendar:(NSCalendar *)calendar
{
	_datePicker.calendar = calendar;
}

- (NSCalendar *)calendar
{
	return _datePicker.calendar;
}

- (void)setTimeZone:(NSTimeZone *)timeZone
{
	_datePicker.timeZone = timeZone;
}

- (NSTimeZone *)timeZone
{
	return _datePicker.timeZone;
}

- (void)setMinimumDate:(NSDate *)minimumDate
{
	_datePicker.minimumDate = minimumDate;
}

- (NSDate *)minimumDate
{
	return _datePicker.minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate
{
	_datePicker.maximumDate = maximumDate;
}

- (NSDate *)maximumDate
{
	return _datePicker.maximumDate;
}

- (void)setCountDownDuration:(NSTimeInterval)countDownDuration
{
	_datePicker.countDownDuration = countDownDuration;
}

- (NSTimeInterval)countDownDuration
{
	return _datePicker.countDownDuration;
}

- (void)setMinuteInterval:(NSInteger)minuteInterval
{
	_datePicker.minuteInterval = minuteInterval;
}

- (NSInteger)minuteInterval
{
	return _datePicker.minuteInterval;
}

- (void)showFromToolbar:(UIToolbar *)view
{
	self.parentView = view;
	
	[self showInView:view];
}

- (void)showFromTabBar:(UITabBar *)view
{
	self.parentView = view;
	
	[self showInView:view];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
	if ( item.target && [item.target isKindOfClass:[UIView class]] )
	{
		self.parentView = item.target;
	}
	
	[super showFromBarButtonItem:item animated:animated];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
{
	self.parentView = view;
	
	[super showFromRect:rect inView:view animated:animated];
}

- (void)showInView:(UIView *)view
{
	self.parentView = view;
	
	[super showInView:view];
}

- (void)showInViewController:(UIViewController *)controller
{
	[self presentForController:controller];
}

- (void)presentForController:(UIViewController *)controller
{
	self.parentView = controller.view;
	
	[self showInView:controller.view];
}

- (void)dismissAnimated:(BOOL)animated
{
	[self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:animated];
}

#pragma mark -

- (void)didDateChanged
{
	NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_datePicker.date, @"date", nil];
	[self sendUISignal:BeeUIDatePicker.CHANGED
			withObject:dict
					to:(_parentView ? _parentView : self)];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

// after animation
- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
	[self sendUISignal:BeeUIDatePicker.DID_PRESENT
			withObject:nil
					to:(_parentView ? _parentView : self)];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ( buttonIndex == self.cancelButtonIndex )
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_datePicker.date, @"date", nil];
		[self sendUISignal:BeeUIDatePicker.CONFIRMED
				withObject:dict
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
	[self sendUISignal:BeeUIDatePicker.WILL_PRESENT
			withObject:nil
					to:(_parentView ? _parentView : self)];
}

// before animation and hiding view
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self sendUISignal:BeeUIDatePicker.WILL_DISMISS
			withObject:nil
					to:(_parentView ? _parentView : self)];
}

// after animation
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self sendUISignal:BeeUIDatePicker.DID_DISMISS
			withObject:nil
					to:(_parentView ? _parentView : self)];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
