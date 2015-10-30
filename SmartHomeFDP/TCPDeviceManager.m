//
//  TCPDeviceManager.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-22.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "TCPDeviceManager.h"
#import "TCPDevice.h"
#import "JSONKit.h"
#import "SmartHomeAPIs.h"

@implementation TCPDeviceManager
static TCPDeviceManager *tcpDeviceManager = nil;

+(instancetype)createTCPDeviceManager
{
    @synchronized(self) {
        if(tcpDeviceManager == nil) {
            tcpDeviceManager = [[[self class] alloc] init];
            
            NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *userName = [userDefaults stringForKey:@"username"];
            tcpDeviceManager.docPath = [doc stringByAppendingPathComponent:userName];
            tcpDeviceManager.path = [tcpDeviceManager.docPath stringByAppendingPathComponent:@"TCPDeviceInfo.plist"];
            
            NSLog(@"path=%@",tcpDeviceManager.path);
            
            [tcpDeviceManager readTCPDeviceInfoFromFile];
        }
    }
    
    
    
    
    return tcpDeviceManager;
}

-(void)readTCPDeviceInfoFromFile
{
    BOOL docIsExist = [self userDocIsExist];
    if (!docIsExist) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // 创建目录
        [fileManager createDirectoryAtPath:self.docPath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        BOOL plistExist=[self TCPDeviceInfoPlistExist];
        if(!plistExist)
        {
            self.TCPDeviceArray=[[NSMutableArray alloc]init];
        }
        else
        {
            self.TCPDeviceArray=[[NSMutableArray alloc]initWithContentsOfFile:self.path];
        }
    }
    
}

-(BOOL) userDocIsExist
{
    NSFileManager *fileManager;
    fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:self.docPath isDirectory:NO];
}

-(BOOL)TCPDeviceInfoPlistExist
{
    NSFileManager *fileManager;
    fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:self.path isDirectory:NO];
}

-(void)saveTCPDeviceInfoToFile:(NSArray *)deviceArray
{
    if(deviceArray==nil)
    {
        return;
    }
    if([deviceArray count]==0)
    {
        return;
    }
    
    NSMutableArray *tcpDeviceArray=[[NSMutableArray alloc]init];
    for(int i=0;i<[deviceArray count];i++)
    {
        NSDictionary *dic=[deviceArray objectAtIndex:i];
        NSNumber *dev_id=[dic objectForKey:@"id"];
        NSString *dev_mac=[dic objectForKey:@"mac"];
        NSString *dev_name=[dic objectForKey:@"name"];
        NSNumber *dev_state=[dic objectForKey:@"state"];
        NSString *dev_type=[dic objectForKey:@"type"];
        
        NSMutableDictionary *dev_dic=[[NSMutableDictionary alloc]init];
        [dev_dic setObject:dev_id forKey:@"id"];
        [dev_dic setObject:dev_mac forKey:@"mac"];
        [dev_dic setObject:dev_name forKey:@"name"];
        [dev_dic setObject:dev_state forKey:@"state"];
        [dev_dic setObject:dev_type forKey:@"type"];
        
        NSMutableArray *buttonArray=[self getButtonArray:dev_type mac:dev_mac];
        [dev_dic setObject:buttonArray forKey:@"buttonArray"];
        
        [tcpDeviceArray addObject:dev_dic];
    }
    
    [tcpDeviceArray writeToFile:self.path atomically:YES];
}

-(NSMutableArray *)getButtonArray:(NSString *)type mac:(NSString *)mac
{
    NSMutableArray *buttonArray=[[NSMutableArray alloc]init];
    
    for(int i=0;i<2;i++)
    {
        NSDictionary *dic;
        if([type isEqualToString:@"light"])
        {
            dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:42],@"api_id",@"sp1_control",@"command",mac,@"mac",[[NSNumber alloc]initWithInt:i],@"status",[[NSNumber alloc]initWithInt:1],@"op_method", nil];
        }
        else if([type isEqualToString:@"socket"])
        {
            dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:52],@"api_id",@"sp1_control",@"command",mac,@"mac",[[NSNumber alloc]initWithInt:i],@"status",[[NSNumber alloc]initWithInt:1],@"op_method", nil];
        }
        NSData *requestData = [dic JSONData];
        NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
        NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/controlMode.action?remoteCtlRequest=%@",[SmartHomeAPIs GetIPAddress],josnString];
        
        if(i==0)
        {
            NSDictionary *closeButton=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:1],@"buttonId",@"关",@"btnName",@"",@"buttonInfo",urlString,@"sendData", nil];
            [buttonArray addObject:closeButton];
        }
        else
        {
            NSDictionary *closeButton=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:0],@"buttonId",@"开",@"btnName",@"",@"buttonInfo",urlString,@"sendData", nil];
            [buttonArray addObject:closeButton];
        }
    }
    
    return buttonArray;
}

