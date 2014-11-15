//
//  UIImage+UIImage_Category.m
//  WeiBo
//
//  Created by 叶根长 on 14-8-31.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "UIImage+YGCCategory.h"

@implementation UIImage (YGCCategory)

+ (UIImage *)resizedImage:(NSString *)imgName
{
    return [self resizedImage:imgName xPos:0.5 yPos:0.5];
}

+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos
{
    UIImage *image = [UIImage imageNamed:imgName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * xPos topCapHeight:image.size.height * yPos];
}

@end
