//
//  NSString+YGCCategory.h
//  WeiBo
//
//  Created by 叶根长 on 14-9-6.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YGCCategory)

-(CGSize)getSizeWithFont:(UIFont *)font;

-(CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)constrainedToSize;

@end
