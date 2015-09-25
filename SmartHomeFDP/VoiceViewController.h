//
//  VoiceViewController.h
//  SmartHomeFDP
//
//  Created by cisl on 14-11-3.
//  Copyright (c) 2014年 eddie. All rights reserved.
//


#import <UIKit/UIKit.h>
@class VoiceManager;

@interface VoiceViewController : UIViewController

@property(nonatomic,strong)VoiceManager *voiceManager;

@property(nonatomic,strong)IBOutlet UIImageView *voiceLightImage;
@property(nonatomic,strong)IBOutlet UIImageView *voiceImage;
@property(nonatomic,strong)IBOutlet UIButton *voiceButton;
@property(nonatomic,assign)BOOL voiceRecognizering;

-(IBAction)voiceButtonTouchDown:(id)sender;
- (void)getVoiceRecognizerResult:(NSString *)resultStr;
- (IBAction)enquiryVoiceList:(UIButton *)sender;

@end
