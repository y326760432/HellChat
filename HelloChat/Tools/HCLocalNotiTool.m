//
//  HCLocalNotiTool.m
//  HelloChat
//
//  Created by 叶根长 on 14-12-14.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCLocalNotiTool.h"
#import "Singleton.h"
@implementation HCLocalNotiTool

singleton_implementation(HCLocalNotiTool)

-(void)postLocalNotiWithString:(NSString *)str
{
    UILocalNotification *noti=[[UILocalNotification alloc]init];
    noti.alertBody=str;
    noti.fireDate=[NSDate date];
    noti.soundName=UILocalNotificationDefaultSoundName;//通知声音
    noti.applicationIconBadgeNumber=[UIApplication sharedApplication].applicationIconBadgeNumber+1;
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
}

@end
