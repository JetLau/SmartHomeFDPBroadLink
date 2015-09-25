//
//  NSObject+InitBroadLink.m
//  SmartHomeFDP
//
//  Created by cisl on 14-11-8.
//  Copyright (c) 2014年 eddie. All rights reserved.
//
//broadlink设备首次配置要四步
//1.network_init对库进行初始化
//2.easyconfig配置联网参数，使设备上网
//3.probe_list搜索所有局域网内的设备
//4.device_add对要控制的搜索到的设备进行设备初始化

//设备联网以后，每次控制设备需要两步
//1.network_init对库进行初始化
//2.device_add对要控制的搜索到的设备进行设备初始化


#import "InitBroadLink.h"
#import "BLNetwork.h"
#import "JSONKit.h"
#import "MJExtension.h"
#import "ProgressHUD.h"
#import "BLDeviceInfo.h"
#import "BLDeviceManager.h"
@interface InitBroadLink ()
{
    dispatch_queue_t networkQueue;
    
}

@end

@implementation InitBroadLink

+ (instancetype)initBroadLinkDevices
{
    //    InitBroadLink * initBL = [[InitBroadLink alloc] init];
    //    [initBL initNetwork];
    return [[self alloc] initNetwork];
}

-(instancetype) initNetwork
{
    if (self = [super init]) {
        networkQueue = dispatch_queue_create("BroadLinkSP2NetworkQueue", DISPATCH_QUEUE_SERIAL);
        _network = [[BLNetwork alloc] init];
    }
    return self;
}

- (void)networkInit
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:1] forKey:@"api_id"];
    [dic setObject:@"network_init" forKey:@"command"];
    //warning input your license.
    [dic setObject:@"sZtBBTSA8lYqJ9RFCz4AuUh1bIUfKCkKkytZphsZqCpooN/f4kqfPPnbUxNFj8tz3Dy4RT2Ybz7eF2CCkRAap8rzKwTlMUEVLc6UhL/6UHFdRU78Ux8=" forKey:@"license"];
    NSData *requestData = [dic JSONData];
    
    NSData *responseData = [_network requestDispatch:requestData];
    if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] == 0)
    {
        NSLog(@"Init success!");
    }
    else
    {
        NSLog(@"Init failed!");
    }
}

