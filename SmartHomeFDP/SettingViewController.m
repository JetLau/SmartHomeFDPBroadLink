//
//  SetterViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 14-11-3.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "SettingViewController.h"
#import "LJCommonGroup.h"
#import "LJCommonItem.h"
#import "JSONKit.h"
#import "RootController.h"
#import "TCPDeviceManager.h"
#import "RMDeviceManager.h"
#import "SmartHomeAPIs.h"
#import "ProgressHUD.h"
#import "StatisticViewController.h"
#import "MapViewController.h"
#import "GpsDataTableViewController.h"
#import "GeocodeDemoViewController.h"
#import "UserInfo.h"
#import "UserDetailViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationItem setTitle:@"设置"];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.blEasyConfig=[InitBroadLink initBroadLinkDevices];

    [self setupGroups];
}

-(void)setupGroups
{
    [self setGroup0];
    [self setGroup1];
}

-(void)setGroup0
{
    LJCommonGroup *LJGroup=[[LJCommonGroup alloc]init];
    [self.groups addObject:LJGroup];
    
    LJCommonItem *downloadItem=[LJCommonItem itemWithTitle:@"下载设备"];
    [LJGroup.items addObject:downloadItem];
//    LJCommonItem *statisticItem=[LJCommonItem itemWithTitle:@"操作统计"];
//    [LJGroup.items addObject:statisticItem];
//    LJCommonItem *upLoadItem=[LJCommonItem itemWithTitle:@"上传遥控列表"];
//    [LJGroup.items addObject:upLoadItem];
//    //地图
//    LJCommonItem *mapItem=[LJCommonItem itemWithTitle:@"设备位置"];
//    [LJGroup.items addObject:mapItem];
//    //gps历史数据
//    LJCommonItem *gpsDataItem=[LJCommonItem itemWithTitle:@"设备GPS历史数据"];
//    [LJGroup.items addObject:gpsDataItem];
//    //某一天的地图
//    LJCommonItem *oneDayMap=[LJCommonItem itemWithTitle:@"历史日期位置显示"];
//    [LJGroup.items addObject:oneDayMap];
}

-(void)setGroup1
{
    LJCommonGroup *LJGroup=[[LJCommonGroup alloc]init];
    [self.groups addObject:LJGroup];
    LJCommonItem *detailItem=[LJCommonItem itemWithTitle:@"账号详情"];
    [LJGroup.items addObject:detailItem];
    
    LJCommonItem *outItem=[LJCommonItem itemWithTitle:@"退出登录"];
    [LJGroup.items addObject:outItem];
}

#pragma mark-点击cell的代理方法
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if (indexPath.item==0) {
            [self downloadDevices];
        }else if(indexPath.item == 1){
            [self upLoadRemote];
//            StatisticViewController *statisticViewController = [[StatisticViewController alloc] init];
//            [statisticViewController.navigationItem setTitle:@"操作统计"];
//            [self.navigationController pushViewController:statisticViewController animated:YES];
        }else if(indexPath.item == 2)
        {
            [self showMap];
        }else if(indexPath.item == 3){
            [self showGPSDataList];
        }else if(indexPath.item == 4)
        {
            [self showOneDayMap];
        }
    }
    if(indexPath.section==1)
    {
        if (indexPath.item==0) {
            [self switchToDetailView];
        }else if(indexPath.item == 1){
            [self logOutSystem];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)switchToDetailView{
    //[ProgressHUD show:@"正在获取用户详情"];
    self.view.userInteractionEnabled = false;
    [self switchToDetailViewController:[[UserInfo alloc] init]];
    
}
-(void)logOutSystem
{
    //删除userdefaults中的用户信息
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"username"];
    [userDefaults removeObjectForKey:@"password"];
    [userDefaults removeObjectForKey:@"gender"];
    [userDefaults removeObjectForKey:@"phone"];
    [userDefaults removeObjectForKey:@"address"];
    [userDefaults removeObjectForKey:@"roleId"];
    [userDefaults removeObjectForKey:@"addressName"];
    
    
    RootController *rootController=(RootController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rootController switchToLoginView];
}

