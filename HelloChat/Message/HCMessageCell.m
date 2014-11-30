//
//  HCMessageCell.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-30.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCMessageCell.h"
#import "HCMessage.h"
#import "NSDate+YGCCategory.h"
@interface HCMessageCell ()
{
    UILabel *_labmsgcontent;
    UILabel *_labmsgtime;
}
@end

@implementation HCMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labmsgcontent=[[UILabel alloc]init];
        _labmsgcontent.font=kFont(15);
        _labmsgcontent.frame=CGRectMake(70, 40, kselfsize.width-40, 20);
        [self.contentView addSubview:_labmsgcontent];
        
        _labmsgtime=[[UILabel alloc]init];
        _labmsgtime.font=kFont(10);
        _labmsgtime.textColor=[UIColor lightGrayColor];
        _labmsgtime.frame=CGRectMake(kselfsize.width-40, 10, 30, 20);
        [self.contentView addSubview:_labmsgtime];
    }
    return self;
}

-(void)setMessage:(HCMessage *)message
{
    _message=message;
    _labmsgcontent.text=message.msgcontent;
    _labmsgtime.text=[message.msgdate toStringWithFormater:@"HH:ss"];
}
;

@end
