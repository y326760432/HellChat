//
//  HCXMPPUserTool.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-29.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@class XMPPJID;
@class XMPPUserCoreDataStorageObject;
@interface HCXMPPUserTool : NSObject

singleton_interface(HCXMPPUserTool)

/**
 获取显示名称
 */
-(NSString *)getDisplayNameWithUser:(XMPPUserCoreDataStorageObject *)user;

/**
 加载用户头像，如果没有，则显示默认头像
 */
-(UIImage *)loaduserPhotoWithUser:(XMPPUserCoreDataStorageObject *)user;

/**
 根据JID加载用户头像，没有则显示默认头像
 */
-(UIImage *)loaduserPhotoWithJid:(NSString *)jid;

/**
 根据JID查找用户信息
 */
+(XMPPUserCoreDataStorageObject *)getUserCoreDataObjectWithJidStr:(NSString *)jidstr;
@end
