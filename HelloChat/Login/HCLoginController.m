//
//  HCLoginController.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-1.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCLoginController.h"
#import <QuartzCore/QuartzCore.h>
#import "HCLoginUser.h"
#import "HCLoginUserTool.h"
#import "HCAppDelegate.h"
#import "HCAlertDialog.h"
#import "MBProgressHUD.h"
#import "UIImage+YGCCategory.h"
@interface HCLoginController ()<UITextFieldDelegate>
{
    MBProgressHUD *_loginhud;//登录加载动画
    UIImageView *_imgphoto;//头像
    UITextField *_txtusername;//用户名
    UITextField *_txtpassword;//密码
    UIButton *_btnlogin;//登录
    UIButton *_btnregister;//注册
}
@end



@implementation HCLoginController

-(HCAppDelegate *)appdelegate
{
    return (HCAppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark 视图将要出现的时候 隐藏导航栏
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    kAppdelegate.isRegister=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   [self setUI];
}

-(void)setUI
{

    //添加头像
    _imgphoto=[[UIImageView alloc]init];
    _imgphoto.image=[UIImage imageNamed:@"normalheadphoto.png"];
    CGFloat imgphoto_w=80;
    CGFloat imgphoto_h=80;
    CGFloat imgphoto_x=(kselfviewsize.width-imgphoto_w)/2;
    CGFloat imgphoto_y=10;
    _imgphoto.frame=CGRectMake(imgphoto_x, imgphoto_y, imgphoto_w, imgphoto_h);
    //设置头像圆角
    _imgphoto.layer.masksToBounds=YES;
    _imgphoto.layer.cornerRadius=40.0;
    [self.view addSubview:_imgphoto];
   
    
    //设置密码输入框回车键文字JOIN
    _txtpassword.returnKeyType=UIReturnKeyJoin;
    
    //设置登录按钮图片拉伸
//    [_btnlogin setBackgroundImage:[UIImage resizedImage:@"bc_btn_blue.png"] forState:UIControlStateNormal];
//    [_btnlogin setBackgroundImage:[UIImage resizedImage:@"login_btn_blue_press.png"]
//                         forState:UIControlStateHighlighted];
    
    //设置按钮背景颜色
    _btnlogin.backgroundColor=kGetColorRGB(0, 173, 241);
    _btnlogin.layer.cornerRadius=5;
    _btnregister.backgroundColor=[UIColor orangeColor];
    _btnregister.layer.cornerRadius=5;
    
    //登录事件
    [_btnlogin addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
   
    
  
    
    //设置用户名和密码,如果沙盒中有用户名和密码，自动填入
    if([HCLoginUserTool sharedHCLoginUserTool].loginUser)
    {
        HCLoginUser *user=[HCLoginUserTool sharedHCLoginUserTool].loginUser;
        _txtusername.text=user.username;
        _txtpassword.text=user.password;
        if(user.photo)
        {
            _imgphoto.image=user.photo;
        }
    }
}

#pragma mark 键盘按上回车键事件
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==_txtusername)
    {
        [_txtpassword becomeFirstResponder];
    }
    else
        [self login];
    return YES;
}

#pragma mark 用户名输完后，清空密码
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==_txtusername)
    {
        _txtpassword.text=@"";
    }
    return YES;
}

#pragma mark 验证用户输入信息是否完整
-(BOOL)valUserInputInfo
{
    NSString *error=nil;
    if (_txtusername.text.length==0) {
        error=@"请输入用户名";
    }
    else if(_txtpassword.text.length==0)
    {
        error=@"请输入密码";
    }
    if(error.length>0)
    {
        [HCAlertDialog showDialog:error];
        return NO;
    }
    else
    {
        [self.view endEditing:YES];
    }
    return YES;
}

#pragma mark 登录
-(void)login
{
    //验证登录信息
    if([self valUserInputInfo])
    {
        HCLoginUser *user=[[HCLoginUser alloc]init];
        user.username=_txtusername.text;
        user.password=_txtpassword.text;
        [HCLoginUserTool sharedHCLoginUserTool].loginUser=user;
        
        //开始加载动画
        //添加指示器
        _loginhud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _loginhud.dimBackground=YES;
        _btnlogin.enabled=NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [[self appdelegate] connectWithFailBock:^(NSString *error) {
            //停止加载动画
            [self finishLogin];
            [HCAlertDialog showDialog:error];
        } succsee:^{
            [self finishLogin];
        }];
    }
}

-(void)finishLogin
{
    //停止加载动画
    [_loginhud hide:YES];
    _btnlogin.enabled=YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}




- (IBAction)btnRegisterClick:(id)sender
{
    kAppdelegate.isRegister=YES;
    
    self.navigationController.navigationBarHidden=NO;
    [self performSegueWithIdentifier:@"goroRegisterName" sender:nil];
}
@end
