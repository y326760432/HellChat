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
@interface HCContactCell ()
{
   IBOutlet UIImageView *_photoview; //头像
   IBOutlet UILabel *_labname;//昵称
}
@end

@implementation HCContactCell


-(void)awakeFromNib
{
    _photoview.layer.masksToBounds=YES;
    _photoview.layer.cornerRadius=25;

}

-(void)setUser:(XMPPUserCoreDataStorageObject *)user
{
    _user=user;
    if(user.displayName)
    {
        _labname.text=user.displayName;
    }
    else
        _labname.text=user.jidStr;
    
    NSLog(@"%@",_labname.text);
    _photoview.image=[self loaduserPhoto:user];
}

#pragma mark 加载用户头像
-(UIImage *)loaduserPhoto:(XMPPUserCoreDataStorageObject *)user
{
    if(user.photo)
        return user.photo;
    NSData *data=[kAppdelegate.xmppvCardAvatarModule photoDataForJID:user.jid];
    if(data)
        return [UIImage imageWithData:data];
    return [UIImage imageNamed:@"normalheadphoto"];
}

@end
