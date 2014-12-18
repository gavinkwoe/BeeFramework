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

#import "Bee_UISignalBus.h"
#import "BeeUISignal+SourceView.h"

#import "UIView+Tag.h"
#import "UIView+UIViewController.h"

#pragma mark -

@interface BeeUISignalBus()
{
	NSMutableDictionary * _selectorCache;
}

- (BOOL)perform:(BeeUISignal *)signal target:(id)target selector:(SEL)sel class:(Class)clazz history:(NSMutableDictionary *)history;
- (void)forward:(BeeUISignal *)signal toClass:(Class)superClass;
- (void)forward:(BeeUISignal *)signal toClassStack:(NSArray *)classArray;

- (void)checkForeign:(BeeUISignal *)signal;
- (void)checkForeign:(BeeUISignal *)signal forTarget:(id)target;

@end

#pragma mark -

@implementation BeeUISignalBus

DEF_SINGLETON( BeeUISignalBus )

- (id)init
{
	self = [super init];
	if ( self )
	{
		_selectorCache = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_selectorCache removeAllObjects];
	[_selectorCache release];
	
	[super dealloc];
}

- (void)checkForeign:(BeeUISignal *)signal
{
	if ( signal.name )
	{
		NSArray * nameComponents = [signal.name componentsSeparatedByString:@"."];
		if ( nameComponents.count > 2 && [[nameComponents objectAtIndex:0] isEqualToString:@"signal"] )
		{
			NSString * sourceName = [[signal.source class] description];
			NSString * namePrefix = [nameComponents objectAtIndex:1];
			
			if ( [sourceName isEqualToString:namePrefix] )
			{
				signal.foreign = NO;
			}
			else
			{
				signal.prefix = namePrefix;
				signal.foreign = YES;
				signal.foreignSource = signal.source;
			}
		}
		else
		{
			signal.foreign = NO;
		}
	}
}

- (void)checkForeign:(BeeUISignal *)signal forTarget:(id)target
{
	if ( signal.foreign )
	{
		if ( signal.source == signal.foreignSource )
		{
			NSString * targetName = [[target class] description];
			
			if ( [targetName isEqualToString:signal.prefix] )
			{
				signal.source = target;
			}
//			else
//			{
//				Class targetClass = NSClassFromString( targetName );
//				Class sourceClass = NSClassFromString( signal.prefix );
//
//				if ( sourceClass == targetClass || [targetClass isSubclassOfClass:sourceClass] )
//				{
//					signal.source = target;
//				}
//			}
		}
	}
}

+ (BOOL)send:(BeeUISignal *)signal
{
	return [[BeeUISignalBus sharedInstance] send:signal];
}

- (BOOL)send:(BeeUISignal *)signal
{
	if ( signal.dead )
	{
		ERROR( @"signal '%@', already dead", signal.name );
		return NO;
	}

//	[signal log:signal.source];
//	[signal log:signal.target];

	[self checkForeign:signal];

	if ( signal.target && [signal.target isUISignalResponder] )
	{
		signal.sending = YES;

		[self routes:signal];
	}
	else
	{
		signal.arrived = YES;
	}

	if ( signal.arrived )
	{
		if ( signal.sourceView.tagString )
		{
			PERF( @"Signal '%@' > '%@ #%@' > %@ > Done", signal.prettyName, signal.sourceView.nameSpace, signal.sourceView.tagString, [signal.jumpPath join:@" > "] );
		}
		else
		{
			PERF( @"Signal '%@' > %@ > Done", signal.prettyName, [signal.jumpPath join:@" > "] );
		}
	}
	else if ( signal.dead )
	{
		if ( signal.sourceView.tagString )
		{
			PERF( @"Signal '%@' > '#%@' > %@ > Kill", signal.prettyName, signal.sourceView.tagString, [signal.jumpPath join:@" > "] );
		}
		else
		{
			PERF( @"Signal '%@' (%@) > %@ > Kill", signal.prettyName, [signal.jumpPath join:@" > "] );
		}
	}

	return signal.arrived;
}

+ (BOOL)forward:(BeeUISignal *)signal
{
	return [[BeeUISignalBus sharedInstance] forward:signal];
}

- (BOOL)forward:(BeeUISignal *)signal
{
	return [self forward:signal to:nil];
}

+ (BOOL)forward:(BeeUISignal *)signal to:(id)target
{
	return [[BeeUISignalBus sharedInstance] forward:signal to:target];
}

- (BOOL)forward:(BeeUISignal *)signal to:(id)target
{
	if ( signal.dead )
	{
		ERROR( @"signal '%@', already dead", signal.name );
		return NO;
	}

	if ( nil == signal.target )
	{
		ERROR( @"signal '%@', no target", signal.name );
		return NO;
	}

	if ( nil == target )
	{
		if ( [signal.target isKindOfClass:[UIView class]] )
		{
			target = ((UIView *)signal.target).superview;
		}
	}

	[signal log:signal.target];

	if ( nil == target )
	{
		signal.arrived = YES;
		return YES;
	}

	[self checkForeign:signal forTarget:target];

	if ( [target isUISignalResponder] )
	{
		signal.target = target;		
		signal.sending = YES;

		[self routes:signal];
	}
	else
	{
		signal.arrived = YES;
	}

	return signal.arrived;
}

