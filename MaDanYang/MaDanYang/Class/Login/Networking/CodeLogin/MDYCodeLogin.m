//
//  MDYCodeLogin.m
//  MaDanYang
//
//  Created by kckj on 2021/7/9.
//

#import "MDYCodeLogin.h"
#import "MDYUserModel.h"
@implementation MDYCodeLogin
- (NSString *)uri{
    return @"api/Login/code_login";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYCodeLoginModel class];
}
@end

@implementation MDYCodeLoginModel

@end
