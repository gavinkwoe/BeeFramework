//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//
//
//  Bee_UIPageControl.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UIPageControl.h"
#import "Bee_UISignal.h"
#import "Bee_SystemInfo.h"
#import "UIView+BeeExtension.h"

#pragma mark -

@interface BeeUIPageControl(Private)
- (void)initSelf;
- (void)updateDotImages;
@end

@implementation BeeUIPageControl
@synthesize dotImageNormals = _dotImageNormals;
@synthesize dotImageNormal = _dotImageNormal;
@synthesize dotImageHilites = _dotImageHilites;
@synthesize dotImageHilite = _dotImageHilite;
@synthesize dotImageSizes = _dotImageSizes;
@synthesize dotSize = _dotSize;

+ (BeeUIPageControl *)spawn
{
	return [[[BeeUIPageControl alloc] init] autorelease];
}

+ (BeeUIPageControl *)spawn:(NSString *)tagString
{
	BeeUIPageControl * view = [[[BeeUIPageControl alloc] init] autorelease];
	view.tagString = tagString;
	return view;
}

- (id)init
{
	self = [super initWithFrame:CGRectZero];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (void)initSelf
{
	self.numberOfPages = 0;
	self.currentPage = 0;
	self.hidesForSinglePage = YES;
	self.defersCurrentPageDisplay = NO;
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
	return _dotSize;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[super endTrackingWithTouch:touch withEvent:event];
	[self updateDotImages];
}

- (void)updateDotImages
{
    NSUInteger index = 0;
	for ( UIView * subView in self.subviews )
	{
		if ( [subView isKindOfClass:[UIImageView class]] )
		{
			UIImageView * imageView = (UIImageView *)subView;
			if ( self.currentPage == index )
			{
                if (self.dotImageHilites && [self.dotImageHilites count]> self.currentPage && [self.dotImageHilites objectAtIndex:self.currentPage] != [NSNull null]) {
                    imageView.image = [self.dotImageHilites objectAtIndex:self.currentPage];
                    if (self.dotImageSizes && [self.dotImageSizes count]>self.currentPage) {
                        NSNumber *number = [self.dotImageSizes objectAtIndex:self.currentPage];
                        CGSize size = [number CGSizeValue];
                        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, size.width, size.height);
                    }
                }else if ( self.dotImageHilite )
				{
					imageView.image = self.dotImageHilite;					
				}
			}
			else
			{
                
				if (self.dotImageNormals && [self.dotImageNormals count]> index && [self.dotImageNormals objectAtIndex:self.currentPage] != [NSNull null]) {
                  
                    imageView.image = [self.dotImageNormals objectAtIndex:index];
                    if (self.dotImageSizes && [self.dotImageSizes count]>index) {
                        NSNumber *number = [self.dotImageSizes objectAtIndex:index];
                        CGSize size = [number CGSizeValue];
                        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, size.width, size.height);
                    }
                    
                    
                }else if ( self.dotImageNormal )
				{
					imageView.image = self.dotImageNormal;					
				}
			}
            
            index += 1;
		}
	}
}

-(void) setDotImageNormals:(NSArray *)dotImageNormals{
    [_dotImageNormals release];
    _dotImageNormals = [dotImageNormals retain];
    [self updateDotImages];
}

-(void) setDotImageHilites:(NSArray *)dotImageHilites{
    [_dotImageHilites release];
    _dotImageHilites = [dotImageHilites retain];
    [self updateDotImages];
}

-(void) setDotImageSizes:(NSArray *)dotImageSizes{
    [_dotImageSizes release];
    _dotImageSizes = [dotImageSizes retain];
    [self updateDotImages];
}


-(void) setCurrentPage:(NSInteger)page{
    [super setCurrentPage:page];
    [self updateDotImages];
}

- (void)dealloc
{
	[_dotImageNormal release];
	[_dotImageHilite release];
    [_dotImageNormals release];
    [_dotImageHilites release];
    [_dotImageSizes release];
    
	[super dealloc];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
