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
//  UADHTTPRequestList.m
//  BabyunCore
//
//  Created by venking on 15/7/7.
//  Copyright (c) 2015年 babyun. All rights reserved.
//

#import "UADHTTPRequestList.h"

#pragma mark -

@interface UADHTTPRequestList()
{
    BeeUIScrollView * m_scroll;
}
@end

@implementation UADHTTPRequestList

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    if (nil == m_scroll)
    {
        m_scroll = [[BeeUIScrollView alloc] init];
        m_scroll.dataSource = self;
        m_scroll.vertical = YES;
        [self.view addSubview:m_scroll];
    }
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

@end
