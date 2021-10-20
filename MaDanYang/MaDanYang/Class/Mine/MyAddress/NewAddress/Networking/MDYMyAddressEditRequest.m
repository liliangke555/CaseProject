//
//  MDYMyAddressEditRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/20.
//

#import "MDYMyAddressEditRequest.h"

@implementation MDYMyAddressEditRequest
- (NSString *)uri{
    return @"api/Address/edit";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYMyAddressEditModel class];
}
@end

@implementation MDYMyAddressEditModel

@end
