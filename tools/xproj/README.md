xproj
=====

## What's this

__xproj__ 是一个shell脚本，可以给工程批量添加 `-fno-objc-arc` 和 `-fobjc-arc` 编译参数。

如果你的项目是 `非arc` ，但是用到了 `arc` 的第三方，或者反之，这时候你有两种选择，`cocopods` 或者手动添加。

1. 使用 `cocopods` 当然是推荐方案，但是出于一些原因，你可能不用它。
2. 这时候你只能手动添加，当然在Xcode里可以多选（ `CMD` or `SHIFT` ），然后双击其中一个文件，接着在弹出的输入框里添加。

**但是**如果文件**巨多**，在 `Build Phases -> Compile Sources` 里既有项目原来的文件，又有你刚刚拉进去的文件，考验你耐心的时候到了~ 肿么办?

算了，还是让这个脚本帮你做点什么吧~

### 准备

第一步需要把用到的文件加到项目里，保证 `Build Phases -> Compile Sources` 里能看到它们

### 加 `-fno-objc-arc`

```sh
$ sh xproj -s 需要添加编译参数的文件所在的文件夹 -t 目标工程文件

# sh xproj -s ./framework -t test.xcodeproj

```
![xproj-narc](https://f.cloud.github.com/assets/679824/2280662/742d4a00-9f8f-11e3-947e-dc97ad8d976f.gif)

### 加 `-fobjc-arc`
  
```sh
$ sh xproj -n -s 需要添加编译参数的文件所在的文件夹 -t 目标工程文件

# sh xproj -n -s ./ZXingObjC -t test.xcodeproj

```

![xproj-arc](https://f.cloud.github.com/assets/679824/2280651/441355bc-9f8f-11e3-8474-2387867cbe1f.gif)

## 提示

这个脚本是直接修改你的工程文件，所以会有风险，修改前建议先备份一份。不过考虑到这点，脚本在做任何操作之前会先自动备份一份你的工程文件，该文件以.bak结尾，执行完没有问题之后你可以把它删了，当然也可以留作纪念~

## HELP
```
NAME
  xproj - batch adding compile flags like `-fno-objc-arc`or `-fobjc-arc`

SYNOPSIS
  xproj -s dir [-t xcodeproj] [-n]

DESCRIPTION
  A shell script can batch adding compile flags like `-fno-objc-arc` 
      or `-fobjc-arc` for all the files under the same dir by processing 
      the project file.

OPTIONS
      -n               | Used to specify the compile flag to be 
                       | `-fobjc-arc`. Default is `-fno-objc-arc`.
      -----------------------------------------------------------------
      -e               | Used to disable from modifying some extented
                       | `build settings`: 
                       | 1. Direct usage of 'isa' to 'NO'
                       | 2. Enable Module(C and Objective-C) to 'NO'
      -----------------------------------------------------------------
      -s dir           | Specify the dir contains source files
      -----------------------------------------------------------------
      -t xcodeproj     | Specify the target xcodeproj file, dafault is 
                       | the first of *.xcodeproj under the same dir.
      -----------------------------------------------------------------

AUTHOR
  Written by QFish <qfish.cn@gmail.com>

COPYRIGHT
  MIT
```
