//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  PhotoPreviewBoard_iPhone.h
//  BTVNow
//
//  Created by QFish on 10/15/13.
//  Copyright (c) 2013 com.geek-zoo. All rights reserved.
//

#import "Bee.h"

@interface PhotoPreviewBoard_iPhone : BeeUIBoard

@property (nonatomic, retain) NSString *	imageURL;
@property (nonatomic, retain) UIImage * image;

AS_OUTLET( BeeUIZoomImageView, preview );

@end