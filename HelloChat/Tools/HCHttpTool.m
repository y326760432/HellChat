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
    //获取文件类型
    NSString *filename=[[HCMessageDataTool sharedHCMessageDataTool] getMsgFilename:msg];
    [self downLoadFileWithFileName:filename filetype:msgtype];
}

#pragma mark 下载文件
-(void)downLoadFileWithFileName:(NSString *)filename filetype:(int)filetype
{
    if(filename==nil||filetype<=0)
        return;
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",kBaseUrl,[self getFileUrlOnServerWithType:filetype],filename]];

    AFHTTPRequestOperation *oper=[[AFHTTPRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:url]];
    NSString *defaultDir=[self getFileDirectoryWithType:filetype];
    NSString *savepath=[defaultDir stringByAppendingPathComponent:filename];
    //如果文件存在，就不下载
    if(![[NSFileManager defaultManager] fileExistsAtPath:savepath])
    {
            NSLog(@"url--%@",url);
        oper.outputStream=[[NSOutputStream alloc ]initToFileAtPath:savepath append:NO];
        [oper setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@下载成功",savepath);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@下载失败---%@",savepath,error.localizedDescription);
        }];
        [oper start];
    }

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
