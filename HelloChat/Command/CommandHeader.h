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

//self.frame.size
#define kselfsize self.frame.size
//self.view.frame.size
#define kselfviewsize self.view.frame.size

//服务器IP
#define kHostName @"121.41.37.62"

//服务名称 拼接JID的时候时候 xxx@Ygcserver
#define kServerName @"@Ygcserver"

#define kBaseUrl @"http://121.41.37.62"

//上传文件的页面
#define kUpLoadFilePath @"FileUpLoad.aspx"

#define kImageServerDirPath @"ChatImages" //服务器图片存放文件夹
#define kImageOriServerDirPath @"ChatImagesOri" //服务器原图片存放文件夹
#define kVoiceServerDirPath @"ChatVoice" //服务器语音文件存放文件夹

//登录人JID字符串
#define kmyJidStr [HCLoginUserTool sharedHCLoginUserTool].loginUser.JID

//登录人JID对象
#define kmyJid [XMPPJID jidWithString:kmyJidStr]

//拼接带服务器地址的JID字符串
#define kAppendJid(name) [name stringByAppendingString:kServerName]


//获取appdelegate
#define kAppdelegate ((HCAppDelegate *)[UIApplication sharedApplication].delegate)

//注册失败发出的通知
#define kRegisterFailNotiKey @"RegisterFailNotiKey"

//注册成功发出通知
#define kRegisterSuccessNotiKey @"RegisterSuccessNotiKey"

//更新电子名片成功发出的通知
#define kdidupdatevCard @"kdidupdatevCardNoti"

//更新电子名片失败发出的通知
#define kupdatevCardFaild @"kupdatevCardFaild"

//是否播放消息声音偏好设置键
#define kSoundUserDefaultKey @"HCSoundUserDefaultKey"

//是否接受通知偏好设置键
#define kNotiUserDefaultKey @"HCNotiUserDefaultKey"

#endif