- (void)listRefresh
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    //int x = 5000;
    //while (x--) {
    [dic setObject:[NSNumber numberWithInt:11] forKey:@"api_id"];
    [dic setObject:@"probe_list" forKey:@"command"];
    
    NSData *requestData = [dic JSONData];
    NSMutableArray *oldDeviceArray = [self readDeviceInfoFromPlist];
    
    dispatch_async(networkQueue, ^{
        
        NSData *responseData = [_network requestDispatch:requestData];
        
        int code = [[[responseData objectFromJSONData] objectForKey:@"code"] intValue];
        
        
        
        if (code == 0)
        {
            NSArray *newDeviceDicArray = [[responseData objectFromJSONData] objectForKey:@"list"];
            for (NSDictionary *item in newDeviceDicArray)
            {
                int i;
                BLDeviceInfo *info = [[BLDeviceInfo alloc] init];
                [info setMac:[item objectForKey:@"mac"]];
                [info setType:[item objectForKey:@"type"]];
                [info setName:[item objectForKey:@"name"]];
                [info setLock:[[item objectForKey:@"lock"] intValue]];
                [info setPassword:[[item objectForKey:@"password"] unsignedIntValue]];
                [info setId:[[item objectForKey:@"id"] intValue]];
                [info setSubdevice:[[item objectForKey:@"subdevice"] intValue]];
                [info setKey:[item objectForKey:@"key"]];
                
                for (i=0; i<oldDeviceArray.count; i++)
                {
                    BLDeviceInfo *tmp = [oldDeviceArray objectAtIndex:i];
                    if ([tmp.mac isEqualToString:info.mac])
                    {
                        [oldDeviceArray replaceObjectAtIndex:i withObject:info];
                        break;
                    }
                }
                
                if (i >= oldDeviceArray.count && ![info.type isEqualToString:@"Unknown"])
                {
                    [oldDeviceArray addObject:info];
                    NSLog(@"add device %@",info.mac);
                }
                
                info = nil;
                
            }
            
            [self saveDeviceInfoToPlist:[NSMutableArray arrayWithArray:[BLDeviceInfo keyValuesArrayWithObjectArray:oldDeviceArray]]];
            [self addAllDevices];
            NSLog(@"newDeviceDicArray：%d",[newDeviceDicArray count]);
            NSLog(@"硬件列表数量：%d",[oldDeviceArray count]);
        }else{
            NSLog(@"probe_list error");
        }
        
        responseData = nil;
        
    });
    //        if ([oldDeviceArray count]) {
    //            break;
    //        }
    //
    //        requestData = nil;
    //        oldDeviceArray=nil;
    //  }
    
    
    //        if (code == 0)
    //        {
    //            NSArray *newDeviceDicArray = [[responseData objectFromJSONData] objectForKey:@"list"];
    //            NSArray *newDeviceArray = [BLDeviceInfo keyValuesArrayWithObjectArray:newDeviceDicArray];
    //            NSLog(@"newDeviceArray: %@",newDeviceDicArray);
    //            if (newDeviceArray.count != 0) {
    //#warning 应该是直接把存的旧的device列表全删掉，直接存新的列表。但是现在搜索不到设备，所以现在算法是保存新设备列表且旧设备列表只改变状态
    //                int count = oldDeviceArray.count;
    //                for (BLDeviceInfo *info in newDeviceArray) {
    //                    int i = 0;
    //                    for (i = 0; i < count; i++)
    //                    {
    //                        BLDeviceInfo *tmp = [oldDeviceArray objectAtIndex:i];
    //
    //                        if ([tmp.mac isEqualToString:info.mac])
    //                        {
    //                            [oldDeviceArray replaceObjectAtIndex:i withObject:info];
    //                            break;
    //                        }
    //                    }
    //
    //                    if (i >= count && ![info.type isEqualToString:@"Unknown"])
    //                    {
    //                        [oldDeviceArray addObject:info];
    //                        //[self deviceAdd:info];
    //                        NSLog(@"add device %@",info.mac);
    //                    }
    //
    //                }
    //
    //                //        for (BLDeviceInfo *info in oldDeviceArray) {
    //                //            [self deviceAdd:info];
    //                //            NSLog(@"info.name %@",info.name);
    //                //        }
    //
    //                [self saveDeviceInfoToPlist:oldDeviceArray];
    //                [self addAllDevices];
    //            }
    //            NSLog(@"硬件列表数量：%d",[oldDeviceArray count]);
    //        }else{
    //            NSLog(@"probe_list error");
    //        }
    //
    
}

//- (void)listRefresh
//{
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:[NSNumber numberWithInt:11] forKey:@"api_id"];
//    [dic setObject:@"probe_list" forKey:@"command"];
//
//    NSData *requestData = [dic JSONData];
//
//    dispatch_async(networkQueue, ^{
//
//        NSData *responseData = [_network requestDispatch:requestData];
//
//        int code = [[[responseData objectFromJSONData] objectForKey:@"code"] intValue];
//        if (code == 0)
//        {
//            NSArray *newDeviceDicArray = [[responseData objectFromJSONData] objectForKey:@"list"];
//            //NSArray *newDeviceArray = [BLDeviceInfo keyValuesArrayWithObjectArray:newDeviceDicArray];
//            NSLog(@"newDeviceArray: %@",newDeviceDicArray);
//            if (newDeviceDicArray != nil) {
//#warning 应该是直接把存的旧的device列表全删掉，直接存新的列表。但是现在搜索不到设备，所以现在算法是保存新设备列表且旧设备列表只改变状态
//                [self saveDeviceInfoToPlist:[NSMutableArray arrayWithArray:newDeviceDicArray]];
//                [self addAllDevices];
//            }
//            NSLog(@"硬件列表数量：%d",[newDeviceDicArray count]);
//        }else{
//            NSLog(@"probe_list error");
//        }
//    });
//
//}


-(NSMutableArray*)readDeviceInfoFromPlist
{

    BLDeviceManager *blDevManager = [BLDeviceManager createBLDeviceManager];
    return [blDevManager readBLDeviceInfoFromPlist];
}

- (void)addAllDevices
{
    NSMutableArray *deviceArray = [self readDeviceInfoFromPlist];
    for (BLDeviceInfo *info in deviceArray) {
        [self deviceAdd:info];
        //NSLog(@"add device %@",info.mac);
    }
}


