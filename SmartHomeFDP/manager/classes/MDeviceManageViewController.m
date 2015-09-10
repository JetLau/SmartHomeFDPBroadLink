//
//  MDeviceManageViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 15/8/26.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import "MDeviceManageViewController.h"
#import "NavigationViewController.h"
#import "OEMSQueryTableViewCell.h"
#import "DiffEnqueryDeviceTableViewController.h"
#import "SmartHomeAPIs.h"
#import "ProgressHUD.h"
@interface MDeviceManageViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation MDeviceManageViewController

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
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    [self.navigationItem setTitle:@"设备查询"];
    
    // Here self.navigationController is an instance of NavigationViewController (which is a root controller for the main window)
    //
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(toggleMenu)];
    
    self.view.layer.shadowOffset = CGSizeZero;
    self.view.layer.shadowOpacity = 0.7f;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    self.view.layer.shadowPath = shadowPath.CGPath;
    
    [addressSegment addTarget:self action:@selector(addressSegmentChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [addressTableView registerNib:[UINib nibWithNibName:@"OEMSQueryTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    self.address = [userDefaults objectForKey:@"address"];
    //self.city = [[NSMutableArray alloc] init];
    if([[userDefaults objectForKey:@"roleId"]intValue]  == 8)
    {
        [addressSegment setTitle:[userDefaults objectForKey:@"addressName"] forSegmentAtIndex:0];
        //[self.addressDic setValue:[self.city objectAtIndex:indexPath.row] forKey:@"city"];
        [addressSegment setEnabled:NO forSegmentAtIndex:0];
        [addressSegment setEnabled:YES forSegmentAtIndex:1];
        
        [self getChildAddressList:[userDefaults objectForKey:@"address"] andRoleId:[userDefaults objectForKey:@"roleId"]];
        
    }else if ([[userDefaults objectForKey:@"roleId"] intValue] == 2){
        [addressSegment setTitle:[userDefaults objectForKey:@"addressName"] forSegmentAtIndex:1];
        //[self.addressDic setValue:[self.city objectAtIndex:indexPath.row] forKey:@"city"];
        [addressSegment setEnabled:NO forSegmentAtIndex:0];
        [addressSegment setEnabled:NO forSegmentAtIndex:1];
        [addressSegment setEnabled:YES forSegmentAtIndex:2];
        
        [self getChildAddressList:[userDefaults objectForKey:@"address"] andRoleId:[userDefaults objectForKey:@"roleId"]];
    }else if([[userDefaults objectForKey:@"roleId"] intValue] == 3){
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

-(void)viewWillAppear:(BOOL)animated {
    
    
}



- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    NavigationViewController *navigationController = (NavigationViewController *)self.navigationController;
    [navigationController.menu setNeedsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self getChildAddressList:self.address andRoleId:@"2"];
    } else {
        [addressSegment setTitle:[[self.street objectAtIndex:indexPath.row] objectForKey:@"address_name"] forSegmentAtIndex:2];
        //[self.addressDic setValue:[self.street objectAtIndex:indexPath.row] forKey:@"street"];
        self.address = [[self.street objectAtIndex:indexPath.row] objectForKey:@"address_id"];
        
    }
}

- (IBAction)queryBtnClicked:(UIButton *)sender {
    NSLog(@"address=%@,type = %d",self.address,[enquiryTypeSegment selectedSegmentIndex]);
    int type = [enquiryTypeSegment selectedSegmentIndex];
    
    DiffEnqueryDeviceTableViewController *enqueryVCtl = [[DiffEnqueryDeviceTableViewController alloc] initWithNibName:@"DiffEnqueryDeviceTableViewController" bundle:nil];
    
    if (type ==0) {
        dispatch_async(serverQueue, ^{
            NSDictionary *resultDic = [SmartHomeAPIs GetControllerList:self.address];
            if([[resultDic objectForKey:@"result"] isEqualToString:@"success"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[resultDic objectForKey:@"Controllers"] count] == 0) {
                        [ProgressHUD showError:@"该区域还没有中控设备！"];
                        return;
                    }
                    [enqueryVCtl.navigationItem  setTitle:@"已申请中控"];
                    enqueryVCtl.type = type;
                    enqueryVCtl.controllerList = [NSMutableArray arrayWithArray:[resultDic objectForKey:@"Controllers"]];
                    [self.navigationController pushViewController:enqueryVCtl animated:YES];
                });
                
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ProgressHUD showError:@"中控列表获取失败，请检查网络！"];
                    
                });
            }
        });
    }else if (type ==1) {
        [enqueryVCtl.navigationItem  setTitle:@"设备申请"];
    }else{
        [enqueryVCtl.navigationItem  setTitle:@"用户反馈"];
    }
    //[self.navigationController pushViewController:enqueryVCtl animated:YES];

}

-(void)getChildAddressList:(NSString *)address andRoleId:(NSString*) roleId{
    dispatch_async(serverQueue, ^{
        NSDictionary *resultDic = [SmartHomeAPIs GetChildAddressList:address];
        int role_id = [roleId intValue];
        if([[resultDic objectForKey:@"result"] isEqualToString:@"success"])
        {
            if (role_id == 8) {
                self.district = [resultDic objectForKey:@"addressList"];
            }else if (role_id == 2){
                self.street = [resultDic objectForKey:@"addressList"];
            }
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (role_id == 8) {
                    [ProgressHUD showError:@"区列表获取失败，请检查网络！"];
                }else if (role_id == 2){
                    [ProgressHUD showError:@"街道列表获取失败，请检查网络！"];
                }
            });
        }
    });
}
@end
