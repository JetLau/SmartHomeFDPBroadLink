//
//  ScenePlistManager.h
//  SmartHomeFDP
//
//  Created by cisl on 15/10/29.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScenePlistManager : NSObject
@property(strong,nonatomic)NSString *path;
@property(strong,nonatomic)NSString *docPath;
@property(strong,nonatomic)NSString *fileName;

@property(strong,nonatomic)NSMutableArray *SceneArray;

+(instancetype) createScenePlistManager;

-(int)addNewSceneIntoFile:(NSString *)name andBtnArray:(NSMutableArray*)btnArray andVoice:(NSString*) voice;
-(BOOL)deleteOneScene:(int)index;
-(BOOL)changeSceneInfo:(NSString *)name andBtnArray:(NSMutableArray*)btnArray andVoice:(NSString*) voice andSceneId:(int)sceneId;
-(NSMutableArray*) getSceneVoiceList;
@end
