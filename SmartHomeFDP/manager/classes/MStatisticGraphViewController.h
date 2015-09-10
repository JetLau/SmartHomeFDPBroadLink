//
//  MStatisticGraphViewController.h
//  SmartHomeFDP
//
//  Created by cisl on 15/8/28.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"
@interface MStatisticGraphViewController : UIViewController<PNChartDelegate>

@property int type;
@property (strong,nonatomic) NSMutableArray *statisticsData;

//@property (nonatomic) PNBarChart * barChart;
@property (nonatomic) PNCircleChart * circleChart;
@property (nonatomic) PNPieChart *pieChart;

@property (weak, nonatomic) IBOutlet PNBarChart *barChart;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@property (strong,nonatomic) NSMutableArray *userNumList;
@property (strong,nonatomic) NSMutableArray *deviceNumList;
@property (strong,nonatomic) NSMutableArray *deviceUseNumList;
@property (strong,nonatomic) NSMutableArray *userNumByDevice;
@property (strong,nonatomic) NSMutableArray *operateNumByMethod;

@end
