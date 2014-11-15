//
//  HCEditVCardController.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-6.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCEditVCardController : UIViewController

@property(nonatomic,weak) UILabel *content;

@property (weak, nonatomic) IBOutlet UITextField *txtContent;
@end
