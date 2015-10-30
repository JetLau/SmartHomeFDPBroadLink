//
//  AddOrChangeCustomBtnViewController.h
//  NewProject
//
//  Created by eddie on 14-9-4.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLDeviceInfo.h"
#import "RMDeviceManager.h"

@interface AddOrChangeCustomBtnViewController : UIViewController
@property (nonatomic, strong) BLDeviceInfo * info;
@property (nonatomic, assign) int rmDeviceIndex;
@property (nonatomic, assign) int btnId;
@property (nonatomic, strong) NSString * style;
@property(strong,nonatomic)RMDeviceManager *rmDeviceManager;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *voiceTextField;
@property (strong, nonatomic) IBOutlet UIView *loginView;

- (IBAction)studyBtnClicked:(UIButton *)sender;
- (IBAction)saveNameOrVoiceBtnClicked:(UIButton *)sender;
- (IBAction)moveView:(id)sender;

@end
