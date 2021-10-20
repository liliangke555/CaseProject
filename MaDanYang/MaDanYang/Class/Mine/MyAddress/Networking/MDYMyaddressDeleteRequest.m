//
//  MDYMyaddressDeleteRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/20.
//

#import "MDYMyaddressDeleteRequest.h"

@implementation MDYMyaddressDeleteRequest
- (NSString *)uri{
    return @"api/Address/del";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYMyaddressDeleteModel class];
}
@end

@implementation MDYMyaddressDeleteModel

@end
