//
//  HCLoginUser.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-2.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCLoginUser : NSObject<NSCoding>

/**
 用户名
 */
@property(nonatomic,copy) NSString *username;

/**
 密码
 */
@property(nonatomic,copy) NSString *password;

/**
 JIP(带服务器名)
 */
@property(nonatomic,copy) NSString *JID;

/**
 已经注销
 */
@property(nonatomic,assign) BOOL logouted;

@end
