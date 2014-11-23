//
//  HCRegisterController.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-22.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCRegisterInfoController : UIViewController

/**
 完成按钮
 */
- (IBAction)flnish:(id)sender;

/**
 设置头像
 */
@property (weak, nonatomic) IBOutlet UIButton *btnphoto;

/**
 头像按钮被点击
 */
-(IBAction)btnphotoclick:(id)sender;

/**
 设置性别按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btnsex;


/**
 设置生日
 */
@property (weak, nonatomic) IBOutlet UITextField *txtbday;


@end
