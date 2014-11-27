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
#import "HCRegisterNameController.h"
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

#pragma mark 将UIImageView设置为本控制器的根view
-(void)loadView
{
    UIImageView *bgimgview=[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    bgimgview.image=[UIImage resizedImage:@"login_bg.jpg"];
    bgimgview.userInteractionEnabled=YES;
    self.view=bgimgview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   [self setUI];
}

-(void)setUI
{

    //起始Y坐标
    CGFloat starty=20;
    if(IOS7_OR_LATER)
        starty +=20;
    //添加头像
    _imgphoto=[[UIImageView alloc]init];
    _imgphoto.image=[UIImage imageNamed:@"normalheadphoto.png"];
    CGFloat imgphoto_w=80;
    CGFloat imgphoto_h=80;
    CGFloat imgphoto_x=(kselfviewsize.width-imgphoto_w)/2;
    CGFloat imgphoto_y=starty;
    _imgphoto.frame=CGRectMake(imgphoto_x, imgphoto_y, imgphoto_w, imgphoto_h);
    //设置头像圆角
    _imgphoto.layer.masksToBounds=YES;
    _imgphoto.layer.cornerRadius=40.0;
    [self.view addSubview:_imgphoto];
   
    //添加用户名和密码View
    CGFloat max_y=CGRectGetMaxY(_imgphoto.frame);
    UIView *infoview=[[UIView alloc]init];
    infoview.backgroundColor=[UIColor whiteColor];
    infoview.frame=CGRectMake(0, max_y+10, kselfviewsize.width, 81);
    //用户名输入框
    _txtusername=[[UITextField alloc]init];
    _txtusername.font=kFont(18);
    _txtusername.placeholder=@"用户名";
    _txtusername.textAlignment=NSTextAlignmentCenter;
    _txtusername.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _txtusername.borderStyle=UITextBorderStyleNone;
    _txtusername.frame=CGRectMake(20, 0, kselfviewsize.width-40, 40);
    _txtusername.delegate=self;
    [infoview addSubview:_txtusername];
    //分割线
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 41, kselfviewsize.width, 1)];
    line.image=[UIImage imageNamed:@"line.png"];
    [infoview addSubview:line];
    //密码输入框
    _txtpassword=[[UITextField alloc]initWithFrame:CGRectMake(20, 41, kselfviewsize.width-40, 40)];
    _txtpassword.secureTextEntry=YES;
    _txtpassword.font=kFont(18);
    _txtpassword.placeholder=@"密码";
    _txtpassword.textAlignment=NSTextAlignmentCenter;
    _txtpassword.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _txtpassword.delegate=self;
    //设置密码输入框回车键文字JOIN
    _txtpassword.returnKeyType=UIReturnKeyJoin;
    [infoview addSubview:_txtpassword];
    [self.view addSubview:infoview];
    
    //登录注册按钮
    max_y=CGRectGetMaxY(infoview.frame)+10;
    //按钮宽度，屏幕两边两个间隙20*2加上那个按钮之间一个间隙20=60
    CGFloat button_w=(kselfviewsize.width-60)/2;
    //按钮高度
    CGFloat button_h=40;
    
    //注册按钮
    _btnregister=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnregister.frame=CGRectMake(20, max_y, button_w, button_h);
    _btnregister.backgroundColor=[UIColor orangeColor];
    [_btnregister setTitle:@"注册" forState:UIControlStateNormal];
    _btnregister.layer.cornerRadius=5;
    [_btnregister addTarget:self action:@selector(userRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnregister];

    //登录按钮
    _btnlogin=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnlogin.frame=CGRectMake(40+button_w, max_y,button_w, button_h);
    [_btnlogin setTitle:@"登录" forState:UIControlStateNormal];
    [_btnlogin addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    _btnlogin.backgroundColor=kGetColorRGB(0, 173, 241);
    _btnlogin.layer.cornerRadius=5;
    [self.view addSubview:_btnlogin];
    
    
    
  
    
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



#pragma mark 注册
- (void)userRegister
{
    kAppdelegate.isRegister=YES;
    
    self.navigationController.navigationBarHidden=NO;
   
    HCRegisterNameController *namecontroller=[[HCRegisterNameController alloc]init];
    [self.navigationController pushViewController:namecontroller animated:YES];
}
@end
