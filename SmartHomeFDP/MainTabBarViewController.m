//
//  MainTabBarViewController.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-4.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainTabBarViewController.h"
#import "HomeViewController.h"
#import "AddDeviceViewController.h"
#import "VoiceViewController.h"
#import "DeviceListViewController.h"
#import "SettingViewController.h"
#import "SmartHomeAPIs.h"
#define mtbvQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation MainTabBarViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    //获取setting中设置的URL
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userQu = [defaults stringForKey:@"qu"];
    if (userQu==nil || [userQu isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"未获取当前用户区号" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        NSLog(@"qu : %@", userQu);
        [SmartHomeAPIs SetQu:userQu];
    }
    HomeViewController *homeView=[[HomeViewController alloc]init];
    UINavigationController *homeNav=[[UINavigationController alloc]initWithRootViewController:homeView];
    homeView.navigationItem.title=@"首页";
    [self addOneChild:homeNav title:@"首页" imageName:@"home_dark" selectedImageName:@"home_light"];
    
    AddDeviceViewController *addDeviceView=[[AddDeviceViewController alloc]init];
    UINavigationController *addDeviceNav=[[UINavigationController alloc]initWithRootViewController:addDeviceView];
    addDeviceView.navigationItem.title=@"添加中控";
    [self addOneChild:addDeviceNav title:@"添加中控" imageName:@"add_dark" selectedImageName:@"add_light"];
    
    VoiceViewController *voiceView=[[VoiceViewController alloc]init];
    UINavigationController *voiceNav=[[UINavigationController alloc]initWithRootViewController:voiceView];
    voiceView.navigationItem.title=@"语音";
    [self addOneChild:voiceNav title:@"语音" imageName:@"voice_dark" selectedImageName:@"voice_light"];
    
    DeviceListViewController *deviceListView=[[DeviceListViewController alloc]init];
    UINavigationController *deviceListNav=[[UINavigationController alloc]initWithRootViewController:deviceListView];
    deviceListView.navigationItem.title=@"设备列表";
    [self addOneChild:deviceListNav title:@"设备列表" imageName:@"list_dark" selectedImageName:@"list_light"];
    
    SettingViewController *settingView=[[SettingViewController alloc]init];
    UINavigationController *settingNav=[[UINavigationController alloc]initWithRootViewController:settingView];
    settingView.navigationItem.title=@"设置";
    [self addOneChild:settingNav title:@"设置" imageName:@"setter_dark" selectedImageName:@"setter_light"];
    
    dispatch_async(mtbvQueue, ^{
        self.blEasyConfig = [InitBroadLink initBroadLinkDevices];
        [self.blEasyConfig networkInit];
        [self.blEasyConfig addAllDevices];
        
    });
}
-(void) viewWillAppear:(BOOL)animated
{
    
}

-(void)addOneChild:(UIViewController *)child title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    child.view.backgroundColor=[UIColor clearColor];
    
    child.tabBarItem.title=title;
    
    UIImage *image=[UIImage imageNamed:imageName];
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    child.tabBarItem.image=image;
    
    UIImage *selectedImage=[UIImage imageNamed:selectedImageName];
    selectedImage=[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    child.tabBarItem.selectedImage=selectedImage;
    
    [self addChildViewController:child];
}

@end
