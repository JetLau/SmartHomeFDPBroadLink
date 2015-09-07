//
//  UserDetailViewController.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-30.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "UserDetailViewController.h"
#import "ProgressHUD.h"
@interface UserDetailViewController ()

@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    [self.navigationItem setTitle:@"账号详情"];
    
    // Here self.navigationController is an instance of NavigationViewController (which is a root controller for the main window)
    //
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(changeInfo)];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [username setText:[userDefaults objectForKey:@"username"]];
    [phone setText:[userDefaults objectForKey:@"phone"]];
    if ([[userDefaults objectForKey:@"gender"] isEqualToString:@"男"]) {
        genderSegment.selectedSegmentIndex = 0;
    }else{
        genderSegment.selectedSegmentIndex = 1;
    }
    
//    [password setText:self.user.password];
//    [phone setText:self.user.phone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [password setText:[userDefaults objectForKey:@"password"]];
    [username setUserInteractionEnabled:TRUE];
    [password setUserInteractionEnabled:TRUE];
    [phone setUserInteractionEnabled:TRUE];
    [genderSegment setUserInteractionEnabled:TRUE];
    
    [username setBackgroundColor:[UIColor whiteColor]];
    [password setBackgroundColor:[UIColor whiteColor]];
    [phone setBackgroundColor:[UIColor whiteColor]];
    [genderSegment setBackgroundColor:[UIColor whiteColor]];
    [changeBtn setHidden:FALSE];
}

- (IBAction)changeBtnClicked:(UIButton *)sender {
//    UserInfo *changedUser = [[UserInfo alloc] init];
//    [changedUser setUsername:[NSString stringWithString:username.text]];
//    [changedUser setPassword:[NSString stringWithString:password.text]];
//    [changedUser setPhone:[NSString stringWithString:phone.text]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:username.text forKey:@"username"];
    [userDefaults setObject:password.text forKey:@"password"];
    [userDefaults setObject:phone.text forKey:@"phone"];

    if (genderSegment.selectedSegmentIndex == 0) {
        [userDefaults setObject:@"男" forKey:@"gender"];

    }else{
        [userDefaults setObject:@"女" forKey:@"gender"];
    }
    BOOL isInfoRight = TRUE;//[changedUser verifyInfo:[NSString stringWithString:[GVUserDefaults standardUserDefaults].password]];
    if (isInfoRight== TRUE) {
        [ProgressHUD show:@"正在修改"];
        self.view.userInteractionEnabled = false;
        
        dispatch_async(serverQueue, ^{
           // NSDictionary *resultDic = [ShareBarrierFreeAPIS ChangeUserDetail:changedUser];
            //if ([[resultDic objectForKey:@"result"] isEqualToString:@"success"]) {
            if(TRUE){
                //self.user = changedUser;
                //[self.user saveUserInfo:[[resultDic objectForKey:@"user_id"] integerValue]];
                [self performSelectorOnMainThread:@selector(changeSuccessd:) withObject:@"修改成功" waitUntilDone:YES];
                // [self performSelectorOnMainThread:@selector(switchNextViewController) withObject:nil waitUntilDone:YES];
                
            }else
            {
                [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"修改失败！" waitUntilDone:YES];
                return ;
            }
        });
    }
    
    
    
}

- (IBAction)moveInfoView:(UITextField *)sender {
    
    CGRect frame = self.infoView.frame;
    //NSLog(@"inputView = %f",self.inputView.frame.origin.y);
    if (sender.tag>0) {
        frame.origin.y = -25*sender.tag;
        //NSLog(@"frame = %f",frame.origin.y);
        
        [UIView animateWithDuration:0.5f
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:0.1f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.infoView.frame = frame;}
                         completion:^(BOOL finished) {}];
    }

}

//点击空白区域，键盘收起
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGRect frame = self.infoView.frame;
    frame.origin.y = 50;
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.infoView.frame = frame;}
                     completion:^(BOOL finished) {}];
    [self.view endEditing:YES];
}
- (void) changeSuccessd:(NSString *)message {
    //[self.user saveUserInfo:[GVUserDefaults standardUserDefaults].userId];
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showSuccess:message];

    [changeBtn setHidden:TRUE];
    [username setUserInteractionEnabled:FALSE];
    [password setUserInteractionEnabled:FALSE];
    [phone setUserInteractionEnabled:FALSE];
    [genderSegment setUserInteractionEnabled:FALSE];
    
    [username setBackgroundColor:[UIColor colorWithWhite:0.90 alpha:1.000]];
    [password setBackgroundColor:[UIColor colorWithWhite:0.90 alpha:1.000]];
    [phone setBackgroundColor:[UIColor colorWithWhite:0.90 alpha:1.000]];
    [genderSegment setBackgroundColor:[UIColor colorWithWhite:0.90 alpha:1.000]];
    [password setText:@""];
}
- (void) errorWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showError:message];
}
@end
