//
//  HCMessageDataTool.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-30.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#define kDBFileName @"HelloChat.db"//数据库文件名称
#define kMsgEntityName @"HCMessage"//实体名称
@class XMPPMessage;
@class NSManagedObjectContext;
@class HCMessage;
@interface HCMessageDataTool : NSObject

singleton_interface(HCMessageDataTool)

/**
 数据库上下文
 */
@property(nonatomic,readonly) NSManagedObjectContext *context;

/**
 添加一个会话记录
 */
-(void)addNewMessage:(XMPPMessage *)message;
/**
 删除会话记录
 */
-(void)delMessage:(HCMessage *)message;

@end
