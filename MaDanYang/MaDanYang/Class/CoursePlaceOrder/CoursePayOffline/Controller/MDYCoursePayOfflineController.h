//
//  MDYCoursePayOfflineController.h
//  MaDanYang
//
//  Created by kckj on 2021/8/19.
//

#import "CKBaseViewController.h"
#import "MDYCoursePreviewOrderRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYCoursePayOfflineController : CKBaseViewController
@property (nonatomic, strong) MDYCoursePreviewOrderModel *orderModel;
@property (nonatomic, copy) NSString *orderNum;
@property (nonatomic, copy) NSString *timeString;
@end

NS_ASSUME_NONNULL_END
