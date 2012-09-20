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

#if __BEE_DEBUGGER__

#import <QuartzCore/QuartzCore.h>
#import "Bee_DebugWindow.h"
#import "Bee_DebugSandboxBoard.h"
#import "Bee_DebugUtility.h"

#include <mach/mach.h>
#include <malloc/malloc.h>

#pragma mark -

@implementation BeeDebugSandboxCell

+ (CGSize)cellSize:(NSObject *)data bound:(CGSize)bound
{
	return CGSizeMake( bound.width, 40.0f );
}

- (void)cellLayout:(BeeUIGridCell *)cell bound:(CGSize)bound
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
	_nameLabel.font = [BeeUIFont height:13.0f bold:YES];
	_nameLabel.lineBreakMode = UILineBreakModeHeadTruncation;
	_nameLabel.numberOfLines = 2;
	[self addSubview:_nameLabel];
	
	_sizeLabel = [[BeeUILabel alloc] init];
	_sizeLabel.textAlignment = UITextAlignmentRight;
	_sizeLabel.font = [BeeUIFont height:13.0f bold:YES];
	_sizeLabel.lineBreakMode = UILineBreakModeClip;
	_sizeLabel.numberOfLines = 1;
	[self addSubview:_sizeLabel];	
}

- (void)bindData:(NSObject *)data
{
	NSString * filePath = (NSString *)data;
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
		
		_nameLabel.text = [(NSString *)data lastPathComponent];
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

@implementation BeeDebugSandboxBoard

DEF_SINGLETON( BeeDebugSandboxBoard )

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
			[self setBaseInsets:UIEdgeInsetsMake(0.0f, 0, 44.0f, 0)];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
		}
		else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
		{
			if ( nil == _fileArray )
			{
				_fileArray = [[NSMutableArray alloc] init];
				[_fileArray addObject:@".."];
				[_fileArray addObjectsFromArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.filePath error:NULL]];
			}
		}
		else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
		{
		}
	}
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize bound = CGSizeMake( self.viewSize.width, 0.0f );
	return [BeeDebugSandboxCell cellSize:nil bound:bound].height;
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
			[cell bindData:file];
		}
		else
		{
			NSString * path = [NSString stringWithFormat:@"%@/%@", self.filePath, file];
			[cell bindData:path];
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

#endif	// #if __BEE_DEBUGGER__
