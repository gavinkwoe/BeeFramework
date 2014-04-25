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

#import "Bee_UILayout.h"
#import "Bee_UILayoutBuilder.h"
#import "Bee_UILayoutContainer.h"

#import "Bee_UIStyle.h"
#import "Bee_UIStyleManager.h"
#import "BeeUIStyle+Builder.h"
#import "BeeUIStyle+Property.h"

#import "UIView+BeeUISignal.h"
#import "UIView+BeeUIStyle.h"
#import "UIView+BeeUILayout.h"
#import "UIView+Tag.h"
#import "UIView+Traversing.h"
#import "UIView+UIViewController.h"

#import "Bee_UICapability.h"
#import "NSObject+UIPropertyMapping.h"

#pragma mark -

@interface BeeUILayout()
{
	NSMutableArray *		_stack;
	BeeUILayout *			_root;
	BeeUILayout *			_parent;
	NSString *				_name;
	NSString *				_value;

	BeeUIStyle *			_styleRoot;
	NSMutableArray *        _styleClasses;
	BeeUIStyle *			_styleInline;
	BeeUIStyle *			_styleMerged;
	
	Class					_classType;
	NSString *				_elemName;
	NSString *				_className;
	NSMutableArray *		_childs;

	BOOL					_containable;
	BOOL					_visible;
	BOOL					_isRoot;
}

- (BeeUILayout *)topLayout;
- (void)pushLayout:(BeeUILayout *)layout;
- (void)popLayout;

@end

#pragma mark -

@implementation BeeUILayout

@synthesize containable = _containable;
@synthesize visible = _visible;
@synthesize root = _root;
@synthesize parent = _parent;
@synthesize name = _name;
@synthesize value = _value;

@synthesize styleRoot = _styleRoot;
@synthesize styleInline = _styleInline;
@synthesize styleClasses = _styleClasses;
@synthesize styleMerged = _styleMerged;

@synthesize classType = _classType;
@synthesize elemName = _elemName;
@synthesize className = _className;
@synthesize childs = _childs;
@synthesize isRoot = _isRoot;
@synthesize DOMPath = _DOMPath;

@dynamic ADD;
@dynamic REMOVE;
@dynamic REMOVE_ALL;

@dynamic CONTAINER_BEGIN;
@dynamic CONTAINER_END;
@dynamic VIEW;

@dynamic DUMP;

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ '%@'", [[self class] description], self.name];
}

+ (NSString *)generateName
{
	static NSUInteger __seed = 0;
	return [NSString stringWithFormat:@"layout_%u", __seed++];
}

+ (BeeUILayout *)layout
{
	return [self layout:0];
}

+ (BeeUILayout *)layout:(NSUInteger)version
{
	BeeUILayout * layout = [[[BeeUILayout alloc] init] autorelease];
	layout.version = version;
	return layout;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.version = 1;
		self.containable = YES;
		self.visible = YES;
		self.root = self;
		self.parent = nil;
		self.name = [BeeUILayout generateName];
		self.value = nil;
		
		self.styleClasses = [NSMutableArray array];
		self.styleInline = [BeeUIStyle style];
		self.styleRoot = nil;
		self.styleMerged = nil;

		self.classType = nil;
		self.elemName = nil;
		self.className = nil;
		self.childs = [NSMutableArray array];
	}
	return self;
}

- (void)dealloc
{
	[self.childs removeAllObjects];
	self.childs = nil;
	
	self.root = nil;
	self.parent = nil;
	self.name = nil;
	self.value = nil;

	self.styleClasses = nil;
	self.styleInline = nil;
	self.styleRoot = nil;
	self.styleMerged = nil;

	self.classType = nil;
	self.elemName = nil;
	self.className = nil;

	if ( _stack )
	{
		[_stack removeAllObjects];
		[_stack release];
		_stack = nil;
	}
	
	[super dealloc];
}

- (void)dump
{
#if __BEE_DEVELOPMENT__

	INFO( @"%@(%d childs) %@", self.name, self.childs.count, self );

	[[BeeLogger sharedInstance] indent];

	for ( BeeUILayout * child in self.childs )
	{
		[child dump];
	}

	[[BeeLogger sharedInstance] unindent];
	
#endif	// #if __BEE_DEVELOPMENT__
}

- (NSString *)DOMPath
{
	NSMutableString * result = [NSMutableString string];
	
	for ( BeeUILayout * layout = self; nil != layout; layout = layout.parent )
	{
		[result appendFormat:@"%@>", layout.name];
	}

	return result;
}

- (UIView *)createView
{
	if ( nil == self.classType )
		return nil;

	Class classType = self.classType;
	if ( classType != [UIView class] && NO == [classType isSubclassOfClass:[UIView class]] )
		return nil;

	UIView * view = [[[classType alloc] initWithFrame:CGRectZero] autorelease];
	if ( view )
	{
        if ( nil == view.layout )
        {
            view.layout = self;
        }
        
		view.nameSpace = self.root.name;
		view.tagString = self.name;
		view.tagClasses = self.styleClasses;

		view.UIStyleRoot = self.styleRoot;
		view.UIStyleClasses = self.styleClasses;
		view.UIStyleInline = self.styleInline;
		view.UIStyle = self.styleMerged;

		view.UILayoutTag = self.name;
		view.UILayoutClassName = self.className;
		view.UILayoutElemName = self.elemName;

		view.UIDOMPath = self.DOMPath;

		[view applyStyle];

//		INFO( @"CreateView %p '%@', tag = '%@'", view, [self.classType description], self.name );
	}

	return view;
}

