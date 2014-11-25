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
#import "HCEmojiInputView.h"
#import "HCFileInputView.h"
#import "UITextField+YGCCategory.h"
#import "UIImage+YGCCategory.h"
#import "HCLocationTool.h"
#import "MBProgressHUD.h"
@interface HCChatController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,HCEmojiInputViewDelegate,HCFileInputViewDelegate,HCLocationToolDelegate,UINavigationControllerDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate>
{
    //查询结果控制器
    NSFetchedResultsController *_fetchedresultsController;
    
    //小键盘图标（普通状态）
    UIImage *_keyboardimgnor;
    
    //小键盘图标（被点击状态）
    UIImage *_keyboardimgpress;
    
    //表情输入视图
    HCEmojiInputView *_emojiInputView;
    
    //文件输入视图
    HCFileInputView *_fileInputView;
    
    //定位工具
    HCLocationTool *_locationtool;
    
    //定位加载动画
    MBProgressHUD *_locationhub;
}
@end

@implementation HCChatController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    //设置title
    self.title=[NSString stringWithFormat:@"%@\n在线",_user.jidStr];
    //监听键盘位置即将改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self setUpfectchresultControllser];
    
    //设置聊天背景图片
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage resizedImage:@"login_bg.jpg"]];
    _tableview.backgroundView=view;
    _tableview.alwaysBounceVertical=YES;
    
    //点击表格时，关闭键盘
    [_tableview addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)]];
    
    if(!IOS7_OR_LATER)
    {
        //_tableview.separatorInset
    }
   
    //初始化键盘小图标
    _keyboardimgnor=[UIImage imageNamed:@"chat_bottom_keyboard_nor.png"];
    _keyboardimgpress=[UIImage imageNamed:@"chat_bottom_keyboard_press.png"];
    
    //初始化定位工具并设置代理
    _locationtool=[HCLocationTool sharedHCLocationTool];
    _locationtool.delegate=self;
    
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
    else
    {
        [self scrolBottom];
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



#pragma mark 表格自动滚动到最底部
-(void)scrolBottom
{
    //获取表格行数
    NSArray *sections= _fetchedresultsController.sections;
    if(sections.count)
    {
        id<NSFetchedResultsSectionInfo> info=sections[0];
        NSInteger count=[info numberOfObjects];
        if(count)
        {
            NSIndexPath *indexpath=[NSIndexPath indexPathForRow:count-1 inSection:0];
            [_tableview selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        }
    }

}

#pragma mark 查询结果代理
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    [_tableview reloadData];
     [self scrolBottom];
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
    [self sendMsgWithStr:msgstr];
    _txtMsg.text=@"";
}

#pragma mark 发送消息
-(void)sendMsgWithStr:(NSString *)msgstr
{
    if(msgstr)
    {
        XMPPMessage *message=[[XMPPMessage alloc]initWithType:@"chat" to:_user.jid];
        [message addBody:msgstr];
        [kAppdelegate.xmppStream sendElement:message];
        
    }
}

#pragma mark 输入视图按钮点击事件处理

#pragma mrak 语音按钮点击
-(void)btnvoliceclick:(UIButton *)sender
{
    //如果按钮没有被选择，则设为选择状态，如果选择了，则设为非选择状态
    sender.tag=!sender.tag;
    
    //如果按钮被选择，按钮图标显示键盘图标
    if(sender.tag)
    {
        [sender setBackgroundImage:_keyboardimgnor forState:UIControlStateNormal];
        [sender setBackgroundImage:_keyboardimgpress forState:UIControlStateHighlighted];
        _btnspeak.hidden=NO;
        _txtMsg.hidden=YES;
        [_txtMsg resignFirstResponder];
        
        [_btnexpression setBackgroundImage:[UIImage imageNamed:@"chat_bottom_smile_nor.png"] forState:UIControlStateNormal];
        [_btnexpression setBackgroundImage:[UIImage imageNamed:@"chat_bottom_smile_press.png"] forState:UIControlStateHighlighted];
        
        [_btnFile setBackgroundImage:[UIImage imageNamed:@"chat_bottom_up_nor.png"] forState:UIControlStateNormal];
        [_btnFile setBackgroundImage:[UIImage imageNamed:@"chat_bottom_up_press.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_nor.png"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_press.png"] forState:UIControlStateHighlighted];
        _btnspeak.hidden=YES;
        _txtMsg.hidden=NO;
        _txtMsg.inputView=nil;
        [_txtMsg becomeFirstResponder];
    }
    
}

#pragma mark 说话按钮点击
-(void)btnspeakclick:(UIButton *)sender
{
   
}

#pragma mark 表情按钮点击
-(void)btnexpressionclick:(UIButton *)sender
{
    _btnspeak.hidden=YES;
    _txtMsg.hidden=NO;
    //如果按钮没有被选择，则设为选择状态，如果选择了，则设为非选择状态
    sender.tag=!sender.tag;
    //如果按钮被选择，按钮图标显示键盘图标
    if(sender.tag)
    {
        //将输入视图设置为表情键盘
        if (_emojiInputView==nil) {
            _emojiInputView=[[HCEmojiInputView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
            _emojiInputView.delegate=self;
        }
        _txtMsg.inputView=_emojiInputView;
        [sender setBackgroundImage:_keyboardimgnor forState:UIControlStateNormal];
        [sender setBackgroundImage:_keyboardimgpress forState:UIControlStateHighlighted];
        [_btnvolice setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_nor.png"] forState:UIControlStateNormal];
        [_btnvolice setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_press.png"] forState:UIControlStateHighlighted];
        [_btnFile setBackgroundImage:[UIImage imageNamed:@"chat_bottom_up_nor.png"] forState:UIControlStateNormal];
        [_btnFile setBackgroundImage:[UIImage imageNamed:@"chat_bottom_up_press.png"] forState:UIControlStateHighlighted];
       
    }
    else
    {
        _txtMsg.inputView=nil;
        [sender setBackgroundImage:[UIImage imageNamed:@"chat_bottom_smile_nor.png"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"chat_bottom_smile_press.png"] forState:UIControlStateHighlighted];
    }

    [_txtMsg becomeFirstResponder];
    [_txtMsg reloadInputViews];

}

#pragma mark 表情视图代理

-(void)EmojiInputViewSelectItem:(NSString *)string
{
    //当前光标位置
    NSRange range=_txtMsg.selectedRange;
    //将输入框内容字符串转变成可变字符串
    NSMutableString *inputstr=[NSMutableString stringWithString:_txtMsg.text];
    //在光标出插入表情
    [inputstr insertString:string atIndex:range.location];
    _txtMsg.text=inputstr;
    //设置光标位置
    [_txtMsg setSelectedRange:NSMakeRange(range.location+1, 0)];
}

#pragma mark 删除一个表情
-(void)EmojiInputViewRemoveItem
{
    //当前光标位置
    NSRange range=_txtMsg.selectedRange;
    if(range.location>0)
    {
        //将输入框内容字符串转变成可变字符串
        NSMutableString *str=[NSMutableString stringWithString:_txtMsg.text];
        //删除范围，当前光标位置-1，长度为1
        NSRange delrange=NSMakeRange(range.location-1, 1);
        //删除字符串
        [str deleteCharactersInRange:delrange];
        //设置删除后的输入框内容
        _txtMsg.text=str;
        //设置光标位置
        [_txtMsg setSelectedRange:NSMakeRange(delrange.location, 0)];
    }
}

#pragma mark 发送表情
-(void)EmojiInputViewDisSend
{
    [self sendMsg];
}

#pragma mark 添加文件按钮点击
-(void)btnFileclick:(UIButton *)sender
{
    _btnspeak.hidden=YES;
    _txtMsg.hidden=NO;
    //如果按钮没有被选择，则设为选择状态，如果选择了，则设为非选择状态
    sender.tag=!sender.tag;
    
    //如果按钮被选择，按钮图标显示键盘图标
    if(sender.tag)
    {
        if(_fileInputView==nil)
        {
            _fileInputView=[[HCFileInputView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
            _fileInputView.delegate=self;
        }
        //设置输入框的输入视图
        _txtMsg.inputView=_fileInputView;
        [sender setBackgroundImage:_keyboardimgnor forState:UIControlStateNormal];
        [sender setBackgroundImage:_keyboardimgpress forState:UIControlStateHighlighted];
        [_btnvolice setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_nor.png"] forState:UIControlStateNormal];
        [_btnvolice setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_press.png"] forState:UIControlStateHighlighted];
        [_btnexpression setBackgroundImage:[UIImage imageNamed:@"chat_bottom_smile_nor.png"] forState:UIControlStateNormal];
        [_btnexpression setBackgroundImage:[UIImage imageNamed:@"chat_bottom_smile_press.png"] forState:UIControlStateHighlighted];
        

    }
    else
    {
        _txtMsg.inputView=nil;
        [sender setBackgroundImage:[UIImage imageNamed:@"chat_bottom_up_nor.png"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"chat_bottom_up_press.png"] forState:UIControlStateHighlighted];
    }
    [_txtMsg becomeFirstResponder];
    
    [_txtMsg reloadInputViews];

}

#pragma mark 发送文件输入视图代理实现

#pragma mark 打开相册选择照片
-(void)FileInputViewImgLib:(HCFileInputView *)FileInputView
{
    UIImagePickerController *imgcontroller=[[UIImagePickerController alloc]init];
    imgcontroller.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    imgcontroller.delegate=self;
    //imgcontroller.allowsEditing=YES;
    [self presentViewController:imgcontroller animated:YES completion:^{
        
    }];

}

#pragma mark 打开相机拍照
-(void)FileInputViewTakePhoto:(HCFileInputView *)FileInputView
{
    //检查相机模式是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
       [HCAlertDialog showDialog:@"没有可用的拍照设备"];
        return;
    }
    UIImagePickerController *imgpickcontroller=[[UIImagePickerController alloc]init];
    imgpickcontroller.sourceType=UIImagePickerControllerSourceTypeCamera;
    imgpickcontroller.delegate=self;
    [self.navigationController presentViewController:imgpickcontroller animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
}

#pragma mark 发送位置
-(void)FileInputViewLocation:(HCFileInputView *)FileInputView
{
    //方式1.直接在View上show
    if(_locationhub==nil)
    {
        _locationhub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [_locationhub show:YES];
    [_locationtool startLocalation];
}

#pragma mark 定位工具代理
#pragma mark 定位成功
-(void)locationToolSuccess:(HCLocationTool *)location
{
    [_locationhub hide:YES];
    if(location.loclationStr)
    {
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"我的位置" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:location.loclationStr otherButtonTitles:nil];
        [sheet showInView:self.view];
    }
}

#pragma mark 发送位置
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self sendMsgWithStr:[actionSheet buttonTitleAtIndex:buttonIndex]];
    }
}

#pragma mark 定位失败
-(void)locationToolFail:(HCLocationTool *)lacation
{
    [_locationhub hide:YES];
}

@end
