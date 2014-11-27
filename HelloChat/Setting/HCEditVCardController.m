//
//  HCEditVCardController.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-6.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCEditVCardController.h"

@interface HCEditVCardController ()
{
    UITextField *_txtContent;
}
@end

@implementation HCEditVCardController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self setLayout];
}

-(void)setLayout
{
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(updatecontent)];
    
    CGFloat start_y=20;
    _txtContent=[[UITextField alloc]initWithFrame:CGRectMake(20, start_y, kselfviewsize.width-40, 40)];
    [self.view addSubview:_txtContent];
    
    _txtContent.text=_content.text;
    _txtContent.textAlignment=NSTextAlignmentCenter;
    _txtContent.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _txtContent.borderStyle=UITextBorderStyleRoundedRect;
    [_txtContent becomeFirstResponder];
    
}

-(void)updatecontent
{
    if(_txtContent.text.length>0)
    {
        _content.text=_txtContent.text;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
