//
//  MStatisticGraphViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 15/8/28.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import "MStatisticGraphViewController.h"
#import "OEMSQueryTableViewCell.h"
#import "DiffEnqueryDeviceTableViewController.h"
#import "ProgressHUD.h"
@interface MStatisticGraphViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation MStatisticGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.type =4;
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    if(self.type == 0){
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSDictionary * dic in self.userNumList) {
            for(NSString *key in dic.allKeys){
                if ([[dic objectForKey:key] intValue] != 0) {
                    [array addObject:[PNPieChartDataItem dataItemWithValue:[[dic objectForKey:key] intValue] color:[self randomColor] description:key]];
                }
                
            }
            
        }
        
        if ([array count] == 0) {
            [ProgressHUD showError:@"该区域没有用户！"];
        }
        //NSArray *items = [NSArray arrayWithArray:array];
        
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 100, 20, 200.0, 200.0) items:array];
        self.pieChart.descriptionTextColor = [UIColor whiteColor];
        self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
        self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
        self.pieChart.showAbsoluteValues = YES;
        self.pieChart.showOnlyValues = YES;
        [self.pieChart strokeChart];
        
        
        self.pieChart.legendStyle = PNLegendItemStyleStacked;
        self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        self.pieChart.delegate = self;
        
        UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
        [legend setFrame:CGRectMake(130, 223, legend.frame.size.width, legend.frame.size.height)];
        [self.view addSubview:legend];
        
        [self.view addSubview:self.pieChart];
        [self.dataTableView setHidden:YES];
