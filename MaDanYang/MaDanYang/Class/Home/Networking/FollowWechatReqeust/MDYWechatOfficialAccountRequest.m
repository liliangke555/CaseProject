//
//  MDYWechatOfficialAccountRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/19.
//

#import "MDYWechatOfficialAccountRequest.h"

@implementation MDYWechatOfficialAccountRequest
- (NSString *)uri{
    return @"api/Wechat/gzgzh";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYWechatOfficialAccountModel class];
}
@end

@implementation MDYWechatOfficialAccountModel

@end
