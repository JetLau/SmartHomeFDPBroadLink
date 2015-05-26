//
//  SetterViewController.h
//  SmartHomeFDP
//
//  Created by cisl on 14-11-3.
//  Copyright (c) 2014年 eddie. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LJCommonViewController.h"
#import "InitBroadLink.h"
#import "SCRFTPRequest.h"

@interface SettingViewController : LJCommonViewController<SCRFTPRequestDelegate>
@property(strong,nonatomic)InitBroadLink *blEasyConfig;

@end

