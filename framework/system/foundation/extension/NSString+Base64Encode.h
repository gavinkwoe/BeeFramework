//
//  NSString+Base64Encode.h
//  Toolkit
//
//  Created by jack zhou on 12/26/13.
//  Copyright (c) 2013 JZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64Encode)

- (NSString*)base64encode;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString*) dataToJsonString:(id)object;

-(id) JSONValue;

@end
