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

#import "BeeUIScrollView+LayoutParser.h"

#import "Bee_UIStyle.h"
#import "BeeUIStyle+Builder.h"
#import "BeeUIStyle+Property.h"

#pragma mark -

@implementation BeeUIScrollView(LayoutParser)

- (void)parseLayout:(BeeUILayout *)layout
{
	NSString * columns = [layout.styleMerged propertyForKeyArray:@[@"columns"]];
	if ( columns )
	{
		self.lineCount = columns.integerValue;
	}

	NSString * insets = [layout.styleMerged propertyForKeyArray:@[@"insets"]];
	if ( insets )
	{
		self.extInsets = UIEdgeInsetsFromStringEx( insets );
	}
	
	[self removeAllSections];

	for ( BeeUILayout * subLayout in layout.childs )
	{
		if ( [subLayout.elemName matchAnyOf:@[@"header", @"list-header"]] )
		{
			NSString * type = [subLayout.styleMerged propertyForKeyArray:@[@"type"]];
			if ( type )
			{
				Class clazz = NSClassFromString( type );
				if ( clazz )
				{
					self.headerClass = clazz;
					self.headerShown = YES;
				}
			}
		}
		else if ( [subLayout.elemName matchAnyOf:@[@"footer", @"list-footer"]] )
		{
			NSString * type = [subLayout.styleMerged propertyForKeyArray:@[@"type"]];
			if ( type )
			{
				Class clazz = NSClassFromString( type );
				if ( clazz )
				{
					self.footerClass = clazz;
					self.footerShown = YES;
				}
			}
		}
		else // if ( [subLayout.elemName matchAnyOf:@[@"section", @"list-section"]] )
		{
//			BeeUIScrollSection * section = [[[BeeUIScrollSection alloc] init] autorelease];
//			
//			if ( [subLayout.styleMerged.orientation is:BeeUIStyle.ORIENTATION_HORIZONAL] )
//			{
//				section.rule = BeeUIScrollLayoutRuleHorizontal;
//			}
//			else
//			{
//				section.rule = BeeUIScrollLayoutRuleVertical;
//			}
//			
//			NSString * insets = [subLayout.styleMerged propertyForKeyArray:@[@"insets"]];
//			if ( insets )
//			{
//				section.viewInsets = UIEdgeInsetsFromStringEx( insets );
//			}
//			
//			NSString * name = [subLayout.styleMerged propertyForKeyArray:@[@"name"]];
//			if ( name )
//			{
//				section.name = name;
//			}
//			
//			NSString * type = [subLayout.styleMerged propertyForKeyArray:@[@"type"]];
//			if ( nil == type )
//			{
//				type = subLayout.elemName;
//			}
//
//			if ( type )
//			{
//				Class clazz = NSClassFromString( type );
//				if ( clazz )
//				{
//					section.viewClass = clazz;
//				}
//			}
//			
//			[self appendSection:section];
		}
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
