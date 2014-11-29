//
//  HCChatController.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-15.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMPPUserCoreDataStorageObject;
@interface HCChatController : UIViewController

/**
 用户信息
 */
@property(nonatomic,strong) XMPPUserCoreDataStorageObject *user;


@end
