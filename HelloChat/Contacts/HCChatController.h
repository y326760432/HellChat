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
 没有键盘时信息输入框的底部距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keybordHiddenCts;

/**
 语音按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btnvolice;

/**
 语音按钮点击事件
 */
-(IBAction)btnvoliceclick:(id)sender;

/**
 按住说话按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btnspeak;


/**
按住说话按钮点击事件
 */
-(IBAction)btnspeakclick:(id)sender;

/**
 表情按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btnexpression;

/**
 表情按钮点击事件
 */
-(IBAction)btnexpressionclick:(id)sender;

/**
 添加文件按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btnFile;

/**
 添加文件按钮点击事件
 */
-(IBAction)btnFileclick:(id)sender;

@end