- (void)deviceAdd:(BLDeviceInfo *)info
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[info keyValues]];
    //NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:12] forKey:@"api_id"];
    [dic setObject:@"device_add" forKey:@"command"];
    //    [dic setObject:info.mac forKey:@"mac"];
    //    [dic setObject:info.type forKey:@"type"];
    //    [dic setObject:info.name forKey:@"name"];
    //    [dic setObject:[NSNumber numberWithInt:info.lock] forKey:@"lock"];
    //    [dic setObject:[NSNumber numberWithUnsignedInt:info.password] forKey:@"password"];
    //    [dic setObject:[NSNumber numberWithInt:info.id] forKey:@"id"];
    //    [dic setObject:[NSNumber numberWithInt:info.subdevice] forKey:@"subdevice"];
    //    [dic setObject:info.key forKey:@"key"];
    //NSLog(@"%@", dic);
    //NSLog(@"dic %@", dic);
    NSData *requestData = [dic JSONData];
    
    dispatch_async(networkQueue, ^{
        NSData *responseData = [_network requestDispatch:requestData];
        int code = [[[responseData objectFromJSONData] objectForKey:@"code"] intValue];
        if (code == 0)
        {
            NSLog(@"Add %@ success!", info.mac);
        }
        else
        {
            NSLog(@"Add %@ failed! code = %i", info.mac, code);
            //TODO:
        }
    });
}

-(void)saveDeviceInfoToPlist :(NSMutableArray *) deviceArray
{
    //获取应用程序根目录
    //NSString *home = NSHomeDirectory();
    // NSUserDomainMask 在用户目录下查找
    // YES 代表用户目录的~
    // NSDocumentDirectory 查找Documents文件夹
    // 建议使用如下方法动态获取
    //NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 拼接文件路径
    //NSString *path = [doc stringByAppendingPathComponent:@"DeviceInfo.plist"];
//    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *path = [doc stringByAppendingPathComponent:@"DeviceInfo.plist"];
//        [deviceArray writeToFile:path atomically:YES];
    //读取数据
    //NSDictionary *dict1 = [NSDictionary dictionaryWithContentsOfFile:path];
    // NSLog(@"读取数据1  %@",[[NSMutableArray alloc] initWithContentsOfFile:path]);
    
    BLDeviceManager *blDevManager = [BLDeviceManager createBLDeviceManager];
    [blDevManager saveBLDeviceInfoToPlist:deviceArray];
}

-(void)startConfig:(NSString *)wifi password:(NSString *)password
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:10000] forKey:@"api_id"];
        [dic setObject:@"easyconfig" forKey:@"command"];
        [dic setObject:wifi forKey:@"ssid"];
        [dic setObject:password forKey:@"password"];
#warning If your device is v1, this field set 0.
        [dic setObject:[NSNumber numberWithInt:1] forKey:@"broadlinkv2"];
#warning This filed is your route's gateway address.
        //        [dic setObject:@"192.168.1.1" forKey:@"dst"];
        
        NSData *requestData = [dic JSONData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD show:@"正在搜索中..."];
        });
        
        NSData *responseData = [_network requestDispatch:requestData];
        NSLog(@"%@", [responseData objectFromJSONData]);
        NSDictionary *resultDic=[responseData objectFromJSONData];
        
        if([[resultDic objectForKey:@"code"]intValue]==0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ProgressHUD showSuccess:@"配置成功"];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ProgressHUD showError:@"配置失败"];
            });
        }
        
        //配置结束后(接口有问题，返回是失败，但设备其实已经配置上网)，调用listrefresh接口，将新添加的设备加入plist
        [self listRefresh];
        
        
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //
        //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[[responseData objectFromJSONData] objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //            [alertView show];
        //        });
    });
}

-(void)cancelConfig
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:10001] forKey:@"api_id"];
        [dic setObject:@"cancel_easyconfig" forKey:@"command"];
        
        NSData *requestData = [dic JSONData];
        
        NSData *responseData = [_network requestDispatch:requestData];
        NSLog(@"%@", [responseData objectFromJSONData]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[[responseData objectFromJSONData] objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        });
    });
}

@end
