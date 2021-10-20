//
//  MDYAliPayRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/28.
//

#import "MDYAliPayRequest.h"

@implementation MDYAliPayRequest
- (NSString *)uri{
    return @"api/AliPay/aliApp";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYAliPayModel class];
}
@end

@implementation MDYAliPayModel

@end
