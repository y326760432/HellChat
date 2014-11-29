//
//  HCContactCell.m
//  HelloChat
//  联系人显示自定义Cell
//  Created by 叶根长 on 14-11-25.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCContactCell.h"
#import <QuartzCore/QuartzCore.h>
#import "HCAppDelegate.h"
#import "HCXMPPUserTool.h"
@interface HCContactCell ()
{
   IBOutlet UIImageView *_photoview; //头像
   IBOutlet UILabel *_labname;//昵称
}
@end

@implementation HCContactCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //创建头像 宽高各50，距离Cell左距离和上距离为10
        _photoview=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        _photoview.layer.masksToBounds=YES;
        _photoview.layer.cornerRadius=25;
        [self.contentView addSubview:_photoview];
        
        //创建昵称 距离头像10距离
        _labname=[[UILabel alloc]init];
        _labname.font=kFont(18);
        _labname.backgroundColor=[UIColor clearColor];
        _labname.frame=CGRectMake(70, 10, kselfsize.width-75-20, 30);
        [self.contentView addSubview:_labname];
    }
    return self;
}

#pragma mark 设置用户昵称和头像
-(void)setUser:(XMPPUserCoreDataStorageObject *)user
{
    _user=user;
    _labname.text=[[HCXMPPUserTool sharedHCXMPPUserTool] getDisplayNameWithUser:user];
    _photoview.image=[[HCXMPPUserTool sharedHCXMPPUserTool] loaduserPhotoWithUser:user];
}

@end
