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
@interface HCContactsController ()<NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_fetchedResultsController;
}
@end

@implementation HCContactsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"联系人";
    [self setUpFetchedResultsController];
}

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_fetchedResultsController.sections[section] numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"CELL";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    XMPPUserCoreDataStorageObject *user=[_fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"%@",user);
    cell.textLabel.text=[NSString stringWithFormat:@"%@",user.jid];
    cell.imageView.image=[self loaduserPhoto:user];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"ChatSegue" sender:indexPath];
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
@end
