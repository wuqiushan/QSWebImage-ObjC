//
//  LruDictionary.h
//  QSWebImage
//
//  Created by apple on 2019/10/2.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LruDictionary : NSObject

- (id)get:(NSString *)key;
- (void)putKey:(NSString *)key value:(id)value;
- (void)removeTail;

@end

NS_ASSUME_NONNULL_END
