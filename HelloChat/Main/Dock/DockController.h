//
//  MainController.h
//  WeiBo
//
//  Created by 叶根长 on 14-8-31.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DockItem;
#import "YGCNavController.h"
#define kDockHeigth 49
@interface DockController : UIViewController
{
    UIView *_dock;
}

@property(nonatomic,weak) DockItem *selecteditem;

@property(nonatomic,readonly) NSMutableArray *dockitems;

//根据title,图片名称创建dockitem
-(void)addDockItemWithtitle:(NSString *)title imgfornormal:(NSString *)imgfornormal imgforhightlight:(NSString *)imgforhightlight imgforselected:(NSString *)imgforselected;

//添加自定义dockitem
-(void)addDockItemWithView:(DockItem *)view;

-(void)addController:(UIViewController *)controller;

//当前选中的Controller
@property(nonatomic,strong) YGCNavController *selectController;

@end
