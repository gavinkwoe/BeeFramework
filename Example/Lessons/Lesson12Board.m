//
//  Lesson12Board.m
//

#import "Lesson12Board.h"

#pragma mark - FirstView

@implementation FirstView

- (void)layoutInBound:(CGSize)bound forCell:(BeeUIGridCell *)cell
{
    [super layoutInBound:bound forCell:cell];

    self.RELAYOUT();
}

- (void)load
{
    self
    .BEGIN_LAYOUT()
        .BEGIN_CONTAINER( nil ).ORIENTATION( @"vertical" ).H( @"100%" )/*可以省略, 默认100%*//*.AUTORESIZE_HEIGHT( YES )无限高度*/
            .VIEW( [BeeUIButton class], @"Welcome" ).H( @"60%" )
            .SPACE().H( @"2.5%" )
            .VIEW( [BeeUIButton class], @"Facebook" ).H( @"10%" ).W( @"90%" ).ALIGN( @"center" )
            .SPACE().H( @"2.5%" )
            .BEGIN_CONTAINER( nil ).H( @"10%" ).W( @"95%" ).ORIENTATION( @"horizonal" )
                .SPACE().W( @"5%" )
                .VIEW( [BeeUIButton class], @"Twitter" ).W( @"45%" )
                .VIEW( [BeeUIButton class], @"Google" ).W( @"45%" ).ALIGN( @"right" )
            .END_CONTAINER()
            .SPACE().H( @"2.5%" )
            .BEGIN_CONTAINER( nil ).H( @"10%" ).W( @"95%" ).ORIENTATION( @"horizonal" )
                .SPACE().W( @"5%" )
                .VIEW( [BeeUIButton class], @"Sign-up" ).W( @"45%" )
                .VIEW( [BeeUIButton class], @"Sign-in" ).W( @"45%" ).ALIGN( @"right" )
            .END_CONTAINER()
        .END_CONTAINER()
    .END_LAYOUT()
    .REBUILD();

	$(@"*").EACH( function( UIView * view ) {
		view.hintString = view.tagString;
	});
}

@end

#pragma mark - SecondView

@implementation SecondView

- (void)layoutInBound:(CGSize)bound forCell:(BeeUIGridCell *)cell
{
    [super layoutInBound:bound forCell:cell];
	
    self.RELAYOUT();
}

