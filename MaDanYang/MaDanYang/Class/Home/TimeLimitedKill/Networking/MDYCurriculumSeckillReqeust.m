//
//  MDYCurriculumSeckillReqeust.m
//  MaDanYang
//
//  Created by kckj on 2021/7/13.
//

#import "MDYCurriculumSeckillReqeust.h"

@implementation MDYCurriculumSeckillReqeust
- (NSString *)uri{
    return @"api/Seckill/curriculum_seckill";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYCurriculumSeckillModel class];
}
@end

@implementation MDYCurriculumSeckillModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uid":@"id"};
}
@end
