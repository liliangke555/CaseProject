//
//  MDYSigninRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/24.
//

#import "MDYSigninRequest.h"

@implementation MDYSigninRequest
- (NSString *)uri{
    return @"api/SignIn/sign_in";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYSigninModel class];
}
@end

@implementation MDYSigninModel

@end
