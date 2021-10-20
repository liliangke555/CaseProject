//
//  MDYCoursePreviewOrderRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/19.
//

#import "MDYCoursePreviewOrderRequest.h"

@implementation MDYCoursePreviewOrderRequest
- (NSString *)uri{
    return @"api/CurriculumOrder/previewOrder";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYCoursePreviewOrderModel class];
}
@end

@implementation MDYCurriculumDetailModel
@end
@implementation MDYCurriculumPayOfflineModel
@end
@implementation MDYCoursePreviewOrderModel
@end
