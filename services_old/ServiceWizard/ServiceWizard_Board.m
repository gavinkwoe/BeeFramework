//
//  WizardWindow_iPhone.m
//  ActionInChina
//
//  Created by QFish on 4/16/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "ServiceWizard_Board.h"
#import "ServiceWizard_Model.h"
#import "ServiceWizard.h"

#pragma mark -

@implementation ServiceWizard_ImageCell

- (void)load
{
    self.imageView = [[[BeeUIImageView alloc] init] autorelease];
    
    [self addSubview:self.imageView];
}

- (void)unload
{
    self.imageView = nil;
    
    [super unload];
}

- (void)layoutDidFinish
{
    self.imageView.frame = self.frame;
}

@end

#pragma mark -

@interface ServiceWizard_Cell()
@property ( nonatomic, retain ) BeeUIButton * mask;
@end

@implementation ServiceWizard_Cell

SUPPORT_AUTOMATIC_LAYOUT( YES );

- (void)setLastPage:(BOOL)flag
{
	if ( flag )
	{
        if ( nil == self.mask )
        {
            self.mask = [BeeUIButton spawn];
            [self.mask addTarget:self action:@selector(touched) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.mask];
        }
	}
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
}

- (void)layoutDidFinish
{
    self.mask.frame = self.bounds;
}

- (void)touched
{
    [[ServiceWizard sharedInstance] close];
}

@end

#pragma mark -

@interface ServiceWizard_Board()
@property (nonatomic, retain) NSArray * splashes;
@end

@implementation ServiceWizard_Board

DEF_SINGLETON( ServiceWizard_Board );

- (void)load
{
    [super load];
}

- (void)unload
{
    self.splashes = nil;
    self.container = nil;
    
    [super unload];
}

- (void)configSplashes
{
    if ( nil == self.splashes )
    {
        NSMutableArray * __splashes = [NSMutableArray array];
        
        for ( NSObject * splash in [ServiceWizard_Model sharedInstance].splashes )
        {
            if ( [splash isKindOfClass:[UIView class]] )
            {
                [__splashes addObject:splash];
            }
            else if ( [splash isKindOfClass:[NSString class]] )
            {
                NSString * ext = [[(NSString *)splash lastPathComponent] pathExtension];

                if ( [ext isEqualToString:@"xml"] || [ext isEqualToString:@"ui"] )
                {
                    ServiceWizard_Cell * cell = [ServiceWizard_Cell spawn];
                    cell.FROM_RESOURCE( (NSString *)splash );
                    [__splashes addObject:cell];
                }
                else if ( [ext isEqualToString:@"png"] || [ext isEqualToString:@"jpg"] )
                {
                    ServiceWizard_ImageCell * cell = [ServiceWizard_ImageCell spawn];
                    
                    UIImage * image = [UIImage imageNamed:(NSString *)splash];
                    
                    if ( image )
                    {
                        cell.imageView.image = image;
                    }
                    else
                    {
                        ERROR( @"There is no such image : %@", splash );
                    }

                    [__splashes addObject:cell];
                }
            }
        }
        
        self.splashes = [NSArray arrayWithArray:__splashes];
    }
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];
    
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        NSObject * background = [ServiceWizard_Model sharedInstance].background;

        if ( background )
        {
            if ( [background isKindOfClass:[UIView class]] )
            {
                [self.view addSubview:(UIView *)background];
            }
            else if ( [background isKindOfClass:[NSString class]] )
            {
                self.view.backgroundImage = [UIImage imageNamed:(NSString *)background];
            }
        }
        
        self.container = [[[BeeUIScrollView alloc] init] autorelease];
		self.container.pagingEnabled = YES;
		self.container.horizontal = YES;
        self.container.dataSource = self;
        [self.view addSubview:self.container];

		NSString * normal = [ServiceWizard_Model sharedInstance].pageControlNoraml;
        NSString * highlight = [ServiceWizard_Model sharedInstance].pageControlHilite;
		NSString * last = [ServiceWizard_Model sharedInstance].pageControlLast;

        self.pageControl = [[[BeeUIPageControl alloc] init] autorelease];
		self.pageControl.numberOfPages = [ServiceWizard_Model sharedInstance].splashes.count + (last ? 1 : 0);
		self.pageControl.dotSize = CGSizeMake( 11, 11 );

        if ( normal )
        {
            self.pageControl.dotImageNormal = [UIImage imageNamed:normal];
        }
        if ( highlight )
        {
            self.pageControl.dotImageHilite = [UIImage imageNamed:highlight];
        }
		if ( last )
		{
			self.pageControl.dotImageLast = [UIImage imageNamed:last];
		}

        [self.view addSubview:self.pageControl];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        self.container = nil;
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        self.container.frame = self.viewBound;

        if ( [BeeSystemInfo isPhoneRetina4] )
        {
            self.pageControl.frame = CGRectMake( 0, self.view.height - 30, self.view.width, 10 );
        }
        else
        {
            self.pageControl.frame = CGRectMake( 0, self.view.height - 20, self.view.width, 10 );
        }
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        [self configSplashes];
        [self.container asyncReloadData];
        [self.pageControl updateDotImages];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
}

ON_SIGNAL2( BeeUIScrollView, signal )
{
    CGFloat ruler = self.container.contentSize.width + 40.0f;
    CGPoint point = self.container.contentOffset;
    
    if ( [signal is:[BeeUIScrollView DID_DRAG]] )
    {
		if ( point.x + self.container.width >= ruler )
        {
			[[ServiceWizard sharedInstance] close];
        }

        INFO( @" drag: %@", NSStringFromCGPoint(point) );
        INFO( @" drag: %@", NSStringFromCGSize(self.container.contentSize) );
    }
    else if ( [signal is:[BeeUIScrollView DID_SCROLL]] )
    {
        INFO( @" scroll: %@", NSStringFromCGPoint(point) );
        INFO( @" scroll: %@", NSStringFromCGSize(self.container.contentSize) );
    }
    else if ( [signal is:[BeeUIScrollView DID_STOP]] )
    {
//        if ( point.x == ruler )
//        {
//            shown = !shown;
//            
//            if ( shown )
//            {
//                [[ServiceWizard sharedInstance] close];
//            }
//        }
        
        self.pageControl.currentPage = ( self.container.contentOffset.x ) / self.container.width;
        
        INFO( @" stop: %@", NSStringFromCGPoint(point) );
        INFO( @" stop: %@", NSStringFromCGSize(self.container.contentSize) );
    }
}

#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	return self.splashes.count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index
{
    ServiceWizard_Cell * cell = (ServiceWizard_Cell *)[self.splashes safeObjectAtIndex:index];
    
    if ( cell )
    {
        if ( index == self.splashes.count - 1 )
        {
            cell.lastPage = YES;
        }
        else
        {
            cell.lastPage = NO;
        }
    }
    
	return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return self.viewBound.size;
}

@end
