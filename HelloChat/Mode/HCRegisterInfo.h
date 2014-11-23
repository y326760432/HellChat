//
//  HCRegisterInfo.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-22.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCRegisterInfo : NSObject

/**
 用户名
 */
@property(nonatomic,copy) NSString *username;

/**
 密码
 */
@property(nonatomic,copy) NSString *password;

/**
 昵称
 */
@property(nonatomic,copy) NSString *nikiname;

/**
 性别
 */
@property(nonatomic,copy) NSString *sex;

/**
 所在地
 */
@property(nonatomic,copy) NSString *city;

@end
