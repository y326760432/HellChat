//
//  HCFileInputView.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-22.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCFileInputView;
@protocol HCFileInputViewDelegate <NSObject>

/**
 点击了相册按钮
 */
-(void)FileInputViewImgLib:(HCFileInputView *)FileInputView;

/**
 点击了拍照按钮
 */
-(void)FileInputViewTakePhoto:(HCFileInputView *)FileInputView;

/**
 点击了位置按钮
 */
-(void)FileInputViewLocation:(HCFileInputView *)FileInputView;

@end

@interface HCFileInputView : UIView

@property(nonatomic,weak) id<HCFileInputViewDelegate> delegate;

@end
