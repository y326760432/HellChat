//
//  HCPersonalController.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-5.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCPersonalController.h"
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
#import "MJRefresh.h"
/**
 电子名片静态行模型
 */
@interface VCardCellData : NSObject

@property(nonatomic,weak) UITableViewCell *cell;

@property(nonatomic,strong) NSIndexPath *indexpath;

@end

@implementation VCardCellData



@end

@interface HCPersonalController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MJRefreshBaseViewDelegate>
{
    NSArray *_cellHeaders;//列头名称数组
    
    NSArray *_cellHeaderLabels;//列头Labels数组
    
    UIActivityIndicatorView *_indictatorview;//加载动画
    
    MJRefreshHeaderView *_headerview;//下来刷新控件
}
@end

@implementation HCPersonalController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUI];
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
    
    //加载动画
    _indictatorview=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indictatorview.center=self.view.center;
    [self.view addSubview:_indictatorview];
    
    //让设置tableview距离底部距离-20 全屏效果
//    self.tableView.contentInset=UIEdgeInsetsMake(-35, 0, 0, 0);
    
    //设置头像点击事件
    [_imgvphoto addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setPhoto)]];
    
    //下载个人名片数据
    [self performSelectorInBackground:@selector(getvCard) withObject:nil];
    
    //初始化列头数组
    _cellHeaders=@[@[@"昵称",@"性别",@"所在地",@"简介"],@[@"生日",@"邮件",@"手机"]];
    _cellHeaderLabels=@[@[_labcellnikiname,_labsex,_labcity,_labdescribe],@[_labbday,_labmail,_labphone]];
    
    //注册电子名片更新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSuccess) name:kdidupdatevCard object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFaild) name:kupdatevCardFaild object:nil];
    NSLog(@"%@",NSStringFromCGRect(self.tableView.frame));
}

#pragma mark 获取电子名片
-(void)getvCard
{
     [_indictatorview startAnimating];
   XMPPvCardTemp *myvcard=kAppdelegate.xmppvCardTempModule.myvCardTemp;
    if(myvcard==nil)
        myvcard=[XMPPvCardTemp vCardTemp];
     XMPPJID *jid=[XMPPJID jidWithString:[HCLoginUserTool sharedHCLoginUserTool].loginUser.JID];
    //设置JID
    myvcard.jid=jid;
    // 更新或保存电子名片
    [kAppdelegate.xmppvCardTempModule updateMyvCardTemp:myvcard];
    
    NSLog(@"jid:%@ nickname:%@ sex:%@ city:%@ title:%@ bday:%@ mail:%@ phone%@",myvcard.jid,myvcard.nickname,myvcard.prefix,myvcard.role,myvcard.title,myvcard.bday,myvcard.mailer,myvcard.suffix);
    
    NSData *data=[kAppdelegate.xmppvCardAvatarModule photoDataForJID:jid];
    if (data) {
        _imgvphoto.image=[UIImage imageWithData:data];//头像
    }
    else if(myvcard.photo)
    {
        _imgvphoto.image=[UIImage imageWithData:myvcard.photo];//头像
    }
    _labcellnikiname.text=myvcard.nickname;//昵称
    _labnikiname.text=myvcard.nickname;//昵称
    _labsex.text=myvcard.prefix;//性别
    _labcity.text=myvcard.role;//所在地
    _labdescribe.text=myvcard.title;//简介
    _labbday.text=[myvcard.bday toStringWithFormater:@"yyyy-MM-dd"];//生日
    _labmail.text=myvcard.mailer;//邮件
    _labphone.text=myvcard.suffix;//电话
    
}

#pragma mark 保存名片信息
-(void)updatevCard
{
  XMPPvCardTemp *myvcard=kAppdelegate.xmppvCardTempModule.myvCardTemp;
    [_indictatorview startAnimating];
    myvcard.nickname=_labcellnikiname.text;//昵称
    myvcard.prefix=_labsex.text;//性别
    myvcard.role=_labcity.text;//所在地
    myvcard.title=_labdescribe.text;//简介
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
    
    myvcard.mailer=_labmail.text;//邮件
    myvcard.photo=UIImagePNGRepresentation(_imgvphoto.image);
    myvcard.suffix=_labphone.text;
    [kAppdelegate.xmppvCardTempModule updateMyvCardTemp:myvcard];
}

#pragma 更新成功
-(void)updateSuccess
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [_indictatorview stopAnimating];
    });
    
}

#pragma mark 更新失败
-(void)updateFaild
{
     dispatch_sync(dispatch_get_main_queue(), ^{
         [_indictatorview stopAnimating];
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
    if(indexPath.section>0)
    {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        self.navigationController.navigationBar.hidden=NO;
        VCardCellData *data=[[VCardCellData alloc]init];
        data.cell=cell;
        data.indexpath=indexPath;
        [self performSegueWithIdentifier:@"editvCardElement" sender:data];
    }
}

#pragma mark 跳转到编辑界面
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(VCardCellData*)sender
{
    if([segue.destinationViewController isKindOfClass:[HCEditVCardController class]])
    {
        HCEditVCardController *controller=(HCEditVCardController *)segue.destinationViewController;
        controller.title=[NSString stringWithFormat:@"编辑%@",_cellHeaders[sender.indexpath.section-1][sender.indexpath.row]];
        controller.content=_cellHeaderLabels[sender.indexpath.section-1][sender.indexpath.row];
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
