//
//  MDYUserInfoRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/10.
//

#import "MDYUserInfoRequest.h"
#import "MDYUserModel.h"
@implementation MDYUserInfoRequest
- (NSString *)uri{
    return @"api/User/userinfo";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYUserModel class];
}
@end
