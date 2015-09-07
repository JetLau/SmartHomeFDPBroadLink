//
//  DiffEnqueryDeviceTableViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 15/8/28.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import "DiffEnqueryDeviceTableViewController.h"

@interface DiffEnqueryDeviceTableViewController ()

@end

@implementation DiffEnqueryDeviceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == 0) {
        return [self.controllerList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
//    NSString * latitudeAndLongitude = [NSString stringWithFormat:@"经度:%@,纬度:%@",[[_gpsArray objectAtIndex:indexPath.row] objectForKey:@"longitude"],[[_gpsArray objectAtIndex:indexPath.row] objectForKey:@"latitude"]];
//    NSString * time = [NSString stringWithFormat:@"时间:%@",[[_gpsArray objectAtIndex:indexPath.row] objectForKey:@"time"]];
    
    NSString * username = [NSString stringWithFormat:@"用户名：%@",[[self.controllerList objectAtIndex:indexPath.row] objectForKey:@"userName"]];
    NSString * controller = [NSString stringWithFormat:@"中控器mac：%@",[[self.controllerList objectAtIndex:indexPath.row] objectForKey:@"mac"]];
    [cell.textLabel setText:username];
    [cell.detailTextLabel setText:controller];
    
    return cell;
    
}
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
