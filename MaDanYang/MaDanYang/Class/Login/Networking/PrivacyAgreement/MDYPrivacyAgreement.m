//
//  MDYPrivacyAgreement.m
//  MaDanYang
//
//  Created by kckj on 2021/7/9.
//

#import "MDYPrivacyAgreement.h"
#import "MDYLoginAgreement.h"

@implementation MDYPrivacyAgreement
- (NSString *)uri{
    return @"api/Login/ys_xy";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass {
    return [MDYLoginAgreementModel class];
}
@end
