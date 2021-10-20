//
//  MDYAddressAddRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/17.
//

#import "MDYAddressAddRequest.h"

@implementation MDYAddressAddRequest
- (NSString *)uri{
    return @"api/Address/add";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYAddressAddModel class];
}
@end

@implementation MDYAddressAddModel

@end
