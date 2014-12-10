//
//  HCAppDelegate.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-1.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "HCAppDelegate.h"
#import "HCLoginController.h"
#import "HCMainController.h"
#import "RESideMenu.h"
#import "HCLeftMenuController.h"
#import "HCLoginUser.h"
#import "HCLoginUserTool.h"
#import "XMPPReconnect.h"
#import "XMPPvCardTemp.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPvCardTempModule.h"
#import "HCSoundTool.h"
#import "HCMessageDataTool.h"
#import "HCMessage.h"
@interface HCAppDelegate ()<XMPPvCardTempModuleDelegate,XMPPRosterDelegate,XMPPStreamDelegate>
{
    connectFailBlock _connectFialBlock;//连接失败调用的Block 包括连接，验证密码错误，都调用整个block
    connectSuccessBlock _connectSuccessBlock;//连接成功调用的Block
    
    XMPPReconnect *_xmppreconect;//网络断开后自动重新连接
    
    XMPPvCardCoreDataStorage *_vcardCoreDataStorage;//电子名片存储模块
    
    HCMainController *_mainController;//主控制器
    
    HCLoginController *_loginController;//登录控制器
    
    UINavigationController *_loginnav;//登录导航控制器
    
    XMPPCapabilities *_xmppcapabilities;//增强实体连接模块
    XMPPCapabilitiesCoreDataStorage *_xmppcapabilitiesStorage;//增强实体连接模块
}
@end

@implementation HCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _mainController=[[HCMainController alloc]init];
    //如果沙盒中有用户登录信息，则直接到主控制器，否则启动登录控制器
//    if([HCLoginUserTool sharedHCLoginUserTool].loginUser&&[HCLoginUserTool sharedHCLoginUserTool])
//        [self goMainController];
//    else
        [self goLoginController];
    
    //创建本地会话数据库
    [HCMessageDataTool sharedHCMessageDataTool];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark  前往登录控制器
-(void)goLoginController
{
    if(_loginController==nil)
    {
        _loginController=[[HCLoginController alloc]init];
        _loginnav=[[UINavigationController alloc]initWithRootViewController:_loginController];
    }
     self.window.rootViewController=_loginnav;
}

#pragma mark 前往主控制器(登录成功)
-(void)goMainController
{
    if(_mainController==nil)
    {
        //初始化主控制并且设置左边侧滑视图
//        _mainController=[[RESideMenu alloc]initWithContentViewController:[[HCMainController alloc]init] leftMenuViewController:[[HCLeftMenuController alloc]init] rightMenuViewController:nil];
//        //设置侧滑视图的背景图片
//        _mainController.backgroundImage=[UIImage imageNamed:@"Stars.png"];
        
    }
    //_mainController=[[HCMainController alloc]init];
    NSLog(@"%@",@"即将显示主界面");
    self.window.rootViewController=_mainController;
}

#pragma mark XMPP相关
-(void)setUpXmppStream
{
    if(_xmppStream==nil)
    {
        _xmppStream=[[XMPPStream alloc]init];
        
        // 让XMPP在真机运行时支持后台，在模拟器上是不支持后台服务运行的
#if !TARGET_IPHONE_SIMULATOR
        {
            // 允许XMPPStream在真机运行时，支持后台网络通讯！
            [_xmppStream setEnableBackgroundingOnSocket:YES];
        }
#endif
        
        //注册重连接模块
        _xmppreconect=[[XMPPReconnect alloc]init];
        
        //设置代理
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        
        //电子名片模块
        _vcardCoreDataStorage=[XMPPvCardCoreDataStorage sharedInstance];
        _xmppvCardTempModule=[[XMPPvCardTempModule alloc]initWithvCardStorage:_vcardCoreDataStorage];
        _xmppvCardAvatarModule=[[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_xmppvCardTempModule];
        //设置代理
        [_xmppvCardTempModule addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        
        //花名册
        _xmpprosterCoreDataStorage=[[XMPPRosterCoreDataStorage alloc]init];
        _xmppRoster=[[XMPPRoster alloc]initWithRosterStorage:_xmpprosterCoreDataStorage];
        //自动接收好友请阅请求 双向关注好友
        _xmppRoster.autoAcceptKnownPresenceSubscriptionRequests=YES;
        //自动更新好友信息（好友信息发送改变后会通知客户端）
        _xmppRoster.autoFetchRoster=YES;
        [_xmppRoster addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        
        //实体扩展模块
        _xmppcapabilitiesStorage =[[XMPPCapabilitiesCoreDataStorage alloc]init];
        _xmppcapabilities=[[XMPPCapabilities alloc]initWithCapabilitiesStorage:_xmppcapabilitiesStorage];
        _xmppUserCoreDataContext=_xmpprosterCoreDataStorage.mainThreadManagedObjectContext;
        //聊天记录模块
        _xmppmessageCoreDataStorage=[[XMPPMessageArchivingCoreDataStorage alloc]init];
        _xmppmessageArchiving=[[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_xmppmessageCoreDataStorage];
        
        //激活
        [_xmppreconect activate:_xmppStream];
        [_xmppvCardTempModule activate:_xmppStream];
        [_xmppvCardAvatarModule activate:_xmppStream];
        [_xmppRoster activate:_xmppStream];
        [_xmppcapabilities activate:_xmppStream];
        [_xmppmessageArchiving activate:_xmppStream];
    }

}

#pragma mark 开始连接服务器
-(void)connectWithFailBock:(connectFailBlock)failblock succsee:(connectSuccessBlock)successblock
{
    _connectFialBlock=failblock;
    _connectSuccessBlock=successblock;
    [self setUpXmppStream];
    [_xmppStream disconnect];
    
    if (![_xmppStream isConnected]) {
        XMPPJID *jid=nil;
        if(_isRegister&&_registerInfo)
            jid=[XMPPJID jidWithString:kAppendJid(_registerInfo.username)];
        else
            jid= [XMPPJID jidWithString:[HCLoginUserTool sharedHCLoginUserTool].loginUser.JID];
        [self.xmppStream setMyJID:jid];
        [self.xmppStream setHostName:kHostName];
        NSError *error = nil;
        [_xmppStream connectWithTimeout:1 error:&error];
        if(error&&_connectFialBlock)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
            _connectFialBlock(@"连接服务器出错,请检查网络是否启用");
            });
        }
    }
    
}

#pragma mark 验证密码
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSError *error = nil;
    if(_isRegister&&_registerInfo)
    {
        [self.xmppStream registerWithPassword:_registerInfo.password error:nil];
    }
    else
    {
        if (![self.xmppStream authenticateWithPassword:[HCLoginUserTool sharedHCLoginUserTool].loginUser.password error:&error]) {
            if(error&&_connectFialBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                _connectFialBlock(@"用户名或密码错误,请重新输入!");
                });
            }
        }
    }
}

