//
//  HCChatCell.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-16.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HCChatCell : UITableViewCell

/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *photoimgv;

/**
 消息内容
 */
@property (weak, nonatomic) IBOutlet UIButton *msgbutton;

/**
 设置消息内容
 */
-(void)setMessage:(NSString *)msg;

/**
 消息内容宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgbuttonWithCts;

/**
 消息内容高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgbuttonHeightCts;

/**
 是否为发送行 反之为接受行
 */
@property(assign,nonatomic) BOOL isOutgoing;

@end
