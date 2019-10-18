//
//  QSMemoryCache.h
//  QSWebImage
//
//  Created by apple on 2019/10/2.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSMemoryCache : NSObject

/** 初步化 */
- (instancetype)init;

/** 初步化并指定最大可以占用内存大小 */
- (instancetype)initWithMaxMemorySize:(long long)size;

/** 根据key获取值对象，访问后排在头节点 (已用内存大小 不变) */
- (nullable id<NSCoding>)getObjectWithKey:(NSString *)key;

/** 设置key和value 之前存在先删除，再增加，访问后排在头节点(已用内存大小 = 上次记录值 - 旧 + 新) */
- (void)setObject:(nullable id<NSCoding>)object withKey:(NSString *)key;

/** 根据key移除对应的节点 (已用内存大小 = 上次记录值 - 该节点) */
- (void)removeObjectWithKey:(NSString *)key;

/** 删除所有节点 (已用内存大小 = 0) */
- (void)removeAllObject;

@end

NS_ASSUME_NONNULL_END
