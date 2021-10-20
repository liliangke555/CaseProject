//
//  MDYServiceCustomListRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/12.
//

#import "MDYServiceCustomListRequest.h"

@implementation MDYServiceCustomListRequest
- (NSString *)uri{
    return @"api/CustomerService/customerList";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYServiceCustomListModel class];
}
@end

@implementation MDYServiceCustomListModel

@end
