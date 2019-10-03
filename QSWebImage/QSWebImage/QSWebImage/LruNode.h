//
//  LruNode.h
//  QSWebImage
//
//  Created by apple on 2019/10/2.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LruNode : NSObject  

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) id value;
@property (nonatomic, strong, nullable) LruNode *prev;
@property (nonatomic, strong, nullable) LruNode *next;

- (instancetype)initWithKey:(NSString *)key value:(id)value;

@end

NS_ASSUME_NONNULL_END
