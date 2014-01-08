//
//  openssl_wrapper.h
//  ThirdDemoApp
//
//  Created by Xu Hanjie on 11-1-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

int rsa_sign_with_private_key_pem(char *message, int message_length
                                  , unsigned char *signature, unsigned int *signature_length
                                  , char *private_key_file_path);
int rsa_verify_with_public_key_pem(char *message, int message_length
                                   , unsigned char *signature, unsigned int signature_length
                                   , char *public_key_file_path);

NSString *base64StringFromData(NSData *signature);
NSData *dataFromBase64String(NSString *base64String);
NSString *rsaSignString(NSString *stringToSign, NSString *privateKeyFilePath, BOOL *signSuccess);
void rsaVerifyString(NSString *stringToVerify, NSString *signature, NSString *publicKeyFilePath, BOOL *verifySuccess);
NSString *formattedPEMString(NSString *originalString);
