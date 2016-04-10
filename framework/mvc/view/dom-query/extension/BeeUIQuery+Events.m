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

#import "BeeUIQuery+Events.h"

#pragma mark -

@implementation BeeUIQuery(Events)

@dynamic selected;
@dynamic focusing;

@dynamic FOCUS;
@dynamic BLUR;

@dynamic SELECT;
@dynamic UNSELECT;

@dynamic ENABLE;
@dynamic DISABLE;

// Document events

@dynamic ERROR;
@dynamic RESIZE;
@dynamic SCROLL;

@dynamic LOAD;
@dynamic READY;
@dynamic UNLOAD;

@dynamic CLICK;
@dynamic DOUBLE_CLICK;

@dynamic TOUCH_DOWN;
@dynamic TOUCH_DOWN_REPEAT;
@dynamic TOUCH_UP_INSIDE;
@dynamic TOUCH_UP_OUTSIDE;
@dynamic TOUCH_UP_CANCEL;

@dynamic PAN;
@dynamic SWIPE_UP;
@dynamic SWIPE_DOWN;
@dynamic SWIPE_LEFT;
@dynamic SWIPE_RIGHT;

#pragma mark -

- (BOOL)selected
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    for ( UIView * view in self.views )
    {
        if ( view )
        {
            if ( [view respondsToSelector:@selector(selected)] )
            {
                BOOL flag =	[(UIControl *)self selected];
                if ( flag )
                    return YES;
            }
            
            if ( [view respondsToSelector:@selector(state)] )
            {
                UIControlState state =	[(UIControl *)self state];
                if ( state & UIControlStateSelected )
                    return YES;
            }
        }
    }
    
#pragma clang diagnostic pop
    
    return NO;
}

- (BOOL)focusing
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    for ( UIView * view in self.views )
    {
        if ( view && [view respondsToSelector:@selector(isFirstResponder)] )
        {
            BOOL flag =	[(UIControl *)view isFirstResponder];
            if ( flag )
                return YES;
        }
    }
    
#pragma clang diagnostic pop
    
    return NO;
}

- (BeeUIQueryObjectBlock)ENABLE
{
    BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
    {
        for ( UIView * v in self.views )
        {
            v.userInteractionEnabled = YES;
            
            if ( [v respondsToSelector:@selector(setEnabled:)] )
            {
                BOOL i = YES;
                [(UIControl *)self setEnabled:i];
            }
        }
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)DISABLE
{
    BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
    {
        for ( UIView * v in self.views )
        {
            v.userInteractionEnabled = NO;
            
            if ( [v respondsToSelector:@selector(setEnabled:)] )
            {
                BOOL i = NO;
                [(UIControl *)v setEnabled:i];
            }
        }
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)FOCUS
{
    BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
    {
        for ( UIView * v in self.views )
        {
            BOOL focus = [v becomeFirstResponder];
            if ( focus )
            {
                break;
            }
        }
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)BLUR
{
    BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
    {
        for ( UIView * v in self.views )
        {
            BOOL focus = [v resignFirstResponder];
            if ( focus )
            {
                break;
            }
        }
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)SELECT
{
    BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
    {
        for ( UIView * v in self.views )
        {
            if ( [v respondsToSelector:@selector(setSelected:)] )
            {
                BOOL i = YES;
                [(UIControl *)v setSelected:i];
            }
        }
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)UNSELECT
{
    BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
    {
        for ( UIView * v in self.views )
        {
            if ( [v respondsToSelector:@selector(setSelected:)] )
            {
                BOOL i = YES;
                [(UIControl *)v setSelected:i];
            }
        }
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockXV)ERROR
{
    BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block2)( UIView * view ) )
    {
        // TODO:
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockXV)RESIZE
{
    BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block2)( UIView * view ) )
    {
        // TODO:
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockXV)SCROLL
{
    BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block2)( UIView * view ) )
    {
        // TODO:
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockXV)LOAD
{
    BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block2)( UIView * view ) )
    {
        // TODO:
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockXV)READY
{
    BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block2)( UIView * view ) )
    {
        // TODO:
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockXV)UNLOAD
{
    BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block2)( UIView * view ) )
    {
        // TODO:
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockXV)CLICK
{
    BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block2)( UIView * view ) )
    {
        // TODO:
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockXV)DOUBLE_CLICK
{
    BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block2)( UIView * view ) )
    {
        // TODO:
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockXV)TOUCH_DOWN
{
    BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block2)( UIView * view ) )
    {
        // TODO:
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockXV)TOUCH_DOWN_REPEAT
{
    BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block2)( UIView * view ) )
    {
        // TODO:
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockXV)TOUCH_UP_INSIDE
{
    BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block2)( UIView * view ) )
    {
        // TODO:
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockXV)TOUCH_UP_OUTSIDE
{
    BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block2)( UIView * view ) )
    {
        // TODO:
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockXV)TOUCH_UP_CANCEL
{
    BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block2)( UIView * view ) )
    {
        // TODO:
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockXV)PAN
{
    BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block2)( UIView * view ) )
    {
        // TODO:
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockXV)SWIPE_UP
{
    BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block2)( UIView * view ) )
    {
        // TODO:
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockXV)SWIPE_DOWN
{
    BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block2)( UIView * view ) )
    {
        // TODO:
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockXV)SWIPE_LEFT
{
    BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block2)( UIView * view ) )
    {
        // TODO:
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockXV)SWIPE_RIGHT
{
    BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block2)( UIView * view ) )
    {
        // TODO:
        
        return self;
    };
    
    return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)