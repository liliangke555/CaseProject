//
//  MDYIntegralOrderPayRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/9.
//

#import "MDYIntegralOrderPayRequest.h"

@implementation MDYIntegralOrderPayRequest
- (NSString *)uri{
    return @"api/IntegralOrder/carorder";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYIntegralOrderPayModel class];
}
@end

@implementation MDYIntegralOrderPayModel

@end
