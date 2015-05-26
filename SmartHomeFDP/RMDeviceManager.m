//
//  RMDeviceManage.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-8.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "RMDeviceManager.h"
#import "RMButton.h"
#import "MJExtension.h"
@implementation RMDeviceManager

+(instancetype) createRMDeviceManager
{
    RMDeviceManager * rmDeviceManager = [[RMDeviceManager alloc]init];
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults stringForKey:@"username"];
    rmDeviceManager.docPath = [doc stringByAppendingPathComponent:userName];
    rmDeviceManager.fileName = [userName stringByAppendingFormat:@"%@",@"RMDeviceInfo.plist"];
    rmDeviceManager.path = [rmDeviceManager.docPath stringByAppendingPathComponent:rmDeviceManager.fileName];
    //self.path=[[NSBundle mainBundle]pathForResource:@"RMDeviceInfo" ofType:@"plist"];
    
    NSLog(@"path = %@",rmDeviceManager.path);
    [rmDeviceManager readRMDeviceInfoFromFile];
    return rmDeviceManager;
}

-(void)initRMDeviceManage
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults stringForKey:@"username"];
    self.docPath = [doc stringByAppendingPathComponent:userName];
    self.fileName = [userName stringByAppendingFormat:@"%@",@"RMDeviceInfo.plist"];
    self.path = [self.docPath stringByAppendingPathComponent:self.fileName];
    //self.path=[[NSBundle mainBundle]pathForResource:@"RMDeviceInfo" ofType:@"plist"];
    
    //NSLog(@"%@",self.path);
    [self readRMDeviceInfoFromFile];
}

-(BOOL) userDocIsExist
{
    NSFileManager *fileManager;
    fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:self.docPath isDirectory:NO];
}

-(BOOL)RMDeviceInfoPlistExist
{
    NSFileManager *fileManager;
    fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:self.path isDirectory:NO];
}

-(void)createRMDeviceInfoPlist
{
    BOOL plistExist=[self RMDeviceInfoPlistExist];
    if(!plistExist)
    {
        NSFileManager *fileManager;
        fileManager=[NSFileManager defaultManager];
        
        [fileManager createFileAtPath:self.path contents:nil attributes:nil];
    }
}

-(void)readRMDeviceInfoFromFile
{
    BOOL docIsExist = [self userDocIsExist];
    if (!docIsExist) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // 创建目录
        [fileManager createDirectoryAtPath:self.docPath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        BOOL plistExist=[self RMDeviceInfoPlistExist];
        if(!plistExist)
        {
            [self createRMDeviceInfoPlist];
            self.RMDeviceArray=[[NSMutableArray alloc]init];
        }
        else
        {
            self.RMDeviceArray=[[NSMutableArray alloc]initWithContentsOfFile:self.path];
        }
    }
    
}

-(int)addRMDeviceInfoIntoFile:(RMDevice *)rmDevice
{
    NSMutableDictionary *deviceDic=[[NSMutableDictionary alloc]init];
    [deviceDic setValue:rmDevice.type forKey:@"type"];
    [deviceDic setValue:rmDevice.name forKey:@"name"];
    [deviceDic setValue:rmDevice.mac forKey:@"mac"];
    
    NSMutableArray *rmDeviceArray=[[NSMutableArray alloc]init];
    for(int i=0;i<[rmDevice.RMButtonArray count];i++)
    {
        RMButton *rmButton=[rmDevice.RMButtonArray objectAtIndex:i];
        NSMutableDictionary *rmDeviceDic=[[NSMutableDictionary alloc]init];
        [rmDeviceDic setObject:[[NSNumber alloc]initWithInt:rmButton.buttonId] forKey:@"buttonId"];
        [rmDeviceDic setObject:rmButton.sendData forKey:@"sendData"];
        [rmDeviceDic setObject:rmButton.buttonInfo forKey:@"buttonInfo"];
        [rmDeviceDic setObject:rmButton.btnName forKey:@"btnName"];
        
        [rmDeviceArray addObject:rmDeviceDic];
    }
    [deviceDic setValue:rmDeviceArray forKey:@"buttonArray"];
    //NSLog(@"deviceDic = %@",deviceDic);
    [self.RMDeviceArray addObject:deviceDic];
    
    [self.RMDeviceArray writeToFile:self.path atomically:YES];
    
    //返回这个device是第几项
    return [self getRMDeviceCount]-1;
}

