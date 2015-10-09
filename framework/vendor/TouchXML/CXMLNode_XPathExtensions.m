//
//  CXMLNode_XPathExtensions.m
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

#import "CXMLNode_XPathExtensions.h"

#import "CXMLDocument.h"
#import "CXMLDocument_PrivateExtensions.h"
#import "CXMLNode_PrivateExtensions.h"

#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>

@implementation CXMLNode (CXMLNode_NamespaceExtensions)

- (NSArray *)nodesForXPath:(NSString *)xpath namespaceMappings:(NSDictionary *)inNamespaceMappings error:(NSError **)error;
{
#pragma unused (error)

NSAssert(_node != NULL, @"TODO");

NSArray *theResult = NULL;

xmlXPathContextPtr theXPathContext = xmlXPathNewContext(_node->doc);
theXPathContext->node = _node;

for (NSString *thePrefix in inNamespaceMappings)
	{
	xmlXPathRegisterNs(theXPathContext, (xmlChar *)[thePrefix UTF8String], (xmlChar *)[[inNamespaceMappings objectForKey:thePrefix] UTF8String]);
	}

// TODO considering putting xmlChar <-> UTF8 into a NSString category
xmlXPathObjectPtr theXPathObject = xmlXPathEvalExpression((const xmlChar *)[xpath UTF8String], theXPathContext);
if (xmlXPathNodeSetIsEmpty(theXPathObject->nodesetval))
	theResult = [NSArray array]; // TODO better to return NULL?
else
	{
	NSMutableArray *theArray = [NSMutableArray array];
	int N;
	for (N = 0; N < theXPathObject->nodesetval->nodeNr; N++)
		{
		xmlNodePtr theLibXMLNode = theXPathObject->nodesetval->nodeTab[N];
        
        CXMLNode *theNode = [CXMLNode nodeWithLibXMLNode:theLibXMLNode freeOnDealloc:YES];
        [self.rootDocument.nodePool addObject:theNode];
        
		[theArray addObject:theNode];
		}
		
	theResult = theArray;
	}
	
xmlXPathFreeObject(theXPathObject);

xmlXPathFreeContext(theXPathContext);
return(theResult);
}

- (CXMLNode *)nodeForXPath:(NSString *)xpath error:(NSError **)outError
{
return([[self nodesForXPath:xpath error:outError] lastObject]);
}

@end
