//
//  LJHotStatusViewController.m
//  NewProject
//
//  Created by eddie on 14-9-4.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "DeviceViewController.h"
#import "RMDeviceManager.h"
#import "BtnStudyViewController.h"
#import "ChangeRemoteNameViewController.h"
#import "BLRM2StudyModel.h"
#import "ProgressHUD.h"
#import "StatisticFileManager.h"
@interface DeviceViewController ()
{
    //RMDeviceManager *rmDeviceManager;
    dispatch_queue_t networkQueue;

}
@end

@implementation DeviceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //隐藏tabbar工具条
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    networkQueue = dispatch_queue_create("BroadLinkRM2NetworkQueue", DISPATCH_QUEUE_SERIAL);
//    rmDeviceManager=[[RMDeviceManager alloc]init];
//    [rmDeviceManager initRMDeviceManage];
    self.view.backgroundColor = [UIColor whiteColor];

    /*Add changeButtonItem button*/
    UIBarButtonItem *changeNameItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(changeBarButtonItemClicked:)];
    //[changeButtonItem setTintColor:[UIColor colorWithRed:132.0f/255.0f green:174.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [self.navigationItem setRightBarButtonItem:changeNameItem];

}

- (void) viewWillAppear:(BOOL)animated
{
    RMDeviceManager *rmDeviceManager=[RMDeviceManager createRMDeviceManager];
    //[rmDeviceManager initRMDeviceManage];
    //NSLog(@"rmDeviceManager.RMDeviceArray = %@",rmDeviceManager.RMDeviceArray);
    NSDictionary *dicDevices=[rmDeviceManager.RMDeviceArray objectAtIndex:_rmDeviceIndex];
    [self.navigationItem setTitle:[dicDevices objectForKey:@"name"]];
    //NSLog(@"plist中第 %d 项",_rmDeviceIndex);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int)addDevice
{
    RMDeviceManager *rmDeviceManager=[RMDeviceManager createRMDeviceManager];
    //[rmDeviceManager initRMDeviceManage];
    
    RMDevice *rmDevice=[RMDevice itemDevice];
    rmDevice.mac = _info.mac;
    if ([_remoteType isEqualToString:@"TV"]) {
        rmDevice.type=_remoteType;
        int remoteCount = [rmDeviceManager getRemoteCount:_remoteType];
        rmDevice.name=[@"电视" stringByAppendingFormat:@"%@",[NSNumber numberWithInt:remoteCount+1]];
        for (int i = 0; i<7; i++) {
            NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:i], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
            [rmDevice addRMButton:dic];
        }
    } else if([_remoteType isEqualToString:@"AirCondition"]){
        rmDevice.type=_remoteType;
        int remoteCount = [rmDeviceManager getRemoteCount:_remoteType];
        rmDevice.name=[@"空调" stringByAppendingFormat:@"%@",[NSNumber numberWithInt:remoteCount+1]];
        for (int i = 0; i<3; i++) {
            NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:i], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
            [rmDevice addRMButton:dic];
        }
    }else if([_remoteType isEqualToString:@"Curtain"]){
        rmDevice.type=_remoteType;
        int remoteCount = [rmDeviceManager getRemoteCount:_remoteType];
        rmDevice.name=[@"窗帘" stringByAppendingFormat:@"%@",[NSNumber numberWithInt:remoteCount+1]];
        for (int i = 0; i<3; i++) {
            NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:i], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
            [rmDevice addRMButton:dic];
        }
    }else if([_remoteType isEqualToString:@"Projector"]){
        rmDevice.type=_remoteType;
        int remoteCount = [rmDeviceManager getRemoteCount:_remoteType];
        rmDevice.name=[@"投影仪" stringByAppendingFormat:@"%@",[NSNumber numberWithInt:remoteCount+1]];
        for (int i = 0; i<2; i++) {
            NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:i], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
            [rmDevice addRMButton:dic];
        }
    }else if([_remoteType isEqualToString:@"Light"]){
        rmDevice.type=_remoteType;
        int remoteCount = [rmDeviceManager getRemoteCount:_remoteType];
        rmDevice.name=[@"电灯" stringByAppendingFormat:@"%@",[NSNumber numberWithInt:remoteCount+1]];
        for (int i = 0; i<2; i++) {
            NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:i], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
            [rmDevice addRMButton:dic];
        }
    }else if([_remoteType isEqualToString:@"Custom"]){
        rmDevice.type=_remoteType;
        int remoteCount = [rmDeviceManager getRemoteCount:_remoteType];
        rmDevice.name=[@"自定义" stringByAppendingFormat:@"%@",[NSNumber numberWithInt:remoteCount+1]];
        
    }else
    {
        //error
        return -1;
    }
    
   
    //向服务器发送添加remote的信息
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *remoteDic = [[NSMutableDictionary alloc] init];
        [remoteDic setObject:@"addRemote" forKey:@"command"];
        [remoteDic setObject:_info.mac forKey:@"mac"];
        [remoteDic setObject:rmDevice.name forKey:@"name"];
        [remoteDic setObject:rmDevice.type forKey:@"type"];
        //NSLog(@"TV =%@",remoteDic);
        [SmartHomeAPIs AddRemote:remoteDic];
    });
    
    NSLog(@"%@ add to plist",_remoteType);
    return [rmDeviceManager addRMDeviceInfoIntoFile:rmDevice];
}

