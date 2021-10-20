//
//  MDYCoursePreviewOrderRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/19.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYCoursePreviewOrderRequest : MDYBaseRequest
CopyStringProperty curriculum_id;
CopyStringProperty pay_type;
@end

@interface MDYCurriculumDetailModel : NSObject
CopyStringProperty curriculum_id;
CopyStringProperty c_name;
CopyStringProperty img;
CopyStringProperty price;
CopyStringProperty integral;
@end

@interface MDYCurriculumPayOfflineModel : NSObject
CopyStringProperty bank_of_deposit;
CopyStringProperty account_name;
CopyStringProperty account;
@end

@interface MDYCoursePreviewOrderModel : NSObject
StrongProperty MDYCurriculumDetailModel *curriculum;
StrongProperty MDYCurriculumPayOfflineModel *pay_offline;
CopyStringProperty pay_price;
@end

NS_ASSUME_NONNULL_END
