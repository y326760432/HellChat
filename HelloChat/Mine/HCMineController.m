//
//  HCMineController.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-8.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCMineController.h"
#import "HCPersonalController.h"
@interface HCMineController ()

@end

@implementation HCMineController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"我";
    
    //让设置tableview距离底部距离-20 全屏效果
    self.tableView.contentInset=UIEdgeInsetsMake(-35, 0, 0, 0);

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0&&indexPath.row==1) {
        HCPersonalController *vcardcontroller=[UIStoryboard storyboardWithName:@"HCPersonalController" bundle:nil].instantiateInitialViewController;
        
        [self.navigationController pushViewController:vcardcontroller animated:YES];
    }
}

@end
