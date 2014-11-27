//
//  HCPersonalController.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-5.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCVCardController.h"
#import "RESideMenu.h"
#import "HCMainController.h"
#import "XMPPvCardTempModule.h"
#import "HCAppDelegate.h"
#import "XMPPvCardTemp.h"
#import "HCLoginUserTool.h"
#import "HCLoginUser.h"
#import "HCEditVCardController.h"
#import "HCAlertDialog.h"
#import "NSDate+YGCCategory.h"
#import "NSString+YGCCategory.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
/**
 电子名片静态行模型
 */
@interface VCardCellData : NSObject

@property(nonatomic,weak) UITableViewCell *cell;

@property(nonatomic,strong) NSIndexPath *indexpath;

@end

@implementation VCardCellData



@end

@interface HCVCardController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MJRefreshBaseViewDelegate>
{
    NSArray *_cellHeaders;//列头名称数组
    
    NSArray *_cellHeaderLabels;//列头Labels数组
    
    MJRefreshHeaderView *_headerview;//下来刷新控件
    
    MBProgressHUD *_hub;
    
    BOOL isviewload;
}
@end

@implementation HCVCardController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.backgroundColor=[UIColor redColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUI];
    isviewload=YES;
    
}

-(void)setUI
{
    self.title=@"我的名片";
    
    self.navigationItem.leftBarButtonItem.title=@"返回";
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(updatevCard)];
    
    //设置头像圆角
    _imgvphoto.layer.masksToBounds=YES;
    _imgvphoto.layer.cornerRadius=40;

    
    //设置头像点击事件
    [_imgvphoto addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setPhoto)]];
    
    //下载个人名片数据
    [self getvCard];
    
    //初始化列头数组
    _cellHeaders=@[@[@"昵称",@"性别"],@[@"生日"]];
    _cellHeaderLabels=@[@[_labcellnikiname,_labsex],@[_labbday]];
    
    //注册电子名片更新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSuccess) name:kdidupdatevCard object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFaild) name:kupdatevCardFaild object:nil];
    NSLog(@"%@",NSStringFromCGRect(self.tableView.frame));
}

#pragma mark 获取电子名片
-(void)getvCard
{
    XMPPvCardTemp *myvcard=kAppdelegate.xmppvCardTempModule.myvCardTemp;
    if(myvcard==nil)
        myvcard=[XMPPvCardTemp vCardTemp];
    NSLog(@"%@",kmyJidStr);
    //设置JID
    myvcard.jid=kmyJid;
    // 更新或保存电子名片(异步操作，通过通知回调进行后续处理)
    [kAppdelegate.xmppvCardTempModule updateMyvCardTemp:myvcard];
    [self setInfo];
    _hub=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hub.dimBackground=YES;
}

#pragma mark 保存名片信息
-(void)updatevCard
{
  XMPPvCardTemp *myvcard=kAppdelegate.xmppvCardTempModule.myvCardTemp;
    NSLog(@"%@",[HCLoginUserTool sharedHCLoginUserTool].loginUser.JID);
    myvcard.name=_labcellnikiname.text;//昵称
    myvcard.prefix=_labsex.text;//性别
    //生日
    if(_labbday.text.length>0)
    {
        NSDateFormatter *formater=[[NSDateFormatter alloc]init];
        formater.dateFormat=@"yyyy-MM-dd";
        NSDate *date=[formater dateFromString:_labbday.text];
        myvcard.bday=date;
    }
    else
        myvcard.bday=nil;
    myvcard.photo=UIImagePNGRepresentation(_imgvphoto.image);
    [kAppdelegate.xmppvCardTempModule updateMyvCardTemp:myvcard];
    _hub=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hub.dimBackground=YES;
}

#pragma 更新成功
-(void)updateSuccess
{
     dispatch_async(dispatch_get_main_queue(), ^{
        _hub.hidden=YES;
         [self setInfo];
        ;});
    
}

#pragma mark 设置用户信息
-(void)setInfo
{
    XMPPvCardTemp *myvcard=kAppdelegate.xmppvCardTempModule.myvCardTemp;
    NSData *data=[kAppdelegate.xmppvCardAvatarModule photoDataForJID:kmyJid];
    if (data) {
        _imgvphoto.image=[UIImage imageWithData:data];//头像
    }
    else if(myvcard.photo)
    {
        _imgvphoto.image=[UIImage imageWithData:myvcard.photo];//头像
    }
    
    _labusername.text=[HCLoginUserTool sharedHCLoginUserTool].loginUser.username;
    _labcellnikiname.text=myvcard.name;//昵称
    _labnikiname.text=myvcard.name;//昵称
    _labsex.text=myvcard.prefix;//性别
    _labbday.text=[myvcard.bday toStringWithFormater:@"yyyy-MM-dd"];//生日
}

#pragma mark 更新失败
-(void)updateFaild
{
     dispatch_sync(dispatch_get_main_queue(), ^{
         _hub.hidden=YES;
         
     });
}


#pragma mark 设置头像
-(void)setPhoto
{
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"打开相册", nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

#pragma mark 设置头像按钮点击后调用事件
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self localPhoto];
            break;
        default:
            break;
    }
}

#pragma mark 打开相机拍照
-(void)takePhoto
{
    //检查相机模式是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [HCAlertDialog showDialog:@"没有可用的拍照设备"];
        return;
    }
    UIImagePickerController *imgcontroller=[[UIImagePickerController alloc]init];
    imgcontroller.sourceType=UIImagePickerControllerSourceTypeCamera;
    imgcontroller.delegate=self;
    imgcontroller.allowsEditing=YES;
    [self presentViewController:imgcontroller animated:YES completion:^{
        
    }];
}

#pragma mark 本地相册
-(void)localPhoto
{
    UIImagePickerController *imgcontroller=[[UIImagePickerController alloc]init];
    imgcontroller.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    imgcontroller.delegate=self;
    imgcontroller.allowsEditing=YES;
    [self presentViewController:imgcontroller animated:YES completion:^{
        
    }];
}

#pragma mark 选择照片后调用的通知
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img=info[@"UIImagePickerControllerEditedImage"];
    
    _imgvphoto.image=img;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableView代理方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section>0)
    {
        self.navigationController.navigationBar.hidden=NO;
        [self performSegueWithIdentifier:@"editvCardElement" sender:indexPath];
    }
}

#pragma mark 跳转到编辑界面
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath *)indexpath
{
    if([segue.destinationViewController isKindOfClass:[HCEditVCardController class]])
    {
        HCEditVCardController *controller=(HCEditVCardController *)segue.destinationViewController;
        NSString *title=@"";
        UILabel *lab=nil;
        if(indexpath.section==1)
        {
            if(indexpath.row==1)
            {
                title=@"昵称";
                lab=_labcellnikiname;
            }
            else if(indexpath.row==2)
            {
                title=@"性别";
                lab=_labsex;
            }
            
        }
        else if(indexpath.section==2)
        {
            if(indexpath.row==0)
            {
                title=@"生日";
                lab=_labbday;
            }
        }
        if(title.length>0)
        {
            controller.title=[NSString stringWithFormat:@"编辑%@",title];
        }
        controller.content=lab;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 0.0001;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
