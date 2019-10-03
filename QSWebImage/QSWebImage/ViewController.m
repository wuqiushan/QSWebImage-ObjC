//
//  ViewController.m
//  QSWebImage
//
//  Created by apple on 2019/10/2.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import "ViewController.h"
#import "LruDictionary.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self testLru];
//    [self testLru1];
//    [self testLru2];
//    [self testLru3];
}



#pragma mark - 测试 Lru 的正确性
- (void)testLru {
    
    LruDictionary *testDic = [[LruDictionary alloc] init];
    [testDic putKey:@"key1" value:@"value1"];
    [testDic putKey:@"key2" value:@"value2"];
    [testDic putKey:@"key3" value:@"value3"];
    id value2 = [testDic get:@"key2"];
    NSLog(@"%@", testDic.description);
    [testDic removeTail];
    NSLog(@"%@", testDic);
}

- (void)testLru1 {
    
    LruDictionary *testDic = [[LruDictionary alloc] init];
    [testDic putKey:@"key1" value:@"value1"];
    [testDic putKey:@"key1" value:@"value2"];
    id value2 = [testDic get:@"key2"];
    NSLog(@"%@", testDic.description);
    [testDic removeTail];
    NSLog(@"%@", testDic);
}

- (void)testLru2 {
    
    LruDictionary *testDic = [[LruDictionary alloc] init];
    [testDic putKey:@"key1" value:@"value1"];
    [testDic putKey:@"key2" value:@"value2"];
    id value2 = [testDic get:@"key1"];
    NSLog(@"%@", testDic.description);
    [testDic removeTail];
    NSLog(@"%@", testDic);
}

- (void)testLru3 {
    
    LruDictionary *testDic = [[LruDictionary alloc] init];
    [testDic putKey:@"key1" value:@"value1"];
    [testDic putKey:@"key2" value:@"value2"];
    id value2 = [testDic get:@"key2"];
    NSLog(@"%@", testDic.description);
    [testDic removeTail];
    NSLog(@"%@", testDic);
}


@end
