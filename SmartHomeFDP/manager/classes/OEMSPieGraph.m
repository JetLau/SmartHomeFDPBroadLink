//
//  OEMSPieGraph.m
//  OfficeEMS_iPhone
//
//  Created by cisl on 14-6-20.
//  Copyright (c) 2014年 WangShengYin. All rights reserved.
//

#import "OEMSPieGraph.h"

#define PI 3.1415926

@implementation OEMSPieGraph

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
	{
	    
        self.imageName = @"";

        self.percentage = [[NSNumber alloc]init];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }
    return self;
}

- (void) showData {
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,width,height)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:self.imageName];
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(width/2, 0)];
    float angle = 2 * PI * [self.percentage floatValue];
    [path addArcWithCenter:CGPointMake(width/2, height/2) radius:height/2 startAngle:self.startAngle endAngle:self.startAngle + angle clockwise:YES];
    [path addLineToPoint:CGPointMake(width/2, height/2)];
    [path closePath];
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    imageView.layer.mask = shape;
    [self addSubview:imageView];
}

@end
