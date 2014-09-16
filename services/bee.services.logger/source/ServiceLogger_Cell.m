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

#import "ServiceLogger_Cell.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@implementation ServiceLogger_Cell

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUILabel, level )
DEF_OUTLET( BeeUILabel, module )
DEF_OUTLET( BeeUILabel, time )
DEF_OUTLET( BeeUILabel, text )

- (void)dataDidChanged
{
	BeeBacklog * backlog = (BeeBacklog *)self.data;

	self.level.text = backlog.levelString;
	
	if ( BeeLogLevelInfo == backlog.level )
	{
		self.level.textColor = HEX_RGB( 0x3fb4ff );
	}
	else if ( BeeLogLevelPerf == backlog.level )
	{
		self.level.textColor = HEX_RGB( 0x3fb4ff );
	}
	else if ( BeeLogLevelWarn == backlog.level )
	{
		self.level.textColor = HEX_RGB( 0xff8522 );
	}
	else if ( BeeLogLevelError == backlog.level )
	{
		self.level.textColor = HEX_RGB( 0xe12a2a );
	}
	else
	{
		self.level.textColor = HEX_RGB( 0xccc );
	}

	self.time.text = [backlog.time asNSString];
	self.module.text = backlog.module;
	self.text.text = backlog.text;
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