- (void)load
{
	NSString * width = @"15px";

	self
	.BEGIN_LAYOUT()
	
		.SPACE().H(@"5px")
		.BEGIN_CONTAINER(nil).H( @"400px" ).ORIENTATION( @"horizonal" )
	
			.SPACE().W(@"5px")
			.BEGIN_CONTAINER(nil).ORIENTATION( @"vertical" ).W(@"100px")
				.VIEW( [BeeUIButton class], @"a" ).H( width ).W(@"80px")
				.BEGIN_CONTAINER(nil).ORIENTATION( @"horizonal" ).H( @"100px" )
					.VIEW( [BeeUIButton class], @"b" ).W( width )
					.SPACE().W(@"50px")
					.VIEW( [BeeUIButton class], @"c" ).W( width )
				.END_CONTAINER()
				.VIEW( [BeeUIButton class], @"d" ).H( width ).W(@"100px")
				.BEGIN_CONTAINER(nil).ORIENTATION( @"horizonal" ).H( @"100px" )
					.VIEW( [BeeUIButton class], @"e" ).W( width )
					.SPACE().W(@"70px")
					.VIEW( [BeeUIButton class], @"f" ).W( width )
				.END_CONTAINER()
				.VIEW( [BeeUIButton class], @"g" ).H( width ).W(@"100px")
			.END_CONTAINER()
	
			.SPACE().W(@"5px")
			.BEGIN_CONTAINER(nil).ORIENTATION( @"vertical" ).W(@"100px")
				.VIEW( [BeeUIButton class], @"h" ).H( width ).W(@"100px")
				.BEGIN_CONTAINER(nil).ORIENTATION( @"horizonal" ).H( @"100px" )
					.VIEW( [BeeUIButton class], @"i" ).W( width )
					.SPACE().W(@"80px")
				.END_CONTAINER()
				.VIEW( [BeeUIButton class], @"k" ).H( width ).W(@"100px")
				.BEGIN_CONTAINER(nil).ORIENTATION( @"horizonal" ).H( @"100px" )
					.VIEW( [BeeUIButton class], @"l" ).W( width )
					.SPACE().W(@"80px")
				.END_CONTAINER()
				.VIEW( [BeeUIButton class], @"n" ).H( width ).W(@"100px")
			.END_CONTAINER()

			.SPACE().W(@"5px")
			.BEGIN_CONTAINER(nil).ORIENTATION( @"vertical" ).W(@"100px")
				.VIEW( [BeeUIButton class], @"o" ).H( width ).W(@"100px")
				.BEGIN_CONTAINER(nil).ORIENTATION( @"horizonal" ).H( @"100px" )
					.VIEW( [BeeUIButton class], @"p" ).W( width )
					.SPACE().W(@"80px")
				.END_CONTAINER()
				.VIEW( [BeeUIButton class], @"r" ).H( width ).W(@"100px")
				.BEGIN_CONTAINER(nil).ORIENTATION( @"horizonal" ).H( @"100px" )
					.VIEW( [BeeUIButton class], @"s" ).W( width )
					.SPACE().W(@"80px")
				.END_CONTAINER()
				.VIEW( [BeeUIButton class], @"u" ).H( width ).W(@"100px")
			.END_CONTAINER()
	
		.END_CONTAINER()
	
	.END_LAYOUT()
	.REBUILD();

	$(@"*").EACH( function( UIView * view ) {
		view.hintString = view.tagString;
	});
}

@end

@implementation Lesson12Board

#pragma mark [B] UISignal

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
    [super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		self
		.BEGIN_LAYOUT()
			.VIEW( [FirstView class], @"1" ).ALWAYS( YES ).POSITION(@"absolute").FULLFILL()
			.VIEW( [SecondView class], @"2" ).ALWAYS( YES ).POSITION(@"absolute").FULLFILL()
		.END_LAYOUT()
		.REBUILD();

        BeeUISegmentedControl * seg = [BeeUISegmentedControl spawn];
		[seg addTitle:@"Page 1" tag:0];
		[seg addTitle:@"Page 2" tag:1];
		[seg setSelectedSegmentIndex:0];
		[self setTitleView:seg];
		[self showNavigationBarAnimated:NO];

        self.allowedPortrait = YES;
        self.allowedLandscape = YES;
		
		$(@"1").SHOW();
		$(@"2").HIDE();
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        // 如果通过上面自动layout的方式添加view,这里需要self需要调用RELAYOUT().
        self.RELAYOUT();
	}
}

- (void)handleUISignal_BeeUISegmentedControl:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUISegmentedControl.HIGHLIGHT_CHANGED] )
	{
		BeeUISegmentedControl * titleView = (BeeUISegmentedControl *)self.titleView;
        if ( titleView.selectedTag == 0 )
        {
			$(@"1").SHOW();
			$(@"2").HIDE();
        }
        else
        {
			$(@"1").HIDE();
			$(@"2").SHOW();
        }
		
		self.RELAYOUT();
	}
}

- (void)handleUISignal_welcome:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		[self presentMessageTips:@"Welcome"];
	}
}

- (void)handleUISignal_facebook:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		[self presentMessageTips:@"Facebook"];
	}
}

- (void)handleUISignal_twitter:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		[self presentMessageTips:@"Twitter"];
	}
}

- (void)handleUISignal_google:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		[self presentMessageTips:@"Google"];
	}
}

- (void)handleUISignal_sign_up:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		[self presentMessageTips:@"Sign up"];
	}
}

- (void)handleUISignal_sign_in:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		[self presentMessageTips:@"Sign in"];
	}
}

@end
