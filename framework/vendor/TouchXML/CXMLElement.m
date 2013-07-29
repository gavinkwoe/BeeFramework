//
//  CXMLElement.m
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

#import "CXMLElement.h"

#import "CXMLNode_PrivateExtensions.h"
#import "CXMLNode_CreationExtensions.h"
#import "CXMLNamespaceNode.h"

@implementation CXMLElement

- (NSArray *)elementsForName:(NSString *)name
    {
    NSMutableArray *theElements = [NSMutableArray array];

    // TODO -- native xml api?
    const xmlChar *theName = (const xmlChar *)[name UTF8String];

    xmlNodePtr theCurrentNode = _node->children;
    while (theCurrentNode != NULL)
        {
        if (theCurrentNode->type == XML_ELEMENT_NODE && xmlStrcmp(theName, theCurrentNode->name) == 0)
            {
            CXMLNode *theNode = [CXMLNode nodeWithLibXMLNode:(xmlNodePtr)theCurrentNode freeOnDealloc:NO];
            [theElements addObject:theNode];
            }
        theCurrentNode = theCurrentNode->next;
        }
    return(theElements);
    }

- (NSArray *)elementsForLocalName:(NSString *)localName URI:(NSString *)URI
    {
	if (URI == nil || [URI length] == 0)
        {
		return [self elementsForName:localName];
        }
	
	NSMutableArray *theElements = [NSMutableArray array];
	const xmlChar *theLocalName = (const xmlChar *)[localName UTF8String];
	const xmlChar *theNamespaceName = (const xmlChar *)[URI UTF8String];
	
	xmlNodePtr theCurrentNode = _node->children;
	while (theCurrentNode != NULL)
        {
		if (theCurrentNode->type == XML_ELEMENT_NODE 
			&& xmlStrcmp(theLocalName, theCurrentNode->name) == 0
			&& theCurrentNode->ns
			&& xmlStrcmp(theNamespaceName, theCurrentNode->ns->href) == 0)
            {
			CXMLNode *theNode = [CXMLNode nodeWithLibXMLNode:(xmlNodePtr)theCurrentNode freeOnDealloc:NO];
			[theElements addObject:theNode];
            }
		theCurrentNode = theCurrentNode->next;
        }	
	
	return theElements;
    }

- (NSArray *)attributes
    {
    NSMutableArray *theAttributes = [NSMutableArray array];
    xmlAttrPtr theCurrentNode = _node->properties;
    while (theCurrentNode != NULL)
        {
        CXMLNode *theAttribute = [CXMLNode nodeWithLibXMLNode:(xmlNodePtr)theCurrentNode freeOnDealloc:NO];
        [theAttributes addObject:theAttribute];
        theCurrentNode = theCurrentNode->next;
        }
    return(theAttributes);
    }

- (CXMLNode *)attributeForName:(NSString *)name
    {
	// TODO -- look for native libxml2 function for finding a named attribute (like xmlGetProp)
	
	NSRange split = [name rangeOfString:@":"];
	
	xmlChar *theLocalName = NULL;
	xmlChar *thePrefix = NULL;
	
	if (split.length > 0)
        {
		theLocalName = (xmlChar *)[[name substringFromIndex:split.location + 1] UTF8String];
		thePrefix = (xmlChar *)[[name substringToIndex:split.location] UTF8String];
        } 
	else 
        {
		theLocalName = (xmlChar *)[name UTF8String];
        }
	
	xmlAttrPtr theCurrentNode = _node->properties;
	while (theCurrentNode != NULL)
        {
		if (xmlStrcmp(theLocalName, theCurrentNode->name) == 0)
            {
			if (thePrefix == NULL || (theCurrentNode->ns 
                && theCurrentNode->ns->prefix 
                && xmlStrcmp(thePrefix, theCurrentNode->ns->prefix) == 0))
                {
				CXMLNode *theAttribute = [CXMLNode nodeWithLibXMLNode:(xmlNodePtr)theCurrentNode freeOnDealloc:NO];
				return(theAttribute);
                }
            }
		theCurrentNode = theCurrentNode->next;
        }
	return(NULL);
    }

- (CXMLNode *)attributeForLocalName:(NSString *)localName URI:(NSString *)URI
    {
	if (URI == nil)
        {
		return [self attributeForName:localName];
        }
	
	// TODO -- look for native libxml2 function for finding a named attribute (like xmlGetProp)
	const xmlChar *theLocalName = (const xmlChar *)[localName UTF8String];
	const xmlChar *theNamespaceName = (const xmlChar *)[URI UTF8String];
	
	xmlAttrPtr theCurrentNode = _node->properties;
	while (theCurrentNode != NULL)
        {
		if (theCurrentNode->ns && theCurrentNode->ns->href &&
			xmlStrcmp(theLocalName, theCurrentNode->name) == 0 &&
			xmlStrcmp(theNamespaceName, theCurrentNode->ns->href) == 0)
            {
			CXMLNode *theAttribute = [CXMLNode nodeWithLibXMLNode:(xmlNodePtr)theCurrentNode freeOnDealloc:NO];
			return(theAttribute);
            }
		theCurrentNode = theCurrentNode->next;
        }
	return(NULL);
    }

