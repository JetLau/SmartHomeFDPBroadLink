//
//  OEMSRootController.m
//  OfficeEMS_iPhone
//
//  Created by cisl on 14-5-27.
//  Copyright (c) 2014年 WangShengYin. All rights reserved.
//

#import "RootController.h"
#import "LoginViewController.h"
#import "MainTabBarViewController.h"
#import "SmartHomeAPIs.h"
#import "NavigationViewController.h"
#import "MHomeViewController.h"
#define CommonUser 5

@interface RootController ()

@property(nonatomic, strong) LoginViewController *loginViewController;
@property(nonatomic, strong) MainTabBarViewController *mainTabBarViewController;
@property(nonatomic, strong) NavigationViewController *navigationViewController;

@end

@implementation RootController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //获取setting中设置的URL
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ipAddr = [defaults stringForKey:@"ipAddr"];
    if (ipAddr==nil || [ipAddr isEqualToString:@""])
    {
        ipAddr =  @"10.131.200.97:8080";
    }
    NSLog(@"IP : %@", ipAddr);
    [SmartHomeAPIs setIpAddr:ipAddr];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults stringForKey:@"username"];
    NSString *password = [userDefaults stringForKey:@"password"];
    NSString *roleId = [userDefaults stringForKey:@"roleId"];
    //[userDefaults setObject:password forKey:@"password"];
    if (!(roleId == nil)) {
        [self switchNextViewController:roleId];
    } else {
        self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.view addSubview:self.loginViewController.view];
    }
    NSLog(@"%@%@",userName,password);

}

- (void)switchToMainTabBarView
{
    [self.loginViewController.view removeFromSuperview];
    self.loginViewController = nil;
    
    self.mainTabBarViewController = [[MainTabBarViewController alloc] init];
    [self.view addSubview:self.mainTabBarViewController.view];
}

- (void)switchToManagerView
{
    [self.loginViewController.view removeFromSuperview];
    self.loginViewController = nil;
    self.navigationViewController = [[NavigationViewController alloc] initWithRootViewController:[[MHomeViewController alloc] init]];
    [self.view addSubview:self.navigationViewController.view];
    
    
}

- (void)switchToLoginView
{
    [self.mainTabBarViewController.view removeFromSuperview];
    self.mainTabBarViewController = nil;
    
    self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.view addSubview:self.loginViewController.view];
}

- (void)switchNextViewController:(NSString*)roleId
{
    int id = [roleId intValue];
    if (id == CommonUser) {
        [self switchToMainTabBarView];
    }else {
        [self switchToManagerView];
    }
}
@end
