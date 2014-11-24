//
//  HCLoginUserTool.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-2.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@class HCLoginUser;
@interface HCLoginUserTool : NSObject

singleton_interface(HCLoginUserTool)

/**
 用户登录信息
 */
@property(nonatomic,strong) HCLoginUser *loginUser;

/**
 保存本地用户头像
 */
@property(nonatomic,strong) UIImage *userPhoto;
/**
 是否已经登录
 */
@property(nonatomic,assign) BOOL isLogined;


@end
