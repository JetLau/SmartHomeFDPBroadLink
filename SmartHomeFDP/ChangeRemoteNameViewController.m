//
//  ChangeRemoteNameViewController.h
//  NewProject
//
//  Created by eddie on 14-9-4.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "ChangeRemoteNameViewController.h"
#import "ProgressHUD.h"
#import "RMDeviceManager.h"
#import "SmartHomeAPIs.h"
#define remoteQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface ChangeRemoteNameViewController ()
{
}
@end

@implementation ChangeRemoteNameViewController

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
    /*Add saveButtonItem button*/
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveBarButtonItemClicked)];
    //[saveButtonItem setTintColor:[UIColor colorWithRed:132.0f/255.0f green:174.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [self.navigationItem setRightBarButtonItem:saveButtonItem];
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
    dispatch_async(remoteQueue, ^{
        RMDeviceManager *rmDeviceManager=[RMDeviceManager createRMDeviceManager];

        //NSLog(@"btnId--%i",button.tag);
        //BOOL TORF = [rmDeviceManager saveVoiceInfo:_rmDeviceIndex btnId:_btnId voiceInfo:voiceText];
        NSString * oldName = [[rmDeviceManager getRMDevice:_rmDeviceIndex] name];
        int isSuccess = [rmDeviceManager saveRemoteName:_rmDeviceIndex name:nameText];
        if (isSuccess == 1) {
            
            NSMutableDictionary *remoteDic = [[NSMutableDictionary alloc] init];
            [remoteDic setObject:@"changeName" forKey:@"command"];
            [remoteDic setObject:_info.mac forKey:@"mac"];
            [remoteDic setObject:oldName forKey:@"oldName"];
            [remoteDic setObject:nameText forKey:@"newName"];
            [SmartHomeAPIs ChangeRemoteName:remoteDic];
            
            
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

- (void) successWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showSuccess:message];
    [self.navigationController popViewControllerAnimated:YES];
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
