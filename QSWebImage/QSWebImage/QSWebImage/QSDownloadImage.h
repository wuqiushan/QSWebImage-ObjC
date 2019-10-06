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

- (void)GET:(NSString *)urlStr param:(NSDictionary *)param success:(BlockRsp)success failure:(BlockErr)failure;

@end

NS_ASSUME_NONNULL_END
