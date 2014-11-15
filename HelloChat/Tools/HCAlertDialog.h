//
//  HCAlertDialog.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-3.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCAlertDialog : NSObject

/**
 弹出提示信息窗口
 
 @param msg 信息内容
 */
+(void)showDialog:(NSString *)msg;

@end
