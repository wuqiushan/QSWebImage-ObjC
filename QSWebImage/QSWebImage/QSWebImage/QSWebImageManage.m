//
//  QSWebImageManage.m
//  QSWebImage
//
//  Created by apple on 2019/10/4.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import "QSWebImageManage.h"
#import <CommonCrypto/CommonDigest.h>
#import "QSMemoryCache.h"
#import "QSDiskCache.h"
#import "QSDownloadImage.h"

@interface QSWebImageManage()

@property (nonatomic, strong) QSMemoryCache *memoryCache;
@property (nonatomic, strong) QSDiskCache   *dishCache;
@property (nonatomic, strong) QSDownloadImage *downloadImage;

@end

@implementation QSWebImageManage


// 单例
+ (instancetype)sharedInstance {
    
    static QSWebImageManage *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[QSWebImageManage alloc] init];
        shared.memoryCache = [[QSMemoryCache alloc] init];
        shared.dishCache   = [[QSDiskCache alloc] init];
        shared.downloadImage = [[QSDownloadImage alloc] init];
    });
    return shared;
}

/**
 获取图片数据
 1.把UrlStr 转化成MD5
 2.从内存取，有则显示，无则下一步
 3.从磁盘取，有则显示，无则下一步
 3.从网络上去下载，完成显示，下一步
 4.存储到磁盘，存储到内存
 */
- (void)imageDataWithUrl:(NSString *)url setImageView:(UIImageView *)imgeView {
    
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"1001 - %@", [NSThread currentThread]);
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSString *md5Key = [strongSelf md5_32bit:url];
        __block NSData *resultData = nil;
        resultData = [strongSelf.memoryCache readFileWithName:md5Key];
        if (resultData) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                imgeView.image = [UIImage imageWithData:resultData];
            });
            return ;
        }
        resultData = [strongSelf.dishCache readFileWithName:md5Key];
        if (resultData) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                imgeView.image = [UIImage imageWithData:resultData];
            });
            [strongSelf.memoryCache writeFileWithName:md5Key content:resultData];
            return ;
        }
        
        [strongSelf.downloadImage GET:url param:nil success:^(id _Nonnull rspObject) {
            
            if ([rspObject isKindOfClass:[NSData class]]) {
                
                resultData = (NSData *)rspObject;
                //NSLog(@"%ld %@", resultData.length, resultData);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgeView.image = [UIImage imageWithData:resultData];
                });
                
                [strongSelf.dishCache writeFileWithName:md5Key content:resultData];
                [strongSelf.memoryCache writeFileWithName:md5Key content:resultData];
            }
            
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"请求失败 %@", error);
        }];
    }];
    
    // 最大并发线程数为20，把任务添加到队列后，不占用主队列
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.maxConcurrentOperationCount = 20;
    [operationQueue addOperation:blockOperation];
}



#pragma mark MD5方法
- (NSString *)md5_32bit:(NSString *)input {
    //传入参数,转化成char
    const char * str = [input UTF8String];
    //开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    /*
     extern unsigned char * CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把str字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了md这个空间中
     */
    CC_MD5(str, (int)strlen(str), md);
    //创建一个可变字符串收集结果
    NSMutableString * ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        /**
         X 表示以十六进制形式输入/输出
         02 表示不足两位，前面补0输出；出过两位不影响
         printf("%02X", 0x123); //打印出：123
         printf("%02X", 0x1); //打印出：01
         */
        [ret appendFormat:@"%02X",md[i]];
    }
    //返回一个长度为32的字符串
    return ret;
}

@end
