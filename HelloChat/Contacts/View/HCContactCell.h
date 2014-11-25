//
//  HCContactCell.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-25.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPUserCoreDataStorageObject.h"
@interface HCContactCell : UITableViewCell

@property(nonatomic,strong) XMPPUserCoreDataStorageObject *user;

@end
