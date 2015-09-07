//
//  MSettingViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 15/8/26.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import "MSettingViewController.h"
#import "NavigationViewController.h"
#import "UserDetailViewController.h"
#import "LJCommonGroup.h"
#import "LJCommonItem.h"
#import "RootController.h"
#import "ProgressHUD.h"
#import "UserInfo.h"

@interface MSettingViewController ()

@end

@implementation MSettingViewController

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
    //self.view.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    [self.navigationItem setTitle:@"个人设置"];
    
    // Here self.navigationController is an instance of NavigationViewController (which is a root controller for the main window)
    //
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(toggleMenu)];
    
    [self setupGroups];
}

-(void)setupGroups
{
    [self setGroup0];
}

-(void)setGroup0
{
    LJCommonGroup *LJGroup=[[LJCommonGroup alloc]init];
    [self.groups addObject:LJGroup];
    
    LJCommonItem *detailItem=[LJCommonItem itemWithTitle:@"账号详情"];
    [LJGroup.items addObject:detailItem];
    
    LJCommonItem *outItem=[LJCommonItem itemWithTitle:@"退出登录"];
    [LJGroup.items addObject:outItem];
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

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.section==0)
    {
        if (indexPath.item==0) {
            [self switchToDetailView];
        }else if (indexPath.item==1) {
            [self logOutSystem];
            
        }
    }
    
}
-(void)switchToDetailView{
    //[ProgressHUD show:@"正在获取用户详情"];
    self.view.userInteractionEnabled = false;
    [self switchToDetailViewController:[[UserInfo alloc] init]];
//    dispatch_async(serverQueue, ^{
//        NSDictionary *resultDic = [ShareBarrierFreeAPIS GetUserDetail];
//        
//        if ([[resultDic objectForKey:@"result"] isEqualToString:@"success"]) {
//            User *user = [User initUser:[resultDic objectForKey:@"data"]];
//            [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"获取成功" waitUntilDone:YES];
//            [self performSelectorOnMainThread:@selector(switchToDetailViewController:) withObject:user waitUntilDone:YES];
//            return ;
//        }
//        else {
//            [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"获取失败！" waitUntilDone:YES];
//            return ;
//        }
//    });
    
}

-(void)logOutSystem
{
    //删除userdefaults中的用户信息
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"username"];
    [userDefaults removeObjectForKey:@"password"];
    [userDefaults removeObjectForKey:@"gender"];
    [userDefaults removeObjectForKey:@"phone"];
    [userDefaults removeObjectForKey:@"address"];
    [userDefaults removeObjectForKey:@"roleId"];
    [userDefaults removeObjectForKey:@"addressName"];


    RootController *rootController=(RootController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rootController switchToLoginView];
}

- (void) successWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showSuccess:message];
}

- (void) errorWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showError:message];
}

- (void)switchToDetailViewController:(UserInfo*)user
{
    [self.view setUserInteractionEnabled:true];

    UserDetailViewController *userDetailViewController = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
    userDetailViewController.user = user;
    [self.navigationController pushViewController:userDetailViewController animated:YES];
}


@end
