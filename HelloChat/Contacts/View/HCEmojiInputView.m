//
//  HCEmojiInputView.m
//  HelloChat
//  表情输入视图
//  Created by 叶根长 on 14-11-19.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCEmojiInputView.h"
#import "Emoji.h"

//分4行7列显示
#define kColCount   8   //列数
#define kButtonSize 38  //每个表情大小
#define kEmojiCount 200 //表情总个数
#define kCountInPage 40 //每页表情个数

@interface HCEmojiInputView ()<UIScrollViewDelegate>
{
    NSArray *_allEmojies;
    UIScrollView *_scorllview;
    UIPageControl *_pageControl;
}
@end

@implementation HCEmojiInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置背景颜色
        self.backgroundColor=[UIColor groupTableViewBackgroundColor];
        //加载所有Emoji表情
        _allEmojies=[Emoji allEmoji];
        
        //创建ScrollView
        _scorllview=[[UIScrollView alloc]init];
        //scrollview的高度=每页个数/列数*每个表情高度
        CGFloat height=(kCountInPage/kColCount)*kButtonSize;
        _scorllview.frame=CGRectMake(0, 0, kselfsize.width, height);
        //总页数
        int pageCount=kEmojiCount/kCountInPage;
        _scorllview.contentSize=CGSizeMake(kselfsize.width*pageCount, 0);
        _scorllview.pagingEnabled=YES;
        _scorllview.showsHorizontalScrollIndicator=NO;
        _scorllview.delegate=self;
        [self addSubview:_scorllview];
       
        //分页控件
        _pageControl=[[UIPageControl alloc]init];
        _pageControl.center=CGPointMake(kselfsize.width/2,height+(kselfsize.height-height)/2);
        _pageControl.numberOfPages=pageCount;
        _pageControl.currentPageIndicatorTintColor=[UIColor darkGrayColor];
        _pageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
        _pageControl.currentPage=0;
        [self addSubview:_pageControl];
        //创建表情按钮
        [self createEmojiButton];
        
    };
    return self;
}

#pragma mark 创建表情按钮
-(void)createEmojiButton
{
    //计算每个表情间的横向间距
    CGFloat marin_x=(kselfsize.width-kButtonSize*kColCount)/2;
        for (int i=0; i<kEmojiCount; i++) {
            int col=i%kColCount;//列
            int row=(i%kCountInPage)/kColCount;//行
            int pageIndex=i/kCountInPage;//页码
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag=i;
            CGFloat x=marin_x+(col*kButtonSize)+(pageIndex*kselfsize.width);
            CGFloat y=row*kButtonSize;
            btn.frame=CGRectMake(x, y, kButtonSize, kButtonSize);
            //如果是最后一行和最后一列，添加发送按钮
            if((i%kCountInPage)==(kCountInPage-1))
            {
                [btn setBackgroundColor:kGetColorRGB(0, 104, 255)];
                btn.layer.masksToBounds=YES;
                btn.layer.cornerRadius=4;
                btn.titleLabel.font=kFont(15);
                [btn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:@"发送" forState:UIControlStateNormal];
            }
            //如果是最后一行和倒数第二列，添加删除按钮
            else if((i%kCountInPage)==(kCountInPage-2))
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"aio_face_delete.png"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"aio_face_delete_pressed.png"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(removeClick) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                //设置表情文字
                [btn setTitle:_allEmojies[i] forState:UIControlStateNormal];
                //设置按钮点击事件
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [_scorllview addSubview:btn];
    }
}

#pragma mark scrollerview代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage=(scrollView.contentOffset.x/kselfsize.width);
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
