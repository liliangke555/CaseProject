//
//  MDYApplyGuidanceController.h
//  MaDanYang
//
//  Created by kckj on 2021/6/9.
//

#import "CKBaseViewController.h"
#import "MDYMyGuidanceDetailRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYApplyGuidanceController : CKBaseViewController
@property (nonatomic, assign) NSInteger type;// 0 == 默认无状态。1==待审核  2==待上门 3==完成；
@property (nonatomic, strong) MDYMyGuidanceDetailModel *guidanceModel;
@end

NS_ASSUME_NONNULL_END
