//
//  ViewController.m
//  QSWebImage
//
//  Created by apple on 2019/10/2.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import "ViewController.h"
#import "LruCache.h"
#import "UIImageView+QSWebImage.h"


@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(10, 250, 350, 150);
    self.imageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.imageView];
    
    
    UIButton *javaButton = [self createButtonWithName:@"java" x:10 y:100];
    [javaButton addTarget:self action:@selector(javaButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:javaButton];
    
    UIButton *objcButton = [self createButtonWithName:@"objc" x:10 y:150];
    [objcButton addTarget:self action:@selector(objcButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:objcButton];
    
    UIButton *serverButton = [self createButtonWithName:@"server" x:10 y:200];
    [serverButton addTarget:self action:@selector(serverButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:serverButton];
    
    
//    [self testLru];
//    [self testLru1];
//    [self testLru2];
//    [self testLru3];
}

- (void)javaButtonAction {
    [self.imageView QSImageUrl:@"https://github.com/wuqiushan/QSHttp-Java/raw/master/QSHttp-Java.png" defaultImage:nil];
}
- (void)objcButtonAction {
    [self.imageView QSImageUrl:@"https://github.com/wuqiushan/QSHttp-OC/raw/master/QSHttp-OC.png" defaultImage:nil];
}
- (void)serverButtonAction {
    [self.imageView QSImageUrl:@"https://github.com/wuqiushan/QSHttp-Server/raw/master/QSHttp-Server.png" defaultImage:nil];
}

#pragma mark - 测试 Lru 的正确性
- (void)testLru {
    
    LruCache *testDic = [[LruCache alloc] init];
    [testDic putKey:@"key1" value:@"value1"];
    [testDic putKey:@"key2" value:@"value2"];
    [testDic putKey:@"key3" value:@"value3"];
    id value2 = [testDic get:@"key2"];
    NSLog(@"%@", testDic.description);
    [testDic removeTail];
    NSLog(@"%@", testDic);
}

- (void)testLru1 {
    
    LruCache *testDic = [[LruCache alloc] init];
    [testDic putKey:@"key1" value:@"value1"];
    [testDic putKey:@"key1" value:@"value2"];
    id value2 = [testDic get:@"key2"];
    NSLog(@"%@", testDic.description);
    [testDic removeTail];
    NSLog(@"%@", testDic);
}

- (void)testLru2 {
    
    LruCache *testDic = [[LruCache alloc] init];
    [testDic putKey:@"key1" value:@"value1"];
    [testDic putKey:@"key2" value:@"value2"];
    id value2 = [testDic get:@"key1"];
    NSLog(@"%@", testDic.description);
    [testDic removeTail];
    NSLog(@"%@", testDic);
}

- (void)testLru3 {
    
    LruCache *testDic = [[LruCache alloc] init];
    [testDic putKey:@"key1" value:@"value1"];
    [testDic putKey:@"key2" value:@"value2"];
    id value2 = [testDic get:@"key2"];
    NSLog(@"%@", testDic.description);
    [testDic removeTail];
    NSLog(@"%@", testDic);
}

// 创建一个Button按钮
- (UIButton *)createButtonWithName:(NSString *)name x:(CGFloat)x y:(CGFloat)y {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, y, 100, 40);
    button.contentMode = UIViewContentModeCenter;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setTitle:name forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 3.0f;
    button.backgroundColor = [UIColor blackColor];
    return button;
}

@end
