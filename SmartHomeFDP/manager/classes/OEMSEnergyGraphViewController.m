//
//  OEMSEnergyGraphViewController.m
//  OfficeEMS_iPhone
//
//  Created by cisl on 14-6-19.
//  Copyright (c) 2014年 WangShengYin. All rights reserved.
//

#import "OEMSEnergyGraphViewController.h"
#import "OEMSQueryTableViewCell.h"
#import "FXLabel.h"

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define PI 3.1415926

@interface OEMSEnergyGraphViewController () <UITableViewDataSource, UITableViewDelegate>


@end

@implementation OEMSEnergyGraphViewController 

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
        ((OEMSPieGraph *)self.pieGraphs[0]).startAngle = - PI / 2;
        ((OEMSPieGraph *)self.pieGraphs[1]).startAngle = - PI / 2;
        ((OEMSPieGraph *)self.pieGraphs[2]).startAngle = - PI / 2;
        ((OEMSPieGraph *)self.pieGraphs[0]).percentage = [NSNumber numberWithFloat:0.13];
        ((OEMSPieGraph *)self.pieGraphs[0]).imageName = @"greenBall.png";
        [((OEMSPieGraph *)self.pieGraphs[0]) showData];
        ((OEMSPieGraph *)self.pieGraphs[1]).percentage = [NSNumber numberWithFloat:0.51];
        ((OEMSPieGraph *)self.pieGraphs[1]).imageName = @"blueBall.png";
        [((OEMSPieGraph *)self.pieGraphs[1]) showData];
        ((OEMSPieGraph *)self.pieGraphs[2]).percentage = [NSNumber numberWithFloat:0.76];
        ((OEMSPieGraph *)self.pieGraphs[2]).imageName = @"orangeBall.png";
        [((OEMSPieGraph *)self.pieGraphs[2]) showData];
        
        for(int i = 0; i < 3; i++) {
            ((FXLabel *)self.percentages[i]).shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
            ((FXLabel *)self.percentages[i]).shadowOffset = CGSizeMake(1.0f, 2.0f);
            ((FXLabel *)self.percentages[i]).shadowBlur = 0;
            ((FXLabel *)self.percentages[i]).innerShadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
            ((FXLabel *)self.percentages[i]).innerShadowOffset = CGSizeMake(1.0f, 2.0f);
        }
        
        ((UILabel *)self.percentages[0]).text = [NSString stringWithFormat:@"%d%%",(int)(0.13 * 100)];
        ((UILabel *)self.percentages[1]).text = [NSString stringWithFormat:@"%d%%",(int)(0.51 * 100)];
        ((UILabel *)self.percentages[2]).text = [NSString stringWithFormat:@"%d%%",(int)(0.76 * 100)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OEMSQueryTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.dates count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OEMSQueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.name.text = [NSString stringWithFormat:@"数据%@",[self.dates objectAtIndex:[indexPath row]]];
    
    return cell;
}




-(void)viewDidAppear:(BOOL)animated

{
    self.tableView.hidden = false;

    //self.tableView.frame=CGRectMake(0, 65, 320, [UIScreen mainScreen].bounds.size.height - 65);
  
}


- (IBAction)focusOnDeviceType:(UIButton *)sender {
    int tag = sender.tag;
    self.dates = [[NSMutableArray alloc] initWithObjects:@(tag),@(tag),@(tag),@(tag),@(tag),@(tag),@(tag),@(tag),@(tag),@(tag), nil];
    [self.tableView reloadData];
}





@end
