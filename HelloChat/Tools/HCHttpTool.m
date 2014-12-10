//
//  HCHttpTool.m
//  HelloChat
//
//  Created by 叶根长 on 14-12-9.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCHttpTool.h"
#import "Singleton.h"
#import "AFNetworking.h"
#import "HCMessageDataTool.h"
#import "HCFileTool.h"
@interface HCHttpTool ()
{
    AFHTTPClient *_httpclient;
}
@end

@implementation HCHttpTool

-(id)init
{
    if(self=[super init])
    {
        _httpclient=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    }
    return self;
}

singleton_implementation(HCHttpTool)

-(void)downLoadFileWithMessage:(NSString *)msg
{
    //获取消息类型
    HCMsgType msgtype=[[HCMessageDataTool sharedHCMessageDataTool]getMsgTypeWithMessage:msg];
    if(msgtype>0)
    {
        if(![[HCFileTool sharedHCFileTool] fileExistsWihtMsg:msg])
        {
            [self downLoadFileWithFileName:msg];
        }
    }
}

#pragma mark 下载文件
-(void)downLoadFileWithFileName:(NSString *)msg
{
    //获取消息类型
    HCMsgType msgtype=[[HCMessageDataTool sharedHCMessageDataTool]getMsgTypeWithMessage:msg];
     NSString *filename=[[HCMessageDataTool sharedHCMessageDataTool] getMsgFilename:msg];
    if(filename==nil||msgtype<=0)
        return;
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?filetype=%d&filename=%@",kBaseUrl,kDownLoadFilePath,msgtype,filename]];
    NSLog(@"%@",url);
    NSString *savepath=[[HCFileTool sharedHCFileTool] getFileSavePathWithMsg:msg];
    AFHTTPRequestOperation *oper=[[AFHTTPRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:url]];
    oper.outputStream=[[NSOutputStream alloc ]initToFileAtPath:savepath append:NO];
    [oper setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@下载成功",savepath);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@下载失败---%@",savepath,error.localizedDescription);
    }];
    [oper start];

}



#pragma mark 获取文件类型在服务器存储的位置
-(NSString *)getFileUrlOnServerWithType:(int)type
{
    if(type==HCMsgTypeIMAGE)
        return kImageServerDirPath;
    else if(type==HCMsgTypeVOICE)
        return kVoiceServerDirPath;
    return nil;
}

@end
