[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE) [![language](https://img.shields.io/badge/language-objective--c-green.svg)](1) 

### 概述
* [X] 采用LRU(最近最少使用)算法进行旧数据淘汰数
* [X] 自动管理缓存大小，内存最大为100M，磁盘为500M

### 使用方法
```Objective-C
- (void)objcButtonAction {
    [self.imageView QSImageUrl:@"https://github.com/wuqiushan/QSHttp-OC/raw/master/QSHttp-OC.png" defaultImage:nil];
}
```
![](https://github.com/wuqiushan/QSWebImage-ObjC/blob/master/QSWebImage.gif)

### 许可证
所有源代码均根据MIT许可证进行许可。

### 设计思路(有兴趣可以看)
#### 类说明
* QSLruNode：双向链表节点(同是也是一个字典，这样设计是为了解决链表查询速度慢的问题)  
* QSLru：实现了LRU算法(最近最少使用)，把最久未使用的节点淘汰掉(即链表尾节点)
    > 1. 查询节点，节点存在且不为头节点，就把节点先断点前后节点，再添加到头节点
    > 2. 新增或修改节点，通过key查询字典元素，有先删除节点，再添加到头节点
    > 3. 删除节点，通过key查询字典元素，删除节点
* QSDownloadImage：图片网络下载类
* QSMemoryCache：实现内存缓存逻辑，使用了QSLru实例实现(与磁盘的QSLru实例是分离的，因为各自己最大允许缓存大小是有限制的)，
* QSDiskCache：实现磁盘缓存逻辑，使用了QSLru实例实现
* QSWebImageManage：图片缓存管理类
* UIImageView+QSWebImage：UIImageView分类，方便调用
#### 流程图
![image](https://github.com/wuqiushan/QSCache-ObjC/blob/master/图片缓存时序图.jpg)
![image](https://github.com/wuqiushan/QSCache-ObjC/blob/master/链表图.jpg)

#### 思路
加载步骤：首先加载默认(背景)图片，然后通过url去内存里拿，如果没有就从磁盘里拿，如果没有就开启请求，请求完后，展示出来图片，然后再把图片存在内存和磁盘中。
> 1. 初始化，内存的LRU创建为空，磁盘LRU通过读取上一次QSLru.plist文件转换
> 2. 获取图片，加载默认图片，把图片Url链接转化为MD5，从内存取，有则获取，无则从磁盘取，有则读取显示并缓存到内存，无则从网络上去下载显示缓存到内存和磁盘
> 3. 退出，保存磁盘LRU配置，转换成QSLru.plist文件存储