//
//  HCRegisterController.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-22.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCRegisterNameController : UIViewController

/**
 用户名
 */
@property (weak, nonatomic) IBOutlet UITextField *txtusername;

/**
 昵称
 */
@property (weak, nonatomic) IBOutlet UITextField *txtnikiname;


- (IBAction)nextStep:(id)sender;

@end