- (void)routes:(BeeUISignal *)signal
{
	Class signalTargetClass = [[signal.target signalTarget] class];
	
	if ( [BeeUIConfig sharedInstance].ASR )
	{
		NSMutableArray * classStack = [NSMutableArray nonRetainingArray];
		for ( ;; )
		{
			[classStack insertObject:signalTargetClass atIndex:0];
			
			signalTargetClass = class_getSuperclass( signalTargetClass );
			if ( nil == signalTargetClass || signalTargetClass == [NSObject class] )
				break;
		}
		
		[self forward:signal toClassStack:classStack];
	}
	else
	{
		[self forward:signal toClass:signalTargetClass];
	}
}

- (void)routes:(BeeUISignal *)signal superClass:(Class)superClass
{
	if ( [BeeUIConfig sharedInstance].ASR )
	{
		[self routes:signal];
	}
	else
	{
		[self forward:signal toClass:superClass];
	}
}


- (BOOL)perform:(BeeUISignal *)signal target:(id)target selector:(SEL)sel class:(Class)clazz history:(NSMutableDictionary *)history
{
	ASSERT( signal );
	ASSERT( target );
	ASSERT( sel );
	ASSERT( clazz );
	
	BOOL performed = NO;
	
	if ( [BeeUIConfig sharedInstance].ASR )
	{
		ImpFuncType prevImp = NULL;
		
		Method method = class_getInstanceMethod( clazz, sel );
		
		if ( method )
		{
			ImpFuncType imp = (ImpFuncType)method_getImplementation( method );
			
			if ( imp )
			{
				if ( nil == [history objectForKey:@((unsigned int)imp)] )
				{
					imp( target, sel, signal );
					
					[history setObject:@(YES) forKey:@((unsigned int)imp)];

					prevImp = imp;
					
					performed = YES;

				}
			}
		}

//		Method method = class_getInstanceMethod( clazz, sel );
//		if ( method )
//		{
//			IMP imp = method_getImplementation( method );
//			if ( imp )
//			{
//				if ( nil == [history objectForKey:@((unsigned int)imp)] )
//				{
//					imp( target, sel, signal );
//				
//					[history setObject:@(YES) forKey:@((unsigned int)imp)];
//
//					performed = YES;
//				}
//			}
//		}
	}
	else
	{
		if ( [target respondsToSelector:sel] )
		{
			[target performSelector:sel withObject:signal];
			
			performed = YES;
		}
	}
	
//	PERF( @"'%@' on '%@' selector '%s', %@", signal.name, [clazz description], sel_getName(sel), performed ? @"HIT" : @"SKIP" );
	
	return performed;
}

- (void)forward:(BeeUISignal *)signal toClass:(Class)superClass
{
	[self forward:signal toClassStack:[NSArray arrayWithObject:superClass]];
}

