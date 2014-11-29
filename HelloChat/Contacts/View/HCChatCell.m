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
#import <QuartzCore/QuartzCore.h>

#define kmargin_x 10 //每条消息距离Cell的左距离和右距离为10
#define kmargin_y 10 //每条消息距离Cell的顶部距离为10
#define kphoto_size 50 //头像大小
#define kcornerRadius kphoto_size*0.5 //头像圆角半径
@interface HCChatCell ()
{
    UIImageView *_photoimgv;//头像
    UIButton *_msgbutton;//消息内容
    UIImage *_send_norimg;//发送信息默认状态的背景
    UIImage *_send_pressimg;//发送信息点击后状态背景
    UIImage *_recive_norimg;//接收信息默认状态背景
    UIImage *_recive_pressimg;//接受信息点击后状态背景
}
@end

@implementation HCChatCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //添加头像
        _photoimgv=[[UIImageView alloc]init];
        _photoimgv.frame=CGRectMake(kmargin_x, kmargin_y,kphoto_size,kphoto_size);
        _photoimgv.layer.masksToBounds=YES;
        _photoimgv.image=[UIImage imageNamed:@"normalheadphoto.png"];
        _photoimgv.layer.cornerRadius=25;
        NSLog(@"%@",NSStringFromCGRect(_photoimgv.frame));
        [self.contentView addSubview:_photoimgv];
        
        //添加消息内容按钮
        _msgbutton=[UIButton buttonWithType:UIButtonTypeCustom];
        _msgbutton.frame=CGRectMake(kmargin_x+kphoto_size,kmargin_y, kbuttonWith, kbuttonHeight);
        _msgbutton.titleLabel.numberOfLines=0;
        _msgbutton.titleLabel.font=kFont(15);
        _msgbutton.titleEdgeInsets=UIEdgeInsetsMake(10, 20, 10,20);
        [_msgbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_msgbutton];
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
    return self;
}


-(void)setMessage:(NSString *)msg
{
    [_msgbutton setTitle:msg forState:UIControlStateNormal];
    
    //计算文字宽高
    CGSize msgsize=[msg sizeWithFont:_msgbutton.titleLabel.font constrainedToSize:CGSizeMake(180, MAXFLOAT)];
    
    CGRect btnframe=_msgbutton.frame;
    btnframe.size.width=msgsize.width+40;
    btnframe.size.height=msgsize.height+40;
    if(btnframe.size.width<kbuttonWith)
        btnframe.size.width=kbuttonWith;
    if(btnframe.size.height<kbuttonHeight)
        btnframe.size.height=kbuttonHeight;
    
    CGRect photoframe=_photoimgv.frame;
   
    //设置背景图片
    if(_isOutgoing)
    {
        //设置消息位置
        btnframe.origin.x=kselfsize.width-kmargin_x-kphoto_size-btnframe.size.width;
        //设置头像位置
        photoframe.origin.x=kselfsize.width-kmargin_x-kphoto_size;
        //自己发送的消息背景图片
        [_msgbutton setBackgroundImage:_send_norimg forState:UIControlStateNormal];
        [_msgbutton setBackgroundImage:_send_pressimg forState:UIControlStateHighlighted];
    }
    else
    {
        //设置消息位置
        btnframe.origin.x=kmargin_x+kphoto_size;
        //设置头像位置
        photoframe.origin.x=kmargin_x;
        //接收到的消息的背景图片
        [_msgbutton setBackgroundImage:_recive_norimg forState:UIControlStateNormal];
        [_msgbutton setBackgroundImage:_recive_pressimg forState:UIControlStateHighlighted];
    }
    _photoimgv.frame=photoframe;
    _msgbutton.frame=btnframe;
}

#pragma mark 设置头像
-(void)setPhoto:(UIImage *)photo
{
    if(photo)
        _photoimgv.image=photo;
    else
        _photoimgv.image=[UIImage imageNamed:@"normalheadphoto.png"];
}

@end
