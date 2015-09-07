//
//  UserDetailViewController.h
//  ShareBarrierFree
//
//  Created by cisl on 15-6-30.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
@interface UserDetailViewController : UIViewController{

    __weak IBOutlet UITextField *username;
    __weak IBOutlet UITextField *password;
    __weak IBOutlet UITextField *phone;
    __weak IBOutlet UIButton *changeBtn;
    __weak IBOutlet UISegmentedControl *genderSegment;
}
@property (strong, nonatomic) IBOutlet UIView *infoView;

@property(strong,nonatomic)UserInfo *user;
- (IBAction)changeBtnClicked:(UIButton *)sender;
- (IBAction)moveInfoView:(UITextField *)sender;

@end
