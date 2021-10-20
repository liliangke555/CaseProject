//
//  MDYBindWechatRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/27.
//

#import "MDYBindWechatRequest.h"

@implementation MDYBindWechatRequest
- (NSString *)uri{
    return @"api/Login/be_weixin";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYBindWechatModel class];
}
@end

@implementation MDYBindWechatModel

@end
