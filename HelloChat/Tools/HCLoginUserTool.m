//
//  HCLoginUserTool.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-2.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCLoginUserTool.h"
#import "Singleton.h"
#import "HCLoginUser.h"
#define kLoginUserFile @"LoginUserFile.data"
@implementation HCLoginUserTool

singleton_implementation(HCLoginUserTool)

-(id)init
{
    if(self=[super init])
    {
        //从沙盒中获取用户登录信息
       _loginUser=[NSKeyedUnarchiver unarchiveObjectWithFile:kAppendDocPath(kLoginUserFile)];
    }
    return self;
}

#pragma mark 如果登录成功，将登录信息写入沙盒
-(void)setIsLogined:(BOOL)isLogined
{
    _isLogined=isLogined;
    //写入到沙盒文件
    [NSKeyedArchiver archiveRootObject:_loginUser toFile:kAppendDocPath(kLoginUserFile)];
}

-(void)setUserPhoto:(UIImage *)userPhoto
{
    _userPhoto=userPhoto;
    _loginUser.photo=userPhoto;
    //写入到沙盒文件
    [NSKeyedArchiver archiveRootObject:_loginUser toFile:kAppendDocPath(kLoginUserFile)];
}

@end
