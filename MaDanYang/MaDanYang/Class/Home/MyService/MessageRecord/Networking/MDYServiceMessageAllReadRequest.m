//
//  MDYServiceMessageAllReadRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/12.
//

#import "MDYServiceMessageAllReadRequest.h"

@implementation MDYServiceMessageAllReadRequest
- (NSString *)uri{
    return @"api/CustomerService/is_showAll";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYServiceMessageAllReadModel class];
}
@end

@implementation MDYServiceMessageAllReadModel

@end
