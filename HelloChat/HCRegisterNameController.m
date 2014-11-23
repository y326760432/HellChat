//
//  HCRegisterController.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-22.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCRegisterNameController.h"
#import "HCAppDelegate.h"
#import "HCRegisterInfo.h"
#import "HCAlertDialog.h"
@interface HCRegisterNameController ()

@end

@implementation HCRegisterNameController


- (void)viewDidLoad
{
    [super viewDidLoad];
    kAppdelegate.registerInfo=[[HCRegisterInfo alloc]init];
    [_txtusername becomeFirstResponder];
}


- (IBAction)nextStep:(id)sender
{
    if(!_txtusername.text)
    {
        [HCAlertDialog showDialog:@"请输入用户名"];
        return;
    }
    
    kAppdelegate.registerInfo.username=_txtusername.text;
    
    if(!_txtnikiname.text)
    {
        [HCAlertDialog showDialog:@"请输入昵称"];
        return;
    }
    kAppdelegate.registerInfo.nikiname=_txtnikiname.text;
    
    [self performSegueWithIdentifier:@"gotoRegisterPassword" sender:nil];
}


@end
