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

#import "Bee_UITemplateSyntaxTree.h"

#pragma mark -

@interface ASTNode()
{
	NSUInteger			_type;
	ASTNode *			_parent;
	ASTNode *			_prev;
	ASTNode *			_next;
	NSMutableArray *	_childs;
	NSString *			_source;
}
@end

#pragma mark -

@implementation ASTNode

@synthesize type = _type;
@synthesize parent = _parent;
@synthesize prev = _prev;
@synthesize next = _next;
@synthesize childs = _childs;
@synthesize source = _source;

DEF_INT( TYPE_UNKNOWN,	0 )
DEF_INT( TYPE_TEXT,		1 )
DEF_INT( TYPE_IF,		2 )
DEF_INT( TYPE_FOR,		3 )
DEF_INT( TYPE_ECHO,		4 )

+ (ASTNode *)spawn
{
	return [[[self alloc] init] autorelease];
}

- (ASTNode *)spawnChild:(Class)clazz
{
	ASTNode * node = [[[clazz alloc] init] autorelease];
	if ( node )
	{
		[self.childs addObject:node];

		node.parent = self;
	}
	return node;
}

- (ASTNode *)spawnSibling:(Class)clazz
{
	ASTNode * node = [[[clazz alloc] init] autorelease];
	if ( node )
	{
		[self.parent.childs addObject:node];

		node.parent = self.parent;
		node.prev = self;
	}
	return node;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		_type = self.TYPE_UNKNOWN;
		_childs = [[NSMutableArray alloc] init];
		_source = nil;
	}
	return self;
}

- (void)dealloc
{
	[_childs removeAllObjects];
	[_childs release];
	
	[_source release];
	
	[super dealloc];
}

- (NSString *)renderInContext:(BeeUITemplateContext *)context
{
	NSMutableString * renderedText = [NSMutableString string];
	
	for ( ASTNode * node in self.childs )
	{
		NSString * text = [node renderInContext:context];
		if ( text && text.length )
		{
			[renderedText appendString:text];
		}
	}
	
	return renderedText;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
