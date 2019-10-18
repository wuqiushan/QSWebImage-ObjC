//
//  QSLru.h
//  QSWebImage
//
//  Created by apple on 2019/10/2.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSLru : NSObject


/**
 获取Lru的对应节点的值，（影响链表排序）
 1.该节点存在，且不为头部节点时 先移除链表关联，移到头部重组关联 再返回其值
 2.该节点不存在，直接返回
 
 @param key 指定获取值的键
 @return 返回该节点的值
 */
- (id)get:(NSString *)key;

/**
 往Lru增加节点，通过键和值（影响链表排序）
 1.如果元素key之前存在的话，去掉链表关联，从字典移除元素
 2.第1步完后，创建节点，把节点放在链表头部
 
 @param key 节点的键
 @param value 节点的值
 */
- (void)putKey:(NSString *)key value:(id)value;

/**
 删除指定的节点（影响链表排序）
 
 @param key 节点的键
 */
- (void)removeWithKey:(NSString *)key;

/**
 删除最旧的数据，即最长时间未使用的那个节点
 */
- (void)removeTail;


- (NSString *)getHeadKey; /** 获取头节点的键 （不影响链表排序）*/
- (id)getHeadValue;       /** 获取头节点的值 （不影响链表排序）*/

- (NSString *)getTailKey; /** 获取尾节点的键 （不影响链表排序）*/
- (id)getTailValue;       /** 获取尾节点的值 （不影响链表排序）*/

- (NSDictionary *)getAllNode;
//- (NSMutableDictionary *)getDic;

@end

NS_ASSUME_NONNULL_END