- (NSArray *)namespaces
    {
	NSMutableArray *theNamespaces = [[[NSMutableArray alloc] init] autorelease];
	xmlNsPtr theCurrentNamespace = _node->nsDef;
	
	while (theCurrentNamespace != NULL)
        {
		NSString *thePrefix = theCurrentNamespace->prefix ? [NSString stringWithUTF8String:(const char *)theCurrentNamespace->prefix] : @"";
		NSString *theURI = [NSString stringWithUTF8String:(const char *)theCurrentNamespace->href];
		CXMLNamespaceNode *theNode = [[CXMLNamespaceNode alloc] initWithPrefix:thePrefix URI:theURI parentElement:self];
		[theNamespaces addObject:theNode];
		[theNode release];		
		
		theCurrentNamespace = theCurrentNamespace->next;
        }
	
	return theNamespaces;
    }

- (CXMLNode *)namespaceForPrefix:(NSString *)name
    {
	const xmlChar *thePrefix = (const xmlChar *)[name UTF8String];
	xmlNsPtr theCurrentNamespace = _node->nsDef;
	
	while (theCurrentNamespace != NULL)
        {
		if (xmlStrcmp(theCurrentNamespace->prefix, thePrefix) == 0)
            {
			NSString *thePrefixString = theCurrentNamespace->prefix ? [NSString stringWithUTF8String:(const char *)theCurrentNamespace->prefix] : @"";
			NSString *theURI = [NSString stringWithUTF8String:(const char *)theCurrentNamespace->href];
			return [[[CXMLNamespaceNode alloc] initWithPrefix:thePrefixString URI:theURI parentElement:self] autorelease];
            }			
		theCurrentNamespace = theCurrentNamespace->next;
        }
	return nil;
    }

- (CXMLNode *)resolveNamespaceForName:(NSString *)name
{
	NSRange split = [name rangeOfString:@":"];
	
	if (split.length > 0)
		return [self namespaceForPrefix:[name substringToIndex:split.location]];
	
	xmlNsPtr theCurrentNamespace = _node->nsDef;
	
	while (theCurrentNamespace != NULL)
	{
		if (theCurrentNamespace->prefix == 0 
			|| (theCurrentNamespace->prefix)[0] == 0)
		{
			NSString *thePrefix = theCurrentNamespace->prefix ? [NSString stringWithUTF8String:(const char *)theCurrentNamespace->prefix] : @"";
			NSString *theURI = [NSString stringWithUTF8String:(const char *)theCurrentNamespace->href];
			return [[[CXMLNamespaceNode alloc] initWithPrefix:thePrefix URI:theURI parentElement:self] autorelease];
		}			
		theCurrentNamespace = theCurrentNamespace->next;
	}
	
	return nil;
}

- (NSString *)resolvePrefixForNamespaceURI:(NSString *)namespaceURI
{
	const xmlChar *theXMLURI = (const xmlChar *)[namespaceURI UTF8String];
	
	xmlNsPtr theCurrentNamespace = _node->nsDef;
	
	while (theCurrentNamespace != NULL)
	{
		if (xmlStrcmp(theCurrentNamespace->href, theXMLURI) == 0)
		{
			if(theCurrentNamespace->prefix) 
				return [NSString stringWithUTF8String:(const char *)theCurrentNamespace->prefix];
			
			return @"";
		}			
		theCurrentNamespace = theCurrentNamespace->next;
	}
	return nil;
}

//- (NSString*)_XMLStringWithOptions:(NSUInteger)options appendingToString:(NSMutableString*)str
//{
//NSString* name = [self name];
//[str appendString:[NSString stringWithFormat:@"<%@", name]];
//
//for (id attribute in [self attributes] )
//	{
//	[attribute _XMLStringWithOptions:options appendingToString:str];
//	}
//
//if ( ! _node->children )
//	{
//	bool isEmpty = NO;
//	NSArray *emptyTags = [NSArray arrayWithObjects: @"br", @"area", @"link", @"img", @"param", @"hr", @"input", @"col", @"base", @"meta", nil ];
//	for (id s in emptyTags)
//		{
//		if ( [s isEqualToString:@"base"] )
//			{
//			isEmpty = YES;
//			break;
//			}
//		}
//	if ( isEmpty )
//		{
//		[str appendString:@"/>"];
//		return str;
//		}
//	}
//
//[str appendString:@">"];
//	
//if ( _node->children )
//	{
//	for (id child in [self children])
//		[child _XMLStringWithOptions:options appendingToString:str];
//	}
//[str appendString:[NSString stringWithFormat:@"</%@>", name]];
//return str;
//}

- (NSString *)description
{
	NSAssert(_node != NULL, @"TODO");
	
	return([NSString stringWithFormat:@"<%@ %p [%p] %@ %@>", NSStringFromClass([self class]), self, self->_node, [self name], [self XMLStringWithOptions:0]]);
}

@end