- (void)switchToDetailViewController:(UserInfo*)user
{
    [self.view setUserInteractionEnabled:true];
    
    UserDetailViewController *userDetailViewController = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
    userDetailViewController.user = user;
    [self.navigationController pushViewController:userDetailViewController animated:YES];
}

-(void)downloadDevices
{
    //下载TCP设备列表
//    dispatch_async(kBgQueue,
//                   ^{
//                       NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//                       NSString *username=[defaults objectForKey:@"username"];
//                       
//                       NSDictionary *jsonDic=[SmartHomeAPIs GetTCPDeviceList:username];
//                       if(jsonDic==nil)
//                       {
//                           dispatch_async(dispatch_get_main_queue(), ^{
//                               [ProgressHUD showError:@"设备下载失败"];
//                           });
//                           return ;
//                       }
//                       NSDictionary *jsonMap=[jsonDic objectForKey:@"jsonMap"];
//                       
//                       if(jsonMap==nil)
//                       {
//                           dispatch_async(dispatch_get_main_queue(), ^{
//                               [ProgressHUD showError:@"设备下载失败"];
//                           });
//                           return;
//                       }
//                       NSArray *array=[jsonMap objectForKey:@"list"];
//                       
//                       TCPDeviceManager *tcpDeviceManager=[TCPDeviceManager createTCPDeviceManager];
//                       [tcpDeviceManager saveTCPDeviceInfoToFile:array];
//                       
//                       dispatch_async(dispatch_get_main_queue(), ^{
//                           
//                           UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"设备下载完成" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                           [alertView show];
//                       });
//                       
//                   });
    //下载遥控列表
    dispatch_async(kBgQueue,
                   ^{
                       [self.blEasyConfig listRefresh];
                       NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                       NSString *username=[defaults objectForKey:@"username"];
                       
                       NSDictionary *jsonDic=[SmartHomeAPIs GetRemoteList:username];
                       if(jsonDic==nil)
                       {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [ProgressHUD showError:@"遥控列表下载失败"];
                           });
                           return ;
                       }
                       NSDictionary *jsonMap=[jsonDic objectForKey:@"jsonMap"];
                       
                       if(jsonMap==nil)
                       {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [ProgressHUD showError:@"遥控列表下载失败"];
                           });
                           return;
                       }
                       NSArray *array=[jsonMap objectForKey:@"result"];
                       NSLog(@"remoteArray : %d",[array count]);
                       RMDeviceManager *rmDeviceManager = [RMDeviceManager createRMDeviceManager];
                       [rmDeviceManager saveRemoteListInfoToFile:array];

                       dispatch_async(dispatch_get_main_queue(), ^{
                           
                           UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"遥控列表下载完成" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                           [alertView show];
                       });
                       
                   });
    
}

-(void) upLoadRemote{
    dispatch_async(kBgQueue,
                   ^{
                       NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                       NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                       NSString *userName = [userDefaults stringForKey:@"username"];
                       NSString *fileName = [userName stringByAppendingFormat:@"%@",@"RMDeviceInfo.plist"];

                       SCRFTPRequest *ftpRequest =[SCRFTPRequest requestWithURL:[NSURL URLWithString:@"ftp://218.193.130.35/"] toUploadFile:[[doc stringByAppendingPathComponent:userName] stringByAppendingPathComponent:fileName]];
//                       [[SCRFTPRequest alloc] initWithURL:[NSURL URLWithString:@"ftp://218.193.130.35/"]
//                                                                         toUploadFile:[doc stringByAppendingPathComponent:userName]];
                       
                       ftpRequest.username = @"TWZ";
                       ftpRequest.password = @"admin";
                       
                       // Specify a custom upload file name (optional)
                       ftpRequest.customUploadFileName = fileName;
                       
                       // The delegate must implement the SCRFTPRequestDelegate protocol
                       ftpRequest.delegate = self;  
                       
                       [ftpRequest startAsynchronous];
                       
                      
                   });
//    SCRFTPRequest *ftpRequest = [SCRFTPRequest requestWithURL:[NSURL URLWithString:@"ftp://DomainUrl/AddressPath"] toUploadFile:fullPath];
//    ftpRequest.username = @"ftpusername";
//    ftpRequest.password = @"ftppassword";
//    ftpRequest.customUploadFileName = @"abcd.png";
//    ftpRequest.delegate = self;
//    [ftpRequest startAsynchronous];
}

