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

#import "NSObject+BeeExtension.h"
#import "Bee_UnitTest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(BeeExtension)

+ (instancetype)object
{
	return [[[self alloc] init] autorelease];
}

+ (instancetype)disposable
{
	return [[[self alloc] init] autorelease];
}

- (void)load
{
	
}

- (void)unload
{	
}

- (void)performLoad
{
	[self performSelectorAlongChainReversed:@selector(load)];
}

- (void)performUnload
{
	[self performSelectorAlongChain:@selector(unload)];
}

- (void)performSelectorAlongChain:(SEL)sel
{
	NSMutableArray * classStack = [NSMutableArray nonRetainingArray];

	for ( Class thisClass = [self class]; nil != thisClass; thisClass = class_getSuperclass( thisClass ) )
	{
		[classStack addObject:thisClass];
	}

	for ( Class thisClass in classStack )
	{
		ImpFuncType prevImp = NULL;
		
		Method method = class_getInstanceMethod( thisClass, sel );
		
		if ( method )
		{
			ImpFuncType imp = (ImpFuncType)method_getImplementation( method );
			
			if ( imp )
			{
				if ( imp == prevImp )
				{
					continue;
				}
				
				imp( self, sel, nil );
				
				prevImp = imp;
			}
		}

//		Method method = class_getInstanceMethod( thisClass, sel );
//		if ( method )
//		{
//			IMP imp = method_getImplementation( method );
//			if ( imp )
//			{
//				imp( self, sel, nil );
//			}
//		}
	}
}

- (void)performSelectorAlongChainReversed:(SEL)sel
{
	NSMutableArray * classStack = [NSMutableArray nonRetainingArray];
	
	for ( Class thisClass = [self class]; nil != thisClass; thisClass = class_getSuperclass( thisClass ) )
	{
		[classStack insertObject:thisClass atIndex:0];
	}
	
	for ( Class thisClass in classStack )
	{
		ImpFuncType prevImp = NULL;
		
		Method method = class_getInstanceMethod( thisClass, sel );
		
		if ( method )
		{
			ImpFuncType imp = (ImpFuncType)method_getImplementation( method );
			
			if ( imp )
			{
				if ( imp == prevImp )
				{
					continue;
				}
				
				imp( self, sel, nil );
				
				prevImp = imp;
			}
		}

//		Method method = class_getInstanceMethod( thisClass, sel );
//		if ( method )
//		{
//			IMP imp = method_getImplementation( method );
//			if ( imp )
//			{
//				imp( self, sel, nil );
//			}
//		}
	}
}

- (void)copyPropertiesFrom:(id)obj
{
	for ( Class clazzType = [obj class]; clazzType != [NSObject class]; )
	{
		unsigned int		propertyCount = 0;
		objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );

		for ( NSUInteger i = 0; i < propertyCount; i++ )
		{
			const char *	name = property_getName(properties[i]);
			NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
			
			[self setValue:[obj valueForKey:propertyName] forKey:propertyName];
		}
		
		free( properties );

		clazzType = class_getSuperclass( clazzType );
		if ( nil == clazzType )
			break;
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( NSObject_BeeExtension )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
