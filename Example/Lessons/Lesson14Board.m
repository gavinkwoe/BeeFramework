//
//  Lesson14Board.m
//

#import "Lesson14Board.h"

#pragma mark -

@implementation Lesson14Board

- (void)load
{
	[super load];
}

- (void)unload
{
	[super unload];
}

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		self
		.BEGIN_LAYOUT().VISIBLE( YES )
			.SPACE().H( @"10px" )
			.BEGIN_CONTAINER( nil ).ORIENTATION( @"vertical" ).AUTORESIZE_HEIGHT( YES )
				.VIEW( [BeeUIButton class], @"a" ).ALIGN( @"center" ).H( @"20px" )
				.VIEW( [BeeUILabel class], @"b" ).H( @"44px" )
				.SPACE().H( @"10px" )
				.BEGIN_CONTAINER( @"xx" ).H( @"250px" ).ORIENTATION( @"horizonal" ).VISIBLE( NO )
					.SPACE().W( @"5%" )
					.VIEW( [BeeUIImageView class], @"c" ).W( @"5%" )
                    .SPACE().W( @"5%" )
					.VIEW( [BeeUILabel class], @"d" ).W( @"10%" ).H( @"100px" ).V_ALIGN( @"bottom" )
                    .SPACE().W( @"5%" )
                    .BEGIN_CONTAINER( nil ).H( @"150px" ).W( @"70%" ).ORIENTATION( @"horizonal" )
                        .VIEW( [BeeUILabel class], @"e" ).W( @"10%" ).H( @"30px" ).V_ALIGN( @"bottom" ).ALIGN( @"right" )
                        .VIEW( [BeeUITextField class], @"f" ).W( @"20%" ).ALIGN( @"center" )
                    .END_CONTAINER()
				.END_CONTAINER()
				.SPACE().H( @"10px" )
				.VIEW( [BeeUITextField class], @"g" ).H( @"44px" )
                .SPACE().H( @"10px" )
				.VIEW( [BeeUITextField class], @"h" ).H( @"44px" )
			.END_CONTAINER()
		.END_LAYOUT()
		.REBUILD();

		
		$(@"a")
		.style
		.PROPERTY( @"{'backgroundColor':'#00F', 'titleColor':'#F00',}" )
		.PROPERTY( @"title:highlighted", @"Hello" )
		.PROPERTY( @"image", @"icon.png" );
		
		$(@"f")
		.style
		.PROPERTY( @"{'title:highlighted':'Hello', 'backgroundColor':'green', 'text':'We R the Champion!'}" )
		.PROPERTY( @"textAlignment", @"center" )
		.APPLY_FOR( $(@"g,h") );
		
		
		$(@"f").style.APPLY_FOR( $(@"g,h,i,j,k") );
		
		
		NSAssert( $(self).CHILDREN().count == self.view.subviews.count, @"" );
		
		NSAssert( $(@"*").count >= 8, @"" );
		NSAssert( $(@".BeeUILabel").count == 3, @"" );
		
		NSAssert( $(@"#a").view == $(@"a").view, @"" );
		NSAssert( $(@"#b").view == $(@"b").view, @"" );
		NSAssert( $(@"#c").view == $(@"c").view, @"" );
		NSAssert( $(@"#d").view == $(@"d").view, @"" );
		NSAssert( $(@"#e").view == $(@"e").view, @"" );
		NSAssert( $(@"#f").view == $(@"f").view, @"" );
		NSAssert( $(@"#g").view == $(@"g").view, @"" );
		NSAssert( $(@"#h").view == $(@"h").view, @"" );
		
		NSAssert( $(@"a,b").count == 2, @"" );
		NSAssert( $(@"#a,b").count == 2, @"" );
		NSAssert( $(@"a,#b").count == 2, @"" );
		NSAssert( $(@"a,b").FILTER(@"*").count == 2, @"" );
		NSAssert( $(@"a,b").FILTER(@".BeeUILabel").count == 1, @"" );
		NSAssert( $(@"a,b").FILTER(@"#a").view == $(@"a").view, @"" );
		NSAssert( $(@"a,b").FILTER(@"a").view == $(@"a").view, @"" );
		
		$(@"h").HIDE();
		NSAssert( NO == $(@"h").view.visible, @"" );
		$(@"h").SHOW();
		NSAssert( YES == $(@"h").view.visible, @"" );
		
		$(@"h").TOGGLE();
		NSAssert( NO == $(@"h").view.visible, @"" );
		$(@"h").TOGGLE();
		NSAssert( YES == $(@"h").view.visible, @"" );
		
		NSAssert( $(@"b").PREV().view == $(@"a").view, @"" );
		NSAssert( $(@"b").NEXT().view == $(@"c").view, @"" );
		
		$(@"h").PREPEND( [BeeUILabel class], @"h1" );
		$(@"h").APPEND( [BeeUILabel class], @"h2" );
		
		NSAssert( $(@"h").FIND(@"h1").NEXT().view == $(@"h").FIND(@"h2").view, @"" );
		NSAssert( $(@"h").FIND(@"h2").PREV().view == $(@"h").FIND(@"h1").view, @"" );
		NSAssert( $(@"h > h1").NEXT().view == $(@"h > h2").view, @"" );
		NSAssert( $(@"h > h2").PREV().view == $(@"h > h1").view, @"" );
		
		NSAssert( 0 == $(@"h1").count, @"" );
		NSAssert( 0 == $(@"h2").count, @"" );
		
		$(@"h > h1").REPLACE_WITH( [BeeUIButton class], @"i" );
		$(@"h > h2").REPLACE_WITH( [BeeUIButton class], @"j" );
		
		NSAssert( 0 == $(@"h > h1").count, @"" );
		NSAssert( 0 == $(@"h > h2").count, @"" );
		NSAssert( 0 != $(@"h > i").count, @"" );
		NSAssert( 0 != $(@"h > j").count, @"" );
		NSAssert( [$(@"h > i").view isKindOfClass:[BeeUIButton class]], @"" );
		NSAssert( [$(@"h > j").view isKindOfClass:[BeeUIButton class]], @"" );
		
		NSAssert( $(@"h > i").PARENT().view == $(@"h").view, @"" );
		NSAssert( $(@"h > j").PARENT().view == $(@"h").view, @"" );
		
		NSAssert( $(@"h > i").PARENTS().count == 2, @"" );
		NSAssert( $(@"h > j").PARENTS().count == 2, @"" );
		NSAssert( $(@"h").PARENTS().count == 1, @"" );
		
		NSAssert( $(@"h > i").SIBLINGS().count == 1, @"" );
		NSAssert( $(@"h > j").SIBLINGS().count == 1, @"" );
		NSAssert( $(@"h").SIBLINGS().count >= 7, @"" );
		
		$(@"h").BEFORE( [BeeUILabel class], @"h3" );
		$(@"h").AFTER( [BeeUILabel class], @"h4" );
		
		NSAssert( $(@"h3").NEXT().view == $(@"h").view, @"" );
		NSAssert( $(@"h4").PREV().view == $(@"h").view, @"" );
		
		$(@"h").EMPTY();
		NSAssert( $(@"h").CHILDREN().count == 0, @"" );
		NSAssert( 0 == $(@"h > i").count, @"" );
		NSAssert( 0 == $(@"h > j").count, @"" );
		NSAssert( $(@"h3").count > 0, @"" );
		NSAssert( $(@"h4").count > 0, @"" );
		
		$(@"h").REMOVE();
		NSAssert( 0 == $(@"h").count, @"" );
		NSAssert( 0 == $(@"h > i").count, @"" );
		NSAssert( 0 == $(@"h > j").count, @"" );
		NSAssert( $(@"h3").count > 0, @"" );
		NSAssert( $(@"h4").count > 0, @"" );
		
		$(self).EMPTY();
		NSAssert( $(self).CHILDREN().count == 0, @"" );
		NSAssert( $(self).CHILDREN().count == 0, @"" );
		
        self.allowedPortrait = YES;
        self.allowedLandscape = YES;
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		self.RELAYOUT();
	}
}

@end
