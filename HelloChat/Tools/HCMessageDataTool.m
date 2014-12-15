//
//  HCMessageDataTool.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-30.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCMessageDataTool.h"
#import "Singleton.h"
#import "HCMessage.h"
#import "XMPPMessage.h"
#import "HCXMPPUserTool.h"
#import <QuartzCore/QuartzCore.h>
#import "HCLocalNotiTool.h"
@implementation HCMessageDataTool

singleton_implementation(HCMessageDataTool)

-(id)init
{
    if(self=[super init])
    {
        [self openDB];
    }
    return self;
}

#pragma mrak 打开或创建数据库
-(void)openDB
{
    NSURL *modeurl=[[NSBundle mainBundle] URLForResource:@"HelloChatMode.momd" withExtension:nil];
    NSLog(@"%@",modeurl);
    //加载所有模型
    NSManagedObjectModel *mode=[[NSManagedObjectModel alloc]initWithContentsOfURL:modeurl];
    //创建持久化存储调度
    NSPersistentStoreCoordinator *store=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:mode];
    //数据库文件路径
    NSURL *url=[NSURL fileURLWithPath:kAppendDocPath(kDBFileName)];
    NSLog(@"%@",kAppendDocPath(kDBFileName));
    NSError *error=nil;
    //创建或打开数据库
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if(error)
        NSLog(@"%@",[NSString stringWithFormat:@"创建数据库失败--%@",error.localizedDescription]);
    else
    {
        _context=[[NSManagedObjectContext alloc]init];
        _context.persistentStoreCoordinator=store;
    }
}

#pragma mark 添加新会话记录
-(void)addNewMessage:(XMPPMessage *)message
{
    //获取完整的jid
    NSString *jid=[NSString stringWithFormat:@"%@@%@",message.from.user,message.from.domain];
    //从数据库查找记录，如果存在，则更新消息内容，如果不存在，则插入新数据
    HCMessage *msg=[self existsWith:jid];
    if(msg)
        [self updateMessage:msg xmppmessage:message];
    else
        [self insertMessage:message];
    //发送本地通知
   __block NSString *msgbody=[self getMessageBody:message.body];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HCLocalNotiTool sharedHCLocalNotiTool] postLocalNotiWithString:msgbody];
    });
}

#pragma mark 插入新记录
-(void)insertMessage:(XMPPMessage *)message
{
    HCMessage *msg=[NSEntityDescription insertNewObjectForEntityForName:kMsgEntityName inManagedObjectContext:_context];
    msg.jidstr=[NSString stringWithFormat:@"%@@%@",message.from.user,message.from.domain];
    msg.msgcontent=[self getMessageBody:message.body];
    msg.msgdate=[NSDate date];
    [[HCMessageDataTool sharedHCMessageDataTool].context save:nil];
    [_context save:nil];

}

#pragma mark 删除一个会话
-(void)delMessage:(HCMessage *)message
{
    if(message)
    {
        [_context deleteObject:message];
        [_context save:nil];
    }
}

#pragma mark 更新一个会话
-(void)updateMessage:(HCMessage *)message xmppmessage:(XMPPMessage *)xmppmessage
{
    message.msgcontent=[self getMessageBody:xmppmessage.body];
    message.msgdate=[NSDate date];
    NSLog(@"%@",message.msgdate);
    [_context save:nil];
}

#pragma mark 获取消息内容
-(NSString *)getMessageBody:(NSString *)msgbody;
{
    NSString *body=msgbody;
    HCMsgType type=[self getMsgTypeWithMessage:msgbody];
    if(type==HCMsgTypeIMAGE)
        return @"图片";
    else if (type==HCMsgTypeVOICE)
        return @"语音";
    else
       return body;
}

#pragma marak 获取消息类型
-(HCMsgType)getMsgTypeWithMessage:(NSString *)msg
{
    if([msg hasPrefix:@"|file|"])
    {
        NSRange range=NSMakeRange(6, 1);
        //获取文件类型
        int filetype=[[msg substringWithRange:range] intValue];
        if(filetype==1)
        {
            return HCMsgTypeIMAGE;//图片
        }
        else if(filetype==2)
            return HCMsgTypeVOICE;//语音
    }
    return HCMsgTypeTEXT;
}

#pragma marak 获取消息内容的文件名，图片消息和语音消息
-(NSString *)getMsgFilename:(NSString *)msg
{
     HCMsgType type=[self getMsgTypeWithMessage:msg];
    if(type==HCMsgTypeIMAGE||type==HCMsgTypeVOICE)
    {
        return [msg substringFromIndex:8];
    }
    return nil;
}

#pragma mark 查看数据中是否有此用户的记录，如果有，则更新消息内容和时间，如果没有，则插入信记录
-(HCMessage *)existsWith:(NSString *)jid
{
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:kMsgEntityName];
    request.predicate=[NSPredicate predicateWithFormat:@"jidstr CONTAINS %@",jid];
    NSArray *array=[_context executeFetchRequest:request error:nil];
    if(array.count>0)
        return array[0];
    return nil;
}

@end
