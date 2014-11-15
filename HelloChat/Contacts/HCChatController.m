//
//  HCChatController.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-15.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCChatController.h"
#import "XMPPUserCoreDataStorageObject.h"
@interface HCChatController ()<UITextFieldDelegate>

@end

@implementation HCChatController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=_user.jidStr;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark 键盘位置发生改变通知
-(void)keyBoardChangeFrame:(NSNotification *)nofification
{
    
    //键盘的目标位置
    CGRect keyboardframe=[nofification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //动画时长
    CGFloat duration=[nofification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    
    //如果键盘的y等于屏幕的总高度，则表示键盘将要隐藏，添加没有键盘时的距离
    if(keyboardframe.origin.y==[UIScreen mainScreen].bounds.size.height)
    {
        if(![self.view.constraints containsObject:_keybordHiddenCts])
        {
            [self.view addConstraint:_keybordHiddenCts];
        }
    }
    else
    {
        //弹出英文键盘
        if(keyboardframe.size.height==216)
        {
            //移除没有键盘时的距离约束，显示英文键盘的距离约束
            [self.view removeConstraint:_keybordHiddenCts];
            //如果英文键盘距离被移除，添加回来
            if(![self.view.constraints containsObject:_enkeybordcts])
            {
                [self.view addConstraint:_enkeybordcts];
            }
        }
        //弹出中文键盘
        else if(keyboardframe.size.height==252)
        {
            //移除没键盘的距离和英文键盘的距离
            [self.view removeConstraint:_keybordHiddenCts];
            [self.view removeConstraint:_enkeybordcts];
        }
    }
    //动画展现输入框位置
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];

}

#pragma mark 信息输入框相关代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //关闭键盘
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
