//
//  MDYWechatLogin.m
//  MaDanYang
//
//  Created by kckj on 2021/7/8.
//

#import "MDYWechatLogin.h"
#import "MDYUserModel.h"
@implementation MDYWechatLogin
- (NSString *)uri{
    return @"api/Login/wxapp_login";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYWechatLoginModel class];
}
@end

@implementation MDYWechatLoginModel

@end
