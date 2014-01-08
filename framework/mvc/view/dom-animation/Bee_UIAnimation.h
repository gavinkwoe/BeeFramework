//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
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

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_Foundation.h"
#import "Bee_UICollection.h"
#import "Bee_UIMetrics.h"

#pragma mark -

typedef enum
{
	BeeUIAnimationTypeDefault,
	BeeUIAnimationTypeAlpha,
	BeeUIAnimationTypeStyling,
	BeeUIAnimationTypeFadeIn,
	BeeUIAnimationTypeFadeOut,
	BeeUIAnimationTypeBounce,
	BeeUIAnimationTypeDissolve,
	BeeUIAnimationTypeZoomIn,
	BeeUIAnimationTypeZoomOut
} BeeUIAnimationType;

#pragma mark -

@class BeeUIAnimation;
typedef void (^BeeUIAnimationBlock)( void );

#pragma mark -

@protocol BeeUIAnimationPerformer<NSObject>
- (void)animationPerform;
@end

#pragma mark -

@interface BeeUIAnimation : BeeUICollection<BeeUIAnimationPerformer>

AS_INT( STATE_IDLE )
AS_INT( STATE_PERFORMING )
AS_INT( STATE_COMPLETED )
AS_INT( STATE_CANCELLED )

@property (nonatomic, retain) NSDate *						createDate;
@property (nonatomic, retain) NSString *					name;
@property (nonatomic, assign) BeeUIAnimationType			type;
@property (nonatomic, assign) NSUInteger					state;
@property (nonatomic, assign) UIViewAnimationCurve			curve;
@property (nonatomic, readonly) UIViewAnimationCurve		curveReversed;
@property (nonatomic, assign) BOOL							reversed;
@property (nonatomic, assign) BOOL							autoCommit;
@property (nonatomic, assign) BOOL							hideWhenStop;
@property (nonatomic, assign) BOOL							showWhenStop;
@property (nonatomic, assign) BOOL							then;
@property (nonatomic, assign) CGFloat						delay;
@property (nonatomic, assign) CGFloat						duration;
@property (nonatomic, retain) NSMutableDictionary *			params;

@property (nonatomic, assign) BeeUIAnimation *				parentAnimation;
@property (nonatomic, retain) NSMutableArray *				childAnimations;

@property (nonatomic, copy) BeeUIAnimationBlock				whenBegin;
@property (nonatomic, copy) BeeUIAnimationBlock				whenComplete;
@property (nonatomic, copy) BeeUIAnimationBlock				whenCancel;
@property (nonatomic, assign) id<BeeUIAnimationPerformer>	performer;

@property (nonatomic, assign) id							target;
@property (nonatomic, assign) SEL							action;

@property (nonatomic, assign) BOOL							idle;
@property (nonatomic, assign) BOOL							performing;
@property (nonatomic, assign) BOOL							completed;
@property (nonatomic, assign) BOOL							cancelled;

+ (NSArray *)allAnimations;
+ (NSArray *)animationsForView:(UIView *)view;
+ (id)lastAnimationForView:(UIView *)view;

+ (id)animationWithType:(BeeUIAnimationType)type;
- (id)animationWithType:(BeeUIAnimationType)type;

+ (void)cancelAnimations;
+ (void)cancelAnimationsByView:(UIView *)view;

- (void)perform;

- (void)begin;
- (void)begin:(SEL)stopSelector;
- (void)commit;
- (void)cancel;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
