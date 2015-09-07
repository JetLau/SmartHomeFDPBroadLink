//
//  OEMSPieGraph.h
//  OfficeEMS_iPhone
//
//  Created by cisl on 14-6-20.
//  Copyright (c) 2014年 WangShengYin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OEMSPieGraph : UIControl

@property (nonatomic) NSString *imageName;
@property (nonatomic) NSNumber *percentage;

@property (nonatomic) float startAngle; //clockwise
- (void) showData;

@end
