//
//  MDeviceManageViewController.h
//  SmartHomeFDP
//
//  Created by cisl on 15/8/26.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMenu.h"

@interface MDeviceManageViewController : UIViewController{

    __weak IBOutlet UISegmentedControl *addressSegment;
    __weak IBOutlet UITableView *addressTableView;
    __weak IBOutlet UISegmentedControl *enquiryTypeSegment;
}

@property (strong,nonatomic) NSMutableArray *city;
@property (strong,nonatomic) NSMutableArray *district;
@property (strong,nonatomic) NSMutableArray *street;

//当前要查询的address
@property (strong,nonatomic) NSString *address;




@end
