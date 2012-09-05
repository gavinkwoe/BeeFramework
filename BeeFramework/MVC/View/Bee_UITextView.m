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
//  Bee_UITextView.m
//

#import "Bee_UITextView.h"
#import "Bee_UISignal.h"

#pragma mark -

@interface BeeUITextViewAgent : NSObject<UITextViewDelegate>
{
	BeeUITextView *	_target;
}

@property (nonatomic, assign) BeeUITextView *	target;

@end

#pragma mark -

@implementation BeeUITextViewAgent

@synthesize target = _target;

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	[_target updatePlaceHolder];
	[_target sendUISignal:BeeUITextView.WILL_ACTIVE];
	return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	[_target updatePlaceHolder];
	[_target sendUISignal:BeeUITextView.DID_ACTIVED];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	[_target updatePlaceHolder];
	[_target sendUISignal:BeeUITextView.WILL_DEACTIVE];
	return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	[_target updatePlaceHolder];
	[_target sendUISignal:BeeUITextView.DID_DEACTIVED];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
	[_target updatePlaceHolder];
	[_target sendUISignal:BeeUITextView.TEXT_CHANGED];
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
	[_target updatePlaceHolder];
	[_target sendUISignal:BeeUITextView.SELECTION_CHANGED];
}

@end

#pragma mark -

@interface BeeUITextView(Private)
- (void)initSelf;
@end

#pragma mark -

@implementation BeeUITextView

DEF_SIGNAL( WILL_ACTIVE )
DEF_SIGNAL( DID_ACTIVED )
DEF_SIGNAL( WILL_DEACTIVE )
DEF_SIGNAL( DID_DEACTIVED )
DEF_SIGNAL( TEXT_CHANGED )
DEF_SIGNAL( SELECTION_CHANGED )

@synthesize placeholder = _placeholder;
@synthesize placeHolderLabel = _placeHolderLabel;
@synthesize placeHolderColor = _placeHolderColor;

+ (BeeUITextView *)spawn
{
	return [[[BeeUITextView alloc] initWithFrame:CGRectZero] autorelease];
}

- (id)init
{
	self = [super initWithFrame:CGRectZero];
    if( self )
    {
		[self initSelf];
    }
    return self;	
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
    if( self )
    {
		[self initSelf];
    }
    return self;
}

- (void)initSelf
{
	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];

	self.placeholder = @"";
	self.placeHolderColor = [UIColor grayColor];
	
	_agent = [[BeeUITextViewAgent alloc] init];
	_agent.target = self;
	
	self.delegate = _agent;	
}

- (void)dealloc
{
	[_agent release];
	
	self.placeHolderLabel = nil;
	self.placeHolderColor = nil;
	self.placeholder = nil;

    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
	[self updatePlaceHolder];
    [super drawRect:rect];
}

- (void)updatePlaceHolder
{	
	if ( [_placeholder length] > 0 )
    {
        if ( nil == _placeHolderLabel )
        {
			CGRect labelFrame = CGRectMake( 9.0f, 8.0f, self.frame.size.width, 0.0f );

			_placeHolderLabel = [[UILabel alloc] initWithFrame:labelFrame];
			_placeHolderLabel.lineBreakMode = UILineBreakModeCharacterWrap;
			_placeHolderLabel.numberOfLines = 1;
			_placeHolderLabel.font =  self.font;
			_placeHolderLabel.backgroundColor = [UIColor clearColor];
			_placeHolderLabel.textColor = _placeHolderColor;
			_placeHolderLabel.alpha = 0.0f;
			_placeHolderLabel.opaque = NO;
            [self addSubview:_placeHolderLabel];
        }
		
		_placeHolderLabel.frame = CGRectMake(_placeHolderLabel.frame.origin.x, _placeHolderLabel.frame.origin.y, self.frame.size.width, 0);
		_placeHolderLabel.lineBreakMode = UILineBreakModeCharacterWrap;
		_placeHolderLabel.numberOfLines = 1;
		_placeHolderLabel.text = self.placeholder;
		[_placeHolderLabel sizeToFit];
		[self sendSubviewToBack:_placeHolderLabel];			
    }
	
	if ( _placeHolderLabel )
	{
		_placeHolderLabel.text = _placeholder;
		[_placeHolderLabel sizeToFit];

		if ( [_placeholder length] > 0 )
		{
			if ( 0 == [self.text length] )
			{
				[_placeHolderLabel setAlpha:1.0f];
			}
			else
			{
				[_placeHolderLabel setAlpha:0.0f];
			}
		}
	}
}

- (BOOL)active
{
	return [self isFirstResponder];
}

- (void)setActive:(BOOL)flag
{
	if ( flag )
	{
		[self becomeFirstResponder];
	}
	else
	{
		[self resignFirstResponder];
	}
}

@end
