//
//  HCChatController.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-15.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCChatController.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPMessageArchiving_Message_CoreDataObject.h"
#import "HCAppDelegate.h"
#import "HCLoginUserTool.h"
#import "HCLoginUser.h"
#import "HCAlertDialog.h"
#import "HCChatCell.h"
#import "HCRoundImageView.h"
@interface HCChatController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>
{
    //查询结果控制器
    NSFetchedResultsController *_fetchedresultsController;
}
@end

@implementation HCChatController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    //设置title
    self.title=_user.jidStr;
    //监听键盘位置即将改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self setUpfectchresultControllser];
    
    _tableview.backgroundColor=[UIColor clearColor];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.jpg"]];
    _tableview.backgroundView=view;
   
   
}

#pragma mark 初始化查询控制器
-(void)setUpfectchresultControllser
{
    //查询上下文
    NSManagedObjectContext *context=kAppdelegate.xmppmessageCoreDataStorage.mainThreadManagedObjectContext;
    
    NSFetchRequest *requset=[[NSFetchRequest alloc]initWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    //添加查询谓词
    requset.predicate=[NSPredicate predicateWithFormat:@"bareJidStr CONTAINS[cd] %@ and streamBareJidStr CONTAINS[cd] %@",_user.jidStr,kmyJidStr];
   //根据发送时间排序
    NSSortDescriptor *sortdesc=[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];;
    [requset setSortDescriptors:@[sortdesc]];
    
    //初始化
    _fetchedresultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:requset managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _fetchedresultsController.delegate=self;
    
    NSError *error=nil;
    //开始查询
    [_fetchedresultsController performFetch:&error];
    if(error)
    {
        [HCAlertDialog showDialog:@"加载聊天记录失败"];
    }
}

#pragma mark 键盘位置发生改变通知
-(void)keyBoardChangeFrame:(NSNotification *)nofification
{
    
    //键盘的目标位置
    CGRect keyboardframe=[nofification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //动画时长
    CGFloat duration=[nofification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    
    //如果键盘的y等于屏幕的总高度，则表示键盘将要隐藏，设置输入视图距离底部距离为0
    if(keyboardframe.origin.y==[UIScreen mainScreen].bounds.size.height)
        _keybordHiddenCts.constant=0;
    else
        _keybordHiddenCts.constant=keyboardframe.size.height;
    
    //动画展现输入框位置
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];

}

#pragma mark UITableView代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> info=_fetchedresultsController.sections[section];
    return [info numberOfObjects];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPMessageArchiving_Message_CoreDataObject *message=[_fetchedresultsController objectAtIndexPath:indexPath];
    //计算文字高度=文字真实高度+文字在Button中的间距40+cell的上下间距30
    CGFloat cellheight=[message.body sizeWithFont:kFont(14) constrainedToSize:CGSizeMake(180, MAXFLOAT)].height+70;
    
    return cellheight>80?cellheight:80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *fromChatCellId=@"FromChatCell";
    static NSString *toChatCellId=@"ToChatCell";
    //提取消息
    XMPPMessageArchiving_Message_CoreDataObject *message=[_fetchedresultsController objectAtIndexPath:indexPath];
    
    HCChatCell *cell=nil;
    if(message.isOutgoing)
        cell=[tableView dequeueReusableCellWithIdentifier:toChatCellId];
    else
        cell=[tableView dequeueReusableCellWithIdentifier:fromChatCellId];
    cell.isOutgoing=message.isOutgoing;
    //设置头像
    XMPPJID *jid=kmyJid;
    //是否用户自己发送的信息
    if(!message.isOutgoing)
        jid=message.bareJid;
    cell.photoimgv.image=[UIImage imageWithData:[kAppdelegate.xmppvCardAvatarModule photoDataForJID:jid]];
    //设置消息内容
    [cell setMessage:message.body];
    
    
    return cell;
}

#pragma mark tableview 滚动代理 将要拖拽
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self closeKeyBoard];
//}

#pragma mark 查询结果代理
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    [_tableview reloadData];
}

#pragma mark 信息输入框相关代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [self sendMsg];
    return YES;
}

#pragma mark 关闭键盘
-(void)closeKeyBoard
{
     [self.view endEditing:YES];
}

#pragma mark 发送信息
-(void)sendMsg
{
    NSString *msgstr=_txtMsg.text;
    if(msgstr)
    {
        XMPPMessage *message=[[XMPPMessage alloc]initWithType:@"chat" to:_user.jid];
        [message addBody:msgstr];
        [kAppdelegate.xmppStream sendElement:message];
        _txtMsg.text=@"";
    }
}

@end
