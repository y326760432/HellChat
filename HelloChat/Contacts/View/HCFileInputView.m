//
//  HCFileInputView.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-22.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCFileInputView.h"
//按钮的宽和高
#define kButtonSize 50
//按钮个数
#define kButtonCount 3
//按钮间的垂直间距
#define kMargin_y (self.frame.size.height-kButtonSize)/2
@implementation HCFileInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置背景颜色
        self.backgroundColor=kGetColorRGB(232, 231, 235);
        //添加按钮
        [self addFileButton];
    }
    return self;
}

#pragma mark 创建文件按钮
-(void)addFileButton
{
    [self buildButtonWithImageName:@"aio_icons_pic" :nil :0 :@selector(imgLib)];
    [self buildButtonWithImageName:@"aio_icons_camera" :nil :1 :@selector(takephoto)];
    [self buildButtonWithImageName:@"aio_icons_location" :nil :2 :@selector(location)];
}

#pragma mark 根据图片创建文件按钮
-(UIButton *)buildButtonWithImageName:(NSString *)nor :(NSString *)hl :(int)index :(SEL)action
{
    CGFloat margin=(self.frame.size.width-(kButtonSize*kButtonCount))/(kButtonCount+1);
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake((index+1)*margin+index*kButtonSize, kMargin_y, kButtonSize, kButtonSize);
    [btn setBackgroundImage:[UIImage imageNamed:nor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:hl] forState:UIControlStateHighlighted];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

#pragma mark 图片库
-(void)imgLib
{
    if (_delegate&&[_delegate respondsToSelector:@selector(FileInputViewImgLib:)]) {
        [_delegate FileInputViewImgLib:self];
    }
}

#pragma mark 拍照
-(void)takephoto
{
    if (_delegate&&[_delegate respondsToSelector:@selector(FileInputViewTakePhoto:)]) {
        [_delegate FileInputViewTakePhoto:self];
    }
}

#pragma mark 位置
-(void)location
{
    if (_delegate&&[_delegate respondsToSelector:@selector(FileInputViewLocation:)]) {
        [_delegate FileInputViewLocation:self];
    }
}

#pragma mark 固定输入视图高度
-(void)setFrame:(CGRect)frame
{
    frame.size.height=100;
    [super setFrame:frame];
}

@end
