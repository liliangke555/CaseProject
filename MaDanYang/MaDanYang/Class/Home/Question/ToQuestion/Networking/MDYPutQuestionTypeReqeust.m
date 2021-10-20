//
//  MDYPutQuestionTypeReqeust.m
//  MaDanYang
//
//  Created by kckj on 2021/7/24.
//

#import "MDYPutQuestionTypeReqeust.h"

@implementation MDYPutQuestionTypeReqeust
- (NSString *)uri{
    return @"api/PutQuestions/putQuestionsType";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYPutQuestionTypeModel class];
}
@end

@implementation MDYPutQuestionTypeModel

@end
