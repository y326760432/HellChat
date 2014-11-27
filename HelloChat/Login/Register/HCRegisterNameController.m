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
#import "HCRegisterPasswordController.h"
@interface HCRegisterNameController ()
{
    UITextField *_txtusername;//用户名
    UITextField *_txtnikiname;//昵称
}
@end

@implementation HCRegisterNameController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUI];
    //舒适化注册信息
    kAppdelegate.registerInfo=[[HCRegisterInfo alloc]init];
    //弹出键盘
    [_txtusername becomeFirstResponder];
}

-(void)setUI
{
    self.title=@"用户名(1/3)";
    self.navigationItem.rightBarButtonItem.title=@"登录";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
    
    CGFloat start_y=20;
    if(IOS7_OR_LATER)
        start_y+=64;
    
    //设置背景颜色
    self.view.backgroundColor=kGetColorRGB(242, 242, 230);
    //信息输入视图
    UIView *infoview=[[UIView alloc]init];
    infoview.backgroundColor=[UIColor whiteColor];
    infoview.frame=CGRectMake(0, start_y, kselfviewsize.width, 81);
    
    //用户名图标
    UIImageView *usericon=[[UIImageView alloc]initWithFrame:CGRectMake(20, 4, 32, 32)];
    usericon.image=[UIImage imageNamed:@"icon_register_name.png"];
    [infoview addSubview:usericon];
    
    //用户名输入框
    _txtusername=[[UITextField alloc]init];
    _txtusername.font=kFont(18);
    _txtusername.placeholder=@"用户名";
    _txtusername.textAlignment=NSTextAlignmentCenter;
    _txtusername.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _txtusername.borderStyle=UITextBorderStyleNone;
    _txtusername.frame=CGRectMake(55, 0, kselfviewsize.width-75, 40);
    [infoview addSubview:_txtusername];
    //分割线
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 41, kselfviewsize.width, 1)];
    line.image=[UIImage imageNamed:@"line.png"];
    [infoview addSubview:line];
    //密码输入框
    _txtnikiname=[[UITextField alloc]initWithFrame:CGRectMake(55, 41, kselfviewsize.width-75, 40)];
    _txtnikiname.font=kFont(18);
    _txtnikiname.placeholder=@"昵称";
    _txtnikiname.textAlignment=NSTextAlignmentCenter;
    _txtnikiname.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [infoview addSubview:_txtnikiname];
    [self.view addSubview:infoview];
}

#pragma mark 下一步
- (void)nextStep
{
    if(_txtusername.text.length==0)
    {
        [HCAlertDialog showDialog:@"请输入用户名"];
        return;
    }
    
    kAppdelegate.registerInfo.username=_txtusername.text;
    
    if(_txtnikiname.text.length==0)
    {
        [HCAlertDialog showDialog:@"请输入昵称"];
        return;
    }
    kAppdelegate.registerInfo.nikiname=_txtnikiname.text;
    HCRegisterPasswordController *passwordcontroller=[[HCRegisterPasswordController alloc]init];
    [self.navigationController pushViewController:passwordcontroller animated:YES];
}


@end
