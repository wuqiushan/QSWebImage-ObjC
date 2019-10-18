//
//  QSLruNode.h
//  QSWebImage
//
//  Created by apple on 2019/10/2.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//  简要说明：Lru竟是一个字典，也是一个链表，所有节点会有键，值、上节点和下节点4个属性

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSLruNode : NSObject  

/** 字典的键 */
@property (nonatomic, copy) NSString *key;
/** 字典的值 */
@property (nonatomic, strong) id value;
/** 链表的上节点 */
@property (nonatomic, strong, nullable) QSLruNode *prev;
/** 链表的下节点 */
@property (nonatomic, strong, nullable) QSLruNode *next;


/**
 初始化创建一个节点，并指定键和值

 @param key 字典的键
 @param value 字典的值
 @return 返回创建的节点对象
 */
- (instancetype)initWithKey:(NSString *)key value:(id)value;

@end

NS_ASSUME_NONNULL_END
