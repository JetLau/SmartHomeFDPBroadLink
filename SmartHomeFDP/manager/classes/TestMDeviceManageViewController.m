//
//  MDeviceManageViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 15/8/26.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import "TestMDeviceManageViewController.h"
#import "NavigationViewController.h"
#import "OEMSQueryTableViewCell.h"
@interface TestMDeviceManageViewController ()<UITableViewDataSource, UITableViewDelegate>
@property int selectorSignal; //1:start 2:end 0:nothing

@end

@implementation TestMDeviceManageViewController

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
    
    [self.segmentControl addTarget:self action:@selector(segmentChangedValue:) forControlEvents:UIControlEventValueChanged];
    self.segmentIndex=0;
    

    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"OEMSQueryTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.city = [[NSArray alloc] initWithObjects:@"北京",@"上海",@"南京", nil];
    self.district = [[NSArray alloc] initWithObjects:@"朝阳",@"通州",@"五道口", nil];
    self.street = [[NSArray alloc] initWithObjects:@"张衡",@"蔡伦",@"张江高科", nil];

    NSDate *today = [[NSDate alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.startDate.text = [dateFormatter stringFromDate:today];
    self.endDate.text = [dateFormatter stringFromDate:today];
    self.dateSelector.maximumDate = today;

    self.selectorSignal = 0;


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

- (OEMSQueryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OEMSQueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(self.segmentIndex == 0) {
        cell.name.text = [self.city objectAtIndex:[indexPath row]];
    } else if(self.segmentIndex == 1) {
        cell.name.text = [self.district objectAtIndex:[indexPath row]];
    } else {
        cell.name.text = [self.street objectAtIndex:[indexPath row]];
        
        
    }
    
    BOOL isPicked = [(NSNumber *)[self.cellsInfo objectAtIndex:[indexPath row]] boolValue];
    if(isPicked) {
        cell.tick.image = [UIImage imageNamed:@"greenTick.png"];
    } else {
        cell.tick.image = [UIImage imageNamed:@"greyTick.png"];
    }
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.segmentIndex == 0) {
        return [self.city count];
    } else if (self.segmentIndex == 1) {
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
    int n = [self.cellsInfo count];
    [self.cellsInfo removeAllObjects];
    for(int i = 0; i < n; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        OEMSQueryTableViewCell *cell = (OEMSQueryTableViewCell *)[self.tableView cellForRowAtIndexPath:index];
        if(i == [indexPath row]) {
            cell.tick.image = [UIImage imageNamed:@"greenTick.png"];
            [self.cellsInfo addObject:[NSNumber numberWithBool:YES]];
            
            [self.segmentControl setTitle:cell.name.text forSegmentAtIndex:self.segmentIndex];
        } else {
            cell.tick.image = [UIImage imageNamed:@"greyTick.png"];
            [self.cellsInfo addObject:[NSNumber numberWithBool:NO]];
        }
    }
    
}


- (IBAction)chooseStartDate:(UIButton *)sender {
    
    self.dateSelector.minimumDate = nil;
    CGRect frame = self.dateSelectorBlock.frame;
    frame.origin.y = 100;
    self.dateSelectorBlock.frame = frame;
    self.dateSelectorBlock.hidden = false;
    self.selectorSignal = 1;
}
- (IBAction)queryBtnClicked:(id)sender {
}

- (IBAction)chooseEndDate:(id)sender {
    CGRect frame = self.dateSelectorBlock.frame;
    frame.origin.y = 100;
    self.dateSelectorBlock.frame = frame;
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date =[dateFormat dateFromString:[NSString stringWithFormat:@"%@ 00:00:01",self.startDate.text]];
    self.dateSelector.minimumDate = date;
    self.dateSelectorBlock.hidden = false;
    self.selectorSignal = 2;
}

- (IBAction)dateSelected:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    if(self.selectorSignal == 1) {
        self.startDate.text = [dateFormatter stringFromDate:self.dateSelector.date];
    } else {
        self.endDate.text = [dateFormatter stringFromDate:self.dateSelector.date];
    }
    self.selectorSignal = 0;
    self.dateSelectorBlock.hidden = true;
}

-(void)segmentChangedValue:(id)sender
{
    switch ([(UISegmentedControl *)sender selectedSegmentIndex]) {
        case 0:
            //city
            self.segmentIndex=0;
            self.cellsInfo = [[NSMutableArray alloc]init];
            for(int i = 0; i < [self.city count]; i++) {
                [self.cellsInfo addObject:[NSNumber numberWithBool:NO]];
            }
            [self.tableView reloadData];

            break;
        case 1:
            //district
            self.segmentIndex=1;
            self.cellsInfo = [[NSMutableArray alloc]init];
            for(int i = 0; i < [self.district count]; i++) {
                [self.cellsInfo addObject:[NSNumber numberWithBool:NO]];
            }
            [self.tableView reloadData];

            break;
        case 2:
            //street
            self.segmentIndex=2;
            self.cellsInfo = [[NSMutableArray alloc]init];
            for(int i = 0; i < [self.street count]; i++) {
                [self.cellsInfo addObject:[NSNumber numberWithBool:NO]];
            }
            [self.tableView reloadData];

            break;
        default:
            break;
    }
}

@end
