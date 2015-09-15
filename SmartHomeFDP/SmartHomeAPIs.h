//
//  OEMSAPIs.h
//  OfficeEMS
//
//  Created by kevin on 12-11-25.
//  Copyright (c) 2012年 cis. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *ipAddr;
NSString *userQu;
@interface SmartHomeAPIs : NSObject
//配置服务器ip
+ (void)setIpAddr:(NSString *)setting;
+(NSString *)GetIPAddress;

//获取用户所在区
+ (void)SetQu:(NSString *)currentQu;
+(NSString *)GetQu;

//1.1用户帐户登录
+ (NSDictionary *)MobileLogin:(NSString *)email password:(NSString *)password;

//1.2注销登录
+ (NSDictionary *)MobileLogout;
//1.3 注册用户
+ (NSDictionary *)MobileRegister:(NSDictionary*)dic andQuNum:(NSString*)quNum;
//1.4 修改用户信息
+ (NSDictionary *)ChangeUserDetail:(NSDictionary*)dic;
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

//7.管理用户接口
//7.1 返回子地址列表
+ (NSDictionary *)GetChildAddressList:(NSString *)address;

//7.2 按区域统计用户数目
+ (NSDictionary *)GetRegionUserNumber:(NSString*)address;
//7.3 按区域统计设备数目
+ (NSDictionary *)GetRegionDeviceNumber:(NSString *)address;
//7.4 按区域统计设备使用次数
+ (NSDictionary *)GetRegionDeviceUseNumber:(NSString *)address;
//7.5 获取中控列表
+ (NSDictionary *)GetControllerList:(NSString *)address;
//7.6 按设备种类统计用户数量
+ (NSDictionary *)GetUserNumberListByDevice:(NSString *)address;
//7.7 按控制方式统计使用次数
+ (NSDictionary *)GetOperateNumberListByMethod:(NSString *)address;

@end
