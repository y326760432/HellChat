//
//  NSString+YGCCategory.m
//  WeiBo
//
//  Created by 叶根长 on 14-9-6.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "NSString+YGCCategory.h"

@implementation NSString (YGCCategory)

-(CGSize)getSizeWithFont:(UIFont *)font
{
    if(IOS7_OR_LATER)
    {
        NSStringDrawingOptions stringoptions= NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        return [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:stringoptions attributes:@{NSFontAttributeName:font} context:nil].size;
    }
    return [self sizeWithFont:font];
}

-(CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)constrainedToSize
{
    if(IOS7_OR_LATER)
    {
        NSStringDrawingOptions stringoptions= NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        return [self boundingRectWithSize:CGSizeMake(constrainedToSize.width, constrainedToSize.height) options:stringoptions attributes:@{NSFontAttributeName:font} context:nil].size;
    }
    return [self sizeWithFont:font constrainedToSize:constrainedToSize];
}

@end
