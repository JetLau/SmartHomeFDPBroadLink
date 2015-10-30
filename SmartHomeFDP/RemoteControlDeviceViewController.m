//
//  RemoteControlDeviceViewController.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-6.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "RemoteControlDeviceViewController.h"
#import "LJCommonGroup.h"
#import "LJCommonItem.h"
#import "DeviceViewController.h"
#import "JSONKit.h"
#import "TVViewController.h"
#import "AirConditionViewController.h"
#import "CurtainViewController.h"
#import "ProjectorViewController.h"
#import "LightViewController.h"
#import "CustomRemoteViewController.h"
#import "RMDeviceManager.h"
#import "RMDevice.h"
#import "RMButton.h"
#import <objc/runtime.h>
#define remoteQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface RemoteControlDeviceViewController ()
{
    dispatch_queue_t networkQueue;
    
}
@property (nonatomic,strong) NSMutableArray *groups;
@property (nonatomic,strong) NSMutableArray *deviceArray;

@end

@implementation RemoteControlDeviceViewController
#pragma mark -懒加载
-(NSMutableArray *) groups
{
    if (_groups == nil) {
        _groups = [[NSMutableArray alloc] init];
    }
    
    return _groups;
}

//屏蔽tableview的样式设置
-(id)init
{
    NSLog(@"1.init DeviceListView table view!");
    return [super init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //隐藏tabbar工具条
        self.hidesBottomBarWhenPushed = YES;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //_deviceArray = [self readDeviceInfoFromPlist];
    
   
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //初始化模型
    self.groups=nil;
    [self setupGroups];
    [self.tableView reloadData];
}


-(void) setupGroups
{
    //添加遥控
    [self setupGroup0];
    //遥控设备列表
    [self setupGroup1];
}

-(void) setupGroup0
{
    //1.创建组
    LJCommonGroup *group = [LJCommonGroup group];
    [self.groups addObject:group];
    
    //2.设置组的基本数据
    group.groupheader = @"添加遥控";
    
    //3.设置组中所有行的数据
    //NSDictionary *parameterDic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:0], @"mode",nil];
    
    LJCommonItem *item_tv=[LJCommonItem itemWithTitle:@"电视" icon:@"tv" type:@"TV"];
    item_tv.destVcClass=[TVViewController class];
    [group.items addObject:item_tv];
    
    LJCommonItem *item_aircondition=[LJCommonItem itemWithTitle:@"空调" icon:@"aircondition" type:@"AirCondition"];
    item_aircondition.destVcClass=[AirConditionViewController class];
    [group.items addObject:item_aircondition];
    
    LJCommonItem *item_curtain=[LJCommonItem itemWithTitle:@"窗帘" icon:@"curtain" type:@"Curtain"];
    item_curtain.destVcClass=[CurtainViewController class];
    [group.items addObject:item_curtain];
    
    LJCommonItem *item_projector=[LJCommonItem itemWithTitle:@"投影仪" icon:@"projector" type:@"Projector"];
    item_projector.destVcClass=[ProjectorViewController class];
    [group.items addObject:item_projector];
    
    LJCommonItem *item_light=[LJCommonItem itemWithTitle:@"电灯" icon:@"light" type:@"Light"];
    item_light.destVcClass=[LightViewController class];
    [group.items addObject:item_light];
    
    LJCommonItem *item_custom=[LJCommonItem itemWithTitle:@"自定义" icon:@"custom" type:@"Custom"];
    item_custom.destVcClass=[CustomRemoteViewController class];
    [group.items addObject:item_custom];
}

- (void) setupGroup1
{
    //1.创建组
    LJCommonGroup *group = [LJCommonGroup group];
    [self.groups addObject:group];
    
    //2.设置组的基本数据
    group.groupheader = @"遥控列表";
    
    //3.设置组中所有行的数据
    RMDeviceManager *rmDeviceManager=[RMDeviceManager createRMDeviceManager];
    int rmDeviceCount=[rmDeviceManager getRMDeviceCount];
    for(int i=0;i<rmDeviceCount;i++)
    {
        RMDevice *rmDevice=[rmDeviceManager getRMDevice:i];
        NSString *type=rmDevice.type;
        //NSDictionary *parameterDic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:1],@"mode",[[NSNumber alloc]initWithInt:i], @"rmDeviceIndex",nil];
        
        if([type isEqualToString:@"TV"])
        {
            LJCommonItem *item_tv=[LJCommonItem itemWithTitle:rmDevice.name icon:@"tv" type:type];
            item_tv.destVcClass=[TVViewController class];
            [group.items addObject:item_tv];
        }
        else if([type isEqualToString:@"Curtain"])
        {
            LJCommonItem *item_curtain=[LJCommonItem itemWithTitle:rmDevice.name icon:@"curtain" type:type];
            item_curtain.destVcClass=[CurtainViewController class];
            [group.items addObject:item_curtain];
        }
        else if([type isEqualToString:@"AirCondition"])
        {
            LJCommonItem *item_aircondition=[LJCommonItem itemWithTitle:rmDevice.name icon:@"aircondition" type:type];
            item_aircondition.destVcClass=[AirConditionViewController class];
            [group.items addObject:item_aircondition];
        }
        else if([type isEqualToString:@"Projector"])
        {
            LJCommonItem *item_projector=[LJCommonItem itemWithTitle:rmDevice.name icon:@"projector" type:type];
            item_projector.destVcClass=[ProjectorViewController class];
            [group.items addObject:item_projector];
        }
        else if([type isEqualToString:@"Light"])
        {
            LJCommonItem *item_light=[LJCommonItem itemWithTitle:rmDevice.name icon:@"light" type:type];
            item_light.destVcClass=[LightViewController class];
            [group.items addObject:item_light];
        }
        else if([type isEqualToString:@"Custom"])
        {
            LJCommonItem *item_custom=[LJCommonItem itemWithTitle:rmDevice.name icon:@"custom" type:type];
            item_custom.destVcClass=[CustomRemoteViewController class];
            [group.items addObject:item_custom];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//-(NSMutableArray*)readDeviceInfoFromPlist{
//
//    return nil;
//}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        //1.取出这行对应的item模型
        LJCommonGroup *group = self.groups[indexPath.section];
        LJCommonItem *item = group.items[indexPath.row];
        
        //2.判断有无需要跳转的控制器
        if (item.destVcClass) {
            
            DeviceViewController *destVc =[[item.destVcClass alloc] init];
            [destVc setRemoteType:item.type];
            [destVc setInfo:_info];
            int deviceId = [destVc addDevice];
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                [_groups removeObjectAtIndex:1];
                [self setupGroup1];
                [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            });
            destVc.rmDeviceIndex = deviceId;
            [destVc.navigationItem setTitle:item.title];
            [self.navigationController pushViewController:destVc animated:YES];
        }
        
        //3.判断有无需要执行的代码段
        if (item.operation) {
            item.operation();
        }
        
    }else{
        //1.取出这行对应的item模型
        LJCommonGroup *group = self.groups[indexPath.section];
        LJCommonItem *item = group.items[indexPath.row];
        
        //2.判断有无需要跳转的控制器
        if (item.destVcClass) {
            DeviceViewController *destVc =[[item.destVcClass alloc] init];
            [destVc setRemoteType:item.type];
            destVc.rmDeviceIndex = indexPath.row;
            [destVc setInfo:_info];
            [destVc.navigationItem setTitle:item.title];
            [self.navigationController pushViewController:destVc animated:YES];
        }
        
        //3.判断有无需要执行的代码段
        if (item.operation) {
            item.operation();
        }
        
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@"cell number %i",indexPath.row);

                RMDeviceManager *rmDeviceManager=[RMDeviceManager createRMDeviceManager];

                RMDevice *rmDevice = [rmDeviceManager getRMDevice:indexPath.row];
                [rmDeviceManager removeRMDevice:indexPath.row];
                
                [_groups removeObjectAtIndex:1];
                [self setupGroup1];
                [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                dispatch_async(remoteQueue, ^{
                    NSMutableDictionary *remoteDic = [[NSMutableDictionary alloc] init];
                    [remoteDic setObject:@"deleteRemote" forKey:@"command"];
                    [remoteDic setObject:_info.mac forKey:@"mac"];
                    [remoteDic setObject:rmDevice.name forKey:@"name"];
                    //NSLog(@"TV =%@",remoteDic);
                    [SmartHomeAPIs DeleteRemote:remoteDic];
                });
            });
            
        }
    }
}
@end
