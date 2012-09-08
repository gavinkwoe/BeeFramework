Bee framework
==================

[Bee Framework][1] 是一款iOS平台的MVC应用快速开发框架，使用Objective-C开发。  
其早期原型曾经被应用在 [QQ游戏大厅 for iPhone][2]、[QQ空间 for iPhone][3] 等多款精品APP中。 在最近几个月中，我梳理并重构了设计，并取名为Bee，寓意着“清晰，灵活，高效，纯粹”。

Bee 从根本上解决了iOS开发者长期困扰的各种问题，诸如：分层架构如何设计，层与层之间消息传递与处理，网络操作及缓存，异步及多线程，以及适配产品多变的UI布局需求。

##（更多文档及DEMO APP将在近两周内持续发布，请大家保持关注）
## 官方QQ群：79054681

特点
--------------------

   * 代码注入    
     借助于OC语言特性，Bee将核心逻辑注入到NSObject基类中去，在使用Bee时，大多数情况下可以不必修改现有类继承关系，这样设计是把双刃剑，也有可能与您现有方法名冲突。
     在您代码中任何位置都可以这样做：    
     [self GET:@"http://www.qq.com/logo.png"];    
     [self POST:@"http://api.qq.com/" data:[NSData data]];    
     [self postNotification:@"SOME_NOTIFICATION"];    
     [self sendMessage:@"SOME_MESSAGE" timeoutSeconds:10.0f];    
     [self sendUISignal:@"SOME_SIGNAL"];    

   * 基于MVC模型    
     典型的MVC架构，清楚的分为View、Controller、Model三个层次，业务数据、业务逻辑、界面展现、交互逻辑完全分离。

   * 事件驱动    
     对于Controller、Model均与状态无关（Stateless），因此由三种Event驱动：Message、Request、Notification。对于View，我们抛弃掉了老旧的Delegate（语言级实现方式），引入新概念UISignal（框架级实现方式）用来驱动界面交互事件或状态改变。  

   * UISignal    
     UISignal拥有极强的路由能力，可以在UIView <-> UIView <-> UIViewController <-> UINavigationController <-> UIViewController 之间完成复杂且高效的的UI信号路由。
 
     那么，我们来看一个关于UISignal的实际运行的例子：  

     [signal.BeeUIImageView.LOAD_COMPLETED] >  // 信号发送   
     BeeUIImageView >                          // 信号发给了自己   
     DribbbleCell >                            // 二传给superview   
     UITableViewCellContentView >              // 三传给contentView   
     BeeUITableViewCell >                      // 四传给UITableViewCell  
     UITableView >                             // 五传给UITableView   
     BeeUIBoardView >                          // 六传给UIViewController.view  
     DribbbleBoard                             // 七传给UIViewController   

     实际上，我只写了一行代码⋯⋯  
     [self sendUISignal:BeeUIImageView.LOAD_COMPLETED];   

     神奇吗？
 
   * 哪里发送哪里接收    
     尽可能允许您将UISignal、Message、Request、Notification相关处理逻辑内嵌到物理位置上相同的代码中，型成整体，方便维护及并行开发。  
     典型的例子是一个APP界面即收发网络请求，又处理控制器相关消息，同时又处理子控件发来的信号。不用担心，这些代码优美而秩序的展现在您面前。

   * 基于状态的新UIBoard    
     基于State，重新定义了UIViewController的实现方式，统一称为UIBoard，同样的，UINavigationController统一称为UIStack。   
     开发者只需关注UIBoard状态变化时该做什么事，以及子级控件的UISignal该怎样处理。

   * 内置Debugger    
     不依赖于XCode instrument，Bee自身提供了App内调试工具。  
     您可以随时观察APP运行状态，诸如：  
       * 网络请求：请求详情，成功失败率，网速限制（模拟3G、2G），开网断网
       * 内存占用：内存剩余，模拟分配，模拟内存警告
       * 事件处理：Notification、Message历史列表
       * 界面状态：界面存活，数据，状态
       * 沙盒浏览：在线查看沙箱目录中所有文件
       * 异常模拟等功能

