//
//  UIBarButtonItem+YGCCategory.m
//  WeiBo
//
//  Created by 叶根长 on 14-9-10.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "UIBarButtonItem+YGCCategory.h"

@implementation UIBarButtonItem (YGCCategory)

+(UIBarButtonItem *)barbuttonitemWithImage:(NSString *)image hilighlight:(NSString *)hightlight action:(SEL)action target:(id)target
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    //获取图片的大小
    UIImage *img=[UIImage imageNamed:image];
    [button setFrame:(CGRect){CGPointZero,img.size}];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:hightlight] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

@end
