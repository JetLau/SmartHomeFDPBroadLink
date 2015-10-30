//
//  CustomRemoteViewController.h
//  SmartHomeFDP
//
//  Created by Looping on 14-2-8.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCDraggableButton.h"
#import "DeviceViewController.h"
#import "RMDeviceManager.h"

@interface CustomRemoteViewController : DeviceViewController
@property(strong,nonatomic)RMDeviceManager *rmDeviceManager;

//-(int)addDevice;

@end
