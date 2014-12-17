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
#import "XMPPUserCoreDataStorageObject.h"
#import "HCAppdelegate.h"
#import <CoreData/CoreData.h>
@implementation HCXMPPUserTool

singleton_implementation(HCXMPPUserTool)

#pragma mark 获取用户显示名称
-(NSString *)getDisplayNameWithUser:(XMPPUserCoreDataStorageObject *)user
{
    if(user.displayName)
    {
        NSString *displayname=user.displayName;
        if([displayname rangeOfString:@"@"].length>0)
            return [user.displayName substringToIndex:[displayname rangeOfString:@"@"].location];
        return displayname;
    }
    else
        return [user.jidStr substringToIndex:[user.jidStr rangeOfString:@"@"].location];
}

-(NSString *)getDisplayNameWithJid:(NSString *)jid
{
    XMPPUserCoreDataStorageObject *user=[HCXMPPUserTool getUserCoreDataObjectWithJidStr:jid];
    if(user)
    {
        return [self getDisplayNameWithUser:user];
    }
    return jid;
}

#pragma mark 加载用户头像
-(UIImage *)loaduserPhotoWithUser:(XMPPUserCoreDataStorageObject *)user
{
    if(user.photo)
        return user.photo;
    return [self loaduserPhotoWithJid:user.jidStr];
    
}

#pragma mark 根据jid加载用户头像
-(UIImage *)loaduserPhotoWithJid:(NSString *)jid
{
    if(jid)
    {
        NSData *data=[kAppdelegate.xmppvCardAvatarModule photoDataForJID:[XMPPJID jidWithString:jid]];
        if(data)
            return [UIImage imageWithData:data];
    }
    return [UIImage imageNamed:@"normalheadphoto"];
}

+(XMPPUserCoreDataStorageObject *)getUserCoreDataObjectWithJidStr:(NSString *)jidstr
{
    NSManagedObjectContext *usercontext=kAppdelegate.xmppUserCoreDataContext;

    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"XMPPUserCoreDataStorageObject"];
    request.predicate=[NSPredicate predicateWithFormat:@"jidStr CONTAINS %@",jidstr];
    
    NSError *error;
    NSArray *array=[usercontext executeFetchRequest:request error:&error];
    if(error)
        NSLog(@"查询用户出错--%@",error.localizedDescription);
    else if(array.count>0)
        return array[0];
    return nil;
}

@end
