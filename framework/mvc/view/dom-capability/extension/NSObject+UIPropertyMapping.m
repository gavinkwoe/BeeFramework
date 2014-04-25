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

#import "NSObject+UIPropertyMapping.h"
#import "UIView+Tag.h"
#import "Bee_UICapability.h"
#import "Bee_Runtime.h"

#pragma mark -

@implementation NSObject(BeeUIPropertyMapping)

- (void)mapPropertiesFromView:(UIView *)view
{
	for ( UIView * subview in view.subviews )
	{
		NSString * tagString = subview.tagString;
		if ( nil == tagString || 0 == tagString.length )
			continue;
		
		NSString * propertyName = tagString;
		propertyName = [propertyName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
		propertyName = [propertyName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
		propertyName = [propertyName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];

		objc_property_t property = class_getProperty( [self class], [propertyName UTF8String] );
		if ( property )
		{
			const char *	attr = property_getAttributes( property );
			NSUInteger		type = [BeeTypeEncoding typeOf:attr];

			if ( BeeTypeEncoding.OBJECT == type )
			{
				NSString * attrClassName = [BeeTypeEncoding classNameOfAttribute:attr];
				if ( attrClassName )
				{
					Class class = NSClassFromString( attrClassName );
					if ( class && ([class isSubclassOfClass:[UIView class]] || [class isSubclassOfClass:[UIViewController class]]) )
					{
						[self setValue:subview forKey:propertyName];
					}
				}
			}

			if ( [subview isContainable] )
			{
				[self mapPropertiesFromView:subview];
			}
		}
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
