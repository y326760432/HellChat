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
#import "HCRegisterInfoController.h"
@interface HCRegisterPasswordController ()
{
    MBProgressHUD *_hub;
     UITextField *_txtpassword1;
    
     UITextField *_txtpassword2;
}
@end

@implementation HCRegisterPasswordController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
    //监听注册失败的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerFail:) name:kRegisterFailNotiKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccess) name:kRegisterSuccessNotiKey object:nil];
}

#pragma mark 设置界面元素
-(void)setUI
{
    self.title=@"设置密码(2/3)";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
    //设置背景颜色
    self.view.backgroundColor=kGetColorRGB(242, 242, 230);

    //起始位置
    CGFloat start_y=20;
    if(IOS7_OR_LATER)
        start_y+=64;
        //信息输入视图
    UIView *infoview=[[UIView alloc]init];
    infoview.backgroundColor=[UIColor whiteColor];
    infoview.frame=CGRectMake(0, start_y, kselfviewsize.width, 81);
    
    //密码图标
    UIImageView *icon1=[[UIImageView alloc]initWithFrame:CGRectMake(20, 4, 32, 32)];
    icon1.image=[UIImage imageNamed:@"icon_register_password"];
    [infoview addSubview:icon1];
    
    UIImageView *icon2=[[UIImageView alloc]initWithFrame:CGRectMake(20, 45, 32, 32)];
    icon2.image=[UIImage imageNamed:@"icon_register_password"];
    [infoview addSubview:icon2];
    
    //用户名输入框
    _txtpassword1=[[UITextField alloc]init];
    _txtpassword1.font=kFont(18);
    _txtpassword1.secureTextEntry=YES;
    _txtpassword1.placeholder=@"密码";
    _txtpassword1.textAlignment=NSTextAlignmentCenter;
    _txtpassword1.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _txtpassword1.borderStyle=UITextBorderStyleNone;
    _txtpassword1.frame=CGRectMake(55, 0, kselfviewsize.width-75, 40);
    [infoview addSubview:_txtpassword1];
    //分割线
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 41, kselfviewsize.width, 1)];
    line.image=[UIImage imageNamed:@"line.png"];
    [infoview addSubview:line];
    //确认密码
    _txtpassword2=[[UITextField alloc]initWithFrame:CGRectMake(55, 41, kselfviewsize.width-75, 40)];
    _txtpassword2.font=kFont(18);
    _txtpassword2.placeholder=@"确认密码";
    _txtpassword2.secureTextEntry=YES;
    _txtpassword2.textAlignment=NSTextAlignmentCenter;
    _txtpassword2.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [infoview addSubview:_txtpassword2];
    [self.view addSubview:infoview];
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
    HCRegisterInfoController *infocontroller=[[HCRegisterInfoController alloc]init];
    [self.navigationController pushViewController:infocontroller animated:YES];
}

- (void)nextStep
{
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
