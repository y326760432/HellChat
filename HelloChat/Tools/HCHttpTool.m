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
#import "HCAlertDialog.h"
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

#pragma mark 上传文件
-(void)upLoadFileWithFileName:(NSString *)filename fileData:(NSData *)fileData oriFileData:(NSData *)oriFileData msgType:(HCMsgType)msgType successBlock:(void (^)())successBlock faildBlock:(void (^)())faildBlock
{
    if(filename==nil||msgType<=0)
        return;
    //请求参数
    NSMutableURLRequest *request=[_httpclient multipartFormRequestWithMethod:@"POST" path:kUpLoadFilePath parameters:@{@"filetype": @(msgType)} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:fileData name:@"image" fileName:filename mimeType:@"image/png"];
    }];
   
    //异步存储图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //保存本地图片
        [[HCFileTool sharedHCFileTool] saveFileWihtData:fileData fileName:filename msgType:msgType];
    });
    //创建请求
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
       if(successBlock)
       {
           successBlock();
           //上传高清图片，高清图片和缩略图分开任务上传，为了页面可以快速反应，上传完缩略图就调用回调函数
           if (oriFileData) {
               [self upLoadHQImage:oriFileData fileName:filename];
           }
       }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(faildBlock)
            faildBlock();
    }];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"%lu",(unsigned long)bytesWritten);
        NSLog(@"%lld",totalBytesWritten);
        NSLog(@"%lld",totalBytesExpectedToWrite);
    }];
    //开始请求
    [operation start];
}

#pragma mark 上传高清图片
-(void)upLoadHQImage:(NSData *)data fileName:(NSString *)fileName
{
    //先保存本地文件
    [[HCFileTool sharedHCFileTool] saveFileWihtData:data fileName:fileName msgType:HCMsgTypeOriIMAGE];
    //请求参数
    NSMutableURLRequest *request=[_httpclient multipartFormRequestWithMethod:@"POST" path:kUpLoadFilePath parameters:@{@"filetype": @(HCMsgTypeOriIMAGE)} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"imageori" fileName:fileName mimeType:@"image/png"];
    }];
    AFJSONRequestOperation *oper=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"上传高清图片成功---%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"上传高清图片失败---%@",error.localizedDescription);
    }];
    [oper start];
}



#pragma mark 根据消息内容下载文件 图片或语音
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
    [self downLoadFileWithFileName:filename msgType:msgtype successBlock:nil faildBlock:nil];
}

#pragma mark 下载文件
-(void)downLoadFileWithFileName:(NSString *)filename msgType:(HCMsgType)msgType successBlock:(void (^)())successBlock faildBlock:(void (^)())faildBlock
{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?filetype=%d&filename=%@",kBaseUrl,kDownLoadFilePath,msgType,filename]];
    NSLog(@"%@",url);
    NSString *savepath=[[HCFileTool sharedHCFileTool] getFullPahtWithFilename:filename msgType:msgType];
    AFHTTPRequestOperation *oper=[[AFHTTPRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:url]];
    oper.outputStream=[[NSOutputStream alloc ]initToFileAtPath:savepath append:NO];
    [oper setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       if(successBlock)
           successBlock();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSFileManager defaultManager] removeItemAtPath:savepath error:nil];
        if(faildBlock)
            faildBlock();
        NSLog(@"%@下载失败---%@",savepath,error.localizedDescription);
    }];
    [oper start];
}

#pragma mark 获取文件类型在服务器存储的位置
-(NSString *)getFileUrlOnServerWithType:(int)type
{
    if(type==HCMsgTypeIMAGE)//缩略图
        return kImageServerDirPath;
    else if(type==HCMsgTypeVOICE)//语音
        return kVoiceServerDirPath;
    else if(type==HCMsgTypeOriIMAGE)//原图
        return kImageOriServerDirPath;
    return nil;
}

@end
