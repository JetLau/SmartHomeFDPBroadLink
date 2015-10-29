//
//  AddSceneViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 15/10/29.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import "AddSceneViewController.h"
#import "SelectCommandTableViewController.h"
#import "RMButton.h"
#import "MJExtension.h"
#import "ScenePlistManager.h"
#import "BtnTableViewCell.h"
@interface AddSceneViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong)ScenePlistManager * sceneManager;
@end

@implementation AddSceneViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //隐藏tabbar工具条
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"场景编辑"];
    [self.navigationController.navigationBar setTranslucent:NO];

    UIBarButtonItem *saveSceneBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveScene)];
                                   
    [self.navigationItem setRightBarButtonItem:saveSceneBtn];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBtnNotification:) name:@"AddBtnNotification" object:nil];


    
    self.sceneManager = [ScenePlistManager createScenePlistManager];
    
    [self.btnTableView registerNib:[UINib nibWithNibName:@"BtnTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

-(void) viewWillAppear:(BOOL)animated
{
    
    if ([_style isEqualToString:@"add"]) {
        self.sceneNameTextField.text = @"新建场景";

    } else {
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) saveScene{
    [self.sceneManager addNewSceneIntoFile:[self.sceneNameTextField text] andBtnArray:self.sceneBtnArray andVoice:[self.voiceTextField text]];
    NSLog(@"saved scene %@",[self.sceneNameTextField text]);
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)addCtrlCommand:(UIButton *)sender {
    SelectCommandTableViewController *selectVC = [[SelectCommandTableViewController alloc] initWithNibName:@"SelectCommandTableViewController" bundle:nil];
    [self.navigationController pushViewController:selectVC animated:YES];
}

-(void) addBtnNotification:(NSNotification*)notification{
    
    NSDictionary *dic = [notification userInfo];
    RMButton *rmBtn = [dic objectForKey:@"result"];
    if (self.sceneBtnArray == nil) {
        self.sceneBtnArray=[[NSMutableArray alloc]init];
    }

    
    [self.sceneBtnArray addObject:rmBtn];

    [self.btnTableView reloadData];
    //NSLog(@"%@",rmBtn.keyValues);
}

-(void) editScene:(NSNotification*)notification{

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (BtnTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.btnName.text = [[self.sceneBtnArray objectAtIndex:indexPath.row] btnName];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sceneBtnArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
@end
