//
//  VoiceCommandRecognizer.h
//  SmartHomeFDP
//
//  Created by eddie on 14-11-13.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RMDeviceManager;
@class TCPDeviceManager;
@class ScenePlistManager;
@class BLNetwork;

@interface VoiceCommandRecognizer : NSObject
@property (nonatomic, strong) BLNetwork *network;

@property(strong,nonatomic)RMDeviceManager *rmDeviceManager;
@property(strong,nonatomic)TCPDeviceManager *tcpDeviceManager;
@property(strong,nonatomic)ScenePlistManager *scenePlistManager;

+(instancetype)createVoiceCommandRecognizer;

-(void)voiceCommandRecognize:(NSString *)voiceCommandStr;
@end
