//
//  HCMineController.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-8.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCMineController.h"
#import "HCVCardController.h"
#import "UIImage+YGCCategory.h"
#import "HCLoginController.h"
#import "HCLoginUserTool.h"
#import "HCAppdelegate.h"
#import "HCAboutController.h"
@interface HCMineController ()
{
    NSArray *_datasource;//分组数据源
    
    UIButton *_btnlogout;//注销按钮
    
    UIView *_footview;//表格底部视图
    
    UISwitch *_switchsound;//是否开启通知声音
    
    UISwitch *_switchnoti;//是否发送通知

}
@end

@implementation HCMineController

-(id)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置数据源
     [self setData];
    //设置界面布局
    [self setLayout];
}

-(void)setData
{
    _datasource=@[@"个人资料",@"声音",@"通知",@"关于"];
}

-(void)setLayout
{
    self.title=@"我";
    
    //注销按钮
    _footview=[[UIView alloc]init];
    _footview.bounds=CGRectMake(0, 0,0, 60);
    _btnlogout=[UIButton buttonWithType:UIButtonTypeCustom];
    //拉伸按钮图片
    [_btnlogout setBackgroundImage:[UIImage resizedImage:@"common_button_red_nor.png"] forState:UIControlStateNormal];
    [_btnlogout setBackgroundImage:[UIImage resizedImage:@"common_button_red_pressed.png"] forState:UIControlStateHighlighted];
    [_btnlogout addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [_btnlogout setTitle:@"退出当前账号" forState:UIControlStateNormal];
    _btnlogout.frame=CGRectMake(10, 20, kselfviewsize.width-20, 40);
    [_footview addSubview:_btnlogout];
    
    //是否开启声音切换按钮
    _switchsound=[[UISwitch alloc]init];
    _switchsound.on=YES;
    //从系统偏好里读取设置
    if([[NSUserDefaults standardUserDefaults] objectForKey:kSoundUserDefaultKey])
    {
        _switchsound.on=(BOOL)[[NSUserDefaults standardUserDefaults] objectForKey:kSoundUserDefaultKey];
    }
    [_switchsound addTarget:self action:@selector(switchValueChage:) forControlEvents:UIControlEventValueChanged];
    
    //是否接受通知切换按钮
    _switchnoti=[[UISwitch alloc]init];
    _switchnoti.on=YES;
    if([[NSUserDefaults standardUserDefaults] objectForKey:kNotiUserDefaultKey])
    {
        _switchnoti.on=(BOOL)[[NSUserDefaults standardUserDefaults] objectForKey:kNotiUserDefaultKey];
    }
    [_switchnoti addTarget:self action:@selector(switchValueChage:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark 声音/通知值发生改变
-(void)switchValueChage:(UISwitch *)uiswitch
{
    if(uiswitch==_switchsound)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(uiswitch.on) forKey: kSoundUserDefaultKey];
    }
    else
        [[NSUserDefaults standardUserDefaults] setObject:@(uiswitch.on) forKey: kNotiUserDefaultKey];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _datasource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section==_datasource.count-1)
        return _footview;
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==_datasource.count-1) {
        return 60;
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"CELL";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil)
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    cell.textLabel.text=_datasource[indexPath.section];
    if(indexPath.section==1)
        cell.accessoryView=_switchsound;
    else if(indexPath.section==2)
        cell.accessoryView=_switchnoti;
    else
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

/**
 退出当前账号
 */
-(void)loginOut
{
    
    //设置登录标记
    [HCLoginUserTool sharedHCLoginUserTool].isLogined=NO;
    [kAppdelegate.xmppStream disconnect];
    //跳转到登录页面
    HCLoginController *login=[UIStoryboard storyboardWithName:@"HCLoginController" bundle:nil].instantiateInitialViewController;
    [UIApplication sharedApplication].keyWindow.rootViewController=login;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        HCVCardController *vcardcontroller=[UIStoryboard storyboardWithName:@"HCVCardController" bundle:nil].instantiateInitialViewController;
        [self.navigationController pushViewController:vcardcontroller animated:YES];
    }
    else if(indexPath.section==_datasource.count-1)
    {
        HCAboutController *about=[[HCAboutController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }
}

@end
