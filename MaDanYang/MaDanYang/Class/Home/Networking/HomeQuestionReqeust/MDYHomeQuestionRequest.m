//
//  MDYHomeQuestionRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/23.
//

#import "MDYHomeQuestionRequest.h"

@implementation MDYHomeQuestionRequest
- (NSString *)uri{
    return @"api/PutQuestions/indexPutQuestions";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYHomeQuestionModel class];
}
@end

@implementation MDYHomeQuestionModel

@end
