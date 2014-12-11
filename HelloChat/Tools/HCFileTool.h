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
 获取大图文件存储文件夹
 */
-(NSString *)getOriImageDirectory;



/**
 根据文件名和类型获取本地全路径
 */
-(NSString *)getFullPahtWithFilename:(NSString *)filename msgType:(HCMsgType)msgtype;

@end
