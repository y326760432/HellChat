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
#import "MBProgressHUD.h"
@interface HCShowPicController ()<UIScrollViewDelegate>
{
    UIImageView *_imgview;
    
    UIScrollView *_scrollview;
}
@end

@implementation HCShowPicController

-(void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden=NO;
}

//IOS7以上版本通过这句代码实现
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scrollview=[[UIScrollView alloc]init];
    CGRect scrollframe=self.view.bounds;
    if(!IOS7_OR_LATER)//如果是IOS7以下，高度+20；
        scrollframe.size.height+=20;
    _scrollview.frame=scrollframe;
    _scrollview.bounces=YES;
    _scrollview.bouncesZoom=YES;
    _scrollview.delegate=self;
    // 设置最大伸缩比例
    _scrollview.maximumZoomScale = 5.0;
    // 设置最小伸缩比例
    _scrollview.minimumZoomScale = 0.5;
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
    //获取缩略图路径
    NSString *smallimgpath=[[HCFileTool sharedHCFileTool]getFullPahtWithFilename:_filename msgType:HCMsgTypeIMAGE];
    //加载缩略图
    UIImage *img=[UIImage imageWithContentsOfFile:smallimgpath];
    //获取原图路径
    NSString *oriimgpath=[[HCFileTool sharedHCFileTool] getFullPahtWithFilename:_filename msgType:HCMsgTypeOriIMAGE];
    //如果本地存在原图，则加载本地原图
    if([[NSFileManager defaultManager] fileExistsAtPath:oriimgpath])
        img=[UIImage imageWithContentsOfFile:oriimgpath];
    else//从网络上下载原图，并存储到本地
    {
        __unsafe_unretained UIImageView *imageview=_imgview;
        
       [[HCHttpTool sharedHCHttpTool]downLoadFileWithFileName:_filename msgType:HCMsgTypeOriIMAGE successBlock:^{
           imageview.image=[UIImage imageWithContentsOfFile:oriimgpath];
       } faildBlock:^{
           
       }];
    }
     _imgview.image=img;
    [self setImageSize:img];
}

#pragma mark 根据图片宽高比设置图片大小
-(void)setImageSize:(UIImage *)image
{
    if(image==nil)
        return;
    //1计算图片的宽高比
    //如果是1:1这表示正方形，如果宽大于长，则根据宽度计算出高度
    CGSize size=image.size;
    CGFloat scale=(size.width/size.height);//图片大小的宽高比
    if(scale==1) //长度和宽度一样
    {
        if(size.width>kselfviewsize.width)//如果图片的宽度大于屏幕的宽度，则让图片的宽度等于屏幕宽度
        {
            size.width=kselfviewsize.width;
        }
        size.height=size.width*scale;
    }
    else if(scale>1)//宽度比高度更大
    {
        if(size.width>kselfviewsize.width)
        {
            //如果图片的宽度大于屏幕的宽度，则让图片的宽度等于屏幕宽度,高度等于宽度除以宽高比
            size.width=kselfviewsize.width;
        }
         size.height=size.width/scale;
    }
    else//宽度比高度小，长图
    {
        NSLog(@"%f",scale);
        if(size.height>kselfviewsize.height)
        {
            //如果图片的高度大于屏幕高度，则将屏幕高度设为图片高度，宽度等于高度乘以比率
            size.height=kselfviewsize.height;
        }
        size.width=size.height*scale;
    }
    _imgview.bounds=(CGRect){CGPointZero,size};
     _imgview.center=_scrollview.center;
    _scrollview.contentSize=size;
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
    CGPoint center=_imgview.center;
    //如果图片的宽度或高度没超过屏幕的宽度或高度，则图片的中点为屏幕宽度的中点或者屏幕高度的中点
    if(_imgview.frame.size.height<kselfviewsize.height)
        center.y=kselfviewsize.height*0.5;
    if(_imgview.frame.size.width<kselfviewsize.width)
        center.x=kselfviewsize.width*0.5;
    _imgview.center=center;
}

@end
