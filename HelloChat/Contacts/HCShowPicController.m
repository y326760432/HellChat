//
//  HCShowPicController.m
//  HelloChat
//  图片展示控制器
//  Created by 叶根长 on 14-12-11.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCShowPicController.h"
#import "HCFileTool.h"
#import "HCMessageDataTool.h"
#import "UIImageView+WebCache.h"
#import "HCHttpTool.h"
@interface HCShowPicController ()<UIScrollViewDelegate>
{
    UIImageView *_imgview;
    
    UIScrollView *_scrollview;
}
@end

@implementation HCShowPicController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scrollview=[[UIScrollView alloc]initWithFrame:self.view.frame];
    _scrollview.contentSize=kselfviewsize;
    _scrollview.bounces=YES;
    _scrollview.bouncesZoom=YES;
    _scrollview.delegate=self;
    // 设置最大伸缩比例
    _scrollview.maximumZoomScale = 5.0;
    // 设置最小伸缩比例
    _scrollview.minimumZoomScale = 0.2;
    _scrollview.backgroundColor=[UIColor blackColor];
    [self.view addSubview:_scrollview];
    _imgview=[[UIImageView alloc]init];
    _imgview.center=_scrollview.center;
    _imgview.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizerHandler)]];
    [_scrollview addSubview:_imgview];
    
    [self setImage];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)setImage
{
    NSString *smallimgpath=[[HCFileTool sharedHCFileTool]getFullPahtWithFilename:_filename msgType:HCMsgTypeIMAGE];
    UIImage *img=[UIImage imageWithContentsOfFile:smallimgpath];
    NSString *oriimgpath=[[HCFileTool sharedHCFileTool] getFullPahtWithFilename:_filename msgType:HSMsgTypeOriIMAGE];
    if([[NSFileManager defaultManager] fileExistsAtPath:oriimgpath])
        img=[UIImage imageWithContentsOfFile:oriimgpath];
    else
    {
        __unsafe_unretained UIImageView *imageview=_imgview;
       [[HCHttpTool sharedHCHttpTool]downLoadFileWithFileName:_filename msgType:HSMsgTypeOriIMAGE successBlock:^{
           imageview.image=[UIImage imageWithContentsOfFile:oriimgpath];
       } faildBlock:^{
           
       }];
    }
     _imgview.image=img;
    _scrollview.contentSize=img.size;
    _imgview.center=_scrollview.center;
    _imgview.bounds=CGRectMake(0, 0, 113, 200);
}

#pragma mark 背景点击事件，关闭控制器
-(void)tapGestureRecognizerHandler
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return  _imgview;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    _imgview.center=_scrollview.center;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
   // _imgview.center=_scrollview.center;
}

@end
