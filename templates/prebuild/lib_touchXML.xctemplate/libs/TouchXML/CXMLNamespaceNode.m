//
//  CXMLNamespaceNode.m
//  TouchXML
//
//  Created by Jonathan Wight on 1/1/2000.
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

#import "CXMLNamespaceNode.h"

@implementation CXMLNamespaceNode

#pragma mark -
#pragma mark Init and dealloc

- (id) initWithPrefix:(NSString *)prefix URI:(NSString *)uri parentElement:(CXMLElement *)parent
{
	if ((self = [super init]) != NULL) 
	{
		_prefix = [prefix copy];
		_uri = [uri copy];
		_parent = parent; // Don't retain parent
	}
	
	return self;
}

- (void) dealloc
{
	[_prefix release], _prefix = nil;
	[_uri release], _uri = nil;
	_parent = nil; // Parent not retained
	
	[super dealloc];
}

#pragma mark -
#pragma mark Overidden methods

// NB: We need to override every method that relies on _node as namespaces in libXML don't have a xmlNode 

- (CXMLNodeKind)kind
{
	return CXMLNamespaceKind;
}

- (NSString *)name
{
	return _prefix ? [[_prefix copy] autorelease] : @"";
}

- (NSString *)stringValue
{
	return _uri ? [[_uri copy] autorelease] : @"";
}

- (NSUInteger)index
{
	return 0; // TODO: Write tets, Fix
}

- (NSUInteger)level
{
	return _parent ? [_parent level] + 1 : 2;
}

- (CXMLDocument *)rootDocument
{
	return [_parent rootDocument];
}

- (CXMLNode *)parent
{
	return _parent;
}

- (NSUInteger)childCount
{
	return 0;
}

- (NSArray *)children
{
	return nil;
}

- (CXMLNode *)childAtIndex:(NSUInteger)index
{
	return nil;
}

- (CXMLNode *)previousSibling
{
	return nil; // TODO: Write tets, Fix
}

- (CXMLNode *)nextSibling
{
	return nil; // TODO: Write tets, Fix
}

//- (CXMLNode *)previousNode;
//- (CXMLNode *)nextNode;
//- (NSString *)XPath;

- (NSString *)localName
{
	return [self name];
}

- (NSString *)prefix
{
	return @"";
}

- (NSString *)URI
{
	return nil;
}

//+ (NSString *)localNameForName:(NSString *)name;
//+ (NSString *)prefixForName:(NSString *)name;
//+ (CXMLNode *)predefinedNamespaceForPrefix:(NSString *)name;

- (NSString *)description
{
	if (_prefix && [_prefix length] > 0)
		return [NSString stringWithFormat:@"xmlns:%@=\"%@\"", _prefix, _uri];

	return [NSString stringWithFormat:@"xmlns=\"%@\"", _uri];
}

- (NSString *)XMLString
{
	return [self description];
}

- (NSString *)XMLStringWithOptions:(NSUInteger)options
{
	return [self description];
}

//- (NSString *)canonicalXMLStringPreservingComments:(BOOL)comments;

- (NSArray *)nodesForXPath:(NSString *)xpath error:(NSError **)error
{
	return nil;
}

@end
