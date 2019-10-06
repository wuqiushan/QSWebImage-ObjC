//
//  QSWebImageManage.h
//  QSWebImage
//
//  Created by apple on 2019/10/4.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSWebImageManage : NSObject

+ (instancetype)sharedInstance;
- (void)imageDataWithUrl:(NSString *)url setImageView:(UIImageView *)imgeView;

@end

NS_ASSUME_NONNULL_END
