//
//  QSDiskCache.m
//  QSWebImage
//
//  Created by apple on 2019/10/2.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import "QSDiskCache.h"
#import "LruDictionary.h"

/*
 存储数据到硬盘, 操作io口
 删除指定的路径下的文件夹
 计算路径下的总大小
 计算单个文件的总大小
 读取当前硬盘大小，一般是程序启动时读一下
 */

@interface QSDiskCache()

/** 维护一个 lru */
@property (nonatomic, strong) LruDictionary *lruDic;
@property (nonatomic, assign) long storeSize;
@property (nonatomic, strong) NSString *storePath;
@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation QSDiskCache


#pragma mark - 初始化
- (instancetype)init
{
    return [self initWithStorePath:nil storeSize:0];
}

- (instancetype)initWithStorePath:(NSString *)path storeSize:(long)size
{
    self.storePath = path;
    self.storeSize = size;
    
    self = [super init];
    if (self) {
        
        if (self.storeSize == 0) {
            self.storeSize = 500 * 1024;
        }
        if (self.storePath == nil) {
            // 默认路径： ../caches/QSWebImage
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            self.storePath = [cachesPath stringByAppendingPathComponent:@"QSWebImage"];
        }
        
        // 创建对应的路径
        if (![self.fileManager fileExistsAtPath:self.storePath]) {
            
            NSError *error;
            [self.fileManager createDirectoryAtPath:self.storePath
                        withIntermediateDirectories:YES
                                         attributes:nil
                                              error:&error];
            if (error) {
                self.storePath = nil;
                NSAssert(self.storePath != nil, @"QSDiskCache路径创建失败");
            }
        }
    }
    return self;
}


/**
 写入文件到磁盘里
 1.如果对应路径有此文件，则先删除，再创建文件，写入数据

 @param name 文件名称
 @param data 文件内容
 */
- (void)writeFileWithName:(NSString *)name content:(NSData *)data {
    
    NSString *filePath = [self.storePath stringByAppendingPathComponent:name];
    if ([self.fileManager fileExistsAtPath:filePath]) {
        // 删除文件
    }
    BOOL isSuccess = [self.fileManager createFileAtPath:filePath contents:data attributes:nil];
    NSAssert(isSuccess == true, @"写入文件失败");
}

/**
 读取图片文件，通过key,

 @param name 是图片链接的MD5值
 */
- (void)readFileWithName:(NSString *)name {
    
}

#pragma mark - 懒加载
- (NSFileManager *)fileManager {
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

@end