- (IBAction)buttonClicked:(UIButton *)sender {
    RMDeviceManager *rmDeviceManager=[[RMDeviceManager alloc]init];
    [rmDeviceManager initRMDeviceManage];
    NSDictionary *dicDevices=[rmDeviceManager.RMDeviceArray objectAtIndex:_rmDeviceIndex];
    //RMDevice *device = [rmDeviceManager getRMDevice:super.rmDeviceIndex];
    NSArray *arrayBtn = [dicDevices objectForKey:@"buttonArray"];
    //NSLog(@"arrayBtn %@",arrayBtn);
    UIButton *button = (UIButton *) sender;
    NSDictionary * dicBtn = [arrayBtn objectAtIndex:button.tag];
    _btnId = button.tag;
    //[self operateStatistics:[dicDevices objectForKey:@"type"]];
    //NSLog(@"_rmDeviceIndex %i dicBtn %@",_rmDeviceIndex,dicBtn);
    if ([[dicBtn objectForKey:@"sendData"] isEqualToString:@""]) {
        BtnStudyViewController *btnStudyViewController = [[BtnStudyViewController alloc] init];
        btnStudyViewController.navigationItem.title = @"学习模式";
        btnStudyViewController.rmDeviceIndex = _rmDeviceIndex;
        btnStudyViewController.info = _info;
        btnStudyViewController.btnId = button.tag;
        [self.navigationController pushViewController:btnStudyViewController animated:YES];
    }else{
        dispatch_async(networkQueue, ^{
            //BLRM2StudyModel * rm2StudyModel = [BLRM2StudyModel studyModelWithArgument:_info];
            RMDevice *btnDevice = [rmDeviceManager getRMDevice:_rmDeviceIndex];
            BLRM2StudyModel * rm2StudyModel = [BLRM2StudyModel studyModelWithBLDeviceInfo:_info rmDevice:btnDevice btnId:button.tag];
            NSString * code = [rm2StudyModel rm2SendControlData:[dicBtn objectForKey:@"sendData"]];
            if ([code intValue] == 0) {
                [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"操作成功" waitUntilDone:YES];
            } else {
                [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"失败，请重试！" waitUntilDone:YES];
                
            }
        });
        //NSLog(@"发送 %@",[dicBtn objectForKey:@"sendData"]);
        
    }
}

-(void) operateStatistics :(NSString*)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        StatisticFileManager * statisticManager = [StatisticFileManager createStatisticManager];
        [statisticManager statisticOperateWithType:type andBtnId:_btnId];
    });
}

- (void) successWithMessage:(NSString *)message {
    [ProgressHUD showSuccess:message];
}

- (void) errorWithMessage:(NSString *)message {
    [ProgressHUD showError:message];
}

- (IBAction)btnLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        if ([sender.view isKindOfClass:[UIButton class]]) {
            //UIButton *button = (UIButton *)sender.view;
            //UIView *view = [longPress view];
            UIButton *btn = (UIButton *)sender.view;
           // NSLog(@"长按成功！！！！！！！！！！！%i",btn.tag);
            _btnId = btn.tag;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"重设Button" message:@"重新设置按钮的语音命令或者操作码？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
  
        }
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        //// Yes condition
        NSLog(@"Yes");
        
        BtnStudyViewController *btnStudyViewController = [[BtnStudyViewController alloc] init];
        btnStudyViewController.navigationItem.title = @"学习模式";
        btnStudyViewController.rmDeviceIndex = _rmDeviceIndex;
        btnStudyViewController.info = _info;
        btnStudyViewController.btnId = _btnId;
        
        [self.navigationController pushViewController:btnStudyViewController animated:YES];
       
    } else {
        NSLog(@"No");
        ///// No condition
    }
}

- (void)changeBarButtonItemClicked:(UIBarButtonItem *)item
{
    ChangeRemoteNameViewController *changeRemoteNameViewController = [[ChangeRemoteNameViewController alloc] init];
    changeRemoteNameViewController.navigationItem.title = @"修改面板名称";
    changeRemoteNameViewController.rmDeviceIndex = _rmDeviceIndex;
    changeRemoteNameViewController.info = _info;
    changeRemoteNameViewController.btnId = _btnId;
    
    [self.navigationController pushViewController:changeRemoteNameViewController animated:YES];
}

@end

