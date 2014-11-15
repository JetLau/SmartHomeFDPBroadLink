//
//  BtnStudyViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 14-11-9.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BtnStudyViewController.h"
#import "BLRM2StudyModel.h"
#import "RMDeviceManager.h"
#import "ProgressHUD.h"
@interface BtnStudyViewController()
{
    dispatch_queue_t networkQueue;
}

@end

@implementation BtnStudyViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*Init network queue.*/
    networkQueue = dispatch_queue_create("BroadLinkNetworkQueue", DISPATCH_QUEUE_CONCURRENT);
    //NSLog(@"view  load");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)studyBtnClicked:(UIButton *)sender
{
    [ProgressHUD show:@"正在学习按键"];
    self.view.userInteractionEnabled = NO;
    dispatch_async(networkQueue, ^{
        //        UIButton *studyBtn = (UIButton *) sender;
        //        [studyBtn setEnabled:NO];
        
        BLRM2StudyModel * rm2StudyModel = [BLRM2StudyModel studyModelWithArgument:_info];
        NSString * code = [rm2StudyModel rm2StudyModelStart];
        NSString *data;
        if ([code intValue] == 0) {
            //成功进入学习模式，提示用户操作遥控器
            //[NSTimer scheduledTimerWithTimeInterval:1.0 target:rm2StudyModel selector:@selector(rm2StudyControlData) userInfo:nil repeats:YES];
            //[_showInfoLabel setText:@"已经进入学习模式，请操作遥控器！"];
            
            //[ProgressHUD show:@"已经进入学习模式，请操作遥控器！"];
            
            data = [rm2StudyModel rm2GetControlData];
            if (data != nil) {
                //成功获得学习码
                NSLog(@"get--%@",data);
                RMDeviceManager *rmDeviceManager=[[RMDeviceManager alloc]init];
                [rmDeviceManager initRMDeviceManage];
                //NSLog(@"btnId--%i",button.tag);
                [rmDeviceManager saveSendData:_rmDeviceIndex btnId:_btnId sendData:data];
                //[_showInfoLabel setText:@"成功学习！"];
                [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"学习成功！"waitUntilDone:YES];
                //[ProgressHUD showSuccess:@"学习成功！"];
                //self.view.userInteractionEnabled = YES;
                
                return;
            } else {
                //学习码获取失败
                NSLog(@"\n学习码获取失败\n");
                //[_showInfoLabel setText:@"学习失败，请重试！"];
//                [ProgressHUD showError:@"学习失败，请重试！"];
//                self.view.userInteractionEnabled = YES;
                  [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"学习失败，请重试！"waitUntilDone:YES];
                return;
            }
        } else {
            //[_showInfoLabel setText:@"未能成功进入学习模式，请重试！"];
//            [ProgressHUD showError:@"未能成功进入学习模式，请重试！"];
//            self.view.userInteractionEnabled = YES;
            [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"未能成功进入学习模式，请重试！" waitUntilDone:YES];
            return;
        }
        
        //        [studyBtn setEnabled:YES];
    });
}

- (IBAction)saveVoiceTextBtnClicked:(id)sender {
    NSString *voiceText = [NSString stringWithString:self.vocieTextField.text];
    if([voiceText isEqualToString:@""])
    {
        [ProgressHUD showError:@"语音命令不可为空！"];
        return;
    }
    [ProgressHUD show:@"正在保存"];
    dispatch_async(networkQueue, ^{
        RMDeviceManager *rmDeviceManager=[[RMDeviceManager alloc]init];
        [rmDeviceManager initRMDeviceManage];
        //NSLog(@"btnId--%i",button.tag);
        BOOL TORF = [rmDeviceManager saveVoiceInfo:_rmDeviceIndex btnId:_btnId voiceInfo:voiceText];
        if (TORF) {
            [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"成功保存" waitUntilDone:YES];
            return;
        }else
        {
            [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"保存失败" waitUntilDone:YES];
            return;
        }
    });
    
}

- (void) successWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showSuccess:message];
}

- (void) errorWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showError:message];
}

//点击空白区域，键盘收起
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end