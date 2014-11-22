//
//  HCMessageController.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-2.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCMessageController.h"
#import "HCPersonalController.h"
#import "RESideMenu.h"
#import "HCAppDelegate.h"
#import "XMPPvCardTemp.h"
#import "HCLoginUser.h"
#import "HCLoginUserTool.h"
#import <QuartzCore/QuartzCore.h>
@interface HCMessageController ()
{
    UIImageView *_imgvPhoto;//头像
    UIView *_discover;//加载蒙版
}
@end

@implementation HCMessageController

///**
// 视图即将出现
// */
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"消息";
    
    //设置圆角头像
    UIImage *img=[UIImage imageNamed:@"AppIcon-140x40.png"];
    _imgvPhoto=[[UIImageView alloc]initWithImage:img];
    _imgvPhoto.contentMode=UIViewContentModeScaleAspectFit;
    _imgvPhoto.frame=CGRectMake(0, 0, 36, 36);
    _imgvPhoto.layer.masksToBounds=YES;
    _imgvPhoto.layer.cornerRadius=18;
    _imgvPhoto.userInteractionEnabled=YES;
    [_imgvPhoto addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentLeftMenuViewController:)]];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:_imgvPhoto];
    
    //监听右侧视图点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPersonal) name:@"headerclick" object:nil];
    //监听电子名片修改后通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vCardUpdate) name:kdidupdatevCard object:nil];
    
    [self vCardUpdate];
}

#pragma mark 电子名片更新通知
-(void)vCardUpdate
{
    XMPPJID *jid=[XMPPJID jidWithString:[HCLoginUserTool sharedHCLoginUserTool].loginUser.JID];
    NSData *data=[kAppdelegate.xmppvCardAvatarModule photoDataForJID:jid];
    if(data)
    {
        _imgvPhoto.image=[UIImage imageWithData:data];
    }
}

#pragma mark UITableView代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"CELL";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"%d",indexPath.row];
    return cell;
}

#pragma mark 显示个人信息
-(void)showPersonal
{
     HCPersonalController *personal=[UIStoryboard  storyboardWithName:@"HCPersonalController" bundle:nil].instantiateInitialViewController;
    [self.navigationController pushViewController:personal animated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
