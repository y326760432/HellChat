//
//  HCRegisterPasswordController.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-22.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCRegisterPasswordController.h"
#import "HCAlertDialog.h"
#import "HCAppDelegate.h"
#import "MBProgressHUD.h"
@interface HCRegisterPasswordController ()
{
    MBProgressHUD *_hub;
}
@end

@implementation HCRegisterPasswordController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //监听注册失败的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerFail:) name:kRegisterFailNotiKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccess) name:kRegisterSuccessNotiKey object:nil];
}

#pragma mark 注册失败
-(void)registerFail:(NSNotification *)notification
{
    _hub.hidden=YES;
    [HCAlertDialog showDialog:@"注册失败"];
    NSLog(@"%@",notification.userInfo);
}

#pragma mark 注册成功
-(void)registerSuccess
{
    _hub.hidden=YES;
     [self performSegueWithIdentifier:@"gotoRegisterInfo" sender:nil];
}

- (IBAction)nextStep:(id)sender
{
//     [self performSegueWithIdentifier:@"gotoRegisterInfo" sender:nil];
//    return;
    if(_txtpassword1.text.length<6||_txtpassword2.text.length<6)
    {
        [HCAlertDialog showDialog:@"请至少输入6位密码"];
        return;
    }
    
    if(![_txtpassword1.text isEqualToString:_txtpassword2.text])
    {
        [HCAlertDialog showDialog:@"两次输入密码不一致"];
        return;
    }
    kAppdelegate.registerInfo.password=_txtpassword1.text;
    [self.view endEditing:YES];
    [self comitRegister];
}

#pragma mark 开始注册
-(void)comitRegister
{
    _hub=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hub.dimBackground=YES;
    [kAppdelegate connectWithFailBock:^(NSString *error) {
        if(error)
        {
            [HCAlertDialog showDialog:error];
        }
    } succsee:^{
        [HCAlertDialog showDialog:@"注册失败"];
    }];
   
}

@end
