//
//  OEMSLoginViewController.m
//  OfficeEMS_iPhone
//
//  Created by cisl on 14-5-28.
//  Copyright (c) 2014年 WangShengYin. All rights reserved.
//

#import "LoginViewController.h"
#import "ProgressHUD.h"
#import "RootController.h"
#import "SmartHomeAPIs.h"
#import "RegisterViewController.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define CommonUser 5
@interface LoginViewController ()

@end

@implementation LoginViewController

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
    //NSLog(@"view  load");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//点击空白区域，键盘收起
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)loginInButtonClicked:(id)sender {
    
    NSString *username;
    NSString *password;
    
    username = [NSString stringWithString:self.userNameTextField.text];
    password = [NSString stringWithString:self.passwordTextField.text];
   
    
    //用来测试用的用户名密码
    if ([username isEqualToString:@""])
    {
        [ProgressHUD showError:@"用户名不能为空"];
        return;
    }
    if ([password isEqualToString:@""])
    {
        [ProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    [ProgressHUD show:@"正在登录"];
    self.view.userInteractionEnabled = false;
    
    dispatch_async(kBgQueue, ^{
        NSDictionary *status = [SmartHomeAPIs MobileLogin:username password:password];
        NSString *loginSuccess = [[status objectForKey:@"jsonMap"] objectForKey:@"result"];
        //loginSuccess = @"success";
        if ([loginSuccess isEqualToString:@"success"])//登录成功
        {
            NSDictionary *userDic = [status objectForKey:@"jsonMap"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[userDic objectForKey:@"userId"] forKey:@"userId"];
            [userDefaults setObject:[userDic objectForKey:@"username"] forKey:@"username"];
            [userDefaults setObject:password forKey:@"password"];
            [userDefaults setObject:[userDic objectForKey:@"phone"] forKey:@"phone"];
            [userDefaults setObject:[userDic objectForKey:@"gender"] forKey:@"gender"];
            [userDefaults setObject:[userDic objectForKey:@"address"] forKey:@"address"];
            [userDefaults setObject:[userDic objectForKey:@"addressName"] forKey:@"addressName"];
            [userDefaults setObject:[userDic objectForKey:@"role_id"] forKey:@"roleId"];
            [userDefaults setObject:[NSString stringWithFormat:@"%@",[userDic objectForKey:@"qu"]] forKey:@"qu"];
            
            NSString *qu = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"qu"]];
            if (qu==nil || [qu isEqualToString:@"(null)"])
            {
                qu = @"null";
            }
            NSLog(@"qu=%@",qu);
            [SmartHomeAPIs SetQu:qu];
            
            
            [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"登录成功" waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(switchNextViewController:) withObject:[userDefaults objectForKey:@"roleId"] waitUntilDone:YES];
            return ;
        }
        else//登录出错
        {
            [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"登录失败！" waitUntilDone:YES];
            return ;
        }
    });

}

- (IBAction)registerNewUser:(UIButton *)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:registerVC];
    [nav.navigationBar performSelector:@selector(setBarTintColor:) withObject:[UIColor colorWithRed:130/255.0 green:206/255.0 blue:59/255.0 alpha:1]];

    [registerVC.navigationItem setTitle:@"注册新用户"];
    [self.view.window.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (void) successWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showSuccess:message];
}

- (void) errorWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showError:message];
}

- (void)switchNextViewController:(NSString *)roleId
{
    RootController *rootController = (RootController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    int id = [roleId intValue];
    if (id == CommonUser) {
        [rootController switchToMainTabBarView];
    }else {
        [rootController switchToManagerView];
    }
}
@end
