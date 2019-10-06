//
//  QSMemoryCache.m
//  QSWebImage
//
//  Created by apple on 2019/10/2.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import "QSMemoryCache.h"
#import "LruCache.h"

@interface QSMemoryCache()

/** 维护一个 lru  key:文件名，value:NSData */
@property (nonatomic, strong) LruCache *lruCache;
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
    [self.lruCache putKey:name value:data];
    long long fileSize = data.length;
    self.useMemorySize += fileSize;
    
    while (self.useMemorySize > self.maxMemorySize) {
        NSString *tailKey = [self.lruCache getTailKey];
        [self removeFileWithName:tailKey];
    }
}

- (NSData *)readFileWithName:(NSString *)name {
    
    NSData *data = [self.lruCache get:name];
    return data;
}

- (void)removeFileWithName:(NSString *)name {
    
    NSData *data = [self.lruCache.dic objectForKey:name];
    long long fileSize = data.length;
    
    if (self.useMemorySize > fileSize) {
        self.useMemorySize -= fileSize;
    }
    else {
        self.useMemorySize = 0;
    }
    [self.lruCache removeWithKey:name];
}

#pragma mark - 懒加载
- (LruCache *)lruCache {
    if (!_lruCache) {
        _lruCache = [[LruCache alloc] init];
    }
    return _lruCache;
}

@end
