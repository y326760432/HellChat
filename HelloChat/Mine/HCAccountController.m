//
//  HCAccountController.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-8.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCAccountController.h"
#import "UIImage+YGCCategory.h"
#import "HCLoginController.h"
#import "HCLoginUserTool.h"
@interface HCAccountController ()

@end

@implementation HCAccountController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"账号管理";
    //拉伸按钮图片
    [_btnlogout setBackgroundImage:[UIImage resizedImage:@"common_button_red_nor.png"] forState:UIControlStateNormal];
    [_btnlogout setBackgroundImage:[UIImage resizedImage:@"common_button_red_pressed.png"] forState:UIControlStateHighlighted];
    [_btnlogout addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
}

/**
 退出当前账号
 */
-(void)loginOut
{
    
    //设置登录标记
    [HCLoginUserTool sharedHCLoginUserTool].isLogined=NO;
    //跳转到登录页面
    HCLoginController *login=[UIStoryboard storyboardWithName:@"HCLoginController" bundle:nil].instantiateInitialViewController;
    [UIApplication sharedApplication].keyWindow.rootViewController=login;
}




@end
