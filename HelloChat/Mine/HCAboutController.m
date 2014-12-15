//
//  HCAboutController.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-27.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCAboutController.h"

@interface HCAboutController ()

@end

@implementation HCAboutController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setLayout];
}

-(void)setLayout
{
    self.title=@"关于";
    
    self.view.backgroundColor=kGetColorRGB(235, 235, 241);
    
//    CGFloat start_y=20;
//    if(IOS7_OR_LATER)
//        start_y +=64;
//    UIImageView *logo=[[UIImageView alloc]init];
}

@end
