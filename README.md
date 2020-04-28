[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE) [![language](https://img.shields.io/badge/language-objective--c-green.svg)](1) 

### 概述
本仓库为图片缓存框架，采用LRU算法进行旧数据淘汰数。加载步骤：首先加载默认(背景)图片，然后通过url去内存里拿，如果没有就从磁盘里拿，如果没有就开启请求，请求完后，展示出来图片，然后再把图片存在内存和磁盘中。

### 使用方法
```Objective-C
- (void)objcButtonAction {
    [self.imageView QSImageUrl:@"https://github.com/wuqiushan/QSHttp-OC/raw/master/QSHttp-OC.png" defaultImage:nil];
}
```
![](https://github.com/wuqiushan/QSWebImage-ObjC/blob/master/QSWebImage.gif)

### 许可证
所有源代码均根据MIT许可证进行许可。