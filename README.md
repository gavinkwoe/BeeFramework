#{bee} framework

a rapid dev framework for iOS.    
by geek, for geek.    

#####It's possible to develop an iOS app in less than 3 days.

##[Download SDK](http://www.bee-framework.com/download/bee_SDK_0_3_0.zip)

Lastest version: **http://www.bee-framework.com/download/bee_SDK_0_3_0.zip**

![SDK](http://blog.whatsbug.com/wp-content/uploads/2013/04/bee_sdk_1.png)
![SDK](http://blog.whatsbug.com/wp-content/uploads/2013/04/bee_sdk_2.png)
![SDK](http://blog.whatsbug.com/wp-content/uploads/2013/04/bee_SDK_3.png)

##Join us

QQ Group:      **79054681**    
website:       **http://www.bee-framework.com**    
email:         **gavinkwoe@gmail.com**    
google groups: **https://groups.google.com/d/forum/beeframework?hl=zh-CN**

##v0.3.0 changes

1. Fully support for MacOS
2. Fully support for UI template:    

	view:

	![Layout](http://blog.whatsbug.com/wp-content/uploads/2013/04/bee_view.png)

	code:

		<?xml version="1.0" encoding="UTF-8"?>
		<ui id="test">

			<layout>
				<container orientation="vertical" autoresize_height="false">
					<view class="BeeUIButton" id="welcome" h="60%" style="welcome"/>
					<space h="2.5%"/>
					<container orientation="horizonal" h="10%">
						<space w="4%"/>
						<view class="BeeUIButton" id="facebook" w="92%" style="facebook"/>
						<space w="4%"/>
					</container>
          		  	<space h="2.5%"/>
					<container orientation="horizonal" h="10%">
						<space w="4%"/>
						<view class="BeeUIButton" id="twitter" w="44%" style="twitter"/>
						<space w="4%"/>
						<view class="BeeUIButton" id="google" w="44%" style="google"/>
						<space w="4%"/>
					</container>
					<space h="2.5%"/>
					<container orientation="horizonal" h="10%">
						<space w="4%"/>
						<view class="BeeUIButton" id="sign-up" w="44%" style="sign-up"/>
						<space w="4%"/>
						<view class="BeeUIButton" id="sign-in" w="44%" style="sign-in"/>
						<space w="4%"/>
					</container>
				</container>
			</layout>

			<style id="welcome">
				font:	'24, bold';
				color:	#369;
				text:	"We are the champion!";
			</style>
			<style id="facebook">
				{
					"font" :	"18, bold",
					"color" :	"#666",
					"text" :	"Facebook"
				}
			</style>
			<style id="twitter">
				{
					"font" :	"18, bold",
					"color" :	"#666",
					"text" :	"Twitter"
				}
			</style>
			<style id="google">
				{
					"font" :	"18, bold",
					"color" :	"#666",
					"text" :	"Google"
				}
			</style>
			<style id="sign-up">
				font:	'18, bold';
				color:	#666;
				text:	"Sign up";
			</style>
			<style id="sign-in">
				font:	'18, bold';
				color:	#666;
				text:	"Sign in";
			</style>

		</ui>

3. Fully support for UI query syntax, like jQUERY:

	(in any view/viewController, you can coding like below:)    
	(see Lesson 14)    

		$(@"*").HIDE()...;

		$(@"#a").HIDE()....;

		$(@"h > i").HIDE()....;

		$(@".BeeUILabel").HIDE()....;		

		$(@"h").BEFORE( [BeeUILabel class], @"h3" );
		$(@"h").AFTER( [BeeUILabel class], @"h4" );

		NSAssert( $(@"h3").NEXT().view == $(@"h").view, @"" );
		NSAssert( $(@"h4").PREV().view == $(@"h").view, @"" );
		
		$(@"h").EMPTY();
		NSAssert( $(@"h").CHILDREN().count == 0, @"" );
		NSAssert( 0 == $(@"h > i").count, @"" );
		NSAssert( 0 == $(@"h > j").count, @"" );
		NSAssert( $(@"h3").count > 0, @"" );
		NSAssert( $(@"h4").count > 0, @"" );
		
		$(@"h").REMOVE();
		NSAssert( 0 == $(@"h").count, @"" );
		NSAssert( 0 == $(@"h > i").count, @"" );
		NSAssert( 0 == $(@"h > j").count, @"" );
		NSAssert( $(@"h3").count > 0, @"" );
		NSAssert( $(@"h4").count > 0, @"" );
		
		$(self).EMPTY();
		NSAssert( $(self).CHILDREN().count == 0, @"" );
		NSAssert( $(self).CHILDREN().count == 0, @"" );
	
4. Fully support for template/viewController signal bridging by ID:

	template.xml

		<view id="twitter"/>

	template.mm

		- (void)handleUISignal_twitter:(BeeUISignal *)signal
		{
			[super handleUISignal:signal];
	
			if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
			{
				// TODO:
			}
		}

5. Fix some bugs


##v0.2.3 changes

1. Refactoring the directory structure, Core and MVC completely separated, and the source files and the extensions completely separated
2. Refactoring the code structure of BeeDatabase and BeeActiveRecord, more clearly
3. Support the ActiveRecord inherition and nesting, support HAS/BELONG_TO operations, such as:

		@interface Location : BeeActiveRecord    
		...    
		@end    

		@interface User : BeeActiveRecord    
		...    
		@end    
	
		@interface User2 : User    
		@property (nonatomic, retain) Location * location;    
		...    
		@end    

		Magzine * magzine = ...;    
		Article.DB.BELONG_TO( magzine ).GET_RECORDS();    
		Article.DB.BELONG_TO( magzine ).SAVE_ARRAY( result );    

		Article * article = ...;    
		Magzine.DB.HAS( article ).GET_RECORDS();    

	(follow-up version will add more RUBY-like advanced features)    

4. Support dot(.) opertions for BeeRequest & BeeMessage, such as：

		self    
		.HTTP_GET( @"http://www.qq.com" )    
		.HEADER( @"header1", @"xxx" )    
		.HEADER( @"header2", @"xxx" )    
		.HEADER( @"header3", @"xxx" )    
		.PARAM( @"key1", @"xxx" )    
		.PARAM( @"key2", @"xxx" )    
		.PARAM( @"key3", @"xxx" )    
		.FILE( @"photo1.png", [NSData data] )    
		.FILE( @"photo2.png", [NSData data] )    
		.FILE( @"photo3.png", [NSData data] );    

		self
		.MSG( ArticleController.GET_ARTICLES )    
		.TIMEOUT( 10.0f )    
		.INPUT( @"magzine", _magzine );    

5. Fix some bugs (Thanks, I love U all!)

##v0.2 changes

1. BeeDatabase:

	self.DB
	    .TABLE( @"tableName" )
	    .FIELD( @"id", @"INTEGER", 12 ).PRIMARY_KEY().AUTO_INREMENT()
	    .FIELD( @"field1", @"TEXT", 20 )
	    .FIELD( @"field2", @"TEXT", 64 )
	    .CREATE_IF_NOT_EXISTS();
	NSAssert( self.DB.succeed, nil );
	
	self.DB
	    .FROM( @"tableName" )
	    .WHERE( @"key", @"value" )
	    .GET();
	NSAssert( self.DB.resultArray.count > 0, nil );

2. Fantastic BeeActiveRecord:

	// UserInfo.h
	
	@interface UserInfo : BeeActiveRecord
	{
		NSNumber *	_uid;
		NSString *	_name;
	}
	@property (nonatomic, retain) NSNumber *	uid;
	@property (nonatomic, retain) NSString *	name;
	@end

	// UserInfo.m
	
	@implementation UserInfo
	@synthesize uid = _uid;
	@synthesize name = _name;
	+ (void)mapRelation
	{
		[self mapPropertyAsKey:@"uid"];		
		[self mapProperty:@"name"];
	}
	@end

	// Test.m

	{
		// style1
		UserInfo.DB
			.SET( @"name", @"gavin" )
			.INSERT();

		// style2
		UserInfo * user = [[UserInfo alloc] init];
		user.name = @"amanda";
		user.INSERT();		
	}
	
3. New overload graph:

	![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/12/bee_5.png)

4. Fix some bugs
5. Move precompile options to 'Bee_Precompile.h'     

##v0.1 changes

1. Add more lessons

	![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/11/bee_1.png)

2. Add heatmap

	![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/11/bee_3.png)

3. Add debugger

	![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/11/bee_4.png)


##Companies are using {bee}

A. China Mobile, http://www.chinamobileltd.com/en/global/home.php    
B. China Unicom, http://www.chinaunicom.com.cn/    
C. China Telecom, http://www.chinatelecom.com.cn/    
D. Tencent, http://www.qq.com/    
E. Baidu, http://www.baidu.com/    
F. Sina, http://www.sina.com.cn/    
G. iFeng, http://www.ifeng.com/    
H. Novagin, http://www.novagin.com/cn/index.htm    
I. IGRS Lab, http://www.tivic.com/    
J. Front network, http://www.frontnetwork.com/      
K. Middling industries, http://www.middlingindustries.com/    
L. iLouShi, http://www.iloushi.cn/    
M. Duopeng, http://www.duopeng.com/    
N. VoiceFrom, http://voicefrom.me/    
O. Distance Education Group, http://www.sdeg.cn/sdegPortal/    
P. MesonTech, http://www.mesontech.com.cn/home/mesontech.jsp

![Vendors](http://blog.whatsbug.com/wp-content/uploads/2013/01/bee_2013.jpg)


##Apps are using {bee}

1. Sina Finance(新浪财经)    
   https://itunes.apple.com/us/app/xin-lang-cai-jing/id430165157?mt=8
2. Mengtu(萌图)    
   https://itunes.apple.com/us/app/meng-tu/id531292307?mt=8    
3. iLoushi(i楼市)    
   http://itunes.apple.com/cn/app/id464232572?mt=8(iPhone)    
   https://itunes.apple.com/cn/app/id428916075?mt=8(iPad)    
4. Duopeng(多朋)    
   http://www.duopeng.com/    
5. Yiban(易班)    
   https://itunes.apple.com/app/yi-ban/id549775029?mt=8    
6. Golden carp(金鲤鱼理财)    
   https://itunes.apple.com/cn/app/id584687764    
7. Tivic(TV客)    
   http://mobile.91.com/Soft/Detail.aspx?Platform=iPhone&f_id=1373668    
8. Middling(Middling图书)    
   https://itunes.apple.com/us/app/middling/id531625104?mt=8    

--------------------

Requirements
--------------------

  * Mac OS X 10.6, Xcode 4
  * iOS 4.0 or Higher


File Directory
--------------------

  * BeeDebugger/  
  * BeeFramework/  
     * Core/: Bee Core    
     * MVC/: Bee MVC    
  * External/
  * Example/
  * Documention/

How to run
--------------------

1. Open Example/WhatsBug.xcodeproj
2. Build and run

Installation
--------------------

1. Copy files below into your project folder:    
   a. BeeFramework/
   b. BeeDebugger/
   c. BeeUnitTest/
   d. External/
2. Drag and drop into your XCode project    
3. Add Framework：    
   a. libz.dlib    
   b. libsqlite3.dylib
   c. libxml2.dylib
   d. AVFoundation.framework
   e. CFNetwork.framework    
   f. CoreMedia.framework
   g. CoreVideo.framework
   h. CoreGraphics.framework    
   i. Foundation.framework    
   j. MobileCoreServies.framework (ASI)    
   k. QuartzCore.framework    
   l. Security.framework (MD5)    
   m. SystemConfiguration.framework (Reachibility)    
   n. UIKit.framework    
4. Modify your precompile header file:    
   a. \#define \__BEE_DEVELOPMENT__  (1)      
   b. \#define \__BEE_LOG__          (1)    
   ...
5. Build and run    
6. Good luck    

Import by cocoapods （Thanks @stcui）
--------------------

This fork is for porting to cocoapods

use cocoapods to enjoy your development

http://cocoapods.org

just add 

```
platform :ios
pod 'BeeFramework', :head
```

to `Podfile` and run `pod install`


[1]: http://www.whatsbug.com
[2]: http://itunes.apple.com/cn/app/qq-you-xi-da-ting/id443908613?mt=8
[3]: http://itunes.apple.com/cn/app/qq-kong-jian/id364183992?mt=8
