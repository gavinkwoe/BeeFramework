//
//  CXMLNode.h
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

#import <Foundation/Foundation.h>
#import <libxml/tree.h>

typedef enum {
	CXMLInvalidKind = 0,
	CXMLElementKind = XML_ELEMENT_NODE,
	CXMLAttributeKind = XML_ATTRIBUTE_NODE,
	CXMLTextKind = XML_TEXT_NODE,
	CXMLProcessingInstructionKind = XML_PI_NODE,
	CXMLCommentKind = XML_COMMENT_NODE,
	CXMLNotationDeclarationKind = XML_NOTATION_NODE,
	CXMLDTDKind = XML_DTD_NODE,
	CXMLElementDeclarationKind =  XML_ELEMENT_DECL,
	CXMLAttributeDeclarationKind =  XML_ATTRIBUTE_DECL,
	CXMLEntityDeclarationKind = XML_ENTITY_DECL,
	CXMLNamespaceKind = XML_NAMESPACE_DECL,
} CXMLNodeKind;

@class CXMLDocument;

// NSXMLNode
@interface CXMLNode : NSObject <NSCopying> {
	xmlNodePtr _node;
	BOOL _freeNodeOnRelease;
}

- (CXMLNodeKind)kind;
- (NSString *)name;
- (NSString *)stringValue;
- (NSUInteger)index;
- (NSUInteger)level;
- (CXMLDocument *)rootDocument;
- (CXMLNode *)parent;
- (NSUInteger)childCount;
- (NSArray *)children;
- (CXMLNode *)childAtIndex:(NSUInteger)index;
- (CXMLNode *)previousSibling;
- (CXMLNode *)nextSibling;
//- (CXMLNode *)previousNode;
//- (CXMLNode *)nextNode;
//- (NSString *)XPath;
- (NSString *)localName;
- (NSString *)prefix;
- (NSString *)URI;
+ (NSString *)localNameForName:(NSString *)name;
+ (NSString *)prefixForName:(NSString *)name;
+ (CXMLNode *)predefinedNamespaceForPrefix:(NSString *)name;
- (NSString *)description;
- (NSString *)XMLString;
- (NSString *)XMLStringWithOptions:(NSUInteger)options;
//- (NSString *)canonicalXMLStringPreservingComments:(BOOL)comments;
- (NSArray *)nodesForXPath:(NSString *)xpath error:(NSError **)error;
@end
