//
//  Lession10Board.m
//

#import "Lession11Board.h"
#import "Lession11Model.h"

#pragma mark -

@implementation Lession11Cell

+ (CGSize)sizeInBound:(CGSize)bound forData:(NSObject *)data
{
	return CGSizeMake( bound.width, 60.0f );
}

- (void)layoutInBound:(CGSize)bound forCell:(BeeUIGridCell *)cell
{
	_label1.frame = CGRectMake( 10.0f, 5.0f, cell.bounds.size.width - 20.0f, 30.0f );
	_label2.frame = CGRectMake( 10.0f, 32.0f, cell.bounds.size.width - 20.0f, 20.0f );
}

- (void)load
{
	[super load];

	_label1 = [[BeeUILabel alloc] init];
	_label1.font = [UIFont boldSystemFontOfSize:18.0f];
	_label1.textColor = [UIColor blackColor];
	_label1.textAlignment = UITextAlignmentLeft;
	[self addSubview:_label1];
	
	_label2 = [[BeeUILabel alloc] init];
	_label2.font = [UIFont systemFontOfSize:14.0f];
	_label2.textColor = [UIColor grayColor];
	_label2.textAlignment = UITextAlignmentLeft;
	[self addSubview:_label2];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _label1 );
	SAFE_RELEASE_SUBVIEW( _label2 );
	
	[super unload];
}

- (void)dataWillChange
{
	[super dataWillChange];
}

- (void)dataDidChanged
{
	[super dataDidChanged];
	
	Lession11Record * record = (Lession11Record *)self.cellData;
	if ( record )
	{
		_label1.text = [NSString stringWithFormat:@"%@. %@", record.rid, record.name];
		_label2.text = record.url;
	}
	else
	{
		_label1.text = nil;
		_label2.text = nil;
	}
}

@end

#pragma mark -

@implementation Lession11Board

DEF_SINGLETON( Lession11Board );

- (void)load
{
	[super load];
	
	_records = [[NSMutableArray alloc] init];
	
	if ( [BeeDatabase openSharedDatabase:@"Lession11.db"] )
	{
		Lession11Record.DB.EMPTY();
		
		Lession11Record.DB
		.SET( @"name", @"WhatsBug" )
		.SET( @"url", @"http://www.whatsbug.com" )
		.INSERT();

		Lession11Record.DB
		.SET( @"name", @"Tencent" )
		.SET( @"url", @"http://www.qq.com" )
		.INSERT();

		Lession11Record.DB
		.SET( @"name", @"Alibaba" )
		.SET( @"url", @"http://www.taobao.com" )
		.INSERT();

		Lession11Record.DB
		.SET( @"name", @"Baidu" )
		.SET( @"url", @"http://www.baidu.com" )
		.INSERT();

		Lession11Record.DB
		.SET( @"name", @"Sina" )
		.SET( @"url", @"http://www.sina.com" )
		.INSERT();

		Lession11Record.DB
		.SET( @"name", @"Sohu" )
		.SET( @"url", @"http://www.sohu.com" )
		.INSERT();
	}
}

- (void)unload
{
	[_records removeAllObjects];
	[_records release];
	
	[super unload];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
}

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		[self setTitleString:@"Lession 11"];
		[self showNavigationBarAnimated:NO];
		[self showSearchBar:YES animated:NO];
		
		self.searchBar.placeholder = @"Input keywords, like: Tencent";
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
		if ( 0 == _records.count )
		{
			Lession11Record.DB.ORDER_ASC_BY( @"name" ).GET_RECORDS();
			if ( Lession11Record.DB.succeed )
			{
				[_records addObjectsFromArray:Lession11Record.DB.resultArray];
			}

			[self asyncReloadData];
		}
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
	}
	else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
	{
	}
}

- (void)handleUISignal_BeeUITableBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUITableBoard.SEARCH_COMMIT] )
	{
		[_records removeAllObjects];
		
		Lession11Record.DB.LIKE( @"name", self.searchBar.text ).ORDER_ASC_BY( @"name" ).GET_RECORDS();
		
		if ( Lession11Record.DB.succeed )
		{
			[_records addObjectsFromArray:Lession11Record.DB.resultArray];
		}
		
		[self asyncReloadData];
	}
	else if ( [signal is:BeeUITableBoard.SEARCH_DEACTIVE] )
	{
		[_records removeAllObjects];
		
		Lession11Record.DB.ORDER_ASC_BY( @"name" ).GET_RECORDS();
		
		if ( Lession11Record.DB.succeed )
		{
			[_records addObjectsFromArray:Lession11Record.DB.resultArray];
		}
		
		[self asyncReloadData];		
	}
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Lession11Record * record = (Lession11Record *)[_records objectAtIndex:indexPath.row];
	CGSize bound = CGSizeMake( self.view.bounds.size.width, 0.0f );
	return [Lession11Cell sizeInBound:bound forData:record].height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BeeUITableViewCell * cell = (BeeUITableViewCell *)[self dequeueWithContentClass:[Lession11Cell class]];
	if ( cell )
	{		
		cell.cellData = [_records objectAtIndex:indexPath.row];
		return cell;
	}
	
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
