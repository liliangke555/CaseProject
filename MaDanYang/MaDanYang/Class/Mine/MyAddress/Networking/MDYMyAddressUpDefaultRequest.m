//
//  MDYMyAddressUpDefaultRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/20.
//

#import "MDYMyAddressUpDefaultRequest.h"

@implementation MDYMyAddressUpDefaultRequest
- (NSString *)uri{
    return @"api/Address/up_default";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYMyAddressUpDefaultModel class];
}
@end

@implementation MDYMyAddressUpDefaultModel

@end
