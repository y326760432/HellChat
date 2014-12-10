//
//  HCFileTool.m
//  HelloChat
//
//  Created by 叶根长 on 14-12-10.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCFileTool.h"
#import "HCMessageDataTool.h"
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
-(NSString *)getFileDirectoryWithType:(int)type
{
    
    if(type==HCMsgTypeIMAGE)
    {
        NSString *imgdirpath=kAppendDocPath(@"image");
        //如果文件夹不存在，则创建文件夹
        if(![[NSFileManager defaultManager] fileExistsAtPath:imgdirpath])
            [[NSFileManager defaultManager] createDirectoryAtPath:imgdirpath withIntermediateDirectories:YES attributes:nil error:nil];
        return imgdirpath;
    }
    else if(type==HCMsgTypeVOICE)
    {
        NSString *imgdirpath=kAppendDocPath(@"voice");
        //如果文件夹不存在，则创建文件夹
        if(![[NSFileManager defaultManager] fileExistsAtPath:imgdirpath])
            [[NSFileManager defaultManager] createDirectoryAtPath:imgdirpath withIntermediateDirectories:YES attributes:nil error:nil];
        return imgdirpath;
    }
    return nil;
}

@end
