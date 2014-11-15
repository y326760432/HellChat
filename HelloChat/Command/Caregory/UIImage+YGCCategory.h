//
//  UIImage+UIImage_Category.h
//  WeiBo
//
//  Created by 叶根长 on 14-8-31.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YGCCategory)

/**
创建可以自由拉伸的图片
 @param imgName 图片名称
 @return 可自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)imgName;

/**
 创建可以自由拉伸的图片
 @param imgName 图片名称
 @param xPos 拉伸的点的x值
  @param yPos 拉伸的点的y值
 @return 可自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

@end
