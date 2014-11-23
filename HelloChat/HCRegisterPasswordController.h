//
//  HCRegisterPasswordController.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-22.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCRegisterPasswordController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *txtpassword1;

@property (weak, nonatomic) IBOutlet UITextField *txtpassword2;


- (IBAction)nextStep:(id)sender;

@end
