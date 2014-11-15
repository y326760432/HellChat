//
//  HCSettingController.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-2.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftMenuDelegate <NSObject>

-(void)headerClick;

@end

@interface HCLeftMenuController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *haderView;

@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;

@property (weak, nonatomic) IBOutlet UILabel *labNikiName;

@property (weak, nonatomic) IBOutlet UIButton *btnLogOut;

@property(weak,nonatomic) id<LeftMenuDelegate> delegate;

@end
