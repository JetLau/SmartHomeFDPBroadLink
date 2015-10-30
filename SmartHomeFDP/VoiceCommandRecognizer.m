//
//  VoiceCommandRecognizer.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-13.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "VoiceCommandRecognizer.h"
#import "TCPDeviceManager.h"
#import "RMDeviceManager.h"
#import "JSONKit.h"
#import "BLNetwork.h"
#import "SmartHomeAPIs.h"
#import "ProgressHUD.h"
#import "StatisticFileManager.h"
#import "ScenePlistManager.h"
#define remoteQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation VoiceCommandRecognizer

+(instancetype)createVoiceCommandRecognizer
{
    VoiceCommandRecognizer *voiceCommandRecognizer=[[VoiceCommandRecognizer alloc]init];
    voiceCommandRecognizer.rmDeviceManager=[RMDeviceManager createRMDeviceManager];
    voiceCommandRecognizer.tcpDeviceManager=[TCPDeviceManager createTCPDeviceManager];
    voiceCommandRecognizer.scenePlistManager=[ScenePlistManager createScenePlistManager];
    
    voiceCommandRecognizer.network=[[BLNetwork alloc]init];
    
    return voiceCommandRecognizer;
}

-(void)voiceCommandRecognize:(NSString *)voiceCommandStr
{
    NSArray *rmDeviceArray=self.rmDeviceManager.RMDeviceArray;
    NSArray *tcpDeviceArray=self.tcpDeviceManager.TCPDeviceArray;
    NSArray *sceneArray = self.scenePlistManager.SceneArray;
    
    //匹配Remote设备
    for(int i=0;i<[rmDeviceArray count];i++)
    {
        NSDictionary *dic=[rmDeviceArray objectAtIndex:i];
        NSArray *buttonArray=[dic objectForKey:@"buttonArray"];
        for(int j=0;j<[buttonArray count];j++)
        {
            NSDictionary *buttonDic=[buttonArray objectAtIndex:j];
            NSString *buttonInfo=[buttonDic objectForKey:@"buttonInfo"];
            
            if([buttonInfo isEqualToString:@""])
            {
                continue;
            }
            NSMutableString *voiceCommandPY=[[NSMutableString alloc]initWithString:voiceCommandStr];
            NSMutableString *buttonInfoPY=[[NSMutableString alloc]initWithString:buttonInfo];
            CFStringTransform((__bridge CFMutableStringRef)voiceCommandPY, 0, kCFStringTransformMandarinLatin, NO);
            CFStringTransform((__bridge CFMutableStringRef)voiceCommandPY, 0, kCFStringTransformStripCombiningMarks, NO);
            CFStringTransform((__bridge CFMutableStringRef)buttonInfoPY, 0, kCFStringTransformMandarinLatin, NO);
            CFStringTransform((__bridge CFMutableStringRef)buttonInfoPY, 0, kCFStringTransformStripCombiningMarks, NO);
            
            NSRange range=[voiceCommandPY rangeOfString:buttonInfoPY];
            // NSLog(@"拼音    %@  %@",voiceCommandPY,buttonInfoPY);
            //NSRange range=[voiceCommandStr rangeOfString:buttonInfo];
            if(range.location !=NSNotFound)
            {
                //匹配成功
                // [self operateStatistics:0];
                
                NSString *mac=[dic objectForKey:@"mac"];
                NSString *name=[dic objectForKey:@"name"];
                NSNumber *buttonId=[buttonDic objectForKey:@"buttonId"];
                NSString *sendData=[buttonDic objectForKey:@"sendData"];
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:[NSNumber numberWithInt:134] forKey:@"api_id"];
                [dic setObject:@"rm2_send" forKey:@"command"];
                [dic setObject:mac forKey:@"mac"];
                [dic setObject:sendData forKey:@"data"];
                NSData *requestData = [dic JSONData];
                NSData *responseData = [_network requestDispatch:requestData];
                
                dispatch_async(remoteQueue, ^{
                    int success = ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue]==0) ? 0:1;
                    //NSLog(@"success = %d",success);
                    NSMutableDictionary *remoteDic = [[NSMutableDictionary alloc] init];
                    [remoteDic setObject:@"rm2Send" forKey:@"command"];
                    [remoteDic setObject:mac forKey:@"mac"];
                    [remoteDic setObject:name forKey:@"name"];
                    [remoteDic setObject:buttonId forKey:@"buttonId"];
                    [remoteDic setObject:sendData forKey:@"sendData"];
                    [remoteDic setObject:[NSNumber numberWithInt:success] forKey:@"success"];
                    [remoteDic setObject:[NSNumber numberWithInt:1] forKey:@"op_method"];
                    
                    NSString *result=[SmartHomeAPIs Rm2SendData:remoteDic];
                    if (success == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [ProgressHUD showSuccess:@"语音控制成功"];
                        });
                    }
                    
                    if([result isEqualToString:@"success"])
                    {
                        //                        dispatch_async(dispatch_get_main_queue(), ^{
                        //                            [ProgressHUD showSuccess:@"语音控制成功"];
                        //                        });
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [ProgressHUD showSuccess:@"语音命令上传失败"];
                        });
                    }
                });
                
                return;
            }
        }
    }
    
    //匹配TCP设备
    for(int i=0;i<[tcpDeviceArray count];i++)
    {
        NSDictionary *dic=[tcpDeviceArray objectAtIndex:i];
        NSArray *buttonArray=[dic objectForKey:@"buttonArray"];
        for(int j=0;j<[buttonArray count];j++)
        {
            NSDictionary *buttonDic=[buttonArray objectAtIndex:j];
            NSString *buttonInfo=[buttonDic objectForKey:@"buttonInfo"];
            
            if([buttonInfo isEqualToString:@""])
            {
                continue;
            }
            
            NSMutableString *voiceCommandPY=[[NSMutableString alloc]initWithString:voiceCommandStr];
            NSMutableString *buttonInfoPY=[[NSMutableString alloc]initWithString:buttonInfo];
            CFStringTransform((__bridge CFMutableStringRef)voiceCommandPY, 0, kCFStringTransformMandarinLatin, NO);
            CFStringTransform((__bridge CFMutableStringRef)voiceCommandPY, 0, kCFStringTransformStripCombiningMarks, NO);
            CFStringTransform((__bridge CFMutableStringRef)buttonInfoPY, 0, kCFStringTransformMandarinLatin, NO);
            CFStringTransform((__bridge CFMutableStringRef)buttonInfoPY, 0, kCFStringTransformStripCombiningMarks, NO);
            
            NSRange range=[voiceCommandPY rangeOfString:buttonInfoPY];
            //NSLog(@"拼音    %@  %@",voiceCommandPY,buttonInfoPY);
            //NSRange range=[voiceCommandStr rangeOfString:buttonInfo];
            if(range.location !=NSNotFound)
            {
                //匹配成功
                // [self operateStatistics:0];
                NSString *sendData=[buttonDic objectForKey:@"sendData"];
                
                NSString *success=[SmartHomeAPIs OperateVoiceCommand:sendData];
                if([success isEqualToString:@"fail"])
                {
                    NSString *type=[buttonDic objectForKey:@"type"];
                    NSString *mac=[buttonDic objectForKey:@"mac"];
                    [SmartHomeAPIs AuthTCPDevice:mac type:type];
                    success=[SmartHomeAPIs OperateVoiceCommand:sendData];
                }
                
                if([success isEqualToString:@"success"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ProgressHUD showSuccess:@"语音控制成功"];
                    });
                }
                else if([success isEqualToString:@"Fail"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ProgressHUD showSuccess:@"操作失败，请检查网络！"];
                    });
                }else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ProgressHUD showSuccess:[NSString stringWithString:success]];
                    });
                }
                return;
            }
        }
    }
    
    //匹配场景
    for(int i=0;i<[sceneArray count];i++)
    {
        NSDictionary *dic=[sceneArray objectAtIndex:i];
        NSString *voice=[dic objectForKey:@"voice"];
        
        if([voice isEqualToString:@""])
        {
            continue;
        }
        NSMutableString *voiceCommandPY=[[NSMutableString alloc]initWithString:voiceCommandStr];
        NSMutableString *buttonInfoPY=[[NSMutableString alloc]initWithString:voice];
        CFStringTransform((__bridge CFMutableStringRef)voiceCommandPY, 0, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)voiceCommandPY, 0, kCFStringTransformStripCombiningMarks, NO);
        CFStringTransform((__bridge CFMutableStringRef)buttonInfoPY, 0, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)buttonInfoPY, 0, kCFStringTransformStripCombiningMarks, NO);
        
        NSRange range=[voiceCommandPY rangeOfString:buttonInfoPY];
        // NSLog(@"拼音    %@  %@",voiceCommandPY,buttonInfoPY);
        //NSRange range=[voiceCommandStr rangeOfString:buttonInfo];
        if(range.location !=NSNotFound)
        {
            //匹配成功
            // [self operateStatistics:0];
            NSArray *btnArray = [dic objectForKey:@"buttonArray"];
            int btnCount = [btnArray count];
            __block int failnum = 0;
            if (btnCount == 0) {
                [ProgressHUD showError:@"此场景未添加控制命令"];
            }else{
                
                dispatch_async(serverQueue, ^{
                    for (int i = 0; i < btnCount; i++) {
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        [dic setObject:[NSNumber numberWithInt:134] forKey:@"api_id"];
                        [dic setObject:@"rm2_send" forKey:@"command"];
                        [dic setObject:[[btnArray objectAtIndex:i] objectForKey:@"btnMac"] forKey:@"mac"];
                        [dic setObject:[[btnArray objectAtIndex:i] objectForKey:@"sendData"] forKey:@"data"];
                        NSData *requestData = [dic JSONData];
                        NSData *responseData = [_network requestDispatch:requestData];
                        NSLog(@"%@",[responseData objectFromJSONData]);
                        if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] != 0)
                        {
                            failnum++;
                        }
                        [NSThread sleepForTimeInterval:0.5];
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ProgressHUD showSuccess:[NSString stringWithFormat:@"发送成功%d/%d个",btnCount-failnum,btnCount]];
                    });
                });
                
                
                
            }
            
            
            return;
        }
    }
    //[self operateStatistics:1];
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showSuccess:@"未找到匹配的语音命令"];
    });
    
    return;
}

-(void) operateStatistics:(int)btnId
{
    dispatch_async(dispatch_get_main_queue(), ^{
        StatisticFileManager * statisticManager = [StatisticFileManager createStatisticManager];
        [statisticManager statisticOperateWithType:@"Voice" andBtnId:btnId];
    });
}

@end
