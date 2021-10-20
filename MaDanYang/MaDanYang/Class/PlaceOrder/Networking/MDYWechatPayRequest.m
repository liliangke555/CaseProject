//
//  MDYWechatPayRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/28.
//

#import "MDYWechatPayRequest.h"

@implementation MDYWechatPayRequest
- (NSString *)uri{
    return @"api/WechatPay/weChatApp";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYWechatPayModel class];
}
@end

@implementation MDYWechatPayModel

@end
