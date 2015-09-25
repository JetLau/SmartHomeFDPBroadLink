//
//  VoiceTableViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 15/9/22.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import "VoiceTableViewController.h"
#import "LJCommonGroup.h"
#import "LJCommonLabelItem.h"
@interface VoiceTableViewController ()
@property (nonatomic,strong) NSMutableArray *groups;

@end

@implementation VoiceTableViewController
#pragma mark -懒加载
-(NSMutableArray *) groups
{
    if (_groups == nil) {
        _groups = [[NSMutableArray alloc] init];
    }
    
    return _groups;
}

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
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }

     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(returnToLogin)];
    [self setupGroups];

}

-(void)returnToLogin{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupGroups
{
    [self setGroup0];
}

-(void)setGroup0
{
    //1.创建组
    LJCommonGroup *group = [LJCommonGroup group];
    [self.groups addObject:group];
    

    for (NSString *voice in self.voiceList) {
            LJCommonLabelItem *item1 = [LJCommonLabelItem itemWithTitle:voice];
            [group.items addObject:item1];
            
    }
}


@end
