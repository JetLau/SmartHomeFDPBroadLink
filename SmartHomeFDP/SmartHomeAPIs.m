//
//  OEMSAPIs.m
//  OfficeEMS
//
//  Created by kevin on 12-11-25.
//  Copyright (c) 2012年 cis. All rights reserved.
//

#import "SmartHomeAPIs.h"
#import "JSONKit.h"
#import "AFHTTPRequestOperationManager.h"
//#define ipAddr @"218.193.130.166"
//#define ipAddr @"192.168.0.7:8080"

@implementation SmartHomeAPIs

+ (void)setIpAddr:(NSString *)setting
{
    ipAddr = setting;
}

+ (NSDictionary *)toDictionary:(NSData *)data
{
    NSError *error;
//    if ([data isEqual:nil]) {
//        return nil;
//    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return json;
}

+(NSString *)GetIPAddress
{
    return ipAddr;
}
//1.1
+ (NSDictionary *)MobileLogin:(NSString *)username password:(NSString *)password
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"username", password, @"password", nil];
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/disableCommunityAOP/user/user_login.action?qu=%@&&requestStr=%@",ipAddr,@"null",josnString];
    NSLog(@"%@",urlString);

    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSLog(@"error = %@",error);

    if (data)
    {
        NSLog(@"login in success %@",[self toDictionary:data]);
        return [self toDictionary:data];
    }
    else
    {
        NSLog(@"login in fail");
        return nil;
    }
    
    
    //__block NSDictionary *resultDic;
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    AFHTTPRequestOperation *operation = [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@",responseObject);
//        //NSLog(@"is : %@",[[responseObject valueForKey:@"jsonMap"] valueForKey:@"result"]);
//        //resultDic = responseObject;
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//    NSLog(@"dic: %@",operation.responseObject);
//    return nil;
}
//1.2
+ (NSDictionary *)MobileLogout
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/MyHomes/MobileLogout?sessionType=3", ipAddr];
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if (data)
        return [SmartHomeAPIs toDictionary:data];
    else
        return nil;
    
//    __block NSDictionary *resultDic;
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@",responseObject);
//        resultDic = [SmartHomeAPIs toDictionary:responseObject];
//        NSLog(@"dic: %@",resultDic);
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//    
//    return resultDic;
}
//1.3 注册用户
+ (NSDictionary *)MobileRegister:(NSDictionary*)dic
{
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];

    NSString *urlString = [NSString stringWithFormat:@"http://%@/disableCommunityAOP/user/user_register.action?qu=%@&&requestStr=%@",ipAddr,@"null",josnString];
    NSLog(@"%@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if(data)
    {
        //NSLog(@"data = %@", [SmartHomeAPIs toDictionary:data]);
        
        return [[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"];
        
    }
    else
    {
        return [[NSDictionary alloc]initWithObjectsAndKeys:@"fail",@"result",nil];
    }}

//Remote
//2.1 添加遥控
+ (NSString *)AddRemote:(NSMutableDictionary*)dic
{
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/disableCommunityAOP/updateRemote.action?updateRemoteRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];

    NSLog(@"error = %@",error);

    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);
            return @"success";
        }
    }
    return @"fail";
    
}

//2.2 删除遥控
+ (NSString *)DeleteRemote:(NSMutableDictionary*)dic
{
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/disableCommunityAOP/updateRemote.action?updateRemoteRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);

    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
    }
    return @"fail";
}

//2.3 遥控的按键学习
+ (NSString *)Rm2StudyData:(NSMutableDictionary*)dic
{
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http:/%@/disableCommunityAOP/studyMode.action?studyRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
    }
    return @"fail";
}
//2.4 保存按钮的语音字段
+ (NSString *)SaveButtonVoice:(NSMutableDictionary*)dic
{
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/disableCommunityAOP/saveVoice.action?saveVoiceRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
    }
    NSLog(@"result: %@",data);

    return @"fail";
}

//2.5 修改按钮名称
+ (NSString *)ChangeBtnName:(NSMutableDictionary*)dic
{
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/disableCommunityAOP/updateBtn.action?updateBtnRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);

    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
    }
  //  NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

    return @"fail";
}

//2.6 修改遥控名称
+ (NSString *)ChangeRemoteName:(NSMutableDictionary*)dic
{
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/disableCommunityAOP/updateRemote.action?updateRemoteRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);

    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
    }
   // NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

    return @"fail";
}


