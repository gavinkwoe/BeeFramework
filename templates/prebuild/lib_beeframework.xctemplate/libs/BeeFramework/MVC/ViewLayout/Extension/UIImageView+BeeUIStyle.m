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
//  UIImageView+BeeUIStyle.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "UIImageView+BeeUIStyle.h"
#import "UIView+BeeUIStyle.h"
#import "NSDictionary+BeeExtension.h"

@implementation UIImageView (BeeUIStyle)

- (void)applyStyleProperties:(NSDictionary *)properties
{
    [super applyStyleProperties:properties];
    
// setImage
	
    NSString * image = [properties stringOfAny:@[@"image"]];
    if ( image )
    {
		if ( [image hasPrefix:@"http://"] || [image hasPrefix:@"https://"] )
		{
			if ( [self respondsToSelector:@selector(readFromURL:)] )
			{
				[self performSelector:@selector(readFromURL:) withObject:image];
			}
		}
		else if ( [image hasPrefix:@"localhost://"] )
		{
			if ( [self respondsToSelector:@selector(readFromFile:)] )
			{
				image = [image substringFromIndex:@"localhost://".length];
				
				[self performSelector:@selector(readFromFile:) withObject:image];
			}			
		}
		else if ( [image hasPrefix:@"file://"] )
		{
			if ( [self respondsToSelector:@selector(readFromFile:)] )
			{
				image = [image substringFromIndex:@"file://".length];

				[self performSelector:@selector(readFromFile:) withObject:image];
			}
		}
		else if ( [image hasPrefix:@"res://"] )
		{
			if ( [self respondsToSelector:@selector(readFromURL:)] )
			{
				image = [image substringFromIndex:@"res://".length];
				
				[self performSelector:@selector(readFromURL:) withObject:image];
			}
		}
		
		UIImage * userImage = [UIImage imageNamed:image];
		if ( userImage )
		{
			[self setImage:userImage];
		}
    }

//    NSString * highlightedImage = [properties valueForKey:@"highlightedImage"];
//    if ( highlightedImage )
//    {
//        [self setHighlightedImage:[UIImage imageNamed:highlightedImage]];
//    }
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
