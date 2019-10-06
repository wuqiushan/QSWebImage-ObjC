//
//  LruCache.h
//  QSWebImage
//
//  Created by apple on 2019/10/2.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LruCache : NSObject

- (id)get:(NSString *)key;
- (void)putKey:(NSString *)key value:(id)value;
- (void)removeWithKey:(NSString *)key;
- (void)removeTail;

- (NSString *)getHeadKey;
- (id)getHeadValue;
- (NSString *)getTailKey;
- (id)getTailValue;

- (NSMutableDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
