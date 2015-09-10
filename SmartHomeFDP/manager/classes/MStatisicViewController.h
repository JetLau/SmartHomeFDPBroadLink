//
//  MStatisicViewController.h
//  SmartHomeFDP
//
//  Created by cisl on 15/8/27.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMenu.h"



@interface MStatisicViewController : UIViewController{
    
    __weak IBOutlet UISegmentedControl *addressSegment;
    __weak IBOutlet UITableView *addressTableView;
//__weak IBOutlet UISegmentedControl *enquiryTypeSegment;
}


@property (strong,nonatomic) NSMutableArray *city;
@property (strong,nonatomic) NSMutableArray *district;
@property (strong,nonatomic) NSMutableArray *street;

//当前要查询的address
@property (strong,nonatomic) NSString *address;

//当前查询类型
@property int SearchType;
@end
