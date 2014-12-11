//
//  HCFileTool.m
//  HelloChat
//
//  Created by 叶根长 on 14-12-10.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCFileTool.h"
#import "HCMessageDataTool.h"
#define kimgdirname @"image" //缩略图存储文件夹
#define koriimgdirname @"oriimage" //大图存储文件夹
#define kvoicedirname @"voice" //语音文件存储文件夹
@implementation HCFileTool

singleton_implementation(HCFileTool)

-(BOOL)fileExistsWihtMsg:(NSString *)msg
{
    
    //拼接本地全路径
    NSString *savepath=[self getFileSavePathWithMsg:msg];
    return  [[NSFileManager defaultManager] fileExistsAtPath:savepath];
    return YES;
}

#pragma marak 获取消息文件的存储路径
-(NSString *)getFileSavePathWithMsg:(NSString *)msg
{
    //获取消息类型
    HCMsgType msgtype=[[HCMessageDataTool sharedHCMessageDataTool]getMsgTypeWithMessage:msg];
    if(msgtype>0)
    {
        //获取文件类型
        NSString *filename=[[HCMessageDataTool sharedHCMessageDataTool] getMsgFilename:msg];
        //文件文件类型本地存放路径
        NSString *defaultDir=[self getFileDirectoryWithType:msgtype];
        //拼接本地全路径
        NSString *savepath=[defaultDir stringByAppendingPathComponent:filename];
        return savepath;
    }
    return nil;
}

#pragma mark 获取文件类型的默认文件夹路径
-(NSString *)getFileDirectoryWithType:(HCMsgType)type
{
    if(type>0)
    {
        NSString *dir=nil;
        if(type==HCMsgTypeIMAGE)
            dir=kAppendDocPath(kimgdirname);
        else if(type==HCMsgTypeVOICE)
            dir=kAppendDocPath(kvoicedirname);
        else if (type==HSMsgTypeOriIMAGE)//原图
        {
            dir=kAppendDocPath(koriimgdirname);
        }
        if(dir)
        {
            //如果文件夹不存在，则创建文件夹
            if(![[NSFileManager defaultManager] fileExistsAtPath:dir])
                [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        return dir;
    }
    return nil;
}

#pragma mark 根据缩略图获取大图路径
-(NSString *)getFullPahtWithFilename:(NSString *)filename msgType:(HCMsgType)msgtype
{
    if(filename&&msgtype>0)
    {
        NSString *dir=[self getFileDirectoryWithType:msgtype];
        if(dir)
        {
            return [dir stringByAppendingPathComponent:filename];
        }
    }
    return nil;
}

@end
