//
//  OEMSQueryTableViewCell.h
//  OfficeEMS_iPhone
//
//  Created by cisl on 14-6-17.
//  Copyright (c) 2014年 WangShengYin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OEMSQueryTableViewCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *tick;

@property (nonatomic) NSString *ID;

@end
