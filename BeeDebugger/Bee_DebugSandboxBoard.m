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

#import "Bee_DebugWindow.h"
#import "Bee_DebugSandboxBoard.h"
#import "Bee_DebugUtility.h"

#include <mach/mach.h>
#include <malloc/malloc.h>

#pragma mark -

@implementation BeeDebugSandboxCell

+ (CGSize)sizeInBound:(CGSize)bound forData:(NSObject *)data
{
	return CGSizeMake( bound.width, 50.0f );
}

- (void)layoutInBound:(CGSize)bound forCell:(BeeUIGridCell *)cell
{
	CGRect iconFrame;
	iconFrame.size.width = bound.height;
	iconFrame.size.height = bound.height;
	iconFrame.origin.x = 0.0f;
	iconFrame.origin.y = 0.0f;
	_iconView.frame = iconFrame;

	CGRect nameFrame;
	nameFrame.size.width = bound.width - iconFrame.size.width - 4.0f - 60.0f;
	nameFrame.size.height = bound.height;
	nameFrame.origin.x = iconFrame.size.width + 2.0f;
	nameFrame.origin.y = 0.0f;
	_nameLabel.frame = nameFrame;
	
	CGRect sizeFrame;
	sizeFrame.size.width = 50.0f;
	sizeFrame.size.height = bound.height;
	sizeFrame.origin.x = bound.width - sizeFrame.size.width - 5.0f;
	sizeFrame.origin.y = 0.0f;
	_sizeLabel.frame = sizeFrame;
}

- (void)load
{
	[super load];
	
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
	self.layer.borderColor = [UIColor colorWithWhite:0.2f alpha:1.0f].CGColor;
	self.layer.borderWidth = 1.0f;

	_iconView = [[BeeUIImageView alloc] init];
	[self addSubview:_iconView];

	_nameLabel = [[BeeUILabel alloc] init];
	_nameLabel.textAlignment = UITextAlignmentLeft;
	_nameLabel.font = [UIFont boldSystemFontOfSize:13.0f];
	_nameLabel.adjustsFontSizeToFitWidth = YES;
	_nameLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
	_nameLabel.numberOfLines = 2;
	[self addSubview:_nameLabel];
	
	_sizeLabel = [[BeeUILabel alloc] init];
	_sizeLabel.textAlignment = UITextAlignmentRight;
	_sizeLabel.font = [UIFont boldSystemFontOfSize:13.0f];
	_sizeLabel.lineBreakMode = UILineBreakModeClip;
	_sizeLabel.numberOfLines = 1;
	[self addSubview:_sizeLabel];
}

- (void)dataWillChange
{
	[super dataWillChange];
}

- (void)dataDidChanged
{
	NSString * filePath = (NSString *)self.cellData;
	if ( [filePath isEqualToString:@".."] )
	{
		_nameLabel.text = @"..";
		_iconView.image = __IMAGE( @"folder.png" );
		_sizeLabel.text = @"";
	}
	else
	{
		BOOL isDirectory = NO;	
		NSDictionary * attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL];
		if ( attributes )
		{
			if ( [[attributes fileType] isEqualToString:NSFileTypeDirectory] )
			{
				isDirectory = YES;
			}
		}
		
		_nameLabel.text = [(NSString *)filePath lastPathComponent];
		_iconView.image = __IMAGE( isDirectory ? @"folder.png" : @"file.png" );
		_sizeLabel.text = @"";
		
		if ( NO == isDirectory )
		{
			NSDictionary * attribs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL];
			if ( attribs )
			{
				NSNumber * size = [attribs objectForKey:NSFileSize];
				_sizeLabel.text = [BeeDebugUtility number2String:[size integerValue]];
			}
		}
	}
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _iconView );
	SAFE_RELEASE_SUBVIEW( _nameLabel );
	
	[super unload];
}

@end

#pragma mark -

@implementation BeeDebugToolCell

DEF_SIGNAL( REFRESH )
DEF_SIGNAL( DELETE_ALL )

+ (CGSize)sizeInBound:(CGSize)bound forData:(NSObject *)data
{
	return CGSizeMake( bound.width, 40.0f );
}

