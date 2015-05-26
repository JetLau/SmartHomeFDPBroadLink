//
//  OEMSAPIs.h
//  OfficeEMS
//
//  Created by kevin on 12-11-25.
//  Copyright (c) 2012年 cis. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *ipAddr;

@interface SmartHomeAPIs : NSObject

+ (void)setIpAddr:(NSString *)setting;
+(NSString *)GetIPAddress;

//1.1用户帐户登录
+ (NSDictionary *)MobileLogin:(NSString *)email password:(NSString *)password;

//1.2注销登录
+ (NSDictionary *)MobileLogout;

//Remote
//2.1 添加遥控
+ (NSString *)AddRemote:(NSMutableDictionary*)dic;
//2.2 删除遥控
+ (NSString *)DeleteRemote:(NSMutableDictionary*)dic;
//2.3 遥控的按键学习
+ (NSString *)Rm2StudyData:(NSMutableDictionary*)dic;
//2.4 保存按钮的语音字段
+ (NSString *)SaveButtonVoice:(NSMutableDictionary*)dic;
//2.5 修改按钮名称
+ (NSString *)ChangeBtnName:(NSMutableDictionary*)dic;
//2.6 修改遥控名称
+ (NSString *)ChangeRemoteName:(NSMutableDictionary*)dic;
//2.7 发送遥控命令
+ (NSString *)Rm2SendData:(NSMutableDictionary*)dic;
//2.8 删除按钮
+ (NSString *)deleteBtn:(NSMutableDictionary*)dic;
//2.9 获取遥控列表
+ (NSDictionary *)GetRemoteList:(NSString *)username;

//TCPDevice
//3.1 获取TCP设备列表
+ (NSDictionary *)GetTCPDeviceList:(NSString *)username;
//3.2 开操作（TCP灯、插座）
+ (NSString *)OpenTCPDevice:(NSString *)mac type:(NSString *)type;
//3.3 关操作（TCP灯、插座）
+ (NSString *)CloseTCPDevice:(NSString *)mac type:(NSString *)type;
//3.4 设备解锁
+ (NSString *)AuthTCPDevice:(NSString *)mac type:(NSString *)type;

//4.Voice
+ (NSString *)OperateVoiceCommand:(NSString *)urlStr;

//6.获取gps数据
+ (NSDictionary *)GetGPSData:(int)num;
+ (NSDictionary *)GetOneDayGPSData:(NSString *)date;
@end
