//
//  HCMainController.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-2.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCMainController.h"
#import "HCLeftMenuController.h"
#import "HCMessageController.h"
#import "HCContactsController.h"
#import "HCDynamicController.h"
#import "YGCNavController.h"
#import "HCLoginUserTool.h"
#import "HCAppDelegate.h"
#import "HCAlertDialog.h"
#import "HCMineController.h"
@interface HCMainController ()<UINavigationControllerDelegate>
{
    UIActivityIndicatorView *_indicator;//记载动画
}
@end

@implementation HCMainController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    

    //消息
    YGCNavController *message=[[YGCNavController alloc]initWithRootViewController:
                               [[HCMessageController alloc]init]];
    message.delegate=self;
    //联系人
    YGCNavController *contact=[UIStoryboard storyboardWithName:@"HCContactsController" bundle:nil].instantiateInitialViewController;
    contact.delegate=self;
    
    //我
    YGCNavController *mine=[[YGCNavController alloc]initWithRootViewController: [UIStoryboard storyboardWithName:@"HCMineController" bundle:nil].instantiateInitialViewController];
    mine.delegate=self;
    
    [self addController:message];
    [self addController:contact];
    [self addController:mine];
    
    [self addDockItemWithtitle:@"消息" imgfornormal:@"tab_recent_nor" imgforhightlight:@"tab_recent_press" imgforselected:@"tab_recent_press"];
     [self addDockItemWithtitle:@"联系人" imgfornormal:@"tab_buddy_nor.png" imgforhightlight:@"tab_buddy_press.png" imgforselected:@"tab_buddy_press.png"];
     [self addDockItemWithtitle:@"我" imgfornormal:@"tab_qworld_nor.png" imgforhightlight:@"tab_qworld_press.png" imgforselected:@"tab_qworld_press.png"];
    
    _indicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.center=self.view.center;
    [self.view addSubview:_indicator];
    //[self connect];
    
    
  
}

#pragma mark 导航控制器代理方法

/*
 将要显示导航视图
 */
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //取出当前导航控制器中的根控制器
    UIViewController *rootnv=navigationController.childViewControllers[0];
    if(viewController!=rootnv)
    {
        
        CGRect viewfarme=navigationController.view.frame;
        if(IOS7_OR_LATER)
            viewfarme.size.height=UIScreen_Heigth;
        else
            viewfarme.size.height=[[UIScreen mainScreen] applicationFrame].size.height;
        navigationController.view.frame=viewfarme;
        [_dock removeFromSuperview];
        
        CGRect dockframe=_dock.frame;
        dockframe.origin.y=rootnv.view.frame.size.height-kDockHeigth;
        //如果根控制器是UIScrollView,则要计算UISCrollView.contentOffset, 超出内容的高度
        if([rootnv.view isKindOfClass:[UIScrollView class]])
        {
            dockframe.origin.y +=((UIScrollView *)rootnv.view).contentOffset.y;
        }
        _dock.backgroundColor=[UIColor whiteColor];
        _dock.frame=dockframe;
        [rootnv.view addSubview:_dock];
        
        
    }
}

/*
 已经显示完成导航视图
 */
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *rootnv=navigationController.childViewControllers[0];
    if(viewController==rootnv)
    {
        //还原导航控制器的高度
        CGRect navframe=navigationController.view.frame;
        if(IOS7_OR_LATER)
            navframe.size.height=UIScreen_Heigth-kDockHeigth;
        else
            navframe.size.height=[[UIScreen mainScreen] applicationFrame].size.height-kDockHeigth;
        navigationController.view.frame=navframe;
        
        //从子页面中移除dock
        [_dock removeFromSuperview];
        
        CGRect dockframe=_dock.frame;
        dockframe.origin.y=self.view.frame.size.height-kDockHeigth;
        _dock.frame=dockframe;
        [self.view addSubview:_dock];
        
    }
}
//-(void)connect
//{
//    [_indicator startAnimating];
//    [kAppdelegate connectWithFailBock:^(NSString *error) {
//        [_indicator stopAnimating];
//        [HCAlertDialog showDialog:error];
//    } succsee:^{
//        [_indicator stopAnimating];
//        
//        [self getVCard];
//    }];
//}

-(void)getVCard
{
   XMPPvCardTemp *vcard=kAppdelegate.xmppvCardTempModule.myvCardTemp;
    if (vcard) {
        
    }
    
}

@end
