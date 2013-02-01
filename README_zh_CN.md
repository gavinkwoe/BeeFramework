#Bee Framework

一款基于IOS平台的快速开发框架，源于极客。

--------------------

QQ群: 79054681    
邮箱: gavinkwoe@gmail.com    
网站: http://www.bee-framework.com    
邮件列表（google groups）： https://groups.google.com/d/forum/beeframework?hl=zh-CN

-----------------
##谁在使用 BeeFramework

####公司

A. 中国移动, http://www.chinamobileltd.com/sc/global/home.php    
B. 中国联通, http://www.chinaunicom.com.cn/    
C. 中国电信, http://www.chinatelecom.com.cn/    
D. 腾讯, http://www.qq.com/    
E. 百度, http://www.baidu.com/    
F. 新浪, http://www.sina.com.cn/    
G. 凤凰网, http://www.ifeng.com/    
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

#### 项目

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
   
------------------------------

##v0.2.3 变更

1. 重构目录结构，Core与MVC完全分离，源文件与Extension分离
2. 重构BeeDatabase及BeeActiveRecord代码结构，更清晰
3. 支持ActiveRecord继承及嵌套，支持HAS、BELONG_TO等高级操作（后续会添加更多类RUBY高级特性），如：

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

4. HTTP及MESSAGE支持点操作，如：

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


5. 修复部分BUG（感谢群友们的支持！爱你们）

##v0.2 变更

1. 增加负载图表在BeeDebugger中    
2. 增加数据库及活动记录的支持    
3. 修改了一些BUG，感谢同学们的给力支持！    
4. 把所有编译选项都移到Bee_Precompile.h里了    

从现在开始，你可以用一种更神奇的方式在做任何代码中使用SQLITEF。    
详情请见 'Lession11'、'Bee_ActiveRecordTest.h/.m'、'BeeDatabaseTest.h/.m'    

神奇的BeeDatabase:

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

神奇的BeeActiveRecord:

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
		
新增加负载图:

![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/12/bee_5.png)

##v0.1 变更

1. 增加更多DEMO
2. 增加热点统计

![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/11/bee_1.png)
![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/11/bee_2.png)
![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/11/bee_3.png)
![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/11/bee_4.png)

###Geek们都在用!

你自认为是GEEK吗？燃烧起来吧！

在时间成本、学习成本、开发成本同时兼顾的情况下，BEE是最好的RAD开发选择。

###欢迎使用Bee

Bee是一套给iOS开发者使用的应用程序“快速”开发框架，它集成了基于COCOA TOUCH的很多扩展组件，并提供简洁（稍有些抽象）的接口，其目的是让开发人员可以"快速"地进行项目开发（不管您是接外包也好，还是给投资人演示DEMO也好，都将是第一选择）。
Bee一来弥补COCOA TOUCH部分缺失功能，二来简化实现并减少代码量，使您可以全身心投入到创造性开发上去。

###Bee是为谁准备的？

1. 你需要一个小巧的框架
2. 你需要短时间内快速开发DEMO
3. 你喜欢把代码写的简单有条理
4. 你需要完整、清晰的文档
5. 你讨厌复杂的设计
6. 你讨厌被迫理解IOS潜规则

if ( 满足以上任何一条 ) echo '恭喜您，继续往下读';

###基本要求

1. 您大概了解ObjectiveC是个啥东西。
2. 您大概了解CocoaTouch是个啥东西。
3. 您大概了解MVC、View、ViewController是个啥东西。

if ( 满足以上任何一条 ) echo '恭喜您，继续往下读';


#加入联盟

百度、腾讯、新浪、网易、SOHU的一线终端开发人员都在这里！    

QQ群：79054681    
论坛：<http://bbs.whatsbug.com> （网站维护中）

#Bee是什么

#####Bee是英文蜜蜂的意思 :-)

Bee是项目代号，寓意着“清晰，灵活，高效，纯粹”。    

#####Bee是应用程序框架

这此略去N字

#####Bee是免费的

Bee 是经过MIT开源许可授权的，可以不经过作者的同意，进行传播、修改、再发布，以及商业化，完全不存在任何法律问题，请放心使用。

#####Bee是轻量级的

非常轻量。其中基础类库可选择性的使用，M-V-C也可选择性使用，其核心部分只有很少量的代码。

#####Bee是快速的

非常快速。经过多个项目测试，没有因为封装而在效率上受影响，我们尽可能的保持快速。

#####Bee使用M-V-C模型

在使用Bee的同时，您会自觉的将界面与逻辑分离开来。    
最大化复用逻辑，最大化用多布局来LAYOUT具有相同元素的界面。

M: Model，数据持久化或数据Cache都在这里    
C: Controller，业务逻辑或与云端交互逻辑都在这里    
V: View + ViewController，界面展示及界面逻辑都在这里    

#####Bee使用干净的VIEW结构

Bee通过轻度的封装，将原本复杂繁重的UI开发工作细化为3部分：View、Layout、Data，可以想像成WEB开发中的HTML、CSS、数据。通过“数据加载或变化时重绘”的机制，简化代码逻辑，开发者只需要知道什么时候给View填充数据即可，计算布局由Bee搞定。

