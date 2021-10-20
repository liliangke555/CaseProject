//
//  MDYServiceMessageRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/12.
//

#import "MDYServiceMessageRequest.h"

@implementation MDYServiceMessageRequest
- (NSString *)uri{
    return @"api/CustomerService/customer";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYServiceMessageModel class];
}
@end

@implementation MDYServiceMessageModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uid":@"id"};
}
- (void)setTxt:(NSString *)txt {
    _txt = txt;
    CGFloat height = [txt getLabelHeightWithWidth:CK_WIDTH - 24 - 32 font:14];
    _messageHeagit += height;
}
- (void)setTxt_admin:(NSString *)txt_admin {
    _txt_admin = txt_admin;
    CGFloat height = [txt_admin getLabelHeightWithWidth:CK_WIDTH - 24 - 32 font:14];
    _messageHeagit += height;
}
@end
