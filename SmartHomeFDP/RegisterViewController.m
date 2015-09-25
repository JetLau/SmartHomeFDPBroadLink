//
//  RegisterViewController.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-29.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserInfo.h"
#import "ProgressHUD.h"
#import "RootController.h"
#import "OEMSQueryTableViewCell.h"
#import "SmartHomeAPIs.h"
#import "MJExtension.h"

@interface RegisterViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    self.user= [[UserInfo alloc] init];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(returnToLogin)];
    //修改title颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [addressSegment addTarget:self action:@selector(addressSegmentChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [addressTableView registerNib:[UINib nibWithNibName:@"OEMSQueryTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    //self.addressDic=[[NSDictionary alloc]initWithObjectsAndKeys: @"",@"city",@"",@"district",@"",@"street",nil];
    [self getChildAddressList:@"1" andRank:@"city"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)returnToLogin{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerBtnClicked:(UIButton *)sender {
    [self.user setUsername:[NSString stringWithString:username.text]];
    [self.user setPassword:[NSString stringWithString:password.text]];
    [self.user setPhone:[NSString stringWithString:phone.text]];
    if ([genderSegment selectedSegmentIndex] == 0) {
        self.user.gender = @"男";
    }else if([genderSegment selectedSegmentIndex] == 1) {
        self.user.gender = @"女";
    }
    if (self.quNumber == nil) {
        self.quNumber = @"null";
    }
    BOOL isInfoRight = [self.user verifyInfo:[NSString stringWithString:verifyPassword.text]];
    if (isInfoRight== TRUE) {
        [ProgressHUD show:@"正在注册"];
        self.view.userInteractionEnabled = false;
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:self.user.username,@"username",self.user.password,@"password",self.user.address,@"address",self.user.gender,@"gender",@"4",@"roleId",self.user.phone,@"phone",nil];
                dispatch_async(serverQueue, ^{
                    NSDictionary *resultDic = [SmartHomeAPIs MobileRegister:dic andQuNum:self.quNumber];
                    if ([[resultDic objectForKey:@"result"] isEqualToString:@"success"]) {
        
                        [self.user setRoleId:[[resultDic objectForKey:@"roleId"] integerValue]];
                        [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"注册成功" waitUntilDone:YES];
                        //[self performSelectorOnMainThread:@selector(switchNextViewController) withObject:nil waitUntilDone:YES];
        
                    }else//登录出错
                    {
                        [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"注册失败！" waitUntilDone:YES];
                        return ;
                    }
                });
        //[self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"注册成功" waitUntilDone:YES];
    }
}

- (IBAction)moveView:(UITextField *)sender {
    CGRect frame = self.inputView.frame;
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
                             self.inputView.frame = frame;}
                         completion:^(BOOL finished) {}];
    }
    
}

//点击空白区域，键盘收起
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGRect frame = self.inputView.frame;
    frame.origin.y = 50;
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.inputView.frame = frame;}
                     completion:^(BOOL finished) {}];
    [self.view endEditing:YES];
}

- (void) successWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showSuccess:message];
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    [userDefaults setObject:@"test" forKey:@"username"];
    //    [userDefaults setObject:@"test" forKey:@"password"];
    //    [userDefaults setObject:@"test" forKey:@"phone"];
    //    [userDefaults setObject:@"man" forKey:@"gender"];
    //    [userDefaults setObject:[NSNumber numberWithInt:0] forKey:@"address"];
    //    [userDefaults setObject:[NSNumber numberWithInt:1] forKey:@"roleId"];
    
    [self returnToLogin];
}
- (void) errorWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showError:message];
}

