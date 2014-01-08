//
//  main.m
//  scaffold
//
//  Created by god on 13-11-13.
//  Copyright (c) 2013年 geek-zoo studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Bee.h"
#import "scaffold.h"

int main(int argc, const char * argv[])
{
	@autoreleasepool
	{
		BeeScaffold * scaffold = [[[BeeScaffold alloc] init] autorelease];
		if ( scaffold )
		{
			[scaffold argc:argc argv:argv];
		}
	}
    return 0;
}
