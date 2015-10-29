//
//  LJCommonCell.m
//  NewProject
//
//  Created by eddie on 14-9-2.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "LJCommonCell.h"
//#import "LJCommonItem.h"
#import "LJCommonArrowItem.h"
#import "LJCommonSwitchItem.h"
#import "LJCommonLabelItem.h"
#import "LJBadgeView.h"

@interface LJCommonCell ()

@property(nonatomic, strong)UISwitch *rightSwitch;
@property(nonatomic, strong)UIImageView *rightArrow;
@property(nonatomic, strong)UILabel *rightLabel;
@property(nonatomic, strong)UIImageView *rightCheckmark;
@property(nonatomic, strong)LJBadgeView *badgeValue;

@end

@implementation LJCommonCell

#pragma marks -懒加载(get方法)
-(UIImageView *)rightArrow
{
    if(_rightArrow != nil)
    {
        _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
    }
    NSLog(@"right arrow");
    return _rightArrow;
}

-(UISwitch *)rightSwitch
{
    if (_rightSwitch == nil) {
        _rightSwitch = [[UISwitch alloc] init];
    }
    return _rightSwitch;
}

-(UILabel *)rightLabel
{
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = [UIColor lightGrayColor];
        _rightLabel.font = [UIFont systemFontOfSize:12];
    }
    return  _rightLabel;
}

-(UIImageView *)rightCheckmark
{
    if(_rightCheckmark == nil)
    {
        _rightCheckmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_checkmark"]];
    }
    
    return _rightCheckmark;
}

-(LJBadgeView *)badgeValue
{
    if (_badgeValue == nil) {
        _badgeValue = [[LJBadgeView alloc] init];
    }
    
    return _badgeValue;
}
//初始化类方法
+(instancetype) cellWithTableView:(UITableView *) tableView
{
    static NSString *ID = @"ID";
    LJCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[LJCommonCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        //cell = [[LJCommonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    //最右多一个‘>’标示
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        //设置标题和子标题文字
        self.textLabel.font = [UIFont boldSystemFontOfSize:15];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
    }
    
    //self.backgroundColor = [UIColor clearColor];
    return self;
}

#pragma mark-setter
-(void)setItem:(LJCommonItem *)item
{
    _item = item;
    //设置基本数据
    if (item.icon != nil) {
        self.imageView.image = [UIImage imageNamed:item.icon];
    }
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subtitle;
    
    //设置右边显示内容
//    if([item isKindOfClass:[LJCommonArrowItem class]])
//    {
//        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
//    }else if([item isKindOfClass:[LJCommonSwitchItem class]])
//    {
//        self.accessoryView=[[UISwitch alloc] init];
//    }else
//    {
//        self.accessoryView = nil;
//    }
    if (item.badgeValue) {
        self.badgeValue.badgeView=item.badgeValue;
        self.accessoryView = self.badgeValue;
    }else if([item isKindOfClass:[LJCommonArrowItem class]])//如果是箭头
    {
        self.accessoryView = self.rightArrow;
    }else if([item isKindOfClass:[LJCommonSwitchItem class]])//如果是开关
    {
        self.accessoryView=self.rightSwitch;
    }else if ([item isKindOfClass:[LJCommonLabelItem class]])//如果右边显示文字
    {
        //设置文字
        LJCommonLabelItem *labelItem = (LJCommonLabelItem *) item;
        self.rightLabel.text = labelItem.text;
        //根据文字计算尺寸
        //CGSize size = [labelItem.text sizeWithFont:self.rightLabel.font];
        CGSize size = [labelItem.text sizeWithAttributes:@{NSFontAttributeName:self.rightLabel.font}];
        self.rightLabel.frame =CGRectMake(0, 0, size.width, size.height);
        self.accessoryView=self.rightLabel;
    }else
    {
        self.accessoryView = nil;
    }

}

#pragma mark -调整子控件位置
-(void) layoutSubviews
{
    [super layoutSubviews];
    //调整子控件的x值
    //self.detailTextLabel.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame) + 10, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height) ;
}

-(void) setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows
{
//    UIImageView *bgv = [[UIImageView alloc] init];
//    UIImageView *sgv = [[UIImageView alloc] init];
//    
//    if (rows==1) {
//        bgv
//    }
}

@end
