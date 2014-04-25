//
//  CXMLNode.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/07/08.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//     1. Redistributions of source code must retain the above copyright notice, this list of
//        conditions and the following disclaimer.
//
//     2. Redistributions in binary form must reproduce the above copyright notice, this list
//        of conditions and the following disclaimer in the documentation and/or other materials
//        provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY TOXICSOFTWARE.COM ``AS IS'' AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL TOXICSOFTWARE.COM OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those of the
//  authors and should not be interpreted as representing official policies, either expressed
//  or implied, of toxicsoftware.com.

#import "CXMLNode.h"

#import "CXMLNode_PrivateExtensions.h"
#import "CXMLDocument.h"
#import "CXMLElement.h"
#import "CXMLNode_CreationExtensions.h"

#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>
#include <libxml/xmlIO.h>

static int MyXmlOutputWriteCallback(void * context, const char * buffer, int len);
static int MyXmlOutputCloseCallback(void * context);


@implementation CXMLNode

- (void)dealloc
{
[self invalidate];
//
[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone;
{
#pragma unused (zone)
xmlNodePtr theNewNode = xmlCopyNode(_node, 1);
CXMLNode *theNode = [[[self class] alloc] initWithLibXMLNode:theNewNode freeOnDealloc:YES];
theNewNode->_private = theNode;
return(theNode);
}

#pragma mark -

- (CXMLNodeKind)kind
{
NSAssert(_node != NULL, @"CXMLNode does not have attached libxml2 _node.");
return((CXMLNodeKind)_node->type); // TODO this isn't 100% accurate!
}

- (NSString *)name
{
	NSAssert(_node != NULL, @"CXMLNode does not have attached libxml2 _node.");
	// TODO use xmlCheckUTF8 to check name
	if (_node->name == NULL)
		return(NULL);
	
	NSString *localName = [NSString stringWithUTF8String:(const char *)_node->name];
	
	if (_node->ns == NULL || _node->ns->prefix == NULL)
		return localName;
	
	return [NSString stringWithFormat:@"%@:%@",	[NSString stringWithUTF8String:(const char *)_node->ns->prefix], localName];
}

- (NSString *)stringValue
{
	NSAssert(_node != NULL, @"CXMLNode does not have attached libxml2 _node.");
	
	if (_node->type == XML_TEXT_NODE || _node->type == XML_CDATA_SECTION_NODE) 
		return [NSString stringWithUTF8String:(const char *)_node->content];
	
	if (_node->type == XML_ATTRIBUTE_NODE)
		return [NSString stringWithUTF8String:(const char *)_node->children->content];

	NSMutableString *theStringValue = [[[NSMutableString alloc] init] autorelease];
	
	for (CXMLNode *child in [self children])
	{
		[theStringValue appendString:[child stringValue]];
	}
	
	return theStringValue;
}

- (NSUInteger)index
{
NSAssert(_node != NULL, @"CXMLNode does not have attached libxml2 _node.");

xmlNodePtr theCurrentNode = _node->prev;
NSUInteger N;
for (N = 0; theCurrentNode != NULL; ++N, theCurrentNode = theCurrentNode->prev)
	;
return(N);
}

- (NSUInteger)level
{
NSAssert(_node != NULL, @"CXMLNode does not have attached libxml2 _node.");

xmlNodePtr theCurrentNode = _node->parent;
NSUInteger N;
for (N = 0; theCurrentNode != NULL; ++N, theCurrentNode = theCurrentNode->parent)
	;
return(N);
}

- (CXMLDocument *)rootDocument
{
NSAssert(_node != NULL, @"CXMLNode does not have attached libxml2 _node.");

return(_node->doc->_private);
}

- (CXMLNode *)parent
{
NSAssert(_node != NULL, @"CXMLNode does not have attached libxml2 _node.");

if (_node->parent == NULL)
	return(NULL);
else
	return (_node->parent->_private);
}

- (NSUInteger)childCount
{
	NSAssert(_node != NULL, @"CXMLNode does not have attached libxml2 _node.");
	
	if (_node->type == CXMLAttributeKind)
		return 0; // NSXMLNodes of type NSXMLAttributeKind can't have children
		
	xmlNodePtr theCurrentNode = _node->children;
	NSUInteger N;
	for (N = 0; theCurrentNode != NULL; ++N, theCurrentNode = theCurrentNode->next)
		;
	return(N);
}

- (NSArray *)children
{
	NSAssert(_node != NULL, @"CXMLNode does not have attached libxml2 _node.");
	
	NSMutableArray *theChildren = [NSMutableArray array];
	
	if (_node->type != CXMLAttributeKind) // NSXML Attribs don't have children.
	{
		xmlNodePtr theCurrentNode = _node->children;
		while (theCurrentNode != NULL)
		{
			CXMLNode *theNode = [CXMLNode nodeWithLibXMLNode:theCurrentNode freeOnDealloc:NO];
			[theChildren addObject:theNode];
			theCurrentNode = theCurrentNode->next;
		}
	}
	return(theChildren);      
}

- (CXMLNode *)childAtIndex:(NSUInteger)index
{
NSAssert(_node != NULL, @"CXMLNode does not have attached libxml2 _node.");

xmlNodePtr theCurrentNode = _node->children;
NSUInteger N;
for (N = 0; theCurrentNode != NULL && N != index; ++N, theCurrentNode = theCurrentNode->next)
	;
if (theCurrentNode)
	return([CXMLNode nodeWithLibXMLNode:theCurrentNode freeOnDealloc:NO]);
return(NULL);
}

- (CXMLNode *)previousSibling
{
NSAssert(_node != NULL, @"CXMLNode does not have attached libxml2 _node.");

if (_node->prev == NULL)
	return(NULL);
else
	return([CXMLNode nodeWithLibXMLNode:_node->prev freeOnDealloc:NO]);
}

- (CXMLNode *)nextSibling
{
NSAssert(_node != NULL, @"CXMLNode does not have attached libxml2 _node.");

if (_node->next == NULL)
	return(NULL);
else
	return([CXMLNode nodeWithLibXMLNode:_node->next freeOnDealloc:NO]);
}

//- (CXMLNode *)previousNode;
//- (CXMLNode *)nextNode;
//- (NSString *)XPath;

- (NSString *)localName
{
NSAssert(_node != NULL, @"CXMLNode does not have attached libxml2 _node.");
// TODO use xmlCheckUTF8 to check name
if (_node->name == NULL)
	return(NULL);
else
	return([NSString stringWithUTF8String:(const char *)_node->name]);
}

- (NSString *)prefix
{
if (_node->ns && _node->ns->prefix)
	return([NSString stringWithUTF8String:(const char *)_node->ns->prefix]);
else
	return(@"");
}

- (NSString *)URI
{
if (_node->ns)
	return([NSString stringWithUTF8String:(const char *)_node->ns->href]);
else
	return(NULL);
}

+ (NSString *)localNameForName:(NSString *)name
{
	NSRange split = [name rangeOfString:@":"];
	
	if (split.length > 0)
		return [name substringFromIndex:split.location + 1];
	
	return name;
}

+ (NSString *)prefixForName:(NSString *)name
{
	NSRange split = [name rangeOfString:@":"];
	
	if (split.length > 0)
		return [name substringToIndex:split.location];
	
	return @"";
}

+ (CXMLNode *)predefinedNamespaceForPrefix:(NSString *)name
{
	if ([name isEqualToString:@"xml"])
		return [CXMLNode namespaceWithName:@"xml" stringValue:@"http://www.w3.org/XML/1998/namespace"];
	
	if ([name isEqualToString:@"xs"])
		return [CXMLNode namespaceWithName:@"xs" stringValue:@"http://www.w3.org/2001/XMLSchema"];
	
	if ([name isEqualToString:@"xsi"])
		return [CXMLNode namespaceWithName:@"xsi" stringValue:@"http://www.w3.org/2001/XMLSchema-instance"];
	
	if ([name isEqualToString:@"xmlns"]) // Not in Cocoa, but should be as it's reserved by W3C
		return [CXMLNode namespaceWithName:@"xmlns" stringValue:@"http://www.w3.org/2000/xmlns/"];
	
	return nil;
}

- (NSString *)description
{
NSAssert(_node != NULL, @"CXMLNode does not have attached libxml2 _node.");

return([NSString stringWithFormat:@"<%@ %p [%p] %@ %@>", NSStringFromClass([self class]), self, self->_node, [self name], [self XMLStringWithOptions:0]]);
}

- (NSString *)XMLString
{
return([self XMLStringWithOptions:0]);
}

- (NSString *)XMLStringWithOptions:(NSUInteger)options
{
#pragma unused (options)

NSMutableData *theData = [[[NSMutableData alloc] init] autorelease];

xmlOutputBufferPtr theOutputBuffer = xmlOutputBufferCreateIO(MyXmlOutputWriteCallback, MyXmlOutputCloseCallback, theData, NULL);

xmlNodeDumpOutput(theOutputBuffer, _node->doc, _node, 0, 0, "utf-8");

xmlOutputBufferFlush(theOutputBuffer);

NSString *theString = [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];

xmlOutputBufferClose(theOutputBuffer);

return(theString);
}
//- (NSString *)canonicalXMLStringPreservingComments:(BOOL)comments;

- (NSArray *)nodesForXPath:(NSString *)xpath error:(NSError **)error
{
#pragma unused (error)

NSAssert(_node != NULL, @"CXMLNode does not have attached libxml2 _node.");

NSArray *theResult = NULL;

xmlXPathContextPtr theXPathContext = xmlXPathNewContext(_node->doc);
theXPathContext->node = _node;

// TODO considering putting xmlChar <-> UTF8 into a NSString category
xmlXPathObjectPtr theXPathObject = xmlXPathEvalExpression((const xmlChar *)[xpath UTF8String], theXPathContext);
if (theXPathObject == NULL)
	{
	if (error)
		*error = [NSError errorWithDomain:@"TODO_DOMAIN" code:-1 userInfo:NULL];
	return(NULL);
	}
if (xmlXPathNodeSetIsEmpty(theXPathObject->nodesetval))
	theResult = [NSArray array]; // TODO better to return NULL?
else
	{
	NSMutableArray *theArray = [NSMutableArray array];
	int N;
	for (N = 0; N < theXPathObject->nodesetval->nodeNr; N++)
		{
		xmlNodePtr theNode = theXPathObject->nodesetval->nodeTab[N];
		[theArray addObject:[CXMLNode nodeWithLibXMLNode:theNode freeOnDealloc:NO]];
		}
		
	theResult = theArray;
	}

xmlXPathFreeObject(theXPathObject);
xmlXPathFreeContext(theXPathContext);
return(theResult);
}

//- (NSArray *)objectsForXQuery:(NSString *)xquery constants:(NSDictionary *)constants error:(NSError **)error;
//- (NSArray *)objectsForXQuery:(NSString *)xquery error:(NSError **)error;


@end

static int MyXmlOutputWriteCallback(void * context, const char * buffer, int len)
{
NSMutableData *theData = context;
[theData appendBytes:buffer length:len];
return(len);
}

static int MyXmlOutputCloseCallback(void * context)
{
return(0);
}
