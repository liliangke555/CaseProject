//
//  MDYLuckDrawlRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/30.
//

#import "MDYLuckDrawlRequest.h"
#import "MDYLuckListRequest.h"
@implementation MDYLuckDrawlRequest
- (NSString *)uri{
    return @"api/LuckDraw/luck_drawl";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYLuckListModel class];
}
@end
