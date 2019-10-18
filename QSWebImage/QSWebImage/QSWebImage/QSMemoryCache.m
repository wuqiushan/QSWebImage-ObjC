//
//  QSMemoryCache.m
//  QSWebImage
//
//  Created by apple on 2019/10/2.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import "QSMemoryCache.h"
#import "QSLru.h"
#import "QSLruNode.h"

@interface QSMemoryCache()

/** 维护一个 lru  key:键，value:id */
@property (nonatomic, strong) QSLru *QSLru;

/** 最大能够内存大小 */
@property (nonatomic, assign) long long maxMemorySize;

/** 已使内存大小 */
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

- (void)setObject:(nullable id<NSCoding>)object withKey:(NSString *)key {
    
    long long fileSize = [self getLengthWithObject:object];
    [self removeObjectWithKey:key];
    [self.QSLru putKey:key value:object];
    self.useMemorySize += fileSize;
    
    while (self.useMemorySize > self.maxMemorySize) {
        NSString *tailKey = [self.QSLru getTailKey];
        [self removeObjectWithKey:tailKey];
    }
}

- (nullable id)getObjectWithKey:(NSString *)key {
    
    return [self.QSLru get:key];
}

- (void)removeObjectWithKey:(NSString *)key {
    
    QSLruNode *node = [[self.QSLru getAllNode] objectForKey:key];
    if (node == nil) { return ; }
    long long fileSize = [self getLengthWithObject:node.value];
    
    if (self.useMemorySize > fileSize) {
        self.useMemorySize -= fileSize;
    }
    else {
        self.useMemorySize = 0;
    }
    [self.QSLru removeWithKey:key];
}

- (void)removeAllObject {
    
    self.QSLru = nil;
    self.useMemorySize = 0;
}

#pragma mark 获取对象占用内存
- (NSUInteger)getLengthWithObject:(nullable id<NSCoding>)object {
    
    NSUInteger dataLength = 0;
    if (object == nil) {
        return dataLength = 0;
    }
    
    NSObject *dataObject = (NSObject *)object;
    if ([dataObject isKindOfClass:[NSData class]]) {
        dataLength = ((NSData *)dataObject).length;
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        dataLength = [NSKeyedArchiver archivedDataWithRootObject:object].length;
#pragma clang diagnostic pop
    }
    return dataLength;
}

#pragma mark - 懒加载
- (QSLru *)QSLru {
    if (!_QSLru) {
        _QSLru = [[QSLru alloc] init];
    }
    return _QSLru;
}

@end
