//
//  HCChatCell.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-16.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kbuttonWith 84 //消息内容最小宽度
#define kbuttonHeight 56 //消息内容最小高度
@interface HCChatCell : UITableViewCell


/**
 头像
 */
-(void)setPhoto:(UIImage *)photo;
/**
 设置消息内容
 */
-(void)setMessage:(NSString *)msg;

/**
 是否为发送行 反之为接受行
 */
@property(assign,nonatomic) BOOL isOutgoing;

@end
