//
//  RMDevice.h
//  SmartHomeFDP
//
//  Created by eddie on 14-11-8.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMDevice:NSObject

@property(strong,nonatomic)NSString *type;

@property(strong,nonatomic)NSMutableArray *RMButtonArray;

+(instancetype) itemWithDevice:(RMDevice *)device;
-(void) addRMButton:(NSDictionary *)buttonDic;

@end
