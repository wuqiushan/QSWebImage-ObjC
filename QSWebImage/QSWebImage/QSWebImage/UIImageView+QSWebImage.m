//
//  UIImageView+QSWebImage.m
//  QSWebImage
//
//  Created by apple on 2019/10/4.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import "UIImageView+QSWebImage.h"
#import "QSWebImageManage.h"

@implementation UIImageView (QSWebImage)


- (void)QSImageUrl:(NSString * _Nullable)urlStr defaultImage:(NSString * _Nullable)defImage {
    
    self.image = [UIImage imageNamed:defImage];
    [[QSWebImageManage sharedInstance] imageDataWithUrl:urlStr setImageView:self];
}

@end
