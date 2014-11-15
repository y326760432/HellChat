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
@interface HCLoginController ()<UITextFieldDelegate>
{
    UIActivityIndicatorView *_indicator;//登录加载动画
}
@end



@implementation HCLoginController

-(HCAppDelegate *)appdelegate
{
    return (HCAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUI];
}

-(void)setUI
{
    //设置头像圆角
    _imgphoto.layer.masksToBounds=YES;
    _imgphoto.layer.cornerRadius=40.0;
    
    //设置登录按钮图片拉伸
    UIImage *img=[UIImage imageNamed:@"bc_btn_blue.png"];
    UIImage *btnimg=[img stretchableImageWithLeftCapWidth:img.size.width*0.5 topCapHeight:img.size.height*0.5];
    [_btnlogin setBackgroundImage:btnimg forState:UIControlStateNormal];
    UIImage  *imghl=[UIImage imageNamed:@"login_btn_blue_press.png"];
    UIImage * btnimghl=[imghl stretchableImageWithLeftCapWidth:imghl.size.width*0.5 topCapHeight:imghl.size.height*0.5];
    _txtpassword.returnKeyType=UIReturnKeyJoin;
    [_btnlogin setBackgroundImage:btnimghl forState:UIControlStateHighlighted];
    [_btnlogin addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.png"]];
    
    //添加指示器
    _indicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicator.center=self.view.center;
    [self.view addSubview:_indicator];
    
    //设置用户名和密码,如果沙盒中有用户名和密码，自动填入
    if([HCLoginUserTool sharedHCLoginUserTool].loginUser)
    {
        _txtusername.text=[HCLoginUserTool sharedHCLoginUserTool].loginUser.username;
        _txtpassword.text=[HCLoginUserTool sharedHCLoginUserTool].loginUser.password;
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
        [_indicator startAnimating];
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
    [_indicator stopAnimating];
    _btnlogin.enabled=YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}




@end
