//
//  SceneViewCollectionViewCell.h
//  SmartHomeFDP
//
//  Created by cisl on 15/10/29.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SceneViewCollectionViewCell : UICollectionViewCell
@property(strong,nonatomic)IBOutlet UIImageView *imageView;
@property(strong,nonatomic)IBOutlet UILabel *label;
@property int collectionViewId;
- (IBAction)sceneCollectionLongPress:(UILongPressGestureRecognizer *)sender;
@end
