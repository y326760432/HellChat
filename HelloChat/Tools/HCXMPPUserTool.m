//
//  HCXMPPUserTool.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-29.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCXMPPUserTool.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "HCAppdelegate.h"
@implementation HCXMPPUserTool

singleton_implementation(HCXMPPUserTool)

#pragma mark 获取用户显示名称
-(NSString *)getDisplayNameWithUser:(XMPPUserCoreDataStorageObject *)user
{
    if(user.displayName)
    {
        return user.displayName;
    }
    else
        return user.jidStr;
}

#pragma mark 加载用户头像
-(UIImage *)loaduserPhotoWithUser:(XMPPUserCoreDataStorageObject *)user
{
    if(user.photo)
        return user.photo;
    NSData *data=[kAppdelegate.xmppvCardAvatarModule photoDataForJID:user.jid];
    if(data)
        return [UIImage imageWithData:data];
    return [UIImage imageNamed:@"normalheadphoto"];
}

@end
