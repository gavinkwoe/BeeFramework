//
//  WizardWindow_iPhone.h
//  ActionInChina
//
//  Created by QFish on 4/16/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface ServiceWizard_Cell : BeeUICell
@property (nonatomic, assign) BOOL lastPage;
@end

@interface ServiceWizard_ImageCell : ServiceWizard_Cell
@property (nonatomic, retain) BeeUIImageView * imageView;
@end

#pragma mark -

@interface ServiceWizard_Board : BeeUIBoard

@property (nonatomic, retain) BeeUIScrollView * container;
@property (nonatomic, retain) BeeUIPageControl * pageControl;

AS_SINGLETON( ServiceWizard_Board );

@end
