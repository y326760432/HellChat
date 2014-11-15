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
   
}
@end

@implementation HCEditVCardController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _txtContent.text=_content.text;
    [_txtContent becomeFirstResponder];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(updatecontent)];
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
