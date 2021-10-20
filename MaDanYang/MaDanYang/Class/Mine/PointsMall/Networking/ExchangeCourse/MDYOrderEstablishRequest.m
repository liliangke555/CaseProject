//
//  MDYOrderEstablishRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/9.
//

#import "MDYOrderEstablishRequest.h"

@implementation MDYOrderEstablishRequest
- (NSString *)uri{
    return @"api/IntegralOrder/orderEstablish";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYOrderEstablishModel class];
}
@end

@implementation MDYOrderEstablishModel

@end
