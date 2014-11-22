//
//  MTLocationTool.h
//  MeiTuan
//
//  Created by 叶根长 on 14-10-25.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@class HCLocationTool;
@protocol HCLocationToolDelegate <NSObject>

/**
 定位成功
 */
-(void)locationToolSuccess:(HCLocationTool *)location;

/**
 定位失败
 */
-(void)locationToolFail:(HCLocationTool *)location;

@end

@interface HCLocationTool : NSObject

singleton_interface(HCLocationTool)

/**
 开始定位
 */
-(void)startLocalation;

/**
 位置信息
 */
@property(nonatomic,copy) NSString *loclationStr;


/**
 代理
 */
@property(nonatomic,weak) id<HCLocationToolDelegate> delegate;

@end
