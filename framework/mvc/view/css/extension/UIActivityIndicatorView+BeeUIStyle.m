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

#import "UIActivityIndicatorView+BeeUIStyle.h"
#import "UIView+BeeUIStyle.h"
#import "UIView+Tag.h"

#import "Bee_UIStyleParser.h"

#pragma mark -

@implementation UIActivityIndicatorView(BeeUIStyle)

+ (BOOL)supportForUIStyling
{
	return YES;
}

- (void)applyIndicatorStyle:(NSMutableDictionary *)properties
{
// indicator style
	
	NSString * indicatorStyle = [properties parseStringWithKeys:@[@"style", @"indicator-style"]];
	if ( indicatorStyle )
	{
		if ( NSOrderedSame == [indicatorStyle compare:@"white" options:NSCaseInsensitiveSearch] )
		{
			self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		}
		else if ( NSOrderedSame == [indicatorStyle compare:@"gray" options:NSCaseInsensitiveSearch] )
		{
			self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		}
	}
	else
	{
		self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	}

// indicator color

	UIColor * indicatorColor = [properties parseColorWithKeys:@[@"color", @"indicator-color"] defaultValue:nil];
	if ( indicatorColor )
	{
		if ( [self respondsToSelector:@selector(setColor:)] )
		{
			[self performSelector:@selector(setColor:) withObject:indicatorColor];
		}
	}
}

- (void)applyIndicatorAnimating:(NSMutableDictionary *)properties
{
// animating
	
	BOOL animating = [properties parseBoolWithKeys:@[@"animating", @"indicator-animating"] defaultValue:NO];
	if ( animating )
	{
		[self startAnimating];
	}
	else
	{
		[self stopAnimating];
	}
}

- (void)applyUIStyling:(NSDictionary *)properties
{
	NSMutableDictionary * propertiesCopy = [NSMutableDictionary dictionaryWithDictionary:properties];
	
	[self applyIndicatorStyle:propertiesCopy];
	[self applyIndicatorAnimating:propertiesCopy];
	
    [super applyUIStyling:properties];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
