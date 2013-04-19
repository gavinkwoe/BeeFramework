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
//  Bee_DebugSandboxBoard.h
//

#import "Bee_Precompile.h"
#import "Bee.h"

#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

#import "Bee_DebugPieView.h"
#import "Bee_DebugPlotsView.h"
#import "Bee_DebugSampleView.h"
#import "Bee_DebugDetailView.h"
#import "Bee_UITableBoard.h"

#pragma mark -

@interface BeeDebugSandboxCell : BeeUIGridCell
{
	UIImageView *	_iconView;
	BeeUILabel *	_nameLabel;
	BeeUILabel *	_sizeLabel;
}
@end

#pragma mark -

@interface BeeDebugToolCell : BeeUIGridCell
{
	BeeUILabel *	_folderName;
	BeeUIButton *	_refresh;
	BeeUIButton *	_deleteAll;
}

AS_SIGNAL( REFRESH )
AS_SIGNAL( DELETE_ALL )

- (void)setPath:(NSString *)path fileCount:(NSUInteger)count;

@end

#pragma mark -

@interface BeeDebugSandboxBoard : BeeUITableBoard
{
	NSUInteger			_folderDepth;
	NSString *			_filePath;
	NSMutableArray *	_fileArray;
	BeeDebugToolCell *	_toolCell;
}

AS_SINGLETON( BeeDebugSandboxBoard )

AS_SIGNAL( CONFIRM_DELETE_ALL )

@property (nonatomic, assign) NSUInteger	folderDepth;
@property (nonatomic, retain) NSString *	filePath;

@end

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__
