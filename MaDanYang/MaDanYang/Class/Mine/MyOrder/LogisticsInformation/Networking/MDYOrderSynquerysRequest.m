//
//  MDYOrderSynquerysRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/23.
//

#import "MDYOrderSynquerysRequest.h"

@implementation MDYOrderSynquerysRequest
- (NSString *)uri{
    return @"api/MyOrder/synquerys";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYOrderSynquerysModel class];
}
@end

@implementation MDYOrderSynquerysRouteModel


@end

@implementation MDYOrderSynquerysModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"data" : [MDYOrderSynquerysRouteModel class]};
}
@end
