//
//  UserInfo.m
//  SmartHomeFDP
//
//  Created by cisl on 15/8/28.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import "UserInfo.h"
#import "ProgressHUD.h"

@implementation UserInfo
+ (UserInfo *)instance
{
    static UserInfo *userInfo;
    
    @synchronized(self)
    {
        if (!userInfo)
        {
            userInfo = [[UserInfo alloc] init];
        }
    }
    return userInfo;
}

-(BOOL) verifyInfo:(NSString*)verifyPassword{
    if ([_username isEqualToString:@""]) {
        [ProgressHUD showError:@"用户名不能为空！"];
        return FALSE;
    }
    if ([_password isEqualToString:@""]) {
        [ProgressHUD showError:@"密码不能为空！"];
        return FALSE;
    }
    if ([verifyPassword isEqualToString:@""]) {
        [ProgressHUD showError:@"再次输入密码不能为空！"];
        return FALSE;
    }
    //    if ([_address isEqualToString:@""]) {
    //        [ProgressHUD showError:@"地址不能为空！"];
    //        return FALSE;
    //    }
    //    if ([_email isEqualToString:@""]) {
    //        [ProgressHUD showError:@"邮箱不能为空！"];
    //        return FALSE;
    //    }
    //    if ([_phone isEqualToString:@""]) {
    //        [ProgressHUD showError:@"手机号不能为空！"];
    //        return FALSE;
    //    }
    if(![_password isEqualToString:verifyPassword]){
        [ProgressHUD showError:@"两次输入密码不一致，请重新输入！"];
        return FALSE;
    }
    if (_phone == nil || [_phone isEqualToString:@""]) {
        [ProgressHUD showError:@"请填写电话！"];
        return FALSE;
    }
    if (_address == nil) {
        [ProgressHUD showError:@"请选择地址！"];
        return FALSE;
    }

    if (_gender == nil || [_gender isEqualToString:@""]) {
        [ProgressHUD showError:@"请选择性别！"];
        return FALSE;
    }
   
    
    
    return TRUE;
}
@end
