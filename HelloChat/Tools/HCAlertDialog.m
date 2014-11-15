//
//  HCAlertDialog.m
//  HelloChat
//  弹出提示或警告信息
//  Created by 叶根长 on 14-11-3.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCAlertDialog.h"
#import "MBProgressHUD.h"
@implementation HCAlertDialog

+(void)showDialog:(NSString *)msg
{
    if(msg)
    {
        //在主线程调用
        dispatch_async(dispatch_get_main_queue(), ^{
            
            MBProgressHUD *_hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];;
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = msg;
            _hud.removeFromSuperViewOnHide = YES;
            [_hud hide:YES afterDelay:1];
        });
    }
}

@end
