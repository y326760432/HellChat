//
//  HCAddContactController.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-11.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCAddContactController.h"
#import "HCLoginUser.h"
#import "HCLoginUserTool.h"
#import "HCAlertDialog.h"
#import "HCAppdelegate.h"
@interface HCAddContactController ()<UITextFieldDelegate>

@end

@implementation HCAddContactController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [_txtuserid becomeFirstResponder];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendInvite];
    return YES;
}

#pragma mark 发送添加好友邀请
-(void)sendInvite
{
    NSString *error=@"";
    if (_txtuserid.text.length==0) {
        error=@"请输入用户名";
    }
    else if ([_txtuserid.text isEqualToString:[HCLoginUserTool sharedHCLoginUserTool].loginUser.username])
    {
        error=@"不能添加自己";
    }
    if(error.length>0)
    {
        [HCAlertDialog showDialog:error];
        return;
    }
    else
    {
        //发送的订阅请求
        [kAppdelegate.xmppRoster subscribePresenceToUser:[XMPPJID jidWithString:kAppendJid(_txtuserid.text)]];
         [self.view endEditing:YES];
    }
}

#pragma mark 点击背景的时候关闭键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
