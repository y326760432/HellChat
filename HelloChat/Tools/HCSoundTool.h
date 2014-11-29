//
//  HCSoundTool.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-29.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface HCSoundTool : NSObject

singleton_interface(HCSoundTool)

/**
 播放新消息提示音效
 */
-(void)playNewMsgSound;

@end
