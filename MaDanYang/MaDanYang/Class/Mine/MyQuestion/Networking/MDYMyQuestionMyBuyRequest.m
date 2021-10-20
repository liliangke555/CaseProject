//
//  MDYMyQuestionMyBuyRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/24.
//

#import "MDYMyQuestionMyBuyRequest.h"

@implementation MDYMyQuestionMyBuyRequest
- (NSString *)uri{
    return @"api/PutQuestions/myPayQuestions";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYMyQuestionMyBuyModel class];
}
@end
@implementation MDYMyQuestionMyBuyModel

@end
