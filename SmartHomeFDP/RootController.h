//
//  RootController.h
//
//  Created by cisl on 14-5-27.
//  Copyright (c) 2014年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootController : UIViewController

- (void)switchToLoginView;
- (void)switchToMainTabBarView;
- (void)switchToManagerView;
- (void)switchNextViewController:(NSString*)roleId;

@end
