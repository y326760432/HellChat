//
//  HCRoundImageView.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-16.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCRoundImageView.h"

@implementation HCRoundImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=30;
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
}

@end
