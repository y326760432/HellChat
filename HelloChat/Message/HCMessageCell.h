//
//  HCMessageCell.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-30.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCUserInfoCell.h"
@class HCMessage;
@interface HCMessageCell : HCUserInfoCell

@property(nonatomic,strong) HCMessage *message;

@end
