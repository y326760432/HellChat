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

//消息类型枚举
typedef enum {
    HCMsgTypeTEXT,//文本表情
    HCMsgTypeIMAGE,//缩略图
    HCMsgTypeVOICE,//语音
    HCMsgTypeOriIMAGE,//原图
} HCMsgType;

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

/**
 根据消息内容获取消息类型
 */
-(HCMsgType)getMsgTypeWithMessage:(NSString *)msg;

/**
 获取消息里面的文件名
 */
-(NSString *)getMsgFilename:(NSString *)msg;

@end
