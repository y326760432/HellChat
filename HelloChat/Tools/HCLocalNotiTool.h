//
//  HCLocalNotiTool.h
//  HelloChat
//
//  Created by 叶根长 on 14-12-14.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface HCLocalNotiTool : NSObject

singleton_interface(HCLocalNotiTool)

/**
 发送本地通知
 */
-(void)postLocalNotiWithString:(NSString *)str;

@end
