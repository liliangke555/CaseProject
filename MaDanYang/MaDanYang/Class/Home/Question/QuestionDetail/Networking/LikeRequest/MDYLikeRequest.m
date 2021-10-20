//
//  MDYLikeRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/20.
//

#import "MDYLikeRequest.h"

@implementation MDYLikeRequest
- (NSString *)uri{
    return @"api/Wechat/thumbsUp";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYLikeModel class];
}
@end

@implementation MDYLikeModel

@end
