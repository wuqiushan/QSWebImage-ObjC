//
//  QSLruNode.m
//  QSWebImage
//
//  Created by apple on 2019/10/2.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import "QSLruNode.h"

@implementation QSLruNode

- (instancetype)initWithKey:(NSString *)key value:(id)value {
    
    self = [super init];
    if (self) {
        self.key = key;
        self.value = value;
    }
    return self;
}

@end
