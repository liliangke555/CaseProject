//
//  MDYSendCode.m
//  MaDanYang
//
//  Created by kckj on 2021/7/9.
//

#import "MDYSendCode.h"

@implementation MDYSendCode
- (NSString *)uri{
    return @"api/Verification/nancuang";
}
- (NSString *)requestMethod
{
    return @"POST";
}
//- (Class)responseDataClass{
//    return [MDYUserModel class];
//}
@end
