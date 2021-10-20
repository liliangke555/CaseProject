//
//  MDYOfflineAccountTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/26.
//

#import <UIKit/UIKit.h>
#import "MDYPlaceOrderRequest.h"
#import "MDYCoursePreviewOrderRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYOfflineAccountTableCell : UITableViewCell
@property (nonatomic, strong) MDYPlaceOrderPayOfflineModel *offlineModel;
@property (nonatomic, strong) MDYCurriculumPayOfflineModel *courseOfflineModel;
@end

NS_ASSUME_NONNULL_END
