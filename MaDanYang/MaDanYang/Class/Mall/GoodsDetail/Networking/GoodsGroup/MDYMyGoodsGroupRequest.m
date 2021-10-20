//
//  MDYMyGoodsGroupRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/12.
//

#import "MDYMyGoodsGroupRequest.h"

@implementation MDYMyGoodsGroupRequest
- (NSString *)uri{
    return @"api/MyGrooup/goods_group";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYMyGoodsGroupListModel class];
}
@end

@implementation MDYMyGoodsGroupModel

@end

@implementation MDYMyGoodsGroupListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"data" : [MDYMyGoodsGroupModel class]};
}
@end


