# iOS-MVVM-Template

本项目是参考 [kickstarter/ios-oss](https://github.com/kickstarter/ios-oss) 编写的一个 iOS 模板项目，目的是为了快速创建新的项目。这里感谢 Kickstarter 的开源，让我们学习到了如此优秀的 iOS 项目结构。

本项目是根据我自己的项目需求、对 Kickstarter 源码中一些不必要的功能进行精简，并且在一个实际项目中应用后整理出的一个模板。如果想要详细了解 Kickstarter 的源码，请自己去仔细阅读。本人之前在阅读 Kickstarter 项目源码时，也整理了一份笔记，有需要的同学也可以去看下。[Kickstarter-iOS 源码分析 - 文集 - 简书](https://www.jianshu.com/nb/36807985)

## 目录结构

```
iOS-MVVM-Template
├── Api : 存放网络请求相关的文件
│   ├── Models
│   │   ├── AccessToken.swift : AccessToken 模型
│   │   ├── ErrorCode.swift：错误代码
│   │   ├── ErrorEnvelope.swift : 后台返回的 Error 数据模型
│   │   ├── Templates : 存放数据模型的模板
│   │   └── VoidEnvelope.swift : 后台返回空 json `{}` 数据时的数据模型
│   ├── Extensions
│   │   └── URLSession+RequestHelpers.swift : 使用 ReactiveSwift 对 URLSession 的扩展方法
│   ├── Lib
│   │   ├── RequestMethod.swift : 请求方法
│   │   └── Route.swift : 所有的网络请求
│   ├── EnvironmentType.swift : 应用环境类型
│   ├── MockService.swift : 模拟的 Service
│   ├── ServerConfig.swift : 服务器配置的数据模型
│   ├── Service+RequestHelpers.swift : 对 Service 的扩展，发送网络请求和解析数据的方法
│   ├── Service.swift : Service 类型，负责整个应用的网络请求
│   └── ServiceType.swift : ServiceType 协议，Service 和 MockService 都遵循这个协议
├── Configs
│   ├── Global.swift : 存放全局的常量
│   └── Secrets.swift : 存放应用的一些配置
├── DataModels : 存放数据模型
│   ├── Templates : 存放数据模型的模板
│   └── User.swift : User 数据模型
├── DataSources : 存放 DataSource
│   └── Base
│       ├── ValueCell.swift : ValueCell 协议。想要使用 ValueCellDataSource 作为 UITableView 和 UICollectionView 的数据源，他们对应的 Cell 都需要实现这个协议
│       └── ValueCellDataSource.swift : 实现了 UITableViewDataSource 和 UICollectionViewDataSource，只整理了一些常用的数据处理的方法，有其他需求的可以继续往这里添加
├── Library : 存放在整个应用中比较通用的类型
│   ├── Extensions : 存放对类型的扩展
│   ├── App.swift : App 的相关信息
│   ├── AppEnvironment.swift : 管理应用环境
│   ├── Environment.swift : 应用环境的数据模型
│   ├── Keyboard.swift : 使用 ReactiveSwift 对键盘的弹出和隐藏进行处理
│   ├── Nib.swift : 方便初始化使用 xib 自定义的 View
│   ├── Notifications.swift : 管理应用中用到的通知类型
│   ├── PushRegistration.swift : 使用 ReactiveSwift 对 Push 通知的注册进行处理，实现了 PushRegistrationType 协议
│   ├── PushRegistrationType.swift : PushRegistrationType 协议
│   └── Storyboard.swift : 方便初始化使用 Storyboard 自定义的 ViewController
├── Resources : 存放应用中用到的字体、图标等文件
├── ViewModels : 存放 View Model
└── Views&Controllers : 存放 View 和 Controller
```

## 使用到的第三方库

- [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift)
- [ReactiveExtensions](https://github.com/Lebron1992/Kickstarter-ReactiveExtensions)
- [PKHUD](https://github.com/pkluz/PKHUD)
- [JWT](https://github.com/yourkarma/JWT)

## License

```
MIT License

Copyright (c) 2019 Lebron

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
