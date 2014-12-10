//
//  HCFileTool.h
//  HelloChat
//
//  Created by 叶根长 on 14-12-10.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
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
-(NSString *)getFileDirectoryWithType:(int)type;

@end
