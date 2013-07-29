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

#import "Bee_UITemplateCompiler.h"
#import "Bee_UITemplateContext.h"
#import "Bee_UITemplateTokenlizer.h"

#import "Bee_UITemplateSyntaxTree.h"
#import "Bee_UITemplateSyntaxEXPR.h"
#import "Bee_UITemplateSyntaxFOR.h"
#import "Bee_UITemplateSyntaxIF.h"
#import "Bee_UITemplateSyntaxTEXT.h"

#pragma mark -

@interface BeeUITemplateCompiler()
{
	BeeUITemplateTokenlizer *	_tokenlizer;
	BeeUITemplateContext *		_context;
	NSMutableString *			_result;
	ASTNode *					_syntax;
}

- (void)parseSyntaxTreeforNode:(ASTNode *)node;
- (void)parseSyntaxTree;
- (void)renderSyntaxTree;

@end

#pragma mark -

@implementation BeeUITemplateCompiler

@synthesize tokenlizer = _tokenlizer;
@synthesize context = _context;
@synthesize result = _result;
@synthesize syntax = _syntax;

@dynamic RENDER;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.tokenlizer = [[[BeeUITemplateTokenlizer alloc] init] autorelease];
		self.context = [[[BeeUITemplateContext alloc] init] autorelease];
		
		self.result = nil;
		self.syntax = nil;
	}
	return self;
}

- (void)dealloc
{
	self.result = nil;
	self.syntax = nil;

	self.tokenlizer = nil;
	self.context = nil;
	
	[super dealloc];
}

#pragma mark -

- (void)parseSyntaxTreeforNode:(ASTNode *)parentNode
{
	BOOL		loopFlag = YES;
	ASTNode *	currNode = nil;
	
	while ( loopFlag )
	{
		BOOL succeed = [self.tokenlizer nextToken];
		if ( NO == succeed )
		{
			INFO( @"no token else" );
			break;
		}

		BOOL	nodePair = NO;
		Class	nodeClass = nil;

		if ( BeeUITemplateTokenlizer.TOKEN_TEXT == self.tokenlizer.tokenType )
		{
			nodePair = NO;
			nodeClass = [ASTNodeTEXT class];
		}
		else if ( BeeUITemplateTokenlizer.TOKEN_IF == self.tokenlizer.tokenType )
		{
			nodePair = YES;
			nodeClass = [ASTNodeIF class];
		}
		else if ( BeeUITemplateTokenlizer.TOKEN_FOR == self.tokenlizer.tokenType )
		{
			nodePair = YES;
			nodeClass = [ASTNodeFOR class];
		}
		else if ( BeeUITemplateTokenlizer.TOKEN_EXPR == self.tokenlizer.tokenType )
		{
			nodePair = NO;
			nodeClass = [ASTNodeEXPR class];
		}
		else if ( BeeUITemplateTokenlizer.TOKEN_EOF == self.tokenlizer.tokenType )
		{
			INFO( @"end of file" );
			break;
		}
		else if ( BeeUITemplateTokenlizer.TOKEN_END == self.tokenlizer.tokenType )
		{
			loopFlag = NO;
			
			INFO( @"end" );
			return;
		}

		if ( loopFlag )
		{
			if ( currNode )
			{
				currNode = [currNode spawnSibling:nodeClass];
			}
			else
			{
				currNode = [parentNode spawnChild:nodeClass];
			}

			currNode.source = self.tokenlizer.tokenInnerString;

			if ( nodePair )
			{
				[self parseSyntaxTreeforNode:currNode];

				if ( BeeUITemplateTokenlizer.TOKEN_END != self.tokenlizer.tokenType )
				{
					ERROR( @"'%@' not match", currNode.source );
					return;
				}
			}
		}
	}
}

- (void)parseSyntaxTree
{
	[self parseSyntaxTreeforNode:self.syntax];
}

- (void)renderSyntaxTree
{
	self.result = [self.syntax renderInContext:self.context];

	VAR_DUMP( self.result );
}

#pragma mark -

- (BeeUITemplateCompilerBlockN)RENDER
{
	BeeUITemplateCompilerBlockN block = ^ BeeUITemplateCompiler * ( id first, ... )
	{
		self.result = nil;
		self.syntax = nil;

		if ( nil == first || NO == [first isKindOfClass:[NSString class]] )
			return self;

		NSString * source = (NSString *)first;
		if ( 0 == source.length )
			return self;

		self.result = @"";
		self.syntax = [ASTNode spawn];

		[self.tokenlizer reset];
		[self.tokenlizer setSource:source];

		[self parseSyntaxTree];
		[self renderSyntaxTree];

		return self;
	};

	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
