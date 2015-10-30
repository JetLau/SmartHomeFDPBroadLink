//
//  AddCustomBtnViewController.h
//  NewProject
//
//  Created by eddie on 14-9-4.
//  Copyright (c) 2014年 eddie. All rights reserved.
//
#import "AddOrChangeCustomBtnViewController.h"
#import "ProgressHUD.h"
#import "RMDeviceManager.h"
#import "SmartHomeAPIs.h"
#import "BLRM2StudyModel.h"
#define remoteQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface AddOrChangeCustomBtnViewController ()
{
    dispatch_queue_t networkQueue;
}
@end

@implementation AddOrChangeCustomBtnViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    //[self.navigationItem setTitle:@"修改面板名称"];
    networkQueue = dispatch_queue_create("BroadLinkNetworkQueue", DISPATCH_QUEUE_CONCURRENT);
}

-(void) viewWillAppear:(BOOL)animated
{
    RMDeviceManager *rmDeviceManager = [RMDeviceManager createRMDeviceManager];

    if ([_style isEqualToString:@"add"]) {
        _btnId = [rmDeviceManager addRemoteButton:_rmDeviceIndex];
        
    } else {
        NSString * voice = [[rmDeviceManager getRMButton:_rmDeviceIndex btnId:_btnId] objectForKey:@"buttonInfo"];
        [_voiceTextField setText:voice];
    }
    rmDeviceManager = nil;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)saveBarButtonItemClicked{
    NSString *nameText = [NSString stringWithString:self.nameTextField.text];
    if([nameText isEqualToString:@""])
    {
        [ProgressHUD showError:@"面板名不可为空！"];
        return;
    }
    [ProgressHUD show:@"正在保存"];
    dispatch_async(networkQueue, ^{
        RMDeviceManager *rmDeviceManager=[RMDeviceManager createRMDeviceManager];

        //NSLog(@"btnId--%i",button.tag);
        //BOOL TORF = [rmDeviceManager saveVoiceInfo:_rmDeviceIndex btnId:_btnId voiceInfo:voiceText];
        NSString * oldName = [[rmDeviceManager getRMDevice:_rmDeviceIndex] name];
        int isSuccess = [rmDeviceManager saveRemoteName:_rmDeviceIndex name:nameText];
        if (isSuccess == 1) {
            
            dispatch_async(remoteQueue, ^{
                NSMutableDictionary *remoteDic = [[NSMutableDictionary alloc] init];
                [remoteDic setObject:@"changeName" forKey:@"command"];
                [remoteDic setObject:_info.mac forKey:@"mac"];
                [remoteDic setObject:oldName forKey:@"oldName"];
                [remoteDic setObject:nameText forKey:@"newName"];
                [SmartHomeAPIs ChangeRemoteName:remoteDic];
            });
            
            [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"成功保存" waitUntilDone:YES];
            return;
        }else if(isSuccess == 0)
        {
            [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"保存失败" waitUntilDone:YES];
            return;
        }else{
            [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"已经有相同的面板名！" waitUntilDone:YES];
            return;
        }
    });
    
   
}

- (IBAction)studyBtnClicked:(UIButton *)sender {

    [ProgressHUD show:@"正在学习按键"];
    self.view.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled=NO;
    dispatch_async(networkQueue, ^{
 
        RMDeviceManager *rmDeviceManager=[RMDeviceManager createRMDeviceManager];

        RMDevice *btnDevice = [rmDeviceManager getRMDevice:_rmDeviceIndex];
        BLRM2StudyModel * rm2StudyModel = [BLRM2StudyModel studyModelWithBLDeviceInfo:_info rmDevice:btnDevice btnId:_btnId];
        NSString * code = [rm2StudyModel rm2StudyModelStart];
        NSString *data;
        if ([code intValue] == 0) {
            //成功进入学习模式，提示用户操作遥控器
            data = [rm2StudyModel rm2GetControlData];
            if (data != nil) {
                //成功获得学习码
                //NSLog(@"get--%@",data);
                //NSLog(@"btnId--%i",button.tag);
                [rmDeviceManager saveSendData:_rmDeviceIndex btnId:_btnId sendData:data];
                [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"学习成功！"waitUntilDone:YES];
                return;
            } else {
                //学习码获取失败
                NSLog(@"\n学习码获取失败\n");
                [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"学习失败，请重试！"waitUntilDone:YES];
                return;
            }
        } else {
            [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"未能成功进入学习模式，请重试！" waitUntilDone:YES];
            return;
        }
    });
}

- (IBAction)saveNameOrVoiceBtnClicked:(UIButton *)sender
{
    UIButton *btn = (UIButton*)sender;
    NSString * text;
    NSString * command;
    if (btn.tag==0) {
        text = [NSString stringWithString:self.nameTextField.text];
        command = @"changeBtnName";
    }else{
        text = [NSString stringWithString:self.voiceTextField.text];
        command = @"saveButtonVoice";

    }
    if([text isEqualToString:@""])
    {
        [ProgressHUD showError:@"输入框不可为空！"];
        return;
    }
    [ProgressHUD show:@"正在保存"];
    dispatch_async(networkQueue, ^{
        RMDeviceManager *rmDeviceManager=[RMDeviceManager createRMDeviceManager];

        //NSLog(@"btnId--%i",button.tag);
        NSString * name = [[rmDeviceManager getRMDevice:_rmDeviceIndex] name];
        BOOL isSave;
        if (btn.tag==0) {
            isSave = [rmDeviceManager saveBtnName:_rmDeviceIndex btnId:_btnId btnName:text];
        } else {
            isSave = [rmDeviceManager saveVoiceInfo:_rmDeviceIndex btnId:_btnId voiceInfo:text];
        }
        if (isSave) {
            dispatch_async(remoteQueue, ^{
                NSMutableDictionary *remoteDic = [[NSMutableDictionary alloc] init];
                
                [remoteDic setObject:command forKey:@"command"];
                [remoteDic setObject:_info.mac forKey:@"mac"];
                [remoteDic setObject:name forKey:@"name"];
                [remoteDic setObject:[NSNumber numberWithInt:_btnId] forKey:@"buttonId"];
                if ([command isEqualToString:@"changeBtnName"]) {
                    [remoteDic setObject:text forKey:@"btnName"];
                    [SmartHomeAPIs ChangeBtnName:remoteDic];
                }else if([command isEqualToString:@"saveButtonVoice"])
                {
                    [remoteDic setObject:text forKey:@"buttonInfo"];
                    [SmartHomeAPIs SaveButtonVoice:remoteDic];
                }
            });
            
            [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"成功保存" waitUntilDone:YES];
            return;
        }else
        {
            [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"保存失败" waitUntilDone:YES];
            return;
        }
    });

}

- (IBAction)moveView:(id)sender {
    CGRect frame = self.loginView.frame;
    //NSLog(@"loginview = %f",self.loginView.frame.origin.y);

    frame.origin.y = -95;
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.loginView.frame = frame;}
                     completion:^(BOOL finished) {}];
    //NSLog(@"loginview = %f",self.loginView.frame.origin.y);

}

- (void) successWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    self.navigationController.navigationBar.userInteractionEnabled=YES;
    [ProgressHUD showSuccess:message];
}

- (void) errorWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    self.navigationController.navigationBar.userInteractionEnabled=YES;
    [ProgressHUD showError:message];
}

//点击空白区域，键盘收起
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGRect frame = self.loginView.frame;
    frame.origin.y = 80;
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.loginView.frame = frame;}
                     completion:^(BOOL finished) {}];
    [self.view endEditing:YES];
}
@end
