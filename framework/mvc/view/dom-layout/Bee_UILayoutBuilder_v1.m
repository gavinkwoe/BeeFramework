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

#import "Bee_UILayoutBuilder_v1.h"
#import "Bee_UILayout.h"
#import "Bee_UIMetrics.h"

#import "Bee_UIStyle.h"
#import "Bee_UIStyleParser.h"
#import "BeeUIStyle+Builder.h"
#import "BeeUIStyle+Property.h"

#import "UIView+BeeUIStyle.h"
#import "UIView+Tag.h"

#pragma mark -

@interface BeeUILayoutBuilder_v1()
{
	NSMutableDictionary *	_viewFrames;
}
@end

#pragma mark -

@implementation BeeUILayoutBuilder_v1

- (void)load
{
	_viewFrames = [[NSMutableDictionary alloc] init];
}

- (void)unload
{
	[_viewFrames removeAllObjects];
	[_viewFrames release];
}

#pragma mark -

- (void)orderTreeForLayout:(BeeUILayout *)thisLayout
{
	if ( nil == self.rootCanvas )
	{
		ERROR( @"canvas not found" );
		return;
	}
	
	for ( BeeUILayout * layout in thisLayout.childs )
	{
		[self orderTreeForLayout:layout];
	}

	UIView * view = [self.rootCanvas viewWithTagString:thisLayout.name];
	if ( view )
	{
		[self.rootCanvas bringSubviewToFront:view];
	}
}

- (void)buildTreeForLayout:(BeeUILayout *)thisLayout depth:(NSUInteger)depth
{
	if ( nil == self.rootCanvas )
	{
		ERROR( @"canvas not found" );
		return;
	}

	for ( BeeUILayout * layout in thisLayout.childs )
	{
		UIView * view = [layout createView];
		if ( view )
		{
			if ( nil == view.nameSpace )
			{
				view.nameSpace = [[self.rootCanvas class] description]; // self.root.name;
			}
			
			[self.rootCanvas addSubview:view];
			[self.rootCanvas bringSubviewToFront:view];
		}
	}

	for ( BeeUILayout * layout in thisLayout.childs )
	{
		[self buildTreeForLayout:layout depth:(depth + 1)];
	}
}

- (void)buildTree
{
	[self buildTreeForLayout:self.rootLayout depth:0];
	[self orderTreeForLayout:self.rootLayout];

	[self.rootCanvas setUIStyleInline:self.rootLayout.styleMerged];
	[self.rootCanvas mergeStyle];
	[self.rootCanvas applyStyle];
}

#pragma mark -

- (CGRect)getFrameForKey:(NSString *)key
{
	if ( nil == key )
	{
		return CGRectZero;
	}
	
	NSValue * value = [_viewFrames objectForKey:key];
	if ( nil == value )
	{
		return CGRectZero;
	}
	
	return [value CGRectValue];
}

- (CGRect)getFrameForLayout:(BeeUILayout *)thisLayout
{
	if ( nil == thisLayout.name )
	{
		return CGRectZero;
	}

	NSValue * value = [_viewFrames objectForKey:thisLayout.name];
	if ( nil == value )
	{
		return CGRectZero;
	}

	return [value CGRectValue];
}

- (BOOL)setFrame:(CGRect)frame forLayout:(BeeUILayout *)thisLayout
{
	if ( nil == thisLayout.name )
	{
		return NO;
	}
	
	NSValue * value = [_viewFrames objectForKey:thisLayout.name];
	if ( value )
	{
		CGRect oldFrame = [value CGRectValue];
		
		if ( CGRectEqualToRect(oldFrame, frame) )
		{
			return NO;
		}
	}

	frame = CGRectNormalize( frame );
	
	[_viewFrames setObject:[NSValue valueWithCGRect:frame] forKey:thisLayout.name];
	return YES;
}

- (BOOL)offsetFrame:(CGSize)size forLayout:(BeeUILayout *)layout
{
	CGRect viewFrame;
	viewFrame = [self getFrameForLayout:layout];
	viewFrame = CGRectOffset( viewFrame, size.width, size.height );
	
	return [self setFrame:viewFrame forLayout:layout];
}

