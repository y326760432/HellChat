//
//  UIBarButtonItem+YGCCategory.h
//  WeiBo
//
//  Created by 叶根长 on 14-9-10.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (YGCCategory)
/**
 根据图片创建UIBarButtonItem
 @param image 默认状态下的图片
 @param hightlight 高亮状态下的图片
 @param action 按钮事件
 @param target 事件源
 */
+(UIBarButtonItem *)barbuttonitemWithImage:(NSString *)image hilighlight:(NSString *)hightlight action:(SEL)action target:(id)target;

@end
