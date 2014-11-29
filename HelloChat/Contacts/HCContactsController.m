//
//  HCContactsController.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-2.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCContactsController.h"
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import "HCAppdelegate.h"
#import "HCChatController.h"
#import "HCContactCell.h"
#import "HCAddContactController.h"
#import "HCXMPPUserTool.h"
@interface HCContactsController ()<NSFetchedResultsControllerDelegate,UIAlertViewDelegate>
{
    NSFetchedResultsController *_fetchedResultsController;
    
    //即将删除的好友，用户选择删除好友后，记录该好友，然后弹出询问对话框，点击确定后将该好友删除
    XMPPUserCoreDataStorageObject *_willdelUser;
}
@end

@implementation HCContactsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLayout];
    [self setUpFetchedResultsController];
}

#pragma mark 设置界面布局
-(void)setLayout
{
    self.title=@"联系人";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addNewContract)];
}

#pragma mark 初始化好友查询控制器
-(void)setUpFetchedResultsController
{
    NSManagedObjectContext *context=kAppdelegate.xmpprosterCoreDataStorage.mainThreadManagedObjectContext;
    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    NSSortDescriptor *sortdesc=[NSSortDescriptor sortDescriptorWithKey:@"jidStr" ascending:YES];
    [request setSortDescriptors:@[sortdesc]];
    _fetchedResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:@"section" cacheName:nil];
    _fetchedResultsController.delegate=self;
    
    //开始查询
    NSError *error=nil;
    [_fetchedResultsController performFetch:&error];
    if(error)
    {
        NSLog(@"%@",error.localizedDescription);
    }
}

#pragma mark 加载用户头像
-(UIImage *)loaduserPhoto:(XMPPUserCoreDataStorageObject *)user
{
    if(user.photo)
        return user.photo;
    NSData *data=[kAppdelegate.xmppvCardAvatarModule photoDataForJID:user.jid];
    if(data)
        return [UIImage imageWithData:data];
    return nil;
}

#pragma mark UITableView代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _fetchedResultsController.sections.count;
}

#pragma mark 设置组名
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // 1. 取出控制器中的所有分组
    NSArray *array = [_fetchedResultsController sections];
    // 2. 根据section值取出对应的分组信息对象
    id <NSFetchedResultsSectionInfo> info = array[section];
    
    NSString *stateName = nil;
    NSInteger state = [[info name] integerValue];
    
    switch (state) {
        case 0:
            stateName = @"在线";
            break;
        case 1:
            stateName = @"离开";
            break;
        case 2:
            stateName = @"下线";
            break;
        default:
            stateName = @"未知";
            break;
    }
    
    return stateName;
}

#pragma mark 获取分组数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_fetchedResultsController.sections[section] numberOfObjects];
}

#pragma mark 创建表格行视图
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"CELL";
    HCContactCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil)
    {
        cell=[[HCContactCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    XMPPUserCoreDataStorageObject *user=[_fetchedResultsController objectAtIndexPath:indexPath];
    cell.user=user;
    return cell;
}

#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark 选择某个联系人
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HCChatController *chatcontroller=[[HCChatController alloc]init];
    chatcontroller.user=[_fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:chatcontroller animated:YES];
}

#pragma mark 设置表格行可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark 提交变化行编辑，如果是删除，则弹出询问提示是否要删除好友
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
       XMPPUserCoreDataStorageObject *user=[_fetchedResultsController objectAtIndexPath:indexPath];
        _willdelUser=user;
        NSString *username=[[HCXMPPUserTool sharedHCXMPPUserTool] getDisplayNameWithUser:user];
        UIAlertView *dialog=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否要删除好友\n%@?",username] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [dialog show];
    }
}

#pragma mark 确定删除好友
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1&&_willdelUser)
    {
        [kAppdelegate.xmppRoster removeUser:_willdelUser.jid];
    }
}

#pragma mark 准备显示聊天控制器

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath *)sender
{
    if([segue.destinationViewController isKindOfClass:[HCChatController class]])
    {
        HCChatController *chatcontroller=segue.destinationViewController;
        chatcontroller.user=[_fetchedResultsController objectAtIndexPath:sender];
    }
}

#pragma mark NSFetchedResultsControllerDelegate 代理方法

//用户信息发生改变
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    [self.tableView reloadData];
}

#pragma mark 添加新的联系人
-(void)addNewContract
{
    HCAddContactController *addcontract=[[HCAddContactController alloc]init];
    [self.navigationController pushViewController:addcontract animated:YES];
}

@end
