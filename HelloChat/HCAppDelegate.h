//
//  HCAppDelegate.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-1.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "XMPPvCardTempModule.h"
#import "XMPPRoster.h"
#import "HCRegisterInfo.h"
/**
 连接失败调用的Block
 */
typedef void (^connectFailBlock)(NSString *error);

/**
 连接成功调用的Block
 */
typedef void (^connectSuccessBlock)();

@interface HCAppDelegate : UIResponder <UIApplicationDelegate,XMPPStreamDelegate>

/**
 是否进入后台
 */
@property(nonatomic,assign) BOOL isbackground;

/**
 是否注册
 */
@property(nonatomic,assign) BOOL isRegister;

/**
 注册信息
 */
@property(nonatomic,strong) HCRegisterInfo *registerInfo;

/**
 xmpp
 */
@property(nonatomic,readonly) XMPPStream *xmppStream;

/**
电子名片
 */
@property(nonatomic,readonly) XMPPvCardTempModule *xmppvCardTempModule;

/**
 *  全局的XMPPvCardAvatar模块，处理头像
 */
@property (strong, nonatomic, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;

/**
 花名册
 */
@property(strong,nonatomic,readonly) XMPPRoster *xmppRoster;

/**
 花名册存储
 */
@property(nonatomic,strong,readonly) XMPPRosterCoreDataStorage *xmpprosterCoreDataStorage;

/**
 本地花名册数据库上下文
 */
@property(nonatomic,strong,readonly) NSManagedObjectContext *xmppUserCoreDataContext;

/**
 聊天记录模块
 */
@property(nonatomic,strong,readonly) XMPPMessageArchiving *xmppmessageArchiving;

/**
聊天记录存储模块
 */
@property(nonatomic,strong,readonly) XMPPMessageArchivingCoreDataStorage *xmppmessageCoreDataStorage;

/**
 连接
 */
-(void)connectWithFailBock:(connectFailBlock) failblock succsee:(connectSuccessBlock)successblock;

/**
 上线
 */
-(void)goOnline;

/**
 断开连接
 */
-(void)disconnect;

@property (strong, nonatomic) UIWindow *window;


@end
