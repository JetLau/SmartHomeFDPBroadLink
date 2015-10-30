//
//  ScenePlistManager.m
//  SmartHomeFDP
//
//  Created by cisl on 15/10/29.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import "ScenePlistManager.h"
#import "RMButton.h"
@implementation ScenePlistManager

static ScenePlistManager *sceneManager = nil;


+(instancetype) createScenePlistManager
{
    @synchronized(self) {
        if(sceneManager == nil) {
            sceneManager = [[[self class] alloc] init];
            
            NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *userName = [userDefaults stringForKey:@"username"];
            sceneManager.docPath = [doc stringByAppendingPathComponent:userName];
            sceneManager.fileName = [userName stringByAppendingFormat:@"%@",@"Scene.plist"];
            sceneManager.path = [sceneManager.docPath stringByAppendingPathComponent:sceneManager.fileName];
            //self.path=[[NSBundle mainBundle]pathForResource:@"RMDeviceInfo" ofType:@"plist"];
            
            NSLog(@"scenePlistManager = %@",sceneManager.path);
            [sceneManager readSceneFromFile];
        }
    }
    
    
    return sceneManager;
}


-(BOOL) userDocIsExist
{
    NSFileManager *fileManager;
    fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:self.docPath isDirectory:NO];
}

-(BOOL)ScenePlistExist
{
    NSFileManager *fileManager;
    fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:self.path isDirectory:NO];
}

-(void)createScenePlist
{
    BOOL plistExist=[self ScenePlistExist];
    if(!plistExist)
    {
        NSFileManager *fileManager;
        fileManager=[NSFileManager defaultManager];
        
        [fileManager createFileAtPath:self.path contents:nil attributes:nil];
    }
}

-(void)readSceneFromFile
{
    BOOL docIsExist = [self userDocIsExist];
    if (!docIsExist) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // 创建目录
        [fileManager createDirectoryAtPath:self.docPath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        BOOL plistExist=[self ScenePlistExist];
        if(!plistExist)
        {
            [self createScenePlist];
            self.SceneArray=[[NSMutableArray alloc]init];
        }
        else
        {
            self.SceneArray=[[NSMutableArray alloc]initWithContentsOfFile:self.path];
            if (self.SceneArray == nil) {
                [self createScenePlist];
                self.SceneArray=[[NSMutableArray alloc]init];
            }
            
        }
    }
    
}

-(int)addNewSceneIntoFile:(NSString *)name andBtnArray:(NSMutableArray*)btnArray andVoice:(NSString*) voice{
    NSMutableDictionary *sceneDic=[[NSMutableDictionary alloc]init];
    [sceneDic setValue:name forKey:@"name"];
    [sceneDic setValue:voice forKey:@"voice"];

    NSMutableArray *btnDicArray=[[NSMutableArray alloc]init];

    for(int i=0;i<[btnArray count];i++)
    {
        RMButton *rmButton=[btnArray objectAtIndex:i];
        NSMutableDictionary *sceneDic=[[NSMutableDictionary alloc]init];
        [sceneDic setObject:[[NSNumber alloc]initWithInt:rmButton.buttonId] forKey:@"buttonId"];
        [sceneDic setObject:rmButton.sendData forKey:@"sendData"];
        [sceneDic setObject:rmButton.buttonInfo forKey:@"buttonInfo"];
        [sceneDic setObject:rmButton.btnName forKey:@"btnName"];
        [sceneDic setObject:rmButton.btnMac forKey:@"btnMac"];

        [btnDicArray addObject:sceneDic];
    }
    [sceneDic setValue:btnDicArray forKey:@"buttonArray"];
    //NSLog(@"self.RMDeviceArray = %@",self.RMDeviceArray);
    [self.SceneArray addObject:sceneDic];
    [self.SceneArray writeToFile:self.path atomically:YES];
    //NSLog(@"RMDeviceArray = %@",self.RMDeviceArray);
    //NSLog(@"self.path = %@",self.path);
    //返回这个device是第几项
    return [self getSceneCount]-1;
}

-(int)getSceneCount
{
    if(self.SceneArray!=nil)
    {
        return [self.SceneArray count];
    }
    else
    {
        return 0;
    }
}
-(BOOL)deleteOneScene:(int)index{
    [self.SceneArray removeObjectAtIndex:index];
    
    if([self ScenePlistExist])
    {
        return [self.SceneArray writeToFile:self.path atomically:YES];
    }
    else
    {
        [self createScenePlist];
        [self.SceneArray writeToFile:self.path atomically:YES];
    }
    return FALSE;
}

-(BOOL)changeSceneInfo:(NSString *)name andBtnArray:(NSMutableArray*)btnArray andVoice:(NSString*) voice andSceneId:(int)sceneId{
    NSMutableDictionary *sceneDic=[[NSMutableDictionary alloc]init];
    [sceneDic setValue:name forKey:@"name"];
    [sceneDic setValue:voice forKey:@"voice"];
    
    NSMutableArray *btnDicArray=[[NSMutableArray alloc]init];
    
    for(int i=0;i<[btnArray count];i++)
    {
        RMButton *rmButton=[btnArray objectAtIndex:i];
        NSMutableDictionary *sceneDic=[[NSMutableDictionary alloc]init];
        [sceneDic setObject:[[NSNumber alloc]initWithInt:rmButton.buttonId] forKey:@"buttonId"];
        [sceneDic setObject:rmButton.sendData forKey:@"sendData"];
        [sceneDic setObject:rmButton.buttonInfo forKey:@"buttonInfo"];
        [sceneDic setObject:rmButton.btnName forKey:@"btnName"];
        [sceneDic setObject:rmButton.btnMac forKey:@"btnMac"];

        [btnDicArray addObject:sceneDic];
    }
    [sceneDic setValue:btnDicArray forKey:@"buttonArray"];
    [self.SceneArray replaceObjectAtIndex:sceneId withObject:sceneDic];
    //NSLog(@"self.RMDeviceArray = %@",self.RMDeviceArray);
    return [self.SceneArray writeToFile:self.path atomically:YES];
}

-(NSMutableArray*) getSceneVoiceList{
    if (self.SceneArray == nil || [self.SceneArray count] == 0) {
        return nil;
    }else{
        NSMutableArray *voicelist = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in self.SceneArray) {
            
            if (![[dic objectForKey:@"voice"] isEqualToString:@""]) {
                [voicelist addObject:[dic objectForKey:@"voice"]];
            }
            
        }
        if([voicelist count] == 0){
            return nil;
        }else{
            return voicelist;
        }
    }
}
@end