- (void)offsetChildsFrame:(CGSize)size forLayout:(BeeUILayout *)layout
{
	if ( CGSizeEqualToSize(size, CGSizeZero) )
		return;

	for ( BeeUILayout * child in layout.childs )
	{
		[self offsetFrame:size forLayout:child];
		[self offsetChildsFrame:size forLayout:child];
	}
}

- (BeeUIStyle *)styleForLayout:(BeeUILayout *)layout
{
	UIView * view = [self.rootCanvas viewWithTagString:layout.name];
	if ( view )
	{
		BeeUIStyle * style = view.UIStyle;
		if ( style )
		{
			return style;
		}
	}

	return layout.styleMerged;
}

- (void)alignForLayout:(BeeUILayout *)thisLayout inBound:(CGRect)parentFrame margin:(UIEdgeInsets)margin padding:(UIEdgeInsets)padding
{
	if ( CGSizeEqualToSize(parentFrame.size, CGSizeZero) )
		return;
	
	BeeUIStyle * thisStyle = [self styleForLayout:thisLayout];
	if ( nil == thisStyle )
	{
		ERROR( @"'%@', style not found", thisLayout.name );
		return;
	}
	
	if ( NO == [thisStyle isAligning] && NO == [thisStyle isVAligning] )
		return;
	
	for ( BeeUILayout * child in thisLayout.childs )
	{
		BeeUIStyle * childStyle = [self styleForLayout:child];
		if ( nil == childStyle )
		{
			ERROR( @"'%@', style not found", child.name );
			continue;
		}
		
		if ( NO == [childStyle isRelativePosition] )
			continue;
		
		CGSize childOffset = CGSizeZero;
		CGRect childFrame = [self getFrameForLayout:child];
		
		if ( [thisStyle isAligning] && NO == [childStyle isFloating] )
		{
			CGRect adjustedFrame = childFrame;
			
			if ( [thisStyle isAlignCenter] )
			{
				adjustedFrame = CGRectAlignX( childFrame, parentFrame );
			}
			else if ( [thisStyle isAlignRight] )
			{
				adjustedFrame = CGRectAlignRight( childFrame, parentFrame );
			}
			else if ( [thisStyle isAlignLeft] )
			{
				adjustedFrame = CGRectAlignLeft( childFrame, parentFrame );
			}
			
			CGSize size = CGRectGetDistance( childFrame, adjustedFrame );
			
			childOffset.width += size.width;
			childOffset.height += size.height;
		}
		
		if ( [thisStyle isVAligning] && NO == [childStyle isVFloating] )
		{
			CGRect adjustedFrame = childFrame;
			
			if ( [thisStyle isVAlignCenter] )
			{
				adjustedFrame = CGRectAlignY( childFrame, parentFrame );
			}
			else if ( [thisStyle isVAlignBottom] )
			{
				adjustedFrame = CGRectAlignBottom( childFrame, parentFrame );
			}
			else if ( [thisStyle isVAlignTop] )
			{
				adjustedFrame = CGRectAlignTop( childFrame, parentFrame );
			}
			
			CGSize size = CGRectGetDistance( childFrame, adjustedFrame );
			
			childOffset.width += size.width;
			childOffset.height += size.height;
		}
		
		if ( NO == CGSizeEqualToSize( childOffset, CGSizeZero ) )
		{
			[self offsetFrame:childOffset forLayout:child];
			[self offsetChildsFrame:childOffset forLayout:child];
		}
	}
}

