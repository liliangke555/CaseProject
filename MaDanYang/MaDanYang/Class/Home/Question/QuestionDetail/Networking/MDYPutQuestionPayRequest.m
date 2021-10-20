//
//  MDYPutQuestionPayRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/27.
//

#import "MDYPutQuestionPayRequest.h"

@implementation MDYPutQuestionPayRequest
- (NSString *)uri{
    return @"api/PutQuestions/putQuestionsPay";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYPutQuestionPayModel class];
}
@end

@implementation MDYPutQuestionPayModel

@end
