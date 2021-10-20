//
//  MDYVerificationRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/10.
//

#import "MDYVerificationRequest.h"

@implementation MDYVerificationRequest
- (NSString *)uri{
    return @"api/User/verification";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYVerificationModel class];
}
@end

@implementation MDYVerificationModel

@end
