//
//  QSDiskCache.h
//  QSWebImage
//
//  Created by apple on 2019/10/2.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSDiskCache : NSObject

/** 初步化 */
- (instancetype)init;

/** 初步化并指定最大可以占用内存大小 */
- (instancetype)initWithStorePath:(NSString * _Nullable)path maxStoreSize:(long long)size;

/**
 写入文件到磁盘里
 1.如果对应路径有此文件，则先删除，再创建文件，写入数据
 
 @param data 文件内容
 @param name 文件名称
 */
- (void)writeFile:(NSData *)data withName:(NSString *)name;

/**
 读取图片文件，通过key,
 
 @param name 是图片链接的MD5值
 */
- (NSData *)readFileWithName:(NSString *)name;

/**
 删除文件，通过文件名
 
 @param name 图片的文件名
 */
- (void)removeFileWithName:(NSString *)name;

/**
 获取所有文件大小
 
 @return 返回所有文件大小值
 */
- (long long)getDirectorySize;

@end

NS_ASSUME_NONNULL_END
