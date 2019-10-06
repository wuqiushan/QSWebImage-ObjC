//
//  UIImageView+QSWebImage.h
//  QSWebImage
//
//  Created by apple on 2019/10/4.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (QSWebImage)

- (void)QSImageUrl:(NSString *)urlStr defaultImage:(NSString *)defImage;

@end

NS_ASSUME_NONNULL_END
