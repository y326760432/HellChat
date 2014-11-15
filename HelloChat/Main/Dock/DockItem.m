//
//  DockItem.m
//  WeiBo
//
//  Created by 叶根长 on 14-8-31.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "DockItem.h"
#import <QuartzCore/QuartzCore.h>
#define kImageHeight 30

@implementation DockItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置title的字体大小和颜色
        self.titleLabel.font=kFont(11);
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self setTitleColor:kGetColorRGB(0, 160, 255) forState:UIControlStateSelected];
        self.titleLabel.shadowColor=[UIColor clearColor];
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        
    }
    return self;
}

//重新设置图片的位置
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect rect=contentRect;
    //如果有设置文字，y的偏移量为3，否则设置图片居中
    if([self titleForState:UIControlStateNormal])
        rect.origin.y=5;
    else
        rect.origin.y=(self.frame.size.height-kImageHeight)/2;
    rect.origin.x=(rect.size.width-kImageHeight)/2;
    rect.size.width=kImageHeight;
    rect.size.height=kImageHeight;
    return rect;
}

//重新设置文字的位置
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect rect=contentRect;
    rect.origin.y=17;
    return rect;
}

-(void)setIconnumber:(int)Iconnumber
{
    
}

@end
