//
//  CXMLDocument.m
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

#import "CXMLDocument.h"

#include <libxml/parser.h>

#import "CXMLNode_PrivateExtensions.h"
#import "CXMLElement.h"

#if TOUCHXMLUSETIDY
#import "CTidy.h"
#endif /* TOUCHXMLUSETIDY */

@implementation CXMLDocument

- (id)initWithXMLString:(NSString *)inString options:(NSUInteger)inOptions error:(NSError **)outError
    {
    #pragma unused (inOptions)

    if ((self = [super init]) != NULL)
        {
        NSError *theError = NULL;
        
        #if TOUCHXMLUSETIDY
        if (inOptions & CXMLDocumentTidyHTML)
            {
            inString = [[CTidy tidy] tidyString:inString inputFormat:TidyFormat_HTML outputFormat:TidyFormat_XHTML diagnostics:NULL error:&theError];
            }
        else if (inOptions & CXMLDocumentTidyXML)
            {
            inString = [[CTidy tidy] tidyString:inString inputFormat:TidyFormat_XML outputFormat:TidyFormat_XML diagnostics:NULL error:&theError];
            }
        #endif
        
        xmlDocPtr theDoc = xmlParseDoc((xmlChar *)[inString UTF8String]);
        if (theDoc != NULL)
            {
            _node = (xmlNodePtr)theDoc;
            NSAssert(_node->_private == NULL, @"TODO");
            _node->_private = self; // Note. NOT retained (TODO think more about _private usage)
            }
        else
            {
            xmlErrorPtr	theLastErrorPtr = xmlGetLastError();
            
                NSString* message = [NSString stringWithUTF8String:
                                     (theLastErrorPtr ? theLastErrorPtr->message : "Unknown error")];
            
            NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                         message, NSLocalizedDescriptionKey, NULL];
            theError = [NSError errorWithDomain:@"CXMLErrorDomain" code:1 userInfo:theUserInfo];
            
            xmlResetLastError();
            }

        if (outError)
            *outError = theError;

        if (theError != NULL)
            {
            [self release];
            self = NULL;
            }
        }
    return(self);
    }

- (id)initWithData:(NSData *)inData options:(NSUInteger)inOptions error:(NSError **)outError
    {
	return [self initWithData:inData encoding:NSUTF8StringEncoding options:inOptions error:outError];	 
    }

- (id)initWithData:(NSData *)inData encoding:(NSStringEncoding)encoding options:(NSUInteger)inOptions error:(NSError **)outError
    {
    #pragma unused (inOptions)
    if ((self = [super init]) != NULL)
        {
        NSError *theError = NULL;
        
        #if TOUCHXMLUSETIDY
        if (inOptions & CXMLDocumentTidyHTML)
            {
            inData = [[CTidy tidy] tidyData:inData inputFormat:TidyFormat_HTML outputFormat:TidyFormat_XHTML diagnostics:NULL error:&theError];
            }
        else if (inOptions & CXMLDocumentTidyXML)
            {
            inData = [[CTidy tidy] tidyData:inData inputFormat:TidyFormat_XML outputFormat:TidyFormat_XML diagnostics:NULL error:&theError];
            }
        #endif
        
        if (theError == NULL)
            {
            xmlDocPtr theDoc = NULL;
            if (inData && inData.length > 0)
                {
                CFStringEncoding cfenc = CFStringConvertNSStringEncodingToEncoding(encoding);
                CFStringRef cfencstr = CFStringConvertEncodingToIANACharSetName(cfenc);
                const char *enc = CFStringGetCStringPtr(cfencstr, 0);
                theDoc = xmlReadMemory([inData bytes], [inData length], NULL, enc, XML_PARSE_RECOVER | XML_PARSE_NOWARNING);
                }
            
            if (theDoc != NULL && xmlDocGetRootElement(theDoc) != NULL)
                {
                _node = (xmlNodePtr)theDoc;
                _node->_private = self; // Note. NOT retained (TODO think more about _private usage)
                }
            else
                {
                xmlErrorPtr	theLastErrorPtr = xmlGetLastError();
                NSString* message = [NSString stringWithUTF8String:
                                     (theLastErrorPtr ? theLastErrorPtr->message : "Unknown error")];
                NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                             message, NSLocalizedDescriptionKey, NULL];
                theError = [NSError errorWithDomain:@"CXMLErrorDomain" code:1 userInfo:theUserInfo];
                                     
                xmlResetLastError();
                }
            }

        if (outError)
            *outError = theError;

        if (theError != NULL)
            {
            [self release];
            self = NULL;
            }
        }
    return(self);
    }

