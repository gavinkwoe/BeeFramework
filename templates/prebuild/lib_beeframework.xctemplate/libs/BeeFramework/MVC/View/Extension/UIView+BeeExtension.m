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
//  UIView+BeeBackground.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UISignal.h"
#import "Bee_UIImageView.h"
#import "Bee_UILabel.h"
#import "UIView+BeeExtension.h"
#include <objc/runtime.h>
#include <execinfo.h>

#pragma mark -

@interface __BeeHintLabel : BeeUILabel
@end

@implementation __BeeHintLabel

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.autoresizesSubviews = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
		
		self.alpha = 0.6f;
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;

		self.textColor = [UIColor whiteColor];
		self.textAlignment = UITextAlignmentCenter;
		self.font = [UIFont boldSystemFontOfSize:16.0f];
		self.lineBreakMode = UILineBreakModeClip;
		self.numberOfLines = 1;
	}

	return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextSaveGState( context );

		CGContextSetStrokeColorWithColor( context, [UIColor colorWithWhite:0.3f alpha:1.0f].CGColor );
		CGContextMoveToPoint( context, 0.0f, 0.0f );
		CGContextAddLineToPoint( context, self.bounds.size.width, self.bounds.size.height );
		CGContextStrokePath( context );
		
		CGContextSetStrokeColorWithColor( context, [UIColor colorWithWhite:0.3f alpha:1.0f].CGColor );
		CGContextMoveToPoint( context, 0.0f, self.bounds.size.height );
		CGContextAddLineToPoint( context, self.bounds.size.width, 0.0f );
		CGContextStrokePath( context );
		
		CGContextRestoreGState( context );
	}
	
	[super drawRect:rect];
}

@end

#pragma mark -

@interface __BeeBackgroundImageView : BeeUIImageView
@end

@implementation __BeeBackgroundImageView
@end

#pragma mark -

@implementation UIView(BeeExtension)

@dynamic tagString;
@dynamic hintString;
@dynamic hintColor;
@dynamic backgroundImageView;
@dynamic backgroundImage;

@dynamic top;
@dynamic bottom;
@dynamic left;
@dynamic right;
@dynamic width;
@dynamic height;

@dynamic x;
@dynamic y;
@dynamic w;
@dynamic h;
@dynamic visible;

- (__BeeBackgroundImageView *)__backgroundImageView
{
	__BeeBackgroundImageView * result = nil;
	
	for ( UIView * subView in self.subviews )
	{
		if ( [subView isKindOfClass:[__BeeBackgroundImageView class]] )
		{
			result = (__BeeBackgroundImageView *)subView;
			break;
		}
	}

	return result;
}

- (BeeUIImageView *)backgroundImageView
{
	return [self __backgroundImageView];
}

- (void)setBackgroundImageView:(BeeUIImageView *)backgroundImageView
{
	NSAssert( @"TO BE DONE", nil );
}

- (UIImage *)backgroundImage
{
	__BeeBackgroundImageView * imageView = [self __backgroundImageView];
	if ( imageView )
	{
		return imageView.image;
	}
	
	return nil;
}

- (void)setBackgroundImage:(UIImage *)image
{
	if ( image )
	{
		__BeeBackgroundImageView * imageView = [self __backgroundImageView];
		if ( nil == imageView )
		{
			imageView = [[[__BeeBackgroundImageView alloc] initWithFrame:self.bounds] autorelease];
			[self addSubview:imageView];
			[self sendSubviewToBack:imageView];
		}

		imageView.autoresizesSubviews = YES;
		imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		imageView.image = image;
		imageView.frame = self.bounds;
		imageView.contentMode = UIViewContentModeCenter;
		[imageView setNeedsDisplay];
	}
	else
	{
		__BeeBackgroundImageView * imageView = [self __backgroundImageView];
		if ( imageView )
		{
			[imageView removeFromSuperview];
		}
	}
}

- (NSString *)tagString
{
	NSObject * obj = objc_getAssociatedObject( self, "UIView.tagString" );
	if ( obj && [obj isKindOfClass:[NSString class]] )
		return (NSString *)obj;
	
	return nil;
}

- (void)setTagString:(NSString *)value
{
	objc_setAssociatedObject( self, "UIView.tagString", value, OBJC_ASSOCIATION_RETAIN );
}

- (UIView *)viewWithTagString:(NSString *)value
{
	if ( nil == value )
		return nil;
	
	for ( UIView * subview in self.subviews )
	{
		NSString * tag = subview.tagString;
		if ( [tag isEqualToString:value] )
		{
			return subview;
		}
	}
	
	return nil;
}

- (UIView *)viewWithTagPath:(NSString *)path
{
	NSArray * array = [path componentsSeparatedByString:@"."];
	if ( 0 == [array count] )
	{
		return nil;
	}

	UIView * result = self;

	for ( NSString * subPath in array )
	{
		if ( 0 == subPath.length )
			continue;

		result = [result viewWithTagString:subPath];
		if ( nil == result )
			return nil;

		if ( [array lastObject] == subPath )
		{
			return result;
		}
		else if ( NO == [result isKindOfClass:[UIView class]] )
		{
			return nil;
		}
	}

	return result;
}

