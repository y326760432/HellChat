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
{
    UITextField *_txtuserid;
}
@end

@implementation HCAddContactController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLayout];
    [_txtuserid becomeFirstResponder];
}


-(void)setLayout
{
    self.title=@"添加好友";
    self.view.backgroundColor=[UIColor whiteColor];
    
    //添加导航栏右边按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sendInvite)];
    
    //添加输入框
    CGFloat start_y=20;
    if(IOS7_OR_LATER)
        start_y+=64;
    _txtuserid=[[UITextField alloc]init];
    _txtuserid.borderStyle=UITextBorderStyleRoundedRect;
    _txtuserid.frame=CGRectMake(20, start_y, kselfviewsize.width-40, 30);
    _txtuserid.delegate=self;
    [self.view addSubview:_txtuserid];
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
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 点击背景的时候关闭键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