-(RMDevice *)getRMDevice:(int)index
{
    RMDevice *rmDevice=[[RMDevice alloc] init];
    NSDictionary *deviceDic=[self.RMDeviceArray objectAtIndex:index];
    
    NSString *type=[deviceDic objectForKey:@"type"];
    NSString *name=[deviceDic objectForKey:@"name"];
    NSString *mac=[deviceDic objectForKey:@"mac"];
    
    NSArray *buttonArray=[deviceDic objectForKey:@"buttonArray"];
    //NSLog(@"buttonArray: %@",buttonArray);
    rmDevice.type=type;
    rmDevice.name=name;
    rmDevice.mac = mac;
    for(int i=0;i<[buttonArray count];i++)
    {
        // RMButton *rmButton=[[RMButton alloc]init];
        NSDictionary *buttonDic=[buttonArray objectAtIndex:i];
        [rmDevice addRMButton:buttonDic];
        //        rmButton.buttonId=[[buttonDic objectForKey:@"buttonId"]intValue];
        //        rmButton.sendData=[buttonDic objectForKey:@"sendData"];
        //        rmButton.buttonInfo=[buttonDic objectForKey:@"buttonInfo"];
        //        rmButton.btnName = [buttonDic objectForKey:@"btnName"];
        //        [rmDevice.RMButtonArray addObject:rmButton];
    }
    
    return rmDevice;
}

-(NSDictionary *)getRMButton:(int)index btnId:(int)btnId
{
    NSDictionary *deviceDic=[self.RMDeviceArray objectAtIndex:index];
    
    //NSString *type=[deviceDic objectForKey:@"type"];
    NSArray *arrayBtn=[deviceDic objectForKey:@"buttonArray"];
    NSMutableDictionary * dicBtn;
    int btnCount = [arrayBtn count];
    int arrayId;
    for (arrayId=0; arrayId<btnCount; arrayId++) {
        dicBtn = [arrayBtn objectAtIndex:arrayId];
        if ([[dicBtn valueForKey:@"buttonId"] intValue] == btnId) {
            break;
        }
    }
    return dicBtn;
}

-(void)removeRMDevice:(int)index
{
    [self.RMDeviceArray removeObjectAtIndex:index];
    
    if([self RMDeviceInfoPlistExist])
    {
        [self.RMDeviceArray writeToFile:self.path atomically:YES];
    }
    else
    {
        [self createRMDeviceInfoPlist];
        [self.RMDeviceArray writeToFile:self.path atomically:YES];
    }
}

-(int)getRMDeviceCount
{
    if(self.RMDeviceArray!=nil)
    {
        return [self.RMDeviceArray count];
    }
    else
    {
        return 0;
    }
}

-(BOOL)saveSendData:(int)rmDeviceIndex btnId:(int)btnId sendData:(NSString*)data
{
    NSMutableDictionary *dicDevices=[self.RMDeviceArray objectAtIndex:rmDeviceIndex];
    //RMDevice *device = [rmDeviceManager getRMDevice:super.rmDeviceIndex];
    NSMutableArray *arrayBtn = [dicDevices objectForKey:@"buttonArray"];
    //NSLog(@"arrayBtn %@",arrayBtn);
    NSMutableDictionary * dicBtn;
    int btnCount = [arrayBtn count];
    int arrayId;
    for (arrayId=0; arrayId<btnCount; arrayId++) {
        dicBtn = [arrayBtn objectAtIndex:arrayId];
        if ([[dicBtn valueForKey:@"buttonId"] intValue] == btnId) {
            break;
        }
    }
    if (dicBtn == nil) {
        return FALSE;
    }
    //NSLog(@"_rmDeviceIndex %i dicBtn %@",_rmDeviceIndex,dicBtn);
    [dicBtn setObject:data forKey:@"sendData"];
    
    //[dicBtn setValue:data forKey:@"sendData"];
    [arrayBtn replaceObjectAtIndex:arrayId withObject:dicBtn];
    [dicDevices setObject:arrayBtn forKey:@"buttonArray"];
    [self.RMDeviceArray replaceObjectAtIndex:rmDeviceIndex withObject:dicDevices];
    return [self.RMDeviceArray writeToFile:self.path atomically:YES];
    
}

