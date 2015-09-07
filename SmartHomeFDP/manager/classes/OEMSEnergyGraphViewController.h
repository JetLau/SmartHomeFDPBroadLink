//
//  OEMSEnergyGraphViewController.h
//  OfficeEMS_iPhone
//
//  Created by cisl on 14-6-19.
//  Copyright (c) 2014年 WangShengYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OEMSPieGraph.h"
#import "FXLabel.h"

@interface OEMSEnergyGraphViewController : UIViewController


@property (strong,nonatomic) NSMutableArray *dates;


@property (nonatomic) int type; //0:area & departemnt 1:device

@property (strong, nonatomic) IBOutletCollection(OEMSPieGraph) NSArray *pieGraphs;
@property (strong, nonatomic) IBOutletCollection(FXLabel) NSArray *percentages;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *upView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *deviceNames;


@property (strong, nonatomic) IBOutlet UIView *mainView;


@end