-(int)saveTCPDeviceNameIntoFile:(int)deviceId name:(NSString *)name
{
    //1表示成功、0表示失败、2表示已经存在相同的name
    //判断是否存在相同的name
    for(int i=0;i<[self.TCPDeviceArray count];i++)
    {
        NSDictionary *dic=[self.TCPDeviceArray objectAtIndex:i];
        NSNumber *dev_id=[dic objectForKey:@"id"];
        NSString *dev_name=[dic objectForKey:@"name"];
        if(deviceId!=[dev_id intValue]&&[name isEqualToString:dev_name])
        {
            return 2;
        }
    }
    
    for(int i=0;i<[self.TCPDeviceArray count];i++)
    {
        NSMutableDictionary *dic=[self.TCPDeviceArray objectAtIndex:i];
        NSNumber *dev_id=[dic objectForKey:@"id"];
        if(deviceId==[dev_id intValue])
        {
            [dic setObject:name forKey:@"name"];
            break;
        }
    }
    
    if([self.TCPDeviceArray writeToFile:self.path atomically:YES])
    {
        return 1;
    }
    else
    {
        return 0;
    }

}

-(int)saveTCPButtonNameIntoFile:(int)deviceId buttonId:(int)buttonId name:(NSString *)name
{
    //1表示成功、0表示失败、2表示已经存在相同的name
    NSMutableArray *buttonArray;
    for(int i=0;i<[self.TCPDeviceArray count];i++)
    {
        NSDictionary *dic=[self.TCPDeviceArray objectAtIndex:i];
        NSNumber *dev_id=[dic objectForKey:@"id"];
        if(deviceId==[dev_id intValue])
        {
            buttonArray=[dic objectForKey:@"buttonArray"];
            break;
        }
    }
    
    for(int i=0;i<[buttonArray count];i++)
    {
        NSMutableDictionary *buttonDic=[buttonArray objectAtIndex:i];
        if(buttonId!=[[buttonDic objectForKey:@"buttonId"]intValue]&&[name isEqualToString:[buttonDic objectForKey:@"btnName"]])
        {
            return 2;
        }
    }
    
    for(int i=0;i<[buttonArray count];i++)
    {
        NSMutableDictionary *buttonDic=[buttonArray objectAtIndex:i];
        if(buttonId==[[buttonDic objectForKey:@"buttonId"]intValue])
        {
            [buttonDic setObject:name forKey:@"btnName"];
            break;
        }
    }
    
    
    if([self.TCPDeviceArray writeToFile:self.path atomically:YES])
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

-(int)saveTCPButtonInfoIntoFile:(int)deviceId buttonId:(int)buttonId info:(NSString *)info
{
    //1表示成功、0表示失败
    NSMutableArray *buttonArray;
    for(int i=0;i<[self.TCPDeviceArray count];i++)
    {
        NSDictionary *dic=[self.TCPDeviceArray objectAtIndex:i];
        NSNumber *dev_id=[dic objectForKey:@"id"];
        if(deviceId==[dev_id intValue])
        {
            buttonArray=[dic objectForKey:@"buttonArray"];
            break;
        }
    }
    
    for(int i=0;i<[buttonArray count];i++)
    {
        NSMutableDictionary *buttonDic=[buttonArray objectAtIndex:i];
        if(buttonId==[[buttonDic objectForKey:@"buttonId"]intValue])
        {
            [buttonDic setObject:info forKey:@"buttonInfo"];
            break;
        }
    }
    
    
    if([self.TCPDeviceArray writeToFile:self.path atomically:YES])
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

-(NSDictionary *)getRMButton:(int)deviceId btnId:(int)btnId
{
    NSMutableArray *buttonArray;
    for(int i=0;i<[self.TCPDeviceArray count];i++)
    {
        NSDictionary *dic=[self.TCPDeviceArray objectAtIndex:i];
        NSNumber *dev_id=[dic objectForKey:@"id"];
        if(deviceId==[dev_id intValue])
        {
            buttonArray=[dic objectForKey:@"buttonArray"];
            break;
        }
    }
   
    NSMutableDictionary * dicBtn;
    int btnCount = [buttonArray count];
    int arrayId;
    for (arrayId=0; arrayId<btnCount; arrayId++) {
        dicBtn = [buttonArray objectAtIndex:arrayId];
        if ([[dicBtn valueForKey:@"buttonId"] intValue] == btnId) {
            break;
        }
    }
    return dicBtn;
}


-(void) removeTCPDevcie:(int)index
{
    [self.TCPDeviceArray removeObjectAtIndex:index];
    [self.TCPDeviceArray writeToFile:self.path atomically:YES];
}

@end