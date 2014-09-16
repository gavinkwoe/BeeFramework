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

#import "UIView+Tag.h"

#pragma mark -

#undef	KEY_NAMESPACE
#define KEY_NAMESPACE	"UIView.nameSpace"

#undef	KEY_TAGSTRING
#define KEY_TAGSTRING	"UIView.tagString"

#undef	KEY_TAGCLASSES
#define KEY_TAGCLASSES	"UIView.tagClasses"

#pragma mark -

@implementation UIView(Tag)

@dynamic nameSpace;
@dynamic tagString;
@dynamic tagClasses;

- (NSString *)nameSpace
{
	NSObject * obj = objc_getAssociatedObject( self, KEY_NAMESPACE );
	if ( obj && [obj isKindOfClass:[NSString class]] )
		return (NSString *)obj;
	
	return nil;
}

- (void)setNameSpace:(NSString *)value
{
	if ( nil == value )
		return;
	
	objc_setAssociatedObject( self, KEY_NAMESPACE, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (NSString *)tagString
{
	NSObject * obj = objc_getAssociatedObject( self, KEY_TAGSTRING );
	if ( obj && [obj isKindOfClass:[NSString class]] )
		return (NSString *)obj;
	
	return nil;
}

- (void)setTagString:(NSString *)value
{
	objc_setAssociatedObject( self, KEY_TAGSTRING, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (NSMutableArray *)tagClasses
{
	NSObject * obj = objc_getAssociatedObject( self, KEY_TAGCLASSES );
	if ( obj && [obj isKindOfClass:[NSMutableArray class]] )
		return (NSMutableArray *)obj;
	
	return nil;
}

- (void)setTagClasses:(NSMutableArray *)value
{
	objc_setAssociatedObject( self, KEY_TAGCLASSES, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
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

- (NSArray *)viewWithTagClass:(NSString *)value
{
	NSMutableArray * result = [NSMutableArray nonRetainingArray];
	
	for ( UIView * subview in self.subviews )
	{
		NSMutableArray * classes = subview.tagClasses;
		for ( NSString * tagClass in classes )
		{
			if ( NSOrderedSame == [tagClass compare:value options:NSCaseInsensitiveSearch] )
			{
				[result addObject:subview];
				break;
			}
		}
	}
	
	return result;
}

- (NSArray *)viewWithTagClasses:(NSArray *)array
{
	NSMutableArray * result = [NSMutableArray nonRetainingArray];
	
	for ( NSString * tagClass in array )
	{
		NSArray * subResult = [self viewWithTagClass:tagClass];
		if ( subResult && subResult.count )
		{
			[result addObjectsFromArray:subResult];
		}
	}
	
	return result;
}

- (NSArray *)viewWithTagMatchRegex:(NSString *)regex
{
	if ( nil == regex )
		return nil;
	
	NSMutableArray * array = [NSMutableArray nonRetainingArray];
	
	for ( UIView * subview in self.subviews )
	{
		NSString * tag = subview.tagString;
		if ( [tag match:regex] )
		{
			[array addObject:subview];
		}
	}
	
	return array;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
