//
//  HCChatCell.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-16.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCChatCell.h"
#import "HCRoundImageView.h"
#import "UIImage+YGCCategory.h"

@interface HCChatCell ()
{
    UIImage *_send_norimg;//发送信息默认状态的背景
    UIImage *_send_pressimg;//发送信息点击后状态背景
    UIImage *_recive_norimg;//接收信息默认状态背景
    UIImage *_recive_pressimg;//接受信息点击后状态背景
}
@end

@implementation HCChatCell

- (void)awakeFromNib
{
    _photoimgv.layer.masksToBounds=YES;
    _photoimgv.layer.cornerRadius=25;
    //创建聊天信息背景图片
   _send_norimg=[UIImage resizedImage:@"chat_send_nor.png"];
    _send_pressimg=[UIImage resizedImage:@"chat_send_press_pic.png"];
    _recive_norimg=[UIImage resizedImage:@"chat_recive_nor.png"];
    _recive_pressimg=[UIImage resizedImage:@"chat_recive_press_pic.png"];
    //设置行的背景颜色为透明色
    self.backgroundColor=[UIColor clearColor];
    
    //设置选择行时背景色为透明色
    UIView *selectview=[[UIView alloc]initWithFrame:self.frame];
    selectview.backgroundColor=[UIColor clearColor];
    self.selectedBackgroundView=selectview;
}

-(void)setMessage:(NSString *)msg
{
    [_msgbutton setTitle:msg forState:UIControlStateNormal];
    
    //计算文字宽高
    CGSize msgsize=[msg sizeWithFont:kFont(14) constrainedToSize:CGSizeMake(180, MAXFLOAT)];
    
    _msgbuttonHeightCts.constant=msgsize.height+40;
    _msgbuttonWithCts.constant=msgsize.width+40>80?msgsize.width+40:80;
    
    //设置背景图片
    if(_isOutgoing)
    {
        [_msgbutton setBackgroundImage:_send_norimg forState:UIControlStateNormal];
        [_msgbutton setBackgroundImage:_send_pressimg forState:UIControlStateHighlighted];
    }
    else
    {
        [_msgbutton setBackgroundImage:_recive_norimg forState:UIControlStateNormal];
        [_msgbutton setBackgroundImage:_recive_pressimg forState:UIControlStateHighlighted];
    }
    [self layoutIfNeeded];
}

@end