在一些互联网公司中，他们的产品经常需要重构UI的，这往往给IOS开发人员带来很大困扰。我想用interface builder快速开发DEMO，又不想写死坐标，如果动态计算，或将来更换布局，我该怎么办？

Bee给您一套简单可行的方案，最常用的，也是建设UI最主要用到的控件是“单元格”，类名叫做BeeUIGridCell，其分别需要开发者其实3个方法（随后章节会细讲）也是3个步骤：    

1. “计算画布大小”				cellSize:bound:
2. “计算内部布局”				cellLayout:bound:
3. “填充数据（字符串图片等）”	bindData:

通过简单实现3个函数，满足各种UI变化的需求。

同时，这套所谓“简单可的方案”也不失灵活性，一个BeeUIGridCell可对应多个布局，在不改变逻辑和增减内部元素的情况下，快速完成UI调整。

下面举个例子说明“单元格”及布局（后面章节中会详细介绍）：

-- xxxView.h

    // 布局1
    @interface MyLayout1 : NSObject
    AS_SINGLETON(MyLayout1)
    @end

    // 布局2
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
		return CGSizeMake( bound.width, 90.0f ); // 宽不变，高为90
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
		[super bindData:data];	// Bee会判断数据是否变了，然后重算布局
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

        [cell bindData:[NSDictionary dictionary]];	// 方式1，自动布局
        [cell layoutAllSubcells];	// 方式2，手动布局
    }

您可能会问：刚刚讲了，我们有了”HTML、CSS、数据”，那么JS哪去了？事件怎样传递和被处理？

您有两个选择，一个是传统的Delegate方式，另一种是新引入的UISignal。    
两种机制本质上是做相同的事情，不过后者采用更聪明简单的方式完成多层UIView之间传事件。

再来个例子说明UISignal（后面章节中会详细介绍）：

-- xxxView.h

    @interface MyCell : BeeUIGridCell
    AS_SIGNAL( TEST )	// 声明SIGNAL
    @end

-- xxxView.m

    @implementation MyCell
    DEF_SIGNAL( TEST )	// 定义SIGNAL
	- (void)someEvent
	{
		[self sendUISignal:MyCell.TEST];	// 发送Signal
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
	}

可以看到，只要存在UIView的层级关系当中，就可以从子级向上透传UISignal。    
而定义方法也极其简单明了，AS/DEF_SIGNAL()即可。

更多细节在后面章节介绍，许多看起来复杂华丽的UI实现，在Bee的支撑下，代码变及清晰简单。

	问：想想怎样把你的界面拆成若干个Cell？怎样把Delegate替换成Signal？

#####Bee使用干净的CONTROLLER结构

相对于View，Controller是存放逻辑的地方，往往是大家所说的看不见的部分，被称为“业务逻辑”。
怎样有效的组织业务逻辑，怎么有效的复用业务逻辑，又使之与VIEW最大程度解耦合？

Bee将Controller与View完全分离，通过Message（消息机制）通讯，并自动消息路由，且逻辑的执行大多是异步的，而且额外负责与云端（服务器）的通讯。

那么您可以这样理解：

1. View只是个数据的Formatter，管理数据显示成什么样子，偶尔产生一些用户事件。
2. Controller只是负责执行逻辑（即便是在服务器端执行），并把结果（数据）返回给View去显示。

这样理解，我们就懂了，原来作者所说的就是View是HTML+CSS，Controller是AJAX。    
或者说Controller是云端逻辑在客户端中的代理，请求需要时间，所以是异步。

举例说明消息及控制器怎样用（后面章节中会详细介绍）：    

-- xxxController.h

    @interface MyController : BeeController

    AS_MESSAGE( TEST ) // 声明消息

    @end

-- xxxController.mm

    @implementation MyController

    DEF_MESSAGE( TEST ) // 定义消息

    - (void)TEST:(BeeMessage *)msg
    {
        if ( msg.sending ) // 正在发送时
        {
			NSString * param1 = [msg.input objectForKey:@"param1"];
			NSString * param2 = [msg.input objectForKey:@"param2"];
	
			// Controller通过Message向某网站请求数据
            [msg POST:@"http://api.XXX.com/" data:...];
        }
		else if ( msg.progressed ) // 发送/接收进度更新时
		{
		}
        else if ( msg.succeed ) // 成功时
        {
            NSDictionary * obj = [msg.response objectFromNSData]; // 解析回应包
            if ( nil == obj )
            {
                [msg setLastError:... domain:...]; // 异常情况，做点什么
                return;
            }

            [msg output:@"result", obj, nil]; // 输出结果
        }
        else if ( msg.failed ) // 错误时
        {
        }
        else if ( msg.cancelled ) // 取消时
        {
        }	
    }

