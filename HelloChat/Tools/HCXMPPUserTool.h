//
//  HCXMPPUserTool.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-29.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
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


@end
