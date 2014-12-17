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
#import "UIImageView+WebCache.h"
#import "HCMessageDataTool.h"
#import "HCHttpTool.h"
#import "HCFileTool.h"
#import "NSDate+YGCCategory.h"
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
    UIImageView *_imageview;
    UILabel *_labsendtime;
    XMPPMessageArchiving_Message_CoreDataObject *_msg;//消息内容
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
        [self.contentView addSubview:_photoimgv];
        
        _labsendtime=[[UILabel alloc]init];
        _labsendtime.tintColor=[UIColor grayColor];
        _labsendtime.font=kFont(9);
        _labsendtime.textAlignment=NSTextAlignmentCenter;
        _labsendtime.frame=CGRectMake(0, 0, kselfsize.width, 30);
        [self.contentView addSubview:_labsendtime];
        
        //添加消息内容按钮
        _msgbutton=[UIButton buttonWithType:UIButtonTypeCustom];
        _msgbutton.frame=CGRectMake(kmargin_x+kphoto_size,kmargin_y+10, kbuttonWith, kbuttonHeight);
        _msgbutton.titleLabel.numberOfLines=0;
        _msgbutton.titleLabel.font=kFont(15);
        _msgbutton.titleEdgeInsets=UIEdgeInsetsMake(10, 20, 10,20);
        [_msgbutton addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
        [_msgbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_msgbutton];
        
        _imageview=[[UIImageView alloc]init];
        _imageview.frame=CGRectMake(13, 10, 10, 20);
        _imageview.layer.masksToBounds=YES;
        _imageview.layer.cornerRadius=10;
        [_msgbutton addSubview:_imageview];
        
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


-(void)setMessage:(XMPPMessageArchiving_Message_CoreDataObject *)msg
{
    _msg=msg;
   __block CGRect btnframe=_msgbutton.frame;
    CGRect photoframe=_photoimgv.frame;
    _imageview.hidden=YES;
    HCMsgType msgtype=[[HCMessageDataTool sharedHCMessageDataTool]getMsgTypeWithMessage:_msg.body];
    if(msgtype>0)
    {
        //先恢复原始的frame
        _imageview.frame=CGRectMake(13, 10, 10, 20);
         _imageview.hidden=NO;
        //下载本地文件
        [[HCHttpTool sharedHCHttpTool]downLoadFileWithMessage:_msg.body];
        if(msgtype==HCMsgTypeIMAGE)
        {
            __block CGRect imgframe=_imageview.frame;
            //如果文件存储在本地，则显示本地图片资源
            if([[HCFileTool sharedHCFileTool] fileExistsWihtMsg:_msg.body])
            {
                NSString *savepath=[[HCFileTool sharedHCFileTool] getFileSavePathWithMsg:_msg.body];
                UIImage *image=[UIImage imageWithContentsOfFile:savepath];
                _imageview.image=image;
                if(image.size.height<100)
                    imgframe.size=image.size;
                else
                {
                    imgframe.size.height=image.size.height*0.5;
                    imgframe.size.width=image.size.width*0.5;
                }
                btnframe.size.width=imgframe.size.width+24;;
                btnframe.size.height=imgframe.size.height+20;
                _imageview.frame=imgframe;
                _msgbutton.frame=btnframe;
            }
            else
            {
                NSString *filename=[[HCMessageDataTool sharedHCMessageDataTool] getMsgFilename:msg.body];
                NSString *url=[NSString stringWithFormat:@"%@/%@/%@",kBaseUrl,kImageServerDirPath,filename];
                imgframe.size.height=100;
                imgframe.size.width=100;
                _imageview.frame=imgframe;
                __weak UIImageView *imageview=_imageview;
                __weak UIButton *button=_msgbutton;
                btnframe.size.width=imgframe.size.width+24;;
                btnframe.size.height=imgframe.size.height+30;
                [_imageview setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"chat_images_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                        imgframe.size.height=image.size.height*0.5;
                        imgframe.size.width=image.size.width*0.5;
                        imageview.frame=imgframe;
                        btnframe.size.width=imgframe.size.width+26;
                        btnframe.size.height=imgframe.size.height+30;
                        button.frame=btnframe;
                }];
            }
           
        }
        else
        {
            NSString *voiceimg=_isOutgoing?@"voice_send_icon_nor":@"voice_receive_icon_nor";
            CGRect imgrect=_imageview.frame;
            imgrect.size=CGSizeMake(24, 24);
            imgrect.origin.y=(_msgbutton.frame.size.height-24)/2;
            imgrect.origin.x=(_msgbutton.frame.size.width-24)/2;
            _imageview.image=[UIImage imageNamed:voiceimg];
            _imageview.frame=imgrect;
        }
    }
    else
    {
        [_msgbutton setTitle:msg.body forState:UIControlStateNormal];
        //计算文字宽高
        CGSize msgsize=[msg.body sizeWithFont:_msgbutton.titleLabel.font constrainedToSize:CGSizeMake(180, MAXFLOAT)];
        btnframe.size.width=msgsize.width+40;
        btnframe.size.height=msgsize.height+50;
        if(btnframe.size.width<kbuttonWith)
            btnframe.size.width=kbuttonWith;
        if(btnframe.size.height<kbuttonHeight+10)
            btnframe.size.height=kbuttonHeight+10;
    }
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

    _labsendtime.text=[msg.timestamp toStringWithFormater:@"MM/dd HH:mm"];
    [self setSendTime];
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

#pragma marak 按钮点击
-(void)btnclick
{
    //通知代理
    if(self.delegate&&[self.delegate respondsToSelector:@selector(ChatCellButtonClick:Msg:)])
    {
        [self.delegate ChatCellButtonClick:_msgbutton Msg:_msg.body];
    }
}

-(void)setSendTime
{
    if(_msg.timestamp)
    {
        NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        //从已有日期获取日期
        unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
        //将信息发送时间和当前时间统一去掉时间格式化，计算相差天数
        NSDate *msgdate=[NSDate dateWithFormat:@"yyyy-MM-dd" dateStr:[_msg.timestamp toStringWithFormater:@"yyyy-MM-dd"]];
        NSDate *nowdate=[NSDate dateWithFormat:@"yyyy-MM-dd" dateStr:[[NSDate date] toStringWithFormater:@"yyyy-MM-dd"]];
        //发送日期与当前日期对比，一个相差多少年，多少月，多少天
        NSDateComponents *comp = [myCal components:units fromDate:msgdate toDate:nowdate options:0];
        if(comp.day==0)
            _labsendtime.text=[_msg.timestamp toStringWithFormater:@"HH:mm"];
        else if(comp.day==1)
            _labsendtime.text=[NSString stringWithFormat:@"昨天 %@",[_msg.timestamp toStringWithFormater:@"HH:mm"]];
        else
            _labsendtime.text=[_msg.timestamp toStringWithFormater:@"MM/dd HH:mm"];
        
    }
}

@end
