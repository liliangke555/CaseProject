//
//  MDYServiceMessageReadRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/12.
//

#import "MDYServiceMessageReadRequest.h"

@implementation MDYServiceMessageReadRequest
- (NSString *)uri{
    return @"api/CustomerService/is_show";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYServiceMessageReadModel class];
}
@end

@implementation MDYServiceMessageReadModel

@end
