//
//  HomeViewController.h
//  SmartHomeFDP
//
//  Created by cisl on 14-11-3.
//  Copyright (c) 2014年 eddie. All rights reserved.
//


#import <UIKit/UIKit.h>
@class RMDeviceManager;
@class TCPDeviceManager;
@class ScenePlistManager;
@interface HomeViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property(strong,nonatomic)IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *sceneView;

@property(strong,nonatomic)RMDeviceManager *rmDeviceManager;
@property(strong,nonatomic)TCPDeviceManager *tcpDeviceManager;
@property(strong,nonatomic)ScenePlistManager *scenePlistmanager;
@property(strong,nonatomic)NSArray *rmDeviceArray;
@property(strong,nonatomic)NSArray *tcpDeviceArray;
@property(strong,nonatomic)NSArray *sceneArray;

@end
