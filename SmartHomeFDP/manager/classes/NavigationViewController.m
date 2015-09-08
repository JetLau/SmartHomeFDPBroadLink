//
//  NavigationViewController.m
//  REMenuExample
//
//  Created by Roman Efimov on 4/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//
//  Sample icons from http://icons8.com/download-free-icons-for-ios-tab-bar
//

#import "NavigationViewController.h"
#import "MHomeViewController.h"
#import "MStatisicViewController.h"
#import "MDeviceManageViewController.h"
#import "MSettingViewController.h"
@interface NavigationViewController ()
@property (strong, readwrite, nonatomic) REMenu *menu;

@end

@implementation NavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (REUIKitIsFlatMode()) {
        [self.navigationBar performSelector:@selector(setBarTintColor:) withObject:[UIColor colorWithRed:130/255.0 green:206/255.0 blue:59/255.0 alpha:1]];
        self.navigationBar.tintColor = [UIColor whiteColor];
    } else {
        self.navigationBar.tintColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
    }
    
    __typeof (self) __weak weakSelf = self;
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"主页"
                                                    subtitle:@"Return to Home Screen"
                                                       image:[UIImage imageNamed:@"Icon_Home"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", item);
//                                                          if ([weakSelf.visibleViewController isKindOfClass:[MHomeViewController class]] ) {
//                                                              return;
//                                                          }
                                                          MHomeViewController *controller = [[MHomeViewController alloc] initWithNibName:@"MHomeViewController" bundle:nil];
                                                          [weakSelf setViewControllers:@[controller] animated:NO];
                                                      }];
    
    REMenuItem *activityItem = [[REMenuItem alloc] initWithTitle:@"设备查询"
                                                    subtitle:@"Device Enquiry"
                                                       image:[UIImage imageNamed:@"Icon_Explore"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", item);
//                                                          if ([weakSelf.visibleViewController isKindOfClass:[MDeviceManageViewController class]] ) {
//                                                              return;
//                                                          }
                                                          
                                                          MDeviceManageViewController *controller = [[MDeviceManageViewController alloc] initWithNibName:@"MDeviceManageViewController" bundle:nil];
                                                          [weakSelf setViewControllers:@[controller] animated:NO];
                                                      }];
    
    REMenuItem *statisticItem = [[REMenuItem alloc] initWithTitle:@"数据统计"
                                                        subtitle:@"statistic data"
                                                           image:[UIImage imageNamed:@"Icon_Explore"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
//                                                              if ([weakSelf.visibleViewController isKindOfClass:[MStatisicViewController class]] ) {
//                                                                  return;
//                                                              }
                                                              
                                                              MStatisicViewController *controller = [[MStatisicViewController alloc] initWithNibName:@"MStatisicViewController" bundle:nil];
                                                              [weakSelf setViewControllers:@[controller] animated:NO];
                                                          }];
    
    REMenuItem *profileItem = [[REMenuItem alloc] initWithTitle:@"设置"
                                                       subtitle:@"Personal Setting"
                                                          image:[UIImage imageNamed:@"Icon_Profile"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                             
//                                                             if ([weakSelf.visibleViewController isKindOfClass:[MSettingViewController class]] ) {
//                                                                 return;
//                                                             }
                                                             
                                                             MSettingViewController *controller = [[MSettingViewController alloc] initWithNibName:@"MSettingViewController" bundle:nil];
                                                             [weakSelf setViewControllers:@[controller] animated:NO];
                                                         }];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];    // You can also assign a custom view for any particular item
    // Uncomment the code below and add `customViewItem` to `initWithItems` array, for example:
    // self.menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem, customViewItem]]
    //
    /*
    UIView *customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor blueColor];
    customView.alpha = 0.4;
    REMenuItem *customViewItem = [[REMenuItem alloc] initWithCustomView:customView action:^(REMenuItem *item) {
        NSLog(@"Tap on customView");
    }];
    */
    
    homeItem.tag = 0;
    activityItem.tag = 1;
    statisticItem.tag = 2;
    profileItem.tag = 3;
    self.menu = [[REMenu alloc] initWithItems:@[homeItem, activityItem, statisticItem, profileItem]];
    
    // Background view
    //
    //self.menu.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    //self.menu.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //self.menu.backgroundView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.600];

    //self.menu.imageAlignment = REMenuImageAlignmentRight;
    //self.menu.closeOnSelection = NO;
    //self.menu.appearsBehindNavigationBar = NO; // Affects only iOS 7
    if (!REUIKitIsFlatMode()) {
        self.menu.cornerRadius = 4;
        self.menu.shadowRadius = 4;
        self.menu.shadowColor = [UIColor blackColor];
        self.menu.shadowOffset = CGSizeMake(0, 1);
        self.menu.shadowOpacity = 1;
    }
    
    // Blurred background in iOS 7
    //
    //self.menu.liveBlur = YES;
    //self.menu.liveBlurBackgroundStyle = REMenuLiveBackgroundStyleDark;

    self.menu.separatorOffset = CGSizeMake(15.0, 0.0);
    self.menu.imageOffset = CGSizeMake(5, -1);
    self.menu.waitUntilAnimationIsComplete = NO;
    self.menu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
        badgeLabel.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
        badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.000].CGColor;
    };
    

    [self.menu setClosePreparationBlock:^{
        NSLog(@"Menu will close");
    }];
    
    [self.menu setCloseCompletionHandler:^{
        NSLog(@"Menu did close");
    }];
    
}

- (void)toggleMenu
{
    if (self.menu.isOpen)
        return [self.menu close];
    
    [self.menu showFromNavigationController:self];
}



@end
