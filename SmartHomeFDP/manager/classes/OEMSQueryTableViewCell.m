//
//  OEMSQueryTableViewCell.m
//  OfficeEMS_iPhone
//
//  Created by cisl on 14-6-17.
//  Copyright (c) 2014年 WangShengYin. All rights reserved.
//

#import "OEMSQueryTableViewCell.h"

@implementation OEMSQueryTableViewCell

- (void)awakeFromNib
{
    self.ID = [[NSString alloc]init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
