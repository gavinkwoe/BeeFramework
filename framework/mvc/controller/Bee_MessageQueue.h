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

#import "Bee_Precompile.h"
#import "Bee_Foundation.h"
#import "Bee_Message.h"
#import "Bee_Package.h"

#pragma mark -

typedef void (^BeeMessageQueueBlock)( BeeMessage * msg );

#pragma mark -

@interface BeeMessageQueue : NSObject

AS_SINGLETON( BeeMessageQueue )

@property (nonatomic, copy) BeeMessageQueueBlock	whenCreate;
@property (nonatomic, copy) BeeMessageQueueBlock	whenUpdate;

@property (nonatomic, retain) NSTimer *				timer;
@property (nonatomic, assign) BOOL					pause;

@property (nonatomic, readonly) NSArray *			messages;
@property (nonatomic, readonly) NSArray *			allMessages;	// same as messages
@property (nonatomic, readonly) NSArray *			pendingMessages;
@property (nonatomic, readonly) NSArray *			sendingMessages;
@property (nonatomic, readonly) NSArray *			finishedMessages;

- (NSArray *)messages:(NSString *)msgName;
- (NSArray *)messagesInSet:(NSArray *)msgNames;
- (NSArray *)messagesByResponder:(id)responder;

- (BOOL)sendMessage:(BeeMessage *)msg;
- (void)removeMessage:(BeeMessage *)msg;
- (void)cancelMessage:(NSString *)msg;
- (void)cancelMessage:(NSString *)msg byResponder:(id)responder;
- (void)cancelMessages;

- (BOOL)sending:(NSString *)msg;
- (BOOL)sending:(NSString *)msg byResponder:(id)responder;

- (void)enableResponder:(id)responder;
- (void)disableResponder:(id)responder;

@end
