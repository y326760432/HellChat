//
//  MTLocationTool.m
//  MeiTuan
//
//  Created by 叶根长 on 14-10-25.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "Singleton.h"
#import <CoreLocation/CoreLocation.h>
#import "HCLocationTool.h"
@interface HCLocationTool ()<CLLocationManagerDelegate>
{
    //定位管理
    CLLocationManager *_mgr;
    
    //地理编码类
    CLGeocoder *_geo;
}
@end

@implementation HCLocationTool

singleton_implementation(HCLocationTool)

-(id)init
{
    if (self=[super init]) {
        _mgr=[[CLLocationManager alloc]init];
        _mgr.delegate=self;
        _geo=[[CLGeocoder alloc]init];
    }
    
    return self;
}

-(void)startLocalation
{
    [_mgr startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorMsg=nil;
    if (error.code==kCLErrorDenied) {
        errorMsg=@"访问被拒绝,请运行本程序使用定位服务";
    }
    else if ([error code] == kCLErrorLocationUnknown) {
        errorMsg = @"获取位置信息失败";
    }
    else
        errorMsg=[error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"定位失败"
                                                      message:errorMsg delegate:self cancelButtonTitle:@"好"otherButtonTitles:nil, nil];
    [alertView show];
   
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //定位一次成功后停止继续定位
    [_mgr stopUpdatingLocation];
    //选择第一个位置，最准确
    CLLocation *clo=locations[0];
    NSLog(@"%lf,%lf",clo.coordinate.latitude,clo.coordinate.longitude);
    //反地理编码，根据经纬度获取地理名称
    [_geo reverseGeocodeLocation:clo completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks&&error==nil) {
            CLPlacemark *mark=placemarks[0];
            _loclationStr=[self stringWithCLPlacemark:mark];
            //通知代理
            if(_delegate&&[_delegate respondsToSelector:@selector(locationToolSuccess:)])
            {
                [_delegate locationToolSuccess:self];
            }
        }
        else if (error)
        {
            UIAlertView *dialog=[[UIAlertView alloc]initWithTitle:@"错误" message:@"定位出错" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [dialog show];
            //通知代理
            if(_delegate&&[_delegate respondsToSelector:@selector(locationToolFail:)])
            {
                [_delegate locationToolFail:self];
            }
        }
    }];
    
}


#pragma mark 组合地址字符串
-(NSString *)stringWithCLPlacemark:(CLPlacemark*)placemark
{
    if(placemark)
    {
        //省份
        NSString *province=placemark.administrativeArea;
        //城市
        NSString *city=placemark.locality;
        //区域
        NSString *district=placemark.subLocality;
        //道路名称
        NSString *streetname=placemark.thoroughfare?placemark.thoroughfare:@"";
        //子路或路段编号
        NSString *substreetname=placemark.subThoroughfare?placemark.subThoroughfare:@"";
        //地点名称（xx广场，xx酒店）
        NSString *name=placemark.name?placemark.name:@"";
        
        return [NSString stringWithFormat:@"%@%@%@%@%@ %@",province,city,district,streetname,substreetname,name];
    }
    return nil;
}

@end