- (void)layoutInBound:(CGSize)bound forCell:(BeeUIGridCell *)cell
{
	CGRect buttonFrame;
	buttonFrame.size.width = 72.0f;
	buttonFrame.size.height = bound.height - 16.0f;
	buttonFrame.origin.x = bound.width - buttonFrame.size.width - 6.0f;
	buttonFrame.origin.y = 8.0f;
	
	_deleteAll.frame = buttonFrame;
	_refresh.frame = CGRectOffset( buttonFrame, -(buttonFrame.size.width + 8.0f), 0.0f );
	
	CGRect folderFrame;
	folderFrame.size.width = bound.width - CGRectGetMinX(_refresh.frame) - 20.0f;
	folderFrame.size.height = bound.height - 12.0f;
	folderFrame.origin.x = 10.0f;
	folderFrame.origin.y = 6.0f;
	
	_folderName.frame = folderFrame;
}

- (void)load
{
	[super load];
	
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
	self.layer.borderWidth = 1.0f;
	self.layer.borderColor = [UIColor grayColor].CGColor;

	_folderName = [[BeeUILabel alloc] init];
	_folderName.textColor = [UIColor lightGrayColor];
	_folderName.textAlignment = UITextAlignmentLeft;
	_folderName.font = [UIFont boldSystemFontOfSize:12.0f];
	_folderName.lineBreakMode = UILineBreakModeTailTruncation;
	_folderName.numberOfLines = 1;
	[self addSubview:_folderName];

	_refresh = [[BeeUIButton alloc] initWithFrame:CGRectZero];
	_refresh.backgroundColor = [UIColor darkGrayColor];
	_refresh.layer.borderColor = [UIColor lightGrayColor].CGColor;
	_refresh.layer.borderWidth = 2.0f;
	_refresh.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
	_refresh.stateNormal.title = @"Refresh";
	_refresh.stateNormal.titleColor = [UIColor whiteColor];
	[_refresh addSignal:BeeDebugToolCell.REFRESH forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_refresh];

	_deleteAll = [[BeeUIButton alloc] initWithFrame:CGRectZero];
	_deleteAll.backgroundColor = [UIColor darkGrayColor];
	_deleteAll.layer.borderColor = [UIColor lightGrayColor].CGColor;
	_deleteAll.layer.borderWidth = 2.0f;
	_deleteAll.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
	_deleteAll.stateNormal.title = @"Delete all";
	_deleteAll.stateNormal.titleColor = [UIColor whiteColor];
	[_deleteAll addSignal:BeeDebugToolCell.DELETE_ALL forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_deleteAll];
}

- (void)setPath:(NSString *)path fileCount:(NSUInteger)count
{
	_folderName.text = [NSString stringWithFormat:@"Total %u file(s)", count];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _folderName );
	SAFE_RELEASE_SUBVIEW( _refresh );
	SAFE_RELEASE_SUBVIEW( _deleteAll );
	
	[super unload];
}

@end

#pragma mark -

@implementation BeeDebugSandboxBoard

DEF_SINGLETON( BeeDebugSandboxBoard )

DEF_SIGNAL( CONFIRM_DELETE_ALL )

@synthesize folderDepth = _folderDepth;
@synthesize filePath = _filePath;

- (void)load
{
	[super load];
	
	_filePath = [NSHomeDirectory() retain];
}

- (void)unload
{
	[_filePath release];
	[_fileArray release];
	
	[super unload];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			[self setBaseInsets:UIEdgeInsetsMake(44.0f, 0, 44.0f, 0)];
			
			_toolCell = [[BeeDebugToolCell alloc] initWithFrame:CGRectZero];
			[self.view addSubview:_toolCell];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
			SAFE_RELEASE_SUBVIEW( _toolCell );
		}
		else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
		{
			CGRect toolFrame;
			toolFrame.size.width = self.viewSize.width;
			toolFrame.size.height = 44.0f;
			toolFrame.origin = CGPointZero;
			
			_toolCell.frame = toolFrame;
		}
		else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
		{
			[self refresh];
		}
		else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
		{
		}
	}
	else if ( [signal isKindOf:BeeDebugToolCell.SIGNAL] )
	{
		if ( [signal is:BeeDebugToolCell.REFRESH] )
		{
			[self refresh];
		}
		else if ( [signal is:BeeDebugToolCell.DELETE_ALL] )
		{
			BeeUIAlertView * alert = [BeeUIAlertView spawn];
			alert.message = @"Delete all files in this folder?";
			[alert addButtonTitle:@"Yes" signal:BeeDebugSandboxBoard.CONFIRM_DELETE_ALL];
			[alert addCancelTitle:@"No"];
			[alert presentForController:self];
		}
	}
	else if ( [signal isKindOf:BeeDebugSandboxBoard.SIGNAL] )
	{
		if ( [signal is:BeeDebugSandboxBoard.CONFIRM_DELETE_ALL] )
		{
			[self deleteAll];
		}
	}
}

