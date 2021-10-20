//
//  MDYLuckDrawListRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/9/14.
//

#import "MDYLuckDrawListRequest.h"

@implementation MDYLuckDrawListRequest
- (NSString *)uri{
    return @"api/LuckDraw/luck_drawlistlist";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYLuckDrawListModel class];
}
@end

@implementation MDYLuckDrawListModel

@end