-(BOOL)saveVoiceInfo:(int)rmDeviceIndex btnId:(int)btnId voiceInfo:(NSString*)voiceInfo
{
    NSMutableDictionary *dicDevices=[self.RMDeviceArray objectAtIndex:rmDeviceIndex];
    //RMDevice *device = [rmDeviceManager getRMDevice:super.rmDeviceIndex];
    NSMutableArray *arrayBtn = [dicDevices objectForKey:@"buttonArray"];
    //NSLog(@"arrayBtn %@",arrayBtn);
    NSMutableDictionary * dicBtn;
    int btnCount = [arrayBtn count];
    int arrayId;
    for (arrayId=0; arrayId<btnCount; arrayId++) {
        dicBtn = [arrayBtn objectAtIndex:arrayId];
        if ([[dicBtn valueForKey:@"buttonId"] intValue] == btnId) {
            break;
        }
    }
    if (dicBtn == nil) {
        return FALSE;
    }
    //NSLog(@"_rmDeviceIndex %i dicBtn %@",_rmDeviceIndex,dicBtn);
    [dicBtn setValue:voiceInfo forKey:@"buttonInfo"];
    [arrayBtn replaceObjectAtIndex:arrayId withObject:dicBtn];
    [dicDevices setValue:arrayBtn forKey:@"buttonArray"];
    [self.RMDeviceArray replaceObjectAtIndex:rmDeviceIndex withObject:dicDevices];
    return [self.RMDeviceArray writeToFile:self.path atomically:YES];
    
}

-(BOOL)saveBtnName:(int)rmDeviceIndex btnId:(int)btnId btnName:(NSString*)btnName
{
    NSMutableDictionary *dicDevices=[self.RMDeviceArray objectAtIndex:rmDeviceIndex];
    //RMDevice *device = [rmDeviceManager getRMDevice:super.rmDeviceIndex];
    NSMutableArray *arrayBtn = [dicDevices objectForKey:@"buttonArray"];
    //NSLog(@"arrayBtn %@",arrayBtn);
    NSMutableDictionary * dicBtn;
    int btnCount = [arrayBtn count];
    int arrayId;
    for (arrayId=0; arrayId<btnCount; arrayId++) {
        dicBtn = [arrayBtn objectAtIndex:arrayId];
        if ([[dicBtn valueForKey:@"buttonId"] intValue] == btnId) {
            break;
        }
    }
    if (dicBtn == nil) {
        return FALSE;
    }
    
    //NSLog(@"_rmDeviceIndex %i dicBtn %@",_rmDeviceIndex,dicBtn);
    [dicBtn setValue:btnName forKey:@"btnName"];
    [arrayBtn replaceObjectAtIndex:arrayId withObject:dicBtn];
    [dicDevices setValue:arrayBtn forKey:@"buttonArray"];
    [self.RMDeviceArray replaceObjectAtIndex:rmDeviceIndex withObject:dicDevices];
    return [self.RMDeviceArray writeToFile:self.path atomically:YES];
    
}

