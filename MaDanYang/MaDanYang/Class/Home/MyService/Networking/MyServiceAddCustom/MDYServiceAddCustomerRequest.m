//
//  MDYServiceAddCustomerRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/12.
//

#import "MDYServiceAddCustomerRequest.h"

@implementation MDYServiceAddCustomerRequest
- (NSString *)uri{
    return @"api/CustomerService/addcustomer";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYServiceAddCustomerModel class];
}
@end

@implementation MDYServiceAddCustomerModel

@end
