//
//  CommandHeader.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-2.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#ifndef HelloChat_CommandHeader_h
#define HelloChat_CommandHeader_h

//判断是否ios系统
#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define IOS7_OR_LATER NLSystemVersionGreaterOrEqualThan(7.0)

//判断是否iphone5尺寸设备
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//服务器IP
#define kHostName @"121.41.37.62"
//服务名称 拼接JID的时候时候 xxx@Ygcserver
#define kServerName @"@Ygcserver"

//拼接带服务器地址的JID字符串
#define kAppendJid(name) [name stringByAppendingString:kServerName]

//获取appdelegate
#define kAppdelegate ((HCAppDelegate *)[UIApplication sharedApplication].delegate)

//更新电子名片成功发出的通知
#define kdidupdatevCard @"kdidupdatevCardNoti"

//更新电子名片失败发出的通知
#define kupdatevCardFaild @"kupdatevCardFaild"

#endif