-(BOOL)saveBtnOrigin:(int)rmDeviceIndex btnId:(int)btnId btnX:(CGFloat)btnX btnY:(CGFloat)btnY
{
    NSMutableDictionary *dicDevices=[self.RMDeviceArray objectAtIndex:rmDeviceIndex];
    //RMDevice *device = [rmDeviceManager getRMDevice:super.rmDeviceIndex];
    NSMutableArray *arrayBtn = [dicDevices objectForKey:@"buttonArray"];
    //NSLog(@"arrayBtn %@",arrayBtn);
    NSDictionary * dicBtn;
    int btnCount = [arrayBtn count];
    int arrayId;
    for (arrayId=0; arrayId<btnCount; arrayId++) {
        dicBtn = [arrayBtn objectAtIndex:arrayId];
        if ([[dicBtn valueForKey:@"buttonId"] intValue] == btnId) {
            break;
        }
    }
    if (dicBtn == nil) {
        return FALSE;
    }
    //NSLog(@"_rmDeviceIndex %i dicBtn %@",_rmDeviceIndex,dicBtn);
    [dicBtn setValue:[[NSNumber alloc] initWithFloat:btnX] forKey:@"btnX"];
    [dicBtn setValue:[[NSNumber alloc] initWithFloat:btnY] forKey:@"btnY"];
    
    [arrayBtn replaceObjectAtIndex:arrayId withObject:dicBtn];
    [dicDevices setValue:arrayBtn forKey:@"buttonArray"];
    [self.RMDeviceArray replaceObjectAtIndex:rmDeviceIndex withObject:dicDevices];
    return [self.RMDeviceArray writeToFile:self.path atomically:YES];
}

-(int)getRemoteCount:(NSString*)type
{
    int i = 0;
    int count = self.RMDeviceArray.count;
    for (int j=0;j<count;j++) {
        NSDictionary *dic = [self.RMDeviceArray objectAtIndex:j];
        if([[dic objectForKey:@"type"] isEqualToString:type])
        {
            i++;
        }
    }
    return i;
}


-(int)saveRemoteName:(int)rmDeviceIndex name:(NSString*)name
{
    int count = self.RMDeviceArray.count;
    for (int j=0;j<count;j++) {
        NSDictionary *dic = [self.RMDeviceArray objectAtIndex:j];
        if([[dic objectForKey:@"name"] isEqualToString:name])
        {
            return -1;
        }
    }
    
    NSMutableDictionary *dicDevices=[self.RMDeviceArray objectAtIndex:rmDeviceIndex];
    
    [dicDevices setValue:name forKey:@"name"];
    [self.RMDeviceArray replaceObjectAtIndex:rmDeviceIndex withObject:dicDevices];
    BOOL isSuccess = [self.RMDeviceArray writeToFile:self.path atomically:YES];
    if (isSuccess==TRUE) {
        return 1;
    }else
    {
        return 0;
    }
}

-(int)addRemoteButton:(int)rmDeviceIndex
{
    
    NSMutableDictionary *dicDevices=[self.RMDeviceArray objectAtIndex:rmDeviceIndex];
    NSMutableArray *arrayBtn = [dicDevices objectForKey:@"buttonArray"];
    int btnId = 0;
    
    if ([arrayBtn count] == 0) {
        NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:btnId], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"按钮",@"btnName",[[NSNumber alloc] initWithFloat:0.0],@"btnX",[[NSNumber alloc]initWithFloat:0.0],@"btnY",nil];
        [arrayBtn addObject:dic];
        [dicDevices setValue:arrayBtn forKey:@"buttonArray"];
        
    }else{
        int btnCount = [arrayBtn count];
        for (int i=0; i<btnCount; i++) {
            NSDictionary * dicBtn = [arrayBtn objectAtIndex:i];
            if (btnId < [[dicBtn valueForKey:@"buttonId"] intValue]) {
                btnId = [[dicBtn valueForKey:@"buttonId"] intValue];
            }
        }
        btnId++;
        
        NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:btnId], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"按钮",@"btnName",[[NSNumber alloc]initWithFloat:0.0],@"btnX",[[NSNumber alloc]initWithFloat:0.0],@"btnY",nil];
        [arrayBtn addObject:dic];
        [dicDevices setValue:arrayBtn forKey:@"buttonArray"];
        
    }
    [self.RMDeviceArray replaceObjectAtIndex:rmDeviceIndex withObject:dicDevices];
    [self.RMDeviceArray writeToFile:self.path atomically:YES];
    
    return btnId;
}