-(void) showMap{
    
    dispatch_async(kBgQueue, ^{
        NSDictionary *gpsData = [SmartHomeAPIs GetGPSData:1];
        if ([[gpsData objectForKey:@"result"] isEqualToString:@"success"]) {
            NSDictionary *latestData = [[gpsData objectForKey:@"gps_datas"] objectAtIndex:0];
            
            NSString *lon = [latestData objectForKey:@"longitude"];
            NSString *lat = [latestData objectForKey:@"latitude"];
            
            double longitude = [[lon substringWithRange:NSMakeRange(0, 3)] doubleValue] + [[lon substringFromIndex:3] doubleValue]/60;
            double latitude = [[lat substringWithRange:NSMakeRange(0, 2)] doubleValue] + [[lat substringFromIndex:2] doubleValue]/60;
            
            NSLog(@"longitude = %lf latitude = %lf",longitude,latitude);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                MapViewController *mapViewController = [[MapViewController alloc] init];
                [mapViewController.navigationItem setTitle:@"设备当前位置"];
                [mapViewController setLongitude:longitude];
                [mapViewController setLatitude:latitude];
                [self.navigationController pushViewController:mapViewController animated:YES];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"获取gps数据失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            });
            return;
        }
    });
    
    
}


-(void) showGPSDataList{
    
    dispatch_async(kBgQueue, ^{
        NSDictionary *gpsData = [SmartHomeAPIs GetGPSData:1000];
        if ([[gpsData objectForKey:@"result"] isEqualToString:@"success"]) {
            NSArray *gpsDataList = [gpsData objectForKey:@"gps_datas"];
            dispatch_async(dispatch_get_main_queue(), ^{
                GpsDataTableViewController *gpsDataTableViewController = [[GpsDataTableViewController alloc] init];
                [gpsDataTableViewController.navigationItem setTitle:@"设备位置记录"];
                [gpsDataTableViewController setGpsArray:gpsDataList];
                [self.navigationController pushViewController:gpsDataTableViewController animated:YES];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"获取gps数据失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            });
            return;
        }
    });
    
    
}

-(void)showOneDayMap{
    GeocodeDemoViewController *geocodeDemoViewController = [[GeocodeDemoViewController alloc] init];
    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
    customLeftBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
    [geocodeDemoViewController.navigationItem setTitle:@"活动位置"];
    [self.navigationController pushViewController:geocodeDemoViewController animated:YES];
    
}
/** Called on the delegate when the request completes successfully. */
- (void)ftpRequestDidFinish:(SCRFTPRequest *)request{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"遥控列表上传完成" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
}
/** Called on the delegate when the request fails. */
- (void)ftpRequest:(SCRFTPRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"遥控列表上传失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

/** Called on the delegate when the transfer is about to start. */
- (void)ftpRequestWillStart:(SCRFTPRequest *)request;
{
    NSLog(@"ftpRequestWillStart");
}
/** Called on the delegate when the status of the request instance changed. */
- (void)ftpRequest:(SCRFTPRequest *)request didChangeStatus:(SCRFTPRequestStatus)status
{
    NSLog(@"didChangeStatus");
}
/** Called on the delegate when some amount of bytes were transferred. */
- (void)ftpRequest:(SCRFTPRequest *)request didWriteBytes:(NSUInteger)bytesWritten
{
    NSLog(@"didWriteBytes");
}

@end
