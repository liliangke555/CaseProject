//
//  MDYTypeInquestionRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/23.
//

#import "MDYTypeInquestionRequest.h"

@implementation MDYTypeInquestionRequest
- (NSString *)uri{
    return @"api/PutQuestions/typePutQuestions";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYTypeInquestionModel class];
}
@end

@implementation MDYTypeInquestionModel

@end
