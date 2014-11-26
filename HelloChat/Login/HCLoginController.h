//
//  HCLoginController.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-1.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCLoginUser;
@interface HCLoginController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;




/**
 注册方法
 */
- (IBAction)btnRegisterClick:(id)sender;

/**
 指定显示用户名和密码
 */
@property(nonatomic,strong) HCLoginUser *user;

@end
