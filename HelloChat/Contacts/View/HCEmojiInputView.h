//
//  HCEmojiInputView.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-19.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HCEmojiInputViewDelegate <NSObject>

/**
 选择了一个表情
 */
-(void)EmojiInputViewSelectItem:(NSString *)string;

/**
 按了删除键
 */
-(void)EmojiInputViewRemoveItem;

/**
 点击了发送按钮
 */
-(void)EmojiInputViewDisSend;
@end

@interface HCEmojiInputView : UIView

/**
 表情输入代理
 */
@property(weak,nonatomic) id<HCEmojiInputViewDelegate> delegate;

@end
