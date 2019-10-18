//
//  QSDownloadImage.h
//  QSWebImage
//
//  Created by apple on 2019/10/4.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BlockRsp)(id rspObject);
typedef void(^BlockErr)(NSError *error);

@interface QSDownloadImage : NSObject

/**
 下载图片，直接获取NSData类型的图片数据

 @param urlStr 请求的url
 @param param 请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
 */
- (void)GET:(NSString * _Nullable)urlStr
      param:(NSDictionary * _Nullable)param
    success:(BlockRsp)success
    failure:(BlockErr)failure;

@end

NS_ASSUME_NONNULL_END
