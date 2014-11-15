//
//  HCAddContactController.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-11.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCAddContactController : UIViewController

/**
 用户名输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *txtuserid;

/**
 发送邀请
 */
-(IBAction)sendInvite;

@end