-(NSArray *)getBtnArray:(int)index
{
    NSDictionary *deviceDic=[self.RMDeviceArray objectAtIndex:index];
    NSArray *buttonArray=[deviceDic objectForKey:@"buttonArray"];
    return buttonArray;
}

-(void)deleteCustomBtn:(int)rmDeviceIndex btnId:(int)btnId
{
    NSMutableDictionary *dicDevices=[self.RMDeviceArray objectAtIndex:rmDeviceIndex];
    NSMutableArray *arrayBtn = [dicDevices objectForKey:@"buttonArray"];
    int btnCount = [arrayBtn count];
    for (int i=0; i<btnCount; i++) {
        NSDictionary * dicBtn = [arrayBtn objectAtIndex:i];
        if ([[dicBtn valueForKey:@"buttonId"] intValue] == btnId) {
            [arrayBtn removeObjectAtIndex:i];
            break;
        }
    }
    [dicDevices setValue:arrayBtn forKey:@"buttonArray"];
    [self.RMDeviceArray replaceObjectAtIndex:rmDeviceIndex withObject:dicDevices];
    [self.RMDeviceArray writeToFile:self.path atomically:YES];
    
    
}

-(void)saveRemoteListInfoToFile:(NSArray*)array
{
    if(array==nil)
    {
        return;
    }
    if([array count]==0)
    {
        return;
    }
    
    //    NSMutableArray *remoteListArray=[[NSMutableArray alloc]init];
    //    for(int i=0;i<[array count];i++)
    //    {
    //        NSDictionary *remote=[array objectAtIndex:i];
    //        NSString *remote_mac=[remote objectForKey:@"mac"];
    //        NSString *remote_name=[remote objectForKey:@"remote_name"];
    //        NSNumber *dev_state=[remote objectForKey:@"state"];
    //        NSString *dev_type=[remote objectForKey:@"type"];
    //
    //        NSMutableDictionary *dev_dic=[[NSMutableDictionary alloc]init];
    //        [dev_dic setObject:dev_id forKey:@"id"];
    //        [dev_dic setObject:dev_mac forKey:@"mac"];
    //        [dev_dic setObject:dev_name forKey:@"name"];
    //        [dev_dic setObject:dev_state forKey:@"state"];
    //        [dev_dic setObject:dev_type forKey:@"type"];
    //
    //        //NSMutableArray *buttonArray=[self getButtonArray:dev_type mac:dev_mac];
    //        //[dev_dic setObject:buttonArray forKey:@"buttonArray"];
    //
    //        [tcpDeviceArray addObject:dev_dic];
    //    }
    //
    //    [tcpDeviceArray writeToFile:self.path atomically:YES];
    [self.RMDeviceArray removeAllObjects];
    for(int i=0;i<[array count];i++)
    {
        NSDictionary *remote=[array objectAtIndex:i];
        
        [self addRemote:remote];
        
        //        NSMutableDictionary *remoteDic=[[NSMutableDictionary alloc]init];
        //        [remoteDic setValue:[remote objectForKey:@"mac"] forKey:@"mac"];
        //        [remoteDic setValue:[remote objectForKey:@"remote_name"] forKey:@"name"];
        //        [remoteDic setValue:[remote objectForKey:@"remote_type"] forKey:@"type"];
        //        NSArray *remoteBtnArray = [remote objectForKey:@"buttons"];
        //        NSMutableArray *btnArray=[[NSMutableArray alloc]init];
        //        for (int j=0; j<[remoteBtnArray count]; j++) {
        //            NSDictionary *btn=[remoteBtnArray objectAtIndex:i];
        //
        //            NSMutableDictionary *btnDic=[[NSMutableDictionary alloc]init];
        //            [btnDic setObject:[[NSNumber alloc]initWithInt:[[btn objectForKey:@"btn_id"] intValue]] forKey:@"buttonId"];
        //            [btnDic setObject:[btn objectForKey:@"wave"] forKey:@"sendData"];
        //            [btnDic setObject:[btn objectForKey:@"voice"] forKey:@"buttonInfo"];
        //            [btnDic setObject:[btn objectForKey:@"btn_name"] forKey:@"btnName"];
        //
        //            [btnArray addObject:btnDic];
        //        }
        //        [remoteDic setValue:btnArray forKey:@"buttonArray"];
        //        [self.RMDeviceArray addObject:remoteDic];
        //    }
        //
        //    [self.RMDeviceArray writeToFile:self.path atomically:YES];
        
        
    }
    
}
-(void)addRemote:(NSDictionary*)remote
{
    RMDevice *rmDevice=[RMDevice itemDevice];
    rmDevice.mac = [remote objectForKey:@"mac"];
    NSString *remoteType = [remote objectForKey:@"remote_type"];
    NSMutableDictionary *btnDic;
    
    if ([remoteType isEqualToString:@"TV"]) {
        rmDevice.type=remoteType;
        rmDevice.name=[remote objectForKey:@"remote_name"];
        
        NSArray *remoteBtnArray = [remote objectForKey:@"buttons"];
        for (int i=0; i<7; i++) {
            btnDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:i], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
            
            for (int j=0; j<[remoteBtnArray count]; j++) {
                NSDictionary *btn=[remoteBtnArray objectAtIndex:j];
                if (i == [[btn objectForKey:@"btn_id"] intValue]) {
                    [btnDic setObject:[[NSNumber alloc]initWithInt:[[btn objectForKey:@"btn_id"] intValue]] forKey:@"buttonId"];
                    [btnDic setObject:[btn objectForKey:@"wave"] forKey:@"sendData"];
                    [btnDic setObject:[btn objectForKey:@"voice"] forKey:@"buttonInfo"];
                    [btnDic setObject:[btn objectForKey:@"btn_name"] forKey:@"btnName"];
                }
                
            }
            
            [rmDevice addRMButton:btnDic];
            
        }
        
    } else if([remoteType isEqualToString:@"AirCondition"]){
        rmDevice.type=remoteType;
        rmDevice.name=[remote objectForKey:@"remote_name"];
        
        NSArray *remoteBtnArray = [remote objectForKey:@"buttons"];
        for (int i=0; i<3; i++) {
            btnDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:i], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
            
            for (int j=0; j<[remoteBtnArray count]; j++) {
                NSDictionary *btn=[remoteBtnArray objectAtIndex:j];
                if (i == [[btn objectForKey:@"btn_id"] intValue]) {
                    [btnDic setObject:[[NSNumber alloc]initWithInt:[[btn objectForKey:@"btn_id"] intValue]] forKey:@"buttonId"];
                    [btnDic setObject:[btn objectForKey:@"wave"] forKey:@"sendData"];
                    [btnDic setObject:[btn objectForKey:@"voice"] forKey:@"buttonInfo"];
                    [btnDic setObject:[btn objectForKey:@"btn_name"] forKey:@"btnName"];
                }
                
            }
            
            [rmDevice addRMButton:btnDic];
            
        }
    }else if([remoteType isEqualToString:@"Curtain"]){
        rmDevice.type=remoteType;
        rmDevice.name=[remote objectForKey:@"remote_name"];
        
        NSArray *remoteBtnArray = [remote objectForKey:@"buttons"];
        for (int i=0; i<3; i++) {
            btnDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:i], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
            
            for (int j=0; j<[remoteBtnArray count]; j++) {
                NSDictionary *btn=[remoteBtnArray objectAtIndex:j];
                if (i == [[btn objectForKey:@"btn_id"] intValue]) {
                    [btnDic setObject:[[NSNumber alloc]initWithInt:[[btn objectForKey:@"btn_id"] intValue]] forKey:@"buttonId"];
                    [btnDic setObject:[btn objectForKey:@"wave"] forKey:@"sendData"];
                    [btnDic setObject:[btn objectForKey:@"voice"] forKey:@"buttonInfo"];
                    [btnDic setObject:[btn objectForKey:@"btn_name"] forKey:@"btnName"];
                }
                
            }
            
            [rmDevice addRMButton:btnDic];
        }
        
    }else if([remoteType isEqualToString:@"Projector"]){
        rmDevice.type=remoteType;
        rmDevice.name=[remote objectForKey:@"remote_name"];
        
        NSArray *remoteBtnArray = [remote objectForKey:@"buttons"];
        for (int i=0; i<2; i++) {
            btnDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:i], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
            
            for (int j=0; j<[remoteBtnArray count]; j++) {
                NSDictionary *btn=[remoteBtnArray objectAtIndex:j];
                if (i == [[btn objectForKey:@"btn_id"] intValue]) {
                    [btnDic setObject:[[NSNumber alloc]initWithInt:[[btn objectForKey:@"btn_id"] intValue]] forKey:@"buttonId"];
                    [btnDic setObject:[btn objectForKey:@"wave"] forKey:@"sendData"];
                    [btnDic setObject:[btn objectForKey:@"voice"] forKey:@"buttonInfo"];
                    [btnDic setObject:[btn objectForKey:@"btn_name"] forKey:@"btnName"];
                    break;
                }
                
            }
            
            [rmDevice addRMButton:btnDic];
        }
        
    }else if([remoteType isEqualToString:@"Light"]){
        rmDevice.type=remoteType;
        rmDevice.name=[remote objectForKey:@"remote_name"];
        
        NSArray *remoteBtnArray = [remote objectForKey:@"buttons"];
        for (int i=0; i<2; i++) {
            btnDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:i], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
            
            for (int j=0; j<[remoteBtnArray count]; j++) {
                NSDictionary *btn=[remoteBtnArray objectAtIndex:j];
                if (i == [[btn objectForKey:@"btn_id"] intValue]) {
                    [btnDic setObject:[[NSNumber alloc]initWithInt:[[btn objectForKey:@"btn_id"] intValue]] forKey:@"buttonId"];
                    [btnDic setObject:[btn objectForKey:@"wave"] forKey:@"sendData"];
                    [btnDic setObject:[btn objectForKey:@"voice"] forKey:@"buttonInfo"];
                    [btnDic setObject:[btn objectForKey:@"btn_name"] forKey:@"btnName"];
                    break;
                }
                
            }
            
            [rmDevice addRMButton:btnDic];
        }
        
    }else if([remoteType isEqualToString:@"Custom"]){
        rmDevice.type=remoteType;
        rmDevice.name=[remote objectForKey:@"remote_name"];
        
        NSArray *remoteBtnArray = [remote objectForKey:@"buttons"];
        for (int j=0; j<[remoteBtnArray count]; j++) {
            btnDic=[[NSMutableDictionary alloc] init];
            NSDictionary *btn=[remoteBtnArray objectAtIndex:j];
            [btnDic setObject:[[NSNumber alloc]initWithInt:[[btn objectForKey:@"btn_id"] intValue]] forKey:@"buttonId"];
            [btnDic setObject:[btn objectForKey:@"wave"] forKey:@"sendData"];
            [btnDic setObject:[btn objectForKey:@"voice"] forKey:@"buttonInfo"];
            [btnDic setObject:[btn objectForKey:@"btn_name"] forKey:@"btnName"];
            
            [rmDevice addRMButton:btnDic];
        }
        
    }else{
        NSLog(@"添加下载遥控失败！！！%@",[remote objectForKey:@"remote_name"]);
        //error
        return;
    }
    
    NSLog(@"%@ add to plist",remoteType);
    [self addRMDeviceInfoIntoFile:rmDevice];
}

@end
