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

- (instancetype)init;
- (instancetype)initWithStorePath:(NSString *)path maxStoreSize:(long long)size;
- (void)writeFileWithName:(NSString *)name content:(NSData *)data;
- (NSData *)readFileWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
