![logo](https://cloud.githubusercontent.com/assets/679824/3976127/d495a6a4-2819-11e4-81cf-b27832e27e90.png)

BeeFramework is a semi-hybrid framework that allows you to create mobile apps using Objective-C and XML/CSS for the iPhone and iPad and more, created and maintained by [Gavin.Kwoe](http://www.weibo.com/gavinkwoe) and [QFish](http://github.com/qfish).

## Join us

QQ Group: 314365063

## 0.6.0 New Feature - Liveload

### Have a better life with liveload

1. Edit the <b style="color:red">XML</b> file with any editor (Xcode, Sublime Text, even TextEdit etc.).
2. After editing, just save the file by shortcut (`Command+S`) or clicking the menu item `Save`.
3. Then the corresponding view in smulator will update according to the changes without rebuilding app.
4. You can get More info from `/serivces/bee.service.liveload/`.

### Here is a video about the new feature
 
📺 &nbsp;BeeFramework 0.6.0 New Feature - Liveload &nbsp; <a href="http://youtu.be/zs85Bo82Mww" target="_blank">[YouTube]</a> &nbsp; <a href="http://v.youku.com/v_show/id_XNzU3NzAyOTQ4.html">[Youku]</a>
 
 <a href="http://youtu.be/zs85Bo82Mww" target="_blank">![liveload-snopshot](https://cloud.githubusercontent.com/assets/679824/3977216/bc197f36-2834-11e4-95ff-838a39556c08.png)</a>

## How to install

1. Download the source code
2. Drag and drop `/framework` folder into your project
3. Drag and drop `/services` folder into your project
4. Build and run

## Demo app

A demo app for dribbble.com, as fast as native, as flexible as web. See `/projects/dribbble` demo for more information.

![dribbble-1](https://cloud.githubusercontent.com/assets/679824/3976218/fe45e93a-281b-11e4-9cae-50fc2266b2a0.png)
![dribbble-2](https://cloud.githubusercontent.com/assets/679824/3976221/08565f9a-281c-11e4-88ea-23724a2008cf.png)

## Demo app - Wireframe mode

![dribbble-3](https://cloud.githubusercontent.com/assets/679824/3976224/18fce0bc-281c-11e4-865c-3cedac069fbf.png)

## Demo app - Inspector mode

![dribbble-4](https://cloud.githubusercontent.com/assets/679824/3976226/26716650-281c-11e4-99f0-c8d12e9b9624.png)

## Semi-Hybrid UI

Semi-hybrid offers you a new approach to UI development using XML/CSS, you can reuse these templates in any project based on BeeFramework. See `/projects/dribbble` demo for more information.

![bee_template](https://cloud.githubusercontent.com/assets/679824/3976231/32682b56-281c-11e4-8824-9ae7aaa0d21f.png)

## Services

Services extend and expand the functionality of your app automatically, drag and drop the services folder into your project. See `/services` for more information.

![bee_services](https://cloud.githubusercontent.com/assets/679824/3976233/32dbf874-281c-11e4-8baf-271edac46312.png)

For example:

<pre>
bee.services.alipay.config.parnter = @"";
bee.services.alipay.config.seller = @"";
bee.services.alipay.config.privateKey = @"";
bee.services.alipay.config.publicKey = @"";
bee.services.alipay.config.notifyURL = @"http://";

bee.services.alipay.order.no = @"SN";
bee.services.alipay.order.name = @"NAME";
bee.services.alipay.order.desc = @"DESC";
bee.services.alipay.order.price = @"PRICE";

bee.services.alipay.whenSucceed = ^
{
};

bee.services.alipay.PAY();	// or .ON();
</pre>

## Scaffold

Scaffold helps you to generate Model/Controller code and documents, also provide the local test environment. See `/tools/scaffold` or `/projects/scaffold` for more information.

![bee_scaffold_1](https://cloud.githubusercontent.com/assets/679824/3976230/32287a1a-281c-11e4-9999-968fb3c9c93e.png)
![bee_scaffold_2](https://cloud.githubusercontent.com/assets/679824/3976232/326d4e88-281c-11e4-837c-bb8756aec6ca.png)

For example:

<pre>
> ./scaffold schema build ./example/dribbble.json
> ./scaffold schema test ./example/dribbble.json
</pre>

## Features

- CLI
- MVC
	- View
		- Liveload
		- Application
		- Config
		- Container
			- Board
			- Stack
			- Router
			- Window
		- CSS style sheet
		- XML template
		- DOM
			- Animation/Transition
			- Data binding
			- Capability
			- Elements
			- Elements ext
			- Signaling
			- Auto layout
			- Query (jQuery-like syntax)
		- View-Model
			- Once
			- Paging
			- Stream
		- Other
			- Color
			- Font
			- Image
			- Metrics
	- Model
	- Controller
		- Message
		- MessageController
		- Queue
		- Routine
		- Extensions
			- Message + JSON
			- Message + HTTP
			- Message + XML
			- Message + ActiveRecord
- System
	- Cache
		- File
		- Memory
		- Keychain
		- UserDefaults
	- Database
		- SQLite wrapper
		- ActiveRecord
		- Driver
	- Foundation
		- Assertion
		- Log
		- Performance
		- Runtime
		- Sandbox
		- Singleton
		- System information
		- Thread
		- Ticker
		- UnitTest
	- Localization
	- Network
		- HTTP client
		- HTTP server
		- Reachability
		- Socket
	- Resource
	- Service

## Lastest version

* [Download the lastest release](https://github.com/gavinkwoe/BeeFramework/archive/master.zip)

		https://github.com/gavinkwoe/BeeFramework/archive/master.zip

* Clone the repo (CLI)

		git clone git@github.com:gavinkwoe/BeeFramework.git

* Clone the repo (HTTP)

		https://github.com/gavinkwoe/BeeFramework.git

* Import from CocoaPods ( thanks to [stcui](https://github.com/stcui) )

	Add below to `Podfile` and run `pod install`

		platform :ios
		pod 'BeeFramework', :head

## Bug tracker

* Have a bug or a feature request? [Please open a new issue](https://github.com/gavinkwoe/BeeFramework/issues).
* Before opening any issue, please read the [Issue Guidelines](https://github.com/necolas/issue-guidelines), written by [Nicolas Gallagher](https://github.com/necolas/).


## License

![geek-zoo](https://cloud.githubusercontent.com/assets/679824/3976260/f51498ba-281c-11e4-9569-6b60cfb1d90a.png)

	 ______    ______    ______
	/\  __ \  /\  ___\  /\  ___\
	\ \  __<  \ \  __\_ \ \  __\_
	 \ \_____\ \ \_____\ \ \_____\
	  \/_____/  \/_____/  \/_____/


	Copyright (c) 2014-2015, Geek Zoo Studio
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

## Change log

#### 0.6.0

1. Liveload

#### 0.5.0

1. New MVVM architecture
2. New Package technology
3. New Signal routing technology
4. New HTTP server technology
5. New CSS parser, support more CSS syntax
6. New ScrollView, support complex layout
7. More jQuery-like syntax
8. Refactory directory structure
9. Refactory animation system
10. Support multi-language
11. Support manifest.json
12. New 3D UI inspector plugin
13. New grid system plugin
14. New alipay plugin
15. New location plugin
16. New push notification plugin
17. New social share plugin
18. New splash plugin
19. Bug fix

#### 0.4.0

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
2. Tutorial
3. In-app debugger

## Contributors

Name|Type
----|----
**Gavin.Kwoe**|[https://github.com/gavinkwoe](https://github.com/gavinkwoe)
**QFish**|[https://github.com/qfish](https://github.com/qfish)
**STCui**|[https://github.com/stcui](https://github.com/stcui)
**ilikeido**|[https://github.com/ilikeido](https://github.com/ilikeido)
**gelosie**|[https://github.com/gelosie](https://github.com/gelosie)
**lancy**|[https://github.com/lancy](https://github.com/lancy)
**uxyheaven**|[https://github.com/uxyheaven](https://github.com/uxyheaven)
**Yulong**|[https://github.com/Yulong](https://github.com/Yulong)
**esseak**|[https://github.com/esseak](https://github.com/esseak)
**inonomori**|[https://github.com/inonomori](https://github.com/inonomori)

## More Incredible Projects from OpenSourceChina

You may want to see more great open source projects brought you by Chinese developers. See more in the [Projects repo](https://github.com/OpenSourceChina/Projects) of [OpenSourceChina](https://github.com/OpenSourceChina).

Join us, please contact [gavinkwoe](https://github.com/gavinkwoe) or [onevcat](https://github.com/onevcat).
