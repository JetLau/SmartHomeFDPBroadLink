//
//  AddSceneViewController.h
//  SmartHomeFDP
//
//  Created by cisl on 15/10/29.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
//添加或修改场景内容
@interface AddSceneViewController : UIViewController

@property (nonatomic, assign) int sceneNum;
@property (nonatomic, strong) NSString * style;
@property (nonatomic, strong) NSMutableArray *sceneBtnArray;
@property (nonatomic, strong) NSString *sceneName;
@property (nonatomic, strong) NSString *sceneVoice;
@property (weak, nonatomic) IBOutlet UITextField *sceneNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *voiceTextField;
@property (weak, nonatomic) IBOutlet UITableView *btnTableView;
- (IBAction)addCtrlCommand:(UIButton *)sender;

@end
