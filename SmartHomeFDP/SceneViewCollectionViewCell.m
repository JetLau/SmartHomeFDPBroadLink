//
//  SceneViewCollectionViewCell.m
//  SmartHomeFDP
//
//  Created by cisl on 15/10/29.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import "SceneViewCollectionViewCell.h"

@implementation SceneViewCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SceneViewCollectionViewCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (IBAction)sceneCollectionLongPress:(UILongPressGestureRecognizer *)sender {
    
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        if ([sender.view isKindOfClass:[self class]]) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"场景设置" message:@"删除或重新编辑场景？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"编辑", @"删除",nil];
            [alert show];
            
        }
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // NSLog(@"buttonIndex = %d", buttonIndex);
    if(buttonIndex==1)
    {
        NSLog(@"编辑");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EditSceneNotification" object:self userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"edit",@"mode",[NSNumber numberWithInt:self.collectionViewId],@"collectionViewId",nil]];
    } else if(buttonIndex==2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EditSceneNotification" object:self userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"delete",@"mode",[NSNumber numberWithInt:self.collectionViewId],@"collectionViewId",nil]];
        NSLog(@"删除");
    }
}


@end
