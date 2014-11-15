//
//  MainController.m
//  WeiBo
//
//  Created by 叶根长 on 14-8-31.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "DockController.h"
#import "DockItem.h"

@interface DockController ()
{
    
}
@end

@implementation DockController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIImageView *dockview=[[UIImageView alloc]init];
    dockview.userInteractionEnabled=YES;
    dockview.frame=(CGRect){0,self.view.frame.size.height-kDockHeigth,self.view.frame.size.width,kDockHeigth};
    UIImage *dockimg;
    dockimg=[UIImage imageNamed:@"tabbar_bg"];
    dockview.image=dockimg;
    _dock=dockview;
    //初始化dockitem数组
    _dockitems=[NSMutableArray arrayWithCapacity:5];
    [self.view addSubview:dockview];
    
}

//根据title,图片名称创建dockitem
-(void)addDockItemWithtitle:(NSString *)title imgfornormal:(NSString *)imgfornormal imgforhightlight:(NSString *)imgforhightlight imgforselected:(NSString *)imgforselected
{
    DockItem *item=[[DockItem alloc]init];
    [item setImage:[UIImage imageNamed:imgfornormal] forState:UIControlStateNormal];
    [item setImage:[UIImage imageNamed:imgforhightlight] forState:UIControlStateHighlighted];
    [item setImage:[UIImage imageNamed:imgforselected] forState:UIControlStateSelected];
    [item setTitle:title forState:UIControlStateNormal];
    [_dockitems addObject:item];
    [self setDockItemFrame];
}

//添加自定义dockitem
-(void)addDockItemWithView:(DockItem *)view
{
    [_dockitems addObject:view];
    [self setDockItemFrame];

}

//调整dockitem的大小和位置
-(void)setDockItemFrame
{
    for (int i=0; i<_dockitems.count; i++)
    {
        CGFloat w=UIScreen_Width/_dockitems.count;
        CGFloat h=kDockHeigth;
        CGFloat x=UIScreen_Width/_dockitems.count*i;
        CGFloat y=0;
        [_dockitems[i] setFrame:CGRectMake(x, y, w, h)];
        [_dock addSubview:_dockitems[i]];
        
        [_dockitems[i] addTarget:self action:@selector(dockItemClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //默认选中第一项
    if(_dockitems.count==1)
        [self dockItemClick:_dockitems[0]];
}

-(void)dockItemClick:(DockItem *)item
{
    _selecteditem.selected=NO;
    int oldindex=0;
    //点击前选中项的索引
    if(_selecteditem)
        oldindex=[_dockitems indexOfObject:_selecteditem];
    //当前点击的索引
    int newindex=[_dockitems indexOfObject:item];
    //设置选中项
    item.selected=YES;
    _selecteditem=item;
    
    if(self.childViewControllers.count>0)
    {
        UIViewController *oldcontroller=[self.childViewControllers objectAtIndex:oldindex];
        
        UIViewController *newcontroller=[self.childViewControllers objectAtIndex:newindex];
        
        // 0.移除旧控制器的view
        [oldcontroller.view removeFromSuperview];
        
        // 1.取出即将显示的控制器
        CGFloat width = self.view.frame.size.width;
        CGFloat height = self.view.frame.size.height - kDockHeigth;
        newcontroller.view.frame = CGRectMake(0, 0, width, height);
        
        // 2.添加新控制器的view到MainController上面
        [self.view addSubview:newcontroller.view];
        _selectController=(YGCNavController *)newcontroller;
    }
    
}


-(void)addController:(UIViewController *)controller
{
    [self addChildViewController:controller];
}


@end