#pragma mark 连接失败
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    if(_connectFialBlock&&error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        _connectFialBlock(@"连接失败!");
        });
    }
}

#pragma mark 密码验证失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    if(error&&_connectFialBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _connectFialBlock(@"用户名或密码错误!");
        });
    }
}

#pragma mark 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    NSLog(@"%@",error.stringValue);
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kRegisterFailNotiKey object:error];
}

#pragma mark 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender
{
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kRegisterSuccessNotiKey object:nil];
}

#pragma mark 验证完毕
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    BOOL islogined=[HCLoginUserTool sharedHCLoginUserTool].isLogined;
    if(!islogined)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self goMainController];
        });
        
    }
    //登录成功回调
    if(_connectSuccessBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _connectSuccessBlock();
        });
    }
    [HCLoginUserTool sharedHCLoginUserTool].isLogined=YES;
    [self goOnline];
}

#pragma mark 上线
-(void)goOnline
{
    NSLog(@"上线");
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [self.xmppStream sendElement:presence];
    
}

#pragma mark 播放音效
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"接受到新消息------%@",message);
    [[HCMessageDataTool sharedHCMessageDataTool] addNewMessage:message];
    //播放音效
    [[HCSoundTool sharedHCSoundTool] playNewMsgSound];
    
    UILocalNotification *noti=[[UILocalNotification alloc]init];
    noti.alertBody=message.body;
    noti.fireDate=[NSDate date];
    noti.applicationIconBadgeNumber=[UIApplication sharedApplication].applicationIconBadgeNumber+1;
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
}

#pragma mark 电子名片保存成功
-(void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule
{
    NSData *data=[_xmppvCardAvatarModule photoDataForJID:kmyJid];
    if(data)
    {
        NSLog(@"asd");
    }
    else if(vCardTempModule.myvCardTemp.photo)
    {
        data=vCardTempModule.myvCardTemp.photo;
    }
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidupdatevCard object:nil];
}

#pragma mark 电子名片保存失败
-(void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(DDXMLElement *)error
{
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kupdatevCardFaild object:nil];
}

#pragma mark 接收到用户展现(好友请求，上线，下线等)

-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    //如果是好友请求的展现
    if([presence.type isEqualToString:@"subscribe"])
    {
        XMPPJID *jid=presence.from;
        //接收请求
        [_xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    }
    else
    {
        NSLog(@"%@",presence);
    }
}

-(void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    NSLog(@"didReceivePresenceSubscriptionRequest---%@",presence);
}

#pragma mark 下线
-(void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
}

#pragma mark 断开连接
- (void)disconnect
{
    [self goOffline];
    [self.xmppStream disconnect];
}

// 销毁XMPPStream并注销已注册的扩展模块
- (void)teardownStream
{
    // 1. 删除代理
    [_xmppStream removeDelegate:self];
    // 2. 取消激活在setupStream方法中激活的扩展模块
    [_xmppreconect deactivate];
    [_xmppvCardTempModule deactivate];
    [_xmppvCardAvatarModule deactivate];
    [_xmppRoster deactivate];
    [_xmppcapabilities deactivate];
    [_xmppmessageArchiving deactivate];
    
    // 3. 断开XMPPStream的连接
    [_xmppStream disconnect];
    
    // 4. 内存清理
    _xmppStream = nil;
    _xmppreconect = nil;
    _xmppvCardTempModule = nil;
    _xmppvCardAvatarModule = nil;
    _vcardCoreDataStorage = nil;
    _xmppRoster=nil;
    _xmpprosterCoreDataStorage=nil;
    _xmppcapabilities=nil;
    _xmppcapabilitiesStorage=nil;
    _xmppmessageArchiving=nil;
    _xmppmessageCoreDataStorage=nil;
}

#pragma mark 当前窗口失去焦点，即将进入后台
- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

#pragma mark 程序进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
   
}

#pragma mark 即将进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

#pragma mark 重新获取焦点
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

//实例销毁
-(void)dealloc
{
    //销毁XMPP相关
    [self teardownStream];
}

@end
