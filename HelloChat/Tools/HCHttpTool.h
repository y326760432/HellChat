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
 根据文件名和文件类型下载文件
 */
-(void)downLoadFileWithFileName:(NSString *)filename msgType:(HCMsgType)msgType successBlock:(void(^)()) successBlock faildBlock:(void(^)()) faildBlock;

@end
