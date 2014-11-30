//
//  HCMessage.h
//  HelloChat
//
//  Created by 叶根长 on 14-11-30.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HCMessage : NSManagedObject

@property (nonatomic, retain) NSString * jidstr;
@property (nonatomic, retain) NSNumber * msgtype;
@property (nonatomic, retain) NSString * msgcontent;
@property (nonatomic, retain) NSDate * msgdate;

@end
