//
//  NSDate+YGCCategory.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-8.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YGCCategory)

/**
 将日期转换成字符串
 */
-(NSString *)toStringWithFormater:(NSString *)formater;

/**
 *  将字符串转换成日期
 *
 *  @param format  日期格式
 *  @param dateStr 日期字符串
 *
 *  @return 日期对象
 */
+(NSDate *)dateWithFormat:(NSString *)format dateStr:(NSString *)dateStr;
@end
