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
//  Bee_UIStackGroup.h
//

#import "Bee_UISignal.h"
#import "Bee_Singleton.h"

#pragma mark -

@class BeeUIBoard;
@class BeeUIStack;

#pragma mark -

@interface BeeUIStackGroup : BeeUIBoard
{
	NSInteger			_index;
	NSMutableArray *	_stacks;
}

AS_SINGLETON( BeeUIStackGroup );

AS_SIGNAL( INDEX_CHANGED );	// 显示顺序变了

@property (nonatomic, retain) NSMutableArray *	stacks;
@property (nonatomic, readonly) NSInteger		topIndex;
@property (nonatomic, readonly) BeeUIStack *	topStack;

+ (BeeUIStackGroup *)group;

- (BeeUIStack *)reflect:(NSString *)name;
- (void)present:(BeeUIStack *)nav;
- (void)append:(BeeUIStack *)nav;
- (void)remove:(BeeUIStack *)nav;

@end
