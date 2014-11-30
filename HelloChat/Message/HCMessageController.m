//
//  HCMessageController.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-2.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCMessageController.h"
#import "HCVCardController.h"
#import "RESideMenu.h"
#import "HCAppDelegate.h"
#import "XMPPvCardTemp.h"
#import "HCLoginUser.h"
#import "HCLoginUserTool.h"
#import <QuartzCore/QuartzCore.h>
#import "HCMessageDataTool.h"
#import "HCMessage.h"
#import <CoreData/CoreData.h>
#import "HCXMPPUserTool.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "HCMessageCell.h"
#import "HCChatController.h"
@interface HCMessageController ()<NSFetchedResultsControllerDelegate>
{
    UIImageView *_imgvPhoto;//头像
    
    NSFetchedResultsController *_fetchedresultsController;//本地会话查询控制器
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
    UIImage *img=[UIImage imageNamed:@"normalheadphoto.png"];
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
    
    [self setupFetchResultController];
}

#pragma mark 查询结果控制器

-(void)setupFetchResultController
{
    //查询请求
    NSFetchRequest *requset=[[NSFetchRequest alloc]initWithEntityName:@"HCMessage"];
    //设置排序字段
    requset.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"msgdate" ascending:NO]];
    
    //初始化查询控制器
    _fetchedresultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:requset managedObjectContext:[HCMessageDataTool sharedHCMessageDataTool].context sectionNameKeyPath:nil cacheName:nil];
    _fetchedresultsController.delegate=self;
    
    NSError *error;
    [_fetchedresultsController performFetch:&error];
    if(error)
        NSLog(@"初始化NSFetchedResultsController出错%@",error.localizedDescription);
    
}

#pragma mark 电子名片更新通知
-(void)vCardUpdate
{
    NSData *data=[kAppdelegate.xmppvCardAvatarModule photoDataForJID:kmyJid];
    if(data)
    {
        _imgvPhoto.image=[UIImage imageWithData:data];
        //设置归档用户的头像，登录界面显示
        [HCLoginUserTool sharedHCLoginUserTool].userPhoto=[UIImage imageWithData:data];

    }
}

#pragma mark 会话信息发生改变
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    dispatch_sync(dispatch_get_main_queue(), ^{
         [self.tableView reloadData];
    });
   
}

#pragma mark UITableView代理方法

#pragma mark 表格行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_fetchedresultsController.sections[section] numberOfObjects];
}

#pragma mark 获取行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

#pragma mark 获取每行视图
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"CELL";
    HCMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil)
    {
        cell=[[HCMessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    HCMessage *msg=[_fetchedresultsController objectAtIndexPath:indexPath];
    XMPPUserCoreDataStorageObject *user=[HCXMPPUserTool getUserCoreDataObjectWithJidStr:msg.jidstr];
    cell.user=user;
    cell.message=msg;
    return cell;
}

#pragma mark 点击某个联系人进入聊天界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HCMessage *msg=[_fetchedresultsController objectAtIndexPath:indexPath];
    XMPPUserCoreDataStorageObject *user=[HCXMPPUserTool getUserCoreDataObjectWithJidStr:msg.jidstr];
    HCChatController *chatcontroller=[[HCChatController alloc]init];
    chatcontroller.user=user;
    [self.navigationController pushViewController:chatcontroller animated:YES];
}

#pragma mark 是否可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
         HCMessage *msg=[_fetchedresultsController objectAtIndexPath:indexPath];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[HCMessageDataTool sharedHCMessageDataTool] delMessage:msg];
        });
        
    }
}

#pragma mark 显示个人信息
-(void)showPersonal
{
     HCVCardController *personal=[UIStoryboard  storyboardWithName:@"HCPersonalController" bundle:nil].instantiateInitialViewController;
    [self.navigationController pushViewController:personal animated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
