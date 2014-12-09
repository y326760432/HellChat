//
//  HCHttpTool.h
//  HelloChat
//
//  Created by 叶根长 on 14-12-9.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface HCHttpTool : NSObject

singleton_interface(HCHttpTool)

/**
 下载文件消息的内容 图片或语音文件
 */
-(void)downLoadFileWithMessage:(NSString *)msg;

@end
