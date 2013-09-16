//
//  CXMLNode_CreationExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/01/08.
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

#import "CXMLNode_CreationExtensions.h"

#import "CXMLDocument.h"
#import "CXMLElement.h"
#import "CXMLNode_PrivateExtensions.h"
#import "CXMLDocument_PrivateExtensions.h"
#import "CXMLNamespaceNode.h"

@implementation CXMLNode (CXMLNode_CreationExtensions)

+ (id)document;
{
xmlDocPtr theDocumentNode = xmlNewDoc((const xmlChar *)"1.0");
NSAssert(theDocumentNode != NULL, @"xmlNewDoc failed");
CXMLDocument *theDocument = [[[CXMLDocument alloc] initWithLibXMLNode:(xmlNodePtr)theDocumentNode freeOnDealloc:NO] autorelease];
return(theDocument);
}

+ (id)documentWithRootElement:(CXMLElement *)element;
{
xmlDocPtr theDocumentNode = xmlNewDoc((const xmlChar *)"1.0");
NSAssert(theDocumentNode != NULL, @"xmlNewDoc failed");
xmlDocSetRootElement(theDocumentNode, element.node);
CXMLDocument *theDocument = [[[CXMLDocument alloc] initWithLibXMLNode:(xmlNodePtr)theDocumentNode freeOnDealloc:NO] autorelease];
[theDocument.nodePool addObject:element];
return(theDocument);
}

+ (id)elementWithName:(NSString *)name
{
xmlNodePtr theElementNode = xmlNewNode(NULL, (const xmlChar *)[name UTF8String]);
CXMLElement *theElement = [[[CXMLElement alloc] initWithLibXMLNode:(xmlNodePtr)theElementNode freeOnDealloc:NO] autorelease];
return(theElement);
}

+ (id)elementWithName:(NSString *)name URI:(NSString *)URI
{
xmlNodePtr theElementNode = xmlNewNode(NULL, (const xmlChar *)[name UTF8String]);
xmlNsPtr theNSNode = xmlNewNs(theElementNode, (const xmlChar *)[URI UTF8String], NULL);
theElementNode->ns = theNSNode;

CXMLElement *theElement = [[[CXMLElement alloc] initWithLibXMLNode:(xmlNodePtr)theElementNode freeOnDealloc:NO] autorelease];
return(theElement);
}

+ (id)elementWithName:(NSString *)name stringValue:(NSString *)string
{
xmlNodePtr theElementNode = xmlNewNode(NULL, (const xmlChar *)[name UTF8String]);
CXMLElement *theElement = [[[CXMLElement alloc] initWithLibXMLNode:(xmlNodePtr)theElementNode freeOnDealloc:NO] autorelease];
theElement.stringValue = string;
return(theElement);
}

+ (id)namespaceWithName:(NSString *)name stringValue:(NSString *)stringValue
{
	return [[[CXMLNamespaceNode alloc] initWithPrefix:name URI:stringValue parentElement:nil] autorelease];
}

+ (id)processingInstructionWithName:(NSString *)name stringValue:(NSString *)stringValue;
{
xmlNodePtr theNode = xmlNewPI((const xmlChar *)[name UTF8String], (const xmlChar *)[stringValue UTF8String]);
NSAssert(theNode != NULL, @"xmlNewPI failed");
CXMLNode *theNodeObject = [[[CXMLNode alloc] initWithLibXMLNode:theNode freeOnDealloc:NO] autorelease];
return(theNodeObject);
}

- (void)setStringValue:(NSString *)inStringValue
{
NSAssert(_node->type == XML_TEXT_NODE, @"CNode setStringValue only implemented for text nodes");    
xmlNodeSetContent(_node, (const xmlChar *)[inStringValue UTF8String]);
}

@end

