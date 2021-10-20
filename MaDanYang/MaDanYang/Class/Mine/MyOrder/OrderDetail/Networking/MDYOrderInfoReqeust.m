//
//  MDYOrderInfoReqeust.m
//  MaDanYang
//
//  Created by kckj on 2021/7/30.
//

#import "MDYOrderInfoReqeust.h"

@implementation MDYOrderInfoReqeust
- (NSString *)uri{
    return @"api/MyOrder/orderinfo";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYOrderInfoModel class];
}
@end

@implementation MDYOrderInfoModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"order_goods" : [MDYOrderInfoGoodsModel class],
              @"pintuanGroup" : [MDYGroupOrderManModel class]
    };
}
@end

@implementation MDYOrderInfoAddressModel

@end
@implementation MDYOrderInfoGoodsModel

@end
@implementation MDYGroupOrderManModel

@end
