//
//  CXMLNode_PrivateExtensions.m
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

#import "CXMLNode_PrivateExtensions.h"

#import "CXMLElement.h"
#import "CXMLDocument_PrivateExtensions.h"

@implementation CXMLNode (CXMLNode_PrivateExtensions)

- (id)initWithLibXMLNode:(xmlNodePtr)inLibXMLNode freeOnDealloc:(BOOL)infreeOnDealloc
{
if (inLibXMLNode == NULL)
	return nil;

if ((self = [super init]) != NULL)
	{
	_node = inLibXMLNode;
	_freeNodeOnRelease = infreeOnDealloc;
	}
return(self);
}

+ (id)nodeWithLibXMLNode:(xmlNodePtr)inLibXMLNode freeOnDealloc:(BOOL)infreeOnDealloc
{
// TODO more checking.
if (inLibXMLNode == NULL)
	return nil;

if (inLibXMLNode->_private)
	return(inLibXMLNode->_private);

Class theClass = [CXMLNode class];
switch (inLibXMLNode->type)
	{
	case XML_ELEMENT_NODE:
		theClass = [CXMLElement class];
		break;
	case XML_DOCUMENT_NODE:
		theClass = [CXMLDocument class];
		break;
	case XML_ATTRIBUTE_NODE:
	case XML_TEXT_NODE:
	case XML_CDATA_SECTION_NODE:
	case XML_COMMENT_NODE:
		break;
	default:
		NSAssert1(NO, @"TODO Unhandled type (%d).", inLibXMLNode->type);
		return(NULL);
	}

CXMLNode *theNode = [[[theClass alloc] initWithLibXMLNode:inLibXMLNode freeOnDealloc:infreeOnDealloc] autorelease];


if (inLibXMLNode->doc != NULL)
	{
	CXMLDocument *theXMLDocument = inLibXMLNode->doc->_private;
	if (theXMLDocument != NULL)
		{
		NSAssert([theXMLDocument isKindOfClass:[CXMLDocument class]] == YES, @"TODO");

		[[theXMLDocument nodePool] addObject:theNode];

		theNode->_node->_private = theNode;
		}
	}
return(theNode);
}

- (xmlNodePtr)node
{
return(_node);
}

- (void)invalidate;
    {
    if (_node)
        {
        if (_node->_private == self)
            _node->_private = NULL;

        if (_freeNodeOnRelease)
            {
            xmlUnlinkNode(_node);
            xmlFreeNode(_node);
            }

        _node = NULL;
        }
    }

@end
