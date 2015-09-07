//
//  UserInfo.h
//  SmartHomeFDP
//
//  Created by cisl on 15/8/28.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

+ (UserInfo *)instance;


@property(strong,nonatomic)NSString *username;
@property(strong,nonatomic)NSString *password;
@property(strong,nonatomic)NSString *address;
@property(strong,nonatomic)NSString *gender;
@property(strong,nonatomic)NSString *phone;
@property(nonatomic)NSInteger roleId;

-(BOOL) verifyInfo:(NSString*)verifyPassword;

@end
