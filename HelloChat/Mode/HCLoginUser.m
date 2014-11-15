//
//  HCLoginUser.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-2.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCLoginUser.h"

@implementation HCLoginUser

//解档
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super init])
    {
        self.username=[aDecoder decodeObjectForKey:@"username"];
        self.password=[aDecoder decodeObjectForKey:@"password"];
        self.JID=[aDecoder decodeObjectForKey:@"JID"];
        self.logouted=[aDecoder decodeBoolForKey:@"logouted"];
    }
    return self;
}

//归档
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.JID forKey:@"JID"];
    [aCoder encodeBool:self.logouted forKey:@"logouted"];
}

//设置用户名的时候顺便设置JID
-(void)setUsername:(NSString *)username
{
    _username=username;
    _JID=[NSString stringWithFormat:@"%@%@",username,kServerName];
}

@end