-- xxxViewController.mm

    .... 

    {
		// MyController自动初始化及挂接到Bee内核
        [MyController sharedInstance]; 
    }

    ....

    {
        // 在你代码任意位置可以发送消息，它会自动路由到MyController::TEST方法中去
        [[self sendMessage:MyController.TEST] input:
            @"param1", @"value1",	// 输入参数1
            @"param2", @"value2",	// 输入参数2
            nil];
    }

    ....

    - (void)handleMessage:(BeeMessage *)msg
    {
		if ( [msg is:MyController.TEST] )
		{
	        [self showLoading:msg.sending]; // 更新界面状态

    	    if ( msg.succeed )
        	{
            	// 提示成功
	        }
			else
			{
				// 提示失败
			}
		}
    }

可以看到，View与Controller完全分离，消息的发送和接收也是非常简单的事情。
而定义方法也极其简单明了，AS/DEF_MESSAGE()即可。

更多细节在后面章节介绍。

	问：想想你的APP应该有几个Controller，以及应该分别有几个Message？

#####Bee使用干净的MODEL结构

很简单，详见Bee_Model.h，未来会对ActiveRecord支持。

#####Bee功能强大

调试功能，性能监测，网络异步交互，多线程，Foundation扩展，UIView扩展等等。

#####Bee深入国内顶尖互联网公司

Geek们都在用！行业内N家顶级互联网公司在采用。


#Bee速记表

	.Foundation
		.Cache
			BeeFileCache			- 文件缓存
			BeeMemoryCache			- 内存缓存
		.Network
			BeeRequest				- 网络请求
		.Debug
			BeeCallFrame			- 调用栈
			BeeRuntime				- 运行时
			BeePerformance			- 性能测试
		.FileSystem
			BeeSandbox				- 沙箱
		.Utility
			BeeLog() / CC			- 日志
			BeeSystemInfo			- 系统信息
		.Thread
			BeeTaskQueue			- 多线程执行队列
		
	.MVC
		.Controller
			BeeMessage				- 消息
			BeeMessageQueue			- 消息队列
			BeeController			- 控制器
		.Model
			BeeModel				- 数据模型
		.View
			.UI
				BeeUIScrollView					- 横向/纵向滚动列表
				BeeUIPageControl				- 页码
				BeeUINavigationBar				- 导航条
				BeeUIActionSheet				- 弹出菜单
				BeeUIActivityIndicatorView		- 加载指示器
				BeeUIAlertView					- 弹出对话框
				BeeUIButton						- 按钮
				BeeUIDatePicker					- 日期选择器
				BeeUIFont						- 字体
				BeeUIGridCell					- 单元格
				BeeUIImageView					- 图片
				BeeUIKeyboard					- 键盘
				BeeUILabel						- 标签
				BeeUIOrientation				- 界面方向
				BeeUIProgressView				- 进度条
				BeeUIPullLoader					- 下拉刷新
				BeeUISegmentedControl			- 分段指示器
				BeeUISignal						- 信号
				BeeUITabBar						- Tab菜单
				BeeUITextField					- 单行文本框
				BeeUITextView					- 多行文本框
				BeeUIWebView					- 网页
				BeeUIZoomView					- 缩放
			.UIController
				BeeUIBoard						- 白板(UIViewController)
				BeeUIStack						- 白板堆栈(UINavigationController)
				BeeUIStackGroup					- 堆栈组
				BeeUICameraBoard				- 照相机
				BeeUIFlowBoard					- 瀑布流
				BeeUITableBoard					- Table
				BeeUIWebBoard					- 浏览器

运行要求
--------------------

  * Mac OS X 10.6, Xcode 4
  * iOS 4.0 or Higher


目录结构
--------------------

  * BeeDebugger/  
  * BeeFramework/  
     * External/: 3rd-party libs
     * Foundation/: Bee foundation
     * MVC/: Bee MVC
  * Example/
  * Documention/

如何运行
--------------------

1. 打开 Example/WhatsBug.xcodeproj
2. 编译并运行

如何安装
--------------------

1. 复制 BeeFramework/ 和 BeeDebugger 目录到您的工程
2. 拖拽并添加两个目录到您的XCode工程
3. 添加Framework：
   a. libz.dlib
   b. CFNetwork.framework
   c. CoreGraphics.framework
   d. Foundation.framework
   e. MobileCoreServies.framework (ASI)
   f. QuartzCore.framework
   g. Security.framework (MD5)
   h. SystemConfiguration.framework (Reachibility)
   i. UIKit.framework
4. 修改预编译.pch头文件
   a. \#import "Bee.h"
   b. \#define __BEE_DEVELOPMENT__  (1)
   c. \#define __BEE_LOG__          (1)
   d. \#define __BEE_DEBUGGER__     (1)
5. 编译并运行
6. Good luck


使用cocoapods管理
--------------------

BeeFramefork 已经支持 [cocoapods](http://cocoapods.org) 管理依赖

在 `Podfile` 中添加 

```
platform :ios
pod 'BeeFramework',:head
```

并执行 `pod install`

[1]: http://www.whatsbug.com
[2]: http://itunes.apple.com/cn/app/qq-you-xi-da-ting/id443908613?mt=8
[3]: http://itunes.apple.com/cn/app/qq-kong-jian/id364183992?mt=8
