//
//  MDYMyAppointmentListController.h
//  MaDanYang
//
//  Created by kckj on 2021/6/19.
//

#import "CKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYMyAppointmentListController : CKBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
