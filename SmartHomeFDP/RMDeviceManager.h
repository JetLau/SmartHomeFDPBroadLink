//
//  RMDeviceManage.h
//  SmartHomeFDP
//
//  Created by eddie on 14-11-8.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMDevice.h"

@interface RMDeviceManager : NSObject

@property(strong,nonatomic)NSString *path;
@property(strong,nonatomic)NSString *docPath;
@property(strong,nonatomic)NSString *fileName;

@property(strong,nonatomic)NSMutableArray *RMDeviceArray;

+(instancetype) createRMDeviceManager;
-(void)initRMDeviceManage;
-(int)getRMDeviceCount;
-(RMDevice *)getRMDevice:(int)index;
-(NSDictionary *)getRMButton:(int)index btnId:(int)btnId;
//-(int)writeRMDeviceInfoIntoFile:(RMDevice *)rmDevice;
-(int)addRMDeviceInfoIntoFile:(RMDevice *)rmDevice;
-(void)removeRMDevice:(int)index;
-(BOOL)saveSendData:(int)rmDeviceIndex btnId:(int)btnId sendData:(NSString*)data;
-(BOOL)saveVoiceInfo:(int)rmDeviceIndex btnId:(int)btnId voiceInfo:(NSString*)voiceInfo;
-(BOOL)saveBtnName:(int)rmDeviceIndex btnId:(int)btnId btnName:(NSString*)btnName;
-(BOOL)saveBtnOrigin:(int)rmDeviceIndex btnId:(int)btnId btnX:(CGFloat)btnX btnY:(CGFloat)btnY;

-(int)getRemoteCount:(NSString*)type;
-(int)saveRemoteName:(int)rmDeviceIndex name:(NSString*)name;

-(int)addRemoteButton:(int)rmDeviceIndex;
-(NSArray *)getBtnArray:(int)index;

-(void)deleteCustomBtn:(int)rmDeviceIndex btnId:(int)btnId;

-(void)saveRemoteListInfoToFile:(NSArray*)array;
-(void)addRemote:(NSDictionary*)remote;
@end
