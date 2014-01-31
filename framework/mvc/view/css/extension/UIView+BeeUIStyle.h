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

#import "Bee_UIStyle.h"
#import "Bee_UICapability.h"

#pragma mark -

@interface UIView(BeeUIStyle)

@property (nonatomic, retain) NSString *				css;
@property (nonatomic, retain) NSString *				cssSelector;
@property (nonatomic, retain) NSString *				cssResource;

@property (nonatomic, retain) NSMutableArray *			UIStyleClasses;
@property (nonatomic, retain) BeeUIStyle *				UIStyleInline;
@property (nonatomic, retain) BeeUIStyle *				UIStyleCustom;
@property (nonatomic, retain) BeeUIStyle *				UIStyleRoot;
@property (nonatomic, retain) BeeUIStyle *				UIStyle;

@property (nonatomic, retain) NSString *				UILayoutTag;		// #xxx
@property (nonatomic, retain) NSString *				UILayoutClassName;	// .xxx
@property (nonatomic, retain) NSString *				UILayoutElemName;	// <xxx>

@property (nonatomic, retain) NSString *				UIDOMPath;

@property (nonatomic, readonly)	BeeUIStyleValueBlockS	GET_ATTRIBUTE;
@property (nonatomic, readonly)	BeeUIStyleValueBlockSS	SET_ATTRIBUTE;

- (BOOL)hasStyleClass:(NSString *)className;
- (void)addStyleClass:(NSString * )className;
- (void)removeStyleClass:(NSString * )className;
- (void)toggleStyleClass:(NSString * )className;
- (void)removeAllStyleClasses;

- (void)addStyleProperties:(NSDictionary *)dict;
- (void)removeStyleProperties:(NSDictionary *)dict;

- (void)mergeStyle;
- (void)applyStyle;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
