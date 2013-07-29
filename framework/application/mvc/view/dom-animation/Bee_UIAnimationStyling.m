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

#import "Bee_UIAnimationStyling.h"
#import "Bee_UIStyle.h"

#pragma mark -

@interface BeeUIAnimationStyling()
@end

#pragma mark -

@implementation BeeUIAnimationStyling

@dynamic css;

#pragma mark -

- (NSString *)css
{
	return [self.params objectForKey:@"css"];
}

- (void)setCss:(NSString *)value
{
	[self.params setObject:value forKey:@"css"];
}

#pragma mark -

- (void)load
{
	self.autoCommit = YES;
	self.type = BeeUIAnimationTypeStyling;
}

- (void)unload
{
}

- (void)animationPerform
{
	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDelay:self.delay];
	[UIView setAnimationDuration:self.duration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop)];
	
	BeeUIStyle * style = [[[BeeUIStyle alloc] init] autorelease];
	style.CSS( self.css );
	
	for ( UIView * view in self.views )
	{
		[style applyFor:view];
	}

	if ( self.autoCommit )
	{
		[UIView commitAnimations];
		
		self.performing = YES;
	}
}

- (void)animationDidStop
{
	self.completed = YES;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
