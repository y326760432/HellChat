//
//  YGCNavController.m
//  WeiBo
//  创建统一样式的导航栏
//  Created by 叶根长 on 14-9-2.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "YGCNavController.h"

@interface YGCNavController ()

@end

@implementation YGCNavController



- (void)viewDidLoad
{
    [super viewDidLoad];
}

+(void)initialize
{
    UINavigationBar *navbar=[UINavigationBar appearance];
   
    NSString *imgstr=@"header_bg";
    if(IOS7_OR_LATER)
        imgstr=@"header_bg_ios7.png";
    [navbar setBackgroundImage:[UIImage imageNamed:imgstr] forBarMetrics:UIBarMetricsDefault];
    
    // 修改所有UIBarButtonItem的外观
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    
    // 修改item上面的文字样式
    NSDictionary *dict = @{
                           UITextAttributeTextColor : [UIColor whiteColor],
                           UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero],
                           };
    [barItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    navbar.titleTextAttributes=dict;
    
    
    if(!IOS7_OR_LATER)
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleBlackOpaque;
}

@end
