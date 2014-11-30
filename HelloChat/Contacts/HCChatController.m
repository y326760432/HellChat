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
#define kInputBarHeight 44 //输入条高度

@interface HCChatController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,HCEmojiInputViewDelegate,HCFileInputViewDelegate,HCLocationToolDelegate,UINavigationControllerDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate>
{
    //查询结果控制器
    NSFetchedResultsController *_fetchedresultsController;
    UITableView *_tableview;//聊天记录tableview
    UIView *_inputBar;//信息输入条
    UITextField *_txtMsg;//信息输入框
    UIButton *_btnvolice;//语音按钮
    UIButton *_btnspeak;//按住说话按钮
    UIButton *_btnexpression;//表情按钮
    UIButton *_btnFile;//添加文件按钮
    UIImage *_keyboardimgnor;//小键盘图标（普通状态）
    UIImage *_keyboardimgpress;//小键盘图标（被点击状态）
    HCEmojiInputView *_emojiInputView;//表情输入视图
    HCFileInputView *_fileInputView;//文件输入视图
    HCLocationTool *_locationtool;//定位工具
    MBProgressHUD *_locationhub;//定位加载动画
}
@end

@implementation HCChatController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self setLayout];
    
    //设置title
    self.title=[NSString stringWithFormat:@"%@\n在线",_user.jidStr];
    
    //监听键盘位置即将改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //初始化查询控制器
    [self setUpfectchresultControllser];
    
    //点击表格时，关闭键盘
    [_tableview addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)]];
    
    //初始化键盘小图标
    _keyboardimgnor=[UIImage imageNamed:@"chat_bottom_keyboard_nor.png"];
    _keyboardimgpress=[UIImage imageNamed:@"chat_bottom_keyboard_press.png"];
    
    //初始化定位工具并设置代理
    _locationtool=[HCLocationTool sharedHCLocationTool];
    _locationtool.delegate=self;
    
}

