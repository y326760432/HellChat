//
//  HCEmojiInputView.m
//  HelloChat
//  表情输入视图
//  Created by 叶根长 on 14-11-19.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCEmojiInputView.h"
#import "Emoji.h"
#pragma mark 表情代码
static unichar emotechars[28] =
{
    0xe415, 0xe056, 0xe057, 0xe414, 0xe405, 0xe106, 0xe418,
    0xe417, 0xe40d, 0xe40a, 0xe404, 0xe105, 0xe409, 0xe40e,
    0xe402, 0xe108, 0xe403, 0xe058, 0xe407, 0xe401, 0xe416,
    0xe40c, 0xe406, 0xe413, 0xe411, 0xe412, 0xe410, 0xe059,
};

//分4行7列显示
#define kRowCount   4
#define kColCount   7
//每个表情大小
#define kButtonSize 44
//每行表情距离屏幕的左右边距
#define kPading 20

@interface HCEmojiInputView ()
{
    NSArray *_allEmojies;
}
@end

@implementation HCEmojiInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置背景颜色
        self.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self createEmojiButton];
        _allEmojies=[Emoji allEmoji];
    };
    return self;
}

#pragma mark 创建表情按钮
-(void)createEmojiButton
{
    //计算每个表情间的横向间距=屏幕的宽度-两边20的间距-7*44的宽度除以8个间隙
    CGFloat marin_x=(self.frame.size.width-kColCount*kButtonSize)/(kColCount+1);
    //计算每个表情间的垂直间距
    CGFloat margin_y=(self.frame.size.height-kButtonSize*kRowCount)/(kRowCount+1);
    for (int row=0; row<kRowCount; row++) {
        for (int column=0; column<kColCount; column++) {
            //表情序号
            int index=row*7+column;
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag=index;
            CGFloat x=(column+1)*marin_x+(column)*kButtonSize;
            CGFloat y=(row+1)*margin_y+(row)*kButtonSize;
            btn.frame=CGRectMake(x, y, kButtonSize, kButtonSize);
           
            
            //如果是最后一行和最后一列，添加发送按钮
            if(row==(kRowCount-1)&&column==(kColCount-1))
            {
                [btn setBackgroundColor:kGetColorRGB(0, 104, 255)];
                btn.layer.masksToBounds=YES;
                btn.layer.cornerRadius=4;
                btn.bounds=CGRectMake(0, 0, 44, 30);
                btn.titleLabel.font=kFont(15);
                [btn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:@"发送" forState:UIControlStateNormal];
            }
            //如果是最后一行和倒数第二列，添加删除按钮
            else if(row==(kRowCount-1)&&column==(kColCount-2))
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"aio_face_delete.png"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"aio_face_delete_pressed.png"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(removeClick) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                //设置表情文字
                [btn setTitle:_allEmojies[0] forState:UIControlStateNormal];
                //设置按钮点击事件
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self addSubview:btn];
        }
    }
}

#pragma mark 表情选择事件
-(void)btnClick:(UIButton *)button
{
    if(_delegate&&[_delegate respondsToSelector:@selector(EmojiInputViewSelectItem:)])
    {
        [_delegate EmojiInputViewSelectItem:[self getEmojiStrWithIndex:button.tag]];
    }
}

#pragma mark 删除一个表情
-(void)removeClick
{
    if(_delegate&&[_delegate respondsToSelector:@selector(EmojiInputViewRemoveItem)])
    {
        [_delegate EmojiInputViewRemoveItem];
    }
}

#pragma mark 发送
-(void)sendClick
{
    if(_delegate&&[_delegate respondsToSelector:@selector(EmojiInputViewDisSend)])
    {
        [_delegate EmojiInputViewDisSend];
    }
}

#pragma mark 获取表情字符
-(NSString *)getEmojiStrWithIndex:(int)index
{
    return _allEmojies[index];
}

#pragma mark 固定输入视图的高度
-(void)setFrame:(CGRect)frame
{
    frame.size.height=216;
    [super setFrame:frame];
}

@end