- (void)floatForLayout:(BeeUILayout *)thisLayout inBound:(CGRect)parentFrame margin:(UIEdgeInsets)parentMargin padding:(UIEdgeInsets)parentPadding
{
	if ( CGSizeEqualToSize(parentFrame.size, CGSizeZero) )
		return;
    
	for ( BeeUILayout * child in thisLayout.childs )
	{
		BeeUIStyle * childStyle = [self styleForLayout:child];
		if ( nil == childStyle )
		{
			ERROR( @"'%@', style not found", child.name );
			continue;
		}
        
		UIEdgeInsets	childMargin = [childStyle estimateMarginBy:parentFrame];
		UIEdgeInsets	childPadding = [childStyle estimatePaddingBy:parentFrame];
		CGSize			childOffset = CGSizeZero;
		CGRect			childFrame = [self getFrameForLayout:child];
		BOOL			childFrameChanged = NO;
        
		if ( NO == [childStyle isRelativePosition] )
		{
//			childOffset = CGSizeMake( childFrame.origin.x, childFrame.origin.y );
			
			if ( [childStyle needAdjustW] )
			{
				childFrame.size.width = [childStyle estimateWBy:parentFrame];
			}
            
			if ( [childStyle needAdjustH] )
			{
				childFrame.size.height = [childStyle estimateHBy:parentFrame];
			}
            
//			childFrame.origin.x += childPadding.left;
//			childFrame.origin.y += childPadding.top;
			childFrame.size.width -= (childPadding.left + childPadding.right);
			childFrame.size.height -= (childPadding.top + childPadding.bottom);
			
			if ( childStyle.right )
			{
				childFrame.origin.x = [childStyle estimateRightBy:parentFrame] - childFrame.size.width;
//				childFrame.origin.x += parentMargin.left;
				childFrame.origin.x -= childMargin.right;
				
				CGSize distance = CGRectGetDistance( parentFrame, childFrame );
				childOffset.width += distance.width;
			}
            
			if ( childStyle.bottom )
			{
				childFrame.origin.y = [childStyle estimateBottomBy:parentFrame] - childFrame.size.height;
//				childFrame.origin.y += parentMargin.top;
				childFrame.origin.y -= childMargin.bottom;
				
				CGSize distance = CGRectGetDistance( parentFrame, childFrame );
				childOffset.height += distance.height;
			}
            
			childFrameChanged = [self setFrame:childFrame forLayout:child];
		}
		
        if ( [childStyle isFloating] || [childStyle isVFloating] )
		{
			if ( [childStyle isRelativePosition] )
			{
				if ( [childStyle needAdjustX] )
				{
					childFrame.origin.x = [childStyle estimateLeftBy:parentFrame];
				}
				
				if ( [childStyle needAdjustY] )
				{
					childFrame.origin.y = [childStyle estimateTopBy:parentFrame];
				}
			}
			
			if ( [childStyle needAdjustW] )
			{
				childFrame.size.width = [childStyle estimateWBy:parentFrame];
			}
			
			if ( [childStyle needAdjustH] )
			{
				childFrame.size.height = [childStyle estimateHBy:parentFrame];
			}
			
			if ( [childStyle isFloating] )
			{
				if ( [childStyle isFloatCenter] )
				{
					childFrame = CGRectAlignX( childFrame, parentFrame );
				}
				else if ( [childStyle isFloatRight] )
				{
					childFrame = CGRectAlignRight( childFrame, parentFrame );
				}
				else if ( [childStyle isFloatLeft] )
				{
					childFrame = CGRectAlignLeft( childFrame, parentFrame );
				}
				
				CGSize distance = CGRectGetDistance( parentFrame, childFrame );
				childOffset.width += distance.width;
			}
			
			if ( [childStyle isVFloating] )
			{
				if ( [childStyle isVFloatCenter] )
				{
					childFrame = CGRectAlignY( childFrame, parentFrame );
				}
				else if ( [childStyle isVFloatBottom] )
				{
					childFrame = CGRectAlignBottom( childFrame, parentFrame );
				}
				else if ( [childStyle isVFloatTop] )
				{
					childFrame = CGRectAlignTop( childFrame, parentFrame );
				}
				
				CGSize distance = CGRectGetDistance( parentFrame, childFrame );
				childOffset.height += distance.height;
			}
            
			childFrame.origin.x += childPadding.left;
			childFrame.origin.y += childPadding.top;
			childFrame.size.width -= (childPadding.left + childPadding.right);
			childFrame.size.height -= (childPadding.top + childPadding.bottom);
            
			childFrameChanged = [self setFrame:childFrame forLayout:child];
		}
        
		if ( childFrameChanged )
		{
			// reset the childs'frame
			if ( NO == CGSizeEqualToSize(childOffset, CGSizeZero) )
			{
				[self offsetChildsFrame:childOffset forLayout:child];
			}
		}
	}
}

