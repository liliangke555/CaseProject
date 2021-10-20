//
//  MDYLoginAgreement.m
//  MaDanYang
//
//  Created by kckj on 2021/7/9.
//

#import "MDYLoginAgreement.h"

@implementation MDYLoginAgreement
- (NSString *)uri{
    return @"api/Login/login_xy";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass {
    return [MDYLoginAgreementModel class];
}
@end

@implementation MDYLoginAgreementModel

@end