- (void)refresh
{
	if ( nil == _fileArray )
	{
		_fileArray = [[NSMutableArray alloc] init];
	}
	
	[_fileArray removeAllObjects];
	
	if ( self.previousBoard )
	{
		[_fileArray addObject:@".."];
	}
	
	NSArray * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.filePath error:NULL];
	[_fileArray addObjectsFromArray:files];
	
	if ( self.previousBoard )
	{
		NSArray * array = [self.filePath componentsSeparatedByString:@"/"];
		if ( array.count )
		{
			[_toolCell setPath:array.lastObject fileCount:files.count];
		}
	}
	else
	{
		[_toolCell setPath:@"/" fileCount:files.count];
	}
	
	[self asyncReloadData];
}

- (void)deleteAll
{
	NSMutableArray * failedList = [NSMutableArray array];
	
	for ( NSString * file in _fileArray )
	{
		if ( [file isEqualToString:@".."] )
			continue;
		
		NSString * path = [NSString stringWithFormat:@"%@/%@", self.filePath, file];
		BOOL succeed = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
		if ( NO == succeed )
		{
			[failedList addObject:file];
		}
	}
	
	if ( failedList.count )
	{
		NSMutableString * string = [NSMutableString string];
		for ( NSString * file in failedList )
		{
			[string appendFormat:@"%@\n", file];
		}
		
		BeeUIAlertView * alert = [BeeUIAlertView spawn];
		alert.title = @"Failed to delete these:";
		alert.message = string;
		[alert addCancelTitle:@"OK"];
		[alert presentForController:self];		
	}

	[self refresh];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize bound = CGSizeMake( self.viewSize.width, 0.0f );
	return [BeeDebugSandboxCell sizeInBound:bound forData:nil].height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_fileArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BeeUITableViewCell * cell = (BeeUITableViewCell *)[self dequeueWithContentClass:[BeeDebugSandboxCell class]];
	if ( cell )
	{
		NSString * file = [_fileArray objectAtIndex:indexPath.row];
		if ( [file isEqualToString:@".."] )
		{
			cell.cellData = file;
		}
		else
		{
			cell.cellData = [NSString stringWithFormat:@"%@/%@", self.filePath, file];
		}
		return cell;
	}
	
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	
	NSString * file = [_fileArray objectAtIndex:indexPath.row];
	if ( [file isEqualToString:@".."] )
	{
		[self.stack popBoardAnimated:YES];
		return;
	}
	
	BOOL isDirectory = NO;
	NSString * path = [NSString stringWithFormat:@"%@/%@", self.filePath, file];
	NSDictionary * attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:NULL];
	if ( attributes )
	{
		if ( [[attributes fileType] isEqualToString:NSFileTypeDirectory] )
		{
			isDirectory = YES;
		}
	}

	if ( isDirectory )
	{
		BeeDebugSandboxBoard * board = [[BeeDebugSandboxBoard alloc] init];
		board.folderDepth = _folderDepth + 1;
		board.filePath = path;
		[self.stack pushBoard:board animated:YES];
		[board release];
	}
	else
	{
		if ( [path hasSuffix:@".png"] || [path hasSuffix:@".jpg"] || [path hasSuffix:@".jpeg"] || [path hasSuffix:@".gif"] )
		{
			CGRect detailFrame = self.viewBound;
			detailFrame.size.height -= 44.0f;
			
			BeeDebugImageView * detailView = [[BeeDebugImageView alloc] initWithFrame:detailFrame];
			[detailView setFilePath:path];
			[self presentModalView:detailView animated:YES];
			[detailView release];
		}
		else if ( [path hasSuffix:@".strings"] || [path hasSuffix:@".plist"] || [path hasSuffix:@".txt"] )
		{
			CGRect detailFrame = self.viewBound;
			detailFrame.size.height -= 44.0f;
			
			BeeDebugTextView * detailView = [[BeeDebugTextView alloc] initWithFrame:detailFrame];
			[detailView setFilePath:path];
			[self presentModalView:detailView animated:YES];
			[detailView release];
		}
		else
		{
			CGRect detailFrame = self.viewBound;
			detailFrame.size.height -= 44.0f;
			
			BeeDebugTextView * detailView = [[BeeDebugTextView alloc] initWithFrame:detailFrame];
			[detailView setFilePath:path];
			[self presentModalView:detailView animated:YES];
			[detailView release];
		}
	}
}

@end

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__
