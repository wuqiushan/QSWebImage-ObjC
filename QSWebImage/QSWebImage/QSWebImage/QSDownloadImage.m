//
//  QSDownloadImage.m
//  QSWebImage
//
//  Created by apple on 2019/10/4.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import "QSDownloadImage.h"

@implementation QSDownloadImage

/**
 GET方法去请求
 
 @param urlStr 请求Url
 @param param 请求参数
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)GET:(NSString *)urlStr param:(NSDictionary *)param success:(BlockRsp)success failure:(BlockErr)failure {
    [self method:@"GET" url:urlStr param:param success:success failure:failure];
}

/**
 通用方法去请求
 
 @param method 请求方式
 @param urlStr 请求Url
 @param param 请求参数
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)method:(NSString *)method url:(NSString *)urlStr param:(NSDictionary *)param success:(BlockRsp)success failure:(BlockErr)failure {
    
    // URL编码
    NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.timeoutInterval = 30;
    request.HTTPMethod = method;
    
    // 设备请求参数
    if (param) {
        NSError *paramError = nil;
        NSData *paramData = [NSJSONSerialization dataWithJSONObject:param
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:&paramError];
        if (paramError == nil) {
            request.HTTPBody = paramData;
        }
        else {
            NSDictionary *errorDic = @{NSLocalizedDescriptionKey: @"请求参数格式错误"};
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:100 userInfo:errorDic];
            failure(error);
            return ;
        }
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@", [NSThread currentThread]);
        if (data && (error == nil)) {
            success(data);
        } else if (failure) {
            failure(error);
        }
    }];
    
    [task resume];
}

@end
