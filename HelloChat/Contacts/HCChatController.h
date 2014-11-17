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

/**
 聊天记录tableview
 */
@property (weak, nonatomic) IBOutlet UITableView *tableview;

/**
 信息输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *txtMsg;

/**
 没有键盘时信息输入框的底部距离 因为约束移除后，又要添加回去，为了防止内存泄露，这里声明为strong
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keybordHiddenCts;


@end
