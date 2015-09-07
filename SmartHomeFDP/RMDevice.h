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
@property(strong,nonatomic)NSString *name;
@property(strong,nonatomic)NSString *mac;
//@property(strong,nonatomic)NSNumber *state;

@property(strong,nonatomic)NSMutableArray *RMButtonArray;

+(instancetype) itemDevice;
-(void) addRMButton:(NSDictionary *)buttonDic;

@end