- (UIView *)viewAtPath:(NSString *)path
{
	if ( nil == path || 0 == path.length )
		return nil;
	
	NSString *	keyPath = [path stringByReplacingOccurrencesOfString:@"/" withString:@"."];
	NSRange		range = NSMakeRange( 0, 1 );
	
	if ( [[keyPath substringWithRange:range] isEqualToString:@"."] )
	{
		keyPath = [keyPath substringFromIndex:1];
	}
	
	NSObject * result = [self valueForKeyPath:keyPath];
	if ( result == [NSNull null] || NO == [result isKindOfClass:[UIView class]] )
		return nil;
	
	return (UIView *)result;
}

- (UIView *)subview:(NSString *)name
{
	if ( nil == name || 0 == [name length] )
		return nil;
	
	NSObject * view = [self valueForKey:name];
	
	if ( [view isKindOfClass:[UIView class]] )
	{
		return (UIView *)view;
	}
	else
	{
		return nil;
	}
}

- (UIView *)prevSibling
{
	if ( nil == self.superview )
		return nil;
	
	if ( self.superview.subviews.count <= 1 )
		return nil;
	
	NSUInteger count = self.superview.subviews.count;
	NSUInteger index = [self.superview.subviews indexOfObject:self];
	if ( 0 == index )
	{
		index = count - 1;
	}
	else
	{
		index = index - 1;
	}

	return [self.superview.subviews objectAtIndex:index];
}

- (UIView *)nextSibling
{
	if ( nil == self.superview )
		return nil;

	if ( self.superview.subviews.count <= 1 )
		return nil;

	NSUInteger count = self.superview.subviews.count;
	NSUInteger index = [self.superview.subviews indexOfObject:self];

	return [self.superview.subviews objectAtIndex:(index + 1) % count];
}

- (void)removeAllSubviews
{
	for ( UIView * view in [[self.subviews copy] autorelease] )
	{
		[view removeFromSuperview];
	}
}

- (UIViewController *)viewController
{
	if ( nil != self.superview )
		return nil;
	
	id nextResponder = [self nextResponder];
	if ( [nextResponder isKindOfClass:[UIViewController class]] )
	{
		return (UIViewController *)nextResponder;
	}
	else
	{
		return nil;
	}
}

- (__BeeHintLabel *)__hintLabel
{
#if defined(__BEE_WIREFRAME__) && __BEE_WIREFRAME__
	
	__BeeHintLabel * hintLabel = nil;
	
	for ( UIView * subView in self.subviews )
	{
		if ( [subView isKindOfClass:[__BeeHintLabel class]] )
		{
			hintLabel = (__BeeHintLabel *)subView;
			break;
		}
	}
	
	if ( nil == hintLabel )
	{
		hintLabel = [[[__BeeHintLabel alloc] initWithFrame:self.bounds] autorelease];
		hintLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		hintLabel.backgroundColor = [UIColor darkGrayColor];
		[self addSubview:hintLabel];
	}
	
	hintLabel.frame = self.bounds;
	[hintLabel setNeedsDisplay];

	[self setAutoresizesSubviews:YES];
	[self sendSubviewToBack:hintLabel];
		
	return hintLabel;
	
#else	// #if defined(__BEE_WIREFRAME__) && __BEE_WIREFRAME__
	
	return nil;
	
#endif	// #if defined(__BEE_WIREFRAME__) && __BEE_WIREFRAME__
}

- (NSString *)hintString
{
	return [self __hintLabel].text;
}

- (void)setHintString:(NSString *)string
{
	[self __hintLabel].text = string;
}

- (UIColor *)hintColor
{
	return [self __hintLabel].backgroundColor;
}

- (void)setHintColor:(UIColor *)color
{
	[self __hintLabel].backgroundColor = color;
}

+ (UIView *)spawn
{
	return [[[[self class] alloc] init] autorelease];
}

+ (UIView *)spawn:(NSString *)tagString
{
	UIView * view = [self spawn];
	view.tagString = tagString;
	return view;
}

- (CGFloat)top
{
	return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
	CGRect frame = self.frame;
	frame.origin.y = top;
	self.frame = frame;
}

- (CGFloat)left
{
	return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
	CGRect frame = self.frame;
	frame.origin.x = left;
	self.frame = frame;
}

- (CGFloat)width
{
	return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat)height
{
	return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.size.height + self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.y = right - frame.size.width;
	self.frame = frame;
}

- (CGFloat)x
{
	return self.frame.origin.x;
}

- (void)setX:(CGFloat)value
{
	CGRect frame = self.frame;
	frame.origin.x = value;
	self.frame = frame;
}

- (CGFloat)y
{
	return self.frame.origin.y;
}

- (void)setY:(CGFloat)value
{
	CGRect frame = self.frame;
	frame.origin.y = value;
	self.frame = frame;
}

- (CGFloat)w
{
	return self.frame.size.width;
}

- (void)setW:(CGFloat)width
{
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat)h
{
	return self.frame.size.height;
}

- (void)setH:(CGFloat)height
{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (BOOL)visible
{
	return self.hidden ? NO : YES;
}

- (void)setVisible:(BOOL)flag
{
	self.hidden = flag ? NO : YES;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
