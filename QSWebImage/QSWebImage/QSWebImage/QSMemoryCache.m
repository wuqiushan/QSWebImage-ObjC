//
//  QSMemoryCache.m
//  QSWebImage
//
//  Created by apple on 2019/10/2.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import "QSMemoryCache.h"
#import "QSLru.h"

@interface QSMemoryCache()

/** 维护一个 lru  key:文件名，value:NSData */
@property (nonatomic, strong) QSLru *QSLru;
@property (nonatomic, assign) long long maxMemorySize;
@property (nonatomic, assign) long long useMemorySize;

@end

@implementation QSMemoryCache

#pragma mark - 初始化、文件操作
- (instancetype)init
{
    return [self initWithMaxMemorySize:0];
}

- (instancetype)initWithMaxMemorySize:(long long)size
{
    self.maxMemorySize = size;
    self.useMemorySize = 0;
    
    self = [super init];
    if (self) {
        if (self.maxMemorySize == 0) {
            self.maxMemorySize = 500 * 1024;
        }
    }
    return self;
}

- (void)writeFileWithName:(NSString *)name content:(NSData *)data {
    
    [self removeFileWithName:name];
    [self.QSLru putKey:name value:data];
    long long fileSize = data.length;
    self.useMemorySize += fileSize;
    
    while (self.useMemorySize > self.maxMemorySize) {
        NSString *tailKey = [self.QSLru getTailKey];
        [self removeFileWithName:tailKey];
    }
}

- (NSData *)readFileWithName:(NSString *)name {
    
    NSData *data = [self.QSLru get:name];
    return data;
}

- (void)removeFileWithName:(NSString *)name {
    
    NSData *data = [[self.QSLru getAllNode] objectForKey:name];
    long long fileSize = data.length;
    
    if (self.useMemorySize > fileSize) {
        self.useMemorySize -= fileSize;
    }
    else {
        self.useMemorySize = 0;
    }
    [self.QSLru removeWithKey:name];
}

#pragma mark - 懒加载
- (QSLru *)QSLru {
    if (!_QSLru) {
        _QSLru = [[QSLru alloc] init];
    }
    return _QSLru;
}

@end
