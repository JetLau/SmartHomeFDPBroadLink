//
//  SelectCommandTableViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 15/10/29.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import "SelectCommandTableViewController.h"
#import "ProgressHUD.h"
#import "LJCommonGroup.h"
#import "LJCommonItem.h"
#import "RMDeviceManager.h"
#import "RMButton.h"
@interface SelectCommandTableViewController ()

@property (nonatomic,strong) NSMutableArray *groups;
@property (nonatomic,strong) NSMutableArray *remoteArray;
@property(strong,nonatomic)RMDeviceManager *rmDeviceManager;
@property(strong,nonatomic)RMButton *selectedBtn;

@property int remoteNum;
@property int btnNum;
@end

@implementation SelectCommandTableViewController
#pragma mark -懒加载
-(NSMutableArray *) groups
{
    if (_groups == nil) {
        _groups = [[NSMutableArray alloc] init];
    }
    
    return _groups;
}
//屏蔽tableview的样式设置
-(id)init
{
    NSLog(@"1.init SelectCommand table view!");
    return [super init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    [self.navigationItem setTitle:@"添加一条执行命令"];

}

-(void)viewWillAppear:(BOOL)animated
{
    //初始化模型
    self.groups=nil;
    [self setupGroups];
    [self.tableView reloadData];
}


-(void) setupGroups
{
    self.rmDeviceManager = [RMDeviceManager createRMDeviceManager];
    int rmCount = [self.rmDeviceManager getRMDeviceCount];
    for (int i = 0; i < rmCount; i++) {
        //1.创建组
        LJCommonGroup *group = [LJCommonGroup group];
        [self.groups addObject:group];
        
        RMDevice *rmDevice=[self.rmDeviceManager getRMDevice:i];

        //2.设置组的基本数据
        group.groupheader = rmDevice.name;
        
        int btnConut = [rmDevice.RMButtonArray count];
        
        for (int j = 0; j < btnConut; j++) {
            RMButton *rmButton = [rmDevice.RMButtonArray objectAtIndex:j];
            LJCommonItem *item=[LJCommonItem itemWithTitle:rmButton.btnName];
            [group.items addObject:item];

        }
        
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.remoteNum = indexPath.section;
    self.btnNum = indexPath.row;
    
    self.selectedBtn = [[self.rmDeviceManager getRMDevice:indexPath.section].RMButtonArray objectAtIndex:indexPath.row];
    self.selectedBtn.btnMac = [self.rmDeviceManager getRMDevice:indexPath.section].mac;

    if ([self.selectedBtn.sendData isEqualToString:@""]) {
        [ProgressHUD showError:@"此按钮未学习"];
    }else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入所选按键执行命令名称，比如\"电视打开\"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alertView show];
    }
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"buttonIndex = %d,%@", buttonIndex,[[alertView textFieldAtIndex:0] text]);
    if(buttonIndex==1)
    {
        self.selectedBtn.btnName = [[alertView textFieldAtIndex:0] text];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddBtnNotification" object:self userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:self.selectedBtn,@"result",nil]];
        [self.navigationController popViewControllerAnimated:YES];

    }
}


@end
