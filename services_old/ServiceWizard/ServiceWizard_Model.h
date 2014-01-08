//
//  ServiceWizard_Model.h
//  SplashService
//
//  Created by QFish on 8/14/13.
//  Copyright (c) 2013 com.bee-framework. All rights reserved.
//

#import "Bee.h"

@interface ServiceWizard_Model : NSObject

@property (nonatomic, retain) NSArray * splashes;
@property (nonatomic, retain) NSObject * background;
@property (nonatomic, retain) NSString * pageControlNoraml;
@property (nonatomic, retain) NSString * pageControlHilite;
@property (nonatomic, retain) NSString * pageControlLast;

@property (nonatomic, retain) NSString * lastVersion;
@property (nonatomic, retain) NSNumber * lastShown;

AS_SINGLETON(ServiceWizard_Model);

+ (BOOL)shown;
+ (void)setShown:(BOOL)flag;

@end
