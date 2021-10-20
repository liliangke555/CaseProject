//
//  MDYQuestionTypeRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/23.
//

#import "MDYQuestionTypeRequest.h"

@implementation MDYQuestionTypeRequest
- (NSString *)uri{
    return @"api/PutQuestions/questionsType";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYQuestionTypeModel class];
}
@end

@implementation MDYQuestionTypeModel

@end
