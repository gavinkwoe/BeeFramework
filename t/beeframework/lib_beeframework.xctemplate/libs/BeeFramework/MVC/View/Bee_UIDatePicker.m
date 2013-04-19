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

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UIDatePicker.h"
#import "Bee_UISignal.h"
#import "UIView+BeeExtension.h"
#import "UIView+BeeUISignal.h"

#pragma mark -

@interface BeeUIDatePicker(Private)
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

+ (BeeUIDatePicker *)spawn
{
	return [[[BeeUIDatePicker alloc] init] autorelease];
}

+ (BeeUIDatePicker *)spawn:(NSString *)tagString
{
	BeeUIDatePicker * view = [[[BeeUIDatePicker alloc] init] autorelease];
	view.tagString = tagString;
	return view;
}

- (void)initSelf
{
	self.delegate = self;
	self.date = [NSDate date];
	self.title = @"\n\n\n\\n\n\n\\n\n\n\n\n\n\n\n";
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
	SAFE_RELEASE_SUBVIEW( _datePicker );

	[_userData release];
	
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
#pragma mark UIActionSheetDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ( buttonIndex == self.cancelButtonIndex )
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_datePicker.date, @"date", nil];
		if ( _parentView )
		{
			[_parentView sendUISignal:BeeUIDatePicker.CONFIRMED withObject:dict from:self];
		}
		else
		{
			[self sendUISignal:BeeUIDatePicker.CONFIRMED withObject:dict from:self];
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
		[_parentView sendUISignal:BeeUIDatePicker.WILL_PRESENT withObject:nil from:self];
	}
	else
	{
		[self sendUISignal:BeeUIDatePicker.WILL_PRESENT withObject:nil from:self];
	}
}

- (void)didDateChanged
{
	NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_datePicker.date, @"date", nil];
	if ( _parentView )
	{
		[_parentView sendUISignal:BeeUIDatePicker.CHANGED withObject:dict from:self];
	}
	else
	{
		[self sendUISignal:BeeUIDatePicker.CHANGED withObject:dict from:self];
	}
}

// after animation
- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
	if ( _parentView )
	{
		[_parentView sendUISignal:BeeUIDatePicker.DID_PRESENT withObject:nil from:self];
	}
	else
	{
		[self sendUISignal:BeeUIDatePicker.DID_PRESENT withObject:nil from:self];
	}
}

// before animation and hiding view
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ( _parentView )
	{
		[_parentView sendUISignal:BeeUIDatePicker.WILL_DISMISS withObject:nil from:self];
	}
	else
	{
		[self sendUISignal:BeeUIDatePicker.WILL_DISMISS withObject:nil from:self];
	}
}

// after animation
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ( _parentView )
	{
		[_parentView sendUISignal:BeeUIDatePicker.DID_DISMISS withObject:nil from:self];		
	}
	else
	{
		[self sendUISignal:BeeUIDatePicker.DID_DISMISS withObject:nil from:self];		
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