-(void)addressSegmentChangedValue:(id)sender
{
    switch ([(UISegmentedControl *)sender selectedSegmentIndex]) {
        case 0:
            if (self.city == nil) {
                [ProgressHUD showError:@"市列表获取失败!"];
            }else{
                [addressTableView reloadData];
                addressTableView.hidden = false;
                [addressSegment setTitle:@"区" forSegmentAtIndex:1];
                //[self.addressDic setValue:@"" forKey:@"district"];
                [addressSegment setTitle:@"街道" forSegmentAtIndex:2];
                //[self.addressDic setValue:@"" forKey:@"street"];
                [addressSegment setEnabled:NO forSegmentAtIndex:2];
                self.user.address = nil;
            }
            
            break;
        case 1:
            
            if (self.district == nil) {
                [ProgressHUD showError:@"区列表获取失败!"];
            }else{
                [addressTableView reloadData];
                addressTableView.hidden = false;
                [addressSegment setTitle:@"街道" forSegmentAtIndex:2];
                //[self.addressDic setValue:@"" forKey:@"street"];
                self.user.address = nil;
            }
            
            
            break;
        case 2:
            
            
            if (self.street == nil) {
                [ProgressHUD showError:@"街道列表获取失败!"];
            }else{
                [addressTableView reloadData];
                addressTableView.hidden = false;
                self.user.address = nil;
            }
        default:
            break;
    }
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (OEMSQueryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OEMSQueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if([addressSegment selectedSegmentIndex] == 0) {
        cell.name.text = [[self.city objectAtIndex:[indexPath row]] objectForKey:@"address_name"];
    } else if([addressSegment selectedSegmentIndex] == 1) {
        cell.name.text = [[self.district objectAtIndex:[indexPath row]] objectForKey:@"address_name"];
    } else {
        cell.name.text = [[self.street objectAtIndex:[indexPath row]] objectForKey:@"address_name"];
        
        
    }
    
    
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([addressSegment selectedSegmentIndex] == 0) {
        return [self.city count];
    } else if ([addressSegment selectedSegmentIndex] == 1) {
        return [self.district count];
    } else {
        return [self.street count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([addressSegment selectedSegmentIndex] == 0) {
        [addressSegment setTitle:[[self.city objectAtIndex:indexPath.row] objectForKey:@"address_name"] forSegmentAtIndex:0];
        //[self.addressDic setValue:[self.city objectAtIndex:indexPath.row] forKey:@"city"];
        [addressSegment setEnabled:YES forSegmentAtIndex:1];
        [self getChildAddressList:[[self.city objectAtIndex:indexPath.row] objectForKey:@"address_id"] andRank:@"district"];
        self.address = [[self.city objectAtIndex:indexPath.row] objectForKey:@"address_id"];
        
    } else if ([addressSegment selectedSegmentIndex] == 1) {
        [addressSegment setTitle:[[self.district objectAtIndex:indexPath.row] objectForKey:@"address_name"] forSegmentAtIndex:1];
        //[self.addressDic setValue:[self.district objectAtIndex:indexPath.row] forKey:@"district"];
        [addressSegment setEnabled:YES forSegmentAtIndex:2];
        
        [self getChildAddressList:[[self.district objectAtIndex:indexPath.row] objectForKey:@"address_id"] andRank:@"street"];
        self.address = [[self.district objectAtIndex:indexPath.row] objectForKey:@"address_id"];
        self.quNumber = self.address;
        
    } else {
        [addressSegment setTitle:[[self.street objectAtIndex:indexPath.row] objectForKey:@"address_name"] forSegmentAtIndex:2];
        //[self.addressDic setValue:[self.street objectAtIndex:indexPath.row] forKey:@"street"];
        self.user.address = [[self.street objectAtIndex:indexPath.row] objectForKey:@"address_id"];
        
    }
    
    [addressTableView setHidden:YES];
}

-(void)getChildAddressList:(NSString *)address andRank:(NSString *)rank{
    dispatch_async(serverQueue, ^{
        NSDictionary *resultDic = [SmartHomeAPIs GetChildAddressList:address];
        if([[resultDic objectForKey:@"result"] isEqualToString:@"success"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([rank isEqualToString:@"city"]) {
                    if ([[resultDic objectForKey:@"addressList"] count] == 0) {
                        [ProgressHUD showError:@"市列表没有数据，该区域暂不支持！"];
                        self.city = nil;
                    }else{
                        self.city = [resultDic objectForKey:@"addressList"];
                    }
                }else if ([rank isEqualToString:@"district"]){
                    if ([[resultDic objectForKey:@"addressList"] count] == 0) {
                        [ProgressHUD showError:@"区列表没有数据，该区域暂不支持！"];
                        self.district = nil;
                    }else{
                        self.district = [resultDic objectForKey:@"addressList"];
                    }
                }else if ([rank isEqualToString:@"street"]){
                    
                    if ([[resultDic objectForKey:@"addressList"] count] == 0) {
                        [ProgressHUD showError:@"街道列表没有数据，该区域暂不支持！"];
                        self.street = nil;
                    }else{
                        self.street = [resultDic objectForKey:@"addressList"];
                    }
                }
            });
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([rank isEqualToString:@"city"]) {
                    [ProgressHUD showError:@"市列表获取失败，请检查网络！"];
                }else if ([rank isEqualToString:@"district"]){
                    [ProgressHUD showError:@"区列表获取失败，请检查网络！"];
                }else if ([rank isEqualToString:@"street"]){
                    [ProgressHUD showError:@"街道列表获取失败，请检查网络！"];
                }
            });
        }
    });
}
@end
