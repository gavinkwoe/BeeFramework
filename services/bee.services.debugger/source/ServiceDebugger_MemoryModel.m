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

#import "ServiceDebugger_MemoryModel.h"
#import "ServiceDebugger_Unit.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__)

#include <mach/mach.h>
#include <malloc/malloc.h>

#pragma mark -

@interface ServiceDebugger_MemoryModel()
{
	int64_t				_usedBytes;
	int64_t				_totalBytes;
	int64_t				_manualBytes;
	NSMutableArray *	_manualBlocks;
	NSMutableArray *	_chartDatas;
	NSUInteger			_lowerBound;
	NSUInteger			_upperBound;
	BOOL				_warningMode;
}
@end

#pragma mark -

@implementation ServiceDebugger_MemoryModel

@synthesize usedBytes = _usedBytes; 
@synthesize totalBytes = _totalBytes;
@dynamic usage;
@synthesize manualBytes = _manualBytes;
@synthesize manualBlocks = _manualBlocks;
@synthesize chartDatas = _chartDatas;
@synthesize lowerBound = _lowerBound;
@synthesize upperBound = _upperBound;
@synthesize warningMode = _warningMode;

DEF_SINGLETON( ServiceDebugger_MemoryModel )

DEF_NOTIFICATION( UPDATED );

- (void)load
{
//	[super load];

	_chartDatas = [[NSMutableArray alloc] init];
//	[_chartDatas addObject:__INT(0)];

	_manualBlocks = [[NSMutableArray alloc] init];

	_lowerBound = 0;
	_upperBound = 16 * M;

	[self observeTick];
}

- (void)unload
{
	[self unobserveTick];
	
	[_chartDatas removeAllObjects];
	[_chartDatas release];
	
	for ( NSNumber * block in _manualBlocks )
	{
		void * ptr = (void *)[block unsignedLongLongValue];
		NSZoneFree( NSDefaultMallocZone(), ptr );
		
		[_manualBlocks removeLastObject];
	}
	
//	[super unload];
}

- (void)allocAll
{
	NSProcessInfo *		progress = [NSProcessInfo processInfo];
	unsigned long long	total = [progress physicalMemory];
//	NSUInteger			total = NSRealMemoryAvailable();
	
	for ( ;; )
	{
		if ( _manualBytes + 50 * M >= total )
			break;

		void * block = NSZoneCalloc( NSDefaultMallocZone(), 50, M );
		if ( nil == block )
		{
			block = NSZoneMalloc( NSDefaultMallocZone(), 50 * M );
		}
		
		if ( block )
		{			
			_manualBytes += 50 * M;			
			[_manualBlocks addObject:[NSNumber numberWithUnsignedLongLong:(unsigned long long)block]];
		}
		else
		{
			break;
		}
	}
}

- (void)freeAll
{
	for ( NSNumber * block in _manualBlocks )
	{
		void * ptr = (void *)[block unsignedLongLongValue];
		NSZoneFree( NSDefaultMallocZone(), ptr );
	}
	
	[_manualBlocks removeAllObjects];
}

- (void)alloc50M
{
	void * block = NSZoneCalloc( NSDefaultMallocZone(), 50, M );
	if ( nil == block )
	{
		block = NSZoneMalloc( NSDefaultMallocZone(), 50 * M );
	}
	
	if ( block )
	{
		_manualBytes += 50 * M;
		[_manualBlocks addObject:[NSNumber numberWithUnsignedLongLong:(unsigned long long)block]];
	}
}

- (void)free50M
{
	NSNumber * block = [_manualBlocks lastObject];
	if ( block )
	{
		void * ptr = (void *)[block unsignedLongLongValue];
		NSZoneFree( NSDefaultMallocZone(), ptr );
		
		[_manualBlocks removeLastObject];
	}
}

- (void)toggleWarning
{
	_warningMode = _warningMode ? NO : YES;
}

- (float)usage
{
	return (_totalBytes > 0.0f) ? ((float)_usedBytes / (float)_totalBytes) : 0.0f;
}

ON_TICK( tick )
{
	struct mstats		stat = mstats();
	
	NSProcessInfo *		progress = [NSProcessInfo processInfo];
	unsigned long long	total = [progress physicalMemory];
	
	_usedBytes = stat.bytes_used;
	_totalBytes = total; // NSRealMemoryAvailable();
	
	if ( 0 == _usedBytes )
	{
		mach_port_t host_port;
		mach_msg_type_number_t host_size;
		vm_size_t pagesize;

		host_port = mach_host_self();
		host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
		host_page_size( host_port, &pagesize );

		vm_statistics_data_t vm_stat;
		kern_return_t ret = host_statistics( host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size );
		if ( KERN_SUCCESS != ret )
		{
			_usedBytes = 0;
			_totalBytes = 0;
		}
		else
		{
			natural_t mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
			natural_t mem_free = vm_stat.free_count * pagesize;
			natural_t mem_total = mem_used + mem_free;

			_usedBytes = mem_used;
			_totalBytes = mem_total;
		}
	}
	
	[_chartDatas addObject:[NSNumber numberWithUnsignedLongLong:_usedBytes]];
	[_chartDatas keepTail:MAX_MEMORY_HISTORY];

//	_lowerBound = _upperBound;
//	_upperBound = 1;

	for ( NSNumber * n in _chartDatas )
	{
		if ( n.intValue > _upperBound )
		{
			_upperBound = n.intValue;
			
//			if ( _upperBound < _lowerBound )
//			{
//				_lowerBound = _upperBound;
//			}
		}
		else if ( n.intValue < _lowerBound )
		{
			_lowerBound = n.intValue;
		}
	}

	if ( _warningMode )
	{
		[[UIApplication sharedApplication] performSelector:@selector(_performMemoryWarning)];		
	}
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
