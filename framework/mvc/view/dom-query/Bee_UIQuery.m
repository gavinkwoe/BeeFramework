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

#import "Bee_UIQuery.h"
#import "Bee_Foundation.h"

#import "UIView+Tag.h"

#pragma mark -

@implementation BeeUIQuery

+ (NSMutableArray *)findViewsIn:(UIView *)rootView byExpression:(NSString *)tag
{
	NSMutableArray * result = [NSMutableArray nonRetainingArray];
	
	NSArray * tags = [tag componentsSeparatedByString:@","];
	for ( NSString * subTag in tags )
	{
		subTag = subTag.trim;
		
		if ( [subTag isEqualToString:@"*"] )
		{
			[result addObjectsFromArray:rootView.subviews];
		}
		else if ( [subTag hasPrefix:@"#"] )
		{
			subTag = [subTag substringFromIndex:1];
			
			if ( subTag.length >= 3 && [subTag hasPrefix:@"/"] && [subTag hasSuffix:@"/"] )
			{
				NSString * regex = [subTag substringWithRange:NSMakeRange(1, subTag.length - 2)];
				
				NSArray * objs = [rootView viewWithTagMatchRegex:regex];
				if ( objs && objs.count )
				{
					[result addObjectsFromArray:objs];
				}
			}
			else
			{
				NSObject * obj = [rootView viewWithTagString:subTag];
				if ( obj )
				{
					[result addObject:obj];
				}
			}
		}
		else if ( [subTag hasPrefix:@"."] )
		{
			subTag = [subTag substringFromIndex:1];

			NSArray * subResult = [rootView viewWithTagClass:subTag];
			if ( subResult && subResult.count )
			{
				[result addObjectsFromArray:subResult];
			}
		}
		else
		{
			NSArray * paths = [subTag componentsSeparatedByString:@">"];
			if ( paths.count > 1 )
			{
				UIView * subview = rootView;
				
				for ( NSString * path in paths )
				{
					subview = [subview viewWithTagString:path.trim];
					if ( nil == subview )
						break;
				}
				
				if ( subview )
				{
					[result addObject:subview];
				}
			}
			else
			{
				if ( subTag.length >= 3 && [subTag hasPrefix:@"/"] && [subTag hasSuffix:@"/"] )
				{
					NSString * regex = [subTag substringWithRange:NSMakeRange(1, subTag.length - 2)];
					
					NSArray * objs = [rootView viewWithTagMatchRegex:regex];
					if ( objs && objs.count )
					{
						[result addObjectsFromArray:objs];
					}
				}
				else
				{
				//	WARN( @"unformal format selector '%@', should add #??", tag );
					
					UIView * subview = [rootView viewWithTagString:subTag];
					if ( subview )
					{
						[result addObject:subview];
					}
				}
			}
		}
	}
	
#if __BEE_DEVELOPMENT__
	if ( 0 == result.count )
	{
		ERROR( @"'%@' not found", tag );
	}
#endif	// #if __BEE_DEVELOPMENT__

	return result;
}

@end

#pragma mark -

BeeUIQueryObjectBlockN __getQueryBlock( id context )
{
	// C
	
	BeeUIQueryContextBlock contextBlock = ^ BeeUIQueryObjectBlockN ( id context )
	{
		// OC Runtime
		
		__block id self = context;
		
		BeeUIQueryObjectBlockN resultBlock = ^ BeeUIQuery * ( id first, ... )
		{
			// OC Runtime with self
			
			BeeUIQuery * wrapper = [[[BeeUIQuery alloc] init] autorelease];
			if ( nil == wrapper )
				return nil;
			
			if ( [first isKindOfClass:[UIView class]] )
			{
				wrapper.object = first;
			}
			else if ( [first isKindOfClass:[UIViewController class]] )
			{
				wrapper.object = first;
			}
			else if ( [first isKindOfClass:[NSString class]] )
			{
				UIView * rootView = nil;
				
				if ( [self isKindOfClass:[UIView class]] )
				{
					rootView = (UIView *)self;
				}
				else if ( [self isKindOfClass:[UIViewController class]] )
				{
					rootView = ((UIViewController *)self).view;
				}
				else if ( [self isKindOfClass:[UIWindow class]] )
				{
					rootView = (UIView *)self;
				}

				if ( rootView )
				{
					wrapper.retainedObject = [BeeUIQuery findViewsIn:rootView byExpression:(NSString *)first];
				}

//				INFO( @"quering '%@'...\tfound %d view(s)", first, wrapper.count );
			}

			return wrapper;
		};
		
		return [[resultBlock copy] autorelease];
	};
	
	return contextBlock( context );
}

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
