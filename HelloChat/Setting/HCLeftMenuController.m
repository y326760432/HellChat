//
//  HCSettingController.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-2.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCLeftMenuController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+YGCCategory.h"
#import "HCLoginController.h"
#import "HCLoginUserTool.h"
#import "HCVCardController.h"
#import "RESideMenu.h"
#import "HCAppdelegate.h"
#import "YGCNavController.h"
#import "XMPPvCardTemp.h"
@interface HCLeftMenuController ()<UIGestureRecognizerDelegate>

@end

@implementation HCLeftMenuController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUI];

}

-(void)setUI
{
    //设置背景色为透明设
    self.view.backgroundColor=[UIColor clearColor];
    
    //设置头像圆角
    _imgPhoto.layer.masksToBounds=YES;
    _imgPhoto.layer.cornerRadius=35;
    
    //添加头部信息点击事件
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)];
    tap.delegate=self;
    [_haderView addGestureRecognizer:tap];
    
    //拉伸按钮图片
    [_btnLogOut setBackgroundImage:[UIImage resizedImage:@"common_button_red_nor.png"] forState:UIControlStateNormal];
    [_btnLogOut setBackgroundImage:[UIImage resizedImage:@"common_button_red_pressed"] forState:UIControlStateHighlighted];
    [_btnLogOut addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    
    //监听电子名片修改后通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vCardUpdate) name:kdidupdatevCard object:nil];
}

-(void)headClick
{

    [self.sideMenuViewController hideMenuViewController];
    if(_delegate&&[_delegate respondsToSelector:@selector(headClick)])
    {
        [_delegate headerClick];
    }
    
    //发出头部视图被点击的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"headerclick" object:nil];
   
}

#pragma mark 电子名片更新通知
-(void)vCardUpdate
{
    if(kAppdelegate.xmppvCardTempModule.myvCardTemp.photo)
    {
        _imgPhoto.image=[UIImage imageWithData:kAppdelegate.xmppvCardTempModule.myvCardTemp.photo];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

/**
 退出当前账号
 */
-(void)loginOut
{
    
    //设置登录标记
    [HCLoginUserTool sharedHCLoginUserTool].isLogined=NO;
    //跳转到登录页面
    HCLoginController *login=[[HCLoginController alloc]init];
    
    [UIApplication sharedApplication].keyWindow.rootViewController=login;
}

@end
