![Bee logo](http://www.0xbee.com/images/banner2.png)

BeeFramework is a semi-hybrid framework that allows you to create mobile apps using Objective-C and XML/CSS for the iPhone and iPad and more, created and maintained by [Gavin.Kwoe](http://www.weibo.com/gavinkwoe) and [QFish](http://weibo.com/u/2987815507).

## How to install

1. Download the source code
2. Drag and drop `/framework` folder into your project
3. Drag and drop `/services` folder into your project
4. Build and run

## Demo app

![1](http://blog.whatsbug.com/wp-content/uploads/2014/01/bee_template_code.png)
![2](http://blog.whatsbug.com/wp-content/uploads/2014/01/bee_ui_1.png)
![3](http://blog.whatsbug.com/wp-content/uploads/2014/01/bee_service_3d_inspector.png)

## Features

- CLI
- MVC
	- View
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

[![Geek-Zoo](http://geek-zoo.com/images/logo-01.png)](http://www.geek-zoo.com)

Copyright (c) 2014-2015, [Geek Zoo Studio](http://www.geek-zoo.com)

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
2. Toturial
3. In-app debugger

## Contributors

Name|Type
-|-
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

* Join us, please contact [gavinkwoe](https://github.com/gavinkwoe) or
 [onevcat](https://github.com/onevcat)

