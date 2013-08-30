BeeFramework : app development framework
==================================

BeeFramework is a new generation of development framework which makes faster and easier app development, created and maintained by [Gavin Kwoe](https://github.com/gavinkwoe) and [QFish](https://github.com/qfish).

![Bee logo](http://blog.whatsbug.com/wp-content/uploads/2013/08/bee-logo.png)

* Contact us, email <b> [gavinkwoe@gmail.com](gavinkwoe@gmail.com) </b>
* Contact us, follow <b> [@老郭为人民服务 on 新浪微博](http://www.weibo.com/gavinkwoe) </b>
* Join us, QQ Group <b><a> 79054681 </a></b>
* Join us, Developer forum <b> [forum.bee-framework.com](http://forum.bee-framework.com) </b>

### Special thanks to

[![Geek-Zoo](http://geek-zoo.com/images/logo-01.png)](http://www.geek-zoo.com)

They provide awesome design and development works continues to help the open-source community even better.

### Lastest version

* [Download the lastest release](https://github.com/gavinkwoe/BeeFramework/archive/master.zip)

		https://github.com/gavinkwoe/BeeFramework/archive/master.zip

* Clone the repo (CLI)

		git clone git@github.com:gavinkwoe/BeeFramework.git

* Clone the repo (HTTP)

		https://github.com/gavinkwoe/BeeFramework.git

* Import from CocoaPods (by [stcui](https://github.com/stcui))

	Add below to `Podfile` and run `pod install`

		platform :ios
		pod 'BeeFramework', :head

### Bug tracker

* Have a bug or a feature request? [Please open a new issue](https://github.com/gavinkwoe/BeeFramework/issues).
* Before opening any issue, please read the [Issue Guidelines](https://github.com/necolas/issue-guidelines), written by [Nicolas Gallagher](https://github.com/necolas/).

### Build and run

1. Open `/projects/BeeFramework.xcworkspace`
2. Choose target, 'lib' or 'example'
3. Build and run

### Documents

* [<< Developer manual >> 开发者手册](https://github.com/gavinkwoe/BeeFramework/blob/master/document)
* [<< Template manual >> 模版使用手册](https://github.com/gavinkwoe/BeeFramework/wiki/Bee-Templates-Manual)
* [<< CSS cheatsheet >> CSS说明书](https://github.com/gavinkwoe/BeeFramework/blob/master/document)

### Architecture

![Bee architecture](http://blog.whatsbug.com/wp-content/uploads/2013/08/architect2.png)

### Feature list

![Bee vs other](http://blog.whatsbug.com/wp-content/uploads/2013/07/bee_vs_other1.png)

### Tools

#### [Online interface builder >>](http://ib.bee-framework.com/)

![Interface builder](http://blog.whatsbug.com/wp-content/uploads/2013/07/beeibpreview.gif)

#### [API code generator >>](https://github.com/gavinkwoe/BeeFramework/blob/master/tools)

![Scaffold](http://blog.whatsbug.com/wp-content/uploads/2013/07/scaffold.png)

#### [Official SDK >>](http://bee-framework.com/download/BeeFramework_SDK_0.4.0.pkg.zip)

![SDK](http://blog.whatsbug.com/wp-content/uploads/2013/08/SDK.png)

### Change log

#### 0.4.0 (Lastest version)

1. Refactory the directory structure, divided into four parts, applicaton, service, system and vendor.
2. New XML template technology, perfect support for CSS
3. New QUERY technology, compatible with the jQUERY grammar
4. New automatic layout algorithm, easy to handle complex UI development task
5. New Service technology, plug-and-play
6. New mocking server technology, simulate network requests.
7. New ActiveObject technology, support any object serialization and deserialization
8. New In-app debugger, simplify the useless function
9. Code generator for JSON schema, no longer need to handwritten server docking code
10. Add BeeUISkeleton, an simple and powerful application entry
11. Add BeeRoutine, an BeeMessage which can asynchronous and by-self executing
12. Fix some BUG

#### 0.3.0

1. Fully support for MacOS
2. Fully support for UI template (xml)
3. Fully support for UI query syntax, like jQUERY
4. Fully support for template/viewController signal bridging by ID
5. Fix some bugs

#### 0.2.3

1. Refactoring the directory structure, Core and MVC completely separated, and the source files and the extensions completely separated
2. Refactoring the code structure of BeeDatabase and BeeActiveRecord, more clearly
3. Support the ActiveRecord inherition and nesting, support HAS/BELONG_TO operations
4. Support dot(.) opertions for BeeRequest and BeeMessage
5. Fix some bugs

#### 0.2.0

1. Add BeeDatabase
2. Add BeeActiveRecord
3. Overload graph
4. Fix some bugs
5. Move precompile options to 'Bee_Precompile.h'

#### 0.1.0

1. Draft version
2. Toturial
3. In-app debugger

## Contributors

**STCui** [https://github.com/stcui](https://github.com/stcui)

**ilikeido** [https://github.com/ilikeido](https://github.com/ilikeido)

**gelosie** [https://github.com/gelosie](https://github.com/gelosie)

**lancy** [https://github.com/lancy](https://github.com/lancy)

**uxyheaven** [https://github.com/uxyheaven](https://github.com/uxyheaven)

**Yulong** [https://github.com/Yulong](https://github.com/Yulong)

**esseak** [https://github.com/esseak](https://github.com/esseak)

**inonomori** [https://github.com/inonomori](https://github.com/inonomori)

## Copyright and license

Copyright 2013 ~ 2014, [Geek-Zoo Studio, Inc.](http://www.geek-zoo.com)

{Bee} is under MIT license.


	 ______    ______    ______
	/\  __ \  /\  ___\  /\  ___\
	\ \  __<  \ \  __\_ \ \  __\_
	 \ \_____\ \ \_____\ \ \_____\
	  \/_____/  \/_____/  \/_____/


	Copyright (c) 2013-2014, {Bee} open source community
	http://www.bee-framework.com


	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the "Software"),
	to deal in the Software without restriction, including without limitation
	the rights to use, copy, modify, merge, publish, distribute, sublicense,
	and/or sell copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
	IN THE SOFTWARE.

## Companies use {bee}

* [China Mobile](http://www.chinamobileltd.com/en/global/home.php)
* [China Unicom](http://www.chinaunicom.com.cn/)
* [China Telecom](http://www.chinatelecom.com.cn/)
* [Tencent](http://www.qq.com/)
* [Baidu](http://www.baidu.com/)
* [Sina](http://www.sina.com.cn/)
* [iFeng](http://www.ifeng.com/)
* [Novagin](http://www.novagin.com/cn/index.htm)
* [IGRS Lab](http://www.tivic.com/)
* [Front network](http://www.frontnetwork.com/)
* [Middling industries](http://www.middlingindustries.com/)
* [iLouShi](http://www.iloushi.cn/)
* [Duopeng](http://www.duopeng.com/)
* [VoiceFrom](http://voicefrom.me/)
* [Distance Education Group](http://www.sdeg.cn/sdegPortal/)
* [MesonTech](http://www.mesontech.com.cn/home/mesontech.jsp)

## Apps use {Bee}

* [Sina Finance](https://itunes.apple.com/us/app/xin-lang-cai-jing/id430165157?mt=8)
* [Mengtu](https://itunes.apple.com/us/app/meng-tu/id531292307?mt=8)
* [iLoushi](http://itunes.apple.com/cn/app/id464232572?mt=8)
* [Duopeng](http://www.duopeng.com/)
* [Yiban](https://itunes.apple.com/app/yi-ban/id549775029?mt=8)
* [Golden carp](https://itunes.apple.com/cn/app/id584687764)
* [Tivic](http://mobile.91.com/Soft/Detail.aspx?Platform=iPhone&f_id=1373668)
* [Middling](https://itunes.apple.com/us/app/middling/id531625104?mt=8)
* [iMyBags](https://itunes.apple.com/us/app/imybags/id672167473?ls=1&mt=8)

## More Incredible Projects from OpenSourceChina

You may want to see more great open source projects brought you by Chinese developers. See more in the [Projects repo](https://github.com/OpenSourceChina/Projects) of [OpenSourceChina](https://github.com/OpenSourceChina).

* Join us, please contact [gavinkwoe](https://github.com/gavinkwoe) or
 [onevcat](https://github.com/onevcat)
