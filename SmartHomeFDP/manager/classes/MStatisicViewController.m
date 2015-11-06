//
//  MStatisicViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 15/8/27.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import "MStatisicViewController.h"
#import "NavigationViewController.h"
#import "OEMSQueryTableViewCell.h"
#import "MStatisticGraphViewController.h"
#import "OEMSEnergyGraphViewController.h"
#import "SmartHomeAPIs.h"
#import "ProgressHUD.h"
#import <YAScrollSegmentControl/YAScrollSegmentControl.h>

#define cityManager 2
#define districtManager 3
#define streetManager 4

@interface MStatisicViewController ()<UITableViewDataSource, UITableViewDelegate,YAScrollSegmentControlDelegate>

@property (weak, nonatomic) IBOutlet YAScrollSegmentControl *enquirySegment;
@end

@implementation MStatisicViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    [self.navigationItem setTitle:@"数据统计"];
    
    // Here self.navigationController is an instance of NavigationViewController (which is a root controller for the main window)
    //
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(toggleMenu)];
   
    
    self.enquirySegment.buttons = @[@"用户数量", @"设备数量", @"设备使用次数", @"设备用户数量", @"控制方式"];
    
    [addressSegment addTarget:self action:@selector(addressSegmentChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [addressTableView registerNib:[UINib nibWithNibName:@"OEMSQueryTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    self.address = [userDefaults objectForKey:@"address"];
    //self.city = [[NSMutableArray alloc] init];
    if([[userDefaults objectForKey:@"roleId"]intValue]  == cityManager)
    {
        [addressSegment setTitle:[userDefaults objectForKey:@"addressName"] forSegmentAtIndex:0];
        //[self.addressDic setValue:[self.city objectAtIndex:indexPath.row] forKey:@"city"];
        [addressSegment setEnabled:NO forSegmentAtIndex:0];
        [addressSegment setEnabled:YES forSegmentAtIndex:1];
        
        [self getChildAddressList:[userDefaults objectForKey:@"address"] andRoleId:[userDefaults objectForKey:@"roleId"]];
    
    }else if ([[userDefaults objectForKey:@"roleId"] intValue] == districtManager){
        [addressSegment setTitle:[userDefaults objectForKey:@"addressName"] forSegmentAtIndex:1];
        //[self.addressDic setValue:[self.city objectAtIndex:indexPath.row] forKey:@"city"];
        [addressSegment setEnabled:NO forSegmentAtIndex:0];
        [addressSegment setEnabled:NO forSegmentAtIndex:1];
        [addressSegment setEnabled:YES forSegmentAtIndex:2];
        
        [self getChildAddressList:[userDefaults objectForKey:@"address"] andRoleId:[userDefaults objectForKey:@"roleId"]];
    }else if([[userDefaults objectForKey:@"roleId"] intValue] == streetManager){
        [addressSegment setTitle:[userDefaults objectForKey:@"addressName"] forSegmentAtIndex:2];
        //[self.addressDic setValue:[self.city objectAtIndex:indexPath.row] forKey:@"city"];
        [addressSegment setEnabled:NO forSegmentAtIndex:0];
        [addressSegment setEnabled:NO forSegmentAtIndex:1];
        [addressSegment setEnabled:NO forSegmentAtIndex:2];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"当前管理员权限不提供服务！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    NavigationViewController *navigationController = (NavigationViewController *)self.navigationController;
    [navigationController.menu setNeedsLayout];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(void)addressSegmentChangedValue:(id)sender
{
    switch ([(UISegmentedControl *)sender selectedSegmentIndex]) {
        case 0:
            [addressTableView reloadData];
            [addressSegment setTitle:@"区" forSegmentAtIndex:1];
            //[self.addressDic setValue:@"" forKey:@"district"];
            [addressSegment setTitle:@"街道" forSegmentAtIndex:2];
            //[self.addressDic setValue:@"" forKey:@"street"];
            [addressSegment setEnabled:NO forSegmentAtIndex:2];
            break;
        case 1:
            if (self.district == nil) {
                [ProgressHUD showError:@"区列表获取失败，请检查网络！"];
            }else{
                [addressTableView reloadData];
                [addressSegment setTitle:@"街道" forSegmentAtIndex:2];
            }
            //[self.addressDic setValue:@"" forKey:@"street"];
            break;
        case 2:
            if (self.street == nil) {
                [ProgressHUD showError:@"街道列表获取失败，请检查网络！"];
            }else{
                [addressTableView reloadData];
            }
            break;
        default:
            break;
    }
    
    
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
    } else if ([addressSegment selectedSegmentIndex] == 1) {
        [addressSegment setTitle:[[self.district objectAtIndex:indexPath.row] objectForKey:@"address_name"] forSegmentAtIndex:1];
        //[self.addressDic setValue:[self.district objectAtIndex:indexPath.row] forKey:@"district"];
        [addressSegment setEnabled:YES forSegmentAtIndex:2];
        self.address = [[self.district objectAtIndex:indexPath.row] objectForKey:@"address_id"];
        [self getChildAddressList:self.address andRoleId:[NSString stringWithFormat:@"%d",districtManager]];
    } else {
        [addressSegment setTitle:[[self.street objectAtIndex:indexPath.row] objectForKey:@"address_name"] forSegmentAtIndex:2];
        //[self.addressDic setValue:[self.street objectAtIndex:indexPath.row] forKey:@"street"];
        self.address = [[self.street objectAtIndex:indexPath.row] objectForKey:@"address_id"];

    }
}

- (IBAction)queryBtnClicked:(UIButton *)sender {
//    NSLog(@"address=%@,type = %d",self.address,[enquiryTypeSegment selectedSegmentIndex]);
//    int type = [enquiryTypeSegment selectedSegmentIndex];
    
    MStatisticGraphViewController *graphVCtrl = [[MStatisticGraphViewController alloc] initWithNibName:@"MStatisticGraphViewController" bundle:nil];
    graphVCtrl.type =self.SearchType;
    [ProgressHUD show:@"正在查询"];
    self.view.userInteractionEnabled = false;
    if (self.SearchType ==0) {
        dispatch_async(serverQueue, ^{
            NSDictionary *resultDic = [SmartHomeAPIs GetRegionUserNumber:self.address];
            if([[resultDic objectForKey:@"result"] isEqualToString:@"success"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [graphVCtrl.navigationItem  setTitle:@"用户数量"];
                    graphVCtrl.userNumList = [NSMutableArray arrayWithArray:[resultDic objectForKey:@"user_num"]];
                    [ProgressHUD showSuccess:@""];
                    self.view.userInteractionEnabled = true;

                    [self.navigationController pushViewController:graphVCtrl animated:YES];
                });
                
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                        [ProgressHUD showError:@"用户数量获取失败，请检查网络！"];
                    self.view.userInteractionEnabled = true;

                });
            }
        });
        
    }else if (self.SearchType  ==1) {
//        OEMSEnergyGraphViewController *egVctrl = [[OEMSEnergyGraphViewController alloc] initWithNibName:@"OEMSEnergyGraphViewController" bundle:nil];
//        [egVctrl.navigationItem  setTitle:@"设备数量"];
//        [self.navigationController pushViewController:egVctrl animated:YES];
//        return;
        
        dispatch_async(serverQueue, ^{
            NSDictionary *resultDic = [SmartHomeAPIs GetRegionDeviceNumber:self.address];
            if([[resultDic objectForKey:@"result"] isEqualToString:@"success"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [graphVCtrl.navigationItem  setTitle:@"设备数量"];
                    graphVCtrl.deviceNumList = [NSMutableArray arrayWithArray:[resultDic objectForKey:@"device_num"]];
                    [ProgressHUD showSuccess:@""];
                    self.view.userInteractionEnabled = true;

                    [self.navigationController pushViewController:graphVCtrl animated:YES];
                });
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.view.userInteractionEnabled = true;

                    [ProgressHUD showError:@"设备数量获取失败，请检查网络！"];
                    
                });
            }
        });
    }else if (self.SearchType  ==2) {
        
        dispatch_async(serverQueue, ^{
            NSDictionary *resultDic = [SmartHomeAPIs GetRegionDeviceUseNumber:self.address];
            if([[resultDic objectForKey:@"result"] isEqualToString:@"success"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [graphVCtrl.navigationItem  setTitle:@"使用次数"];
                    [ProgressHUD showSuccess:@""];
                    self.view.userInteractionEnabled = true;
                    graphVCtrl.deviceUseNumList = [NSMutableArray arrayWithArray:[resultDic objectForKey:@"device_num"]];
                    [self.navigationController pushViewController:graphVCtrl animated:YES];
             


                });
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ProgressHUD showError:@"使用次数获取失败，请检查网络！"];
                    self.view.userInteractionEnabled = true;

                });
            }
        });
    }else if (self.SearchType  ==3) {
        
        dispatch_async(serverQueue, ^{
            NSDictionary *resultDic = [SmartHomeAPIs GetUserNumberListByDevice:self.address];
            if([[resultDic objectForKey:@"result"] isEqualToString:@"success"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [graphVCtrl.navigationItem  setTitle:@"设备用户数量"];
                    [ProgressHUD showSuccess:@""];
                    self.view.userInteractionEnabled = true;
                    graphVCtrl.userNumByDevice = [NSMutableArray arrayWithArray:[resultDic objectForKey:@"user_num"]];
                    [self.navigationController pushViewController:graphVCtrl animated:YES];
                    
                    
                    
                });
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ProgressHUD showError:@"设备用户数量获取失败，请检查网络！"];
                    self.view.userInteractionEnabled = true;
                    
                });
            }
        });
    }else if (self.SearchType  ==4) {
        
        dispatch_async(serverQueue, ^{
            NSDictionary *resultDic = [SmartHomeAPIs GetOperateNumberListByMethod:self.address];
            if([[resultDic objectForKey:@"result"] isEqualToString:@"success"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [graphVCtrl.navigationItem  setTitle:@"控制方式统计"];
                    [ProgressHUD showSuccess:@""];
                    self.view.userInteractionEnabled = true;
                    graphVCtrl.operateNumByMethod = [NSMutableArray arrayWithArray:[resultDic objectForKey:@"operator_num"]];
                    [self.navigationController pushViewController:graphVCtrl animated:YES];
                    
                    
                    
                });
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ProgressHUD showError:@"控制方式数据获取失败，请检查网络！"];
                    self.view.userInteractionEnabled = true;
                    
                });
            }
        });
    }


}

-(void)getChildAddressList:(NSString *)address andRoleId:(NSString*) roleId{
    dispatch_async(serverQueue, ^{
        NSDictionary *resultDic = [SmartHomeAPIs GetChildAddressList:address];
        int role_id = [roleId intValue];
        if([[resultDic objectForKey:@"result"] isEqualToString:@"success"])
        {
            if (role_id == cityManager) {
                self.district = [resultDic objectForKey:@"addressList"];
            }else if (role_id == districtManager){
                self.street = [resultDic objectForKey:@"addressList"];
            }
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (role_id == cityManager) {
                    [ProgressHUD showError:@"区列表获取失败，请检查网络！"];
                }else if (role_id == districtManager){
                    [ProgressHUD showError:@"街道列表获取失败，请检查网络！"];
                }
            });
        }
    });
}

- (void)didSelectItemAtIndex:(NSInteger)index
{
    self.SearchType = index;
    //NSLog(@"Button selected at index: %lu", (long)index);
}

@end
