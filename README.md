#Bee framework

A rapid development framework for iOS applications.
By geek, for geek.

--------------------

QQ Group:      79054681    
website:       http://www.bee-framework.com    
email:         gavinkwoe@gmail.com    
google groups: https://groups.google.com/d/forum/beeframework?hl=zh-CN

--------------------

Happy chinese new year~~~~
![Fu](http://blog.whatsbug.com/wp-content/uploads/2013/02/fu2.jpg)

##Who using Bee

####Companies

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

####Projects

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

1. Add overload graph in BeeDebugger    
2. Add BeeDatabase(based on FMDB) and BeeActiveRecord    
3. Fix some bugs
4. Move precompile options to 'Bee_Precompile.h'     

From now, you can use SQLITE everywhere in fantastic way!    
See 'Lession11' & 'Bee_ActiveRecordTest.h/.m' & 'BeeDatabaseTest.h/.m'    

Fantastic BeeDatabase:

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

Fantastic BeeActiveRecord:

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
	
New overload graph:

![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/12/bee_5.png)

##v0.1 changes

1. Add more DEMOs (useful~~)
2. Add Heatmap (cool~~)

![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/11/bee_1.png)
![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/11/bee_2.png)
![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/11/bee_3.png)
![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/11/bee_4.png)

--------------------

## For all the coding ninjas out there

Ever want to build better iOS apps faster and cheaper? Check out Bee, a new rapid development framework that will turbo charge your new projects!

### Welcome Bee

Bee is a rapid development framework for iOS applications, which integrates COCOA TOUCH components and provides concise interface, allowing developers to develop apps more quickly.
Bee adds features to COCOA TOUCH to simplify implementation and reduce the amount of code you need to write, freeing up your time to do what you enjoy, building cool apps.

### Who is Bee for?

1. You want a compact framework
2  You need to develop a working app quickly
3. You like to write simple and well structured codes
4. You need to something with complete, clear documentation
5. You hate complex designs
6. You hate to all the hidden rules you need to follow in iOS development

If you agree with one or more of the above, congratulations! Bee framework is for you.

### Basic requirements

1. You have some knowledge of Objective-C
2. You know what CocoaTouch is
3. You know what MVC, View, ViewController are

If you know one or more of the above, congratulations! Bee framework is for you.

# Join a growing family

Developers from top Asian sites like Baidu, Tencent and Sina are using this, join us!

QQ group: 79054681
Forum: <http://bbs.whatsbug.com> (website maintenance)


### Bee is free

The Bee is distributed under the MIT open source license so please feel free to use it in any project:

  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### Bee is lightweight

The use of the base class library and MVC is optional, the core part of the framework is very compact.

### Bee is fast and reliable

Bee allows your app to run quickly and smoothly. Tested in a number of projects to ensure reliability.

### Bee uses M-V-C model

With Bee, the interface and logic has been separated, allowing you to reuse codes more easily. You can also resuse elements to build your interface.

M: Model - data persistence or and caching all in here

C: Controller - business logic and cloud interaction logic live here

V: View - ViewController interface display and interface logic here

### Bee uses a clean VIEW structure

Bee split the complex and usually difficult UI development process into 3 parts: View, Layout and Data. For web developers this can be thought of as HTML, CSS, data. Interface gets redrawn when the data is loaded or changed. To simplify the code, you only need to know when View is filled with new data before the layout is updated.

The product's UI often needs refactoring, which makes life for IOS developers more difficult.  So what should you do when you know the interface will change but you still want to use interface builder to build a demo quickly and don't want to write dynamic coordinate calculations?

Bee gives you a simple solution, you can use a UI "cell", the BeeUIGridCell class, for the most important elements. Here are the three simple steps (more details shown later):

1. Calculate size of the canvas  cellSize: bound:
2. Calculate internal layout cellLayout: bound:
3. Fill data (strings, images, etc.) bindData:

You can use these simple three functions to meet the requirements of various UI changes.

This solution is simple without sacrificing flexibility. BeeUIGridCell can correspond to multiple layouts and you can quickly finish UI adjustments without changing the logic and without increasing or decreasing the number of internal elements.

Here's an example cell layout (more details in later chapters):

-- xxxView.h

    // Layout 1
    @interface MyLayout1 : NSObject
    AS_SINGLETON(MyLayout1)
    @end

    // Layout 2
    @interface MyLayout2 : NSObject
    AS_SINGLETON(MyLayout2)
    @end

    @interface MyCell : BeeUIGridCell
    {
    	UILabel * _subView1;
        UILabel * _subView2;
    }
    @end

-- xxxView.mm

	@implementation MyLayout1
	+ (CGSize)cellSize:(NSObject *)data bound:(CGSize)bound
	{
		return CGSizeMake( bound.width, 90.0f ); // width unchanged, height 90
	}
	- (void)cellLayout:(BeeUIGridCell *)cell bound:(CGSize)bound
	{
		_subView1.frame = …;
		_subView2.frame = …;
	}
	- (void)bindData:(NSObject *)data
	{
		_subView1.text = …;
		_subView2.text = …;
		[super bindData:data];	// Bee will determine whether the data has changed, then recalculate layout
		}
	}
	@end

	...
    {
        MyCell * cell = [[MyCell alloc] init];
        if ( ... )
            cell.layout = [MyLayout1 sharedInstance];
        else
            cell.layout = [MyLayout2 sharedInstance];
    }

