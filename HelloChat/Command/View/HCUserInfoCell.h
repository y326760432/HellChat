//
//  HCUserInfoCell.h
//  HelloChat
//  用户展现基类 目前由消息会话和好友列表继承
//  Created by 叶根长 on 14-11-30.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellHeight 70.0 //行高
@class XMPPUserCoreDataStorageObject;
@interface HCUserInfoCell : UITableViewCell

@property(nonatomic,strong) XMPPUserCoreDataStorageObject *user;

@end