//2.7 发送遥控命令
+ (NSString *)Rm2SendData:(NSMutableDictionary*)dic
{
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/disableCommunityAOP/controlRemoteMode.action?ctlRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);

    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
    }
    //NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

    return @"fail";
}

//2.8 删除按钮
+ (NSString *)deleteBtn:(NSMutableDictionary*)dic
{
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/disableCommunityAOP/updateBtn.action?updateBtnRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);

    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
    }
    //NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

    return @"fail";
}

//2.9 获取遥控列表
+ (NSDictionary *)GetRemoteList:(NSString *)username
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/disableCommunityAOP/refreshRemote.action?username=%@",ipAddr,username];
    NSLog(@"获取遥控列表url %@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSLog(@"GetRemoteList error = %@", error);
    if(data)
    {
        //NSLog(@"data = %@", [SmartHomeAPIs toDictionary:data]);
        
        return [SmartHomeAPIs toDictionary:data];
        
    }
    else
    {
        return nil;
    }

}

//3.1 获取TCP设备列表
+ (NSDictionary *)GetTCPDeviceList:(NSString *)username
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/getOneUserDevices.action?username=%@",ipAddr,username];
    NSLog(@"%@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSLog(@"GetTCPDeviceList error = %@", error);
    if(data)
    {
        NSLog(@"data = %@", [SmartHomeAPIs toDictionary:data]);

        return [SmartHomeAPIs toDictionary:data];

    }
    else
    {
        return nil;
    }
}
//3.2 开操作（TCP灯、插座）
+ (NSString *)OpenTCPDevice:(NSString *)mac type:(NSString *)type
{
    NSDictionary *dic;
    if([type isEqualToString:@"light"])
    {
        dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:42],@"api_id",@"sp1_control",@"command",mac,@"mac",[[NSNumber alloc]initWithInt:1],@"status",[[NSNumber alloc]initWithInt:0],@"op_method", nil];
    }
    else if([type isEqualToString:@"socket"])
    {
        dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:52],@"api_id",@"sp2_control",@"command",mac,@"mac",[[NSNumber alloc]initWithInt:1],@"status",[[NSNumber alloc]initWithInt:0],@"op_method",  nil];
    }
    
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/controlMode.action?remoteCtlRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);

    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    NSLog(@"error = %@",error);

    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
        else
        {
            
            return [[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"message"];
        }
    }
    return @"fail";
}
//3.3 关操作（TCP灯、插座）
+ (NSString *)CloseTCPDevice:(NSString *)mac type:(NSString *)type
{
    NSDictionary *dic;
    if([type isEqualToString:@"light"])
    {
        dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:42],@"api_id",@"sp1_control",@"command",mac,@"mac",[[NSNumber alloc]initWithInt:0],@"status",[[NSNumber alloc]initWithInt:0],@"op_method",  nil];
    }
    else if([type isEqualToString:@"socket"])
    {
        dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:52],@"api_id",@"sp2_control",@"command",mac,@"mac",[[NSNumber alloc]initWithInt:0],@"status",[[NSNumber alloc]initWithInt:0],@"op_method",  nil];
    }
    
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/controlMode.action?remoteCtlRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);

    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
        else
        {
            
            return [[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"message"];
        }
    }
    return @"fail";
}
//3.4 设备解锁
+ (NSString *)AuthTCPDevice:(NSString *)mac type:(NSString *)type;
{
    NSDictionary *dic;
    if([type isEqualToString:@"light"])
    {
        dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:41],@"api_id",@"sp1_auth",@"command",mac,@"mac",[[NSNumber alloc]initWithInt:1028000492],@"password", nil];
    }
    else if([type isEqualToString:@"socket"])
    {
        dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:51],@"api_id",@"sp2_auth",@"command",mac,@"mac",[[NSNumber alloc]initWithInt:1028000492],@"password", nil];
    }
    
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/controlMode.action?remoteCtlRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
    }
    return @"fail";
}

//4.1 执行语音命令
+ (NSString *)OperateVoiceCommand:(NSString *)urlString
{
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }else
        {
            return [[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"message"];
        }
    }
    return @"Fail";
}

