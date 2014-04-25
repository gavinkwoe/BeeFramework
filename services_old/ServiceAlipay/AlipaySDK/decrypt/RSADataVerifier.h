//
//  RSADataVerifier.h
//  SafepayService
//
//  Created by wenbi on 11-4-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataVerifier.h"

@interface RSADataVerifier : NSObject <DataVerifier> {
	NSString *_publicKey;
}

- (id)initWithPublicKey:(NSString *)publicKey;

@end
