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

#import "Bee.h"
#import "ServiceNetwork.h"

#pragma mark -

@interface NSNetService(NetAddress)
@property (nonatomic, readonly) BOOL		resolved;
@property (nonatomic, readonly) NSString *	resolvedHost;
@end

#pragma mark -

@interface ServiceNetworkBrowser : ServiceNetwork<NSNetServiceDelegate, NSNetServiceBrowserDelegate>

AS_SINGLETON( ServiceNetworkBrowser )

@property (nonatomic, retain) NSNetServiceBrowser *	browser;

@property (nonatomic, retain) NSMutableArray *		foundDomains;
@property (nonatomic, retain) NSMutableArray *		foundServices;
@property (nonatomic, retain) NSDictionary *		lastError;

@property (nonatomic, assign) BOOL					autoClear;
@property (nonatomic, assign) BOOL					searching;
@property (nonatomic, assign) BOOL					more;

@property (nonatomic, copy) BeeServiceBlock			START;
@property (nonatomic, copy) BeeServiceBlock			STOP;
@property (nonatomic, copy) BeeServiceBlock			CLEAR;

@property (nonatomic, copy) BeeServiceBlock			whenStart;
@property (nonatomic, copy) BeeServiceBlock			whenStop;
@property (nonatomic, copy) BeeServiceBlock			whenUpdate;
@property (nonatomic, copy) BeeServiceBlock			whenError;

@end