-- xxxViewController.mm

    {
        
        MyCell * cell = ...;

        [cell bindData:[NSDictionary dictionary]];	// mode 1, automatic layout
        [cell layoutAllSubcells];	// mode 2, manual layout
    }
    
After seeing this you may ask: we now have a 'HTML', 'CSS', 'Data', but where did 'Javascript' go to? How can events be passed and processed?

You have two options, a traditional Delegate or a new way using UISignal.
The two options essentially do the same thing, but the latter is a simpler and better way of passing events between multilayers UIView.

Another example illustrates UISignal (more details in later chapters):

-- xxxView.h

    @interface MyCell : BeeUIGridCell
    AS_SIGNAL( TEST )	// declare SIGNAL
    @end

-- xxxView.m

    @implementation MyCell
    DEF_SIGNAL( TEST )	// define SIGNAL
	- (void)someEvent
	{
		[self sendUISignal:MyCell.TEST];	// send the signal
	}
    @end

-- xxxViewController.m

	- (void)loadView
	{
		MyCell * cell = [[MyCell alloc] init];
		[self.view addSubview:cell];
	}

	- (void)handleUISignal:(BeeUISignal *)signal
	{
		if ( [signal is:MyCell.TEST] )
		{
			// do something
		}
		[super handleUISignal:signal]; // pass to super view

As you can see, the UIView hierarchical relationship exists and UISignal can move up from views below.
Define method is also easy, can just use DEF_SIGNAL().

Later chapters will introduce examples of more complex UI implementations developed using Bee to illustrate how it works.

	Q: How can your interface can be split into a number of Cells? How to replace Delegate with Signal?


### Using Bee for clean CONTROLLER structure 

The Controller is where the logic of the application lives, also known as the "business logic".
How to effectively organize business logic, how to effectively reuse business logic, and how to decouple the VIEW as much as possible?

Bee completely separates the Controller from the View via Message (the messaging mechanism). Bee allows automatic message routing that can be asynchronous. It is also responsible for communicating with the cloud (server).

You can see it this way:

1. View just shows data in the right format and occasionally produces user driven events
2. Controller is only responsible for the implementation of logic (even if executed on the server side) and the results (data) is returned to the View to be displayed.

As we mentioned earlier, the equivalent of this in web development is: View is HTML + CSS, Controller is AJAX.
One thing to note, if the Controller contains logic executed in the Cloud, the request will take time, and will need to be asynchronous.

This example shows how to use the Controller ( will be described in more detail later):

-- xxxController.h

    @interface MyController : BeeController

    AS_MESSAGE( TEST ) // declare the message

    @end

-- xxxController.mm

    @implementation MyController

    DEF_MESSAGE( TEST ) // define the message

    - (void)TEST:(BeeMessage *)msg
    {
        if ( msg.sending ) // being sent
        {
			NSString * param1 = [msg.input objectForKey:@"param1"];
			NSString * param2 = [msg.input objectForKey:@"param2"];
	
			// Controller request data from a website
            [msg POST:@"http://api.XXX.com/" data:...];
        }
		else if ( msg.progressed ) // send / receive progress updates
		{
		}
        else if ( msg.succeed ) // success
        {
            NSDictionary * obj = [msg.response objectFromNSData]; // parse response to package
            if ( nil == obj )
            {
                [msg setLastError:... domain:...]; // abnormal situation, do something
                return;
            }

            [msg output:@"result", obj, nil]; // output results
        }
        else if ( msg.failed ) // error
        {
        }
        else if ( msg.cancelled ) // canceled
        {
        }	
    }

-- xxxViewController.mm

    .... 

    {
		// MyController automatically initialized and mounted by Bee
        [MyController sharedInstance]; 
    }

    ....

    {
        // Your code can send a message anywhere, it is automatically routed to MyController :: TEST method
            [[self sendMessage:MyController.TEST] input:
            @"param1", @"value1",	// input parameters 1
            @"param2", @"value2",	// input parameters 2
            nil];
    }

    ....

    - (void)handleMessage:(BeeMessage *)msg
    {
		if ( [msg is:MyController.TEST] )
		{
	        [self showLoading:msg.sending]; // update interface state

    	    if ( msg.succeed )
        	{
            	// Prompt success
	        }
			else
			{
				// Send fail
			}
		}
    }
    
You can see here the complete separation of the View from the Controller, and how simple the sending and receiving of messages has become.

Defining the message is also extremely simple, just DEF_MESSAGE ().

More details are introduced in later chapters.

	Q: Think about how your APP should use several Controllers, and about the Messages to be sent between them?

### The Bee using clean MODEL structure

Very simple, see Bee_Model.h. Will have ActiveRecord support in the future.

### Bee also provides other powerful features

In-app debugging mode, performance monitoring, asynchronous network communication, multi-threaded, easy expandability, UIView extensions and more.

### Bee-depth used by top Internet companies

Top Internet companies already use this framework to build many successful apps. 

# Bee Cheat Sheet

	.Foundation
		.Cache
			BeeFileCache			- file cache
			BeeMemoryCache			- memory cache
		.Network
			BeeRequest				- network request
		.Debug
			BeeCallFrame			- call stack
			BeeRuntime				- run
			BeePerformance			- perfromance testing
		.FileSystem
			BeeSandbox				- sandbox
		.Utility
			BeeLog() / CC			- log
			BeeSystemInfo			- system information
		.Thread
			BeeTaskQueue			- multi-threaded execution queue
		
	.MVC
		.Controller
			BeeMessage				- message
			BeeMessageQueue			- message queue
			BeeController			- controller
		.Model
			BeeModel				- data model
		.View
			.UI
				BeeUIScrollView					- horizontal / vertical scroll list
				BeeUIPageControl				- page
				BeeUINavigationBar				- navigation bar
				BeeUIActionSheet				- pop-up menu
				BeeUIActivityIndicatorView		- loading indicator
				BeeUIAlertView					- pop-up dialog box
				BeeUIButton						- button
				BeeUIDatePicker					- date picket
				BeeUIFont						- font
				BeeUIGridCell					- cell
				BeeUIImageView					- images
				BeeUIKeyboard					- keyboard
				BeeUILabel						- label
				BeeUIOrientation				- interface orientation
				BeeUIProgressView				- progress bar
				BeeUIPullLoader					- pull-down refresh
				BeeUISegmentedControl			- segmented indicator
				BeeUISignal						- signal
				BeeUITabBar						- tab menu
				BeeUITextField					- single-line text box
				BeeUITextView					- multi-line text box
				BeeUIWebView					- webview
				BeeUIZoomView					- zoom
			.UIController
				BeeUIBoard						- whiteboard (UIViewController)
				BeeUIStack						- whiteboard stack (UINavigationController)
				BeeUIStackGroup					- stack
				BeeUICameraBoard				- camera
				BeeUIFlowBoard					- data stream
				BeeUITableBoard					- table
				BeeUIWebBoard					- browser
		
Requirements
--------------------

  * Mac OS X 10.6, Xcode 4
  * iOS 4.0 or Higher


File Directory
--------------------

  * BeeDebugger/  
  * BeeFramework/  
     * External/: 3rd-party libs
     * Foundation/: Bee foundation
     * MVC/: Bee MVC
  * Example/
  * Documention/

How to run
--------------------

1. Open Example/WhatsBug.xcodeproj
2. Build and run

Installation
--------------------

1. Copy BeeFramework/ and BeeDebugger into your project folder    
2. Drag and drop both two source folder into your XCode project    
3. Add Framework：    
   a. libz.dlib    
   b. CFNetwork.framework    
   c. CoreGraphics.framework    
   d. Foundation.framework    
   e. MobileCoreServies.framework (ASI)    
   f. QuartzCore.framework    
   g. Security.framework (MD5)    
   h. SystemConfiguration.framework (Reachibility)    
   i. UIKit.framework    
4. Modify your precompile header file:    
   a. \#define \__BEE_DEVELOPMENT__  (1)      
   b. \#define \__BEE_LOG__          (1)    
   c. \#define \__BEE_DEBUGGER__     (1)    
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