- (CGRect)estimateForLayout:(BeeUILayout *)thisLayout inBound:(CGRect)bound
{
	BeeUIStyle * thisStyle = [self styleForLayout:thisLayout];
	if ( nil == thisStyle || [thisStyle isHidden] )
	{
		if ( nil == thisStyle )
		{
			ERROR( @"'%@', style not found", thisLayout.name );
		}
		
		CGRect emptyFrame;
		emptyFrame.origin = bound.origin;
		emptyFrame.size = bound.size;
		return emptyFrame;
	}

// Step1, calculate this frame
	CGRect thisFrame;
	thisFrame.origin = [thisStyle estimateOriginBy:bound];
	thisFrame.size = [thisStyle estimateSizeBy:bound];

	UIEdgeInsets margin = [thisStyle estimateMarginBy:thisFrame];
	UIEdgeInsets padding = [thisStyle estimatePaddingBy:thisFrame];

	BOOL wWrapping = (thisFrame.size.width < 0.0f) ? YES : NO;
	BOOL hWrapping = (thisFrame.size.height < 0.0f) ? YES : NO;
	BOOL horizonal = [thisStyle isHorizontal];

	CGRect layoutBound = CGRectZero;
	layoutBound.origin = thisFrame.origin;
	layoutBound.size.width = wWrapping ? LAYOUT_MAX_WIDTH : thisFrame.size.width;
	layoutBound.size.height = hWrapping ? LAYOUT_MAX_HEIGHT : thisFrame.size.height;

	layoutBound.origin.x += padding.left;
	layoutBound.origin.y += padding.top;
	layoutBound.size.width -= (padding.left + padding.right);
	layoutBound.size.height -= (padding.top + padding.bottom);

	if ( thisLayout.childs.count )
	{
// Step2.1, calc thisFrame by childs

		CGRect lineWindow = layoutBound;
		CGSize lineMaxSize = CGSizeZero;
		CGSize layoutMaxSize = CGSizeZero;

//		BOOL lineBreaked = NO;

		for ( BeeUILayout * child in thisLayout.childs )
		{
//			UIView * childView = [self.rootCanvas viewWithTagString:child.name];
//			if ( childView && childView.hidden )
//				continue;

			BeeUIStyle * childStyle = [self styleForLayout:child];
			if ( nil == childStyle )
			{
				ERROR( @"'%@', style not found", child.name );
				continue;
			}

			CGSize relativeSize;
			relativeSize.width = [childStyle isFlexiableW] ? layoutBound.size.width : lineWindow.size.width;
			relativeSize.height = [childStyle isFlexiableH] ? layoutBound.size.height : lineWindow.size.height;
			
			CGRect relativeBound;
			relativeBound.origin = [childStyle isRelativePosition] ? lineWindow.origin : layoutBound.origin;
			relativeBound.size = relativeSize;

			CGRect childFrame = [self estimateForLayout:child inBound:relativeBound];
            
			// no need calculate child's position by lineWindow if the position equals "absolute"
			if ( [childStyle isRelativePosition] )
			{
				if ( horizonal )
				{
				// Step 2.1.1)
				// move window

					lineWindow.origin.x += childFrame.size.width;
					lineWindow.origin.x += (childFrame.origin.x - relativeBound.origin.x);
					lineWindow.size.width -= childFrame.size.width;
					lineWindow.size.width -= (childFrame.origin.x - relativeBound.origin.x);

					if ( childFrame.size.height > lineMaxSize.height )
					{
						lineMaxSize.height = childFrame.size.height;
					}

					if ( (lineWindow.origin.x - layoutBound.origin.x) > lineMaxSize.width )
					{
						lineMaxSize.width = (lineWindow.origin.x - layoutBound.origin.x);
					}

				// Step 2.1.2)
				// calculate max size

					if ( lineMaxSize.height > layoutMaxSize.height )
					{
						layoutMaxSize.height = lineMaxSize.height;
					}

					if ( lineMaxSize.width > layoutMaxSize.width )
					{
						layoutMaxSize.width = lineMaxSize.width;
					}

				// Step 2.1.3)
				// break line if reach right edge

					if ( (lineWindow.origin.y - layoutBound.origin.y) > layoutMaxSize.height )
					{
						layoutMaxSize.height = (lineWindow.origin.y - layoutBound.origin.y);
					}

					if ( lineWindow.size.width <= 0.0f )
					{
						lineWindow.origin.x = layoutBound.origin.x;
						lineWindow.size.width = layoutBound.size.width;

						lineWindow.origin.y += lineMaxSize.height;
						lineWindow.size.height -= lineMaxSize.height;

						lineMaxSize = CGSizeZero;
//						lineBreaked = YES;
					}

					if ( (lineWindow.origin.x - layoutBound.origin.x) > layoutMaxSize.width )
					{
						layoutMaxSize.width = (lineWindow.origin.x - layoutBound.origin.x);
					}

					if ( hWrapping )
					{
						if ( (childFrame.origin.y + childFrame.size.height - layoutBound.origin.y) > layoutMaxSize.height )
						{
							layoutMaxSize.height = childFrame.origin.y + childFrame.size.height - layoutBound.origin.y;
						}
					}
				}
				else
				{
				// Step 2.1.1)
				// move window

					lineWindow.origin.y += childFrame.size.height;
					lineWindow.origin.y += (childFrame.origin.y - relativeBound.origin.y);
					lineWindow.size.height -= childFrame.size.height;
					lineWindow.size.height -= (childFrame.origin.y - relativeBound.origin.y);

					if ( childFrame.size.width > lineMaxSize.width )
					{
						lineMaxSize.width = childFrame.size.width;
					}

					if ( (lineWindow.origin.y - layoutBound.origin.y) > lineMaxSize.height )
					{
						lineMaxSize.height = (lineWindow.origin.y - layoutBound.origin.y);
					}

				// Step 2.1.2)
				// calculate max size

					if ( lineMaxSize.width > layoutMaxSize.width )
					{
						layoutMaxSize.width = lineMaxSize.width;
					}

					if ( lineMaxSize.height > layoutMaxSize.height )
					{
						layoutMaxSize.height = lineMaxSize.height;
					}

				// Step 2.1.3)
				// break line if reach bottom edge

					if ( (lineWindow.origin.x - layoutBound.origin.x) > layoutMaxSize.width )
					{
						layoutMaxSize.width = (lineWindow.origin.x - layoutBound.origin.x);
					}

					if ( lineWindow.size.height <= 0.0f )
					{
						lineWindow.origin.y = layoutBound.origin.y;
						lineWindow.size.height = layoutBound.size.height;

						lineWindow.origin.x += layoutMaxSize.width;
						lineWindow.size.width -= lineMaxSize.width;

						lineMaxSize = CGSizeZero;
//						lineBreaked = YES;
					}

					if ( (lineWindow.origin.y - layoutBound.origin.y) > layoutMaxSize.height )
					{
						layoutMaxSize.height = (lineWindow.origin.y - layoutBound.origin.y);
					}

					if ( wWrapping )
					{
						if ( (childFrame.origin.x + childFrame.size.width - layoutBound.origin.x) > layoutMaxSize.width )
						{
							layoutMaxSize.width = childFrame.origin.x + childFrame.size.width - layoutBound.origin.x;
						}
					}
				}
			}
		}

		if ( thisLayout.isRoot )
		{
			thisFrame.size = layoutMaxSize;
		}
		else
		{
			if ( wWrapping )
			{
				thisFrame.size.width = layoutMaxSize.width;
			}
			if ( hWrapping )
			{
				thisFrame.size.height = layoutMaxSize.height;
			}
		}
	}
	else
	{
// Step2.2, calc thisFrame by contentSize

		CGRect relativeBound = layoutBound;
		relativeBound.size.width -= (padding.left + padding.right);
		relativeBound.size.height -= (padding.top + padding.bottom);

		UIView * thisView = nil;
		
		if ( self.rootCanvas)
		{
			thisView = [self.rootCanvas viewWithTagString:thisLayout.name];
		}
		
		if ( thisView && [[thisView class] supportForUISizeEstimating] )
		{
			if ( wWrapping && hWrapping )
			{
				thisFrame.size = [thisView estimateUISizeByBound:relativeBound.size];
			}
			else
			{
				if ( wWrapping )
				{
					thisFrame.size.width = [thisView estimateUISizeByHeight:relativeBound.size.height].width;
				}
				if ( hWrapping )
				{
					thisFrame.size.height = [thisView estimateUISizeByWidth:relativeBound.size.width].height;
				}
			}
		}
	}
    
// max/min
    
    if ( [thisStyle hasMaxW] )
    {
        CGFloat maxWidth = [thisStyle estimateMaxWBy:bound];
        
        if ( thisFrame.size.width > maxWidth )
        {
            thisFrame.size.width = maxWidth;
        }
    }
    
    if ( [thisStyle hasMinW] )
    {
        CGFloat minWidth = [thisStyle estimateMinWBy:bound];
        
        if ( thisFrame.size.width < minWidth )
        {
            thisFrame.size.width = minWidth;
        }
    }
    
    if ( [thisStyle hasMaxH] )
    {
        CGFloat maxHeight = [thisStyle estimateMaxHBy:bound];
        
        if ( thisFrame.size.height > maxHeight )
        {
            thisFrame.size.height = maxHeight;
        }
    }
    
    if ( [thisStyle hasMinH] )
    {
        CGFloat minHeight = [thisStyle estimateMinHBy:bound];
        
        if ( thisFrame.size.height < minHeight )
        {
            thisFrame.size.height = minHeight;
        }
    }

// float

	if ( CGSizeEqualToSize(thisFrame.size, CGSizeZero) )
	{
		thisFrame = bound;
	}

	CGRect innerBound = thisFrame;
	innerBound.origin.x += padding.left;
	innerBound.origin.y += padding.top;
	innerBound.size.width -= (padding.left + padding.right);
	innerBound.size.height -= (padding.top + padding.bottom);

	[self alignForLayout:thisLayout inBound:thisFrame margin:margin padding:padding];
	[self floatForLayout:thisLayout inBound:innerBound margin:margin padding:padding];

// change frame

	CGRect viewFrame = thisFrame;

	viewFrame.origin.x += margin.left;
	viewFrame.origin.y += margin.top;
//	viewFrame.size.width += margin.right;
//	viewFrame.size.height += margin.bottom;

	viewFrame.origin.x += padding.left;
	viewFrame.origin.y += padding.top;
	viewFrame.size.width -= (padding.left + padding.right);
	viewFrame.size.height -= (padding.top + padding.bottom);
//	viewFrame.size.width -= padding.right;
//	viewFrame.size.height -= padding.bottom;
		
	[self setFrame:viewFrame forLayout:thisLayout];
	
	[self offsetChildsFrame:CGSizeMake(margin.left, margin.top) forLayout:thisLayout];

	CGRect outerBound = thisFrame;
	outerBound.size.width += (margin.left + margin.right);
	outerBound.size.height += (margin.top + margin.bottom);
	
	return outerBound;
}

