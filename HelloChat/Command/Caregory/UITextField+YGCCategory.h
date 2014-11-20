//
//  UITextField+YGCCategory.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-20.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (YGCCategory)

/**
 获取光标位置
 */
- (NSRange) selectedRange;

/**
 设置光标位置
 */
- (void) setSelectedRange:(NSRange) range;

@end