#pragma mark 设置界面布局
-(void)setLayout
{
    
    CGFloat start_y=0;
    //1添加tableView
    UIButton *buton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buton.frame=CGRectMake(40, 50, 100, 40);
    [self.view addSubview:buton];
    //tableview的高度=控制器高度-起始位置-输入视图高度-导航栏的高度，如果是IOS7则还需要减去20个状态栏高度
    CGFloat tableview_h=kselfviewsize.height-start_y-kInputBarHeight-44;
    if (IOS7_OR_LATER) {
        tableview_h-=20;
    }
     _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, start_y, kselfviewsize.width, tableview_h) style:UITableViewStylePlain];
    //取消分割线
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    //设置聊天背景图片
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage resizedImage:@"login_bg.jpg"]];
    _tableview.backgroundView=view;
   _tableview.alwaysBounceVertical=YES;
    [self.view addSubview:_tableview];
    CGFloat max_y=CGRectGetMaxY(_tableview.frame);
    //2添加输入条 输入条高度为44
    _inputBar=[[UIView alloc]initWithFrame:CGRectMake(0, max_y, kselfviewsize.width, kInputBarHeight)];
    _inputBar.backgroundColor=kGetColorRGB(232, 231, 235);
    [self.view addSubview:_inputBar];
    //2.1 添加语音按钮，输入框，表情按钮，文件按钮 每个小按钮的宽高为34，距离底部和顶部距离为4
    //第一个按钮距离左边距离为20，最后一个按钮距离右边屏幕距离为20，按钮直接距离为5
    CGFloat margin_y=4;
    CGFloat margin_x=5;
    CGFloat panding=1;
    CGFloat size=34;
    
    //2.2添加语音按钮
    _btnvolice=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnvolice.frame=CGRectMake(margin_x, margin_y,size,size);
    [_btnvolice setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_nor.png"] forState:UIControlStateNormal];
    [_btnvolice setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_press.png"] forState:UIControlStateHighlighted];
    [_btnvolice addTarget:self action:@selector(btnvoliceclick:) forControlEvents:UIControlEventTouchUpInside];
    [_inputBar addSubview:_btnvolice];
    
    //2.3添加输入框
    CGFloat max_x=CGRectGetMaxX(_btnvolice.frame)+panding;
    _txtMsg=[[UITextField alloc]init];
    _txtMsg.frame=CGRectMake(max_x, margin_y, kselfviewsize.width-(margin_x*2+panding*2)-3*size, size);
    _txtMsg.delegate=self;
    _txtMsg.borderStyle=UITextBorderStyleRoundedRect;
    _txtMsg.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [_inputBar addSubview:_txtMsg];
    
    //2.4添加按住说话按钮
    _btnspeak=[UIButton buttonWithType:UIButtonTypeCustom];
    [_btnspeak setTitle:@"按住说话" forState:UIControlStateNormal];
    _btnspeak.titleLabel.font=kFont(15);
    [_btnspeak setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_btnspeak addTarget:self action:@selector(btnspeakclick:) forControlEvents:UIControlEventTouchUpInside];
    _btnspeak.frame=_txtMsg.frame;
    _btnspeak.hidden=YES;
    [_inputBar addSubview:_btnspeak];
    
    //2.5添加表情按钮
    max_x=CGRectGetMaxX(_txtMsg.frame)+panding;
    _btnexpression=[UIButton buttonWithType:UIButtonTypeCustom];
    [_btnexpression setBackgroundImage:[UIImage imageNamed:@"chat_bottom_smile_nor.png"] forState:UIControlStateNormal];
    [_btnexpression setBackgroundImage:[UIImage imageNamed:@"chat_bottom_smile_press.png"] forState:UIControlStateHighlighted];
    _btnexpression.frame=CGRectMake(max_x, margin_y, size, size);
    [_btnexpression addTarget:self action:@selector(btnexpressionclick:) forControlEvents:UIControlEventTouchUpInside];
    [_inputBar addSubview:_btnexpression];
    
    //2.6添加发送文件按钮
    max_x=CGRectGetMaxX(_btnexpression.frame)+panding;
    _btnFile=[UIButton buttonWithType:UIButtonTypeCustom];
    [_btnFile setBackgroundImage:[UIImage imageNamed:@"chat_bottom_up_nor.png"] forState:UIControlStateNormal];
    [_btnFile setBackgroundImage:[UIImage imageNamed:@"chat_bottom_up_press.png"] forState:UIControlStateHighlighted];
    [_btnFile addTarget:self action:@selector(btnFileclick:) forControlEvents:UIControlEventTouchUpInside];
    _btnFile.frame=CGRectMake(max_x, margin_y, size, size);
    [_inputBar addSubview:_btnFile];

    
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
    CGRect inputbarframe=_inputBar.frame;
    CGRect tableviewframe=_tableview.frame;
    //记录输入视图的初始位置
    inputbarframe.origin.y=kselfviewsize.height-kInputBarHeight;
    tableviewframe.origin.y=0;
    //键盘的目标位置
    CGRect keyboardframe=[nofification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //动画时长
    CGFloat duration=[nofification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    
    //如果键盘的y等于屏幕的总高度，则表示键盘将要隐藏，设置输入视图距离底部距离为0
    if(keyboardframe.origin.y==[UIScreen mainScreen].bounds.size.height)
    {
        inputbarframe.origin.y=kselfviewsize.height-kInputBarHeight;
        tableviewframe.origin.y=0;
    }
    else
    {
        inputbarframe.origin.y -=keyboardframe.size.height;
        tableviewframe.origin.y-=keyboardframe.size.height;
    }

    //动画展现输入框位置
    [UIView animateWithDuration:duration animations:^{
        _inputBar.frame=inputbarframe;
        _tableview.frame=tableviewframe;
    }];

}

#pragma mark UITableView代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> info=_fetchedresultsController.sections[section];
    return [info numberOfObjects];
}

#pragma mark 获取行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPMessageArchiving_Message_CoreDataObject *message=[_fetchedresultsController objectAtIndexPath:indexPath];
    //计算文字宽高 需要和HCChatCell方法一致
    CGSize msgsize=[message.body sizeWithFont:kFont(15) constrainedToSize:CGSizeMake(180, MAXFLOAT)];
    CGFloat height=msgsize.height+40;
    if(height<kbuttonHeight)
        height=kbuttonHeight;
    //行高再加10个距离，为了与输入视图有一定的距离
    height +=10;
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"CELL";
    //提取消息
    XMPPMessageArchiving_Message_CoreDataObject *message=[_fetchedresultsController objectAtIndexPath:indexPath];
    
    HCChatCell *cell=nil;
    if(cell==nil)
        cell=[[HCChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.isOutgoing=message.isOutgoing;
    //设置头像
    XMPPJID *jid=kmyJid;
    //是否用户自己发送的信息
    if(!message.isOutgoing)
        jid=message.bareJid;
    [cell setPhoto:[UIImage imageWithData:[kAppdelegate.xmppvCardAvatarModule photoDataForJID:jid]]];
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
    if(_txtMsg.text.length>0)
    {
        NSString *msgstr=_txtMsg.text;
        [self sendMsgWithStr:msgstr];
        _txtMsg.text=@"";
    }
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

#pragma mark 输入一个表情
-(void)EmojiInputViewSelectItem:(NSString *)string
{
    _txtMsg.text=[_txtMsg.text stringByAppendingString:string];
    NSRange range=_txtMsg.selectedRange;
//    int length=string.length;
//    //当前光标位置
//    NSRange range=_txtMsg.selectedRange;
//    //将输入框内容字符串转变成可变字符串
//    NSMutableString *inputstr=[NSMutableString stringWithString:_txtMsg.text];
//    //在光标出插入表情
//    [inputstr insertString:string atIndex:range.location*2];
//    _txtMsg.text=inputstr;
//    //设置光标位置
//    [_txtMsg setSelectedRange:NSMakeRange((range.location*2)+1, 0)];
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
        NSRange delrange=NSMakeRange(range.location-2, 2);
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
