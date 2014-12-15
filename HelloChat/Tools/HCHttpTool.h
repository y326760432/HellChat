//
//  HCHttpTool.h
//  HelloChat
//
//  Created by 叶根长 on 14-12-9.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "HCMessageDataTool.h"
@interface HCHttpTool : NSObject

singleton_interface(HCHttpTool)

/**
 下载文件消息的内容 图片或语音文件
 */
-(void)downLoadFileWithMessage:(NSString *)msg;

/**
 上传文件
 @param filename 文件名
 @param msgType
 @param fileData 文件数据
 @param oriFileData 原始文件数据 （用于缩略图和高清图）
 @param msgType 消息类型（语音或者图片）
 @param successBlock 上传成功回调
 @param faildBlock 上传失败回调
 */
-(void)upLoadFileWithFileName:(NSString *)filename fileData:(NSData*)fileData oriFileData:(NSData *)oriFileData msgType:(HCMsgType)msgType successBlock:(void(^)()) successBlock faildBlock:(void(^)()) faildBlock;

/**
 根据文件名和文件类型下载文件
 @param filename 文件名
 @param msgType 文件类型
 @param successBlock 下载成功回调
 @param faildBlock 下载失败回调
 */
-(void)downLoadFileWithFileName:(NSString *)filename msgType:(HCMsgType)msgType successBlock:(void(^)()) successBlock faildBlock:(void(^)()) faildBlock;

@end