//6.1获取gps数据
+ (NSDictionary *)GetGPSData:(int)num
{
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:[NSNumber numberWithInt:num] forKey:@"gpsDataNum"];
//    [dic setObject:@"860719021423573" forKey:@"IEME"];
//    NSData *requestData = [dic JSONData];
//    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/getGPSData.action?IMEI=%@&gpsDataNum=%d",ipAddr,@"860719021423573",num];
    NSLog(@"获取遥控列表url %@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSLog(@"GetGPSData error = %@", error);
    if(data)
    {
        //NSLog(@"data = %@", [SmartHomeAPIs toDictionary:data]);
        
        return [[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"];
        
    }
    else
    {
        return [[NSDictionary alloc]initWithObjectsAndKeys:@"fail",@"result",nil];
    }
    
}
//6.2获取某一天中每个小时的GPS数据
+ (NSDictionary *)GetOneDayGPSData:(NSString *)date{
    //    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    //    [dic setObject:[NSNumber numberWithInt:num] forKey:@"gpsDataNum"];
    //    [dic setObject:@"860719021423573" forKey:@"IEME"];
    //    NSData *requestData = [dic JSONData];
    //    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/getOneDayGPSData?IMEI=%@&date=%@",ipAddr,@"860719021423573",date];
    NSLog(@"获取遥控列表url %@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSLog(@"GetOneDayGPSData error = %@", error);
    if(data)
    {
        //NSLog(@"data = %@", [SmartHomeAPIs toDictionary:data]);
        
        return [[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"];
        
    }
    else
    {
        return [[NSDictionary alloc]initWithObjectsAndKeys:@"fail",@"result",nil];
    }
    
}

//7.1 返回子地址列表
+ (NSDictionary *)GetChildAddressList:(NSString *)address{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/disableCommunityAOP/address/get_address_child_list.action?id=%@",ipAddr,address];
    NSLog(@"返回子地址列表 %@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    //NSLog(@"GetOneDayGPSData error = %@", error);
    if(data)
    {
        //NSLog(@"data = %@", [SmartHomeAPIs toDictionary:data]);
        
        return [[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"];
        
    }
    else
    {
        return [[NSDictionary alloc]initWithObjectsAndKeys:@"fail",@"result",nil];
    }

}
//7.2 按区域统计用户数目
+ (NSDictionary *)GetRegionUserNumber:(NSString*)address{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/disableCommunityAOP/statistic/get_user_number_by_area_mobile.action?id=%@",ipAddr,address];
    NSLog(@"%@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if(data)
    {
        //NSLog(@"data = %@", [SmartHomeAPIs toDictionary:data]);
        
        return [[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"];
        
    }
    else
    {
        return [[NSDictionary alloc]initWithObjectsAndKeys:@"fail",@"result",nil];
    }
}
//7.3 按区域统计设备数目
+ (NSDictionary *)GetRegionDeviceNumber:(NSString *)address{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/disableCommunityAOP/statistic/get_device_number_by_area.action?id=%@",ipAddr,address];
    NSLog(@"返回子地址列表 %@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if(data)
    {
        //NSLog(@"data = %@", [SmartHomeAPIs toDictionary:data]);
        
        return [[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"];
        
    }
    else
    {
        return [[NSDictionary alloc]initWithObjectsAndKeys:@"fail",@"result",nil];
    }
}
//7.4 按区域统计设备使用次数
+ (NSDictionary *)GetRegionDeviceUseNumber:(NSString *)address{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/disableCommunityAOP/statistic/get_device_rate.action?id=%@",ipAddr,address];
    NSLog(@"%@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if(data)
    {
        //NSLog(@"data = %@", [SmartHomeAPIs toDictionary:data]);
        
        return [[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"];
        
    }
    else
    {
        return [[NSDictionary alloc]initWithObjectsAndKeys:@"fail",@"result",nil];
    }
}

//7.5 获取中控列表
+ (NSDictionary *)GetControllerList:(NSString *)address{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/disableCommunityAOP/device/getMyControllerListByAddressId?addressId=%@",ipAddr,address];
    NSLog(@"获取中控列表 %@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if(data)
    {
        //NSLog(@"data = %@", [SmartHomeAPIs toDictionary:data]);
        
        return [[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"];
        
    }
    else
    {
        return [[NSDictionary alloc]initWithObjectsAndKeys:@"fail",@"result",nil];
    }
}
@end
