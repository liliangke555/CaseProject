//
//  MDYPutQuestionRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/23.
//

#import "MDYPutQuestionRequest.h"

@implementation MDYPutQuestionRequest
- (NSString *)uri{
    return @"api/PutQuestions/addPutQuestions";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYPutQuestionModel class];
}
@end

@implementation MDYPutQuestionModel

@end
