//
//  NSDate+YGCCategory.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-8.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "NSDate+YGCCategory.h"

@implementation NSDate (YGCCategory)

/**
 将日期转换字符串
 */
-(NSString *)toStringWithFormater:(NSString *)formater
{
    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
    fmt.dateFormat=formater;
    return [fmt stringFromDate:self];
}

//将字符串转换成日期
+(NSDate *)dateWithFormat:(NSString *)format dateStr:(NSString *)dateStr
{
    if(format&&dateStr)
    {
    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
    fmt.dateFormat=format;
    return [fmt dateFromString:dateStr];
    }
    return nil;
}

@end