- (UIView *)createTree
{
	UIView * view = [self createView];
	if ( view )
	{
		for ( UIView * subview in [[view.subviews copy] autorelease] )
		{
			[subview removeFromSuperview];
		}

		[self buildFor:view];
	}
	return view;
}

- (void)buildFor:(UIView *)canvas
{
	BeeUILayoutBuilder * builder = [BeeUILayoutBuilder builder:self.version];
	builder.rootCanvas = canvas;
	builder.rootLayout = self;
	[builder buildTree];

	if ( [[canvas class] supportForUIPropertyMapping] )
	{
		UIViewController * controller = [canvas viewController];
		if ( controller )
		{
			[controller mapPropertiesFromView:canvas];
		}
		else
		{
			[canvas mapPropertiesFromView:canvas];
		}
	}
}

- (void)layoutFor:(UIView *)canvas inBound:(CGRect)bound
{
	if ( bound.size.width <= 0.0f || bound.size.height <= 0.0f )
	{
		return;
	}
	
	// TODO: read cache
	
	BeeUILayoutBuilder * builder = [BeeUILayoutBuilder builder:self.version];
	builder.rootCanvas = canvas;
	builder.rootLayout = self;
	[builder layoutTree:bound];
	
	// TODO: save cache
}

- (CGRect)estimateFor:(UIView *)canvas inBound:(CGRect)bound
{
	BeeUILayoutBuilder * builder = [BeeUILayoutBuilder builder:self.version];
	builder.rootCanvas = canvas;
	builder.rootLayout = self;
	return [builder estimateRect:bound];
}

- (void)mergeRootStyle:(BeeUIStyle *)style
{
	self.styleRoot = style;
	
	if ( self.styleInline )
	{
		self.styleInline.root = style;
	}
	
	if ( self.styleMerged )
	{
		self.styleMerged.root = style;
	}
	
	[self mergeStyle];
}

- (void)mergeStyle
{
	BeeUIStyle * merged = [BeeUIStyle style];
	if ( merged )
	{
	// single style
		
		BeeUIStyle * style1 = self.styleInline;

        BeeUIStyle * style2 = [self.styleRoot childStyleWithElement:self];
		
		BeeUIStyle * globalStyle = [BeeUIStyleManager sharedInstance].defaultStyle;
        
		if ( globalStyle )
		{
			BeeUIStyle * style3 = [globalStyle childStyleWithElement:self];
            [style3 mergeTo:merged];
		}
		
        if ( style2 && style2.properties.count )
		{
			[style2 mergeTo:merged];
		}
		
		if ( style1 && style1.properties.count )
		{
			[style1 mergeTo:merged];
		}

		self.styleMerged = merged;
	}
}

#pragma mark -

- (BeeUILayout *)topLayout
{
	if ( nil == _stack || 0 == _stack.count )
		return self;
	
	return _stack.lastObject;
}

- (void)pushLayout:(BeeUILayout *)layout
{
	if ( nil == layout )
		return;
	
	if ( nil == _stack )
	{
		_stack = [[NSMutableArray alloc] init];
	}
	
	[_stack pushTail:layout];
}

- (void)popLayout
{
	if ( _stack )
	{
		[_stack popTail];
	}
}

#pragma mark -

- (BeeUILayoutBlockS)CONTAINER_BEGIN
{
	BeeUILayoutBlockS block = ^ BeeUILayout * ( NSString * tag )
	{
		[[BeeLogger sharedInstance] indent];

		BeeUILayout * layout = [BeeUILayout layout];
		if ( layout )
		{
			layout.containable = YES;
			layout.root = self.root;
			layout.parent = self.containable ? self : self.parent;
			layout.visible = layout.parent.visible;

			if ( tag && tag.length )
			{
				layout.name = tag;
			}

//			layout.W( @"wrap_content" );
//			layout.H( @"wrap_content" );

			[layout.parent.childs addObject:layout];
		}
		
//		INFO( @"container %@", layout.name );
        
		[self.root pushLayout:layout];
		
		return [self.root topLayout];
	};

	return [[block copy] autorelease];
}

- (BeeUILayoutBlock)CONTAINER_END
{
	BeeUILayoutBlock block = ^ BeeUILayout * ( void )
	{
		[[BeeLogger sharedInstance] unindent];

//		INFO( @"end of container '%@'", self.name );

		[self.root popLayout];
		
		return [self.root topLayout];
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlockS)VIEW
{
	BeeUILayoutBlockS block = ^ BeeUILayout * ( NSString * tag )
	{
		BeeUILayout * layout = [BeeUILayout layout];
		if ( layout )
		{
			layout.containable = NO;
			layout.root = self.root;
			layout.parent = self.containable ? self : self.parent;			
			layout.visible = layout.parent.visible;

			if ( tag && tag.length )
			{
				layout.name = tag;
			}

			[layout.parent.childs addObject:layout];
		}

//		INFO( @"view(%@) %@", [clazz description], layout.name );

		return layout;
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)