- (void)forward:(BeeUISignal *)signal toClassStack:(NSArray *)classStack
{
	if ( 0 == classStack.count )
		return;
	
	if ( nil == signal.source || nil == signal.target )
	{
		ERROR( @"Wrong signal parameter" );
		return;
	}
	
	NSString *	prioSelector = nil;
	NSString *	nameSpace = nil;
	NSString *	tagString = nil;
	
	NSString *	signalPrefix = nil;
	NSString *	signalClass = nil;
	NSString *	signalMethod = nil;
	
	if ( signal.name && [signal.name hasPrefix:@"signal."] )
	{
		NSArray * array = [signal.name componentsSeparatedByString:@"."];
		if ( array && array.count > 1 )
		{
			signalPrefix = (NSString *)[array objectAtIndex:0];
			signalClass = (NSString *)[array objectAtIndex:1];
			signalMethod = (NSString *)[array objectAtIndex:2];
			
			ASSERT( [signalPrefix isEqualToString:@"signal"] );
		}
	}
	
	if ( signal.source )
	{
		nameSpace = [signal.source signalNamespace];
		nameSpace = [nameSpace stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
		nameSpace = [nameSpace stringByReplacingOccurrencesOfString:@":" withString:@"_"];
		
		tagString = [signal.source signalTag];
		tagString = [tagString stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
		tagString = [tagString stringByReplacingOccurrencesOfString:@":" withString:@"_"];
		
		if ( nameSpace || tagString )
		{
			if ( nameSpace && tagString )
			{
				prioSelector = [NSString stringWithFormat:@"%@_%@", nameSpace, tagString];
			}
			else if ( nameSpace )
			{
				prioSelector = nameSpace;
			}
			else if ( tagString )
			{
				prioSelector = tagString;
			}
		}
	}
	
	id						signalTarget = [signal.target signalTarget];
	NSMutableDictionary *	history = [NSMutableDictionary dictionary];
	
	for ( Class signalTargetClass in classStack )
	{
		NSString *	cacheName = nil;
		
		if ( prioSelector )
		{
			cacheName = [NSString stringWithFormat:@"%@/%@/%@", signal.name, [signalTargetClass description], prioSelector];
		}
		else
		{
			cacheName = [NSString stringWithFormat:@"%@/%@", signal.name, [signalTargetClass description]];
		}
		
		NSString * cachedSelectorName = [_selectorCache objectForKey:cacheName];
		if ( cachedSelectorName )
		{
			SEL cachedSelector = NSSelectorFromString( cachedSelectorName );
			if ( cachedSelector )
			{
				BOOL hit = [self perform:signal target:signalTarget selector:cachedSelector class:signalTargetClass history:history];
				if ( hit )
				{
					continue;
				}
			}
		}
		
		do
		{
			NSString *	selectorName = nil;
			SEL			selector = nil;
			BOOL		performed = NO;
			
			if ( prioSelector )
			{
				// eg. handleUISignal_MyClass_tag
				
				selectorName = [NSString stringWithFormat:@"handleUISignal_%@:", prioSelector];
				selector = NSSelectorFromString( selectorName );
				
				performed = [self perform:signal target:signalTarget selector:selector class:signalTargetClass history:history];
				if ( performed )
				{
					[_selectorCache setObject:selectorName forKey:cacheName];
					break;
				}
			}
			
			// eg. handleUISignal_BeeUIBoard_CREATE_VIEWS
			
			if ( signalClass && signalMethod )
			{
				selectorName = [NSString stringWithFormat:@"handleUISignal_%@_%@:", signalClass, signalMethod];
				selector = NSSelectorFromString( selectorName );
				
				performed = [self perform:signal target:signalTarget selector:selector class:signalTargetClass history:history];
				if ( performed )
				{
					[_selectorCache setObject:selectorName forKey:cacheName];
					break;
				}
			}
			
			// eg. handleUISignal_BeeUIBoard
			
			if ( signalClass )
			{
				selectorName = [NSString stringWithFormat:@"handleUISignal_%@:", signalClass];
				selector = NSSelectorFromString( selectorName );
				
				performed = [self perform:signal target:signalTarget selector:selector class:signalTargetClass history:history];
				if ( performed )
				{
					[_selectorCache setObject:selectorName forKey:cacheName];
					break;
				}
			}
			
			// eg. handleUISignal_mask
			
			selectorName = [NSString stringWithFormat:@"handleUISignal_%@:", signal.name];
			selectorName = [selectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
			selectorName = [selectorName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
			selectorName = [selectorName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
			selector = NSSelectorFromString( selectorName );
			
			performed = [self perform:signal target:signalTarget selector:selector class:signalTargetClass history:history];
			if ( performed )
			{
				[_selectorCache setObject:selectorName forKey:cacheName];
				break;
			}
			
			for ( Class rtti = [signal.source class]; nil != rtti && rtti != [NSObject class]; rtti = class_getSuperclass(rtti) )
			{
				// eg. handleUISignal_BeeUIBoard_CREATE_VIEWS
				
				if ( signalMethod && signalMethod.length )
				{
					selectorName = [NSString stringWithFormat:@"handleUISignal_%@_%@:", [rtti description], signalMethod];
					selector = NSSelectorFromString( selectorName );
					
					performed = [self perform:signal target:signalTarget selector:selector class:signalTargetClass history:history];
					if ( performed )
					{
						[_selectorCache setObject:selectorName forKey:cacheName];
						break;
					}
				}
				
				// eg. handleUISignal_MyCell_mask
				
				if ( tagString && tagString.length )
				{
					selectorName = [NSString stringWithFormat:@"handleUISignal_%@_%@:", [rtti description], tagString];
					selector = NSSelectorFromString( selectorName );
					
					performed = [self perform:signal target:signalTarget selector:selector class:signalTargetClass history:history];
					if ( performed )
					{
						[_selectorCache setObject:selectorName forKey:cacheName];
						break;
					}

					selectorName = [NSString stringWithFormat:@"handleUISignal_%@:", tagString];
					selector = NSSelectorFromString( selectorName );
					
					performed = [self perform:signal target:signalTarget selector:selector class:signalTargetClass history:history];
					if ( performed )
					{
						[_selectorCache setObject:selectorName forKey:cacheName];
						break;
					}
				}
				
				// eg. handleUISignal_BeeUIBoard
				
				selectorName = [NSString stringWithFormat:@"handleUISignal_%@:", [rtti description]];
				selector = NSSelectorFromString( selectorName );
				
				performed = [self perform:signal target:signalTarget selector:selector class:signalTargetClass history:history];
				if ( performed )
				{
					[_selectorCache setObject:selectorName forKey:cacheName];
					break;
				}
			}
			
			if ( NO == performed )
			{
				// default case
				
//				ERROR( @"unhandled signal '%@' to '%@'", signal.name, [[signalTarget class] description] );
				
				selectorName = @"handleUISignal:";
				selector = NSSelectorFromString( selectorName );
				
				performed = [self perform:signal target:signalTarget selector:selector class:signalTargetClass history:history];
				if ( performed )
				{
					[_selectorCache setObject:selectorName forKey:cacheName];
					break;
				}
			}
		}
		while ( 0 );
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
