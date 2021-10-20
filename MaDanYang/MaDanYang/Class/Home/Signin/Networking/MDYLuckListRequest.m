//
//  MDYLuckListRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/29.
//

#import "MDYLuckListRequest.h"

@implementation MDYLuckListRequest
- (NSString *)uri{
    return @"api/LuckDraw/luck_drawlist";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYLuckListModel class];
}
@end

@implementation MDYLuckListModel

@end