- (id)initWithContentsOfURL:(NSURL *)inURL options:(NSUInteger)inOptions error:(NSError **)outError
    {
	return [self initWithContentsOfURL:inURL encoding:NSUTF8StringEncoding options:inOptions error:outError];
    }

- (id)initWithContentsOfURL:(NSURL *)inURL encoding:(NSStringEncoding)encoding options:(NSUInteger)inOptions error:(NSError **)outError
    {
    if (outError)
        *outError = NULL;

    NSData *theData = [NSData dataWithContentsOfURL:inURL options:NSUncachedRead error:outError];
    if (theData)
        {
        self = [self initWithData:theData encoding:encoding options:inOptions error:outError];
        }
    else
        {
        self = NULL;
        }
        
    return(self);
    }

- (void)dealloc
    {
    // Fix for #35 http://code.google.com/p/touchcode/issues/detail?id=35 -- clear up the node objects first (inside a pool so I _know_ they're cleared) and then freeing the document

    NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

    for (CXMLNode *theNode in nodePool)
        {
        [theNode invalidate];
        }

    [nodePool release];
    nodePool = NULL;

    [thePool release];
    //
    xmlUnlinkNode(_node);
    xmlFreeDoc((xmlDocPtr)_node);
    _node = NULL;
    [super dealloc];
}

//- (NSString *)characterEncoding;
//- (NSString *)version;
//- (BOOL)isStandalone;
//- (CXMLDocumentContentKind)documentContentKind;
//- (NSString *)MIMEType;
//- (CXMLDTD *)DTD;

- (CXMLElement *)rootElement
    {
    xmlNodePtr theLibXMLNode = xmlDocGetRootElement((xmlDocPtr)_node);	
    return([CXMLNode nodeWithLibXMLNode:theLibXMLNode freeOnDealloc:NO]);
    }

- (NSData *)XMLData
    {
    return([self XMLDataWithOptions:0]);
    }

- (NSData *)XMLDataWithOptions:(NSUInteger)options
    {
    #pragma unused (options)
    xmlChar *theBuffer = NULL;
    int theBufferSize = 0;
    xmlDocDumpMemory((xmlDocPtr)self->_node, &theBuffer, &theBufferSize);

    NSData *theData = [NSData dataWithBytes:theBuffer length:theBufferSize];

    xmlFree(theBuffer);

    return(theData);
    }

//- (id)objectByApplyingXSLT:(NSData *)xslt arguments:(NSDictionary *)arguments error:(NSError **)error;
//- (id)objectByApplyingXSLTString:(NSString *)xslt arguments:(NSDictionary *)arguments error:(NSError **)error;
//- (id)objectByApplyingXSLTAtURL:(NSURL *)xsltURL arguments:(NSDictionary *)argument error:(NSError **)error;
- (id)XMLStringWithOptions:(NSUInteger)options
    {
    CXMLElement *theRoot = [self rootElement];
    NSMutableString *xmlString = [NSMutableString string];
    [xmlString appendString:[theRoot XMLStringWithOptions:options]];
    return xmlString;
    }

- (NSString *)description
    {
    NSAssert(_node != NULL, @"TODO");

    NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p [%p]> ", NSStringFromClass([self class]), self, self->_node];
    xmlChar *xmlbuff;
    int buffersize;

    xmlDocDumpFormatMemory((xmlDocPtr)(self->_node), &xmlbuff, &buffersize, 1);
    NSString *dump = [[[NSString alloc] initWithBytes:xmlbuff length:buffersize encoding:NSUTF8StringEncoding] autorelease];
    xmlFree(xmlbuff);
                               
    [result appendString:dump];
    return result;
    }

@end
