//
//  MDYMyAddressListRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/17.
//

#import "MDYMyAddressListRequest.h"

@implementation MDYMyAddressListRequest
- (NSString *)uri{
    return @"api/Address/list";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYMyAddressListModel class];
}
@end

@implementation MDYMyAddressListModel

@end