- (CGSize)estimateSize:(CGRect)bound
{
	return [self estimateRect:bound].size;
}

- (CGRect)estimateRect:(CGRect)bound
{
	return [self estimateForLayout:self.rootLayout inBound:bound];
}

- (void)layoutTree:(CGRect)bound
{
	if ( self.rootCanvas )
	{
//		INFO( @"%@, frame = (%.0f, %.0f, %.0f, %.0f)",
//			 [[self.rootCanvas class] description],
//			 self.rootCanvas.frame.origin.x, self.rootCanvas.frame.origin.y,
//			 self.rootCanvas.frame.size.width, self.rootCanvas.frame.size.height );

		[self estimateForLayout:self.rootLayout inBound:bound];

		for ( UIView * view in self.rootCanvas.subviews )
		{
			NSString * name = view.tagString;
			if ( name && name.length )
			{
				CGRect viewFrame;
				
				viewFrame = [self getFrameForKey:name];
				viewFrame = CGRectNormalize( viewFrame );

//				INFO( @"%@ '%@', frame = (%.0f, %.0f, %.0f, %.0f)",
//					 [[view class] description], name,
//					 viewFrame.origin.x, viewFrame.origin.y,
//					 viewFrame.size.width, viewFrame.size.height );

				view.frame = viewFrame;
			}
		}
		
//		self.rootCanvas.bounds = CGSizeMakeBound( canvasBound.size );
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)