![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/08/screenshot1.png)
![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/08/screenshot2.png)
![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/08/screenshot3.png)
![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/08/screenshot4.png)
![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/08/screenshot5.png)
![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/08/screenshot6.png)
![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/08/screenshot7.png)
![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/08/screenshot8.png)
![Debugger](http://blog.whatsbug.com/wp-content/uploads/2012/08/screenshot9.png)

主要模块
--------------------

   * External
     外部信赖库
     * ASI: 网络通讯库
     * JSONKit: JSON解析引擎
     * Reachability: 网络接入点检测
   * Foundation
     基础模块，及NSObject扩展
     * Cache
       * JSON based
       * File cache
       * Memory cache
     * Log
       * NSLog wrapper
       * VAR_DUMP
     * Network
       * GET/POST
       * File upload
       * Black list
     * Performance
     * Runtime
       * Object allocation
       * Callstack
     * Sandbox
     * Singleton
     * SystemInfo
       * UDID
       * System version
       * Jailbreak detection
     * Thread
       * Block based
   * MVC
     * Controller
       * Message
       * Action mapping/routing
     * Model
     * View
       * UIView
         * Touchable
         * UISignal
       * UIActionSheet
       * UIActivityIndicator
       * UIAlertView
       * UIButton
       * UIColor
       * UIDatePicker
       * UIFont
       * UIGridCell
       * UIImageView
         * 支持网络异步加载   
       * UIKeyboard
       * UILabel
       * UIOrientation
         * 方向变化通知
         * 角度变化通知
       * UIProgressView
       * UIPullLoader
       * UIRect
         * 拉伸
         * 位移
       * UISegmentedControl
       * UITabBar
       * UITextView
       * UIWebView
       * UIZoomView
     * ViewController
       * UIBoard
       * UIStack
       * UIStackGroup
       * UITableBoard
       * UIFlowBoard

编译要求
--------------------

  * Mac OS X 10.6, Xcode 4


运行要求
--------------------

  * iOS 4.0 或更新版本


目录结构
--------------------

  * BeeDebugger/  
     内置调试工具
  * BeeFramework/  
     框架源代码主目录
     * Core/: 核心模块
     * Extension/: 基础类扩展
     * View/: 基础视图控件
     * ViewController/: 基础视图控制器
  * Example/  
     相关教程及示例代码
  * Documention/
     相关文档
  * External/
     第三方库引用


已知问题
--------------------
1. 内存泄露（正在解决）
2. 下拉刷新（没写完）


运行例程
--------------------

双击打开Example/WhatsBug.xcodeproj，编译并运行。


安装步骤
--------------------

1. 将BeeFramework目录完整复制到项目目录中去。
2. 添加BeeFramework到工程目录
3. 添加相关Framework：
   a. libz.dlib
   b. CFNetwork.framework
   c. CoreGraphics.framework
   d. Foundation.framework
   e. MobileCoreServies.framework (ASI)
   f. QuartzCore.framework
   g. Security.framework (MD5)
   h. SystemConfiguration.framework (Reachibility)
   i. UIKit.framework
4. 在工程的.pch预编译头中加入：
   a. \#import "Bee.h"
   b. \#define __BEE_TESTING__  (1) // 是否启用开发模式
   c. \#define __BEE_LOG__      (1) // 是否打印LOG
   d. \#define __BEE_DEBUGGER__ (1) // 是否开启Debug
5. 编译运行
6. Good luck

联系方式
--------------------

QQ: 5220509
邮箱: gavinkwoe@gmail.com

我们架构了论坛 [bbs.whatsbug.com][4]，供大家讨论专用。

[1]: http://www.whatsbug.com
[2]: http://itunes.apple.com/cn/app/qq-you-xi-da-ting/id443908613?mt=8
[3]: http://itunes.apple.com/cn/app/qq-kong-jian/id364183992?mt=8
[4]: http://bbs.whatsbug.com
