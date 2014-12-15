//
//  HCFileTool.h
//  HelloChat
//
//  Created by 叶根长 on 14-12-10.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "HCMessageDataTool.h"
@interface HCFileTool : NSObject

singleton_interface(HCFileTool)

/**
 判断消息里面的文件是否下载到本地
 */
-(BOOL)fileExistsWihtMsg:(NSString *)msg;

/**
 获取消息类型文件的存储路劲
 */
-(NSString *)getFileSavePathWithMsg:(NSString *)msg;


/**
 获取消息类型的默认存储目录
 */
-(NSString *)getFileDirectoryWithType:(HCMsgType)type;

/**
 根据文件名和类型获取本地全路径
 */
-(NSString *)getFullPahtWithFilename:(NSString *)filename msgType:(HCMsgType)msgtype;

/**
 *  根据文件名和文件类型保存到沙盒
 *
 *  @param data 文件流
 *  @param fileName 文件名
 *  @param msgType  文件类型
 */
-(void)saveFileWihtData:(NSData *)data fileName:(NSString *)fileName msgType:(HCMsgType)msgType;

@end