//    }else if(self.type == 1){
//        self.barChart.backgroundColor = [UIColor clearColor];
//        self.barChart.yLabelFormatter = ^(CGFloat yValue){
//            CGFloat yValueParsed = yValue;
//            NSString * labelText = [NSString stringWithFormat:@"%0.f个",yValueParsed];
//            return labelText;
//        };
//        self.barChart.labelMarginTop = 5.0;
//        self.barChart.showChartBorder = YES;
//        NSMutableArray *deviceName = [[NSMutableArray alloc] init];
//        NSMutableArray *deviceNum = [[NSMutableArray alloc] init];
//        int max= 1;
//        for (NSDictionary * dic in self.deviceNumList) {
//            for(NSString *key in dic.allKeys){
//                [deviceName addObject:key];
//                [deviceNum addObject:[NSNumber numberWithInt:[[dic objectForKey:key] intValue]]];
//                if ([[dic objectForKey:key] intValue] > max) {
//                    max = [[dic objectForKey:key] intValue];
//                }
//            }
//            
//        }
//        
//        if (max > 9) {
//            max = 9;
//        }else if (max == 4){
//            max = 3;
//        }
//        self.barChart.yLabelSum = max;
//        [self.barChart setXLabels:deviceName];
//        [self.barChart setYValues:deviceNum];
//        [self.barChart setStrokeColors:@[PNGreen,PNGreen,PNRed,PNGreen,PNGreen]];
//        self.barChart.isGradientShow = NO;
//        self.barChart.isShowNumbers = YES;
//        
//        [self.barChart strokeChart];
//        
//        self.barChart.delegate = self;
//        
//    }else if (self.type == 2) {
//        
//        self.barChart.backgroundColor = [UIColor clearColor];
//        self.barChart.yLabelFormatter = ^(CGFloat yValue){
//            CGFloat yValueParsed = yValue;
//            NSString * labelText = [NSString stringWithFormat:@"%0.f次",yValueParsed];
//            return labelText;
//        };
//        self.barChart.labelMarginTop = 5.0;
//        self.barChart.showChartBorder = YES;
//        NSMutableArray *deviceName = [[NSMutableArray alloc] init];
//        NSMutableArray *deviceUseNum = [[NSMutableArray alloc] init];
//        int max= 1;
//        
//        for (NSDictionary * dic in self.deviceUseNumList) {
//            for(NSString *key in dic.allKeys){
//                [deviceName addObject:key];
//                [deviceUseNum addObject:[NSNumber numberWithInt:[[dic objectForKey:key] intValue]]];
//                if ([[dic objectForKey:key] intValue] > max) {
//                    max = [[dic objectForKey:key] intValue];
//                }
//            }
//            
//        }
//        if (max > 9) {
//            max = 9;
//        }else if (max == 4){
//            max = 3;
//        }
//        self.barChart.yLabelSum = max;
//        //self.barChart.showLabel = NO;
//        [self.barChart setXLabels:deviceName];
//        [self.barChart setYValues:deviceUseNum];
//        
//        [self.barChart setStrokeColors:@[PNGreen,PNGreen,PNRed,PNGreen,PNGreen]];
//        self.barChart.isGradientShow = YES;
//        self.barChart.isShowNumbers = YES;
//        
//        [self.barChart strokeChart];
//        
//        self.barChart.delegate = self;
//        
    }else{
        self.barChart.backgroundColor = [UIColor clearColor];
        self.barChart.labelMarginTop = 5.0;
        self.barChart.showChartBorder = YES;
        NSMutableArray *xAxis = [[NSMutableArray alloc] init];
        NSMutableArray *yAxis = [[NSMutableArray alloc] init];
        int max= 1;
        if (self.type == 1) {
            self.barChart.yLabelFormatter = ^(CGFloat yValue){
                CGFloat yValueParsed = yValue;
                NSString * labelText = [NSString stringWithFormat:@"%0.f个",yValueParsed];
                return labelText;
            };
            for (NSDictionary * dic in self.deviceNumList) {
                for(NSString *key in dic.allKeys){
                    [xAxis addObject:key];
                    [yAxis addObject:[NSNumber numberWithInt:[[dic objectForKey:key] intValue]]];
                    if ([[dic objectForKey:key] intValue] > max) {
                        max = [[dic objectForKey:key] intValue];
                    }
                }
                
            }
        }else if(self.type == 2){
            self.barChart.yLabelFormatter = ^(CGFloat yValue){
                CGFloat yValueParsed = yValue;
                NSString * labelText = [NSString stringWithFormat:@"%0.f次",yValueParsed];
                return labelText;
            };
            for (NSDictionary * dic in self.deviceUseNumList) {
                for(NSString *key in dic.allKeys){
                    [xAxis addObject:key];
                    [yAxis addObject:[NSNumber numberWithInt:[[dic objectForKey:key] intValue]]];
                    if ([[dic objectForKey:key] intValue] > max) {
                        max = [[dic objectForKey:key] intValue];
                    }
                }
                
            }

        }else if (self.type == 3) {
            self.barChart.yLabelFormatter = ^(CGFloat yValue){
                CGFloat yValueParsed = yValue;
                NSString * labelText = [NSString stringWithFormat:@"%0.f人",yValueParsed];
                return labelText;
            };
            for (NSDictionary * dic in self.userNumByDevice) {
                for(NSString *key in dic.allKeys){
                    [xAxis addObject:key];
                    [yAxis addObject:[NSNumber numberWithInt:[[dic objectForKey:key] intValue]]];
                    if ([[dic objectForKey:key] intValue] > max) {
                        max = [[dic objectForKey:key] intValue];
                    }
                }
                
            }
        }else if(self.type == 4){
            self.barChart.yLabelFormatter = ^(CGFloat yValue){
                CGFloat yValueParsed = yValue;
                NSString * labelText = [NSString stringWithFormat:@"%0.f次",yValueParsed];
                return labelText;
            };
            for (NSDictionary * dic in self.operateNumByMethod) {
                for(NSString *key in dic.allKeys){
                    [xAxis addObject:key];
                    [yAxis addObject:[NSNumber numberWithInt:[[dic objectForKey:key] intValue]]];
                    if ([[dic objectForKey:key] intValue] > max) {
                        max = [[dic objectForKey:key] intValue];
                    }
                }
                
            }
        }
        
        if (max > 9) {
            max = 9;
        }else if (max == 4){
            max = 3;
        }
        self.barChart.yLabelSum = max;
        //self.barChart.showLabel = NO;
        [self.barChart setXLabels:xAxis];
        [self.barChart setYValues:yAxis];
        
        [self.barChart setStrokeColors:@[PNGreen,PNGreen,PNRed,PNGreen,PNGreen]];
        self.barChart.isGradientShow = YES;
        self.barChart.isShowNumbers = YES;
        
        [self.barChart strokeChart];
        
        self.barChart.delegate = self;

    }
    
    [self.dataTableView registerNib:[UINib nibWithNibName:@"OEMSQueryTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}


- (void)userClickedOnBarAtIndex:(NSInteger)barIndex
{
    
    NSLog(@"Click on bar %@", @(barIndex));
    
    PNBar * bar = [self.barChart.bars objectAtIndex:barIndex];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.fromValue = @1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.toValue = @1.1;
    animation.duration = 0.2;
    animation.repeatCount = 0;
    animation.autoreverses = YES;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    [bar.layer addAnimation:animation forKey:@"Float"];
    
    self.statisticsData = [[NSMutableArray alloc] initWithObjects:@(barIndex),@(barIndex),@(barIndex),@(barIndex),@(barIndex),@(barIndex),@(barIndex),@(barIndex),@(barIndex),@(barIndex),nil];
    [self.dataTableView reloadData];
}

- (void)userClickedOnPieIndexItem:(NSInteger)pieIndex{
    //    DiffEnqueryDeviceTableViewController *enqueryVCtl = [[DiffEnqueryDeviceTableViewController alloc] initWithNibName:@"DiffEnqueryDeviceTableViewController" bundle:nil];
    //    NSLog(@"Click on pie %@", @(pieIndex));
    //
    //    if (pieIndex ==0) {
    //        [enqueryVCtl.navigationItem  setTitle:@"1街"];
    //    }else if (pieIndex ==1) {
    //        [enqueryVCtl.navigationItem  setTitle:@"2街"];
    //    }else if (pieIndex ==2) {
    //        [enqueryVCtl.navigationItem  setTitle:@"3街"];
    //    }
    //    [self.navigationController pushViewController:enqueryVCtl animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (OEMSQueryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OEMSQueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.name.text = [NSString stringWithFormat:@"数据%@",[self.statisticsData objectAtIndex:[indexPath row]]];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.statisticsData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataTableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
