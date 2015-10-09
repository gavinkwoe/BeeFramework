//
//  CXHTMLDocument.m
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

// This is an experiment to see if we can utilize the HTMLParser functionality
// of libXML to serve as a XHTML parser, I question if this is a good idea or not
// need to test some of the following 
// [-] How are xml namespaces handled
// [-] Can we support DTD
// [-] 

#import "CXHTMLDocument.h"

#include <libxml/parser.h>
//#include <libxml/htmlparser.h>
#include <libxml/HTMLtree.h>
#include <libxml/xpath.h>

#import "CXMLNode_PrivateExtensions.h"
#import "CXMLElement.h"

#if TOUCHXMLUSETIDY
#import "CTidy.h"
#endif /* TOUCHXMLUSETIDY */

@implementation CXHTMLDocument


// Differs from initWithXMLString by using libXML's HTML parser, which automatically decodes XHTML/HTML entities found within the document
// which eliminates the need to resanitize strings extracted from the document
// libXML treats a htmlDocPtr the same as xmlDocPtr
- (id)initWithXHTMLString:(NSString *)inString options:(NSUInteger)inOptions error:(NSError **)outError
    {
    #pragma unused (inOptions)
	if ((self = [super init]) != NULL)
        {
		NSError *theError = NULL;

		htmlDocPtr theDoc = htmlParseDoc(BAD_CAST[inString UTF8String], xmlGetCharEncodingName(XML_CHAR_ENCODING_UTF8));
		if (theDoc != NULL)
            {
            // TODO: change code to not depend on XPATH, should be a task simple enough to do
            // alternatively see if we can prevent the HTML parser from adding implied tags

            xmlXPathContextPtr xpathContext = xmlXPathNewContext (theDoc);

            xmlXPathObjectPtr xpathObject = NULL;
            if (xpathContext)
            xpathObject = xmlXPathEvalExpression (BAD_CAST("/html/body"), xpathContext);

            xmlNodePtr bodyNode = NULL;
            if (xpathObject && xpathObject->nodesetval->nodeMax)
            bodyNode = xpathObject->nodesetval->nodeTab[0];

            // TODO: Determine if this is sufficient to handle memory in libXML, is the old root removed / deleted, etc
            if (bodyNode)
            xmlDocSetRootElement(theDoc, bodyNode->children);

            _node = (xmlNodePtr)theDoc;
            NSAssert(_node->_private == NULL, @"TODO");
            _node->_private = self; // Note. NOT retained (TODO think more about _private usage)

            if (xpathObject)
            xmlXPathFreeObject (xpathObject);

            if (xpathContext)
            xmlXPathFreeContext (xpathContext);
            }
		else
            {
			xmlErrorPtr theLastErrorPtr = xmlGetLastError();
			NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                theLastErrorPtr ? [NSString stringWithUTF8String:theLastErrorPtr->message] : @"unknown", NSLocalizedDescriptionKey,
                NULL];
			
			theError = [NSError errorWithDomain:@"CXMLErrorDomain" code:1 userInfo:theUserInfo];
			
			xmlResetLastError();
            }
		
		if (outError)
            {
			*outError = theError;
            }
		
		if (theError != NULL)
            {
			[self release];
			self = NULL;
            }
        }
	return(self);
    }

- (id)initWithXHTMLData:(NSData *)inData encoding:(NSStringEncoding)encoding options:(NSUInteger)inOptions error:(NSError **)outError
    {
    #pragma unused (inOptions)
    if ((self = [super init]) != NULL)
        {
        NSError *theError = NULL;

        if (theError == NULL)
            {
            xmlDocPtr theDoc = NULL;
            if (inData && inData.length > 0)
                {
                CFStringEncoding cfenc = CFStringConvertNSStringEncodingToEncoding(encoding);
                CFStringRef cfencstr = CFStringConvertEncodingToIANACharSetName(cfenc);
                const char *enc = CFStringGetCStringPtr(cfencstr, 0);
                theDoc = htmlReadMemory([inData bytes], [inData length], NULL, enc, HTML_PARSE_NONET | HTML_PARSE_NOBLANKS | HTML_PARSE_NOWARNING);
                }

            if (theDoc != NULL)
                {
                _node = (xmlNodePtr)theDoc;
                _node->_private = self; // Note. NOT retained (TODO think more about _private usage)
                }
            else
                {
                theError = [NSError errorWithDomain:@"CXMLErrorDomain" code:-1 userInfo:NULL];
                }
            }

        if (outError)
            {
            *outError = theError;
            }

        if (theError != NULL)
            {
            [self release];
            self = NULL;
            }
        }
    return(self);
    }

@end
