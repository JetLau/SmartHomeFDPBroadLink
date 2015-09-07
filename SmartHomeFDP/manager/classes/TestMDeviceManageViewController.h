//
//  MDeviceManageViewController.h
//  SmartHomeFDP
//
//  Created by cisl on 15/8/26.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMenu.h"
@interface TestMDeviceManageViewController : UIViewController

@property (strong,nonatomic) NSArray *city;
@property (strong,nonatomic) NSArray *district;
@property (strong,nonatomic) NSArray *street;


@property (weak, nonatomic) IBOutlet UIButton *startDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;
@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UILabel *endDate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *dateSelectorBlock;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateSelector;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property int segmentIndex;
@property (nonatomic) NSMutableArray *cellsInfo;

@end
